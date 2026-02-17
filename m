Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58F52F5A36;
	Tue, 17 Feb 2026 21:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771364886; cv=none; b=oO9z/w2Av0EgrmO/dviSvcq6GQ3/o6BTAivE+2rebNLZCY0VVBDQa3OZBpV4X88C7Yobfh0Kirc2ptO0WATAb7BsEN1BvBVjhk1bh8OowSdDYqr5fiV3MA/s5aSoqej0MQl+ooDnQy4+miZnmZTkRBzViviLhxTgHZ3Ms3KgSyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771364886; c=relaxed/simple;
	bh=hTKaZ1DqrpDPT8D9Hsa+8JFcRjOoKkJIQ9HwVjo6HdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RApVpYCDp+mTQ3NHZFV+lhf/2Scei+kUPKPtSKtFagrBPM+majrkHh/iPKPH36FbMIvwi+Xhbo6/cUOUbMpVsJEnIbZ5E/oG1SPsFvv3M5/ikIPtioCxREAwWq195aCy4/nfaThZr0KX62jMvA6UZA9poHXTzW06vny4xb2I2Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Es8TacpK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Es8TacpK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 017B4C4CEF7;
	Tue, 17 Feb 2026 21:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771364886;
	bh=hTKaZ1DqrpDPT8D9Hsa+8JFcRjOoKkJIQ9HwVjo6HdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Es8TacpKYI7rQxz+XweHWdzuT/zgCJVBa3OY1udo7vycYwkZ/4znBYaBURWNZ98Yp
	 RaQBkNkUOE7+gcDQy72TK3tHy3S+DPEDc4/f4cD1VXk3BZlqyC+5npM3NSxCCNwepy
	 UiZUNypdReMu0/4f/YwqwY/ku+wDMxEvRqooibz9MDIfkoIp9LC48t7+IawAOf3C6M
	 idiefwYJQ3tc0TVrk99AVkHGvtc2M4WBG8tcLKvQ0uuhBZN/65dKUyoS0ZcdThHzzX
	 UfBoiUsWeDDHpaVSQ6fwQFSPwDCe/KhijmTuVGcoeMWjpvROwpRKefnSiFS2rMBm+Z
	 Q194pkU9htQ/w==
From: Chuck Lever <cel@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	hirofumi@mail.parknet.co.jp,
	linkinjeon@kernel.org,
	sj1557.seo@samsung.com,
	yuezhang.mo@sony.com,
	almaz.alexandrovich@paragon-software.com,
	slava@dubeyko.com,
	glaubitz@physik.fu-berlin.de,
	frank.li@vivo.com,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	cem@kernel.org,
	sfrench@samba.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	trondmy@kernel.org,
	anna@kernel.org,
	jaegeuk@kernel.org,
	chao@kernel.org,
	hansg@kernel.org,
	senozhatsky@chromium.org,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH v8 08/17] ext4: Report case sensitivity in fileattr_get
Date: Tue, 17 Feb 2026 16:47:32 -0500
Message-ID: <20260217214741.1928576-9-cel@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217214741.1928576-1-cel@kernel.org>
References: <20260217214741.1928576-1-cel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chuck Lever <chuck.lever@oracle.com>

Report ext4's case sensitivity behavior via the FS_XFLAG_CASEFOLD
flag. ext4 always preserves case at rest.

Case sensitivity is a per-directory setting in ext4. If the queried
inode is a casefolded directory, report case-insensitive; otherwise
report case-sensitive (standard POSIX behavior).

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/ext4/ioctl.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 3ae9cb50a0c0..a93017b80aa0 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -999,6 +999,13 @@ int ext4_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
 	if (ext4_has_feature_project(inode->i_sb))
 		fa->fsx_projid = from_kprojid(&init_user_ns, ei->i_projid);
 
+	/*
+	 * Case folding is a directory attribute in ext4. Set FS_XFLAG_CASEFOLD
+	 * for directories with the casefold attribute; all other inodes use
+	 * standard case-sensitive semantics.
+	 */
+	if (IS_CASEFOLDED(inode))
+		fa->fsx_xflags |= FS_XFLAG_CASEFOLD;
 	return 0;
 }
 
-- 
2.53.0

