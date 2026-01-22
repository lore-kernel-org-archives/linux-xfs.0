Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E12C42E016;
	Thu, 22 Jan 2026 16:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769097824; cv=none; b=SaPJqrIn6OPsEcIlF6CND4H2gn5b0dzR9L0nMi/j5uJpSvN5aOBZ/KIfmrkUfolWjqukVpStUveS4LgDkqdJ3CxA8o/vESmZ4JF2CEIpssdZoTDDKkXqKohQpz3IKrfmpWwF9/rFMEeeHOaVrhlwbZR0HvoxUSNw369Wm9osYDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769097824; c=relaxed/simple;
	bh=YDDyyYB+YVCQQ3bOYUSgoPwx7V5Jm2aE0B8Vt/Q0AHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHeFq8872nVgltKR/1q5kd5gn2i5Ga0JzPUkUhEir8FCyR1dOFQD8gozK0jLEF8Q5a4hnfVJCxqJvyqR6szXP9LSK62jjuPVPXXAr269tZ46bYKcssR7xQ9J7ynOgeYGYEDrYOkJU5XwMW15kv1NpiwW84fpyILq+WL5LWZidAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g/sLXrEl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g/sLXrEl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E6DC116D0;
	Thu, 22 Jan 2026 16:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769097823;
	bh=YDDyyYB+YVCQQ3bOYUSgoPwx7V5Jm2aE0B8Vt/Q0AHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g/sLXrEly993FahgZPwCWJLYU6V+16O3RjK9dfQBPO5qkuryI+Sukw7w3Gukpme47
	 Cc9dmFFMuvOQoakWSCiGslFdzmW9RxTFN2SdYZrINv0tMVCaQUsmmn+X0yRCwBu6Pq
	 OdLmrxmJGAJCF9JBDaZL2b83T/7IsVqbFvCvXG1snKIpJ0jE9sX4kVwHFj5Hj1914x
	 5H1gOP3LaQEpBnnNMc+xtyaMP2A61YUBZ0zI3/5x9R7lu9cJz36GgZL4+e1oSJPHYM
	 +7z25L9Wdkp685O4WLv2zj5M9Bzq4I4r5ZbJtmd9yYp1OtmROzyKj2RNzvtsZhLaZF
	 LC5BIjYMitvpw==
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
Subject: [PATCH v7 11/16] f2fs: Add case sensitivity reporting to fileattr_get
Date: Thu, 22 Jan 2026 11:03:06 -0500
Message-ID: <20260122160311.1117669-12-cel@kernel.org>
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

NFS and other remote filesystem protocols need to determine
whether a local filesystem performs case-insensitive lookups
so they can provide correct semantics to clients. Without
this information, f2fs exports cannot properly advertise
their filename case behavior.

Report f2fs case sensitivity behavior via the FS_XFLAG_CASEFOLD
flag. Like ext4, f2fs supports per-directory case folding via
the casefold flag (IS_CASEFOLDED). Files are always case-preserving.

Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/f2fs/file.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index d7047ca6b98d..91c255bbbf48 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -3439,6 +3439,13 @@ int f2fs_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
 	if (f2fs_sb_has_project_quota(F2FS_I_SB(inode)))
 		fa->fsx_projid = from_kprojid(&init_user_ns, fi->i_projid);
 
+	/*
+	 * f2fs preserves case (the default). If this inode is a
+	 * casefolded directory, report case-insensitive; otherwise
+	 * report case-sensitive (standard POSIX behavior).
+	 */
+	if (IS_CASEFOLDED(inode))
+		fa->fsx_xflags |= FS_XFLAG_CASEFOLD;
 	return 0;
 }
 
-- 
2.52.0

