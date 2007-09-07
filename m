Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 06 Sep 2007 19:00:35 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8720Q4p020041
	for <xfs@oss.sgi.com>; Thu, 6 Sep 2007 19:00:29 -0700
Message-ID: <46E0B154.1000805@sgi.com>
Date: Fri, 07 Sep 2007 12:03:00 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] log replay should not overwrite newer ondisk inodes
References: <46D6279F.40601@sgi.com> <46D6480F.4040307@sgi.com> <46D64CAD.6050705@sgi.com> <46D67FE6.20205@sgi.com> <46D68510.1020404@sgi.com> <46D77B79.3040104@sgi.com> <46D792A1.7030308@sgi.com> <20070831154822.GD734179@sgi.com>
In-Reply-To: <20070831154822.GD734179@sgi.com>
Content-Type: multipart/mixed;
 boundary="------------020202030406060709080005"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Mark Goodwin <markgw@sgi.com>, Timothy Shimmin <tes@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

This is a multi-part message in MIME format.
--------------020202030406060709080005
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

David Chinner wrote:
> On Fri, Aug 31, 2007 at 02:01:37PM +1000, Mark Goodwin wrote:
>> Lachlan McIlroy wrote:
>>> Timothy Shimmin wrote:
>>>> Timothy Shimmin wrote:
>>>>>>>  But I'm not sure this is an error...
>>>>>>>  Hmmmm...I'm a bit confused.
>>>>>>>  So you are _almost_ combining an error check with a flushiter check?
>>>>>>>  If one buffer is an inode magic# and the other isn't then we
>>>>>>>  have an error right - and could report it - but we are not doing 
>>>>>>> that here.
>>>>>> Not exactly.  If what's on disk is not an inode but the log item is
>>>>>> then that could be because we haven't written the inode to disk yet
>>>>>> and we need to perform recovery.
>>>>> Yeah, I was thinking about that afterward.
>>>>> The item's format which gives the blk# for the buf to read could
>>>>> be a block which hasn't been used for an inode yet.
>>>>>
>>>> Well, if what's on disk is not an inode but some other data
>>>> and it happens to have the inode magic# which is remotely possible,
>>>> then we are making a bad assumption.
>>>> i.e. if we're not sure what the block/buffer should be, then testing the
>>>> MAGIC# isn't a guarantee it's an inode then.
>>>> Well not for the freeing of inode clusters case I would assume.
>>>> Or am I missing something?
>>> I don't think you're missing anything!
>>>
>>> You're right though - a magic number check is no guarantee.  On the same
>>> vein, adding a generation number check isn't much better.
>> unlink will have to invalidate the on-disk inode magic number? Or only
>> when the whole cluster is free'd?
> 
> An unlinked inode is only detectable by the mode parameter being zero.
> The rest of the inode will look valid.
> 
> To detect the difference between a newly allocated inode *chunk*
> that has been written to and a stale inode chunk that we have
> just allocated and not written to yet, you need to walk every inode
> in the chunk and determine if the mode parameter is zero in every
> inode.
> 
> If the mode is zero for all inodes and there are generation numbers
> that are not zero, then you've detected a stale buffer and you should
> replay the inode cluster buffer initialisation.
> 

Thanks for this info Dave.  I looked into it and came up with a solution
that looks at the ondisk inode buffer and determines if it has been
written to since being logged.  It iterates through all the inodes and
checks each one with:

- if the magic number is wrong the buffer is stale
- if the mode is non-zero then the buffer is newer than the log
- if the mode is zero and the generation count is non-zero then the
   buffer is stale

If the end result is a stale buffer then the buffer is replayed otherwise
it is skipped.  I added a new flag that gets logged with a new inode
cluster so that we can identify a buffer of inodes from something else.
This fix is passing all the tests we have.  Is this a better approach
than the last fix?

Lachlan

--------------020202030406060709080005
Content-Type: text/x-patch;
 name="xfs_log_recover.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xfs_log_recover.diff"

--- fs/xfs/xfs_buf_item.h_1.44	2007-09-04 13:38:24.000000000 +1000
+++ fs/xfs/xfs_buf_item.h	2007-09-06 12:06:39.000000000 +1000
@@ -52,6 +52,11 @@ typedef struct xfs_buf_log_format_t {
 #define	XFS_BLI_UDQUOT_BUF	0x4
 #define XFS_BLI_PDQUOT_BUF	0x8
 #define	XFS_BLI_GDQUOT_BUF	0x10
+/*
+ * This flag indicates that the buffer contains newly allocated
+ * inodes.
+ */
+#define	XFS_BLI_INODE_NEW_BUF	0x20
 
 #define	XFS_BLI_CHUNK		128
 #define	XFS_BLI_SHIFT		7
--- fs/xfs/xfs_log_recover.c_1.322	2007-08-27 17:45:45.000000000 +1000
+++ fs/xfs/xfs_log_recover.c	2007-09-07 10:41:38.000000000 +1000
@@ -1874,6 +1874,7 @@ xlog_recover_do_inode_buffer(
 /*ARGSUSED*/
 STATIC void
 xlog_recover_do_reg_buffer(
+	xfs_mount_t		*mp,
 	xlog_recover_item_t	*item,
 	xfs_buf_t		*bp,
 	xfs_buf_log_format_t	*buf_f)
@@ -1884,6 +1885,30 @@ xlog_recover_do_reg_buffer(
 	unsigned int		*data_map = NULL;
 	unsigned int		map_size = 0;
 	int                     error;
+	int			stale_buf = 1;
+
+	if (buf_f->blf_flags & XFS_BLI_INODE_NEW_BUF) {
+		xfs_dinode_t    *dip;
+		int             inodes_per_buf;
+
+		stale_buf = 0;
+		inodes_per_buf = XFS_BUF_COUNT(bp) >> mp->m_sb.sb_inodelog;
+		for (i = 0; i < inodes_per_buf; i++) {
+			dip = (xfs_dinode_t *)xfs_buf_offset(bp,
+				i * mp->m_sb.sb_inodesize);
+			if (be16_to_cpu(dip->di_core.di_magic) !=
+					XFS_DINODE_MAGIC) {
+				stale_buf = 1;
+				break;
+			}
+			if (be16_to_cpu(dip->di_core.di_mode))
+				break;
+			if (be16_to_cpu(dip->di_core.di_gen)) {
+				stale_buf = 1;
+				break;
+			}
+		}
+	}
 
 	switch (buf_f->blf_type) {
 	case XFS_LI_BUF:
@@ -1917,7 +1942,7 @@ xlog_recover_do_reg_buffer(
 					       -1, 0, XFS_QMOPT_DOWARN,
 					       "dquot_buf_recover");
 		}
-		if (!error)
+		if (!error && stale_buf)
 			memcpy(xfs_buf_offset(bp,
 				(uint)bit << XFS_BLI_SHIFT),	/* dest */
 				item->ri_buf[i].i_addr,		/* source */
@@ -2089,7 +2114,7 @@ xlog_recover_do_dquot_buffer(
 	if (log->l_quotaoffs_flag & type)
 		return;
 
-	xlog_recover_do_reg_buffer(item, bp, buf_f);
+	xlog_recover_do_reg_buffer(mp, item, bp, buf_f);
 }
 
 /*
@@ -2190,7 +2215,7 @@ xlog_recover_do_buffer_trans(
 		  (XFS_BLI_UDQUOT_BUF|XFS_BLI_PDQUOT_BUF|XFS_BLI_GDQUOT_BUF)) {
 		xlog_recover_do_dquot_buffer(mp, log, item, bp, buf_f);
 	} else {
-		xlog_recover_do_reg_buffer(item, bp, buf_f);
+		xlog_recover_do_reg_buffer(mp, item, bp, buf_f);
 	}
 	if (error)
 		return XFS_ERROR(error);
--- fs/xfs/xfs_trans_buf.c_1.126	2007-09-04 13:38:27.000000000 +1000
+++ fs/xfs/xfs_trans_buf.c	2007-09-05 17:37:31.000000000 +1000
@@ -966,6 +966,7 @@ xfs_trans_inode_alloc_buf(
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 
 	bip->bli_flags |= XFS_BLI_INODE_ALLOC_BUF;
+	bip->bli_format.blf_flags |= XFS_BLI_INODE_NEW_BUF;
 }
 
 

--------------020202030406060709080005--
