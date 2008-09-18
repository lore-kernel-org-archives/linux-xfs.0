Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 17 Sep 2008 21:43:47 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8I4hgro007598
	for <xfs@oss.sgi.com>; Wed, 17 Sep 2008 21:43:43 -0700
Message-ID: <48D1DCD5.7040502@thebarn.com>
Date: Wed, 17 Sep 2008 23:45:09 -0500
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: REVIEW: Fix for incore extent corruption.
References: <48D19A83.4040608@thebarn.com> <48D1CD46.4010104@sgi.com>
In-Reply-To: <48D1CD46.4010104@sgi.com>
Content-Type: multipart/mixed;
 boundary="------------040806040806040709080001"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: lachlan@sgi.com
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------040806040806040709080001
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Lachlan McIlroy wrote:
> Russell Cattelan wrote:
>>
>> Reference:
>> http://oss.sgi.com/archives/xfs/2008-06/msg00209.html
>>
>>
>> It turns out that the code in question is still broken.
>>
>> xfs_iext_irec_compact_full will still corrupt the incore extent list 
>> if it does
>> the the partial copy of extents from one page to the next.
>> I haven't quit figured out where things get out of sync but somehow
>> if_real_bytes which tracks the total number of bytes available in
>> the extent buffers and if_bytes (which tracks the total bytes used
>> for extents.
>>
>> So at some point the inode thinks is has more extents than allocated 
>> pages allow.
>> So what happens is xfs_iext_idx_to_irec which uses idxp to pass IN the
>> absolute extent index is suppose to change  idxp on the way OUT and 
>> erp_idxp
>> to be a buffer index pair. What happens is that it doesn't find the 
>> extent so idxp
>> is left holding the same value as was passed in and erp_idx is 0.
>> This causes the extent code to then index way past the end of extent 
>> buffer 0
>> into garbage mem.
>>
>> with 4k ext buffers max extent count per buffer is 256.
>> example being:
>> IN:
>> idxp = 400
>> should become:
>> idexp = 144
>> erp_idxp = 1
>>
>> but we end up not finding the extent so
>> we have
>> idxp = 400
>> erp_idxp =0
>>
>> so we now index 6400 bytes into a 4k buffer.
>>
>> Which often times  is a pages of mostly 0 so we end up with access to 
>> block 0 errors.
>>
>> The more I looked at this code the more it didn't make sense to do 
>> partial moves.
>> Since the list of extent buffers is only scanned once vs restarting 
>> the list whenever a partial move is done,
>> it is very unlikely to actually free an extent buffer. (granted it's 
>> possible but unlikely)
>>
>> xfs_iext_irec_compact_pages does the same thing as 
>> xfs_iext_irec_compact_full except that doesn't handle partial moves.
>>
>> xfs_iext_irec_compact is written such that ratio of current extents 
>> has to be significantly smaller than the current allocated space
>> xfs_inode: 4513
>> nextents < ( nlists  * XFS_LINEAR_EXT) >> 3
>>
>> As it turns out 99% of the time it calls xfs_iext_irec_compact_pages
>> (which is why it has been so hard to track this bug down).
>>
>> If you change the 3 to a 1 so the code alway calls compact_full vs 
>> compact_pages the extent list will corrupt amost
>> immediately.
> Awesome work Russell, we'll give it a go.
>
>>
>> Since the code is broken, almost never used, and provides only micro 
>> optimization of incore space I propose we just
>> remove it all together.
> Are you sure the bug is in xfs_iext_irec_compact_full?
>
> Is it possible that we are still indexing beyond the page when using
> xfs_iext_irec_compact_pages but the pages just happen to be sequential
> so the indexing gets the extent anyway?
I added a bunch of printk to track this down,  the compact_pages path is hit
a lot in fact as far as I can tell all running file systems that shrink 
extents and don't crash :-)

I should have done this originally my I'm including the modified 
makeextents that
I used to tickle this problem.
It reserves a bunch of space to create a contiguous extents then in 
unreserves space to
poke a bunch of holes creating a big extent list, it then goes back and 
writes the whole
file hopefully collapsing extents as it goes.

i.e.
makeextents -v -c 512 foo ; xfs_bmap -v foo
should give you 1024 extents
makeextents -v -f -c 512 foo ; xfs_bmap -v foo
will do the same thing but fill in the file with writes.
The number of resulting extents vary, but sometimes you
end up with one extent. sometimes more.

If you change the 3 to a 1 in the current code so compact_full is used 
vs compact_pages
and run the test it will hit some problem every time.
xexlist in kdb will show the corruption in the incore list.

This will run the code through all 3 formats so if you are lucky you end 
up hitting all
the cases indirect > 256, direct <= 256, and inline <= 2

note:  xfs_iext_indirect_to_direct does call compact_full but in that 
case we are already down
to under 256 extents (at least we should be ) and at that point 
compact_full will behave just like compact_pages.


>
>>
>> I'm also including an xfsidbg patch that for xexlist that prints out 
>> buffer offset and index.
>>
>> -Russell Cattelan
>>
>>
>


--------------040806040806040709080001
Content-Type: text/plain;
 name="makeextents.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="makeextents.c"

/*
 * Copyright (c) 2000-2004 Silicon Graphics, Inc.
 * All Rights Reserved.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it would be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write the Free Software Foundation,
 * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 */

/*
 * Write a bunch of holes to create a bunch of extents.
 */
 

#include "global.h"


char *progname;
__uint64_t num_holes = 1000;
__uint64_t curr_holes;
int verbose_opt = 0;
char *filename;
int status_num = 100;
int wsync;
int preserve;
unsigned int blocksize;
__uint64_t fileoffset;

#define JUMP_SIZE (128 * 1024)
#define NUMHOLES_TO_SIZE(i) (i * JUMP_SIZE)
#define SIZE_TO_NUMHOLES(s) (s / JUMP_SIZE)

void
usage(void)
{
	fprintf(stderr, "%s [-b blocksize] [-n num-holes] [-s status-num]"
			" [-o start-offset] [-vwp] file\n", progname);
	exit(1);
}


static int
offset_length(
	__uint64_t	offset,
	__uint64_t	length,
	xfs_flock64_t	*segment)
{

	memset(segment, 0, sizeof(*segment));

	segment->l_whence = SEEK_SET;
	segment->l_start = offset;

	if (segment->l_start < 0) {
		printf(_("non-numeric offset argument -- %lld\n"), offset);
		return 0;
	}
	segment->l_len = length;
	if (segment->l_len < 0) {
		printf(_("non-numeric length argument -- %lld\n"), length);
		return 0;
	}
	return 1;
}

int
main(int argc, char *argv[])
{
	int c;
	int fd;
	int oflags;
	__uint64_t i;
	__uint64_t offset;
	int blocksize = 512;
	int fill = 0;
	unsigned char *buffer = NULL;
	struct stat stat;
	xfs_flock64_t segment;

	progname = argv[0];

	while ((c = getopt(argc, argv, "b:n:o:ps:vwf")) != -1) {
		switch (c) {
		case 'b':
			blocksize = atoi(optarg);
			break;
		case 'n':
			num_holes = atoll(optarg);
			break;
		case 'v':
			verbose_opt = 1;
			break;
		case 'w':
			wsync = 1;
			break;
		case 'p':
			preserve = 1;
			break;
		case 's':
			status_num = atoi(optarg);
			break;
		case 'o':
			fileoffset = strtoull(optarg, NULL, 16);
			break;
		case 'f':
			fill = 1;
			break;
		case '?':
			usage();
		}
	}
	if (optind == argc-1)
		filename = argv[optind];
	else
		usage();

	buffer = malloc(4096);
	if (buffer == NULL) {
	    fprintf(stderr, "%s: blocksize to big to allocate buffer\n", progname);
	    return 1;
	}

        oflags = O_RDWR | O_CREAT;
	oflags |=   (preserve ? 0 : O_TRUNC) |
		    (wsync ? O_SYNC : 0);
        
	if ((fd = open(filename, oflags, 0666)) < 0) {
		perror("open");
		return 1;
	}

	if (fstat(fd, &stat) < 0) {
		perror("stat");
		return 1;
	}
	if (preserve) {
		curr_holes = SIZE_TO_NUMHOLES(stat.st_size);
		if (num_holes < curr_holes) {
			/* we need to truncate back */
			if (ftruncate(fd, NUMHOLES_TO_SIZE(num_holes)) < 0) {
				perror("ftruncate");
				return 1;
			}
			if (verbose_opt) {
				printf("truncating back to %lld\n", NUMHOLES_TO_SIZE(num_holes));
			}
			return 0;
		}
	}
	else {
		curr_holes = 0;
	}
	if (curr_holes != 0 && verbose_opt) {
		printf("creating %lld more holes\n", num_holes - curr_holes);
	}
		
	printf("xfsctl alloc space\n");

	offset_length(0, NUMHOLES_TO_SIZE(num_holes), &segment);

	if (xfsctl(filename, fd,  XFS_IOC_RESVSP64, &segment) < 0) {
		perror(" XFS_IOC_RESVSP64");
		return 0;
	}	

#if 0
	/* create holes by seeking and writing */
	for (i = curr_holes; i < num_holes; i++) {

		offset = NUMHOLES_TO_SIZE(i) + fileoffset;

		if (lseek64(fd, offset, SEEK_SET) < 0) {
			perror("lseek");
			return 1;
		}

		if (write(fd, buffer, blocksize) < blocksize) {
			perror("write");
			return 1;
		}

		if (verbose_opt && ((i+1) % status_num == 0)) {
			printf("seeked and wrote %lld times\n", i+1);
		}
	}
#endif
	offset = 0;
	for (i = curr_holes; i < num_holes; i++) {

		offset = NUMHOLES_TO_SIZE(i) + fileoffset;
		//printf("unresvsp %lld\n", offset);
		if (!offset_length(offset, JUMP_SIZE/2, &segment))
			return 0;

		if (xfsctl(filename, fd, XFS_IOC_UNRESVSP64, &segment) < 0) {
			perror("XFS_IOC_UNRESVSP64");
			return 0;
		}
	}

	/* ok fill up file */

	if (fill) {
		int size = 4096;
		offset  = 0;
		memset(buffer,'B', size);
		printf("filling in file num_holes %lld size %lld\n",num_holes, NUMHOLES_TO_SIZE(num_holes));
		for (i = 0; i < NUMHOLES_TO_SIZE(num_holes) /  size ; i++) {
			if (lseek64(fd, offset, SEEK_SET) < 0) {
				perror("lseek");
				return 1;
			}
			//printf("write @ %lld\n",offset);
			if (write(fd, buffer,  size) <  size ) {
				perror("write");
				return 1;
			}
			offset += size;
		}
	}
		
		

	close(fd);

	return 0;
}

--------------040806040806040709080001
Content-Type: text/plain; x-mac-type="0"; x-mac-creator="0";
 name="xfs_extent_debug"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xfs_extent_debug"

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_lrw.c	2008-09-16 00:10:26.000000000 -0500
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c	2008-09-16 09:44:52.000000000 -0500
@@ -489,6 +489,11 @@ xfs_zero_eof(
 	start_zero_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)isize);
 	end_zero_fsb = XFS_B_TO_FSBT(mp, offset - 1);
 	ASSERT((xfs_sfiloff_t)last_fsb < (xfs_sfiloff_t)start_zero_fsb);
+
+	printk("%s: start_zero_fsb %lld end_zero_fsb %lld offset %lld isize %lld\n",
+	       __FUNCTION__, start_zero_fsb, end_zero_fsb,
+	       offset,isize);
+
 	if (last_fsb == end_zero_fsb) {
 		/*
 		 * The size was only incremented on its last block.
@@ -503,6 +508,11 @@ xfs_zero_eof(
 		zero_count_fsb = end_zero_fsb - start_zero_fsb + 1;
 		error = xfs_bmapi(NULL, ip, start_zero_fsb, zero_count_fsb,
 				  0, NULL, 0, &imap, &nimaps, NULL, NULL);
+#warning printk added
+		printk("%s: after bmapi start_zero_fsb %lld end_zero_fsb %lld offset %lld isize %lld\n",
+		       __FUNCTION__, start_zero_fsb, end_zero_fsb,
+		       offset,isize);
+
 		if (error) {
 			ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
 			return error;
Index: linux-2.6-xfs/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.c	2008-09-16 00:10:25.000000000 -0500
+++ linux-2.6-xfs/fs/xfs/xfs_bmap.c	2008-09-16 09:44:52.000000000 -0500
@@ -2216,7 +2216,8 @@ xfs_bmap_add_extent_hole_real(
 					new->br_startblock,
 					new->br_blockcount, &i)))
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 0, done);
+			//XFS_WANT_CORRUPTED_GOTO(i == 0, done);
+			printk("%s:%d i %d\n",__FUNCTION__,__LINE__,i);
 			cur->bc_rec.b.br_state = new->br_state;
 			if ((error = xfs_bmbt_insert(cur, &i)))
 				goto done;
Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2008-09-16 00:10:26.000000000 -0500
+++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2008-09-16 09:44:52.000000000 -0500
@@ -4157,6 +4157,7 @@ xfs_iext_indirect_to_direct(
 	ASSERT(nextents <= XFS_LINEAR_EXTS);
 	size = nextents * sizeof(xfs_bmbt_rec_t);
 
+	printk("%s: if_bytes %d\n",__FUNCTION__,ifp->if_bytes);
 	xfs_iext_irec_compact_full(ifp);
 	ASSERT(ifp->if_real_bytes == XFS_IEXT_BUFSZ);
 
@@ -4165,6 +4166,7 @@ xfs_iext_indirect_to_direct(
 	ifp->if_flags &= ~XFS_IFEXTIREC;
 	ifp->if_u1.if_extents = ep;
 	ifp->if_bytes = size;
+	printk("%s: if_bytes %d\n",__FUNCTION__,ifp->if_bytes);
 	if (nextents < XFS_LINEAR_EXTS) {
 		xfs_iext_realloc_direct(ifp, size);
 	}
@@ -4439,6 +4441,32 @@ xfs_iext_irec_new(
 	return (&erp[erp_idx]);
 }
 
+void
+xfs_iext_print(
+	xfs_ifork_t	*ifp)		/* inode fork pointer */
+{
+
+	int		i;		/* loop counter */
+	int		nlists;		/* number of irec's (ex lists) */
+	xfs_ext_irec_t	*erp;		/* indirection array pointer */
+	nlists = ifp->if_real_bytes / XFS_IEXT_BUFSZ;
+
+	printk("%s real_bytes %d\n",__FUNCTION__,ifp->if_real_bytes );
+	erp = ifp->if_u1.if_ext_irec;
+	for (i = 0; i < nlists - 1; i++) {
+		printk("%s\ti %d "
+		       "erp[i] 0x%p buf 0x%p off %d count %d "
+		       "\n",
+		       __FUNCTION__,
+		       i,
+		       &erp[i],
+		       (&erp[i])->er_extbuf,
+		       (&erp[i])->er_extoff,
+		       (&erp[i])->er_extcount);
+	}
+}
+
+
 /*
  * Remove a record from the indirection array.
  */
@@ -4459,9 +4487,26 @@ xfs_iext_irec_remove(
 			-erp->er_extcount);
 		kmem_free(erp->er_extbuf);
 	}
+//	printk("%s: if_real_bytes 0x%x\n",__FUNCTION__,ifp->if_real_bytes);
 	/* Compact extent records */
 	erp = ifp->if_u1.if_ext_irec;
 	for (i = erp_idx; i < nlists - 1; i++) {
+		printk("%s i %d "
+		       "erp[i] 0x%p buf 0x%p off %d count %d "
+		       "erp[i+1] 0x%p buf 0x%p off %d count %d "
+		       "\n",
+		       __FUNCTION__,
+		       i,
+		       &erp[i],
+		       (&erp[i])->er_extbuf,
+		       (&erp[i])->er_extoff,
+		       (&erp[i])->er_extcount,
+		       &erp[i+1],
+		       (&erp[i+1])->er_extbuf,
+		       (&erp[i+1])->er_extoff,
+		       (&erp[i+1])->er_extcount
+			);
+
 		memmove(&erp[i], &erp[i+1], sizeof(xfs_ext_irec_t));
 	}
 	/*
@@ -4472,12 +4517,13 @@ xfs_iext_irec_remove(
 	 * infinite loop.
 	 */
 	if (--nlists) {
-		xfs_iext_realloc_indirect(ifp,
-			nlists * sizeof(xfs_ext_irec_t));
+		printk("%s: is this ok?\n",__FUNCTION__);
+		xfs_iext_realloc_indirect(ifp, nlists * sizeof(xfs_ext_irec_t));
 	} else {
 		kmem_free(ifp->if_u1.if_ext_irec);
 	}
 	ifp->if_real_bytes = nlists * XFS_IEXT_BUFSZ;
+	//printk("%s: if_real_bytes 0x%x\n",__FUNCTION__,ifp->if_real_bytes);
 }
 
 /*
@@ -4499,21 +4545,36 @@ xfs_iext_irec_compact(
 	xfs_extnum_t	nextents;	/* number of extents in file */
 	int		nlists;		/* number of irec's (ex lists) */
 
+	xfs_inode_t	*xip;
+
 	ASSERT(ifp->if_flags & XFS_IFEXTIREC);
 	nlists = ifp->if_real_bytes / XFS_IEXT_BUFSZ;
 	nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
 
+	xip = container_of(ifp, xfs_inode_t, i_df);
+
+	printk("%s: xip 0x%p nextents %d nlists %d ratko 3 %d ratio 1 %d\t",
+	       __FUNCTION__, xip, nextents, nlists,
+	       (nlists * XFS_LINEAR_EXTS) >> 3,
+	       (nlists * XFS_LINEAR_EXTS) >> 1);
 	if (nextents == 0) {
+		printk("%s:%d destroy\n",__FUNCTION__,__LINE__);
 		xfs_iext_destroy(ifp);
 	} else if (nextents <= XFS_INLINE_EXTS) {
+		printk("%s:%d indirect_to_direct 0\n",__FUNCTION__,__LINE__);
 		xfs_iext_indirect_to_direct(ifp);
 		xfs_iext_direct_to_inline(ifp, nextents);
 	} else if (nextents <= XFS_LINEAR_EXTS) {
+		printk("%s:%d indirect_to_direct 1\n",__FUNCTION__,__LINE__);
 		xfs_iext_indirect_to_direct(ifp);
-	} else if (nextents < (nlists * XFS_LINEAR_EXTS) >> 3) {
+	} else if (nextents < (nlists * XFS_LINEAR_EXTS) >> 1){
+		printk("%s:%d compact_full\n",__FUNCTION__,__LINE__);
 		xfs_iext_irec_compact_full(ifp);
 	} else if (nextents < (nlists * XFS_LINEAR_EXTS) >> 1) {
+		printk("%s:%d compact_pages\n",__FUNCTION__,__LINE__);
 		xfs_iext_irec_compact_pages(ifp);
+	} else {
+		printk("\n");
 	}
 }
 
@@ -4576,6 +4637,7 @@ xfs_iext_irec_compact_full(
 	erp_next = erp + 1;
 	ep_next = erp_next->er_extbuf;
 
+	printk("%s return 0x%p\n",__FUNCTION__,__builtin_return_address(0));
 	while (erp_idx < nlists - 1) {
 		/*
 		 * Check how many extent records are available in this irec.
@@ -4589,6 +4651,18 @@ xfs_iext_irec_compact_full(
 			 * the previous page.
 			 */
 			ext_diff = MIN(ext_avail, erp_next->er_extcount);
+			
+			if (erp_next->er_extcount > ext_diff) {
+				printk("partial moves is broken skip %d %d\n",
+				       erp_next->er_extcount, ext_diff);
+				erp_idx++;
+				goto next;
+			}
+
+			printk("%s: memcpy dst 0x%p src 0x%p size %d\n",__FUNCTION__,
+			       ep,
+			       ep_next,
+			       ext_diff * sizeof(xfs_bmbt_rec_t));
 			memcpy(ep, ep_next, ext_diff * sizeof(xfs_bmbt_rec_t));
 			erp->er_extcount += ext_diff;
 			erp_next->er_extcount -= ext_diff;
@@ -4598,16 +4672,19 @@ xfs_iext_irec_compact_full(
 			 * remove it.
 			 */
 			if (erp_next->er_extcount == 0) {
+				printk("%s:%d extcount==0 \n",__FUNCTION__,__LINE__);
 				/*
 				 * Free page before removing extent record
 				 * so er_extoffs don't get modified in
 				 * xfs_iext_irec_remove.
 				 */
+				xfs_iext_print(ifp);
 				kmem_free(erp_next->er_extbuf);
 				erp_next->er_extbuf = NULL;
 				xfs_iext_irec_remove(ifp, erp_idx + 1);
 				erp = &ifp->if_u1.if_ext_irec[erp_idx];
 				nlists = ifp->if_real_bytes / XFS_IEXT_BUFSZ;
+				xfs_iext_print(ifp);
 
 			/*
 			 * If the next irec is not empty move up the content
@@ -4615,17 +4692,29 @@ xfs_iext_irec_compact_full(
 			 * the beggining of this one.
 			 */
 			} else {
+				xfs_iext_print(ifp);
+				printk("%s: memmove dst 0x%p src 0x%p size %d\n",__FUNCTION__,
+				       erp_next->er_extbuf, &ep_next[ext_diff],
+				       erp_next->er_extcount *
+				       sizeof(xfs_bmbt_rec_t));
 				memmove(erp_next->er_extbuf, &ep_next[ext_diff],
 					erp_next->er_extcount *
 					sizeof(xfs_bmbt_rec_t));
 				ep_next = erp_next->er_extbuf;
+				printk("%s: memset src 0x%p erp count %d size %d\n",__FUNCTION__,
+				       &ep_next[erp_next->er_extcount],
+				       erp_next->er_extcount,
+				       (XFS_LINEAR_EXTS -
+				        erp_next->er_extcount) *
+					sizeof(xfs_bmbt_rec_t));
+
 				memset(&ep_next[erp_next->er_extcount], 0,
 					(XFS_LINEAR_EXTS -
 						erp_next->er_extcount) *
 					sizeof(xfs_bmbt_rec_t));
+				xfs_iext_print(ifp);
 			}
 		}
-
 		if (erp->er_extcount == XFS_LINEAR_EXTS) {
 			erp_idx++;
 			if (erp_idx < nlists)
@@ -4633,6 +4722,7 @@ xfs_iext_irec_compact_full(
 			else
 				break;
 		}
+	next:
 		ep = &erp->er_extbuf[erp->er_extcount];
 		erp_next = erp + 1;
 		ep_next = erp_next->er_extbuf;
Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2008-09-16 00:10:26.000000000 -0500
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2008-09-16 09:44:52.000000000 -0500
@@ -2054,6 +2054,7 @@ kdbm_bp(int argc, const char **argv)
 static int
 kdbm_bpdelay(int argc, const char **argv)
 {
+#if 0
 	struct list_head	*xfs_buftarg_list = xfs_get_buftarg_list();
 	struct list_head	*curr, *next;
 	xfs_buftarg_t		*tp, *n;
@@ -2091,6 +2092,7 @@ kdbm_bpdelay(int argc, const char **argv
 			}
 		}
 	}
+#endif
 	return 0;
 }
 
@@ -3831,21 +3833,32 @@ xfs_rw_trace_entry(ktrace_entry_t *ktep)
 static void
 xfs_xexlist_fork(xfs_inode_t *ip, int whichfork)
 {
-	int nextents, i;
+	int nextents, nlists, i;
 	xfs_ifork_t *ifp;
 	xfs_bmbt_irec_t irec;
+	xfs_bmbt_rec_host_t *rec_h;
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	if (ifp->if_flags & XFS_IFEXTENTS) {
 		nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
-		kdb_printf("inode 0x%p %cf extents 0x%p nextents 0x%x\n",
+		nlists = ifp->if_real_bytes / XFS_IEXT_BUFSZ;
+		kdb_printf("inode 0x%p %cf extents 0x%p nextents %d nlists %d\n",
 			ip, "da"[whichfork], xfs_iext_get_ext(ifp, 0),
-			nextents);
+			   nextents,nlists);
 		for (i = 0; i < nextents; i++) {
-			xfs_bmbt_get_all(xfs_iext_get_ext(ifp, i), &irec);
+			rec_h = xfs_iext_get_ext(ifp, i);
+
+			if (ifp->if_flags & XFS_IFEXTIREC) {
+				xfs_ext_irec_t	*erp;		/* irec pointer */
+				int		erp_idx = 0;	/* irec index */
+				xfs_extnum_t	page_idx = i;	/* ext index in target list */
+				erp = xfs_iext_idx_to_irec(ifp, &page_idx, &erp_idx, 0);
+				kdb_printf("page_idx %d erp_idx %d\t",page_idx,erp_idx);
+			}
+			xfs_bmbt_get_all(rec_h, &irec);
 			kdb_printf(
-		"%d: startoff %Ld startblock %s blockcount %Ld flag %d\n",
-			i, irec.br_startoff,
+		"%d: addr 0x%p startoff %Ld startblock %s blockcount %Ld flag %d\n",
+		        i, rec_h, irec.br_startoff,
 			xfs_fmtfsblock(irec.br_startblock, ip->i_mount),
 			irec.br_blockcount, irec.br_state);
 		}

--------------040806040806040709080001--
