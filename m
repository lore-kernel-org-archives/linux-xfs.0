Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1AA01FDA6D
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 14:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744814693; cv=none; b=j0VgC+k3VfKu56GffqMYKRJighb4WQAoXVwb0NWxP5QvCuGCDbkX+Cq9TUTDdrZN0O6kTsHqoBdOLGhxv9CfdckcU1NbWNkvuF4h6iudnLNqIXQ2zg2SB3nbZIYJY2ztnr0ngXavg3Wzg1+5IwabQkeZVko1LGRWzDjrAxIWBp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744814693; c=relaxed/simple;
	bh=vkUD96kEtzzO77SAioqfguBK2Z+GzKT6iDhbhztfccM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sw+adzt5NbKx9EeUrRARPWnzAO/C0UzE+mUsYZf7i/01eAWHjvtl/tyOZuZEvvxeE57OauNue/xYKoBZ6ClBbkvETsi0+1xvLU3hxIBj4KdRs30+Dt+ADnXlmA5EJE+9YkMZ6adKbmIPDg1hDlaO5R7qiZYIR56eYl8bkg3xfXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hyRNVWld; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hyRNVWld"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-acb39c45b4eso141825166b.1
        for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 07:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744814690; x=1745419490; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ntvqmNW/StnnzfNSA2Vg93tEXLvEy+jJS06cIZNNTN4=;
        b=hyRNVWld3LMjE8PfZweURdDun+d968Ip8lWjI6XyvLhKC7no1U2I4sdVfvOAgplV6X
         wgea9mzSskvISZNxFGFHIlkygsOvDHI+1cuVCvEQDrB1v1UyHtFSDoW+32dSYvheLCEV
         fxyoYuwntLmwkqhXVvVh31/ds7EYUBYxVMcDxTKPMrmoM621kpQ+X/pIJn648XBa0knV
         FbxuuS2Vg6d00Ubgz9pi68doNSNz0xYFejOed3j/9AXo1xHpq7DJPs94k1MRokOfu/ez
         tgd3FaPdn+bknWCIpHzinzHDP8AEDO08+KZthGYw+LZFa+U8WRnuPbjSnrBlUF7Wne4L
         FeIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744814690; x=1745419490;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ntvqmNW/StnnzfNSA2Vg93tEXLvEy+jJS06cIZNNTN4=;
        b=ODVmWZdfI2c6zkTtXsPfKZiGC5XVmTMR/eOzMkkYBT8g4nqLxOtGAlmoobHHL26zlO
         wYqfQvcv/u2T66ahLnHhrU56Aif5wO7Jtq6c7bcfh2jUhq+ZzTS/V3hCQKBr9VwMQMsg
         MxQLEdbjeNIpQWHfkb1jPfXTD0IANyBsiC5/ECHqPOFgW3CpYDL1kwc8myT3sO7kACjl
         tEUDSZHT4+0OCHT6cOaqvlVXcck3sz3cLVmuyPr3AQXRvtnfoAlv63wQ8le9BSZ3n63F
         emjOLevwOcfX9lIwIQKlTxleFu396v9EErvZ3IjlExFEvcWrl5Yc/94pJrxd8crfwWNn
         ICQQ==
X-Gm-Message-State: AOJu0Yw7BqpLnn7/atNotdgE+jQmnZ20lKpQQYxKGYoV9YzbGUUx3vkg
	IV1vmqCoGqyqIr/X+ZrMPkxysFfhZ5aqttllPNGSmZlkvTUzVyyI7a2H2Q==
X-Gm-Gg: ASbGncsxU5FzSesvEW9R9XDuS+m3ydPLYyPpEzPro2LpGL1pbkzTh/HAyXIdgDOT6+4
	wMJNeZlk21seGTkoCcGBp/78NfvThDNFOueKZnLqmXBNQQ3/VdOgFCZCwH9WmfC/72p7B2zzbdt
	+6o77dZ2xQyQTnDaQrmWvr/8bIXW2R0BP1NVnEOlRCQTZUn9jdYSU3iduflId3dxbXr6fgSBZpH
	MAI/Favt9vYdv2pP/l5PoooZnFnMVWWZw6gIcWZmNp9Zbk/9vjmGibFPxXOEo57Eb/rTeyoyftD
	yYq2dAul8EnrGMdklF7kYSTiGnyg3z1Bv0bvxCTzUrF/jBMhpBw=
X-Google-Smtp-Source: AGHT+IFKYu1i/RKN9y8dmEp+6UzzGXnJMYeXQGNN127NVnWmi3Jn0Re1tmfAl+hW4TvrPfXhdz7y4g==
X-Received: by 2002:a17:907:a08a:b0:ac1:e07b:63ca with SMTP id a640c23a62f3a-acb429e6ef0mr167170766b.22.1744814689836;
        Wed, 16 Apr 2025 07:44:49 -0700 (PDT)
Received: from localhost.localdomain ([2001:b07:646e:16a2:521a:8bc0:e205:6c52])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb3ce59962sm141167966b.78.2025.04.16.07.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Apr 2025 07:44:49 -0700 (PDT)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev
Subject: [PATCH RFC 2/2] proto: read origin also for directories, chardevs and symlinks. copy timestamps from origin.
Date: Wed, 16 Apr 2025 16:43:33 +0200
Message-ID: <20250416144400.940532-3-luca.dimaio1@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250416144400.940532-1-luca.dimaio1@gmail.com>
References: <20250416144400.940532-1-luca.dimaio1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Right now, when populating a filesystem with the prototype file,
generated inodes will have timestamps set at the creation time.

This change enables more accurate filesystem initialization by preserving
original file timestamps during inode creation rather than defaulting to
the current time.

This patch leverages the xfs_protofile changes in order to carry the
reference to the original files for files other than regular ones.

Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
---
 mkfs/proto.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/mkfs/proto.c b/mkfs/proto.c
index 6dd3a20..ed76155 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -352,6 +352,15 @@ writefile(

 	libxfs_trans_ijoin(tp, ip, 0);
 	ip->i_disk_size = statbuf.st_size;
+
+	/* Copy timestamps from source file to destination inode */
+	VFS_I(ip)->__i_atime.tv_sec = statbuf.st_atime;
+	VFS_I(ip)->__i_mtime.tv_sec = statbuf.st_mtime;
+	VFS_I(ip)->__i_ctime.tv_sec = statbuf.st_ctime;
+	VFS_I(ip)->__i_atime.tv_nsec = statbuf.st_atim.tv_nsec;
+	VFS_I(ip)->__i_mtime.tv_nsec = statbuf.st_mtim.tv_nsec;
+	VFS_I(ip)->__i_ctime.tv_nsec = statbuf.st_ctim.tv_nsec;
+
 	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	error = -libxfs_trans_commit(tp);
 	if (error)
@@ -689,6 +698,7 @@ parseproto(
 	char		*fname = NULL;
 	struct xfs_name	xname;
 	struct xfs_parent_args *ppargs = NULL;
+	struct stat		statbuf;

 	memset(&creds, 0, sizeof(creds));
 	mstr = getstr(pp);
@@ -823,10 +833,23 @@ parseproto(
 		ppargs = newpptr(mp);
 		majdev = getnum(getstr(pp), 0, 0, false);
 		mindev = getnum(getstr(pp), 0, 0, false);
+		fd = newregfile(pp, &fname);
 		error = creatproto(&tp, pip, mode | S_IFCHR,
 				IRIX_MKDEV(majdev, mindev), &creds, fsxp, &ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
+
+		/* Copy timestamps from source file to destination inode */
+		error = fstat(fd, &statbuf);
+		if (error < 0)
+			fail(_("unable to stat file to copyin"), errno);
+		VFS_I(ip)->__i_atime.tv_sec = statbuf.st_atime;
+		VFS_I(ip)->__i_mtime.tv_sec = statbuf.st_mtime;
+		VFS_I(ip)->__i_ctime.tv_sec = statbuf.st_ctime;
+		VFS_I(ip)->__i_atime.tv_nsec = statbuf.st_atim.tv_nsec;
+		VFS_I(ip)->__i_mtime.tv_nsec = statbuf.st_mtim.tv_nsec;
+		VFS_I(ip)->__i_ctime.tv_nsec = statbuf.st_ctim.tv_nsec;
+
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_CHRDEV;
 		newdirent(mp, tp, pip, &xname, ip, ppargs);
@@ -846,6 +869,7 @@ parseproto(
 		break;
 	case IF_SYMLINK:
 		buf = getstr(pp);
+		char* orig = getstr(pp);
 		len = (int)strlen(buf);
 		tp = getres(mp, XFS_B_TO_FSB(mp, len));
 		ppargs = newpptr(mp);
@@ -854,11 +878,24 @@ parseproto(
 		if (error)
 			fail(_("Inode allocation failed"), error);
 		writesymlink(tp, ip, buf, len);
+
+		/* Copy timestamps from source file to destination inode */
+		error = lstat(orig, &statbuf);
+		if (error < 0)
+			fail(_("unable to stat file to copyin"), errno);
+		VFS_I(ip)->__i_atime.tv_sec = statbuf.st_atime;
+		VFS_I(ip)->__i_mtime.tv_sec = statbuf.st_mtime;
+		VFS_I(ip)->__i_ctime.tv_sec = statbuf.st_ctime;
+		VFS_I(ip)->__i_atime.tv_nsec = statbuf.st_atim.tv_nsec;
+		VFS_I(ip)->__i_mtime.tv_nsec = statbuf.st_mtim.tv_nsec;
+		VFS_I(ip)->__i_ctime.tv_nsec = statbuf.st_ctim.tv_nsec;
+
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_SYMLINK;
 		newdirent(mp, tp, pip, &xname, ip, ppargs);
 		break;
 	case IF_DIRECTORY:
+		fd = newregfile(pp, &fname);
 		tp = getres(mp, 0);
 		error = creatproto(&tp, pip, mode | S_IFDIR, 0, &creds, fsxp,
 				&ip);
@@ -878,6 +915,18 @@ parseproto(
 			libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
 		}
 		newdirectory(mp, tp, ip, pip);
+
+		/* Copy timestamps from source file to destination inode */
+		error = stat(fname, &statbuf);
+		if (error < 0)
+			fail(_("unable to stat file to copyin"), errno);
+		VFS_I(ip)->__i_atime.tv_sec = statbuf.st_atime;
+		VFS_I(ip)->__i_mtime.tv_sec = statbuf.st_mtime;
+		VFS_I(ip)->__i_ctime.tv_sec = statbuf.st_ctime;
+		VFS_I(ip)->__i_atime.tv_nsec = statbuf.st_atim.tv_nsec;
+		VFS_I(ip)->__i_mtime.tv_nsec = statbuf.st_mtim.tv_nsec;
+		VFS_I(ip)->__i_ctime.tv_nsec = statbuf.st_ctim.tv_nsec;
+
 		libxfs_trans_log_inode(tp, ip, flags);
 		error = -libxfs_trans_commit(tp);
 		if (error)
--
2.49.0
