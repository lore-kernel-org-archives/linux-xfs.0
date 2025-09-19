Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EAD431E8A5
	for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 15:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758296959; cv=none; b=rzqUZSQGTUx0G8rjFzjZo0U88IhCsOKtaB/wttPe1CcmCwNOiNHymHxv2njMSA2xajztPyKfhw9M+1zChwDPtwYzLUdN9cRVzOkLWnn0ysoBrPWRjtA9nDH+sTxocwQHIZJuYG1y1ZSR+gggq11Kwc9XUU3iWUI7Oqrr8wm5zHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758296959; c=relaxed/simple;
	bh=4iwo/4hETyrGGvwl7DvWSV1pIW8nOTgSDeRa6KhBnMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FqTXMV/1sEeRWbwirV4tGIU3uTTQHMzKX1sDN2zX+ZC/PB0K2aGbkDDlOFnb49nci1GhaNCRwM+TN89hFKq0kKBAA2mQKVO2yeW+mrhE+0/qfd4WF0K2nvQYEKNyg3cWYH1l5Ww3fpCDc5J3i6SzjB6y48QK6V+DJoehhaG7O7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DfEdrCTF; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DfEdrCTF"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45f2c5ef00fso18230915e9.1
        for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 08:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758296955; x=1758901755; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K6Nz4rZ6SPAY+5NRu1bbLzqkYF61IrDASgyLTr6XAmg=;
        b=DfEdrCTFo6rdzFYhld/JgF+qNufolUKLhbGDNtTgYPHDlacnV21osF/hPH9BqVco5A
         u/5u4Hbmx0xc4EcCChq8CAsPF8ecogqsmc6iaUBgL4tAtBjeqwoEGgmxGdou+gxqgL05
         nIAHEFYmokCTym8WnaPjHyGpKKlpxHw+2xKrezfoYo+yO7H9iXRToVdJIrnEwm3D1XR3
         LAJnYPnere9sfucV1mHf5UOYtTa7rJTLka3HATCQNY+2O7xu6QnPMRlcRFExIMulsXu+
         uejrcrNBwLoL3TBm5OaeM1hCaOlnvddNEb7j0U9ugsmxZNQhkFpZaevx2pNJwPBg64nW
         pz1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758296955; x=1758901755;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K6Nz4rZ6SPAY+5NRu1bbLzqkYF61IrDASgyLTr6XAmg=;
        b=QIQlJzGxbW4PZMZg0OlBvanTmpu+uB9yD04SoJSKFZ9oQfVWHA1Ih/Sq75oor7kaqr
         TU0eU/izz3H8LKwHE4X5ZXtqoN/EFsNYdFU6xft2T8Fsq4x1/fhrTuPsoDKjqDGxVa89
         frdf2BqlbbOEj/HiXyooFpohkA5rxD1xnG8hLHKQYMLCjt5yWlDbCCpsQHSxwO7h79Iv
         EQp8877ksPUzuRdAGT4tTA1Dk2zDz7Bh/n7bf0K9pmAeEGJtCyQwo0ZGkd3Ih23+YN60
         SPqAdO8e9V96kZUTvZ/ovchZFm0FsYajIWVkVbBMWwky5ZDvtySy2m2d0ZpZP61yckkg
         7WKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXjmbGBlHxun6MtV9Iz4COj52KXuSF8gyc9IFKOJ6Wsav7dVu/HKorfjORb9BLoJIDhYfg685Ol2b4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxK5IiKNjNXijpRFjuFxLZTrjS3BZfTGVAZW0tMITmmiEps8lwg
	cSm0F6QsssEwYG0WZwcZrH8Jh2Klr2Zujs8V6VM3vr9xkBIimwWAd6Pc
X-Gm-Gg: ASbGncs6Z+gVkuqo88rEgE02O0Bxb8Z/1s1s+/buJyxMFNWcvKezRXra4ZENY9n16cJ
	dgtdmh+h4b8KAXa2eJkNYQ6xd2HHxdqkwwBjkWjIERO/ZoJwhFhmarst2XqMP7FpRhOBpNpcjCq
	NX0kkLHtTayawxXgG7GCoajxN0IrazAEocnoxMNbJFp7I3yzI0l/4J6IV5cRy5AahvHVke0wFHZ
	al2mwmU7mSgymMdxFXB4dJxlBX+855/4/vtgboKaAdZBUAL41s9fDXm/u6msq+jP9NB5Apf3Bk1
	1Zb18L9ve8ScL6NoHArkTQsTrXbUfBC7zN5KwzS6BzLo7jZQesSx3/KenHk5Bv5htEYs4OqcxyM
	jLzoIVY59w+OO/5wQx+gPf2tNPLyHa35UFIeQPbPR2pYSNi8tgHgDJA7v+qgvL4UjjUbt1+G5
X-Google-Smtp-Source: AGHT+IFi3Qiw2JmDbZ5JtfHacDK+pNgJNUdMyHN8bx8JLqrebQREXbPs43I+kD+9QA6IwdllVAvzbw==
X-Received: by 2002:a05:600c:1d12:b0:45d:cff6:733f with SMTP id 5b1f17b1804b1-467ebacab73mr28722625e9.11.1758296954944;
        Fri, 19 Sep 2025 08:49:14 -0700 (PDT)
Received: from f.. (cst-prg-88-146.cust.vodafone.cz. [46.135.88.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee073f53c4sm8446746f8f.3.2025.09.19.08.49.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 08:49:14 -0700 (PDT)
From: Mateusz Guzik <mjguzik@gmail.com>
To: brauner@kernel.org
Cc: viro@zeniv.linux.org.uk,
	jack@suse.cz,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	josef@toxicpanda.com,
	kernel-team@fb.com,
	amir73il@gmail.com,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH v5 1/4] fs: provide accessors for ->i_state
Date: Fri, 19 Sep 2025 17:49:01 +0200
Message-ID: <20250919154905.2592318-2-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250919154905.2592318-1-mjguzik@gmail.com>
References: <20250919154905.2592318-1-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Open-coded accesses prevent asserting they are done correctly. One
obvious aspect is locking, but significantly more can checked. For
example it can be detected when the code is clearing flags which are
already missing, or is setting flags when it is illegal (e.g., I_FREEING
when ->i_count > 0).

Given the late stage of the release cycle this patchset only aims to
hide access, it does not provide any of the checks.

Consumers can be trivially converted. Suppose flags I_A and I_B are to
be handled, then:

state = inode->i_state  	=> state = inode_state_read(inode)
inode->i_state |= (I_A | I_B) 	=> inode_state_add(inode, I_A | I_B)
inode->i_state &= ~(I_A | I_B) 	=> inode_state_del(inode, I_A | I_B)
inode->i_state = I_A | I_B	=> inode_state_set(inode, I_A | I_B)

Note open-coded access compiles just fine until the last patch in the
series.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---
 include/linux/fs.h | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index c4fd010cf5bf..a4e93fcd4b44 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -756,7 +756,7 @@ enum inode_state_bits {
 	/* reserved wait address bit 3 */
 };
 
-enum inode_state_flags_t {
+enum inode_state_flags_enum {
 	I_NEW			= (1U << __I_NEW),
 	I_SYNC			= (1U << __I_SYNC),
 	I_LRU_ISOLATING         = (1U << __I_LRU_ISOLATING),
@@ -840,7 +840,7 @@ struct inode {
 #endif
 
 	/* Misc */
-	enum inode_state_flags_t	i_state;
+	enum inode_state_flags_enum i_state;
 	/* 32-bit hole */
 	struct rw_semaphore	i_rwsem;
 
@@ -899,6 +899,35 @@ struct inode {
 	void			*i_private; /* fs or device private pointer */
 } __randomize_layout;
 
+/*
+ * i_state handling
+ *
+ * We hide all of it behind helpers so that we can validate consumers.
+ */
+static inline enum inode_state_flags_enum inode_state_read(struct inode *inode)
+{
+	return READ_ONCE(inode->i_state);
+}
+
+static inline void inode_state_add(struct inode *inode,
+				   enum inode_state_flags_enum addflags)
+{
+	WRITE_ONCE(inode->i_state, inode->i_state | addflags);
+}
+
+static inline void inode_state_del(struct inode *inode,
+				   enum inode_state_flags_enum delflags)
+{
+	WRITE_ONCE(inode->i_state, inode->i_state & ~delflags);
+
+}
+
+static inline void inode_state_set(struct inode *inode,
+				   enum inode_state_flags_enum setflags)
+{
+	WRITE_ONCE(inode->i_state, setflags);
+}
+
 static inline void inode_set_cached_link(struct inode *inode, char *link, int linklen)
 {
 	VFS_WARN_ON_INODE(strlen(link) != linklen, inode);
-- 
2.43.0

