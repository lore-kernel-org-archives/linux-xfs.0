Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD9138D7CA
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 20:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807654; cv=none; b=oaHi2NZXGWO0Xd0EGXQDANwinuQVWG5hmF18MsCDGgqVIL6tfp0z7FA19DDCFEOvXFZXqnJLKak2LGSeQGeWMVxV8VNrPEWrIAfl6hv1XHqwmNWmQQiOnTNYDwev03erzvi7koVMb2LkzZqq/izKU7MKoCNHCiWL4WWhsFtIL5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807654; c=relaxed/simple;
	bh=/SD0GMQ7Z7lFaGRylxaKZKlYwNeii2yE86zZo8Sf7zY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DyDxKCAX2Lqw2RMCzT5obwaq3qQJ447XexXRvKwMtEVL5+tyWrE6X9+zW14vE7eATwD7Si8Jvi4DbPK30kkI7Kk5RlX3clYe9ZZCdS1HuWTrrdQUUQubxyO4kVoIOIbVjLCOwG43SrYedokQUccRxFLZ++8ZSXPVQGY35zRbDU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=ONDchD72; arc=none smtp.client-ip=209.85.219.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="ONDchD72"
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-e94fc015d77so1481596276.0
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 13:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1755807651; x=1756412451; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VOMZ4zNNq1s5cON6tAf/wq9yALNeNe8lvhj+xp/yDeY=;
        b=ONDchD72W2DwN1FJdIE+SLzJAyAdGWwOzGuSG/IW4cVZAiN6IqrX5RMpnL/NTAGSK8
         wGlw9hG4pGobJJTyA6r6oVoC1zeB91GQsbdcyMO833NytI+hjCx64gUtVhtSrHq2vwfq
         YqQOsklf84SU5aepheB22LjL+sg0x/a1FCx15YrhUd7LO72w3ixGFEtLRnPVJQWY8MvM
         VK9/xCCadbCJBEePzm3zyrqlolYWJpT8BXOvM9Ddn7jK7w3vpNzTMfaHSUlER2cFLSOV
         Kc0GmNtGT4AodvEoRbTM4GPcAv2JlGBIBSd912getd0eJdCbkwRDO/uKMOWjHuxNkmJP
         RB7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807651; x=1756412451;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VOMZ4zNNq1s5cON6tAf/wq9yALNeNe8lvhj+xp/yDeY=;
        b=XpRmXg+xsXAuC0y/S/EGiC4H0fWXQimDwAHWweeDu4G7Xfum+2zK/2DlxitHUdx75P
         QeuQj9RL3f7GALasNJsyX1FlvPEgDuDaG0XWRxB29ZablVkvpIxEanNjy2//Uy3XkkLk
         bVQwDL9vhxNJCgE0i7GskPg8JxfWrj2VOp1HwK5T3aLsNiSp8MXfNkFQ1CwB9Q2WPuHD
         EkhjINNHKbKhkopOY1u5YiOI1kV1u2N57h/JWx9ioa52HLH22J/WGCz+7PIYs9/Y/YrU
         5FaMMBJlHZYOxWwnIskZTqhMW0XoHxaoIgsjjogQYpMyfHQ+kYgSt3NWACW+qg2llPRE
         D3hQ==
X-Forwarded-Encrypted: i=1; AJvYcCWjFhfd0aPqUTS+5sYTJJQZRMedLEkKUX5QgqEalXa9m8uPMJh/xnpSVGOn58ioSsppJFLIAo5LhkM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwqxEu1kVhtBT53O5tncWtw6a4WVLqdCa0uJ4XqO1OLG3/aP5UE
	nopC+98/A2CpygE5EUN4hH0A1TLi+MYLQUSwH2l896nSig7LFskmk3TPg/MXZ820Tq4=
X-Gm-Gg: ASbGnctNTOhuuXmvLHHxb3PLWmAqeeXvezFa/o0WaTm6bgzLcF+mI9EFztjw8rBxFSl
	ntBjFu5dyG961un66576hhF73jGeV2vFXq3+zXEPTS1hnH8V9ogonGBDzrxtFDLan8bX9ZoW0iF
	AmVahEPnh6zjhVuISIU96FBrl8nTokAe3jqRbgvD9CrbnuM/rbeogwXRgNpIHWcdlWen2JMO+Rl
	R/dkyGyyvcXtVRMOfuFlIyRmLwex7oHXjAiM4UwPeY77fvLIZStzJP3KCM/EYswwFlYt1/F9ZI/
	A39Lc80CFIQ9xNFMIE6rF3BB3+zaXADJC4sO/RlQSCoIE9iyTg74JoK1kFZ4VtvKgkpl2b5Jke7
	16tVfga7c8bXtJWp4gOFweIR2fyLYw7uMOKg6B4YaCvXqMWUo8Eyk5rFG8Mc2xm+kPNVZaVSEKe
	4aOym8
X-Google-Smtp-Source: AGHT+IE6HvsxjPwCyB/oWd9nkC+GiXEkxClQFs1S1ZRPTLNR+IPSUbRvRPeUbjnnpHHrMVPQxbBM3g==
X-Received: by 2002:a05:6902:2b89:b0:e94:e1e3:efc8 with SMTP id 3f1490d57ef6-e951c2eac87mr904774276.53.1755807651484;
        Thu, 21 Aug 2025 13:20:51 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e94f14d53cbsm2423258276.26.2025.08.21.13.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 13:20:50 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk
Subject: [PATCH 24/50] fs: use igrab in insert_inode_locked
Date: Thu, 21 Aug 2025 16:18:35 -0400
Message-ID: <b4aa91a69d006ade6afc9acee6fbd2192cd186d4.1755806649.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755806649.git.josef@toxicpanda.com>
References: <cover.1755806649.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Follow the same pattern in find_inode*. Instead of checking for
I_WILL_FREE|I_FREEING simply call igrab() and if it succeeds we're done.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/inode.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 63ccd32fa221..6b772b9883ec 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1899,11 +1899,8 @@ int insert_inode_locked(struct inode *inode)
 				continue;
 			if (old->i_sb != sb)
 				continue;
-			spin_lock(&old->i_lock);
-			if (old->i_state & (I_FREEING|I_WILL_FREE)) {
-				spin_unlock(&old->i_lock);
+			if (!igrab(old))
 				continue;
-			}
 			break;
 		}
 		if (likely(!old)) {
@@ -1915,12 +1912,13 @@ int insert_inode_locked(struct inode *inode)
 			spin_unlock(&inode_hash_lock);
 			return 0;
 		}
+		spin_lock(&old->i_lock);
 		if (unlikely(old->i_state & I_CREATING)) {
 			spin_unlock(&old->i_lock);
 			spin_unlock(&inode_hash_lock);
+			iput(old);
 			return -EBUSY;
 		}
-		__iget(old);
 		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_hash_lock);
 		wait_on_inode(old);
-- 
2.49.0

