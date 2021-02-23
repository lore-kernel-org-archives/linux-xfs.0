Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D1E5C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 03:02:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D158B64E4B
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 03:02:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbhBWDBz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Feb 2021 22:01:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:47520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231286AbhBWDBs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Feb 2021 22:01:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57ADE64E6C;
        Tue, 23 Feb 2021 03:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614049291;
        bh=xu4I7Zho5aatS468G2ieDU6Sn9deTfMztZnfSIbgVX0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lrsWHtZGXAikTsL0/IoqqJkrVJqlGVQ8Ip9ReyVZzRzSG7tKqwmTodl2M8qAY5rlP
         dVBEuTsCYPczq6QB++Hf2ak7fLjRNUitYU1d+s2Hx5O1iHhmBZVrQVYJfsFjbex9Tz
         vGe4XkGgl6523TkNuO9oOClOGLibQY0CVVJg40CJYZpAdHhzXz/hQ5CjyjLRkMsAES
         wI5s5bmYr7CsYMSQdx3bPdPpSfXhfHyYs4wHiqUm7BYyYHlbciOQU/ASO2p3vyrrRv
         L+dptI/121mTc1pveVM6YSrjzz44u87V3zCoy+g7RTdkWpAARG786MuP31iAePptYn
         xSte6PYjeJEGw==
Subject: [PATCH 1/5] man: mark all deprecated V4 format options
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, bfoster@redhat.com
Date:   Mon, 22 Feb 2021 19:01:30 -0800
Message-ID: <161404929091.425731.465351236842105610.stgit@magnolia>
In-Reply-To: <161404928523.425731.7157248967184496592.stgit@magnolia>
References: <161404928523.425731.7157248967184496592.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Update the manual pages for the most popular tools to note which options
are only useful with the V4 XFS format, and that the V4 format is
deprecated and will be removed no later than September 2030.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man8/mkfs.xfs.8  |   16 ++++++++++++++++
 man/man8/xfs_admin.8 |   10 ++++++++++
 2 files changed, 26 insertions(+)


diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index fac82d74..df25abaa 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -223,6 +223,11 @@ of calculating and checking the CRCs is not noticeable in normal operation.
 By default,
 .B mkfs.xfs
 will enable metadata CRCs.
+.IP
+Formatting a filesystem without CRCs selects the V4 format, which is deprecated
+and will be removed from upstream in September 2030.
+Distributors may choose to withdraw support for the V4 format earlier than
+this date.
 .TP
 .BI finobt= value
 This option enables the use of a separate free inode btree index in each
@@ -592,6 +597,8 @@ This option can be used to turn off inode alignment when the
 filesystem needs to be mountable by a version of IRIX
 that does not have the inode alignment feature
 (any release of IRIX before 6.2, and IRIX 6.2 without XFS patches).
+.IP
+This option only applies to the deprecated V4 format.
 .TP
 .BI attr= value
 This is used to specify the version of extended attribute inline
@@ -602,6 +609,8 @@ between attribute and extent data.
 The previous version 1, which has fixed regions for attribute and
 extent data, is kept for backwards compatibility with kernels older
 than version 2.6.16.
+.IP
+This option only applies to the deprecated V4 format.
 .TP
 .BI projid32bit[= value ]
 This is used to enable 32bit quota project identifiers. The
@@ -609,6 +618,8 @@ This is used to enable 32bit quota project identifiers. The
 is either 0 or 1, with 1 signifying that 32bit projid are to be enabled.
 If the value is omitted, 1 is assumed.  (This default changed
 in release version 3.2.0.)
+.IP
+This option only applies to the deprecated V4 format.
 .TP
 .BI sparse[= value ]
 Enable sparse inode chunk allocation. The
@@ -690,6 +701,7 @@ stripe-aligned log writes (see the sunit and su options, below).
 The previous version 1, which is limited to 32k log buffers and does
 not support stripe-aligned writes, is kept for backwards compatibility
 with very old 2.4 kernels.
+This option only applies to the deprecated V4 format.
 .TP
 .BI sunit= value
 This specifies the alignment to be used for log writes. The
@@ -744,6 +756,8 @@ is 1 (on) so you must specify
 .B lazy-count=0
 if you want to disable this feature for older kernels which don't support
 it.
+.IP
+This option only applies to the deprecated V4 format.
 .RE
 .PP
 .PD 0
@@ -803,6 +817,8 @@ will be stored in the directory structure.  The default value is 1.
 When CRCs are enabled (the default), the ftype functionality is always
 enabled, and cannot be turned off.
 .IP
+This option only applies to the deprecated V4 format.
+.IP
 .RE
 .TP
 .BI \-p " protofile"
diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index cccbb224..5ef99316 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -54,6 +54,8 @@ for a detailed description of the XFS log.
 Enables unwritten extent support on a filesystem that does not
 already have this enabled (for legacy filesystems, it can't be
 disabled anymore at mkfs time).
+.IP
+This option only applies to the deprecated V4 format.
 .TP
 .B \-f
 Specifies that the filesystem image to be processed is stored in a
@@ -67,12 +69,16 @@ option).
 .B \-j
 Enables version 2 log format (journal format supporting larger
 log buffers).
+.IP
+This option only applies to the deprecated V4 format.
 .TP
 .B \-l
 Print the current filesystem label.
 .TP
 .B \-p
 Enable 32bit project identifier support (PROJID32BIT feature).
+.IP
+This option only applies to the deprecated V4 format.
 .TP
 .B \-u
 Print the current filesystem UUID (Universally Unique IDentifier).
@@ -83,6 +89,8 @@ Enable (1) or disable (0) lazy-counters in the filesystem.
 Lazy-counters may not be disabled on Version 5 superblock filesystems
 (i.e. those with metadata CRCs enabled).
 .IP
+In other words, this option only applies to the deprecated V4 format.
+.IP
 This operation may take quite a bit of time on large filesystems as the
 entire filesystem needs to be scanned when this option is changed.
 .IP
@@ -92,6 +100,8 @@ information is kept in other parts of the filesystem to be able to
 maintain the counter values without needing to keep them in the
 superblock. This gives significant improvements in performance on some
 configurations and metadata intensive workloads.
+.IP
+This option only applies to the deprecated V4 format.
 .TP
 .BI \-L " label"
 Set the filesystem label to

