Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB62D2F5308;
	Tue, 17 Feb 2026 21:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771364883; cv=none; b=AKKl+XVIAWQW63uuVw+1BdEvilczi1NP479p6zEVyUQyHCA2iHNgsU7Xywuf50SP8YvWZp/I3IdYYzDO1cyilh+G5TmBcWJ6wQhLcHWsk2UNzB41OfwAuan6F/8dtpibBg5uCelJ3IwsVZpLY6tt4GxwUlk4v0DAOSmpGq5CZig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771364883; c=relaxed/simple;
	bh=P5+WVnKmUY1EF3MqMMnnMfbxqC72lpyhhIR9yq0eVrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTiyqxpmE4DQ/5N/ViLv0gzHCsoSPoiqZCPRPTqyS7xnuJhc+j0sj1vEo6TCSp0XSi3tXOwfkpY9XaAGXUjgVA+4jngGD61eurF9aYIk34iLP9F15Tivqz5gDL1fUaNmmN2Sdrns85RZskm7IbVy9zMMPQHDT4zoGO25v38+ug0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NuSiuDbC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NuSiuDbC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4D2C19421;
	Tue, 17 Feb 2026 21:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771364883;
	bh=P5+WVnKmUY1EF3MqMMnnMfbxqC72lpyhhIR9yq0eVrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NuSiuDbCNCMuhZw0qBGFxOA3xH1gKVPWZ+zqEmBaghoqu9lNyRLcO2IU77ZY3HPC9
	 960qgZ19lNKSyRbpflXvCV7h4ciVIE7mvkbrjtP1HdoDys2jAfBfV7LuCzxJjcEw7/
	 WFQrkEvzwBsF7V3kuiRgOTIMrcdvUvbLoo4F13fOlpWAi98ZnUfNB0Dfx2mLiHnoYX
	 pK11aZEKBMyUjsxG90jpYG0B/SQTlrH+0xciHlZTi3CAL0qBYnOmncHZIsnDjQYChw
	 kruufwl9AtirWmnegJeToEJhHO+9Q3m3E2U/L2zdjg4i893pTb/Sk6BId3UlwiuJXZ
	 zyF9cjjASn88A==
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
Subject: [PATCH v8 07/17] hfsplus: Report case sensitivity in fileattr_get
Date: Tue, 17 Feb 2026 16:47:31 -0500
Message-ID: <20260217214741.1928576-8-cel@kernel.org>
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

Add case sensitivity reporting to the existing hfsplus_fileattr_get()
function via the FS_XFLAG_CASEFOLD flag. HFS+ always preserves case
at rest.

Case sensitivity depends on how the volume was formatted: HFSX
volumes may be either case-sensitive or case-insensitive, indicated
by the HFSPLUS_SB_CASEFOLD superblock flag.

Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/hfsplus/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 922ff41df042..fd50f0d52c81 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -728,6 +728,7 @@ int hfsplus_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
 {
 	struct inode *inode = d_inode(dentry);
 	struct hfsplus_inode_info *hip = HFSPLUS_I(inode);
+	struct hfsplus_sb_info *sbi = HFSPLUS_SB(inode->i_sb);
 	unsigned int flags = 0;
 
 	if (inode->i_flags & S_IMMUTABLE)
@@ -739,6 +740,13 @@ int hfsplus_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
 
 	fileattr_fill_flags(fa, flags);
 
+	/*
+	 * HFS+ preserves case (the default). Case sensitivity depends
+	 * on how the filesystem was formatted: HFSX volumes may be
+	 * either case-sensitive or case-insensitive.
+	 */
+	if (test_bit(HFSPLUS_SB_CASEFOLD, &sbi->flags))
+		fa->fsx_xflags |= FS_XFLAG_CASEFOLD;
 	return 0;
 }
 
-- 
2.53.0

