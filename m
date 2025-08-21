Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FC338F1BE
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 20:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807668; cv=none; b=fEjfU+6g45REF5cm5HAD2WR9r0oON8BjBBDgHmdI5JRISw3a21mxdPXekbSIOXd68fvtfxcMuylEG3FmYMMJUxcaYXQsVctglPs3Hkl0uhGFXk0g4Oc/mZl7AnIf4f/vcLQZ3WCIrxN+bVIcjTt89+2yP2zmwkXOSbK5+5G7zUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807668; c=relaxed/simple;
	bh=9pmJgOu567RA5Ek8MFIOT/ON1k/r/cyEM9dNKAJxRKs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CRuDvkf5QeAW8QT76hadH9b3aowc43AqsLm+/vdEtQ7NS3Ri6Vlks+HvfMY1b+Tk8GOBwIs1GCvtrdp+kt8XUChOxeiYfrdsSQchPafpDvKB0KERvY7uxsRxnfbyiMXNXQrc3JBRFfm8kyZE8p+GmYIL5+xPsNroxtP0lGT0PeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=ia90qBLf; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="ia90qBLf"
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e93498d41a1so1456044276.2
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 13:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1755807666; x=1756412466; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GTp3cGLbO59j3lKKBRw8ISQooTk63pePlY3kcn/TIF4=;
        b=ia90qBLfu1VH0QSFY8tATZlNB2UdQpu+I9379MS+KMkVo58JC66crqh+KatrZURjdR
         SZEASlhf9yQo9qPQpw8BWmkFNLUX6Jo2Vl6nNJ5YLSVRzASYmLtOoh320NDdVptTVisK
         ipNlM8uY5Uigt3/g/OHDxVStb0Be/8GfGQ47/hQwo35qIVuVF5RiPQNCuvBjcJwgsptt
         aKkHLiJHKJzjARPrdT7W6/9WFJU2ymDgBGUUO6Xqdq4a4zt4VcWnITPEshQu/VHx2KLM
         I32P/yrysOMQF/FNwdUr2t7AALO2NJt0nn7jZGj5cJ8pnT6zBEUWxuuAUr4UoHoHihdI
         HiGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807666; x=1756412466;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GTp3cGLbO59j3lKKBRw8ISQooTk63pePlY3kcn/TIF4=;
        b=kM8ALFgibmLcBJTWRJYEYDQlOJ2QlbOk4GzFaDUz43RIBO1QEalvDrWNn0Irb0MLsS
         fDpjfy8jAsrT+17peaBTFmdkNsaSKLQwaZUXw4L/93yPUBVdAgzNVuSkJ52p2nDMXx3b
         CMBXO3KxmKy8MkSjCy/8fXiIS7sgc+BrmwSY7zm+JFF+1w6iVgIUdw0xDjrcupl5LV+K
         4WEytc6emeCCL6aO6ejiSvZsFOoxVHN1JfIjqAwIqbZxdavnOiz8lbh3h9YlfQt7X2kW
         qJSgDIT98dKoPy9RUOY7FHSmPB75bDyY/DM/nbc0R67LkPqHZ5ae3I+o4b1XAbmE0o05
         PvAg==
X-Forwarded-Encrypted: i=1; AJvYcCWGeay1TnlfDhkurwEWn+/YadIUU0Y5KcW36/RNeN0RstSRo2E95hQWegLOadaCVK+wuvW2PYmC12A=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywt2GgaNmdN29bl3Nm6nWaChGHbcBIEFwJaEFlD/KY3p7UAjeTR
	xYKIHsh3wBc1omSydEcYYxpfriOiJ9T5FFrc8pkcyDnk6RU9jancSkADOMpHSHf4Geg=
X-Gm-Gg: ASbGnct85472j+2sUZXWUhzG5IL372D+A0NZv2RgT/6/wOMzrsVaRXzTHfTBz+IDMR6
	QsN5KXS6vPXnUhonKVjgjcLZU+e6QO8MuKK4qZJeD3G2Uw+xqEn/jMK9NenEuDQZwRwsK2cvbTA
	/NzxlVHgIbUHbWzqpDpYDJ/MrIVZYEKtlSEVX9x20gO4oeUTkvB+2qGpub0iGqJgs8Wv1xjgAlp
	LArHLc8r7SbZtHxBS1+T2KQs2zs86fFOgG+UIigVQPuPugcmb20tinJpf8YYEbw17ecstD2O+B4
	5NBnSrh2ywUWbzXs2MP0mqISOUE6yksNW3/vq63vAzv4iJdDUlUVsKMPhr0/qFPImWeXQ51e3oy
	hhpbHh6KuXL+jyW1N6EfMm/0g1rdvc2okXQLlY0MJRciorozjCUt4Il6q2gA=
X-Google-Smtp-Source: AGHT+IG3QjFoZbQu6hg8VFuaebRzzPXkxgod3PhB2rVk9DI3MJfu/348HPHSDjgQnN+TBDXaLYfVew==
X-Received: by 2002:a05:6902:2082:b0:e93:2e8c:36b5 with SMTP id 3f1490d57ef6-e951c401816mr828431276.42.1755807666169;
        Thu, 21 Aug 2025 13:21:06 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e94e85ab0e9sm2809223276.37.2025.08.21.13.21.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 13:21:05 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk
Subject: [PATCH 33/50] fs: stop checking I_FREEING in d_find_alias_rcu
Date: Thu, 21 Aug 2025 16:18:44 -0400
Message-ID: <782ee9ead6eddc1f96a0ab91b97dea577d20779f.1755806649.git.josef@toxicpanda.com>
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

Instead of checking for I_FREEING, check the refcount of the inode to
see if it is alive.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/dcache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 60046ae23d51..fa72a7922517 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1072,8 +1072,8 @@ struct dentry *d_find_alias_rcu(struct inode *inode)
 
 	spin_lock(&inode->i_lock);
 	// ->i_dentry and ->i_rcu are colocated, but the latter won't be
-	// used without having I_FREEING set, which means no aliases left
-	if (likely(!(inode->i_state & I_FREEING) && !hlist_empty(l))) {
+	// used without having an i_count reference, which means no aliases left
+	if (likely(refcount_read(&inode->i_count) && !hlist_empty(l))) {
 		if (S_ISDIR(inode->i_mode)) {
 			de = hlist_entry(l->first, struct dentry, d_u.d_alias);
 		} else {
-- 
2.49.0

