Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A404421CC53
	for <linux-xfs@vger.kernel.org>; Fri, 14 Feb 2025 08:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739522794; cv=none; b=ORqaQb8bllwsTPKEcSyj/2AGRIlU2I7MfHdXC2JI9UqB+C8kYXCs428RDdTeuv6Ya0sFE3isquxJWROuJS+2qpLPnnJARLfbf92+pt21EfFwGRazmNcOpoQlzF7h4BVjrkSIzu9Vhx5JiJOrfwjdpVQLIvouAkKmZe0MTF83JA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739522794; c=relaxed/simple;
	bh=Nqpx0/3SZp7FX5waNQp3oVh2+nK1H4D+1P9hLy9crZI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tEfIdT9oX//PNeZtlYenMYvIllqyLV/zo8jAcsZr4R6h0EIqMUWu4KFPDen3JtU1TH8mC1j8s79j/Tesdpr124TbBKcR6yfZQ7Fx96jVNFxPCoTm7s8/sN/CWpBuFLjZYlGfiK5+xkWLY7nO50pRRQHZvq9DQVRbMX1bsO3fPTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alyssa.is; spf=pass smtp.mailfrom=alyssa.is; dkim=pass (2048-bit key) header.d=alyssa.is header.i=@alyssa.is header.b=TW1FFHJK; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=VBQXa8o2; arc=none smtp.client-ip=103.168.172.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alyssa.is
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alyssa.is
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=alyssa.is header.i=@alyssa.is header.b="TW1FFHJK";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="VBQXa8o2"
Received: from phl-compute-04.internal (phl-compute-04.phl.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 8318E1380418;
	Fri, 14 Feb 2025 03:46:30 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Fri, 14 Feb 2025 03:46:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=cc
	:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm2; t=1739522790; x=1739609190; bh=nFrngLo81eI4IrKosLxc6
	gLdBjgkF8kY1wHyapW57N0=; b=TW1FFHJKR8pgPa3Bgmev763K1rUpbZbwPVWrh
	1YTQSXz9b3sujs+VTdPY8bwQoXrjxvn9pWboMBf4gBVmmN6ZWvEP5JOvxJ3bvq2T
	NZ5MXcwPfPr5mgYoa9WXVVqxuU1HfMwmCzdrc95HohVGXdkMhOkzxH1WYVRWqTwd
	A5LjWrWzIxeIn7UqQKNeWPFlTUmcDQZ3OS8F/CRTmfU3zV2sK382C/JWBYZqmOHe
	l0Y/RJVApNfpzo9AN6MCWASUsSuxKaZYgb7s9mwWZjgZzUvl8757OwXlEjA2iKZ9
	UNsbe9A+v2yUvGQhgFIo4qQM0u6q3h2CxenOoycOSMweciBig==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1739522790; x=1739609190; bh=nFrngLo81eI4IrKosLxc6gLdBjgkF8kY1wH
	yapW57N0=; b=VBQXa8o2xSu/jy6rrO+uESjyC143iiWR5Zukdr1KGTRqO2FonuB
	lMqZG6EG4qRzlV6qkwKCASbwxbjHQestgTQvJ1LZx2OVaNDxfD6mGw+dvk/oA/rJ
	4lcZn/FR3u9acU8UA/0+G8ZqCfuzLDT5XZpY7eZ0ZIsyKxEDATmmFO0ZWQuUOUO9
	i0Rm+Rdm1V0FmXldNMndP4k8q0Zln1IuyEzCejq1enkoZMbrbtvVsQ+8wbVxIjPu
	h9UpiCbGJO+tbKUKK91b83bAp7RLv1cn3Gllbh1u47lefCGkoiGfs65ERgRmeloV
	XJo6OEnwkbJzJ39+8uqOFvjppf4M5y/unNA==
X-ME-Sender: <xms:5gKvZxRv2sIqnvZpfDddLmicxXAS9GolZQKDs_yUpYK-cO0Gkj18MQ>
    <xme:5gKvZ6xfMz3k02_lqO3N_AxgPsmuyldxuPd5Y4G1MrVT9E6pSaGvAXbHPvc7FPbV9
    LCWzRYHc_Wbk5uJfg>
X-ME-Received: <xmr:5gKvZ22cxIixM8nLbv-R1LokLJPivkDWLynv0FRX1UBEcBqBCK8ZfVgYh2_kKckdJQBxC1FBJcBT9HhAEQAWacqPYjI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdegledvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefhvfevufffkffoggfgsedtkeertdertddtnecu
    hfhrohhmpeetlhihshhsrgcutfhoshhsuceohhhisegrlhihshhsrgdrihhsqeenucggtf
    frrghtthgvrhhnpeefteekteehtdfhfedvieevvdehgfdvjeeitdfggeevjeeftdeludet
    gfetgedujeenucffohhmrghinhepghhithhhuhgsrdgtohhmpdhfvgguohhrrghprhhojh
    gvtghtrdhorhhgpdhkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehhihesrghlhihsshgrrdhishdpnhgspghrtghpth
    htohepvddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepughjfihonhhgsehkvghr
    nhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvg
    hlrdhorhhg
X-ME-Proxy: <xmx:5gKvZ5D0n9-mJvBdSIii3Qwlt3GbppQGFjd5sBFAmL00SuwQhC2LoA>
    <xmx:5gKvZ6hF2H2jG2wJBmUF31g-fCjBVRdgRuERVE2WBdTFcNvY40ICfw>
    <xmx:5gKvZ9o0cUu-Xmg8V1m_lX1HyQqwRuBU7qP4NYmG8RJKWFiFreLTMQ>
    <xmx:5gKvZ1juRAyEQpFHS0rEiIH_67FEiy3q-yapefsaw6_-CAjujB9BGw>
    <xmx:5gKvZ9tfN7IMq7gcB-50L5LcY5ytMhLuJZQBQK_nvYTM2MoHUUVUJLeO>
Feedback-ID: i12284293:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 14 Feb 2025 03:46:29 -0500 (EST)
Received: by sf.qyliss.net (Postfix, from userid 1000)
	id 4490B505E71A; Fri, 14 Feb 2025 09:46:28 +0100 (CET)
From: Alyssa Ross <hi@alyssa.is>
To: linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH xfsprogs v2] configure: additionally get icu-uc from pkg-config
Date: Fri, 14 Feb 2025 09:45:10 +0100
Message-ID: <20250214084509.833013-2-hi@alyssa.is>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Upstream libicu changed its pkgconfig files[0] in version 76 to require
callers to call out to each .pc file they need for the libraries they
want to link against.  This apparently reduces overlinking, at a cost of
needing the world to fix themselves up.

This patch fixes the following build error with icu 76, also seen by
Fedora[1]:

	    /bin/ld: unicrash.o: undefined reference to symbol 'uiter_setString_76'
	    /bin/ld: /lib/libicuuc.so.76: error adding symbols: DSO missing from command line
	    collect2: error: ld returned 1 exit status
	    make[2]: *** [../include/buildrules:65: xfs_scrub] Error 1
	    make[1]: *** [include/buildrules:35: scrub] Error 2

Link: https://github.com/unicode-org/icu/commit/199bc827021ffdb43b6579d68e5eecf54c7f6f56 [0]
Link: https://src.fedoraproject.org/rpms/xfsprogs/c/624b0fdf7b2a31c1a34787b04e791eee47c97340 [1]
Signed-off-by: Alyssa Ross <hi@alyssa.is>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
Changes since v1:

 • Expand patch description with Darrick's suggestion.

v1: https://lore.kernel.org/linux-xfs/20250212081649.3502717-1-hi@alyssa.is/

 m4/package_icu.m4 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/m4/package_icu.m4 b/m4/package_icu.m4
index 3ccbe0cc..6b89c874 100644
--- a/m4/package_icu.m4
+++ b/m4/package_icu.m4
@@ -1,5 +1,5 @@
 AC_DEFUN([AC_HAVE_LIBICU],
-  [ PKG_CHECK_MODULES([libicu], [icu-i18n], [have_libicu=yes], [have_libicu=no])
+  [ PKG_CHECK_MODULES([libicu], [icu-i18n icu-uc], [have_libicu=yes], [have_libicu=no])
     AC_SUBST(have_libicu)
     AC_SUBST(libicu_CFLAGS)
     AC_SUBST(libicu_LIBS)

base-commit: 90d6da68ee54e6d4ef99eca4a82cac6036a34b00
-- 
2.47.0

