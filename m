Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2ED31DD93
	for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 15:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758296969; cv=none; b=OEbk1AwDb+y1aPkjW9qzO3boUmGMkI9yETJ0PRpDTMZTbNHE6U952n3h6IqNacAknVJy976Lqo0ggmtGHuwpG2W33DBI7LHqsPGZ986y33y3aRtT+2tEpul7c8iZkt1dC8xxANP5gG804E7Wy0tugiPd4U9ODwkU0dPDkkoII1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758296969; c=relaxed/simple;
	bh=mwvxOTrWUws8OMACY4TrEt0dK3mhZILNulqgYpZhPQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IURK88x5Df6dlPIPZOgcfS2iNxoMsVnpgmq/KjKDTt8b8Ls3lMNhxmcEemQuOnbesrBm31gIMvTE1Jw3fxeHkK6xPDvwLSMU2Lrbc2OH4IIntFJQe3zoWeerOB+fye/kW5NcHNge5yrd9hTqkzXEmGxUJ51w9qKTjmrtlY28RxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gJBQjcPj; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gJBQjcPj"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3df15fdf0caso2034858f8f.0
        for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 08:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758296964; x=1758901764; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=61d6oBaZHfUlKu+4j2QssmtpKiSdVI4e5z02o4UC0u8=;
        b=gJBQjcPjlAVeXIpKpiWI3+YDxneMBgccZS+2jAHDPUzhYn10d5TKf6h1KrweDA6RhW
         UCyXNyqTdbV4ksXQ9Hruor1pS/Nrh0aKOWopUOnOLvo7Aq3XzjCX3LMYkZyP+MTEWuIZ
         72MMwgTJ/+c7MZ4Yk9cvfcRUK+fmxNUgxfLs5AMa7zLy2HBlNaVVA+q8s610ZmJ1gu2k
         uwr/jtN9VkhflldfMdHezQ2g2lSOU/JuwjzMQanXUhgcSpaL35sdvGfyrhiig6ZoNtZ4
         bJ6SB0Fjvjy8yyMOIrOpIQWSXTsKkWc0APM6pQvyG1/onArV5YwjQI2bwtEVYlMijfCp
         3MWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758296964; x=1758901764;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=61d6oBaZHfUlKu+4j2QssmtpKiSdVI4e5z02o4UC0u8=;
        b=jH029Jb8WadlZvE+PYGodot1qyRQj1h2Or1sUobgkf2bJlqrciGcVpaA3xaYQZnYpG
         2eaKwqm+X2neyP3R13zUeqSoCSqmwWNCWSzPA4pLiBn15d9v5r1HQFX1lVOsnn+OrfSa
         lfp/E06jIkVrobWzfIjReTSNpzVDL50ipWop1/fJQrLEyf3qWfi8lvMiHGOiAqYoSSYF
         fmgHpkmCmuRC0pZYNgYD+LmSJXe+UdgQs40YqweINvIIMKkLROsNaAD8SKuNwwmkUv/m
         tuF+lfbYI42IhTj9Ny//kGL4V/dDvP+y8UYlho+UnR5pRRYfPFoMcJZROQ0mSlzH5jle
         HE9g==
X-Forwarded-Encrypted: i=1; AJvYcCWHGahz9tBokMohMio2PwRcVg4mmZlO5Xzl0L3NfJufCRexVVEk/Ttm18cXA0cmr8PCyP6M+Q2cF70=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyc/3VzjYy1e92/wbKgQXYZMOWWGw2lVNILA9XVdJ9Kz4nn6idv
	CsqZ4i/HtzHYDYWyi/YtfQU6La6888QD6jz+j3mrbNMT1Qpy5t8EiRDa
X-Gm-Gg: ASbGncss4EDhFjiyx0jWX85fzS3QEwO+gBY8+pYwgNoqo6Kiaashljot3l3b4fYctm1
	a+zaO8DIvPrRwxODMOiRfgN3lrSohlfrIuKtBh3HeN8e9vzi83QDC9+fjriiEUFz1uhCrjbw68z
	Dr+yqkWb5j21CVLYJihXyzdbPPvVpHZlSYGBg9hnVMpfITeA42VkdRqVZ3RIStXvFSOfwTOJ3rL
	uYGU92vLdQewjs0eE+WQsba/H8sFqTRkCX0TSXielCcc32vmHnzQEsDhjQbwKV7o4kAuzNLpgSt
	8RxduWe3f0sz5iSAB3gc05gviz7sB6QVqd07i08ZcB+YuoNVPub44hK8DMSsO+0ytAT7WIlQ32K
	/CWkY3LTQBZ3T2g0Mu7I/+EZSOO4QmrJLS7oHHAECqMf8mZlypW1WxwO2jqSDvNY6kal54yHG
X-Google-Smtp-Source: AGHT+IElu5efTxqeZRn/Q7DGHQ7xzDh6VVQxmvzWa6J1DdvqizNuOI3aGe/Bc0G2MqWrzLvaODXXhw==
X-Received: by 2002:a05:6000:250c:b0:3e7:5f26:f1d6 with SMTP id ffacd0b85a97d-3ee7bad15f0mr3165724f8f.13.1758296964249;
        Fri, 19 Sep 2025 08:49:24 -0700 (PDT)
Received: from f.. (cst-prg-88-146.cust.vodafone.cz. [46.135.88.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee073f53c4sm8446746f8f.3.2025.09.19.08.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 08:49:23 -0700 (PDT)
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
Subject: [PATCH v5 4/4] fs: make plain ->i_state access fail to compile
Date: Fri, 19 Sep 2025 17:49:04 +0200
Message-ID: <20250919154905.2592318-5-mjguzik@gmail.com>
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

... to make sure all accesses are properly validated.

Merely renaming the var to __i_state still lets the compiler make the
following suggestion:
error: 'struct inode' has no member named 'i_state'; did you mean '__i_state'?

Unfortunately some people will add the __'s and call it a day.

In order to make it harder to mess up in this way, hide it behind a
struct. The resulting error message should be convincing in terms of
checking what to do:
error: invalid operands to binary & (have 'struct inode_state_flags' and 'int')

Of course people determined to do a plain access can still do it, but
nothing can be done for that case.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---
 include/linux/fs.h | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4ba2b274588a..3d678cd02fea 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -782,6 +782,13 @@ enum inode_state_flags_enum {
 #define I_DIRTY (I_DIRTY_INODE | I_DIRTY_PAGES)
 #define I_DIRTY_ALL (I_DIRTY | I_DIRTY_TIME)
 
+/*
+ * Use inode_state_read() & friends to access.
+ */
+struct inode_state_flags {
+	enum inode_state_flags_enum __state;
+};
+
 /*
  * Keep mostly read-only and often accessed (especially for
  * the RCU path lookup and 'stat' data) fields at the beginning
@@ -840,7 +847,7 @@ struct inode {
 #endif
 
 	/* Misc */
-	enum inode_state_flags_enum i_state;
+	struct inode_state_flags i_state;
 	/* 32-bit hole */
 	struct rw_semaphore	i_rwsem;
 
@@ -906,26 +913,26 @@ struct inode {
  */
 static inline enum inode_state_flags_enum inode_state_read(struct inode *inode)
 {
-	return READ_ONCE(inode->i_state);
+	return READ_ONCE(inode->i_state.__state);
 }
 
 static inline void inode_state_add(struct inode *inode,
 				   enum inode_state_flags_enum addflags)
 {
-	WRITE_ONCE(inode->i_state, inode->i_state | addflags);
+	WRITE_ONCE(inode->i_state.__state, inode->i_state.__state | addflags);
 }
 
 static inline void inode_state_del(struct inode *inode,
 				   enum inode_state_flags_enum delflags)
 {
-	WRITE_ONCE(inode->i_state, inode->i_state & ~delflags);
+	WRITE_ONCE(inode->i_state.__state, inode->i_state.__state & ~delflags);
 
 }
 
 static inline void inode_state_set(struct inode *inode,
 				   enum inode_state_flags_enum setflags)
 {
-	WRITE_ONCE(inode->i_state, setflags);
+	WRITE_ONCE(inode->i_state.__state, setflags);
 }
 
 static inline void inode_set_cached_link(struct inode *inode, char *link, int linklen)
-- 
2.43.0

