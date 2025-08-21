Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FC0372166
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 20:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807628; cv=none; b=uvTWnygJSAFu9nALQwy3HEVkCNETiUdK1RhLhzJ1O0XTFZT/G6BiXI3yM7LV9Afns+YWoLF9+Gqae3eCNmvwCxEbriq73nFVpHrrmyyQVxCat+gfK+kB1A/OSAc2EgRRCXKUJUpp0OMJCiyW2kKZU1dwJybmu/vvTwFtEAr+4Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807628; c=relaxed/simple;
	bh=79hNy8MLLzEWxtQB4sKNaWyskip03chASXjDy5oeEVE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tgqeWLdt1rJJLTrlRgUNwWkdr2US6xhaUG9Ba2FW0WNCEvE2PdA+Z/62paxGvLWy7gJedaFa2qbpnBo+srcBaywGKpYgpDUV9MVEmm9i1HcMqPyELfDb1O2KsQrshPv/Pb7lzrVMzR3Ixr/Yw6GZxlyXaMO2wFFvI7Xz1/Q054I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=ute/rt2a; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="ute/rt2a"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-71d6059643eso10784207b3.3
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 13:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1755807626; x=1756412426; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fQfgrNdLLZc/kRK8PuHP6T1NoeMFhCjwF6aVkuwb+Vw=;
        b=ute/rt2aDrIGbZcCD4LoRaErKtNRZOnwRe0tj73h6Uh6wBt09gFyfS/b+nr5VTrHRM
         jdjYrsHb9aizSdiPtxJVHryfIZOUzkn87zPRqYAq+K0hTuwI2KIe+d6AL2RHHxFmWjgp
         MDZwbUO1v7gEpLVagg0/apRbDMBjjdbsNvSjZkHOkpGRnZRMZ4/+ubFnpmObjsxFR51T
         LcFRDS6cb9uyvV5QZOB+NA8lyg3YSLW1rqv8ylfL4DfMwWfbG2xVo4FP9AyCF41kfH66
         kwrft+1sGQl0g5Niz8Pvx4ZmvYk4EdBSTpYybUhSzpeT3hEs1yilEbdxHSJLrW5JrGDP
         s1WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807626; x=1756412426;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fQfgrNdLLZc/kRK8PuHP6T1NoeMFhCjwF6aVkuwb+Vw=;
        b=KAL2KbFDLZXEI1YI56qKu39HNSElf1NbfrodA8Xl4DutjJaWuqW5AiW4byxR9p1ng5
         bYWsKs7R4wxNjA5s1ZKFceIADxdsaP1opVRjzgbbfgcggiHW8xWrzN4WZTYPzJNCm0DI
         CIDkYMLxSo+WWG/F4abBFIcDDL+m0vQU0k5fft25A/xWIX2eYcK25fIFQYrO32mzvLEq
         W7Ak17RrbBCM7OOgnSM1XQNBnnEAFDEeLpftw1lBeMDF6NgmH5bvSO1+Og2IxS143irb
         3RiRv3sIcdde+sV8+JWY29WK349B407/LjJcOY37eAU/OUEWAG5qgafiEK1XVJ5ScMIW
         Pc6w==
X-Forwarded-Encrypted: i=1; AJvYcCWW0rzSm8Ld+OEQvDC/o8ELpZR72moW+508cpPJWBnKgMCuAmD8X34/UCt+VzQZ/szHVNA8Y67ZrmU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQeAoCbegZ194UK8hS+pqoZ2PahYsvr5+zjsMUHfn21tDSHELl
	RJ+uAIKYkQ4WxxdoePzR7GmXZbRDZSp8j2a/EDu0m4TKMwBok1qQqjseU0dmm02oCNw=
X-Gm-Gg: ASbGncvH1B9GRkMWR3yIkZzz1SqqY42bd6L5SWZfHfXwStgGF4kMaMO4P79ni8yPY4G
	fSnol6D3k5lN4yqNvABlEHOM2l/8fptvEZdVqAGKDAv/DfD6OVYdRYeklfqRsNHJqtyQv3PCHl1
	EdYoVMAJ2QDS+WCU8fpzX4fOj8TOvtf31wu62mIQ12MuBKv/gLDENpSUGbcJcdJEagbs/3DlWC1
	BW/3ZcAtkNHCGn7Np5m4sIIeTKIa/+qZ7N1Pbfy/0XCoLLbhFWZyjIh5RhfSIs0qmHq7IQw9J50
	8J0bGhUPnadczDUjjGK35rzr5ebgsNAVw1hrDatjc/WF2tpn1iNagv3PcWIZ4LPWZdsPXUi4ieV
	+nu6kaVuYDXg1MG0eWdVUL+uUxNQArNlnSz1BaaBaho24RiR4fi/9z24DcbI=
X-Google-Smtp-Source: AGHT+IH6qMUNtcjMenDwwsBm6WjRZG6TyRrHXTaa6FiUieFXv2EqpL/3ycbYTymZg5Nc7D4WJE0sWg==
X-Received: by 2002:a05:690c:b06:b0:702:52af:7168 with SMTP id 00721157ae682-71fdc2be3eemr6737757b3.2.1755807625992;
        Thu, 21 Aug 2025 13:20:25 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71fa8224c2csm19078567b3.16.2025.08.21.13.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 13:20:25 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk
Subject: [PATCH 07/50] fs: hold an i_obj_count reference while on the hashtable
Date: Thu, 21 Aug 2025 16:18:18 -0400
Message-ID: <56fd237584c36a1afd72b429a1d8fbf4049268cf.1755806649.git.josef@toxicpanda.com>
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

While the inode is on the hashtable we need to hold a reference to the
object itself.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/inode.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/inode.c b/fs/inode.c
index 454770393fef..1ff46d9417de 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -667,6 +667,7 @@ void __insert_inode_hash(struct inode *inode, unsigned long hashval)
 
 	spin_lock(&inode_hash_lock);
 	spin_lock(&inode->i_lock);
+	iobj_get(inode);
 	hlist_add_head_rcu(&inode->i_hash, b);
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_hash_lock);
@@ -681,11 +682,16 @@ EXPORT_SYMBOL(__insert_inode_hash);
  */
 void __remove_inode_hash(struct inode *inode)
 {
+	bool putref;
+
 	spin_lock(&inode_hash_lock);
 	spin_lock(&inode->i_lock);
+	putref = !hlist_unhashed(&inode->i_hash) && !hlist_fake(&inode->i_hash);
 	hlist_del_init_rcu(&inode->i_hash);
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_hash_lock);
+	if (putref)
+		iobj_put(inode);
 }
 EXPORT_SYMBOL(__remove_inode_hash);
 
@@ -1314,6 +1320,7 @@ struct inode *inode_insert5(struct inode *inode, unsigned long hashval,
 	 * caller is responsible for filling in the contents
 	 */
 	spin_lock(&inode->i_lock);
+	iobj_get(inode);
 	inode->i_state |= I_NEW;
 	hlist_add_head_rcu(&inode->i_hash, head);
 	spin_unlock(&inode->i_lock);
@@ -1451,6 +1458,7 @@ struct inode *iget_locked(struct super_block *sb, unsigned long ino)
 		if (!old) {
 			inode->i_ino = ino;
 			spin_lock(&inode->i_lock);
+			iobj_get(inode);
 			inode->i_state = I_NEW;
 			hlist_add_head_rcu(&inode->i_hash, head);
 			spin_unlock(&inode->i_lock);
@@ -1803,6 +1811,7 @@ int insert_inode_locked(struct inode *inode)
 		}
 		if (likely(!old)) {
 			spin_lock(&inode->i_lock);
+			iobj_get(inode);
 			inode->i_state |= I_NEW | I_CREATING;
 			hlist_add_head_rcu(&inode->i_hash, head);
 			spin_unlock(&inode->i_lock);
-- 
2.49.0

