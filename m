Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13487C433C1
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 01:09:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBA64619C1
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 01:09:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbhCaBIu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 21:08:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:41860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232126AbhCaBIS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Mar 2021 21:08:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D8E46190A;
        Wed, 31 Mar 2021 01:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617152898;
        bh=CJ82AbyQcnYPHSdtrUNRy/iC/R95GeMCEQatDDi/F5M=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=A7Pd9sCnk0TJlR35bA9djZ2NG+aIj8DuVgKsu1LwAlx0DG6aMi2/lKWHCr5CtpN5M
         r/pyX15qszt9wn1RWLdGIF1hywu/hQNgsCVIYEKLa/aFM+5GxSRKxaUkU2QhTYRmez
         895aEbM+Hdpo9L5hsgSkowm7AB4HGcWUEzdgvVBWyBo6FOi4uPFBEaVixsrapT/fn9
         z3mfJh8bUYzwmgWDX8umBWqbAwVwpffFgRngb3w3u4OhogSItb7jXK+zEdyDys3tGm
         7I5ZVBq4Q/+2q2qrZ1f4QGWbYHNlP2lodKgz1B10AjBCRvLR8Qr/mrm4jBtau7D5BN
         UhIUxtnTj8ODQ==
Subject: [PATCH 2/3] common/xfs: work around a hang-on-stdin bug in xfs_admin
 5.11
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 30 Mar 2021 18:08:15 -0700
Message-ID: <161715289578.2703773.11659648563859531836.stgit@magnolia>
In-Reply-To: <161715288469.2703773.13448230101596914371.stgit@magnolia>
References: <161715288469.2703773.13448230101596914371.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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
index 189da54b..c97e08ba 100644
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

