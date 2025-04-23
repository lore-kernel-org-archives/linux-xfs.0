Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524BA242D64
	for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 16:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745424957; cv=none; b=EbKxXXPVBVnSxAOJe8JULKn9G2eZKEawyBCVqsQMSrVVb/+CPO5+NRedvk25T7sHpN6AJ9EWa9Gl81ZM9L0mp5ppwyN0bw+vm/v2QhgYrBHwBmFZEkxjW1je9kJAUZejtp4itM8gbeZXXYb2Qrh5qK9xDGXKc/0Z4/39+/yTnr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745424957; c=relaxed/simple;
	bh=K3OUhiOI/hPL5/bSlqk/8zma986vKhRGE3xiIqWOX8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZe/WWEVJCs7giAKHkSMWVL4L3TyQ9q0+eIarqAzZ0IYbzb2vMIpU/Y2sZ5UQ/NjyqQtGX3GuYY6mgv98qFukBDbwAukOBJubmLaoCEYSfDEhPn0PAKt4W6w7oGNcyfLnma8NPFRLCx+PLB4onlVvpn0/y1PrDhNcjvh/RtmRnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SKNG9ala; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SKNG9ala"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-39c1efbefc6so4264283f8f.1
        for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 09:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745424953; x=1746029753; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O3Cjm3eOcLkeX2WzIAuk/s5uERN+6+5ywXixDj1GOZ0=;
        b=SKNG9alaY23gfrkicXqnk7pLX4kxWstSAWUGNCfFbTc4PaSUi3sOtjB4Q1VAkrpGzq
         7kO8U+keeUU8Gc5wt0S09Z4ayrdvWfwbWfvmFGcGs3HVKRlsrPqcmZs05s5bwc/Dil9A
         9DpAB5L5NyHBIqJIlXhJ/3V83aAFMlVeKn6L7Yu0Vv6BFgNJ/gIjpK0B5ktPxoItKr6S
         rSUVEj9sGs9No93AIAKSadeVjCVxX2RtUaWjb6Mwh7384ZUgQWaT2zr3cDod1kLlH53Z
         l8G/YSAs4nhiKcMwilflGSeLvMFj2ELDMAwaJrctV4b7tyIGUyk7lNfLdzmDFoL97FKC
         r7cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745424953; x=1746029753;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O3Cjm3eOcLkeX2WzIAuk/s5uERN+6+5ywXixDj1GOZ0=;
        b=TB3DRKOkqx0pFnZZUt/trcM9Fg9u3/h26woJMRHkSE8GQemJgcry/FgyLKXSKaXHw4
         PNbStRsiV1Vh60rf+uxdskwseCrKYWLTsZILDNA29gD4eZXgSxpu92FgdwfbngTeQEaP
         jTmT3YaEh+iALizqQCJkDathpYEEH9L4xcxTT/bqq7Z5GgS0EyjhhCdiYBkDjihssj5Z
         KRiyPgplfuYdCwR4ymRbQJemazoFIIllcZ1LUxrhfK2Ir38SfQbWv6Glao+i6Z4zGujT
         Jz+N/sUSeAqifb8BuEnmpuMdSt2KuxCrETW71hxUVEshk7o6nfS2orC7IOD3S+eqQ/1A
         w5qw==
X-Gm-Message-State: AOJu0Yyw/Cm9HVCqQph4wmXmVmA0Rfzf9v/3oute0kgSUBhHJl3EP+6T
	OO76qPWv+csnQ3g0fG2GPwGW+vI61jgOLriE6bOl83ThL1EuwBuup/RkIw==
X-Gm-Gg: ASbGncvdG1jw7V7hYPF9MYWyG8093UxZC6bSYj+dtOo7iz2aYKkF3g+2s/0bFFInVuM
	b0aPOzUnpjirjyACloElIISvCVbQ7QsKuc+tMpfOjk/KpNqU5RuwyCrCIqICIjmROEmI5eEzrUm
	ucE8A8yU3sK27u6SNfnd6QdG4a12qfyhKNQj/4AzKXT8okNc9qZbVHgRiYvojy58NjI9bU6Z0T4
	GNf2f9N6H5qyLd5BftyPeMQbgB5tVgW5wfAfoKsD0WPLbdSPh9iqCf3iTmj689ZnMj2iU9bM0Th
	CoSJtWTGtzKbmD905sfA
X-Google-Smtp-Source: AGHT+IG8MRBB2ZtXp6HD9I1vBqTMmk5LIOx3KRW0643erLQIk1gPyt92zem0s5lp3X5jw/g22Rj6qA==
X-Received: by 2002:a5d:5f87:0:b0:39e:cbf3:2660 with SMTP id ffacd0b85a97d-3a06c3fe3c1mr174840f8f.3.1745424953313;
        Wed, 23 Apr 2025 09:15:53 -0700 (PDT)
Received: from localhost.localdomain ([78.209.93.220])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39efa421c79sm19083567f8f.1.2025.04.23.09.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 09:15:53 -0700 (PDT)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev,
	djwong@kernel.org,
	hch@infradead.org
Subject: [PATCH v6 1/4] proto: expose more functions from proto
Date: Wed, 23 Apr 2025 18:03:16 +0200
Message-ID: <20250423160319.810025-2-luca.dimaio1@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423160319.810025-1-luca.dimaio1@gmail.com>
References: <20250423160319.810025-1-luca.dimaio1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In order to minimize code duplication, we want to expose more functions
from proto. This will simplify alternative implementations of filesystem
population.

Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
---
 mkfs/proto.c | 33 ++++++++++++---------------------
 mkfs/proto.h | 22 ++++++++++++++++++++++
 2 files changed, 34 insertions(+), 21 deletions(-)

diff --git a/mkfs/proto.c b/mkfs/proto.c
index 7f56a3d..695e1a6 100644
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
-static off_t filesize(int fd);
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
@@ -1151,7 +1142,7 @@ rtinit_groups(
 /*
  * Allocate the realtime bitmap and summary inodes, and fill in data if any.
  */
-static void
+void
 rtinit(
 	struct xfs_mount	*mp)
 {
@@ -1161,7 +1152,7 @@ rtinit(
 		rtinit_nogroups(mp);
 }

-static off_t
+off_t
 filesize(
 	int		fd)
 {
diff --git a/mkfs/proto.h b/mkfs/proto.h
index be1ceb4..9abb9b8 100644
--- a/mkfs/proto.h
+++ b/mkfs/proto.h
@@ -5,10 +5,32 @@
  */
 #ifndef MKFS_PROTO_H_
 #define MKFS_PROTO_H_
+struct cred {
+	uid_t			cr_uid;
+	gid_t			cr_gid;
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
