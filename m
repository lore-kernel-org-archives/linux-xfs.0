Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792573215;
	b=35pM182KEJssxieXEBIuJpxowlkJ/WkOoyuMwVltt+kJMzdFfxSZHQ/DYVI8qFK9Wolb
	 a1PQhP29JgYvPqMHkYJQzzt2MgNf0MEreHY3lr3fsvI+Hb3qlGs5E3cmAkkIYuMCZPZ9g
	 0EQCE7M8uJigo4BjbxYFisFc1n4818fXGj0hi8MlMcdnGgpj9pWEhYCHS8jHsS0yde02N
	 p+MuiBG3xZCjuiuah0JM7yDtn6PvRusHZOlsBn016Wbndfqpkc9QN4VqtyAMJVF6SXJsa
	 WUBMjnM0ofr+dOes7sS7jFXh5jeyDv2H84n2XUNVTm+uPl8dKjdPc+vGLut7nAYBeHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792573215;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=uc/0o8hECknAJcw2ey4ZkXZWcoOijsa5LExKv8NU9zI=;
	b=HUzMVvVQex5E9K3t447BHQRQeZViz99TipzQ2PLXdWXaJF3eGu7vBuECEQZB2vwAwpsq
	 UB8nfZiGB/xrjMYIi0nxbZPc1XZ9NgsbXlG5kx9/wqHSfTc7andj+Sxn1Ji+atgvjIHXz
	 LNdmdOjNEkwStLgCAHDUvYVoSM5FzVPmHHmn3KnYuvso+ap59ZxT3r+clXtWU2si+Ff8K
	 UJh41FceOIUQtYXI0rLpK05tsNrbwddkfMQqw0fEc+oXfvy7wM2T5gbo+2JJGWE6iORyO
	 dV09bLhM9Vpe2fFvi24QN82sxbw07Gdw8RUroP4HhI8skFssw831FXpQNmCupVM0msA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Y/xsSmfF";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930BA606A325
	for <linux-xfs@vger.kernel.org>; Wed, 21 Oct 2026 09:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y/xsSmfF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4725C1F000C9;
	Wed, 21 Oct 2026 09:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792573215;
	bh=uc/0o8hECknAJcw2ey4ZkXZWcoOijsa5LExKv8NU9zI=;
	h=From:To:Cc:Subject:Date;
	b=Y/xsSmfFf6PPYfzyOdVQtGf0RZb0Tz+Zafrm/2HGKDavUXvoPP0HBDKD1Dufx1hQm
	 zdeaTXbODRp1L6ZFuEEpIIMfjSvu3UKcukqd1sM1n5xF//3n/R6mkxn3kQ19xS/dCe
	 0qxNpxruzOeejb0RyCJrPkyTSLOjjiwR0Mi5OaG/vHI0LiKoBww/cPAJCBirv9hyrv
	 ZRZO7DubpOdXjRfdzzUTk/HMNg4aK61rVzBmMYZWByjh16tjQRXiJm1AsDzdKL4SAp
	 ayoHY7PX4lKxXNjllowkf1LPqcRjO0r/yqRnwpfVvJSwPfYRMbBRzHs0zxbNRQAiJ7
	 +b0nyk45i2/jw==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Pavel Reichl <preichl@redhat.com>
Subject: [PATCH] libxfs: remove stale xfs_trans_mod_sb() declaration
Date: Wed, 21 Oct 2026 10:59:22 +0200
Message-ID: <20261021085921.56883-2-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The fa19604607c1 added xfs_trans.h which declares xfs_trans_mod_sb(),
this function was already declared in xfs_platoform.h. They have
conflicting type of the last 'delta' argument (stale long, newer int64_t
from kernel's xfs_trans.h).

This breaks on systems with 32-bit long (e.g. i686) but works fine on 64-bit
as these are basically the same definitions there.

./libxfs_api_defs.h:390:41: error: conflicting types for 'libxfs_trans_mod_sb'; have 'void(struct xfs_trans *, uint,  long int)' {aka 'void(struct xfs_trans *, unsigned int,  long int)'}
  390 | #define xfs_trans_mod_sb                libxfs_trans_mod_sb
      |                                         ^~~~~~~~~~~~~~~~~~~
xfs_platform.h:411:6: note: in expansion of macro 'xfs_trans_mod_sb'
  411 | void xfs_trans_mod_sb(struct xfs_trans *, uint, long);
      |      ^~~~~~~~~~~~~~~~
./libxfs_api_defs.h:390:41: note: previous declaration of 'libxfs_trans_mod_sb' with type 'void(xfs_trans_t *, uint,  int64_t)' {aka 'void(struct xfs_trans *, unsigned int,  long long int)'}
  390 | #define xfs_trans_mod_sb                libxfs_trans_mod_sb
      |                                         ^~~~~~~~~~~~~~~~~~~
./xfs_trans.h:173:17: note: in expansion of macro 'xfs_trans_mod_sb'
  173 | void            xfs_trans_mod_sb(xfs_trans_t *, uint, int64_t);
      |                 ^~~~~~~~~~~~~~~~

Fix by removing stale definition and updating declaration to int64_t.

Fixes: fa19604607c1 ("libxfs: use xfs_trans.h from the kernel source")
Reported-by: Pavel Reichl <preichl@redhat.com>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/trans.c        | 2 +-
 libxfs/xfs_platform.h | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/libxfs/trans.c b/libxfs/trans.c
index c509ca113111..920f0eba7519 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -845,7 +845,7 @@ void
 libxfs_trans_mod_sb(
 	xfs_trans_t		*tp,
 	uint			field,
-	long			delta)
+	int64_t			delta)
 {
 	switch (field) {
 	case XFS_TRANS_SB_RES_FDBLOCKS:
diff --git a/libxfs/xfs_platform.h b/libxfs/xfs_platform.h
index 4f4990a20dad..80ff969b9f27 100644
--- a/libxfs/xfs_platform.h
+++ b/libxfs/xfs_platform.h
@@ -408,8 +408,6 @@ int  libxfs_mod_incore_sb(struct xfs_mount *, int, int64_t, int);
 /* percpu counters in mp are #defined to the superblock sb_ counters */
 #define xfs_reinit_percpu_counters(mp)
 
-void xfs_trans_mod_sb(struct xfs_trans *, uint, long);
-
 void xfs_verifier_error(struct xfs_buf *bp, int error,
 			xfs_failaddr_t failaddr);
 void xfs_inode_verifier_error(struct xfs_inode *ip, int error,
-- 
2.54.0

