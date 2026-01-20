Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E8D441036;
	Tue, 20 Jan 2026 14:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768919100; cv=none; b=eE5ecJHDggQVEu34WpArLRjZOkrv/6Y3Maj65YQeJSRIlTOUzQX58PTQ5hQ/8M7pjsaPLRn7xl2jyUlyH6A2gzWaqp4Pq8qdR38TsX+/6iYXMXG5mGWR/z72P6OF79bh5p2rdP3VtIvR4ckpEQOIWPZAy2JOJV8FfKvmB/8g3gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768919100; c=relaxed/simple;
	bh=PrjBIgqMZlEiWazg7UCKbeIwEx1gUf+zQ+J1E5IoNSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0R6O0X0kbs/1QvmSnIr633QH/dSeWZUD9DbsrkOPSOFdFYZUt9uiX+iefXNzVK1jnadPhoDLifKvFPalyfyhm+/G/YAcTeu21Kv38uusX/yhRKoGZRbZAq+D5r+2vBA0lyc+ujNAmsYLLYwwdP1NgVBhIbPQT9TekXhSV/smUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=joErGhnM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="joErGhnM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC88C19423;
	Tue, 20 Jan 2026 14:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768919100;
	bh=PrjBIgqMZlEiWazg7UCKbeIwEx1gUf+zQ+J1E5IoNSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=joErGhnMxpPDVNbFfZz/yvqUXpNYj0yDUZ36SZXRmjwptNnx7rlyWYJGaprbVCa6A
	 pK+fVGp9+9jPa/TAKapKtpnlrOnO/YRTUyATmU8/RmgCd6TgbX06rUwfHw/9c+NO1B
	 jXm9PxMAKF9A+9g2a7AsriizaCU3KXMhMULl9zYAbAtGxptwbtDrruBt4tFEMwvC13
	 OisNXOB2ncqrbRFbRDFvczS2zn0Tf283mKmkdmG04lf66jj3h3TPvbLQLk/pvCYbfS
	 zwqgTaPmqtyEWYTtHUq1xWCk3idQWCUxcHzb1d9KG0uuyIyGA/s14gZCkBZkdmsUPc
	 lOomn0ulkxnsg==
From: Chuck Lever <cel@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>
Cc: <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	<linux-nfs@vger.kernel.org>,
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
Subject: [PATCH v6 07/16] ext4: Report case sensitivity in fileattr_get
Date: Tue, 20 Jan 2026 09:24:30 -0500
Message-ID: <20260120142439.1821554-8-cel@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260120142439.1821554-1-cel@kernel.org>
References: <20260120142439.1821554-1-cel@kernel.org>
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

