Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B776292B25
	for <linux-xfs@vger.kernel.org>; Mon, 30 Jun 2025 16:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751300443; cv=none; b=F/q6PepCewOlC7Iz6/KcM6NhYjJgd65qJ0Vy1j9YJmDN/kspUPmyBtObapzqthXNFIsVgAkt1WXnSZXKVYDI0SNOKuBFCxdf23Kv0aFnhupcwk6EZRNh/LjbovUzcMtvsQZDh2sRI1BAFk/5/7ym+o4c7WS2jPsB4sITrvpr0K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751300443; c=relaxed/simple;
	bh=IwADuJENyczf/bwBuYPIR4rrw/CJ1prOrfW5cqesY5Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=GB801W2MGdlVhjm+KqnClu8RMsoc6lyha2zXlHBor/YBI82kNPOXVhnCz8CE5nUsB6ui8GrUL3UjCyIKyQeIQTL9LeaGS0qXd0HJFmKlDlV0zpsg1O+eCZzr5r9k8kSgtCYR5XbJG9nyRX6sL66v4d6t5fHldMSBPtJnCODECEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BSDXf2Bx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BSDXf2Bx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751300438;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GlL+qFUOPnhKYJXl/arb34Hj2cUvdXFZcSDvCm6FshI=;
	b=BSDXf2BxDmQcbc7xit41eQGOXn+fKGfe+EPxnfMGAN3VnHL8atv13HOCdyoT7/X2QShq/3
	U0jLnmAawfv48Myg3gbz+WrAaoQQ6HqlNdK/f8X0mbWL1EssBpLmaIS37L+Ti5JRdZL3yJ
	OZhNxfobSIG12/gStkZBD5lYdx3U0Qc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-413-XfJ7hkWhOJqr25yvzUdSbA-1; Mon, 30 Jun 2025 12:20:37 -0400
X-MC-Unique: XfJ7hkWhOJqr25yvzUdSbA-1
X-Mimecast-MFC-AGG-ID: XfJ7hkWhOJqr25yvzUdSbA_1751300435
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4530ec2c87cso15205875e9.0
        for <linux-xfs@vger.kernel.org>; Mon, 30 Jun 2025 09:20:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751300435; x=1751905235;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GlL+qFUOPnhKYJXl/arb34Hj2cUvdXFZcSDvCm6FshI=;
        b=uA9me0Tr/ogu8L0ENheod1FSy/lK3UO6lY2oLNsUv9JTqEVZgILfALlTi78TsDjmYR
         zXBPYLkpgI873yjigzEJvRSUzjiprNxJXOMR1lcvlPHwQyd6XG7ZSH7YbdjXzNUfEUPM
         /jC8lzPUehZjuoRE4rdK/k/WS8lIyM/j8zVlKasu16aY8n1fG5Kdg55lA4Te2em8rCEM
         8UPZ0m0DibPQkf7vb1WbVuw7isupZ3VDoDn583k4xAr9aRoou76w/KE636OkWpSQksm7
         jGjOAkEsGN+PX+c7hnpJ4RtQ5SrBNpadVGi5NFjEyObWCTP0Ny+4B65bPMzHiaD9wsGu
         yikg==
X-Forwarded-Encrypted: i=1; AJvYcCVcfy3giZYbpGx4ZiHFJ4B3CsWoPez2qQMUzuuAQZr7RNyqpINGf1awcJqljeSWi9SIQgMVyV0xfRQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxntYFNnQoQFv/bm1dFIxSeLDN/8mPkcp5WSr6R7eNCSiFZNxKX
	w+d5zNYWH4u4n1tFAUL69nyjhGlujQxaaS1A1FdWsnn9ZVsG2i4PGH98iItKhBxsH/TnBJQB0M2
	OFDkDPM9agxNCpzi6zFGDLzon5/291+cBuSDGqMhInAWCoTExlnjeC7k9ChdD
X-Gm-Gg: ASbGncvGZszDs9bABh/wCcCc3sSZDkMjkW0U/KCHEoM0cjPnSyeYbzf6BIll+jKVHg5
	TECk6SHqa28wVZ1Q0vmmkY/ck3h2KGvWRA9C2MFR0dNucRNYxJ7aTgiTZylbw1bmKICKXVglflX
	5ifkCN/AqqtL8NJCLBCaOw26fEVjbC/Ami4PlPhPXg9LBaCETlnLfqAlkt1SEvrhzP8BjSPJT8V
	O7My+KAVXl1+h+ccRtRxRJHpXBz89PVc/u09HADs7I3IMu1+xtrRGZ89+oOqcJuRnpFbtBU5QuW
	Tvqx8lvFTty6k6HlN1v6LsrDna/w
X-Received: by 2002:a05:600c:4ed3:b0:43d:45a:8fc1 with SMTP id 5b1f17b1804b1-4538f244121mr145675635e9.4.1751300434966;
        Mon, 30 Jun 2025 09:20:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0mlgM2WuBIj0NGAO7JpYDWypMZ7nhIDOKUHExDDi9JTWtN36FkNXEpiG/WFqMOZqsmfA9XA==
X-Received: by 2002:a05:600c:4ed3:b0:43d:45a:8fc1 with SMTP id 5b1f17b1804b1-4538f244121mr145675185e9.4.1751300434446;
        Mon, 30 Jun 2025 09:20:34 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4538233c1easm168769245e9.3.2025.06.30.09.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 09:20:33 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 30 Jun 2025 18:20:14 +0200
Subject: [PATCH v6 4/6] fs: make vfs_fileattr_[get|set] return -EOPNOSUPP
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250630-xattrat-syscall-v6-4-c4e3bc35227b@kernel.org>
References: <20250630-xattrat-syscall-v6-0-c4e3bc35227b@kernel.org>
In-Reply-To: <20250630-xattrat-syscall-v6-0-c4e3bc35227b@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
 Casey Schaufler <casey@schaufler-ca.com>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
 Paul Moore <paul@paul-moore.com>
Cc: linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
 selinux@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3358; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=IwADuJENyczf/bwBuYPIR4rrw/CJ1prOrfW5cqesY5Q=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMpJ2en+qD5NXqUucEMbfvf3H22r17tAf/0/fjdsaf
 U5u8crGl5s6SlkYxLgYZMUUWdZJa01NKpLKP2JQIw8zh5UJZAgDF6cATORUFiPD6u3Sewp/NG2b
 tVPL4QNj7k2l1J5t+vvM4lviFD/6OvFoMTLcKsnetPxBseFWzV/7Vhf92JD/dMKHlSE7FWuMv/1
 eZT2DHwBb9Uul
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Future patches will add new syscalls which use these functions. As
this interface won't be used for ioctls only, the EOPNOSUPP is more
appropriate return code.

This patch converts return code from ENOIOCTLCMD to EOPNOSUPP for
vfs_fileattr_get and vfs_fileattr_set. To save old behavior translate
EOPNOSUPP back for current users - overlayfs, encryptfs and fs/ioctl.c.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/ecryptfs/inode.c  |  8 +++++++-
 fs/file_attr.c       | 12 ++++++++++--
 fs/overlayfs/inode.c |  2 +-
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 493d7f194956..a55c1375127f 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -1126,7 +1126,13 @@ static int ecryptfs_removexattr(struct dentry *dentry, struct inode *inode,
 
 static int ecryptfs_fileattr_get(struct dentry *dentry, struct fileattr *fa)
 {
-	return vfs_fileattr_get(ecryptfs_dentry_to_lower(dentry), fa);
+	int rc;
+
+	rc = vfs_fileattr_get(ecryptfs_dentry_to_lower(dentry), fa);
+	if (rc == -EOPNOTSUPP)
+		rc = -ENOIOCTLCMD;
+
+	return rc;
 }
 
 static int ecryptfs_fileattr_set(struct mnt_idmap *idmap,
diff --git a/fs/file_attr.c b/fs/file_attr.c
index be62d97cc444..4e85fa00c092 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -79,7 +79,7 @@ int vfs_fileattr_get(struct dentry *dentry, struct fileattr *fa)
 	int error;
 
 	if (!inode->i_op->fileattr_get)
-		return -ENOIOCTLCMD;
+		return -EOPNOTSUPP;
 
 	error = security_inode_file_getattr(dentry, fa);
 	if (error)
@@ -229,7 +229,7 @@ int vfs_fileattr_set(struct mnt_idmap *idmap, struct dentry *dentry,
 	int err;
 
 	if (!inode->i_op->fileattr_set)
-		return -ENOIOCTLCMD;
+		return -EOPNOTSUPP;
 
 	if (!inode_owner_or_capable(idmap, inode))
 		return -EPERM;
@@ -271,6 +271,8 @@ int ioctl_getflags(struct file *file, unsigned int __user *argp)
 	int err;
 
 	err = vfs_fileattr_get(file->f_path.dentry, &fa);
+	if (err == -EOPNOTSUPP)
+		err = -ENOIOCTLCMD;
 	if (!err)
 		err = put_user(fa.flags, argp);
 	return err;
@@ -292,6 +294,8 @@ int ioctl_setflags(struct file *file, unsigned int __user *argp)
 			fileattr_fill_flags(&fa, flags);
 			err = vfs_fileattr_set(idmap, dentry, &fa);
 			mnt_drop_write_file(file);
+			if (err == -EOPNOTSUPP)
+				err = -ENOIOCTLCMD;
 		}
 	}
 	return err;
@@ -304,6 +308,8 @@ int ioctl_fsgetxattr(struct file *file, void __user *argp)
 	int err;
 
 	err = vfs_fileattr_get(file->f_path.dentry, &fa);
+	if (err == -EOPNOTSUPP)
+		err = -ENOIOCTLCMD;
 	if (!err)
 		err = copy_fsxattr_to_user(&fa, argp);
 
@@ -324,6 +330,8 @@ int ioctl_fssetxattr(struct file *file, void __user *argp)
 		if (!err) {
 			err = vfs_fileattr_set(idmap, dentry, &fa);
 			mnt_drop_write_file(file);
+			if (err == -EOPNOTSUPP)
+				err = -ENOIOCTLCMD;
 		}
 	}
 	return err;
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 6f0e15f86c21..096d44712bb1 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -721,7 +721,7 @@ int ovl_real_fileattr_get(const struct path *realpath, struct fileattr *fa)
 		return err;
 
 	err = vfs_fileattr_get(realpath->dentry, fa);
-	if (err == -ENOIOCTLCMD)
+	if (err == -EOPNOTSUPP)
 		err = -ENOTTY;
 	return err;
 }

-- 
2.47.2

