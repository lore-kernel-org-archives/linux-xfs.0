Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33ECF3629AC
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 14:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758031212; cv=none; b=hpyq4dRF3lFtrllS+B3mR9E++MkFkV/6/xZHxv6E+3TKAua7RUFgH5P5aRp00XrMWrHcUE8sfOJmSoDxE1ZMYAQbsqFA0a+Ss0HkK7kIPAGyqD1RIC5L5wNkXAbVi7ftOah0L/zG1w2Rk5P5bYMh8AIBvncOYe288HYgwdcz2K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758031212; c=relaxed/simple;
	bh=QCGFM/cnMeWMX3htX5p6eryZx4ChTW6raUZie6Xkq4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sd+3eLIcAZBB5UHAGPjUKxNo2FTAkBaE6NTsoJ8QrPPo8sLrrxq5iSi71QjFATFT5Bq7WqlnlAzue8MTMfocjoOrDr2wOcW5Cl7xMiazwpx0M1sm/trX0Gl7wec3f/oz2Ef3qK9tIuvtUKHRIXoubuUhG2HE9N6oeBEYRE9t5o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L3nhuz8Z; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L3nhuz8Z"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-45dcfecdc0fso55140145e9.1
        for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 07:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758031208; x=1758636008; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F3p/HZf12MlzeyzMfr2O5f/PDaT3y6+eiNIS1WtKNH8=;
        b=L3nhuz8Z9oR2kJSqns3xH/4NNgB63DxIRTaNe5oIxa1VLEVdkRdB/o3wev4JT9FNev
         eYpTXmtMWdeLljSdxJ79OLMkhJkiqrc6h7LHAZW+X5s3QVxcasSgLD7hAUeJrGRLubrB
         rulGsgIDFkzQK+2p9g4U8tVgIq95EgJGWBcjRk5IWOXboTPeJq5Wl8CIcLDDTCttURg+
         Z/kpRYpJML9Zm7dCljBFAix9m7eNOll6G7VSP+j67BxEW1aC/WZ7ZjSMe8UMq+FpcsCJ
         Gpseb7IWms7Lemr8sJ3X2y84OXx4aqfDuLL8yMdr7v3hdlC3zgsgY4glFyVdW2zXXK2M
         b5dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758031208; x=1758636008;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F3p/HZf12MlzeyzMfr2O5f/PDaT3y6+eiNIS1WtKNH8=;
        b=F1lbJBxDNOHbEyfivuniWxd0andU0yZZBvAPs8/89vN3QvKsljja+xbRmEBoflZmTF
         a5nW5gkuBGocWyWaSE4264sgTVFXLcVlrnL/IvDvDiQ0ECa0yD3/mJuKqFMBl/au8Ayv
         Ly0ujZY4FPecKG37RAyIQUnHv6CPciEKzx+UtRjEOFcBlH+iXidhTcCywTvKTrF2QbRk
         d6PQJXa2j9BfHkRo3I/H4GFOsEHn/K3qoQiNloP84LI6uL235Isr93Q+FwHvFI0fuq+1
         Id2Frrm+Xcpb6KhR+wLkDj2wd4vtf3Og7CEAqpY7RJjkpadTAJKy272zS0AH+dO8MsG4
         H/vw==
X-Forwarded-Encrypted: i=1; AJvYcCXD/+a+idZGwbiqIb29cdsd4Qk/8dyFXyw9tZx0acJ8E/N5XT9bCgETrwhBrvuRQJNMdIxhGVJqnsI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMzGjzLsDzOSeyweNUD7GuedZEL1UXn0Ia+lCV8yLSCNLveYNM
	bi1TVz2kttH+4/3RfLzIa1QsiVdk9xzHCzw1Wg9jlwPVeXsQPJoAlViB
X-Gm-Gg: ASbGncuCzakp6MX3GYgpyXqV3glPdKk5IJxnHORZcJJ9yorwYE7SIU9Co7bZ+8xj40U
	WIntKBYobykHZzqQ1qMRNRV/4NIaKfaRV3vd4/W2Guy4JgLYXiiRPhXhYQMgA7sLog9E2DDV9XC
	cEooWlBxBUe6MFEVq86y69tvgUiAdBSb3kcStRY0TU7dnlHQX2PZ0xrkMtSirlskZmh97vSQbr6
	PJtwUVeuSp1SmJUsz9zN7jUmgjzX5GchEPRITDgqdND9gOGa6p0VeSo9s6M6UoQSruOD2JrKJow
	hvHDBrhENcQk4jnK6f3g/bW/5jkBUmBNbuJnrTH5QpV82dujI884qejg7xCq7MWsrFy6UAWZpUF
	8Bq/RfUfM3KqMHSKnnSoyxTTPstR8igOk0BQSTrkcCK/Z8X8QovFXzCkRafMOI5cKq74Wesex
X-Google-Smtp-Source: AGHT+IG3ojTnTVy1hdNr03FmdV6E3sTeXWaDybJz1f1E1nvEGmI8CA+2Pel84ZsC9/O7zHxZywZmtw==
X-Received: by 2002:a05:600c:5246:b0:459:e025:8c40 with SMTP id 5b1f17b1804b1-45f211c8aa9mr181401305e9.10.1758031208380;
        Tue, 16 Sep 2025 07:00:08 -0700 (PDT)
Received: from f.. (cst-prg-88-146.cust.vodafone.cz. [46.135.88.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7cde81491sm16557991f8f.42.2025.09.16.07.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 07:00:07 -0700 (PDT)
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
Subject: [PATCH v4 12/12] fs: make plain ->i_state access fail to compile
Date: Tue, 16 Sep 2025 15:59:00 +0200
Message-ID: <20250916135900.2170346-13-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250916135900.2170346-1-mjguzik@gmail.com>
References: <20250916135900.2170346-1-mjguzik@gmail.com>
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
 include/linux/fs.h | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 11eef4ef5ace..80c53af7bc5a 100644
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
 
@@ -906,19 +913,19 @@ struct inode {
  */
 static inline enum inode_state_flags_enum inode_state_read_once(struct inode *inode)
 {
-	return READ_ONCE(inode->i_state);
+	return READ_ONCE(inode->i_state.__state);
 }
 
 static inline enum inode_state_flags_enum inode_state_read(struct inode *inode)
 {
 	lockdep_assert_held(&inode->i_lock);
-	return inode->i_state;
+	return inode->i_state.__state;
 }
 
 static inline void inode_state_add_raw(struct inode *inode,
 				       enum inode_state_flags_enum addflags)
 {
-	WRITE_ONCE(inode->i_state, inode->i_state | addflags);
+	WRITE_ONCE(inode->i_state.__state, inode->i_state.__state | addflags);
 }
 
 static inline void inode_state_add(struct inode *inode,
@@ -931,7 +938,7 @@ static inline void inode_state_add(struct inode *inode,
 static inline void inode_state_del_raw(struct inode *inode,
 				       enum inode_state_flags_enum delflags)
 {
-	WRITE_ONCE(inode->i_state, inode->i_state & ~delflags);
+	WRITE_ONCE(inode->i_state.__state, inode->i_state.__state & ~delflags);
 }
 
 static inline void inode_state_del(struct inode *inode,
@@ -944,7 +951,7 @@ static inline void inode_state_del(struct inode *inode,
 static inline void inode_state_set_raw(struct inode *inode,
 				       enum inode_state_flags_enum setflags)
 {
-	WRITE_ONCE(inode->i_state, setflags);
+	WRITE_ONCE(inode->i_state.__state, setflags);
 }
 
 static inline void inode_state_set(struct inode *inode,
-- 
2.43.0

