Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4CC36808B
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 15:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756222893; cv=none; b=AKjOEsmE86Wh2E5HPBYkho7Du4tMrxlC3m+88JgtiTot7L9w46j2TkB8CJlrpt1m9LZoDHffddOhLoGJRHXKQArW2kMjOuynWm1iDHqAJdxyQMPy1Q0InIDfN4u2w8Qz5Z+A5oZ6TuqBEQpwSwFOVgT/M0zaU4IvRe9agg66vHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756222893; c=relaxed/simple;
	bh=KH914xoQJXrO8N3ZjmL923rQ+0fw5BtVRwkJcmLo93g=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bbgqaRWKnh1aTlCG/tgftUDHs2ATWDICtd53+2GknPO8Jpw5MdePWyt5Vv8l5sMjjerChUwsVmb9pN1JCX7IWOJoDAu1AsXvTHaOW6SNddT0zN5XuZrBVRAhy2Vfh2kUiM4flmcF95T6yczWQ7R2uHcNyV1405f4PsUBRyuZ3/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=PAIBrMSp; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="PAIBrMSp"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-72019872530so23005097b3.1
        for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 08:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1756222891; x=1756827691; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C5KAKsh2PfGXT4+TYPG/ltaJ7kkJlF6llKvHHQC7hMo=;
        b=PAIBrMSpjeDzuYzNJC62+RMhL/Fl6xdLmvBwZflI1a2/qZ0H7VxahgeFe2J2cCNZRY
         B7WCA2M7b7ZxDaLu8Pv1/LjFNsZODqQwetoe6/v53qB85BF4QxQRvZt+epApAW5nmbox
         5K4Z5S9FFpR5PrM1gDfEFGHtONcq8m5NWSsyG+D3GR2Xr6y9n/29LBjdYnoYNqyDtZ6a
         aqoCK/SRshuysx1TLXRFN6UKV6pcIFgfMJamxsm/QRbcCddYijlsCeSpK+3iW5MlUTpL
         QIbe3e8BkATd0PTHj2lgJVw7U8vA7LWjvbcnN36GpewVJX01gNebt/D18gy6m+PdtcNT
         zUPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756222891; x=1756827691;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C5KAKsh2PfGXT4+TYPG/ltaJ7kkJlF6llKvHHQC7hMo=;
        b=XxvJ3bzIxkGq/jvGpvNCqTgiGFZ6iCgNgE2WDtNHHouHTI5hbUGOn9Wdqi8dCzgGtu
         jb8KtK0AjemqNTeZpu7wUM8fs4DiezOsb8RU3tfA+QNw2QH721Jt5u4Vsgf9PpbQNJwy
         8+y21VF5A4hdBEyQqEuIRcs+rnQ6i9/24dee+IBL15hr1hnjRStymmrwfrpGTR4XmtR4
         xMtvcjo6fGsOXZOLtwkzW2ZAiriBw2pk/BiimKh4KGe42rckv2/F7G/5XvU1rDUCIXnk
         DgNsO7+EKIO7vckH7WbcsSxlfZaTaXADCOqKY91FRrY/VkiSft3k8rvsmfM6S8MXCaqq
         TOug==
X-Forwarded-Encrypted: i=1; AJvYcCU2cxlZBtz/2ovCPUMCCARPaak+kSquupfsof237qFmGRK2nBrYvJDXoAJmHKGQXUcYEeY8kjYmtRI=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywtz2wTgtujA6wMiOp23omq9glBMJ+yNoKxEseouoOfqAxjv2tk
	+71MycpFMerQBPY4cDLLb7bkuZqZix+7TPOmhSFxdJD9X9oCN1OWbQzHk1HiXeMdsMLupNfWh/1
	OyaQG
X-Gm-Gg: ASbGncufxf8sy3e8kUgLnVZOWjR9sIvCgclSZCrmAU0Gak0IfE18ecaK0G7vrnUO3BF
	Q36uZQVDpczMXFxKuFz4RJ1S1RaCGJNJqsFvRLFCHJRsLAva7vi4Gn0eaqixz7K5JKTyJrra/v6
	W17C5MSpVf1xjnQZ+6IEGVURs8SM+FhQoThwZjJ5jX8serV6qsB+eG2+vPIRx6r+SAzk++Hxnkr
	w7xHyF0EPi1PdD1/rp65VhS+yoDBS8/2z1cdEtrMNuJDL1JCXbyl5xUrGRX13Nn3GMDIaWeMK9p
	qEIqpD4U6euxtgpn2ECQ7yl6/CDVhZ12etpwuZzFuXh8hORdXV6Fzycmwx0JDPkgRzmiZicYezH
	q4g6SaCMeXKrgi7vQIIHj2GBpH/7JmLU3P1c5Avd9HrRNxi/P3vhCb/Of29/9MjhenMJnTw==
X-Google-Smtp-Source: AGHT+IFKqwEmHNx5eQFlQTUVO696PTRIuWbfxVqgnshRh3PzZ7/9O1IwzGnfu42E66nP2s6IML84qQ==
X-Received: by 2002:a05:690c:620d:b0:721:369e:44e4 with SMTP id 00721157ae682-721369e668dmr18015457b3.45.1756222890893;
        Tue, 26 Aug 2025 08:41:30 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71ffce104d1sm21641597b3.28.2025.08.26.08.41.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 08:41:30 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk,
	amir73il@gmail.com
Subject: [PATCH v2 29/54] fs: use inode_tryget in evict_inodes
Date: Tue, 26 Aug 2025 11:39:29 -0400
Message-ID: <a9182c9716b474752c0110af726b95125a7007db.1756222465.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1756222464.git.josef@toxicpanda.com>
References: <cover.1756222464.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of checking I_WILL_FREE|I_FREEING we can simply use
inode_tryget() to determine if we have a live inode that can be evicted.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/inode.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 2ceceb30be4d..eb74f7b5e967 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -967,12 +967,16 @@ void evict_inodes(struct super_block *sb)
 	spin_lock(&sb->s_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		spin_lock(&inode->i_lock);
-		if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE)) {
+		if (inode->i_state & I_NEW) {
+			spin_unlock(&inode->i_lock);
+			continue;
+		}
+
+		if (!inode_tryget(inode)) {
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
 
-		__iget(inode);
 		inode_lru_list_del(inode);
 		list_add(&inode->i_lru, &dispose);
 		spin_unlock(&inode->i_lock);
-- 
2.49.0

