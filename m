Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBSDuIMJ183776 for <xfs@oss.sgi.com>; Wed, 28 Dec 2011 07:56:18 -0600
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id VxAgfeclWSRtRrZD for
	<xfs@oss.sgi.com>; Wed, 28 Dec 2011 05:56:15 -0800 (PST)
Message-ID: <4EFB1FEC.1050800@oracle.com>
Date: Wed, 28 Dec 2011 21:55:56 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Another SEEK_DATA/SEEK_HOLE  tester
Reply-To: jeff.liu@oracle.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, Chris Mason <chris.mason@oracle.com>

A test tool to verify larger files with more extents(it can be used, but still need improvements).

Usage:
Create a 121M file in preallocate mode(-P), fallocate(2) offset start from 0(-O); seek to 100 bytes(-s) for the first write,
skip 4096 bytes(-k) for next write, fill up 8192bytes(-l) for each writing.
./seek_copy_test -P -O 1 -L 121M -s 100 -k 4096 -l 8192 /xfs/st /xfs/st_cp 

Similar to above, but with '-S' option, call sync_file_range(2) to flush the dirty pages, this can produce writeback data buffers.
./seek_copy_test -P -O 1 -L 121M -s 100 -k 4096 -l 8192 -S /xfs/st /xfs/st_cp 

After copy done, in xfstests test script, we can ensure there is no data loss through cmp(1) to checking source and dest files
byte by byte, and need to compare the file length.

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdarg.h>
#include <string.h>
#include <getopt.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <fcntl.h>
#include <unistd.h>
#include <ctype.h>
#include <errno.h>
#include <limits.h>
#include <assert.h>
#include <linux/falloc.h>

#ifndef SEEK_DATA
#define SEEK_DATA	3
#define SEEK_HOLE	4
#endif

#define BUF_SIZE	4096

/* Below check stuff copied from Coreutils */
/* True if the arithmetic type T is signed */
#define TYPE_SIGNED(t) (! ((t)0 < (t)-1))
#define TYPE_MAXIMUM(t)								\
	((t) (! TYPE_SIGNED(t)							\
		? (t) -1							\
		: ((((t) 1 << (sizeof(t) * CHAR_BIT - 2)) - 1) * 2 + 1)))

#ifndef OFF_T_MAX
# define OFF_T_MAX TYPE_MAXIMUM (off_t)
#endif

void
error(const char *fmt, ...)
{
	char buf[256];
	va_list args;
	va_start(args, fmt);
	vsprintf(buf, fmt, args);
	va_end(args);

	fprintf(stderr, "ERROR: %s\n", buf);
}

/* copied from btrfs progs */
uint64_t
parse_size(char *s)
{
	int len = strlen(s);
	char c;
	uint64_t mult = 1;

	if (!isdigit(s[len - 1])) {
		c = tolower(s[len - 1]);
		switch (c) {
		case 'g':
			mult <<= 30;
			break;
		case 'm':
			mult <<= 20;
			break;
		case 'k':
			mult <<= 10;
			break;
		case 'b':
			break;
		default:
			error("unknown size descriptor %c", c);
			exit(1);
		}
		s[len - 1] = '\0';
	}

	printf("s=%s, mult=%llu\n", s, mult);
	return atoll(s) * mult;
}

size_t
full_write(int fd, const void *buf, size_t count)
{
	size_t total = 0;
	const char *ptr = (const char *) buf;

	while (count > 0) {
		size_t n = write(fd, ptr, count);
		if (n == (size_t) -1)
			break;
		if (n == 0)
			break;

		total += n;
		ptr += n;
		count -= n;
	}

	return total;
}

size_t
get_block_size(int fd)
{
	struct stat st;
	return (fstat(fd, &st) < 0) ? -1 : st.st_blksize;
}

/*
 * Check if the underlaying file system support SEEK_HOLE/SEEK_DATA
 * feature or not.
 */
int
support_seek_hole(int fd)
{
	if (lseek(fd, 0, SEEK_HOLE) < 0) {
		if (errno == EINVAL || errno == ENOTSUP) {
			error("SEEK_HOLE does not support");
			return 0;
		}

		error("pre-checking SEEK_HOLE failed as %s", strerror(errno));
		return -1;
	}

	if (lseek(fd, 0, SEEK_SET) < 0) {
		error("seek back to ZERO failed as %s", strerror(errno));
		return -1;
	}

	return 1;
}

/*
 * Write out of all dirty pages in the specified range which are
 * not presently submitted write-out.
 * @offset: the starting byte of the file range to be synchronized.
 * @nbytes: specifies the length of the range to be synchronized, in bytes;
 *	    if nbytes is zero, then all bytes from offset through to the end
 *	    of file are synchronized.
 * @flags:  by default, SYNC_FILE_RANGE_WRITE will be used.
 */
int
writeout_dirty_pages(int fd, off_t offset, off_t nbytes,
		     unsigned int flags)
{
	if (sync_file_range(fd, offset, nbytes, flags) < 0) {
		error("sync file range failed as %s", strerror(errno));
		return -1;
	}

	return 0;	
}


/*
 * Produce a sparse file with data extents and holes.
 * @len:		the maximum length of the produced file.
 * @start_offset:	seek to here first to write data.
 * @skip_bytes:		for the next lseek(2) operation, we need to
 *			skip the number of bytes to create holes.
 * @data_len:		how many bytes for each write(2).
 */
int
create_data_and_holes(int fd, size_t len, off_t start_offset,
		      uint64_t skip_bytes, uint64_t data_len)
{
	int ret;
	off_t off = start_offset;
	char buf[4096];

	memset(buf, 'A', sizeof(buf));
	do {
		ret = lseek(fd, off, SEEK_SET);
		if (ret < 0) {
			error("seek to %llu for writing failed due to %s",
			       (uint64_t)off, strerror(errno));
			goto out;
		}

		while (data_len > 0) {
			ret = full_write(fd, buf, sizeof(buf));
			if (ret < 0) {
				error("write to dest file %llu failed as %s",
				       (uint64_t)off, strerror(errno));
				}
				goto out;
			data_len -= sizeof(buf);
		}
		off += skip_bytes;
		printf("write data off=%llu\n", (uint64_t) off);

	} while (off < len);

	printf("create data and holes done, off=%llu, len=%llu\n", (uint64_t) off, (uint64_t) len);
	ret = lseek(fd, 0, SEEK_SET);
	if (ret < 0)
		error("seek back to ZERO failed due to %s", strerror(errno));

out:
	return ret;
}

/*
 * Copy a data extent from source file to dest file.
 * @data_off: data offset
 * @hole_off: hole offset
 * The length of this extent is (hole_off - data_off).
 */
int
do_extent_copy(int src_fd, int dest_fd, off_t data_off, off_t hole_off)
{
	uint64_t len = (uint64_t)(hole_off - data_off);
	char buf[BUF_SIZE];
	int ret;

	/* Seek to data_off for data reading */
	ret = lseek(src_fd, data_off, SEEK_SET);
	if (ret < 0) {
		error("seek source file to %llu failed as %s",
		       (uint64_t)data_off, strerror(errno));
		return ret;
	}

	/* Seek to data_off for data writing, make holes as well */
	ret = lseek(dest_fd, data_off, SEEK_SET);
	if (ret < 0) {
		error("seek dest file to %llu failed as %s",
		       (uint64_t)data_off, strerror(errno));
		return ret;
	}

	while (len > 0) {
		memset(buf, 0, sizeof(buf));
		ssize_t n_read = read(src_fd, buf, BUF_SIZE);
		if (n_read < 0) {
			if (errno == EINTR)
				continue;

			error("read source file extent failed as %s",
			      strerror(errno));	
			return n_read;
		}

		if (n_read == 0)
			break;

		ret = full_write(dest_fd, buf, n_read);
		if (ret < 0) {
			error("write data to dest file failed as %s",
			       strerror(errno));
			return ret;
		}

		len -= n_read;
	}

	return ret;
}

/*
 * If lseek(2) failed and the errno is set to ENXIO, for
 * SEEK_DATA there are no more data regions past the supplied
 * offset.  For SEEK_HOLE, there are no more holes past the
 * supplied offset.  Set scan->hit_final_extent to true for
 * either case.
 */
int
copy_extents(int src_fd, int dest_fd, off_t src_total_size)
{
	int ret = 0;
	unsigned int i = 0;
	off_t seek_start = 0;
	off_t dest_pos = 0;
	off_t data_pos, hole_pos;
	
	do {
		data_pos = lseek(src_fd, seek_start, SEEK_DATA);
		if (data_pos < 0) {
			if (errno == ENXIO) {
				fprintf(stderr, "SEEK_DATA hit EOF at offset=%llu\n",
					(uint64_t)seek_start);
				ret = 0;
			} else {
				error("SEEK_DATA failed due to %s", strerror(errno));
				ret = -1;
			}
			break;
		}

		hole_pos = lseek(src_fd, data_pos, SEEK_HOLE);
		if (hole_pos < 0) {
			if (errno == ENXIO) {
				fprintf(stderr, "SEEK_HOLE hit EOF at offset=%llu\n",
					(uint64_t)data_pos);
				ret = 0;
			} else {
				fprintf(stderr, "SEEK_HOLE failed due to %s\n",
					strerror(errno));
				ret = -1;
			}
			break;
		}

		fprintf(stdout,
			"index=[%d], data offset=%llu, hole offset=%llu\n",
			i, (uint64_t)data_pos, (uint64_t)hole_pos);

		/* do extent copy */
		ret = do_extent_copy(src_fd, dest_fd, data_pos, hole_pos);
		if (ret < 0) {
			error("copy extent failed");
			break;
		}

		dest_pos += (hole_pos - data_pos);
		++i;
		seek_start = hole_pos;
	} while (seek_start < src_total_size);

	printf("after copy, seek_start=%llu, hole_pos=%llu, dest_pos=%llu\n",
		(uint64_t)seek_start, (uint64_t)hole_pos, (uint64_t)dest_pos);

	if (dest_pos < src_total_size)
		ftruncate(dest_fd, src_total_size);

	return ret;
}

static struct option const longopts[] = {
	{"fallocate", no_argument, NULL, 'P'},
	{"falloc-offset", required_argument, NULL, 'O'},
	{"falloc-length", required_argument, NULL, 'L'},
	{"falloc-keep-size", no_argument, NULL, 'N'},
	{"max-file-size", required_argument, NULL, 'M'},
	{"seek-start-offset", required_argument, NULL, 's'},
	{"seek-skip-bytes", required_argument, NULL, 'k'},
	{"seek-write-bytes", required_argument, NULL, 'l'},
	{"sync-dirty-pages", no_argument, NULL, 'S'},
	{"sync-page-offset", required_argument, NULL, 'p'},
	{"sync-page-bytes", required_argument, NULL, 'b'},
	{"sync-page-flags", required_argument, NULL, 'f'},
	{NULL, 0, NULL, 0}
};

void
usage(const char *progname)
{
	fprintf(stdout, "Usage: %s [OPTION]... SOURCE DEST\n"
		"	    [-P] [-O falloc-offset] [-L falloc-length] [-N]\n"
		"	    [-M max-file-size]\n"
		"	    [-s seek-start-offset] [-k seek-skip-length] [-l seek-write-length]\n"
		"	    [-S] [-p sync-page-offset] [-b sync-page-bytes] [-f sync-page-flags]\n"
		"	-L, --falloc-length=LENGTH	fallocate length\n"
		"	-O, --falloc-offset=OFFSET	fallocate offset\n"
		"	-M, --max-file-size=LENGTH	the maximum file size, don't required in fallocation mode\n"
		"	-s, --seek-offset=OFFSET	seek holes at the begnning of source file\n"
		"	-k, --seek-skip-bytes=BYTES	seek skip a range of bytes for next write\n"
		"	-l, --seek-write-bytes=BYTES	create data extent in number of bytes\n"
		"	-p, --sync-page-offset=OFFSET   sync dirty pages from where\n"
		"	-b, --sync-page-bytes=BYTES	sync dirty pages for a number of bytes\n"
		"	-f, --sync-page-flags=FLAGS	sync dirty pages in which mode\n"
		"	-P				preallocate space for source file\n"
		"	-N 				fallocate(2) in keep size mode\n"
		"	-S				sync out dirty pages\n",
		progname);

	exit(1);
}

int
main(int argc, char **argv)
{
	int opt;
	int src_fd;
	int dest_fd;
	int ret = 0;
	int do_falloc = 0;
	int falloc_mode = 0;
	int do_sync_dirty_pages = 0;
	unsigned int sync_page_flags = 0;
	size_t src_total_size;
	size_t max_file_size = 0;
	off_t falloc_length = 0;
	off_t falloc_offset = 0;
	off_t seek_start_offset = 0;
	off_t seek_skip_bytes = 0;
	off_t sync_page_offset = 0;
	off_t sync_page_bytes = 0;
	uint64_t seek_write_bytes = 0;
	char *src_file = NULL;
	char *dest_file = NULL;
	struct stat st;

	while ((opt = getopt_long(argc, argv, "PO:L:NM:s:k:l:S:p:b:f:",
				  longopts, NULL)) != -1) {
		switch(opt) {
		case 'P':
			do_falloc = 1;
			break;
		case 'O':
			/* Preallocate disk space from where */
			falloc_offset = parse_size(optarg);
			assert(falloc_offset <= OFF_T_MAX);
			printf("falloc offset=%ld\n", falloc_offset);
			break;
		case 'L':
			/* Preallocate disk space length */
			falloc_length = parse_size(optarg);
			assert(falloc_offset <= OFF_T_MAX);
			printf("falloc length=%ld\n", falloc_length);
			break;
		case 'N':
			/* Preallocation in KEEP_FILE_SIZE mode */
			falloc_mode = FALLOC_FL_KEEP_SIZE;
			break;
		case 'M':
			/*
			 * The maximum length of source file, only valid
			 * if the source file created in non-preallocation
			 * mode. Otherwise, it will be set to falloc_length.
			 */
			max_file_size = parse_size(optarg);
			printf("max file size=%llu\n", (uint64_t)max_file_size);
		case 's':
			/*
			 * Seek to where for the first write. It will create
			 * a hole at the beginning of the source file if this
			 * option was specified. It can be ignored if you don't
			 * want that.
			 */
			seek_start_offset = parse_size(optarg);
			assert(seek_start_offset <= OFF_T_MAX);
			break;
		case 'k':
			/*
			 * Skip the number of bytes for the next data write.
			 * It is used to create holes in the middle of file.
			 * If this option was not specified, using blocksize
			 * instead.
			 */
			seek_skip_bytes = parse_size(optarg);
			assert(seek_start_offset <= OFF_T_MAX);
			break;
		case 'l':
			/*
			 * Write the number of bytes after seeking, we
			 * we can make the disk fragmented as much as
			 * possbile by tweaking up this value.
			 */
			seek_write_bytes = parse_size(optarg);
			break;
		case 'S':
			/*
			 * Call sync_file_range(2) to writeout dirty
			 * pages. It can be used to test WRITEBACK pages
			 * probing branch.
			 */
			do_sync_dirty_pages = 1;
			break;
		case 'p':
			/*
			 * Sync out dirty pages starting from where, sync
			 * from 0 if it was not specified.
			 */
			sync_page_offset = parse_size(optarg);
			break;
		case 'b':
			/*
			 * If it was not specified, sync out pages from
			 * above offset to the end of file.
			 */
			sync_page_bytes = parse_size(optarg);
			break;
		case 'f':
			/*
			 * By default, SYNC_FILE_RANGE_WRITE will be used if
			 * this option was not specified.
			 */
			sync_page_flags = (unsigned int)atol(optarg);
			break;
		default:
			usage(argv[0]);
		}
	}

        if (argc - optind != 2) {
		error("Invalid arguments, missing SOURCE and DEST file");
		usage(argv[0]);
                return 1;
        }

	src_file = strdup(argv[optind]);
	if (!src_file) {
		usage(argv[0]);
		ret = -ENOMEM;
		goto out;
	}

	dest_file = strdup(argv[optind + 1]);
	if (!dest_file) {
		usage(argv[0]);
		ret = -ENOMEM;
		goto out;
	}

	if (!do_falloc && (falloc_length || falloc_offset)) {
		error("Invalid arguments, missing -F or --fallocate option "
		      "for fallocation tests");
		usage(argv[0]);
		goto out;
	}

	if (do_falloc && !falloc_length) {
		error("Invalid arguments, fallocate length must be specified "
		      "for fallocation tests");
		usage(argv[0]);
		goto out;
	}

	if (!do_falloc && !max_file_size) {
		error("Invalid arguments, missing -M or --max-file-size option "
		      "in none-fallocate mode");
		usage(argv[0]);
		goto out;
	}

	if (falloc_length && max_file_size) {
		error("Invalid arguments, don't combine -M with -F options");
		usage(argv[0]);
		goto out;
	}

	if (!do_sync_dirty_pages && (sync_page_offset ||
				     sync_page_bytes  ||
				     sync_page_flags)) {
		error("Invalid argument, missing -S or --sync-pages option "
		      "for sync file range tests");
		usage(argv[0]);
		return 1;
	}

	if (do_sync_dirty_pages && !sync_page_flags)
		sync_page_flags = SYNC_FILE_RANGE_WRITE;

	src_fd = open(src_file, O_RDWR|O_CREAT|O_TRUNC, 0644);
	if (src_fd < 0) {
		error("create %s failed as %s", src_file, strerror(errno));
		goto out;
	}

	dest_fd = open(dest_file, O_RDWR|O_CREAT|O_TRUNC, 0644);
	if (dest_fd < 0) {
		error("create %s failed as %s", dest_file, strerror(errno));
		close(src_fd);
		goto close_src_fd;
	}

	if (do_falloc) {
		/* Preallocate space for source file */
		ret = fallocate(src_fd, falloc_mode,
				falloc_offset, falloc_length);
		if (ret < 0) {
			error("fallocate file %s failed as %s",
			       src_file, strerror(errno));
			goto close_dest_fd;
		}
		max_file_size = falloc_length;
	}

	/*
	 * If seek_write_bytes was not specified, fill up data extent
	 * to st.st_blksize for each write.
	 */
	if (!seek_write_bytes) {
		seek_write_bytes = get_block_size(src_fd);
		if (seek_write_bytes < 0) {
			error("get %s block size failed as %s",
			       src_file, strerror(errno));
			goto close_dest_fd;
		}
	}

	printf("the max file size=%llu\n", (uint64_t)max_file_size);

	/*
	 * Seek to seek_offset, write seek_write_len to dest file,
	 * skip seek_skip_len for next write.
	 */
	ret = create_data_and_holes(src_fd, max_file_size,
				    seek_start_offset,
				    seek_skip_bytes,
				    seek_write_bytes);
	if (ret < 0) {
		error("seek write to %s failed", src_file);
		goto close_dest_fd;
	}

	/*
	 * Does the underlaying file system that the source file
	 * resides support SEEK_DATA/SEEK_HOLE?
	 */
	ret = support_seek_hole(src_fd);
	if (ret < 0) {
		error("%s does not support SEEK_DATA/SEEK_HOLE", src_file);
		goto close_dest_fd;
	}

	if (do_sync_dirty_pages) {
		ret = writeout_dirty_pages(src_fd, sync_page_offset,
					   sync_page_bytes, sync_page_flags);
		if (ret < 0) {
			error("write out dirty pages failed as %s",
			      strerror(errno));
			goto close_dest_fd;
		}
	}

	/*
	 * Note that if the source file created in non-fallocte mode,
	 * the source file size might less than the max_file_size.
	 */
	ret = fstat(src_fd, &st);
	if (ret < 0) {
		error("get file %s staticis failed as %s",
		       src_file, strerror(errno));
		goto close_dest_fd;
	} else {
		src_total_size = st.st_size;
		fprintf(stdout, "source file size = %lld\n",
			(uint64_t)src_total_size);
	}

	ret = copy_extents(src_fd, dest_fd, src_total_size);
	if (ret < 0)
		error("extents copy failed");

close_dest_fd:
	close(dest_fd);
close_src_fd:
	close(src_fd);
out:
	if (src_file)
		free(src_file);
	if (dest_file)
		free(dest_file);
	return ret;
}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
