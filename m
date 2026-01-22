Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1184367F48;
	Thu, 22 Jan 2026 16:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769097817; cv=none; b=gP7VpT1CydcKJKncagW3q9G6eiBfcZ78UaMxop/DtDJGy1r/4LZPoHe9F9PlunKsTZzaX/okxRj+OhdVyQrtiRRS/KrdCdmOgu165SmN32Ka6gHY5/m2OfVSNtRR2apvIGXenff80F8MxPIuTlLLLIXHn5UrMKYZIGSVZ4jYdt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769097817; c=relaxed/simple;
	bh=Kj+ayzVWTGTE/9UqBMu9SybvI6joLEnV2BfTwDGEXeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qi+L5n33XphWxlTxRjjhisPYclCRhM4xg+bFN0WN16r1ebA9DpYwbJRCFve3BCpETo3x+CXGGKgYDsr67qr8dGzQ4FruuIZC+IemIit6R2gg5z0SEDo6xf5srS1JPfb4MECVie0O5qt0PzAO5dcSF4SYpLy3Jg975Uh73a99eso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X7pHCXBA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X7pHCXBA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FDB8C116C6;
	Thu, 22 Jan 2026 16:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769097815;
	bh=Kj+ayzVWTGTE/9UqBMu9SybvI6joLEnV2BfTwDGEXeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X7pHCXBAinh6H8ZYn6Eb3un06aRuRAt5mTyxa3ks5jcEg7tVd8V9L39NatW85XC5F
	 eGQB71z6LusnxAi5F6aW4stt1oV4700INXmDBFdlllvUwZDHA/Yb/42yY6vNqGpj57
	 qRoVEVGNcOScP4KRzYA3rWSZyh08fo5JLYlzLsnb1XNGdqippb/JBuxBOuJKiAA5AH
	 aT70DBp2amQWE9GQ6Hu54hhWd4Tq2McMKVnSwx9vUix5IWBW0FrEYNCK9e5WXGx0EY
	 YSUUwfyi2YDwXAX2LxNsoAySQwA7uBsTDmZBtn5aUxLjiL2BQDnrlbUH+cFiMZu6Fq
	 tLqTkF+ffwl0A==
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
	Chuck Lever <chuck.lever@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v7 08/16] xfs: Report case sensitivity in fileattr_get
Date: Thu, 22 Jan 2026 11:03:03 -0500
Message-ID: <20260122160311.1117669-9-cel@kernel.org>
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

Upper layers such as NFSD need to query whether a filesystem is
case-sensitive. Report case sensitivity via the FS_XFLAG_CASEFOLD
flag in xfs_fileattr_get(). XFS always preserves case. XFS is
case-sensitive by default, but supports ASCII case-insensitive
lookups when formatted with the ASCIICI feature flag.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/xfs/xfs_ioctl.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index f0417c4d1fca..da98d4422b02 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -516,6 +516,13 @@ xfs_fileattr_get(
 	xfs_fill_fsxattr(ip, XFS_DATA_FORK, fa);
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
+	/*
+	 * FS_XFLAG_CASEFOLD indicates case-insensitive lookups with
+	 * case preservation. This matches ASCIICI behavior: lookups
+	 * fold ASCII case while filenames remain stored verbatim.
+	 */
+	if (xfs_has_asciici(ip->i_mount))
+		fa->fsx_xflags |= FS_XFLAG_CASEFOLD;
 	return 0;
 }
 
-- 
2.52.0

