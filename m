Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795710710;
	b=WbGUPDtUqBIb9iUmhTGWeWtf4LnqUnjz948CGOTeNutnIyJ48Q39WYaZhfzc7yfG7DId
	 /SLII/3qBm0f8s9snGRQYVHSaaTLaSJmd/7ZSLSwZENycKt7S1CBRddFDmkHOFbadpyTT
	 n4qXrjiz6SBZ0O6rLzAb43siSlbAFhW5KHcNdf8KBiGxOZhWJ0h1s2/gwAsjAMRJr7mMB
	 DsOMWJi09+iAxP5EpvbdQj4AyKEjkl1ZxTjLnUiOVNA4ArTHAnz1+SyD99eX8ItQnG4ch
	 WMuCqPHW3NpHJACQtoFiojja9aN+uYUbZy/6yclcOpMCZG0ZytUEyV7BvLFmR2DNQYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795710710;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6DGKGHZD1sWqO2WRSY4U0udOhpGKQXiV3WJqb4Fx1ZI=;
	b=CvPdug4PEXcWY++LpNX9CsV+4RFzZ5tu1O7iNcYjPCeYJfuYUvmKqtMS6DJrCFVg1wCJ
	 HGFMObyafGG/WHnRJ5VZROBGjAHcjHFfd0JvRuWnrFIS7UQNNYszEpftxNKWiwzLyaJGh
	 vaKCTbAIjVkPGCBIB3dtJ8duaUq+etmTVHQtvwi8Vsfo3SxKZQpSiVZck7dkQf+79vhp6
	 XJ/hNwKL2Ri4wynz7yAfDJrq4AwqsKOkQhuv4vEh+0+69cpBUtm57/ESZOwIZWWPYSUl5
	 AeYfTMN2V4SunBXNoyG60BNs9lGpNqLKYzXC+fDgT19Hj83sd63AxxZK2FfWqFRS87Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NgzesBph;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0850E606A6A4
	for <linux-xfs@vger.kernel.org>; Thu, 26 Nov 2026 16:31:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0850E606A6A4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NgzesBph
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4b79502c27aso72619975e9.1
        for <linux-xfs@vger.kernel.org>; Thu, 26 Nov 2026 08:31:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795710708; x=1796315508; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6DGKGHZD1sWqO2WRSY4U0udOhpGKQXiV3WJqb4Fx1ZI=;
        b=NgzesBpha5/UiuwtyApe4LBXa4J/ZEE9RKL51o52cHEQZvDJx1Io0LkMX9T4hggZMH
         yMa0nLXZDeXh3OTT5Dceu8BR+qdcmeSaC9RWK6GGdpgvq67OWwu0N8mw3xfC+ykgxBkA
         yEoRN9ICF95EXoJwq1ROoEh5ttxJozEqUgS4kFy2WgRT3O8gDHMMShxwnJZV/bfNq8gV
         94Ff+uDAmyBMb5RFFUJa2wayxciw/19DqrWBprAc5PQ2xTH4mJm64KnLuI4iptKk72YS
         FGHpM0M/l0unSVUyE9VXt42T1xN0phYdlNSwj0GuBcjfL5tAcfYo3HAercHmLDLsdKJ/
         INoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795710708; x=1796315508;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6DGKGHZD1sWqO2WRSY4U0udOhpGKQXiV3WJqb4Fx1ZI=;
        b=oFTHvZP4QrgkqC9k+MdZ01DFZzY4dOwEumkIG6IY/ayxR2Bw7VRffv3TiX2asKsuLW
         3jPGW4J965B4lE6mWLuJBYo1+31iYcJTf63LrFaNCf/zZoOqXyQkgxpz30OOLHbrwFHx
         l1u5n0HKX61Cwf2ejDY0kNo+fNe/PV56YMRRuooiq0X3ZE84w23wBg01aFAeC/A/tXNb
         /S9J9dK4yF0TtEfdrQmmWbqK0XFq8v4XYVs6GTqGcQtAcWL5fKW4SAarXIiLr2RA3RBH
         7G+cycVk8jTd9ByUuIklKhBk26x+SJTuQihJ8xfqC8K1PsEIP4DL0C1b0nhZ2KtBdW9l
         2lXQ==
X-Forwarded-Encrypted: i=1; AL+hErGGzER1ib9LqIZHybLWQQDrocQwarNpkOHDzNpViBv8rXHInmPRbxTL6PRFkI2mNdTnmBK3igzftM0=@vger.kernel.org
X-Gm-Message-State: APuU4Z8vSJ5C1L7QqcafMroifZKINTfjG0Mg2ZPeZGODRyXDw5ei5ZUl
	3KqsmduYI+K/9te4sEj4zG5xRvL82R46SDzW+TUDUl74g7vxYrl2ikYG
X-Gm-Gg: AZFdTZfL4izqe3S3liF0WmY1FfaUelUCeGPJcqZFEvb3Mi48la/urkow0KzouPSHhfU
	MRr20J8yNMLTZeU6DRPPPkONLsmp/ACg+sHVV6lO4oVZvpCnkr1j2Ypgf56fCjZBFB0R7twsWfT
	jLVL/gtwL8L1d9uzbn38YTf13ZufycD/5YnlAiZqS3V8uV8dw1ti7MLRm7cLu195nARdxiN6MOf
	jkQfhUhDw/ON/rxKbmNAQqaKRCjWiwM+jckNoQyVw8iGEWAXBhknJgTlXIkd2JP4VpEatNJkSCP
	5KKDNZ3pUsLwnoqmQ0vvGABmVRgv9MPxu9oSjJK1nu0LdtBz2MfJS+p59YwICe8ekdx7b67AUj6
	X6TREePufhDl7el6bFF+is3FV6W6N0kS6UunXCdzkAkcAYjIZ9qVQ/Uvl/DBD1j5nwiDs8gFmu7
	1eo4yu4dE748w1+MTJ6noWbggUtYn/7Hz9sp20P/QEXUvG+N6pXr7VCo/zkP6vg99HeztVnNZ2p
	ZyHCy3mtcX31P4VNjc2NAA0sN0ipX5tpLdAt2BVTbLjhLaytudX7TJng0Yd1jk5rwbrMjm5Rslg
	2U6hs1xNFT2O0ZoYYF0oXZnN
X-Received: by 2002:a05:600c:3b83:b0:4b7:6b96:e431 with SMTP id 5b1f17b1804b1-4bb88822242mr502582645e9.28.1795710708243;
        Thu, 26 Nov 2026 08:31:48 -0800 (PST)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853a9846sm721964995e9.11.2026.11.26.08.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 08:31:47 -0800 (PST)
From: koraynilay <koray.fra@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y . Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Aring <alex.aring@gmail.com>,
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
Subject: [PATCH v2 2/4] fscrypt: update fscrypt_prepare_setflags() to use xflags
Date: Thu, 26 Nov 2026 17:31:12 +0100
Message-ID: <20261126163114.403846-3-koray.fra@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261126163114.403846-1-koray.fra@gmail.com>
References: <20261126163114.403846-1-koray.fra@gmail.com>
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

Update fscrypt_prepare_setflags() to use FS_XFLAG_* xflags instead of
legacy FS_*_FL flags.

Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/crypto/hooks.c       | 10 +++++-----
 fs/file_attr.c          |  2 +-
 include/linux/fscrypt.h |  6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index 149498bdab94..52d6a33fc9e9 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -182,10 +182,10 @@ int __fscrypt_prepare_setattr(struct dentry *dentry, struct iattr *attr)
 EXPORT_SYMBOL_GPL(__fscrypt_prepare_setattr);
 
 /**
- * fscrypt_prepare_setflags() - prepare to change flags with FS_IOC_SETFLAGS
+ * fscrypt_prepare_setflags() - prepare to change xflags
  * @inode: the inode on which flags are being changed
- * @oldflags: the old flags
- * @flags: the new flags
+ * @oldxflags: the old xflags
+ * @xflags: the new xflags
  *
  * The caller should be holding i_rwsem for write.
  *
@@ -193,7 +193,7 @@ EXPORT_SYMBOL_GPL(__fscrypt_prepare_setattr);
  *	   another error occurs.
  */
 int fscrypt_prepare_setflags(struct inode *inode,
-			     unsigned int oldflags, unsigned int flags)
+			     unsigned int oldxflags, unsigned int xflags)
 {
 	struct fscrypt_inode_info *ci;
 	struct fscrypt_master_key *mk;
@@ -204,7 +204,7 @@ int fscrypt_prepare_setflags(struct inode *inode,
 	 * derive the secret key needed for the dirhash.  This is only possible
 	 * if the directory uses a v2 encryption policy.
 	 */
-	if (IS_ENCRYPTED(inode) && (flags & ~oldflags & FS_CASEFOLD_FL)) {
+	if (IS_ENCRYPTED(inode) && (xflags & ~oldxflags & FS_XFLAG_CASEFOLD)) {
 		err = fscrypt_require_key(inode);
 		if (err)
 			return err;
diff --git a/fs/file_attr.c b/fs/file_attr.c
index 40d6518f1d8e..1687891c526c 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -195,7 +195,7 @@ static int fileattr_set_prepare(struct inode *inode,
 	    !capable(CAP_LINUX_IMMUTABLE))
 		return -EPERM;
 
-	err = fscrypt_prepare_setflags(inode, old_ma->flags, fa->flags);
+	err = fscrypt_prepare_setflags(inode, old_ma->fsx_xflags, fa->fsx_xflags);
 	if (err)
 		return err;
 
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 28f2108e29f3..68d0983385d0 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -461,7 +461,7 @@ int fscrypt_prepare_lookup_partial(struct inode *dir, struct dentry *dentry);
 int __fscrypt_prepare_readdir(struct inode *dir);
 int __fscrypt_prepare_setattr(struct dentry *dentry, struct iattr *attr);
 int fscrypt_prepare_setflags(struct inode *inode,
-			     unsigned int oldflags, unsigned int flags);
+			     unsigned int oldxflags, unsigned int xflags);
 int fscrypt_prepare_symlink(struct inode *dir, const char *target,
 			    unsigned int len, unsigned int max_len,
 			    struct fscrypt_str *disk_link);
@@ -784,8 +784,8 @@ static inline int __fscrypt_prepare_setattr(struct dentry *dentry,
 }
 
 static inline int fscrypt_prepare_setflags(struct inode *inode,
-					   unsigned int oldflags,
-					   unsigned int flags)
+					   unsigned int oldxflags,
+					   unsigned int xflags)
 {
 	return 0;
 }
-- 
2.56.0

