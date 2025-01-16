Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1DB1F78F5;
	Thu, 16 Jan 2025 23:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070630; cv=none; b=fr9BgriwQy2SSu/niGtfvJgAl4C0TAtyWonWhT90i1EEGeNB7zI6SQ09R5ywWYIoSu0rSSCdXIkk2Z3MfB9MK5TBjVd27jr69kr3hw59hJVKUMSfuqXJvnahG5U1Q2Bwyr/8VfDnXqQuuU6ezd0NcmAMiEj7VSfXz8eJWlGUA/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070630; c=relaxed/simple;
	bh=whgHXdDe4v2qGzbi60U9hg9fOP5STBty49Ju3sKfVek=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sCc+3k+UzkxcLUtbNhFvQJ2t9ltooFBncGH75mHAgfi/xcgihn/TD5/lq8KLhcvXoNjo3IgzH/f7juH1rpSUl1Lc1UbmPb7BG0M5M3+GZ3xqgjGg5ppRGbTY/2KTUWLTEd1i+hMoDGs7E1oWTjjKKeqLG7P5K6WRWQlk9Zno27E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GB8TtDP/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GB8TtDP/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3143CC4CEDD;
	Thu, 16 Jan 2025 23:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070630;
	bh=whgHXdDe4v2qGzbi60U9hg9fOP5STBty49Ju3sKfVek=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GB8TtDP/I3elHXqtnFdhco0YQk/utPZSjUumFHT1S5/E9fJRQium3bAabljsmXLYX
	 li6gle40pKXvroaXD6r68xSpfpLPQfu36Hlp+pNn+wgdWNOkoTr3XThFEI6bySkrlG
	 KrcZdmG6spcaaC1idIJ6FEYb4TS7b7vgXlRr5ekIcTxXpSlM2Z0xlwQTzTD85/+JgG
	 YACSSgOUupSvmJQQPrWi21KX5g8blliXyRziP6F0xAc+aOza6N/CXZcHJIbzn4SfI0
	 5nVCn5nZojGS99GlawQwKz+2GTA1qFbXF7GisYdjwiO66t+MN79dJwQDwwCUlTVN2c
	 Wmynl9h3HrHzg==
Date: Thu, 16 Jan 2025 15:37:09 -0800
Subject: [PATCH 08/14] common: pass the realtime device to xfs_db when
 possible
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706976185.1928798.11944257459731657070.stgit@frogsfrogsfrogs>
In-Reply-To: <173706976044.1928798.958381010294853384.stgit@frogsfrogsfrogs>
References: <173706976044.1928798.958381010294853384.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Teach xfstests to pass the realtime device to xfs_db when it supports
that option.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/xfs |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/common/xfs b/common/xfs
index b8e24c2e0ce8fe..6e2070b5647b38 100644
--- a/common/xfs
+++ b/common/xfs
@@ -308,6 +308,10 @@ _scratch_xfs_db_options()
 	SCRATCH_OPTIONS=""
 	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
 		SCRATCH_OPTIONS="-l$SCRATCH_LOGDEV"
+	if [ "$USE_EXTERNAL" = yes ] && [ ! -z "$SCRATCH_RTDEV" ]; then
+		$XFS_DB_PROG --help 2>&1 | grep -q -- '-R rtdev' && \
+			SCRATCH_OPTIONS="$SCRATCH_OPTIONS -R$SCRATCH_RTDEV"
+	fi
 	echo $SCRATCH_OPTIONS $* $SCRATCH_DEV
 }
 

