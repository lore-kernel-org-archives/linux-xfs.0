Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3202F17C2;
	Sat, 23 Nov 2024 07:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732348274; cv=none; b=LSvBrvGrtXjCGX+6Bs2utYpQVWhzG4V9ChPDDMqdMuWXCgZ9ewQg/GAjioBdTttg5fCW9s819QoH3xn5+iJLQATgS9v8bgOQQWOjbYDdtF4Pr07brd0kmgfcgpHOeVd/LapKR3j9tA8CvUaIFOFYhU5wwSUdznihxD9398y63Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732348274; c=relaxed/simple;
	bh=8aChVbkK0EVXAN7NoXRGD/tIqKzSh29p3UYm7S7ulYs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MaNktEKDWnFom1kvFQWfV2PZjpGEoKyBhwAFWRcXa9N/pL8XLXHSr72UNas3r+Dim4UuC3RCIEKmuUbbFUZ5ZJMA6pg++f2RqfbFWqqPMurc4/SxV5pV5fEViBxuwo8qCvk3MoiunlQCP/XvNoPWxeIRUEsvr5iDqkkJO3B+hPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EEH3EUFl; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EEH3EUFl"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-aa503cced42so228592266b.3;
        Fri, 22 Nov 2024 23:51:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732348271; x=1732953071; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JjqODffSLarE4IkaHSg6ABv//2c3FMpHj9F25S+cusA=;
        b=EEH3EUFlDC1eDDcBXV5CP81mHoSNSMcjezX1Ay8juQAQvtN1PisHj7wJbB66tl4GcO
         bKOvpePBz7GZtSv+WAHBttduBlU5ZNHcyKWJ93eW6v7qtr6G424/MbdxSLfCtYQ6Onph
         qFfy7+tWg+xivnjlPm4flUU3/9R0p+UPAK2IkSKjOj9cJYVWfu3uGpbJMsDQgLl+sceI
         r1fENCbAwWlfOSAGwkmMMvTMBZpSKFkLNFLwBCqHOGgL0cVqsB7ujw2T92DuYBTGhE5v
         bjsYyd89OpxKx6RLNEAPGXJsq8ChN1VCKNS8GOAFNpHFSW0yxIyZcO8K3//2EukQxTNG
         zAlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732348271; x=1732953071;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JjqODffSLarE4IkaHSg6ABv//2c3FMpHj9F25S+cusA=;
        b=fVzJk+eChE7+U2+/oiYzjLFKpYNkUZKHoDkoNTVO2VrE81AbuOqKZ/rKAmo4gYbZpV
         nGvzErI++XOa5u7TMEQOmqCTF4upVYCediI98rtWQqxtV2Xi+wgNkX+t2P/xMFzsnn34
         FFxhiR7I5q4T9pwyUhLqI/5B7Y6xVP5gtm+qaGGGWjf5Ya1qCqb3bMPG44D7n/ddqZa+
         GOhJ0zeiJjOY4LIPvnz8As98UHfd7eA45who+Lt0VfdKoydbqyJAw78FYYfdPn02EBKN
         CqlsPMcslqvH5r3MHhIIPbxy2LG0sIUbdCIiN238wIAOmYlsyf8XGJWUlmVctCy6B/xr
         /adw==
X-Forwarded-Encrypted: i=1; AJvYcCUS63s6rWd+o+9bhF6d1dQmO5Spa9YtkWC1FIg99xhuvB6NnVo9/pEoLEksQ2MyZnmS/BYR3yTrhXf5Q+A=@vger.kernel.org, AJvYcCVGbdlJIwgfRKCE0oimRkphIY9UQxyUDpxi/riAIAVo44uCqN2pz2o29SAkttrWbVt83BbOKwyvUcHM@vger.kernel.org
X-Gm-Message-State: AOJu0Yxy39YaQ+acC/eldz0l1kEao7AUo4A3VKojG5FyQ0XcGiESD08V
	3DqjUDHliJGwciFFFqwiciirJdq8kNcUadeIHDtWJgmkUmmNiFHM
X-Gm-Gg: ASbGncuKOQu9HsCTK9j+k2wmsW6cZLZnX4uET8M+9SnBqnFVd/ZC+SVyBgEGhh7faOb
	dKhGJz+eCWWTwOzCgVM35HcOgtohbuOewmp8gRmk7p/k65jmzO4cSmgTO75a/iC9N/eFX27kuGP
	5HT0b23w3bH8Yb/6o9hzf84mlTQ7CAL8TkB7pdpZVp/rvoFcHJiMUkHuQl1HNstdmF9C42/JTo8
	6P4H5AqEGTsnrZv4JHxE2onwZ9f7DCutnvzPm9uUzkDITHA54psf9V4Aeaynqmxog==
X-Google-Smtp-Source: AGHT+IErZcIlg5kLu3d34Vm8i/ExFg/oGLWvlYWlzHxp2Oc+UxIkYf8KBPYGqAuIWUP4YNL7LhvD9g==
X-Received: by 2002:a17:907:7844:b0:aa5:2bfb:dd4d with SMTP id a640c23a62f3a-aa52bfbdffcmr198373566b.0.1732348271299;
        Fri, 22 Nov 2024 23:51:11 -0800 (PST)
Received: from f.. (cst-prg-93-87.cust.vodafone.cz. [46.135.93.87])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa50b57c19esm191456666b.154.2024.11.22.23.51.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 23:51:10 -0800 (PST)
From: Mateusz Guzik <mjguzik@gmail.com>
To: dchinner@redhat.com
Cc: cem@kernel.org,
	djwong@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH] xfs: use inode_set_cached_link()
Date: Sat, 23 Nov 2024 08:51:05 +0100
Message-ID: <20241123075105.1082661-1-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For cases where caching is applicable this dodges inode locking, memory
allocation and memcpy + strlen.

Throughput of readlink on Saphire Rappids (ops/s):
before:	3641273
after:	4009524 (+10%)

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---

First a minor note that in the stock case strlen is called on the buffer
and I verified that i_disk_size is the value which is computed.

The important note is that I'm assuming the pointed to area is stable
for the duration of the inode's lifetime -- that is if the read off
symlink is fine *or* it was just created and is eligible caching, it
wont get invalidated as long as the inode is in memory. If this does not
hold then this submission is wrong and it would be nice(tm) to remedy
it.

This depends on stuff which landed in vfs-6.14.misc, but is not in next
nor fs-next yet.

For benchmark code see bottom of https://lore.kernel.org/linux-fsdevel/20241120112037.822078-1-mjguzik@gmail.com/

 fs/xfs/xfs_iops.c    |  1 +
 fs/xfs/xfs_symlink.c | 24 ++++++++++++++++++++++++
 fs/xfs/xfs_symlink.h |  1 +
 3 files changed, 26 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 207e0dadffc3..1d0a3797f876 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1394,6 +1394,7 @@ xfs_setup_iops(
 		break;
 	case S_IFLNK:
 		inode->i_op = &xfs_symlink_inode_operations;
+		xfs_setup_cached_symlink(ip);
 		break;
 	default:
 		inode->i_op = &xfs_inode_operations;
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 4252b07cd251..59bf1b9ccb20 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -28,6 +28,30 @@
 #include "xfs_parent.h"
 #include "xfs_defer.h"
 
+void
+xfs_setup_cached_symlink(
+	struct xfs_inode	*ip)
+{
+	struct inode		*inode = &ip->i_vnode;
+	xfs_fsize_t		pathlen;
+
+	/*
+	 * If we have the symlink readily accessible let the VFS know where to
+	 * find it. This avoids calls to xfs_readlink().
+	 */
+	pathlen = ip->i_disk_size;
+	if (pathlen <= 0 || pathlen > XFS_SYMLINK_MAXLEN)
+		return;
+
+	if (ip->i_df.if_format != XFS_DINODE_FMT_LOCAL)
+		return;
+
+	if (XFS_IS_CORRUPT(ip->i_mount, !ip->i_df.if_data))
+		return;
+
+	inode_set_cached_link(inode, ip->i_df.if_data, pathlen);
+}
+
 int
 xfs_readlink(
 	struct xfs_inode	*ip,
diff --git a/fs/xfs/xfs_symlink.h b/fs/xfs/xfs_symlink.h
index 0d29a50e66fd..0e45a8a33829 100644
--- a/fs/xfs/xfs_symlink.h
+++ b/fs/xfs/xfs_symlink.h
@@ -12,5 +12,6 @@ int xfs_symlink(struct mnt_idmap *idmap, struct xfs_inode *dp,
 		umode_t mode, struct xfs_inode **ipp);
 int xfs_readlink(struct xfs_inode *ip, char *link);
 int xfs_inactive_symlink(struct xfs_inode *ip);
+void xfs_setup_cached_symlink(struct xfs_inode *ip);
 
 #endif /* __XFS_SYMLINK_H */
-- 
2.43.0

