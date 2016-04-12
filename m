Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7C44E7CA0
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 06:47:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 50E108F8037
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 04:47:21 -0700 (PDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com
	[74.125.82.43]) by cuda.sgi.com with ESMTP id uwLea7SQiimmxZdK
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 12 Apr 2016 04:47:15 -0700 (PDT)
Received: by mail-wm0-f43.google.com with SMTP id v188so123581272wme.1
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 04:47:15 -0700 (PDT)
From: Shyam Kaushik <shyam@zadarastorage.com>
References: <23e35813cb097c7b15686852500cbf97@mail.gmail.com>
	<20160412082759.GI9088@dastard>
In-Reply-To: <20160412082759.GI9088@dastard>
MIME-Version: 1.0
Date: Tue, 12 Apr 2016 17:17:13 +0530
Message-ID: <107cf9c2690aa00fcdd74b15198fbbdf@mail.gmail.com>
Subject: RE: [PATCH] xfs: Abort intent log item in xfs_iflush() upon error to
	get buf
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi Dave,

With your patch, I ran into below OOPs once. With "if (bp)" check before
xfs_buf_relse() I am not sure how this happened. I will re-run the tests
few more times & get back to you.

[  514.010390] XFS (dm-10): xfs_imap_to_bp: xfs_trans_read_buf() returned
error -5.
[  514.010410] BUG: unable to handle kernel NULL pointer dereference at
000000000000003f
[  514.010415] IP: [<ffffffff81717137>] _raw_spin_lock_irqsave+0x27/0x60
[  514.010422] PGD 7b9b067 PUD 7545067 PMD 0
[  514.010424] Oops: 0002 [#2] PREEMPT SMP
[  514.010486] task: ffff88001dd3bcc0 ti: ffff880007a9c000 task.ti:
ffff880007a9c000
[  514.010488] RIP: 0010:[<ffffffff81717137>]  [<ffffffff81717137>]
_raw_spin_lock_irqsave+0x27/0x60
[  514.010491] RSP: 0018:ffff880007a9f538  EFLAGS: 00010082
[  514.010492] RAX: 0000000000000296 RBX: 000000000000003f RCX:
0000000000003dfc
[  514.010492] RDX: 0000000000020000 RSI: 000000003dfe3dfc RDI:
000000000000003f
[  514.010493] RBP: ffff880007a9f538 R08: 0000000000000296 R09:
ffffffff81ecadf4
[  514.010494] R10: 000000000001675c R11: 0000000000000001 R12:
000000000000000f
[  514.010494] R13: ffff880009471000 R14: ffff880007a9f610 R15:
0000000000000000
[  514.010496] FS:  00007f0ba69e1840(0000) GS:ffff88007fc00000(0000)
knlGS:0000000000000000
[  514.010498] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  514.010499] CR2: 000000000000003f CR3: 000000001e313000 CR4:
00000000000007f0
[  514.010504] Stack:
[  514.010506]  ffff880007a9f568 ffffffff810b9236 ffffea000109fec0
0000000000000000
[  514.010507]  00000000368bb6a0 ffff880003406400 ffff880007a9f598
ffffffffc07b661e
[  514.010508]  ffff8800034064e4 ffff880003406400 000000000000000f
ffff880009471000
[  514.010511] Call Trace:
[  514.010515]  [<ffffffff810b9236>] up+0x16/0x50
[  514.010544]  [<ffffffffc07b661e>] xfs_buf_unlock+0x1e/0x90 [xfs]
[  514.010562]  [<ffffffffc07ce31f>] xfs_iflush+0xcf/0x290 [xfs]
[  514.010580]  [<ffffffffc07c2195>] xfs_reclaim_inode+0xd5/0x340 [xfs]
[  514.010597]  [<ffffffffc07c2633>] xfs_reclaim_inodes_ag+0x233/0x370
[xfs]
[  514.010614]  [<ffffffffc07c3323>] xfs_reclaim_inodes_nr+0x33/0x40 [xfs]
[  514.010632]  [<ffffffffc07d2df5>] xfs_fs_free_cached_objects+0x15/0x20
[xfs]
[  514.010637]  [<ffffffff811eb459>] super_cache_scan+0x169/0x170
[  514.010639]  [<ffffffff81182db8>] shrink_slab_node+0x138/0x2f0
[  514.010641]  [<ffffffff811d9197>] ? mem_cgroup_iter+0x257/0x470
[  514.010644]  [<ffffffff811847fb>] shrink_slab+0x8b/0x160
[  514.010646]  [<ffffffff8118796f>] do_try_to_free_pages+0x34f/0x4a0
[  514.010648]  [<ffffffff81187b7a>] try_to_free_pages+0xba/0x1a0
[  514.010652]  [<ffffffff8117b0b4>] __alloc_pages_nodemask+0x664/0xaa0
[  514.010655]  [<ffffffff811bf227>] alloc_pages_current+0x97/0x110
[  514.010658]  [<ffffffff811723b7>] __page_cache_alloc+0xa7/0xc0
[  514.010660]  [<ffffffff8117ec78>] __do_page_cache_readahead+0x108/0x250
[  514.010662]  [<ffffffff811f6115>] ? do_last+0x185/0x1220
[  514.010670]  [<ffffffff811f23a8>] ? inode_permission+0x18/0x50
[  514.010672]  [<ffffffff8117ef08>] ondemand_readahead+0x148/0x2a0
[  514.010674]  [<ffffffff8117260c>] ? pagecache_get_page+0x2c/0x1e0
[  514.010676]  [<ffffffff8117f1e1>] page_cache_sync_readahead+0x31/0x50
[  514.010679]  [<ffffffff81173979>] generic_file_read_iter+0x409/0x5f0
[  514.010681]  [<ffffffff811e73fe>] new_sync_read+0x7e/0xb0
[  514.010683]  [<ffffffff811e7c3c>] vfs_read+0x9c/0x180
[  514.010686]  [<ffffffff811e87a6>] SyS_read+0x46/0xb0
[  514.010688]  [<ffffffff817179cd>] system_call_fastpath+0x16/0x1b

Thanks.

--Shyam

-----Original Message-----
From: Dave Chinner [mailto:david@fromorbit.com]
Sent: 12 April 2016 13:58
To: Shyam Kaushik
Cc: xfs@oss.sgi.com
Subject: Re: [PATCH] xfs: Abort intent log item in xfs_iflush() upon error
to get buf

On Tue, Apr 12, 2016 at 12:27:30PM +0530, Shyam Kaushik wrote:
> Looking at xfs_iflush(). If an IO fails, it is supposed to unlock the
> inode by calling xfs_iflush_abort(), which will also remove it from
> the AIL. This can also happen on reclaim of a dirty inode, and if so
> we'll still reclaim the inode because reclaim assumes xfs_iflush()
> cleans up properly. Which, apparently, it doesn't.
>
> Fix xfs_iflush() buf get failure to remove intent log item.
>
> Discovered-by: Dave Chinner <dchinner at redhat.com>
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 96f606d..85414a6 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3374,8 +3374,9 @@ xfs_iflush(
>         error = xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &bp,
> XBF_TRYLOCK,
>                                0);
>         if (error || !bp) {
> -               xfs_ifunlock(ip);
> -               return error;
> +               if (!bp)
> +                       error = -EIO;
> +               goto abort_out;

So that will trigger a failure whenever the underlying buffer is
busy (i.e. returns -EAGAIN with bp NULL), not just when an IO
or corruption error occurs. The hammer is too big. ;)

Great proof of concept, though, as your testing results tell us you
have found the root cause of the bug. The patch I wrote earlier
today takes the EAGAIN case into account - I'm currently testing it,
and have attached it below. Can you run it through your error
testing, please, Shyam?

I'll update all the reported-by, etc attributions before I post it
for proper review.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: xfs_iflush_cluster fails to abort on error

From: Dave Chinner <dchinner@redhat.com>

When a failure due to an inode buffer occurs, the error handling
fails to abort the inode writeback correctly. This can result in the
inode being reclaimed whilst still in the AIL, leading to
use-after-free situations as well as filesystems that cannot be
unmounted as the inode log items left in the AIL never get removed.

Fix this by ensuring fatal errors from xfs_imap_to_bp() result in
the inode flush being aborted correctly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5b84bbc..e1a8020 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3378,14 +3378,22 @@ xfs_iflush(
 	}

 	/*
-	 * Get the buffer containing the on-disk inode.
+	 * Get the buffer containing the on-disk inode. We are doing a
try-lock
+	 * operation here, so we may get  an EAGAIN error. In that case,
we
+	 * simply want to return with the inode still dirty.
+	 *
+	 * If we get any other error, we effectively have a corruption
situation
+	 * and we cannot flush the inode, so we treat it the same as
failing
+	 * xfs_iflush_int().
 	 */
 	error = xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &bp,
XBF_TRYLOCK,
 			       0);
-	if (error || !bp) {
+	if (error == -EAGAIN) {
 		xfs_ifunlock(ip);
 		return error;
 	}
+	if (error)
+		goto corrupt_out;

 	/*
 	 * First flush out the inode that xfs_iflush was called with.
@@ -3413,7 +3421,8 @@ xfs_iflush(
 	return 0;

 corrupt_out:
-	xfs_buf_relse(bp);
+	if (bp)
+		xfs_buf_relse(bp);
 	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 cluster_corrupt_out:
 	error = -EFSCORRUPTED;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
