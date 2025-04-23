Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DE519F13F
	for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 10:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745405165; cv=none; b=ItylPl5mIsAt+/gpRO2yepdOR26Qsq7zvu9/c1olj1VTDDO9IusOwZXkMD7FhT4mZLo5Q7VwxLmtgRQ9PnnP8zxeL/TFtpgoAGkecM8y6tMHu/Rt7x1Py9HGUXM/+0BaWQ5npetI+oos7SFPhL1bg7uCV7o3l/XrkdGQNJMeT6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745405165; c=relaxed/simple;
	bh=6tcMaEYgL5UWMl1na2lCFurcWLSJlwRW6ITNuZk4z1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T99bWumc/32om58bBKV7MefLoQp1M3T8eCkPIJL0mN/vBWKDYgTuFRz5lIVvLUBrOPY9DqAPPeuzuvnHnzsyEGak85dzNC0V9xmeN62DT450aOwKmpdpnbtrP/mmviyHwsblW7Oab7SId9QLx1LYN9QL7bnCDNcCBLFZGoMe4YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bpt2japC; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bpt2japC"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3913d129c1aso604016f8f.0
        for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 03:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745405162; x=1746009962; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/IKj7wBjc8QQLxh8p7AhG5yJoVyoAdGU50ETxwRrqzI=;
        b=bpt2japCmZaepCtRTTBXuKXLmR169LJc0BmWLnayIZzaioN89rf4f7+M2f7iQKOQ0v
         yQe7Ev+S8NvZJw3ZeUJyTq2eIzfigLcjY+1k7HJ7EWxzFgCzuWwAok3KwKgVRpVMAWj6
         D4bBnUV93MqohiRFWSdcP7GjVtfh/CRUKZ50djrT12xV9nZFjCfga4zsRis9SWb3y86+
         FLePsWek5/v3idvG41M0BEEP1N37Z8OrR2qOW7IMQPuvlpj8UCkSHPfD8GU7ChOCKXNO
         hScGOtL+oCiAaSOIm0S6Ooa/dSAo6Z8FQwhMYXjYVLufvFY6UoWv/bR16NOg/lXhrXx3
         SQdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745405162; x=1746009962;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/IKj7wBjc8QQLxh8p7AhG5yJoVyoAdGU50ETxwRrqzI=;
        b=xB5iW8ReDyHAgtrwNYv83DUU8lQk+HfqX0npRCu6IQT256qZNmKRFcBCoAKO1ztLc/
         /dVaG+uWCkCx5mDnxtj1UUH5zQa/caGOinwhQvDFclnJifaXVZfQOZeS2EW0znfdXWHm
         sls90fWG/kfuZ/mgirN4zdke/c3hiK4NVNqop4dfJEWrwFmK/wC5ON4Up30i/DbmNNdo
         N8gP1laFCoVf4jFX9oH4UpTd/7PR2tjyzY1QOkRzog66hiFt6z7d5oIP4Q2YJ1vrc5cR
         RtKa8Wl40fOLPLIheXx+PIDMqF5H313/Kbpln2S2dOMyx5uMW7WJhV9d4p4BGBF8IOT9
         O0yw==
X-Gm-Message-State: AOJu0YwVe5Gle9IGUaYkGrsydtlh6eMs/A4KNUis19h09GuL8Tz/56Qj
	TjewkbLBQ1EfrWHQqzZJ5WwkyWCexNJ1hTzLCA0gOD/54JI0fPMbNVnO6w==
X-Gm-Gg: ASbGnctF6GlRDW22Dgl4hcggTltVOP0f9RzI0o64LobLwhk1Znm34+VJgLJHCEWwMyd
	d9XpaHJ0avpWAuBV0G5WSbWeg5kIf3YnfSRfae47m8njnxBqigTjDIkPdIzo6RU+lGoUl1RSYZq
	7/dPKrwUABpFUWaJW7C7QKTRKxD4PSghQWz8rV1KCiQMwVv8+hIw1B3Tf7bzCdQ3uOPZQ/jo3I6
	GUGfdHZD5jqqaz0oFhFfcHZyjnIyBKY2Z8dv1ab7Vhz3Ir7+TmMmvqhyidZbqRyvG/gphmfJa6/
	uZS3NperluHpQCGp9rA=
X-Google-Smtp-Source: AGHT+IFIzTc+cpfqTRWb/DcsK9JmhqsGmHoX2G8z2vYevtNLRIC74KJ5RPd0mGZBigXjcSClkEI09Q==
X-Received: by 2002:a05:6000:1889:b0:39c:1efb:eec9 with SMTP id ffacd0b85a97d-3a0672430c0mr1895752f8f.13.1745405161625;
        Wed, 23 Apr 2025 03:46:01 -0700 (PDT)
Received: from localhost.localdomain ([78.209.88.10])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39efa43ca78sm18214925f8f.47.2025.04.23.03.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 03:46:01 -0700 (PDT)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev,
	djwong@kernel.org,
	hch@infradead.org
Subject: [PATCH v5 1/4] proto: expose more functions from proto
Date: Wed, 23 Apr 2025 12:45:32 +0200
Message-ID: <20250423104535.628057-2-luca.dimaio1@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423104535.628057-1-luca.dimaio1@gmail.com>
References: <20250423104535.628057-1-luca.dimaio1@gmail.com>
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
