Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A371B392193
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 20:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807684; cv=none; b=jneluIpfwk6jppLC4oxkq8+U4Mvup3Y+VsfMr6hvTYqQTSAZWPK5/KbegrJscxh63t17dEjI/1nuITY5YcPf7kKUqP9rlR//J7ICIq/7+jiGDSMOnMYHPDRHptdtMq03Umw9MOdZEyxPSYlJZEPvbhHF56HMzjidHU13rBIQf4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807684; c=relaxed/simple;
	bh=dcsAxEHT5Jq2nRSpkM5+vx6RORRZ4KO+wi+OUDbhG0Q=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=epWfTDXXq7PVuQu9U9m3ICs1cOcr2Pq0GLb2chhQAPPOhpJxA8xh6QG725JK59PoFL9XCoYNbSEygZ8RD2VRC7F+3w/rxd75AzN7krdDNMgPdZoIZAYWt8Qx7I6tMYLf0/cB86O9kbczmx4+hOlW+ahVFS2HKDRHgBFgD/sEPyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=mHgOvNMB; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="mHgOvNMB"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-71e6f84b77eso12796047b3.2
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 13:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1755807681; x=1756412481; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AHd+4Vz7kPVwWP6qqpZo346lGeZ1ejCBP7K3x1LyEEE=;
        b=mHgOvNMBzYdTWyof322s66jOucc2q08/MzV/xZ6yIs68LuEQFsPDQiKpgqruUbkZVZ
         QJLfgykxXhhEo7I5B70Qd/tJbXqZFpoqO7VYZEDp6/EcYsuRR73OTOK0EXx7qqrfcOkJ
         0lDLZNuvSklFEAkeYMR0KAI3xpEShNzf+uNRLP+J6b/cTnn7NE5jeQWcghM/02+jNR2K
         RvfJH4vOJlZn7E4OfDJmJvvctBKIzcD5AimKMQdJvO6VqjqVgtpLbVr+5Bvx4abTDvPQ
         k7I3dkzfPrcJTSyxLEeA8Y8IWZN9kE4yqly0AxznwrI2MH5zHV+wgurMMKRXk8QSMtma
         FwGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807682; x=1756412482;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AHd+4Vz7kPVwWP6qqpZo346lGeZ1ejCBP7K3x1LyEEE=;
        b=CYuKWNPADdtCJmm7+ZFmZmy8R2KS+YIPtTRdKR9yUDc1yPTQ+z37SrbJm/UpOa8mZG
         EL+iWywXAw/abKjXVbHTiqoVg+RK+BsZ3Z12DZ5+Q4Mctxud5lWK7Om4t3DU7lpHVRFp
         LTZY5QAWqEfZAmPAwSaWy0Orl5e5wOJSqX5uIBXB8QPdQMRwn/uWK3QP26+LXxIot8qb
         fRXVUrSdxBg0CqQgH6y2573Dm/zVOSjLUShtYOiOpr+d9kgN3quW/296cDABTFKS3MyI
         TcPYE78j23RfWbSZE9/5/1paR/YH6+F508FG/p70bSL9I4emxXoDQWRyUxLmr4VVtPqY
         DN3w==
X-Forwarded-Encrypted: i=1; AJvYcCUDHg6PuY2Hp9sYB6oJG7JM6KKES2AUJNHKC59TnMwDjjo4PtbDjLQEOFECyuNtRyvYdM0173y4voo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkGtTUfCWOKX9FnP7JkfHFdcyuW7uwuBW5Cvdo25n7jEZ1QZvW
	r9NleXO0wCtrsgHg9TZ8jmWpFOOMFKuaKJVMvXSsnkAAy8yUm8qwVwDOffyMoY58d6g=
X-Gm-Gg: ASbGncvZtOpMEJKv5tWsBYNerE3T8vKbrC7zl9eh5tLo695n5v+8mFuxc9+a1IdMKlc
	whtvlpCuXg61CjXP26NyNBF22llncUtQBy9t5x8gZGgv/yoUfKNcoaQ8W62AL5hWxqMQPpw8G9c
	r4XYghuQzn2S4bnIPvbnnkl00ysOzvZ0Ks2MO8eIoCabsP1F0iYRLI2kZghJSvNHnOSoWoBxwHk
	Y6Kjy8MuoByPYE0a8HOzzTUJAPQC3JdXtyGp0oqGtmncgM+uohbZZvNRnU+UsOqCQ1gn9/s8Ukn
	KyYtwdintcAGhdtWDl/790tZ5DnjITGNdvz6CyN07IBI5J9HQaMoU3sGsqpYoa0ykSqr+G21vhn
	BoAihsi+qBV+CNwGDlX6I+07jfwcWAM5g7mZ4nCvflRrN1U7Z4LHVUl1D9pahP3nilQwMfw==
X-Google-Smtp-Source: AGHT+IEzo0QXY9VIuY4baShzyB2YhjsCyUBZU5mUEwfUAhGbJD1bAOOlVU8KN48xmuT/FokHR6oSiw==
X-Received: by 2002:a05:690c:9a11:b0:71a:a9c:30de with SMTP id 00721157ae682-71fdc418f92mr7089417b3.41.1755807681418;
        Thu, 21 Aug 2025 13:21:21 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71f96ec62cfsm24521717b3.22.2025.08.21.13.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 13:21:20 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk
Subject: [PATCH 43/50] ext4: remove reference to I_FREEING in inode.c
Date: Thu, 21 Aug 2025 16:18:54 -0400
Message-ID: <ed4673380176f640f0d33201387999207dc1426a.1755806649.git.josef@toxicpanda.com>
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

Instead of checking I_FREEING, simply check the i_count reference to see
if this inode is going away.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/ext4/inode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7674c1f614b1..3950e19cf862 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -199,8 +199,8 @@ void ext4_evict_inode(struct inode *inode)
 	 * For inodes with journalled data, transaction commit could have
 	 * dirtied the inode. And for inodes with dioread_nolock, unwritten
 	 * extents converting worker could merge extents and also have dirtied
-	 * the inode. Flush worker is ignoring it because of I_FREEING flag but
-	 * we still need to remove the inode from the writeback lists.
+	 * the inode. Flush worker is ignoring it because the of the 0 i_count
+	 * but we still need to remove the inode from the writeback lists.
 	 */
 	if (!list_empty_careful(&inode->i_io_list))
 		inode_io_list_del(inode);
@@ -4581,7 +4581,7 @@ int ext4_truncate(struct inode *inode)
 	 * or it's a completely new inode. In those cases we might not
 	 * have i_rwsem locked because it's not necessary.
 	 */
-	if (!(inode->i_state & (I_NEW|I_FREEING)))
+	if (!(inode->i_state & I_NEW) && refcount_read(&inode->i_count) > 0)
 		WARN_ON(!inode_is_locked(inode));
 	trace_ext4_truncate_enter(inode);
 
-- 
2.49.0

