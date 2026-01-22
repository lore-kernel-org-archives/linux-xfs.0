Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FED37648C;
	Thu, 22 Jan 2026 16:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769097814; cv=none; b=JxxkZbngosK0whKP6V5SnFnT3gA7DLTYWlijtf2tzTl7q9ubJJTlFgGWg0iXhZUfCPO5dScrKVn7MWrlGE9XigWDYUr/38106DuoJPtnQ0JTfWhjSzeKOvErspXZvCtl0Z2cU/19+KTi7JwZyiehGCaiT3nBztuHPhtHLHs3J9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769097814; c=relaxed/simple;
	bh=PrjBIgqMZlEiWazg7UCKbeIwEx1gUf+zQ+J1E5IoNSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpQmhIBPWX0E6fJO3gdQLE2npUmkgSHE+Neoyz+Us2I/gtCvqpIlIWs0ek7jpZI3vkfMaIkND2T67XD3/nzkgPLfWwusv5Sitc2I39GGjmOcJ4aReLLmZsChX6T1d1IAQX/UrqwA8PNrsDNaMYoxqowEkcFfdX+HpHpkeU2Hjqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IKCkgvAo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IKCkgvAo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1222BC19425;
	Thu, 22 Jan 2026 16:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769097813;
	bh=PrjBIgqMZlEiWazg7UCKbeIwEx1gUf+zQ+J1E5IoNSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IKCkgvAoZmGIRN95yLR39VWoG8ht6zNmNM8Kc9ogmsU4v/mqfyfFpmBza3cerGwrt
	 fwXXKFfANAVlgByho9c3D2O8rGbaB0MPHC0/1EKMiC4hZy+7XoHpx39MG5HUJFBWa6
	 RKFbSfogNdO1fdC/FpV4eZwZJNwoPexdd+ta0lBLY28wqr1kmaCuWpQ3DK1Tn/XEfe
	 j8mV/CrLr2yWPF+zuzQFj1C2M2H3KMZxs7l3VBmUOZFqKIKUNFm+KuPqi+sYQHstq8
	 FowLN7iCDCAsShQkPuGKGwHuY/fKIyGRVDwtF0dxvGZiR+AWX16Ld8phS/EjQ0IalO
	 l2yiQmg+1FqQA==
From: Chuck Lever <cel@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>
Cc: <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	<linux-nfs@vger.kernel.org>,
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
Subject: [PATCH v7 07/16] ext4: Report case sensitivity in fileattr_get
Date: Thu, 22 Jan 2026 11:03:02 -0500
Message-ID: <20260122160311.1117669-8-cel@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260122160311.1117669-1-cel@kernel.org>
References: <20260122160311.1117669-1-cel@kernel.org>
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
index 7ce0fc40aec2..462da7aadc80 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -996,6 +996,13 @@ int ext4_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
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
2.52.0

