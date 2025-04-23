Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE01227466E
	for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 08:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745396601; cv=none; b=Ne7N6/7f3sM0uGe6xo4RhezVPOjNVr6oFU8n1oOozsAAbnkKfFopEgYKCZ6amWU4wCqPiQT4YgaCQO8eM3RdImmEASVOMFLpcCRC6V3IhjN3KbaoJIKlhvp434L7Aeafju+mWbVkc8DFNQDX7M9dimmrQOoq+Hum2pUs9PVqVXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745396601; c=relaxed/simple;
	bh=Wv8Z5Qhwb7nPc57UNBf022h/iLN7VuTWBpzvWKJH0MM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/s8355zhGsCaW9J/oDgkAFWeVpeXTVcjWVOreHsB44ZMAIPYnf+I0YTnjhA5gunfNQIA9efXShCvk7c1H2fMO7lDP+5J64hEyqAjKPeyLWH8tdrgH7D9TAtGxXd7p5TaJQ0pEQQqUGB6C9eG7ZcefVPfuTeIUodcRXvd3t7OC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KIp9W8t8; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KIp9W8t8"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-39c1efc457bso3938647f8f.2
        for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 01:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745396596; x=1746001396; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SECg+NK/thM8s3OtgtCfIYDfvRgsusSkcc20PVG2Omw=;
        b=KIp9W8t8YLyJ4z00IfmNVbtba5J1b8NG5kslQuk5zAxXIZJRJG5QkU4yAp5urjxpp2
         Tl2wbo7yYuvJk4AY0CMpxAQq92G/ndHlP3RWr3VEcdcMIoBml/bZSRZ53mSbwRXruimT
         gNfSY1IX7aWMfdTR6l4jWKVgp7FPGpDhxDXLi95PGIpz5blqaIJsd8R38065DN/uZobv
         tBa00Gfh9VkU5K/vUoeeBMgpAKAoWmEtvzRC/xv6nL74iHNnUesFWoAEdlF2yusP6bjN
         eIx5zo8Oe4frnbqXDEY2rC6/q1hShaoqutUXOkjL8TKrEg20Dsv4QWk3XY9Gds9283s9
         atuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745396596; x=1746001396;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SECg+NK/thM8s3OtgtCfIYDfvRgsusSkcc20PVG2Omw=;
        b=cNyyQ/v5KIctkViGv4XTH2t5wx3cDGREODtP58iBX8FMQqE3WKP0EaOyCnWTxsLx/O
         F45TU9Z7MpO1xkV6Hz9GiCm0H0NF7tY1r1bUciB0nXUIJ7jBHjKgoJfOYAwt5RQIkmqh
         je5yW/n52ldDs8ul/X6HB0RtgigAGjIpIlxoyndW1JUpF7iMU6txgVXXIf0qz5ABYqMq
         9oBGvyP4BgwYnaoi7oruiQkToLsdk+k8U7TMPw2Gx8WMcKPjPEMAVLAPVkwwzFAllPo0
         cMsslPR4fWXvqYSvTFuq0irEpFU7BBV32mGJejcWr41CgGO/zoETOvNb9Je9dAnUWIjD
         aHEQ==
X-Gm-Message-State: AOJu0YwrY6OChdd01K4h7kfMHHN8G/WNufzWT4eurex0Bco8GttMoSY9
	xmJwm9pw8TWuLamUHbavVz1cJ0KcHXU6ZEz6Yci7cYg0eaRcKXCrWDSBvA==
X-Gm-Gg: ASbGnctozjUyEb81zbuEfQ6OuwX7+DUdVJP1s8TqZ+87K0jndHlZvU32CBSqJ8ht3O9
	yaPu+Sr/u7Md/Jpt5uIdwrZOrgNyn+lLPSdJJtVvv/UPahwXF8MvEDqNTuslhTjDTpfI3Smz+Nn
	UPQk5fuwgb9vTeKKnYBdv94kvix4TbTstuVGFq4OKQAiTvQM2uRwdbvbZHW9nxMZFmhJuJwr9U1
	Ug1xhkJBl4a7y2vd8YmI7jToCnkSlIvpxJL6WDPY8Uc9+ont1WBUmCpSdPrVw1rBhQEa5wgVBtr
	8Z20VmlsEQHLPX3tHzzs
X-Google-Smtp-Source: AGHT+IF8mEdC/ZrX2dpyWgvuXgAyvpYmtlAWOdGg4AA4L/VaxRw63+Lj01JE4jAJ8pO8lhB5qzPDsQ==
X-Received: by 2002:a05:6000:4201:b0:39e:cbc7:ad2c with SMTP id ffacd0b85a97d-39efba5ede7mr14396776f8f.25.1745396595423;
        Wed, 23 Apr 2025 01:23:15 -0700 (PDT)
Received: from localhost.localdomain ([78.208.91.121])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39efa4a4c37sm18345313f8f.98.2025.04.23.01.23.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 01:23:15 -0700 (PDT)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev,
	djwong@kernel.org
Subject: [PATCH v4 1/4] proto: expose more functions from proto
Date: Wed, 23 Apr 2025 10:22:43 +0200
Message-ID: <20250423082246.572483-2-luca.dimaio1@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423082246.572483-1-luca.dimaio1@gmail.com>
References: <20250423082246.572483-1-luca.dimaio1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In order to minimize code duplication, we want to expose more functions
from proto. This will simplify alternative implementations of filesystem population.

Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
---
 mkfs/proto.c | 33 ++++++++++++---------------------
 mkfs/proto.h | 22 ++++++++++++++++++++++
 2 files changed, 34 insertions(+), 21 deletions(-)

diff --git a/mkfs/proto.c b/mkfs/proto.c
index 6dd3a20..d5122e0 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -16,11 +16,7 @@
  */
 static char *getstr(char **pp);
 static void fail(char *msg, int i);
-static struct xfs_trans * getres(struct xfs_mount *mp, uint blocks);
-static void rsvfile(xfs_mount_t *mp, xfs_inode_t *ip, long long len);
 static int newregfile(char **pp, char **fname);
-static void rtinit(xfs_mount_t *mp);
-static long filesize(int fd);
 static int slashes_are_spaces;

 /*
@@ -115,7 +111,7 @@ res_failed(
 	fail(_("cannot reserve space"), i);
 }

-static struct xfs_trans *
+struct xfs_trans *
 getres(
 	struct xfs_mount *mp,
 	uint		blocks)
@@ -196,7 +192,7 @@ getdirentname(
 	return p;
 }

-static void
+void
 rsvfile(
 	xfs_mount_t	*mp,
 	xfs_inode_t	*ip,
@@ -242,7 +238,7 @@ rsvfile(
 		fail(_("committing space for a file failed"), error);
 }

-static void
+void
 writesymlink(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
@@ -303,7 +299,7 @@ writefile_range(
 	}
 }

-static void
+void
 writefile(
 	struct xfs_inode	*ip,
 	const char		*fname,
@@ -410,7 +406,7 @@ writeattr(
 		fail(_("setting xattr value"), error);
 }

-static void
+void
 writeattrs(
 	struct xfs_inode	*ip,
 	const char		*fname,
@@ -467,7 +463,7 @@ newregfile(
 	return fd;
 }

-static void
+void
 newdirent(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
@@ -498,7 +494,7 @@ newdirent(
 	}
 }

-static void
+void
 newdirectory(
 	xfs_mount_t	*mp,
 	xfs_trans_t	*tp,
@@ -512,7 +508,7 @@ newdirectory(
 		fail(_("directory create error"), error);
 }

-static struct xfs_parent_args *
+struct xfs_parent_args *
 newpptr(
 	struct xfs_mount	*mp)
 {
@@ -526,12 +522,7 @@ newpptr(
 	return ret;
 }

-struct cred {
-	uid_t			cr_uid;
-	gid_t			cr_gid;
-};
-
-static int
+int
 creatproto(
 	struct xfs_trans	**tpp,
 	struct xfs_inode	*dp,
@@ -594,7 +585,7 @@ creatproto(
 }

 /* Create a new metadata root directory. */
-static int
+int
 create_metadir(
 	struct xfs_mount	*mp)
 {
@@ -1122,7 +1113,7 @@ rtinit_groups(
 /*
  * Allocate the realtime bitmap and summary inodes, and fill in data if any.
  */
-static void
+void
 rtinit(
 	struct xfs_mount	*mp)
 {
@@ -1132,7 +1123,7 @@ rtinit(
 		rtinit_nogroups(mp);
 }

-static off_t
+off_t
 filesize(
 	int		fd)
 {
diff --git a/mkfs/proto.h b/mkfs/proto.h
index be1ceb4..8cb6674 100644
--- a/mkfs/proto.h
+++ b/mkfs/proto.h
@@ -5,10 +5,32 @@
  */
 #ifndef MKFS_PROTO_H_
 #define MKFS_PROTO_H_
+struct cred {
+    uid_t cr_uid;
+    gid_t cr_gid;
+};

 char *setup_proto(char *fname);
 void parse_proto(struct xfs_mount *mp, struct fsxattr *fsx, char **pp,
 		int proto_slashes_are_spaces);
 void res_failed(int err);
+struct xfs_trans *getres(struct xfs_mount *mp, uint blocks);
+struct xfs_parent_args *newpptr(struct xfs_mount *mp);
+void writesymlink(struct xfs_trans *tp, struct xfs_inode *ip,
+                 char *buf, int len);
+void writefile(struct xfs_inode *ip, const char *fname, int fd);
+void writeattrs(struct xfs_inode *ip, const char *fname, int fd);
+void rsvfile(xfs_mount_t *mp, xfs_inode_t *ip, long long len);
+void newdirent(struct xfs_mount *mp, struct xfs_trans *tp,
+              struct xfs_inode *pip, struct xfs_name *name,
+              struct xfs_inode *ip, struct xfs_parent_args *ppargs);
+void newdirectory(xfs_mount_t *mp, xfs_trans_t *tp,
+                 xfs_inode_t *dp, xfs_inode_t *pdp);
+int creatproto(struct xfs_trans **tpp, struct xfs_inode *dp,
+              mode_t mode, xfs_dev_t rdev, struct cred *cr,
+              struct fsxattr *fsx, struct xfs_inode **ipp);
+long filesize(int fd);
+void rtinit(struct xfs_mount *mp);
+int create_metadir(struct xfs_mount *mp);

 #endif /* MKFS_PROTO_H_ */
--
2.49.0
