Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1B0rxu6086719 for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 18:54:00 -0600
Received: from [134.14.52.238] (unknown [134.14.52.238])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8766E8F80D0
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 16:53:22 -0800 (PST)
Message-ID: <4992227B.3010107@sgi.com>
Date: Wed, 11 Feb 2009 11:57:31 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: [PATCH] Various fixes for extent list indexing
Content-Type: multipart/mixed; boundary="------------070404060407010304010106"
Reply-To: lachlan@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

This is a multi-part message in MIME format.
--------------070404060407010304010106
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

We had some systems crash with this stack:

[<a00000010000cb20>] ia64_leave_kernel+0x0/0x280
[<a00000021291ca00>] xfs_bmbt_get_startoff+0x0/0x20 [xfs]
[<a0000002129080b0>] xfs_bmap_last_offset+0x210/0x280 [xfs]
[<a00000021295b010>] xfs_file_last_byte+0x70/0x1a0 [xfs]
[<a00000021295b200>] xfs_itruncate_start+0xc0/0x1a0 [xfs]
[<a0000002129935f0>] xfs_inactive_free_eofblocks+0x290/0x460 [xfs]
[<a000000212998fb0>] xfs_release+0x1b0/0x240 [xfs]
[<a0000002129ad930>] xfs_file_release+0x70/0xa0 [xfs]
[<a000000100162ea0>] __fput+0x1a0/0x420
[<a000000100163160>] fput+0x40/0x60

I suspect what has happened here is that xfs_bmap_last_offset() has
accessed the extent list without acquiring the ilock and has raced
with another thread that has changed the extent list.  The other
thread has reduced the extent count so we've tried to access an
extent beyond the end of the list.

I added some ASSERTs in xfs_iext_get_ext() and xfs_iext_idx_to_irec()
to catch this and sure enough they triggered very quickly.  Looking
closely at the algorithm in xfs_iext_idx_to_irec(), if we try to
lookup an extent beyond the end of the list the search terminates
with 'low > high' and page_idx never gets updated to be an index
into a specific extent buffer.

Back in xfs_iext_get_ext(), if page_idx is > 255 it is off the end
of the extent buffer and potentially in unmapped memory which is how
the system panicked.  Some debugging in xfs_iext_get_ext() on a heavily
fragmented file revealed that page_idx was 167532 while the actual
count of extents in the buffer was only 254 so we accessed way outside
the bounds of the extent buffer.

I put together a test program (attached) and ran it as:

# ./extent -t -l 163840000 <file>

and it found many places where we try to index an extent beyond the
end of the extent list.  There's code in xfs_bmapi() and xfs_bunmapi()
that uses the value of if_lastex in the data fork to index an extent
so it's important to make sure that field holds a sane value.  The
primary culprit there is xfs_bmap_del_extent() when deleting an entire
extent - it leaves if_lastex as the index of the extent that was removed.
If there is another extent beyond that one then if_lastex now points to
that.  If the removed extent was the last extent then if_lastex is now
beyond the end of the list.


Index: xfs-fix/fs/xfs/xfs_bmap.c
===================================================================
--- xfs-fix.orig/fs/xfs/xfs_bmap.c
+++ xfs-fix/fs/xfs/xfs_bmap.c
@@ -1887,7 +1887,7 @@ xfs_bmap_add_extent_hole_delay(
  #define	SWITCH_STATE		(state & MASK2(LEFT_CONTIG, RIGHT_CONTIG))

  	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
-	ep = xfs_iext_get_ext(ifp, idx);
+	ep = NULL;
  	state = 0;
  	ASSERT(isnullstartblock(new->br_startblock));
  	/*
@@ -1904,6 +1904,7 @@ xfs_bmap_add_extent_hole_delay(
  	if (STATE_SET_TEST(RIGHT_VALID,
  			   idx <
  			   ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t))) {
+		ep = xfs_iext_get_ext(ifp, idx);
  		xfs_bmbt_get_all(ep, &right);
  		STATE_SET(RIGHT_DELAY, isnullstartblock(right.br_startblock));
  	}
@@ -2078,7 +2079,7 @@ xfs_bmap_add_extent_hole_real(

  	ifp = XFS_IFORK_PTR(ip, whichfork);
  	ASSERT(idx <= ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t));
-	ep = xfs_iext_get_ext(ifp, idx);
+	ep = NULL;
  	state = 0;
  	/*
  	 * Check and set flags if this segment has a left neighbor.
@@ -2094,6 +2095,7 @@ xfs_bmap_add_extent_hole_real(
  	if (STATE_SET_TEST(RIGHT_VALID,
  			   idx <
  			   ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t))) {
+		ep = xfs_iext_get_ext(ifp, idx);
  		xfs_bmbt_get_all(ep, &right);
  		STATE_SET(RIGHT_DELAY, isnullstartblock(right.br_startblock));
  	}
@@ -3206,6 +3208,8 @@ xfs_bmap_del_extent(
  		 */
  		XFS_BMAP_TRACE_DELETE("3", ip, idx, 1, whichfork);
  		xfs_iext_remove(ifp, idx, 1);
+		if (idx >= (ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t)))
+			idx--;
  		ifp->if_lastex = idx;
  		if (delay)
  			break;
@@ -5290,12 +5294,13 @@ xfs_bmapi(
  		/*
  		 * Else go on to the next record.
  		 */
-		ep = xfs_iext_get_ext(ifp, ++lastx);
  		prev = got;
-		if (lastx >= nextents)
+		if (++lastx >= nextents)
  			eof = 1;
-		else
+		else {
+			ep = xfs_iext_get_ext(ifp, lastx);
  			xfs_bmbt_get_all(ep, &got);
+		}
  	}
  	ifp->if_lastex = lastx;
  	*nmap = n;
@@ -5723,15 +5728,15 @@ nodelete:
  		 * If not done go on to the next (previous) record.
  		 * Reset ep in case the extents array was re-alloced.
  		 */
-		ep = xfs_iext_get_ext(ifp, lastx);
  		if (bno != (xfs_fileoff_t)-1 && bno >= start) {
-			if (lastx >= XFS_IFORK_NEXTENTS(ip, whichfork) ||
-			    xfs_bmbt_get_startoff(ep) > bno) {
-				if (--lastx >= 0)
-					ep = xfs_iext_get_ext(ifp, lastx);
-			}
-			if (lastx >= 0)
+			if (lastx >= 0) {
+				ep = xfs_iext_get_ext(ifp, lastx);
+				if (xfs_bmbt_get_startoff(ep) > bno) {
+					if (--lastx >= 0)
+						ep = xfs_iext_get_ext(ifp, lastx);
+				}
  				xfs_bmbt_get_all(ep, &got);
+			}
  			extno++;
  		}
  	}
Index: xfs-fix/fs/xfs/xfs_inode.c
===================================================================
--- xfs-fix.orig/fs/xfs/xfs_inode.c
+++ xfs-fix/fs/xfs/xfs_inode.c
@@ -1258,8 +1258,10 @@ xfs_file_last_byte(
  	 * necessary.
  	 */
  	if (ip->i_df.if_flags & XFS_IFEXTENTS) {
+		xfs_ilock(ip, XFS_ILOCK_SHARED);
  		error = xfs_bmap_last_offset(NULL, ip, &last_block,
  			XFS_DATA_FORK);
+		xfs_iunlock(ip, XFS_ILOCK_SHARED);
  		if (error) {
  			last_block = 0;
  		}
@@ -2645,10 +2647,8 @@ xfs_iflush_fork(
  	case XFS_DINODE_FMT_EXTENTS:
  		ASSERT((ifp->if_flags & XFS_IFEXTENTS) ||
  		       !(iip->ili_format.ilf_fields & extflag[whichfork]));
-		ASSERT((xfs_iext_get_ext(ifp, 0) != NULL) ||
-			(ifp->if_bytes == 0));
-		ASSERT((xfs_iext_get_ext(ifp, 0) == NULL) ||
-			(ifp->if_bytes > 0));
+		ASSERT((ifp->if_bytes == 0) ||
+			(xfs_iext_get_ext(ifp, 0) != NULL));
  		if ((iip->ili_format.ilf_fields & extflag[whichfork]) &&
  		    (ifp->if_bytes > 0)) {
  			ASSERT(XFS_IFORK_NEXTENTS(ip, whichfork) > 0);
@@ -3265,6 +3265,7 @@ xfs_iext_get_ext(
  	xfs_extnum_t	idx)		/* index of target extent */
  {
  	ASSERT(idx >= 0);
+	ASSERT(idx < (ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t)));
  	if ((ifp->if_flags & XFS_IFEXTIREC) && (idx == 0)) {
  		return ifp->if_u1.if_ext_irec->er_extbuf;
  	} else if (ifp->if_flags & XFS_IFEXTIREC) {
@@ -4035,6 +4036,8 @@ xfs_iext_idx_to_irec(
  	ASSERT(ifp->if_flags & XFS_IFEXTIREC);
  	ASSERT(page_idx >= 0 && page_idx <=
  		ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t));
+	ASSERT(page_idx < ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t)
+		|| realloc);
  	nlists = ifp->if_real_bytes / XFS_IEXT_BUFSZ;
  	erp_idx = 0;
  	low = 0;

--------------070404060407010304010106
Content-Type: text/x-csrc;
 name="extent.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="extent.c"

#define _LARGEFILE64_SOURCE

#include <sys/types.h>
#include <sys/stat.h>
#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>
#include <malloc.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <time.h>
#include <string.h>
#include <xfs/xfs.h>

#ifndef O_DIRECT
#define O_DIRECT	00040000
#endif
#define PREALLOC	1024*1024*1024

long		blocks;
long		*blocklist;
int		blocksize;
char		*buffer;
int		fd;
long		interval = 0;
off64_t		filesize = PREALLOC;
int		otrunc = 0;
int		odirect = 0;
int		osync = 0;
int		prealloc = 0;
int		removefile = 0;
char		*filename;

void
usage(void)
{
	fprintf (stderr, "usage: extent [options] <file>\n");
	fprintf (stderr, "	-d		use direct I/O\n");
	fprintf (stderr, "	-i <count>	progress interval\n");
	fprintf (stderr, "	-l <size>	file length (default %ld)\n", filesize);
	fprintf (stderr, "	-p		preallocate file\n");
	fprintf (stderr, "	-r		remove file after each test\n");
	fprintf (stderr, "	-s		synchronous I/O\n");
	fprintf (stderr, "	-t		truncate on open\n");
}

void
preallocate(void)
{
	struct flock	f;

	if (ftruncate(fd, 0) < 0) {
		perror("ftruncate");
		exit(1);
	}

	f.l_start = 0;
	f.l_whence = 0;

	while (f.l_start < filesize) {

		f.l_len = PREALLOC;
		if (f.l_len > (filesize - f.l_start))
			f.l_len = filesize - f.l_start;

		if (ioctl(fd, XFS_IOC_RESVSP64, &f) < 0) {
			perror("fcntl");
			exit(1);
		}

		f.l_start += f.l_len;
	}

	if (ftruncate(fd, filesize) < 0) {
		perror("ftruncate");
		exit(1);
	}
}

void
open_file(char *filename)
{
	fd = open(filename, O_WRONLY|O_CREAT|(otrunc ? O_TRUNC : 0)|(osync ? O_SYNC : 0)|(odirect ? O_DIRECT : 0), 0666);

	if (fd < 0) {
		perror("open");
		exit(1);
	}
}

void
close_file(void)
{
	if (removefile) {
		if (unlink(filename) < 0)
			perror("unlink");
	}

	close(fd);
}

void
do_write(void)
{
	int		ret;
	long		i;
	off64_t		offset;

	for (i = 0; i < blocks; i++) {

		if (interval && (i % interval) == 0) {
			printf("\rwriting record %ld of %ld, %f%%", i, blocks, ((float)i * 100) / (float)blocks);
			fflush(stdout);
			fdatasync(fd);
		}

		offset = (off64_t)blocklist[i] * (off64_t)blocksize;

		if (lseek64(fd, offset, SEEK_SET) < 0)
			perror("lseek");

		ret = write(fd, buffer, blocksize);

		if (ret < 0)
			perror("write");
		else if (ret < blocksize)
			printf("short write\n");
	}

	if (interval)
		printf("\rwriting record %ld of %ld, %f%%\n", i, blocks, ((float)i * 100) / (float)blocks);
}

void
do_read(void)
{
	int		i;
	int		ret;
	off64_t		offset = 0;

	if (lseek64(fd, 0, SEEK_SET) < 0) {
		perror("lseek");
		exit(1);
	}

	for (;;) {

		ret = read(fd, buffer, blocksize);

		if (ret < 0) {
			perror("read");
			exit(1);
		}

		if (ret == 0)
			break;

		for (i = 0; i < ret; i++) {
			if (buffer[i] != 'x')
				printf("corruption detected at offset %ld\n", offset);
		}

		offset += ret;
	}
}

int main(int argc, char **argv)
{
	struct stat	buf;
	long		temp;
	long		i;
	long		j;
	int		c;

        while ((c = getopt(argc, argv, "di:l:prst")) != EOF) {
		switch (c) {
			case 'd':
				odirect = 1;
				break;
			case 'i':
				interval = strtoul(optarg, NULL, 0);
				break;
			case 'l':
				filesize = strtoll(optarg, NULL, 0);
				break;
			case 'p':
				prealloc = 1;
				break;
			case 'r':
				removefile = 1;
				break;
			case 's':
				osync = 1;
				break;
			case 't':
				otrunc = 1;
				break;
			default:
				usage();
				exit(1);
				break;
		}
	}

	if (optind == argc) {
		usage();
		exit(1);
	}

	filename = argv[optind];

	open_file(filename);

	if (fstat(fd, &buf) < 0) {
		perror("fstat");
		exit(1);
	}

	close_file();

	srandom(time(NULL));
	blocksize = buf.st_blksize;
	blocks = filesize / blocksize;

	printf("blocksize: %d\n", blocksize);
	printf("blocks: %ld\n", blocks);

	buffer = memalign(getpagesize(), blocksize);

	if (!buffer) {
		perror("malloc");
		exit(1);
	}

	memset(buffer, 'x', blocksize);

	blocklist = malloc(sizeof(blocklist[0]) * blocks);

	if (!blocklist) {
		perror("malloc");
		exit(1);
	}

	open_file(filename);
	if (prealloc)
		preallocate();

	printf("forward sequential write...\n");

	for (i = 0; i < blocks; i++)
		blocklist[i] = i;

	do_write();
	close_file();

	open_file(filename);
	if (prealloc)
		preallocate();

	printf("backward sequential write...\n");

	for (i = 0; i < blocks; i++)
		blocklist[i] = blocks - i - 1;

	do_write();
	close_file();

	open_file(filename);
	if (prealloc)
		preallocate();

	printf("stride write...\n");

	for (i = 0, j = 0; i < (blocks / 2); i++, j += 2)
		blocklist[i] = j;
	for (j = 1; i < blocks; i++, j += 2)
		blocklist[i] = j;

	do_write();
	close_file();

	open_file(filename);
	if (prealloc)
		preallocate();

	printf("backward stride write...\n");

	for (i = 0, j = blocks - 1; i < (blocks / 2); i++, j -= 2)
		blocklist[i] = j;
	for (j = blocks - 2; i < blocks; i++, j -= 2)
		blocklist[i] = j;

	do_write();
	close_file();

	open_file(filename);
	if (prealloc)
		preallocate();

	printf("inverted stride write...\n");

	for (i = 0, j = 0; i < (blocks / 2); i++, j += 2)
		blocklist[i] = j;
	for (j = blocks - 1; i < blocks; i++, j -= 2)
		blocklist[i] = j;

	do_write();
	close_file();

	open_file(filename);
	if (prealloc)
		preallocate();

	printf("parallel write...\n");

	for (i = 0, j = 0; i < blocks; i += 2, j++)
		blocklist[i] = j;
	for (i = 1; i < blocks; i += 2, j++)
		blocklist[i] = j;

	do_write();
	close_file();

	open_file(filename);
	if (prealloc)
		preallocate();

	printf("converge write...\n");

	for (i = 0, j = 0; i < blocks; i += 2, j++)
		blocklist[i] = j;
	for (i = 1, j = blocks - 1; i < blocks; i += 2, j--)
		blocklist[i] = j;

	do_write();
	close_file();

	open_file(filename);
	if (prealloc)
		preallocate();

	printf("diverge write...\n");

	for (i = 0, j = (blocks / 2) - 1; i < blocks; i += 2, j--)
		blocklist[i] = j;
	for (i = 1, j = (blocks / 2); i < blocks; i += 2, j++)
		blocklist[i] = j;

	do_write();
	close_file();

	open_file(filename);
	if (prealloc)
		preallocate();

	printf("random write...\n");

	for (i = 0; i < blocks; i++)
		blocklist[i] = i;

	for (i = 0; i < blocks; i++) {
		j = random() % blocks;
		temp = blocklist[i];
		blocklist[i] = blocklist[j];
		blocklist[j] = temp;
	}

	do_write();
	close_file();

	free(blocklist);
	free(buffer);
	exit(0);
}


--------------070404060407010304010106
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------070404060407010304010106--
