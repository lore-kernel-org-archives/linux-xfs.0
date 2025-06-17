Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B545156F5E;
	Tue, 17 Jun 2025 20:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750193746; cv=none; b=hcEAib4MF/iUjZagVyz7Lrs710FL5JYBf/dD1mGMZHgccUyjBfyIqgwyT90SmTbHnQZvOlLC4ttNu/EfsjbD1X3Nam/wqLGrPQgQ3mtlnHxZpr48DKEvNirhJzc/rCmtEnl8JJehdod8nghZx9ZzT51FgoZ3ECl2O6TPeDQBj/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750193746; c=relaxed/simple;
	bh=OhHRBPMRV/UHcsVAGr5/2+3PfnQ5V8unIAEuX1cHqcg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gopALN376Xdb/nXktrpvNKqq00siFR0NKJ5Lkef+PveVCdofWNd4wSFNzfbyEqpQGfVQG/OaILmzP1VVSptspFcMzIHZtXYrSJJ2EpNNU92LeGljtO8CWWr06vCmEwct0+SpGFXSLhmyNZOxYBwsnlXuYT8//DvxoVQ+tkqKHsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ww+1Ce2t; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ww+1Ce2t"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-addda47ebeaso1252754766b.1;
        Tue, 17 Jun 2025 13:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750193743; x=1750798543; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Z6GF9ie7geadzhcZucxpdHyxYKwylC1RiYeKOCBRN3k=;
        b=Ww+1Ce2t8yrCU0OYsUEdU89ouvrHmPMyLUB7NsbdQpJYqJn2Lb2Bhe4htXVOJcnnM4
         TrpfWT3KvoB5GLE113lLoE9l9P05JiccS8jfKSOKRMdn2mqSxiUD7FFJtygXJLXTthch
         NjRtE6aJ2QHX1Db36b4HaH3CtcMDQHbS6ahxyPsb7lZPAlBsvlsdmNi++/7LPyBHpwd3
         WQBBOb+yT6L/kpd/bUCSsgecFJiIlTXOO5JoYlYmcpp7m2hZydhls0UmGUAsTeo9qEXI
         cab9xN3TjLQXG8csbrvZPS5xramKekXsDgj/B+eTaM2Yqqx8ymVzuZQQBwvuzgr/Tc4O
         McQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750193743; x=1750798543;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z6GF9ie7geadzhcZucxpdHyxYKwylC1RiYeKOCBRN3k=;
        b=q5d5m64tGqrNXYiE27Dx8Yna8YUMuf+rl8orQGRnpqBd8njJ2JxDEFOg+E5E7kYEMh
         XCuTqbjzcC+Z1LtpDsMv0VohUs+jLidRX8lTWfmh0iUOxzeZ7c29hS+eOLXOUuyFNikq
         kPny3D8VBb4DMXpzrnPcAHxiQBTtvsvU4iznfIV5/XLCcVAEgoBwK1lyLDA64h/j2xuX
         QjXFEU9qJkPx1HpcdUN5fcyXxFowwmIopI9wUbpCbk2UBMFQNIds3LMXZd4gTJ3DVbIE
         OtDQ75ld/eMQdeGpbO+olO66tatAtdbDmoeaPOpTLmH/8fKq2KlF36cjPVJC/fc27b59
         cn3g==
X-Forwarded-Encrypted: i=1; AJvYcCXDjZk/aq/pV967T3ur1M0nONlVNHWOlUaMOYnVgtpdZnPv9cnuzze4cAzXCXYtyxwj1KH7abCI0bQ=@vger.kernel.org, AJvYcCXmKQGR7te1+ddylMXiOSR3vzooATtmhzgkwrNTDTcFzFckU+isicreICTy5QA+aurzDAFoOPdg@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7zNNgIT+6Ygv6c1Z2A0nqJlL2dIlXRPHocdtUQL5RdK1Se/IW
	l36U6cbCFmxaPwHJKH+mo9ztuQO/cXMu8PTMsOeBitnSJGmCZlq6I1jt
X-Gm-Gg: ASbGnctCZz0E6jhl8hk0nnYoc8W2OvWwYopOo/i18JFqvVcrfOZVr826NOoUZWmhVZn
	xBAp5yhmiCT2JoDcBD2p2i31KAv+hBgfeUU5FBDNIRIq1Ky2R3ev9lcVHREuq87Q9k8R2di/EVd
	mh1u31Rp5kC0hCOsUEfYqVhqG+A06GwpEowtYzL//TNuNJtCmyzikm0w5Nr0/M73DhycE8YOBxR
	xBb4odGIQLMZjwjRw+YtJmvuzyjcpBHtMqfSQnrGPWt58H5OuOKZx4eZElkxYqyLhT8vLI31ejD
	Mc/cxt/3IQC+Bi7Vle3gb7os5x+yiHyGN5n715W++C7TciZ+eJ0dZ/5kzA4tz28oR3LbuKtRMtg
	mxMNErr9iy0T4bC3Ec4QX4AkX5fhxc+Ai1Fv1jCvkTwSHuajcH9GuZJHnsYvCALKEUlxczg==
X-Google-Smtp-Source: AGHT+IEqziB0vNC7Zgnv3HeNmOwInCxtuCKj03BmBmL0eTRJFYYZ4/DveA17OHFaTmKWjcLqItPRNA==
X-Received: by 2002:a17:906:730c:b0:ad8:9257:5727 with SMTP id a640c23a62f3a-adfad4f7406mr1417714866b.51.1750193742057;
        Tue, 17 Jun 2025 13:55:42 -0700 (PDT)
Received: from amir-ThinkPad-T480.arnhem.chello.nl (92-109-99-123.cable.dynamic.v4.ziggo.nl. [92.109.99.123])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adec89299c2sm922695566b.119.2025.06.17.13.55.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 13:55:41 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Sasha Levin <sashal@kernel.org>
Cc: Leah Rumancik <leah.rumancik@gmail.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Long Li <leo.lilong@huawei.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-xfs@vger.kernel.org,
	stable@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 5.15] xfs: allow inode inactivation during a ro mount log recovery
Date: Tue, 17 Jun 2025 22:55:33 +0200
Message-ID: <20250617205533.145730-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 76e589013fec672c3587d6314f2d1f0aeddc26d9 ]

In the next patch, we're going to prohibit log recovery if the primary
superblock contains an unrecognized rocompat feature bit even on
readonly mounts.  This requires removing all the code in the log
mounting process that temporarily disables the readonly state.

Unfortunately, inode inactivation disables itself on readonly mounts.
Clearing the iunlinked lists after log recovery needs inactivation to
run to free the unreferenced inodes, which (AFAICT) is the only reason
why log mounting plays games with the readonly state in the first place.

Therefore, change the inactivation predicates to allow inactivation
during log recovery of a readonly mount.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Stable-dep-of: 74ad4693b647 ("xfs: fix log recovery when unknown rocompat bits are set")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Sasha,

This 5.15 backport is needed to fix a regression introduced to
test generic/417 in kernel v5.15.176.
With this backport, kernel v5.15.185 passed the fstests quick run.

As you may have noticed, 5.15.y (and 5.10.y) are not being actively
maintained by xfs stable maintainer who moved their focus to 6.*.y
LTS kernels.

The $SUBJECT commit is a dependency of commit 74ad4693b647, as hinted by
the wording: "In the next patch, we're going to... This requires...".

Indeed, Leah has backported commit 74ad4693b647 to 6.1.y along with its
dependency, yet somehow, commit 74ad4693b647 found its way to v5.15.176,
without the dependency and without the xfs stable review process.

Judging by the line: Stable-dep-of: 652f03db897b ("xfs: remove unknown
compat feature check in superblock write validation") that exists only
in the 5.15.y tree, I deduce that your bot has auto selected this
patch in the process of backporting the commit 652f03db897b, which was
explicitly marked for stable v4.19+ [1].

I don't know if there is a lesson to be learned from this incident.
Applying xfs backports without running fstests regression is always
going to be a gamble. I will leave it up to you to decide if anything
in the process of applying xfs patches to <= v5.15.y needs to change.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-xfs/ZzFon-0VbKscbGMT@localhost.localdomain/

 fs/xfs/xfs_inode.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3b36d5569d15..98955cd0de40 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -32,6 +32,7 @@
 #include "xfs_symlink.h"
 #include "xfs_trans_priv.h"
 #include "xfs_log.h"
+#include "xfs_log_priv.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_reflink.h"
 #include "xfs_ag.h"
@@ -1678,8 +1679,11 @@ xfs_inode_needs_inactive(
 	if (VFS_I(ip)->i_mode == 0)
 		return false;
 
-	/* If this is a read-only mount, don't do this (would generate I/O) */
-	if (xfs_is_readonly(mp))
+	/*
+	 * If this is a read-only mount, don't do this (would generate I/O)
+	 * unless we're in log recovery and cleaning the iunlinked list.
+	 */
+	if (xfs_is_readonly(mp) && !xlog_recovery_needed(mp->m_log))
 		return false;
 
 	/* If the log isn't running, push inodes straight to reclaim. */
@@ -1739,8 +1743,11 @@ xfs_inactive(
 	mp = ip->i_mount;
 	ASSERT(!xfs_iflags_test(ip, XFS_IRECOVERY));
 
-	/* If this is a read-only mount, don't do this (would generate I/O) */
-	if (xfs_is_readonly(mp))
+	/*
+	 * If this is a read-only mount, don't do this (would generate I/O)
+	 * unless we're in log recovery and cleaning the iunlinked list.
+	 */
+	if (xfs_is_readonly(mp) && !xlog_recovery_needed(mp->m_log))
 		goto out;
 
 	/* Metadata inodes require explicit resource cleanup. */
-- 
2.47.1

