Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795710708;
	b=aNTHjQ1+mRi+KPCrkXPMEVNrH/u1CaNFd5ellNTzR2ErlVaqga0Ishp6w/Z2pAi2fe2k
	 lSdZFKgTCfzPhCdYx3sBNLsnOP3QlmR09yC8dYyEo6TcVNzGN40is37rlSB3hDbNRTG+I
	 urkUMYgmy+JVfqLvatQEqrzC2/QYIjT5F914rL9wiMsvdsB9cC30XGPDHuFmS9LfhRflE
	 BeN+seqAvi3rSmFgS7nQAvrWUV6Yubt17zTE3QKTY2OmYR0+zpswZjl3U2H3IetHFDjIH
	 q02pjRE0ZcvKOC8xEN+QXZYveb/wtd/u2PRTW4SFzdNByQt5X5AuqB3gAt7SeL+lIbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795710708;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mfpEhfbyhPi8fEOS+N1QHzNJFz4cU/NZgKWTwuKYJ+M=;
	b=rBQSE9moGVaIg5FlBRikJCfXi7F8CBUat5/aC/ozXGKe9Ecnr61sOHLGazDAdphuL6fH
	 L2G471AxqaIyLJN+lVAGzz5GaEPQPnCicUNV57V3OZT/UyFTrfTmekCu9bo6RuJYn16vb
	 tUkix/cjbq/p6Ri0yYj9bkkoBasV03xKybc52isUeoWXB3vb7kJk8KsukTdtzVfvWbrcg
	 fcBHj218q7hz8fw8qJqqS0cTUkCvFMEvMhkQDVlengIur+ipUnVU+ZwUjLzr9fWG6djSf
	 tSSxN1GQ+PbuMgj7xTDDFWPlrqYKlD0Zs2OA65DthO0sLQpkYL8NJ3D6D+dhga+ooVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xc+MkwdP;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432F4606A333
	for <linux-xfs@vger.kernel.org>; Thu, 26 Nov 2026 16:31:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 432F4606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xc+MkwdP
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4bb6ba3b244so73940835e9.3
        for <linux-xfs@vger.kernel.org>; Thu, 26 Nov 2026 08:31:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795710707; x=1796315507; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mfpEhfbyhPi8fEOS+N1QHzNJFz4cU/NZgKWTwuKYJ+M=;
        b=xc+MkwdP2qSHhRJs8tqp0gJVAbhLaJGgxK7Lgcrjfgi+poNIcrpekreyQIw8Wa2ubw
         JTYEYjzBQHqXA+RCGlkMim5rWjlpg2Rc8MJ45f9iuFGrYnTeolSe9vBS2bLSeX5T5fZf
         SZX2nx4eSzWBYUFb1yi9O/TFdM/MA3MAnAw6/ApHrCpLQQihkBD0TTWOQKPnQ28uZTYE
         XpRkIhDzQqfntphSLOtItZuJswRxPc5PSDPlBmuNOaDHAcf8EMQ3hdeMUxJAM4CSuDyL
         mqwH8JHptswvYdfZEoqv6ChJC6m67PYPkI1mpROJ+wyATfnVNkfzJA1ri8ZRyz6/FKyk
         ZCyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795710707; x=1796315507;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mfpEhfbyhPi8fEOS+N1QHzNJFz4cU/NZgKWTwuKYJ+M=;
        b=CdPud2K7Velu5A+xYbELzJlIAUV39NciGSX+2ZBDZaEqFB1THAx577Tquq87smfzyY
         4g2Ni02fE3BRHXFNv1ZsIrpl65whi2RxexacUKcCznXU6MVbhdaVw3zv0yXt4wy1vEBb
         9ezqyYLD3Vpty03NJzq0omKqqkko8P4Leb6e1Jnih1niLNWwXf3nKXbM2vvaFgRigTYd
         fiNmXyx/gRh5sNansJjO3Esls8IQFZ2N9GBM0Z4UYh29fABJcmHYLvPXeVFx8rjdpwQD
         AoILBAB1LrxITCPZV6faTt1Gi64R567keZpDquYJKmHp3D1QcreUpzFFZvts7SYpOv6I
         xlxw==
X-Forwarded-Encrypted: i=1; AL+hErG1v16rjOZZMD4rAm7TJbWzzkTqjmhMDxYBc54Qv25NDUb4gnzYRExQFniPbLr1NdlJO/fmzniqGUA=@vger.kernel.org
X-Gm-Message-State: APuU4Z8Z3jsUl2KBScShxm0FW3/u9eOHlO8gEVfplAN32Mt5m5P3nwqz
	nSClEONo/i8U5vCEa0Inh5UVzNCs9o5r7Y/z8itD2HzJ0+vDjStwNaI/
X-Gm-Gg: AZFdTZeSw9TLkBT8JW3bqAhciEpNCBGTWyyDHqoeAyWhAHBFR05wdgIiRAWKTrbDbIi
	IkYDJCopx0ZY8mnqF19L8XIauWV6SesbMsbMccr/LCWcfWABF9cU5HPpI0lPFhT4VzLZ/DPJcq3
	X9vTP4Dar1vu8SgGljJVH+WidW2qf8H+1t9rxGM67XkKo8UjmzG/duSVYds1SLI+rYrSlHE8eCD
	4CNt6zN7WgAnP8OxlVN/mLRzuIWVOTy9PfoQcrsDBWqnNSxvR+kiALVWq+fmH/D7UstekAFnf66
	+CSxtaN2xcH0x7Y96hzX5iRD4e/ikg6YFKcfJniFZFpMpzIZhSHDFxN8fW6jnmAy8vTwOEJvgVY
	SzRudYH96Do5aou2VFWtiHHtXB14i/Y0FhdUndR6b3EEIjUcJe6BC6UBWurk7huiAQ/hXbjo7R3
	i3T5p/heuerQCxE/meoNP8/qTdmVHISY74KCIz7yWMDSU8DOQrSsztCVlNSxfQfiIB9MrYbqxRk
	hfJDpMcjuTV50Mh42UYWsKpJiUIYIZArKAQtfzuoQDigIHojXwTuIJA6GP2oYUYPSvch3KO+VO8
	Hx9mA7voiceO9p4vURFN+2uI
X-Received: by 2002:a05:600c:4e0c:b0:4bb:875b:f23f with SMTP id 5b1f17b1804b1-4bb88827f0bmr416764955e9.33.1795710706373;
        Thu, 26 Nov 2026 08:31:46 -0800 (PST)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853a9846sm721964995e9.11.2026.11.26.08.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 08:31:45 -0800 (PST)
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
Subject: [PATCH v2 1/4] vfs: use goto out on error in vfs_fileattr_set()
Date: Thu, 26 Nov 2026 17:31:11 +0100
Message-ID: <20261126163114.403846-2-koray.fra@gmail.com>
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

Switch from using if (!err) { ... } to the cleaner if (err) goto out;
in the main body of vfs_fileattr_set().

Signed-off-by: koraynilay <koray.fra@gmail.com>
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>
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

