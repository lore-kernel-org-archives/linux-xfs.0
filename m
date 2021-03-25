Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AB56C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 23:21:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21EB261A0F
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 23:21:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbhCYXU2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 19:20:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231309AbhCYXU0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 19:20:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A185C61A0F;
        Thu, 25 Mar 2021 23:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616714425;
        bh=mK2zqjS1Qt+ZPqP1WoS2AhhuYUTfPPWq2exc3DLSDlo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RCoOVeGPG3+nbICwdiAq76JuRx8FwcIAO+waUFANzv6hlXpGLTuXHaEFp/buR+RPA
         iLYJzRqAPahujSehirJLCigEAvcJx6CmImhOdIiPBp1CHlrjT3VrGKhuBDD3Mf9ah1
         tRa5vCapY5vsM9J2wLuDjUM2H+WPybwsVIb1lyo2eXSTsKFxgIucJCWKBTtahGklOR
         /tEi7SuIr4w4T40PY8Y+opce8z0791c6dTHIlzztEoaQ+AuL+BCJVTiTBMU4vmqUso
         D3exiExl2O5+pPsitlbm4R2zNJsZwV18wAorKB25j/clm0G/JLIls1rlaHIQQWb3re
         nJpeZlN/H6IDw==
Date:   Thu, 25 Mar 2021 16:20:25 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 3/2] common/xfs: work around a hang-on-stdin bug in xfs_admin
 5.11
Message-ID: <20210325232025.GM1670408@magnolia>
References: <161647323173.3431002.17140233881930299974.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161647323173.3431002.17140233881930299974.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

xfs_admin in xfsprogs 5.11 has a bug wherein a caller who specifies an
external log device forces xfs_db to be invoked, potentially with zero
command arguments.  When this happens, xfs_db will wait for input on
stdin, which causes fstests to hang.  Since xfs_admin is not an
interactive tool, redirect stdin from /dev/null to prevent this issue.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/common/xfs b/common/xfs
index 06989d1c..d2173129 100644
--- a/common/xfs
+++ b/common/xfs
@@ -277,7 +277,13 @@ _scratch_xfs_admin()
 			_notrun 'xfs_admin does not support rt devices'
 		rt_opts+=(-r "$SCRATCH_RTDEV")
 	fi
-	$XFS_ADMIN_PROG "${rt_opts[@]}" "$@" "${options[@]}"
+
+	# xfs_admin in xfsprogs 5.11 has a bug where an external log device
+	# forces xfs_db to be invoked, potentially with zero command arguments.
+	# When this happens, xfs_db will wait for input on stdin, which causes
+	# fstests to hang.  Since xfs_admin is not an interactive tool, we
+	# can redirect stdin from /dev/null to prevent this issue.
+	$XFS_ADMIN_PROG "${rt_opts[@]}" "$@" "${options[@]}" < /dev/null
 }
 
 _scratch_xfs_logprint()
