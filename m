Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35818 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726907AbfDPMBB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 16 Apr 2019 08:01:01 -0400
Date: Tue, 16 Apr 2019 08:00:59 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Assertions tripping in xfs/104
Message-ID: <20190416120056.GA14042@bfoster>
References: <20190416015328.GL4752@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190416015328.GL4752@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Apr 15, 2019 at 06:53:28PM -0700, Darrick J. Wong wrote:
> Hi Brian,
> 
> When running fstests against what will become the xfs-5.2-merge tree, I
> hit an assert in xfs/104; the dmesg for that is pasted below.
> 
> I'm pretty sure that what's going on here is that we hit a deferred AGFL
> free while growing the filesystem and need to do a defer_roll, but
> tr_growdata is not one of the permanent reservation transactions and
> that's why we trip some asserts.
> 

Yeah, it looks like we can hit this in the case where a growfs extends
the last pre-existing AG in the fs. We "free" the additional space into
the AG, happen to come across an overpopulated AGFL and end up doing
deferred ops from a non-permanent transaction.

I think we should probably just update the tr_growdata transaction to
reflect how it's used and mark it permanent with the default permanent
log count (2). That obviously increases the reservation size, but it's
not like grow is a high frequency or performance critical operation.

> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 mtr01 5.1.0-rc5-djw
> MKFS_OPTIONS  -- -f -m reflink=1,rmapbt=1, -i sparse=1, -b size=1024, /dev/sdd
> MOUNT_OPTIONS -- -o usrquota,grpquota,prjquota, /dev/sdd /opt
> 
> Granted this is the first time I've seen this in several months of
> nightly fstests runs, so chances are this one is hard to reproduce.
> 

I don't recall seeing this and don't reproduce in a few iterations of
xfs/104 with the above geometry. I'll keep trying for a bit. In the
meantime, a diff is appended if you'd like to give that a try. Thoughts?

Brian

--- 8< ---

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index f99a7aefe418..83f4ee2afc49 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -876,9 +876,13 @@ xfs_trans_resv_calc(
 	resp->tr_sb.tr_logres = xfs_calc_sb_reservation(mp);
 	resp->tr_sb.tr_logcount = XFS_DEFAULT_LOG_COUNT;
 
+	/* growdata requires permanent res; it can free space to the last AG */
+	resp->tr_growdata.tr_logres = xfs_calc_growdata_reservation(mp);
+	resp->tr_growdata.tr_logcount = XFS_DEFAULT_PERM_LOG_COUNT;
+	resp->tr_growdata.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
 	/* The following transaction are logged in logical format */
 	resp->tr_ichange.tr_logres = xfs_calc_ichange_reservation(mp);
-	resp->tr_growdata.tr_logres = xfs_calc_growdata_reservation(mp);
 	resp->tr_fsyncts.tr_logres = xfs_calc_swrite_reservation(mp);
 	resp->tr_writeid.tr_logres = xfs_calc_writeid_reservation(mp);
 	resp->tr_attrsetrt.tr_logres = xfs_calc_attrsetrt_reservation(mp);
