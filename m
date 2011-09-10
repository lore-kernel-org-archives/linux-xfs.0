Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8AIUVcb121725 for <xfs@oss.sgi.com>; Sat, 10 Sep 2011 13:30:31 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BC7F81524B31
	for <xfs@oss.sgi.com>; Sat, 10 Sep 2011 11:34:52 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	SeBiTSNlebgMdEqE for <xfs@oss.sgi.com>;
	Sat, 10 Sep 2011 11:34:52 -0700 (PDT)
Date: Sat, 10 Sep 2011 14:30:28 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS: Observed Crash followed by deadlock of khubd/sync/XFS
Message-ID: <20110910183028.GA23537@infradead.org>
References: <CADDb1s2QDk7y+JgMikoje35LviYQwzpgFihndUPuZx2VXYV4Ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
In-Reply-To: <CADDb1s2QDk7y+JgMikoje35LviYQwzpgFihndUPuZx2VXYV4Ew@mail.gmail.com>
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
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: xfs@oss.sgi.com


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 08, 2011 at 04:35:28PM +0530, Amit Sahrawat wrote:
> Kernel Version: 2.6.39.4
> Target: ARM
> 
> Observed while doing:
> Copy some file (any size, I tried with 10MB, 100MB) to XFS partition
> After Copy do???sync???
> Now immediately, unplug the device.

Does this still happen with the patch below applied?


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="xfs-fix-synchronous-writes.diff"

commit 9e978d8f7db1c5de7cdc6450a8ca208db3b95f84
Author: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Date:   Fri Jul 29 07:42:59 2011 +0000

    "xfs: fix error handling for synchronous writes" revisited
    
    xfs: fix for hang during synchronous buffer write error
    
    If removed storage while synchronous buffer write underway,
    "xfslogd" hangs.
    
    Detailed log http://oss.sgi.com/archives/xfs/2011-07/msg00740.html
    
    Related work bfc60177f8ab509bc225becbb58f7e53a0e33e81
    "xfs: fix error handling for synchronous writes"
    
    Given that xfs_bwrite actually does the shutdown already after
    waiting for the b_iodone completion and given that we actually
    found that calling xfs_force_shutdown from inside
    xfs_buf_iodone_callbacks was a major contributor the problem
    it better to drop this call.
    
    Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Alex Elder <aelder@sgi.com>

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 0402173..cac2ecf 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1010,7 +1010,6 @@ xfs_buf_iodone_callbacks(
 	XFS_BUF_UNDELAYWRITE(bp);
 
 	trace_xfs_buf_error_relse(bp, _RET_IP_);
-	xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
 
 do_callbacks:
 	xfs_buf_do_callbacks(bp);

--DocE+STaALJfprDB
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--DocE+STaALJfprDB--
