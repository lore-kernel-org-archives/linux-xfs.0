Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Mar 2008 15:16:34 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2OMGMDp022843
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2008 15:16:25 -0700
Date: Tue, 25 Mar 2008 09:16:45 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH]fix fbno in  xfs_dir2_node_addname_int
Message-ID: <20080324221645.GD103491721@sgi.com>
References: <47E5A982.8010002@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E5A982.8010002@gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Kevin Xu <cgxu.gg@gmail.com>
Cc: xfscn@googlegroups.com, xfs@oss.sgi.com

On Sun, Mar 23, 2008 at 08:51:14AM +0800, Kevin Xu wrote:
> if we didn't find a freespace block for our new entry  in the current 
> freeindex block, 
> return to the first freeindex block and continue to check.

What is the test case that demonstrates this problem?

Looking at the impact of setting fbno = -1 if we don't find a
suitable free space, the next iteration of the loop will do:

   1454                 if (fbp == NULL) {
   1455                         /*
   1456                          * Happens the first time through unless lookup gave
   1457                          * us a freespace block to start with.
   1458                          */
   1459                         if (++fbno == 0)
   1460                                 fbno = XFS_DIR2_FREE_FIRSTDB(mp);

and

define XFS_DIR2_FREE_FIRSTDB(mp)       \
        xfs_dir2_byte_to_db(mp, XFS_DIR2_FREE_OFFSET)

Is a fixed offset into the directory. Hence resetting fbno = -1 will
force us to look up the same freespace block on every loop iteration.
That looks like it will livelock as soon as the first free space block
does not have enough space for the desired entry......

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
