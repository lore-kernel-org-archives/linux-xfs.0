Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 29 Oct 2008 09:56:12 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9TGtvnr000882
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 09:56:00 -0700
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C04B0B07A6A
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 09:55:57 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com with ESMTP id WBDhoFpJSzyTu9jE for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 09:55:57 -0700 (PDT)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id m9TGtqbP009622
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 12:55:52 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9TGtpp3032077
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 12:55:52 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id m9TGtoit031722
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 12:55:51 -0400
Message-ID: <49089596.80006@sandeen.net>
Date: Wed, 29 Oct 2008 11:55:50 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 0/3 v4]  hook xfs to fiemap ioctl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs mailing list <xfs@oss.sgi.com>

v2: Update & resend, including some checkpatch fixes, a bugfix, and 
incorporating some of Christoph's and Dave's comments.

v3: Address more review comments, and split into 3 patches this time.

v4: fix things up so that a 0-length array from fiemap behaves as
it should: simply return an extent count, but no extent data, for 
the range.  In this version the formatter can return "full" to
tell the getbmap loop to stop; see comment above xfs_getbmap.

Also, here's a very hacky (don't laugh!) test app.  I'll clean it
up at some point   :)  

(v4: test app slightly more cleaned up)

-Eric

---------------------

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/vfs.h>
#include <ext2fs/ext2_types.h>

/*************************************************/
/* All this should come from fiemap.h eventually */
struct fiemap_extent {
        __u64 fe_logical;  /* logical offset in bytes for the start of
                            * the extent from the beginning of the file */
        __u64 fe_physical; /* physical offset in bytes for the start
                            * of the extent from the beginning of the disk */
        __u64 fe_length;   /* length in bytes for this extent */
        __u64 fe_reserved64[2];
        __u32 fe_flags;    /* FIEMAP_EXTENT_* flags for this extent */
        __u32 fe_reserved[3];
};

struct fiemap {
        __u64 fm_start;         /* logical offset (inclusive) at
                                 * which to start mapping (in) */
        __u64 fm_length;        /* logical length of mapping which
                                 * userspace wants (in) */
        __u32 fm_flags;         /* FIEMAP_FLAG_* flags for request (in/out) */
        __u32 fm_mapped_extents;/* number of extents that were mapped (out) */
        __u32 fm_extent_count;  /* size of fm_extents array (in) */
        __u32 fm_reserved;
        struct fiemap_extent fm_extents[0]; /* array of mapped extents (out) */
};

#define FIEMAP_MAX_OFFSET       (~0ULL)

#define FIEMAP_FLAG_SYNC        0x00000001 /* sync file data before map */
#define FIEMAP_FLAG_XATTR       0x00000002 /* map extended attribute tree */

#define FIEMAP_FLAGS_COMPAT     (FIEMAP_FLAG_SYNC | FIEMAP_FLAG_XATTR)

#define FIEMAP_EXTENT_LAST              0x00000001 /* Last extent in file. */
#define FIEMAP_EXTENT_UNKNOWN           0x00000002 /* Data location unknown. */
#define FIEMAP_EXTENT_DELALLOC          0x00000004 /* Location still pending.
                                                    * Sets EXTENT_UNKNOWN. */
#define FIEMAP_EXTENT_ENCODED           0x00000008 /* Data can not be read
                                                    * while fs is unmounted */
#define FIEMAP_EXTENT_DATA_ENCRYPTED    0x00000080 /* Data is encrypted by fs.
                                                    * Sets EXTENT_NO_BYPASS. */
#define FIEMAP_EXTENT_NOT_ALIGNED       0x00000100 /* Extent offsets may not be
                                                    * block aligned. */
#define FIEMAP_EXTENT_DATA_INLINE       0x00000200 /* Data mixed with metadata.
                                                    * Sets EXTENT_NOT_ALIGNED.*/
#define FIEMAP_EXTENT_DATA_TAIL         0x00000400 /* Multiple files in block.
                                                    * Sets EXTENT_NOT_ALIGNED.*/
#define FIEMAP_EXTENT_UNWRITTEN         0x00000800 /* Space allocated, but
                                                    * no data (i.e. zero). */
#define FIEMAP_EXTENT_MERGED            0x00001000 /* File does not natively
                                                    * support extents. Result
                                                    * merged for efficiency. */

#define FIGETBSZ	_IO(0x00, 2)    /* get the block size used for bmap */
#define FS_IOC_FIEMAP			_IOWR('f', 11, struct fiemap)
// #define FS_IOC_FIECOUNT			_IOWR('f', 12, struct fiecount)

/* End of what should be coming from fiemap.h */
/**********************************************/


void usage(void)
{
	printf("Usage: fiemap [-vrSCL] [-s start] [-l length] [-c buf count] [-m max] filename\n");
	printf("  -v        : verbose mode\n");
	printf("  -r        : raw output: print raw ioctl structure values\n");
	printf("  -S        : set FIEMAP_FLAG_SYNC to sync before mapping\n");
	printf("  -C        : set FIEMAP_FLAG_NUM_EXTENTS to only get extent count, not mapping\n");
	printf("  -L        : set FIEMAP_FLAG_LUN_OFFSET to report extents in lun order\n");
	printf("  -X        : set FIEMAP_FLAG_XATTR to report xattr mapping\n");
	printf("  -s start  : start of mapping in bytes (default 0)\n");
	printf("  -l length : length of mapping in bytes (default to end of file)\n");
	printf("  -c count  : count of extents in ioctl input structure (default 32)\n");
	printf("  -m max    : max nr of ioctls to call before exit (default 512)\n");
	exit(EXIT_FAILURE);
}

#define EXABYTES(x)     ((long long)(x) << 60)
#define PETABYTES(x)    ((long long)(x) << 50)
#define TERABYTES(x)    ((long long)(x) << 40)
#define GIGABYTES(x)    ((long long)(x) << 30)
#define MEGABYTES(x)    ((long long)(x) << 20)
#define KILOBYTES(x)    ((long long)(x) << 10)

long long
cvtnum(char *s)
{
	long long	i;
	char		*sp;
	int		c;

	i = strtoll(s, &sp, 0);
	if (i == 0 && sp == s)
		return -1LL;
	if (*sp == '\0')
		return i;
	if (sp[1] != '\0')
		return -1LL;

	c = tolower(*sp);
	switch (c) {
	case 'k':
		return KILOBYTES(i);
	case 'm':
		return MEGABYTES(i);
	case 'g':
		return GIGABYTES(i);
	case 't':
		return TERABYTES(i);
	case 'p':
		return PETABYTES(i);
	case 'e':
		return  EXABYTES(i);
	}

	return -1LL;
}

void show_extents_table(struct fiemap *fiemap, int blocksize, int start_extent, int *is_last)
{
	unsigned int	i;

	for (i = 0; i < fiemap->fm_mapped_extents; i++) {
		__u64	logical = fiemap->fm_extents[i].fe_logical;
		__u64	phys = fiemap->fm_extents[i].fe_physical;
		__u64	length = fiemap->fm_extents[i].fe_length;
		int	flags = fiemap->fm_extents[i].fe_flags;
		__u64	last_logical = 0;

		if (i) {
			last_logical =
				fiemap->fm_extents[i-1].fe_logical +
				fiemap->fm_extents[i-1].fe_length - 1;
		}

		printf("ext: %3u logical: [%8llu..%8llu] phys: %8llu..%8llu flags: 0x%03X tot: %llu\n",
			i + start_extent,
			logical / blocksize,
			(logical + length - 1) / blocksize,
			phys / blocksize,
			(phys + length - 1) / blocksize,
			flags,
			(length / blocksize));

		if (fiemap->fm_extents[i].fe_flags & FIEMAP_EXTENT_LAST) {
			*is_last = 1;
			break; /* XXX should we?  or should look for exents filled in past last? */
		}
	}

	if (fiemap->fm_mapped_extents < fiemap->fm_extent_count)
		*is_last = 1;
}

void show_extents_raw(struct fiemap *fiemap, int start_extent, int *is_last)
{
	unsigned int	i;

	for (i = 0; i < fiemap->fm_mapped_extents; i++) {
		printf("Extent %3u: logical: %10lld physical: %10lld length: %10lld flags 0x%03X\n",
			i + start_extent,
			fiemap->fm_extents[i].fe_logical,
			fiemap->fm_extents[i].fe_physical,
			fiemap->fm_extents[i].fe_length,
			fiemap->fm_extents[i].fe_flags);

		if (fiemap->fm_extents[i].fe_flags & FIEMAP_EXTENT_LAST) {
			*is_last = 1;
			break;
			/* XXX should we?  or should look for extents wrongly filled in past last? */
		}
	}

	if (fiemap->fm_mapped_extents < fiemap->fm_extent_count)
		*is_last = 1;
}

int main(int argc, char**argv)
{
	int	blocksize = 0;	/* filesystem blocksize */
	uint	count = 32;	/* extent count */
	int	countonly = 0;	/* return only extent count? */
	int	fd;		/* file descriptor */
	int	last = 0;	/* last extent found */
	int	lunwise = 0;	/* return extents lun-wise */
	int	xattr = 0;	/* return xattr mapping */
	int	maxioctls = 512; /* max ioctls to try */
	int	opt;
	int	rc;
	int	raw = 0;	/* raw output format */
	int	sync = 0;	/* sync file before mapping */
	int	verbose = 0;	/* verbose output */
	char	*fname;		/* filename to map */
	char	*fiebuf;	/* fiemap buffer / ioctl argument */
	__u64	lstart = 0;	/* logical input mapping start */
	__u64	llength = ~0ULL;/* logical input mapping length */
	uint	start_ext = 0;	/* starting extent nr. for this batch */
	__u32	flags = 0;
	struct fiemap *fiemap;


	/* XXX er, can llength be ~0ULL if start > 0? */
	while ((opt = getopt(argc, argv, "s:l:c:m:rSCLXv")) != -1) {
		switch(opt) {
		/* logical mapping offset */
		case 's':
			lstart = cvtnum(optarg);
			break;
		/* logical mapping length */
		case 'l':
			llength = cvtnum(optarg);
			break;
		/* count of extent buffers to send */
		case 'c':
			count = atoi(optarg);
			if (count == 0)
				countonly++;
			break;
		/* max nr. of ioctls to try (safety net) */
		case 'm':
			maxioctls = atoi(optarg);
			break;
		/* raw format output */
		case 'r':
			raw++;
			break;
		/* sync file before mapping */
		case 'S':
			sync++;
			break;
		/* count extents only, no details */
		case 'C':
			countonly++;
			count = 0;
			break;
		/* return extents in lun order */
		case 'L':
			lunwise++;
			break;
		/* return extents in lun order */
		case 'X':
			xattr++;
			break;
		/* be verbose */
		case 'v':
			verbose++;
			break;
		default:
			usage();
		}
	}

	fname = argv[optind++];
	if (!fname)
		usage();

	/* Set the flags for the header */
	if (sync)
		flags |= FIEMAP_FLAG_SYNC;
	if (xattr)
		flags |= FIEMAP_FLAG_XATTR;
	if (lunwise)
		; // flags |= FIEMAP_FLAG_LUN_OFFSET;

	/* The whole buffer, extent maps and all */
	fiebuf = malloc(sizeof (struct fiemap) + (count * sizeof(struct fiemap_extent)));
	if (!fiebuf) {
		perror("Could not allocate fiemap buffers");
		exit(1);
	}

	/* set up the header */
	fiemap = (struct fiemap *)fiebuf;

	fiemap->fm_start = lstart;
	fiemap->fm_length = llength;
	fiemap->fm_flags = flags;
	fiemap->fm_extent_count = count;
	fiemap->fm_mapped_extents = 0;	/* output only */

	fd = open(fname, O_RDONLY);
	if (fd < 0) {
		perror("Can't open file");
		exit(1);
	}

	if (ioctl(fd, FIGETBSZ, &blocksize) < 0) {
		perror("Can't get block size");
		close(fd);
		return;
	}

	do {
		if (verbose)
			printf("Input:  start %llu length %llu flags 0x%X count %u\n",
				fiemap->fm_start, fiemap->fm_length,
				fiemap->fm_flags, fiemap->fm_extent_count);

		rc = ioctl(fd, FS_IOC_FIEMAP, (unsigned long)fiemap);
		if (rc < 0) {
			perror("FIEMAP ioctl failed");
			printf("flags 0x%x\n", fiemap->fm_flags);
			close(fd);
			exit(1);
		}
		if (verbose)
			printf("Output: start %llu length %llu flags 0x%X count %u mapped %u\n",
				fiemap->fm_start, fiemap->fm_length,
				fiemap->fm_flags, fiemap->fm_extent_count,
				fiemap->fm_mapped_extents);

		if (countonly) {
			printf("%llu extent%s\n", fiemap->fm_mapped_extents,
				fiemap->fm_mapped_extents != 1 ? "s" : "");
			break;
		} else if (raw)
			show_extents_raw(fiemap, start_ext, &last);
		else
			show_extents_table(fiemap, blocksize, start_ext, &last);

		if (!last) {
			int last_map = fiemap->fm_mapped_extents - 1;
			__u64 foo;	/* XXX Ummmm */

			foo = fiemap->fm_extents[last_map].fe_logical +
				fiemap->fm_extents[last_map].fe_length;
			/* Set up the next call arguments */ /* move to top */
			fiemap->fm_start = foo;
			fiemap->fm_length = lstart + llength - foo;
			fiemap->fm_extent_count = count;
		}

		/* keeps track of extent nrs. we've printed; rather, pass by value! */
		start_ext += fiemap->fm_mapped_extents;

		/* XXX need to stop if we've reached what we asked for */
		maxioctls--;

	} while (!last && maxioctls > 0);


	close(fd);

	return 0;
}
