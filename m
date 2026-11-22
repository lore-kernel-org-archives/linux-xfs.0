Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795306156;
	b=t79GwgoL/5U35WPcHa84fCGDPAm8xHQQZBwt5n44dOb3dxMlcP6kpTg+b6wAkmqEzLtO
	 V/+uQ8Jgy0RKf0Ed/4C1+22aJhsql7Ef3K4tlAe3LZBXAihjo2XkTmakcnH8OKqYqSUjy
	 yP6XIkbWW7TAuAWv8TDFNLKDec6yqyaGptS2gECrGnNMEs96VY8XxFFNJdQYrR4WuedFo
	 FGAVjbXQKFIssHWL3bR4UzhY1Ltuze1ZYHt8zWdY0l/nskj/ksXdH0CQz6DblRQa+nOAX
	 +10KsDS9OKW126A0AWIZk9w3sIGALdFCU6b2JSX3lFxq78uleAHFYS05PyBoQpSqFAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795306156;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I3/a3+7dsQvjvECUWVZ/SwOHlfbc32z4n2+Zae+M7DI=;
	b=HDF+FLVHG/t6ZWLdfk64OUweWMWGhRabt2Ea2RxSzO0GDh52ZwOpmZ+Ejo9U+f7Prbpt
	 54jiGB+xDTz3H5MaPsPT7UzoBGG0esNHJFZIr3BHpMZ5JK50KPrTsHDaXXb0Gx5KvPVvj
	 Idktg4wW1rNHTezn+owAc2oDJB2pU4VRknhz+eXVRNYyURTag78iC20i48ZdYuu7NXbgI
	 cgyx5oeWJYFaE0HJerZD/qIOtpXkBTths7Xz0+wvoXXBAaV7GgeHLuPhCvhfrhzHNClOV
	 AltA4C1sMfkAuUEkU3GF1b1aorWaDPkYoK/qZ7aw38dLHMWF+sEk2Q5MEZGPuLyWC6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pxx4MEVM;
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB27606A334
	for <linux-xfs@vger.kernel.org>; Sun, 22 Nov 2026 00:09:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3BB27606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pxx4MEVM
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48e46e449e8so1396174f8f.3
        for <linux-xfs@vger.kernel.org>; Sat, 21 Nov 2026 16:09:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795306155; x=1795910955; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=I3/a3+7dsQvjvECUWVZ/SwOHlfbc32z4n2+Zae+M7DI=;
        b=pxx4MEVM3F9ewoA+cmrYZ5iJ7GG66cT5YEMw/9bSw+32AQdbNaeyaZM+3JoC/dwApz
         UTXTyt2hP1yxywMm4hNVJePOeGz0MGnOqeDT59BoZmGM0iHtv3qvQDqcKJ75ZctYftXA
         kPEmslanb0UMiXCiyaAj65FLQcg9cH55lzNF2rhCJTB0VVD4RlJR8bfx34szlVVEKDaC
         /SQf4GCr0GacL1gTvq3QehD9mb/pXaJT0DU0oIq9fiin+wEYVcS/rJt2xmbLSEz1RYGY
         zZWz6FecCb/clp9mCPrinCaau+nYvOhVOjDICs76X+KNwZWPsk1GaY5WrM54lZtPqKFa
         teuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795306155; x=1795910955;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=I3/a3+7dsQvjvECUWVZ/SwOHlfbc32z4n2+Zae+M7DI=;
        b=Tlmihj7fOtuwzGsWcbbDkLXcpu3pO8+A6Vt/sQBXW5vOnetCZnAXUaTOUzTk4ogNIg
         iecXQeeMninvV+M3uSD4Zvx9n1ke4a2JQnlWKiA/U2f6Wt4L+goPcPTuW2zIDbqs4NBu
         dxGAgYidz4ybU345fsJCZkjcxEvrRfz3XBPG1IAKYDnDErc8uhhATCBXVIjdQgKbnJGj
         abZBptPiQUhfbtw+1P8ZH2TEcDCYrONTDD7LAJbssavgs+XfI7IvJl42zhQmbxkmbfVe
         3gnGMd4Y3r77pjJaq0vLoV5LJky/6m6YpdW5T6Cd3HxkgjcT4mELifMqbtIQMoJ/fdFF
         lALg==
X-Forwarded-Encrypted: i=1; AL+hErGzTWucF2cj++iU/bk/EtGymoYOpTTudCfwytqv9p3RgjtnUjBEdxV64QmtiZd5bwwYmKHwYI3c4mQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z+rTheQqN1n4rNNNYWb9H6j7N6hg7n65pCkTjgi9kFwfvygtMO/
	j8kthhv8sRw0R6buyPly1yuVXJS3bHhKub4KZvwn2Oe9B0xvqs24SIRVbpDTbWmTdSo=
X-Gm-Gg: AZFdTZfTYBIhyxjox0h98YYGltjcpGgpbL6ruzvxulqgYR5rueHosh0acbFzgQnUOCg
	S+odg3YIYX9z2ezEMbkS6cSvUVukVdLBqFHEs8ee2njOZE64gSsaCYVT8EUTvnpT+Yw2kdhT6MT
	l806jxYyumXXuSoeFWBnloVqVCF9CMVunm8Dq4AyFpBvaVg/sNgftY/umVkke13oC+rgDZCRag7
	R94/S7KzmHi0LH0cVu/PwFiP59aQcoTPbWeQeUKy/cQbD6WNUGQtZJ3CtbyAhXBUbU4fl3lZwWp
	OYfdQ+8H2W323MIZkSnNaSLCpcLDuh2uUTYozNPWmaeUf2CJyU+vt9BYxS3dyI2oiMTIaHRURBe
	WmScPDdhC/noaRnlfgCFWZ2/aP7s5f3FAqsJJ3ze4s+EhAvjJjouxrNvL3vX4KIdMULZRbqcebG
	6kw6f65wQcqe7tM1KABgUEasYKyz2ASXZGLynPCx5IThbe9hqDyVPzGTCtJc46ZwItQlUWEE/ri
	vM0879SMeZrJLzUvskRdbB4mfgpsWgW/nslcvxeEcMpp/PYg7m/WvP98IXAtjiJShGgwSoTBYwQ
	YC+CjR2dnuT8ZKb5BUys5hzjDn8S0Jh9m4vpOayQh39Lsw==
X-Received: by 2002:a5d:5f4c:0:b0:48e:5d33:da5c with SMTP id ffacd0b85a97d-4abad5aca65mr14743143f8f.1.1795306154599;
        Sat, 21 Nov 2026 16:09:14 -0800 (PST)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab5ffcad11sm13461872f8f.0.2026.11.21.16.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 16:09:13 -0800 (PST)
From: koraynilay <koray.fra@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Lauri Gates <lauri.gates@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <dgc@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	ntfs@lists.linux.dev,
	linux-nfs@vger.kernel.org,
	linux-api@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH 1/3] vfs: use goto out on error in vfs_fileattr_set()
Date: Sun, 22 Nov 2026 01:08:54 +0100
Message-ID: <20261122000856.536902-2-koray.fra@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261122000856.536902-1-koray.fra@gmail.com>
References: <20261122000856.536902-1-koray.fra@gmail.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Switch from using if (!err) { ... } to the cleaner if (err) goto out;
in the main body of vfs_fileattr_set().

Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/file_attr.c | 45 +++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/fs/file_attr.c b/fs/file_attr.c
index 833e03810b24..40d6518f1d8e 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -285,30 +285,31 @@ int vfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
 
 	inode_lock(inode);
 	err = vfs_fileattr_get(dentry, &old_ma);
-	if (!err) {
-		/* initialize missing bits from old_ma */
-		if (fa->flags_valid) {
-			fa->fsx_xflags |= old_ma.fsx_xflags & ~FS_XFLAG_COMMON;
-			fa->fsx_extsize = old_ma.fsx_extsize;
-			fa->fsx_nextents = old_ma.fsx_nextents;
-			fa->fsx_projid = old_ma.fsx_projid;
-			fa->fsx_cowextsize = old_ma.fsx_cowextsize;
-		} else {
-			fa->flags |= old_ma.flags & ~FS_COMMON_FL;
-		}
-
-		err = fileattr_set_prepare(inode, &old_ma, fa);
-		if (err)
-			goto out;
-		err = security_inode_file_setattr(dentry, fa);
-		if (err)
-			goto out;
-		err = inode->i_op->fileattr_set(idmap, dentry, fa);
-		if (err)
-			goto out;
-		fsnotify_xattr(dentry);
+	if (err)
+		goto out;
+
+	/* initialize missing bits from old_ma */
+	if (fa->flags_valid) {
+		fa->fsx_xflags |= old_ma.fsx_xflags & ~FS_XFLAG_COMMON;
+		fa->fsx_extsize = old_ma.fsx_extsize;
+		fa->fsx_nextents = old_ma.fsx_nextents;
+		fa->fsx_projid = old_ma.fsx_projid;
+		fa->fsx_cowextsize = old_ma.fsx_cowextsize;
+	} else {
+		fa->flags |= old_ma.flags & ~FS_COMMON_FL;
 	}
 
+	err = fileattr_set_prepare(inode, &old_ma, fa);
+	if (err)
+		goto out;
+	err = security_inode_file_setattr(dentry, fa);
+	if (err)
+		goto out;
+	err = inode->i_op->fileattr_set(idmap, dentry, fa);
+	if (err)
+		goto out;
+	fsnotify_xattr(dentry);
+
 out:
 	inode_unlock(inode);
 	return err;
-- 
2.56.0

