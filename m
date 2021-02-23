Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E300C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 13:44:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6254864E3F
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 13:44:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbhBWNok (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 08:44:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37615 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232525AbhBWNoi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Feb 2021 08:44:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614087791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j6H6h+538HlCBVTPzh6u+revg3Y1sIhM9dUH3+plHfg=;
        b=Bd4TacNUsdSGsEEGkgApRwXGT1Zk72sR9dT1xg4MmVpcGFSg+QYFoh5BB/GIqtBY4V30G/
        /c2weXmjKiky+Dg6KLGtZaW6a6nVCSTJxVTgP5jaJw0JsC/UFtyYxR/y+hRKzcKn13Ilja
        AJ6FhBDJ/bXI1btvvJaiEgBvnE7ADDw=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-6xL9g1-4OO6l9NkzD_reKg-1; Tue, 23 Feb 2021 08:43:10 -0500
X-MC-Unique: 6xL9g1-4OO6l9NkzD_reKg-1
Received: by mail-pg1-f197.google.com with SMTP id m14so9761694pgr.9
        for <linux-xfs@vger.kernel.org>; Tue, 23 Feb 2021 05:43:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=j6H6h+538HlCBVTPzh6u+revg3Y1sIhM9dUH3+plHfg=;
        b=HlFl365jd/wNrlb7Lwkj8lW6DPv4SP4sy16r5s70qHE153ZSFsN2OoL2ZdiY51MoGv
         Vc/s1xD+VKND4zrEaGhthUvUKaouE6f0cKJbJdw6BcEiM9SVWx5H8xKMHKZ2SgwajPPI
         +gT92hCx3A4GZfuKYRd5lFb+M4qJ0BYKJDfCtfS40ufLR+Pm389Nttf7cchuqqzef7ji
         TtVOc7CP901q7g0PwUrEksRAeFsYT/LUI8g64ElWgPDHl2tkcG8PN3SaM78UkBXoX2nE
         5R7FXyKslfgxmpk2xwYZbOgWKHTzPfMCSe4tQuEKA4RQKnXBLwg1KuPFExre2PKWpwpi
         9UiA==
X-Gm-Message-State: AOAM533cY6fWpeBy5VgqtwrSC5NyL3nrm0srEEHB5w6+dQK0w6wObQWC
        oRsOUwbt9AiQTTasM9X2F2iX0wIpflIPYxiqhOZyd62f2DS2Ubls/erTjarp9f6MHc3eDrrzQyD
        50rUOQVeqt4lpfUDEXWrabXujPklIEHP/EUIQiKXVp6AAmeeNwCdb/jpTF061ULixtn2oTR+7KQ
        ==
X-Received: by 2002:a17:90a:d149:: with SMTP id t9mr25613970pjw.43.1614087788495;
        Tue, 23 Feb 2021 05:43:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxQB47YO2VPar9TMDuzdsrFQ0gzEudrM+9johaFEjXqxmbBJs3G/IiSXMuapkN7DOe1ML610Q==
X-Received: by 2002:a17:90a:d149:: with SMTP id t9mr25613947pjw.43.1614087788184;
        Tue, 23 Feb 2021 05:43:08 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s18sm21640085pfm.129.2021.02.23.05.43.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 05:43:07 -0800 (PST)
Date:   Tue, 23 Feb 2021 21:42:56 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 2/2] xfs: don't dirty snapshot logs for unlinked inode
 recovery
Message-ID: <20210223134256.GA1327978@xiangao.remote.csb>
References: <83696ce6-4054-0e77-b4b8-e82a1a9fbbc3@redhat.com>
 <896a0202-aac8-e43f-7ea6-3718591e32aa@sandeen.net>
 <20180324162049.GP4818@magnolia>
 <20180326124649.GD34912@bfoster.bfoster>
 <20180327211728.GP18129@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20180327211728.GP18129@dastard>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

On Wed, Mar 28, 2018 at 08:17:28AM +1100, Dave Chinner wrote:
> On Mon, Mar 26, 2018 at 08:46:49AM -0400, Brian Foster wrote:
> > On Sat, Mar 24, 2018 at 09:20:49AM -0700, Darrick J. Wong wrote:
> > > On Wed, Mar 07, 2018 at 05:33:48PM -0600, Eric Sandeen wrote:
> > > > Now that unlinked inode recovery is done outside of
> > > > log recovery, there is no need to dirty the log on
> > > > snapshots just to handle unlinked inodes.  This means
> > > > that readonly snapshots can be mounted without requiring
> > > > -o ro,norecovery to avoid the log replay that can't happen
> > > > on a readonly block device.
> > > > 
> > > > (unlinked inodes will just hang out in the agi buckets until
> > > > the next writable mount)
> > > 
> > > FWIW I put these two in a test kernel to see what would happen and
> > > generic/311 failures popped up.  It looked like the _check_scratch_fs
> > > found incorrect block counts on the snapshot(?)
> > > 
> > 
> > Interesting. Just a wild guess, but perhaps it has something to do with
> > lazy sb accounting..? I see we call xfs_initialize_perag_data() when
> > mounting an unclean fs.
> 
> The freeze is calls xfs_log_sbcount() which should update the
> superblock counters from the in-memory counters and write them to
> disk.
> 
> If they are out, I'm guessing it's because the in-memory per-ag
> reservations are not being returned to the global pool before the
> in-memory counters are summed during a freeze....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

I spend some time on tracking this problem. I've made a quick
modification with per-AG reservation and tested with generic/311
it seems fine. My current question is that how such fsfreezed
images (with clean mount) work with old kernels without [PATCH 1/1]?
I'm afraid orphan inodes won't be freed with such old kernels....
Am I missing something?

Thanks,
Gao Xiang

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 06041834daa3..79d6d8858dcf 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -963,12 +963,17 @@ xfs_log_quiesce(
 	return xfs_log_cover(mp);
 }
 
-void
+int
 xfs_log_clean(
 	struct xfs_mount	*mp)
 {
-	xfs_log_quiesce(mp);
+	int ret;
+
+	ret = xfs_log_quiesce(mp);
+	if (ret)
+		return ret;
 	xfs_log_unmount_write(mp);
+	return 0;
 }
 
 /*
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 044e02cb8921..4061a219bfde 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -139,7 +139,7 @@ bool	xfs_log_item_in_current_chkpt(struct xfs_log_item *lip);
 
 void	xfs_log_work_queue(struct xfs_mount *mp);
 int	xfs_log_quiesce(struct xfs_mount *mp);
-void	xfs_log_clean(struct xfs_mount *mp);
+int	xfs_log_clean(struct xfs_mount *mp);
 bool	xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
 bool	xfs_log_in_recovery(struct xfs_mount *);
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 97f31308de03..3ef21f589d6b 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3478,6 +3478,7 @@ xlog_recover_finish(
 						     : "internal");
 		log->l_flags &= ~XLOG_RECOVERY_NEEDED;
 	} else {
+		xlog_recover_process_iunlinks(log);
 		xfs_info(log->l_mp, "Ending clean mount");
 	}
 	return 0;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 21b1d034aca3..0db1e7e0e0c8 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -884,7 +884,7 @@ xfs_fs_freeze(
 {
 	struct xfs_mount	*mp = XFS_M(sb);
 	unsigned int		flags;
-	int			ret;
+	int			error;
 
 	/*
 	 * The filesystem is now frozen far enough that memory reclaim
@@ -893,10 +893,25 @@ xfs_fs_freeze(
 	 */
 	flags = memalloc_nofs_save();
 	xfs_blockgc_stop(mp);
+
+	/* Get rid of any leftover CoW reservations... */
+	error = xfs_blockgc_free_space(mp, NULL);
+	if (error) {
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		return error;
+	}
+
+	/* Free the per-AG metadata reservation pool. */
+	error = xfs_fs_unreserve_ag_blocks(mp);
+	if (error) {
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		return error;
+	}
+
 	xfs_save_resvblks(mp);
-	ret = xfs_log_quiesce(mp);
+	error = xfs_log_clean(mp);
 	memalloc_nofs_restore(flags);
-	return ret;
+	return error;
 }
 
 STATIC int
@@ -904,10 +919,26 @@ xfs_fs_unfreeze(
 	struct super_block	*sb)
 {
 	struct xfs_mount	*mp = XFS_M(sb);
+	int error;
 
 	xfs_restore_resvblks(mp);
 	xfs_log_work_queue(mp);
+
+	/* Recover any CoW blocks that never got remapped. */
+	error = xfs_reflink_recover_cow(mp);
+	if (error) {
+		xfs_err(mp,
+			"Error %d recovering leftover CoW allocations.", error);
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		return error;
+	}
+
 	xfs_blockgc_start(mp);
+
+	/* Create the per-AG metadata reservation pool .*/
+	error = xfs_fs_reserve_ag_blocks(mp);
+	if (error && error != -ENOSPC)
+		return error;
 	return 0;
 }
 
@@ -1440,7 +1471,6 @@ xfs_fs_fill_super(
 #endif
 	}
 
-	/* Filesystem claims it needs repair, so refuse the mount. */
 	if (xfs_sb_version_needsrepair(&mp->m_sb)) {
 		xfs_warn(mp, "Filesystem needs repair.  Please run xfs_repair.");
 		error = -EFSCORRUPTED;
-- 
2.18.1




