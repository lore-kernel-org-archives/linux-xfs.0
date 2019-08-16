Return-Path: <SRS0=CZ9Z=WM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF076C3A59C
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Aug 2019 06:35:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85EE32077C
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Aug 2019 06:35:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Fxy7QOZW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbfHPGfz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Aug 2019 02:35:55 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49406 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfHPGfz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Aug 2019 02:35:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=VtafC2w2AlJZTHOaatCCHxnljZRB+B/F5sz1Olj1F8A=; b=Fxy7QOZWk2Y1vW3/eJwPtBykx/
        /hRcbEgImCB+vKJlqcmKwmlZsq4ni6pfNIn4oAgvdipdElUEOPMLS3vevWKQZ9TMUxuURtEFXL5j1
        vFI3HZay7jERwVmK3ieyw8R1FB98ZaTXn7hdRgrv3kMo7WpUJvnim0F8GglH5pQ6b064rhUOK4Fw9
        6Ub2DIZHG3Llgu/1K3PJL3rFjpj5JpDlOJeYAOuNI5FP1jObCZUMvNmBvb2d6lL1EYDpneVn69U6M
        VhwdqbhBhyo6bMtvQ36RwYqO91zBD8m3f1xxE33/Cp8TIkYyE5BjWp/+ERZNv7P9xkxk9twKsjiTk
        rG00gM2Q==;
Received: from [2001:4bb8:18c:28b5:44f9:d544:957f:32cb] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hyVq6-0001ua-CG; Fri, 16 Aug 2019 06:35:54 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 1/2] xfs: fall back to native ioctls for unhandled compat ones
Date:   Fri, 16 Aug 2019 08:35:46 +0200
Message-Id: <20190816063547.1592-2-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190816063547.1592-1-hch@lst.de>
References: <20190816063547.1592-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Always try the native ioctl if we don't have a compat handler.  This
removes a lot of boilerplate code as 'modern' ioctls should generally
be compat clean, and fixes the missing entries for the recently added
FS_IOC_GETFSLABEL/FS_IOC_SETFSLABEL ioctls.

Fixes: f7664b31975b ("xfs: implement online get/set fs label")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl32.c | 54 ++------------------------------------------
 1 file changed, 2 insertions(+), 52 deletions(-)

diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 7fcf7569743f..bae08ef92ac3 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -553,57 +553,6 @@ xfs_file_compat_ioctl(
 	trace_xfs_file_compat_ioctl(ip);
 
 	switch (cmd) {
-	/* No size or alignment issues on any arch */
-	case XFS_IOC_DIOINFO:
-	case XFS_IOC_FSGEOMETRY_V4:
-	case XFS_IOC_FSGEOMETRY:
-	case XFS_IOC_AG_GEOMETRY:
-	case XFS_IOC_FSGETXATTR:
-	case XFS_IOC_FSSETXATTR:
-	case XFS_IOC_FSGETXATTRA:
-	case XFS_IOC_FSSETDM:
-	case XFS_IOC_GETBMAP:
-	case XFS_IOC_GETBMAPA:
-	case XFS_IOC_GETBMAPX:
-	case XFS_IOC_FSCOUNTS:
-	case XFS_IOC_SET_RESBLKS:
-	case XFS_IOC_GET_RESBLKS:
-	case XFS_IOC_FSGROWFSLOG:
-	case XFS_IOC_GOINGDOWN:
-	case XFS_IOC_ERROR_INJECTION:
-	case XFS_IOC_ERROR_CLEARALL:
-	case FS_IOC_GETFSMAP:
-	case XFS_IOC_SCRUB_METADATA:
-	case XFS_IOC_BULKSTAT:
-	case XFS_IOC_INUMBERS:
-		return xfs_file_ioctl(filp, cmd, p);
-#if !defined(BROKEN_X86_ALIGNMENT) || defined(CONFIG_X86_X32)
-	/*
-	 * These are handled fine if no alignment issues.  To support x32
-	 * which uses native 64-bit alignment we must emit these cases in
-	 * addition to the ia-32 compat set below.
-	 */
-	case XFS_IOC_ALLOCSP:
-	case XFS_IOC_FREESP:
-	case XFS_IOC_RESVSP:
-	case XFS_IOC_UNRESVSP:
-	case XFS_IOC_ALLOCSP64:
-	case XFS_IOC_FREESP64:
-	case XFS_IOC_RESVSP64:
-	case XFS_IOC_UNRESVSP64:
-	case XFS_IOC_FSGEOMETRY_V1:
-	case XFS_IOC_FSGROWFSDATA:
-	case XFS_IOC_FSGROWFSRT:
-	case XFS_IOC_ZERO_RANGE:
-#ifdef CONFIG_X86_X32
-	/*
-	 * x32 special: this gets a different cmd number from the ia-32 compat
-	 * case below; the associated data will match native 64-bit alignment.
-	 */
-	case XFS_IOC_SWAPEXT:
-#endif
-		return xfs_file_ioctl(filp, cmd, p);
-#endif
 #if defined(BROKEN_X86_ALIGNMENT)
 	case XFS_IOC_ALLOCSP_32:
 	case XFS_IOC_FREESP_32:
@@ -705,6 +654,7 @@ xfs_file_compat_ioctl(
 	case XFS_IOC_FSSETDM_BY_HANDLE_32:
 		return xfs_compat_fssetdm_by_handle(filp, arg);
 	default:
-		return -ENOIOCTLCMD;
+		/* try the native version */
+		return xfs_file_ioctl(filp, cmd, p);
 	}
 }
-- 
2.20.1

