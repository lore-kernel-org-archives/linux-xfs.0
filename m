Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3A815ECEF
	for <linux-xfs@vger.kernel.org>; Thu,  9 May 2024 15:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715267725; cv=none; b=Flfs+WPNjJ7p3wtlbD/N45OZZVcryTmDQxghYzG6ShC5HGPshFasiAT2WCI+8XScYe1xMUklYsDJwy1f3cGGwH4EO+249yuYn5tWSjz5+/TiJ4yhuWAhGlmLQBmEn11mxwX4Z59XrG1NC/OJ+io5kP+eM2fPXB1w9wp0LNs1d5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715267725; c=relaxed/simple;
	bh=B+MXNH6SjKJPDVfwlZCqff4StUEqeP2tU28dLpP82KU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HwnG6bxMjikmaTVnCs8u10GWChn98XxFnZvt4O1DrTJlezKIME2wedBP71+bCXPiV5nLIYvxmyejvZsAOrFQxxfssG05YKUpHWnZLaJDrETefCR0Xvr9OPaVVeexqgxJbTpHOmrNrPgFphfxN4uPcRCPTzd24NCdmUWV/BWViKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ND6fYyTI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ND6fYyTI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715267720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RY+ugPrDK83tQomk3xmQyphPy5GlvX952C2zVFWwL9A=;
	b=ND6fYyTICvGbN78Gd2Ww33QMolE3etpDjiv7B/Gp7mdxbVSpKPQTF0/HZVnGdB+BU18N1F
	0IcrgibP5lVOiijqqyMzHdTwB0DmNqc+WyFVnSdxoSviv6sonqIOjd7JGiWniJXf5yGfsc
	Y1qPOXbldtc03nIO4Ol8CGAmLgi38kc=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-18-g8jaVV2EMSWgHft5EyZQJA-1; Thu, 09 May 2024 11:15:18 -0400
X-MC-Unique: g8jaVV2EMSWgHft5EyZQJA-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a592c35ac06so104578066b.0
        for <linux-xfs@vger.kernel.org>; Thu, 09 May 2024 08:15:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715267717; x=1715872517;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RY+ugPrDK83tQomk3xmQyphPy5GlvX952C2zVFWwL9A=;
        b=WzbbsQ8ET5yvXbixusuU6Uox3tFnpi1YqI9qkDCKmIWeS81MG399+pT+6tMHd+Pi2j
         lysmmToS1NvWQu0cMJzZgluZhsPONhIv/jXJwXABWup5D3g6tSndCAv3xDVFEhnyWu8c
         7xvDQy614solknN6YXju5S5o+V6xm5+xt0FD8P8woWWuJzpwnA5ad2VBx+ba1bxaU53C
         l7Jt7VQDtPX5tXtvDmyCY0I2O8GqCXMPFLADD7ErxZbb3+S6fd8vSMjRzWU9ygU4B46O
         89bfKY+liVfqG91WuR2AReIbp8gBpEDZY3vQ9yuaBeLTIa/JnELNB3msjVIK2HbtWxxt
         e7/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXhnaC0p/oU+uXllhcXwXVhpl2zII2izTJq7ZMuMo/UC7tnJmVL8RvdYkcRCS8w2mkarjtHJV+27h6u9aJXnS9bXtMfxgcTip4v
X-Gm-Message-State: AOJu0YzgCcEx9RuM75WxA5Ud0wXbqk5bs0M6wqpJfB1EPLXd2TLsnKN1
	sj+n73hyPQagYmH6UUrRFu8xz6Um+jpVldlG3LszCbLYGCI9STvV2TspFNvYCLOAN7Y0DciaEeR
	7FcNERHs11JzIpn0xRulJYcSVW8zFT3R+h1E+zUfCNJUYuhRI82jCYKWL
X-Received: by 2002:a17:906:2a11:b0:a59:a85c:a5ca with SMTP id a640c23a62f3a-a5a2d18b04amr940666b.7.1715267717239;
        Thu, 09 May 2024 08:15:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGSiXphLOfsmbMLx7yciNd95cjz6zMV0Vui4i9K4qSbDDKW3Q5leA26X5GzVYRPu8Dd9WV0Lw==
X-Received: by 2002:a17:906:2a11:b0:a59:a85c:a5ca with SMTP id a640c23a62f3a-a5a2d18b04amr937766b.7.1715267716702;
        Thu, 09 May 2024 08:15:16 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a5a17b01785sm82035866b.164.2024.05.09.08.15.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 May 2024 08:15:16 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-fsdevel@vgre.kernel.org,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 4/4] xfs: add XFS_IOC_SETFSXATTRAT and XFS_IOC_GETFSXATTRAT
Date: Thu,  9 May 2024 17:15:00 +0200
Message-ID: <20240509151459.3622910-6-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240509151459.3622910-2-aalbersh@redhat.com>
References: <20240509151459.3622910-2-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

XFS has project quotas which could be attached to a directory. All
new inodes in these directories inherit project ID.

The project is created from userspace by opening and calling
FS_IOC_FSSETXATTR on each inode. This is not possible for special
files such as FIFO, SOCK, BLK etc. as opening them return special
inode from VFS. Therefore, some inodes are left with empty project
ID.

This patch adds new XFS ioctl which allows userspace, such as
xfs_quota, to set project ID on special files. This will let
xfs_quota set ID on all inodes and also reset it when project is
removed.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/libxfs/xfs_fs.h   | 11 +++++
 fs/xfs/xfs_ioctl.c       | 86 ++++++++++++++++++++++++++++++++++++++++
 include/linux/fileattr.h |  2 +-
 3 files changed, 98 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 97996cb79aaa..f68e98005d4b 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -670,6 +670,15 @@ typedef struct xfs_swapext
 	struct xfs_bstat sx_stat;	/* stat of target b4 copy */
 } xfs_swapext_t;
 
+/*
+ * Structure passed to XFS_IOC_GETFSXATTRAT/XFS_IOC_GETFSXATTRAT
+ */
+struct xfs_xattrat_req {
+	struct fsxattr	__user *fsx;		/* XATTR to get/set */
+	__u32		dfd;			/* parent dir */
+	const char	__user *path;
+};
+
 /*
  * Flags for going down operation
  */
@@ -997,6 +1006,8 @@ struct xfs_getparents_by_handle {
 #define XFS_IOC_BULKSTAT	     _IOR ('X', 127, struct xfs_bulkstat_req)
 #define XFS_IOC_INUMBERS	     _IOR ('X', 128, struct xfs_inumbers_req)
 #define XFS_IOC_EXCHANGE_RANGE	     _IOWR('X', 129, struct xfs_exchange_range)
+#define XFS_IOC_GETFSXATTRAT	     _IOR ('X', 130, struct xfs_xattrat_req)
+#define XFS_IOC_SETFSXATTRAT	     _IOW ('X', 131, struct xfs_xattrat_req)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 515c9b4b862d..d54dba9128a0 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1408,6 +1408,74 @@ xfs_ioctl_fs_counts(
 	return 0;
 }
 
+static int
+xfs_xattrat_get(
+	struct file		*dir,
+	const char __user	*pathname,
+	struct xfs_xattrat_req	*xreq)
+{
+	struct path		filepath;
+	struct xfs_inode	*ip;
+	struct fileattr		fa;
+	int			error = -EBADF;
+
+	memset(&fa, 0, sizeof(struct fileattr));
+
+	if (!S_ISDIR(file_inode(dir)->i_mode))
+		return error;
+
+	error = user_path_at(xreq->dfd, pathname, 0, &filepath);
+	if (error)
+		return error;
+
+	ip = XFS_I(filepath.dentry->d_inode);
+
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	xfs_fill_fsxattr(ip, XFS_DATA_FORK, &fa);
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+
+	error = copy_fsxattr_to_user(&fa, xreq->fsx);
+
+	path_put(&filepath);
+	return error;
+}
+
+static int
+xfs_xattrat_set(
+	struct file		*dir,
+	const char __user	*pathname,
+	struct xfs_xattrat_req	*xreq)
+{
+	struct fileattr		fa;
+	struct path		filepath;
+	struct mnt_idmap	*idmap = file_mnt_idmap(dir);
+	int			error = -EBADF;
+
+	if (!S_ISDIR(file_inode(dir)->i_mode))
+		return error;
+
+	error = copy_fsxattr_from_user(&fa, xreq->fsx);
+	if (error)
+		return error;
+
+	error = user_path_at(xreq->dfd, pathname, 0, &filepath);
+	if (error)
+		return error;
+
+	error = mnt_want_write(filepath.mnt);
+	if (error) {
+		path_put(&filepath);
+		return error;
+	}
+
+	fa.fsx_valid = true;
+	error = vfs_fileattr_set(idmap, filepath.dentry, &fa);
+
+	mnt_drop_write(filepath.mnt);
+	path_put(&filepath);
+	return error;
+}
+
 /*
  * These long-unused ioctls were removed from the official ioctl API in 5.17,
  * but retain these definitions so that we can log warnings about them.
@@ -1652,6 +1720,24 @@ xfs_file_ioctl(
 		sb_end_write(mp->m_super);
 		return error;
 	}
+	case XFS_IOC_GETFSXATTRAT: {
+		struct xfs_xattrat_req xreq;
+
+		if (copy_from_user(&xreq, arg, sizeof(struct xfs_xattrat_req)))
+			return -EFAULT;
+
+		error = xfs_xattrat_get(filp, xreq.path, &xreq);
+		return error;
+	}
+	case XFS_IOC_SETFSXATTRAT: {
+		struct xfs_xattrat_req xreq;
+
+		if (copy_from_user(&xreq, arg, sizeof(struct xfs_xattrat_req)))
+			return -EFAULT;
+
+		error = xfs_xattrat_set(filp, xreq.path, &xreq);
+		return error;
+	}
 
 	case XFS_IOC_EXCHANGE_RANGE:
 		return xfs_ioc_exchange_range(filp, arg);
diff --git a/include/linux/fileattr.h b/include/linux/fileattr.h
index 3c4f8c75abc0..8598e94b530b 100644
--- a/include/linux/fileattr.h
+++ b/include/linux/fileattr.h
@@ -34,7 +34,7 @@ struct fileattr {
 };
 
 int copy_fsxattr_to_user(const struct fileattr *fa, struct fsxattr __user *ufa);
-int copy_fsxattr_from_user(struct fileattr *fa, struct fsxattr __user *ufa)
+int copy_fsxattr_from_user(struct fileattr *fa, struct fsxattr __user *ufa);
 
 void fileattr_fill_xflags(struct fileattr *fa, u32 xflags);
 void fileattr_fill_flags(struct fileattr *fa, u32 flags);
-- 
2.42.0

