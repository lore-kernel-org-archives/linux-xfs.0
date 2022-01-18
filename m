Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86DEFC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Jan 2022 18:30:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348021AbiARSaJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Jan 2022 13:30:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347746AbiARSaI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jan 2022 13:30:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE59C061574
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jan 2022 10:30:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F162EB8173F
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jan 2022 18:30:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87890C340E0;
        Tue, 18 Jan 2022 18:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642530605;
        bh=fHroJTZpdnIHRc0uuHibqmSnjtTUPJCtec7Own1v8Fs=;
        h=Date:From:To:Cc:Subject:From;
        b=ePhINX3G2ir7OfJ5sI3e2qWgSxB22UT3NywxsGJhLp211juRFQ4mevtaKStnrYsvJ
         0xsCcdHuq/GwIuA0OFA5IkPSEQm0bm8caQdpyCSj4TKXrbagLorHegb669R8AaTgV0
         hmDZn/8qeEFgMkAWBvpL3PF7rHXECbZ9W1PQRoWQrygL6NN2BT0vXHs0OzuH/Ba2/d
         CELMkS0PvkuYXli2pWR9hCPqmBuIMOqnz3wnIU6/IX5phZfUfHT/SSVq4EAiJhK9Fy
         k0EuQy2eRJmAj1nQza5hO0ZVsC8L0P3JpBBe7RIcmvu8VTe3Y8RqJPe0yhmw8bVMKm
         2OkOZnKESDWkQ==
Date:   Tue, 18 Jan 2022 10:30:05 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: remove unused xfs_ioctl32.h declarations
Message-ID: <20220118183005.GD13540@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Remove these unused ia32 compat declarations; all the bits involved have
either been withdrawn or hoisted to the VFS.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_ioctl32.h |   18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/fs/xfs/xfs_ioctl32.h b/fs/xfs/xfs_ioctl32.h
index fc5a91f3a5e0..c14852362fce 100644
--- a/fs/xfs/xfs_ioctl32.h
+++ b/fs/xfs/xfs_ioctl32.h
@@ -142,24 +142,6 @@ typedef struct compat_xfs_fsop_attrmulti_handlereq {
 	_IOW('X', 123, struct compat_xfs_fsop_attrmulti_handlereq)
 
 #ifdef BROKEN_X86_ALIGNMENT
-/* on ia32 l_start is on a 32-bit boundary */
-typedef struct compat_xfs_flock64 {
-	__s16		l_type;
-	__s16		l_whence;
-	__s64		l_start	__attribute__((packed));
-			/* len == 0 means until end of file */
-	__s64		l_len __attribute__((packed));
-	__s32		l_sysid;
-	__u32		l_pid;
-	__s32		l_pad[4];	/* reserve area */
-} compat_xfs_flock64_t;
-
-#define XFS_IOC_RESVSP_32	_IOW('X', 40, struct compat_xfs_flock64)
-#define XFS_IOC_UNRESVSP_32	_IOW('X', 41, struct compat_xfs_flock64)
-#define XFS_IOC_RESVSP64_32	_IOW('X', 42, struct compat_xfs_flock64)
-#define XFS_IOC_UNRESVSP64_32	_IOW('X', 43, struct compat_xfs_flock64)
-#define XFS_IOC_ZERO_RANGE_32	_IOW('X', 57, struct compat_xfs_flock64)
-
 typedef struct compat_xfs_fsop_geom_v1 {
 	__u32		blocksize;	/* filesystem (data) block size */
 	__u32		rtextsize;	/* realtime extent size		*/
