Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89F91C07E99
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 04:12:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F07A6138C
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 04:12:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbhGIEOx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Jul 2021 00:14:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229441AbhGIEOw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Jul 2021 00:14:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD1F86143C
        for <linux-xfs@vger.kernel.org>; Fri,  9 Jul 2021 04:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625803929;
        bh=czKkOdGYjhYfNDdjOtZayBE13mY7B1XFobgp83NPPW8=;
        h=Date:From:To:Subject:From;
        b=kvlzxuvfjECrkqqkcBrRCPrcYj/sX+3K+sRd/GPTvvDmNfhoIRWbdC/1dKlPhd9as
         pAynnKNxUrf4FjZmas2T2wuxJBDGMqnygt1eTVxa6pOa36KWSxk3nxNRzd7Drl7aqp
         t7BkeA3wIsMOXUu/yUhZSUQ/cpf4508Q2GyPQnTCi/SlqNMC+c3snFJ23wN9+8ysCR
         LDKlBVJ8GSM+ekCDRGLixBzD31Dn5/XMcPJaUZaWokM+rzJ7QbMfAlAwgHf1c6txmB
         gHxkAS4Oo4xmFanLkiarDZ6uP7K1pJBan98EJnjzaUs4sw2NLt8pv4xXRvpHzSokng
         olyCA1q9VR4iA==
Date:   Thu, 8 Jul 2021 21:12:09 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: don't expose misaligned extszinherit hints to userspace
Message-ID: <20210709041209.GO11588@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Commit 603f000b15f2 changed xfs_ioctl_setattr_check_extsize to reject an
attempt to set an EXTSZINHERIT extent size hint on a directory with
RTINHERIT set if the hint isn't a multiple of the realtime extent size.
However, I have recently discovered that it is possible to change the
realtime extent size when adding a rt device to a filesystem, which
means that the existence of directories with misaligned inherited hints
is not an accident.

As a result, it's possible that someone could have set a valid hint and
added an rt volume with a different rt extent size, which invalidates
the ondisk hints.  After such a sequence, FSGETXATTR will report a
misaligned hint, which FSSETXATTR will trip over, causing confusion if
the user was doing the usual GET/SET sequence to change some other
attribute.  Change xfs_fill_fsxattr to omit the hint if it isn't aligned
properly.

Fixes: 603f000b15f2 ("xfs: validate extsz hints against rt extent size when rtinherit is set")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_ioctl.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index cfc2e099d558..72441c7be644 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1065,7 +1065,24 @@ xfs_fill_fsxattr(
 
 	fileattr_fill_xflags(fa, xfs_ip2xflags(ip));
 
-	fa->fsx_extsize = XFS_FSB_TO_B(mp, ip->i_extsize);
+	if (ip->i_diflags & XFS_DIFLAG_EXTSIZE) {
+		fa->fsx_extsize = XFS_FSB_TO_B(mp, ip->i_extsize);
+	} else if (ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) {
+		/*
+		 * Don't let a misaligned extent size hint on a directory
+		 * escape to userspace if it won't pass the setattr checks
+		 * later.
+		 */
+		if ((ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
+		    ip->i_extsize % mp->m_sb.sb_rextsize > 0) {
+			fa->fsx_xflags &= ~(FS_XFLAG_EXTSIZE |
+					    FS_XFLAG_EXTSZINHERIT);
+			fa->fsx_extsize = 0;
+		} else {
+			fa->fsx_extsize = XFS_FSB_TO_B(mp, ip->i_extsize);
+		}
+	}
+
 	if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
 		fa->fsx_cowextsize = XFS_FSB_TO_B(mp, ip->i_cowextsize);
 	fa->fsx_projid = ip->i_projid;
