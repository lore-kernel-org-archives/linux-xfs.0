Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C257251783;
	Mon, 12 May 2025 16:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747067544; cv=none; b=GqVxjRlKlwTO7Mfq5MvX+BnupqQ8wc/i7yEQEmjDpou5A2ikI7oBCcqx7dn/XILiTJ4MkIYevFj4uqaUjLxl9pxjw5jPeNp+norZPjOyX2liRkhyj6WhHgelPCHc8+BnY5t+CURXiImByzB/mi0W+HQ7ppnGySAXLL/vIk4QVyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747067544; c=relaxed/simple;
	bh=fMiasWPiUBdFL3DVSAeKjkF0obC+BUUqbBWDalvKxE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eCVDtbD/pKIW+kgyHAWf/0gc3vjqJj2hQdQqWB3o4lO/ZdZ7++MCH5C6cegXKmB1ED2tSeWFGoCGqYSfmSGjvGkO3RACkGiOG4d1U//mJl7rKtYavA2TVWc/e+EfRjmTRrmCbuOIPpYDYlgZlXGfvKtVr7LTHnpr3oS+M7xXFhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JMhx+OH6; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JMhx+OH6"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-306b6ae4fb2so4389019a91.3;
        Mon, 12 May 2025 09:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747067540; x=1747672340; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Epl0Oqhlb5zK4xIQwWeFjvtozngBud4D0IYtwuWw5Mw=;
        b=JMhx+OH6PufUcbxMqPiTjGROo4LKQJaFgyb1YvobevBPYDY7I0jLUHDP4QySqjSJpa
         kjfaKpMM8BMI8ucpT0zNRKFIySMmpuPHCoR0kxb/zKUJj7KbM8kzXswsywfzfyBWqHYd
         xgeqENoSaZVb8mfHXHyaTI8Sbhcu9f0PfyZhSnwWB5CfKgf9jIECfS+dKRheUZfEspFp
         xhgBOMum0qJP/LHiwqJ9qTB7aLrgJeLxJOZJ5ZfBwBuZ4JBB9OUNqtWT2ZOlO6a2kNHC
         6WToChk6tX5Qlty6hJOzsuUH07IE8hXdXqEfzYzhUwGxTRazpQSMoFKXl9ANJCOd/sjk
         blZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747067540; x=1747672340;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Epl0Oqhlb5zK4xIQwWeFjvtozngBud4D0IYtwuWw5Mw=;
        b=rMOPtcEhUmNEtb3LpIJ6Q9ka8OkhchuETO0gurKTs6xyMT0AI07ylPIJiBvM7qYX7k
         L0/Wa3MT7uay1HxXtZ81Iy81i+jxCrp8bEuEibPu5Nv+bmus76D1njDGBhrJx+3HbYR7
         tn1JUfcDcGepEP0jZX3Mq11yznnDGIORzEEu5pJNtc4vQ2vITljvdgTXPFxbLSylW91L
         CnXw8Vy/Spc2F6TOEzrGWgna97dFhuNI0QG0sdtD8PJU/rM7pzg721dWahDhuvv/OMXp
         6NERlXbdLB+1r5joa3ZN3lax8naTXygLfy5zeKHV0nMw2wnk43r6PhN5mugX/Wm0/EzV
         RZNw==
X-Gm-Message-State: AOJu0YyCTsj/lfzzjoXcmTByxySqux1WPky9EH3OQdVvBIhequ2VHTcx
	Ox5zfC6wBGFWF9DhT8rA3ravzDdh7NE4k0SfIm83sDqicd7IsvyOJIOGMA==
X-Gm-Gg: ASbGnctYRo1xtwo9RrmO8YjPzFZFg4vHsbK68Hm9+1w712RA99vdjcV9VNcRv9J9hGf
	MSr/zR7Q1OD2twAypDF4qThTkCXC61Ygoon1a+sIibunhl3EOIW77MXLwZVWRE16e6cotMXOaQk
	LQPtg9sQQpLsUZ6FuvEdNqF1AbusT371zGSOyrzVnxKCgEOte5x1eYSYR9x3XfX3VJEqIyZHhbJ
	pGxuOeqv42yHYcTG5eDjJE+bFYJlKvPKn6hz131RjXoSgiMPnE7/PKaFe/HdwbfNHIfArOyteFc
	HitZp3Vvw6VS9vrlyyXf1jYQLXsQc4uoWrzt2OjSPqgY437vmeqWGhV82GDQNf2Y+7V89qvLr+b
	3Alk+zCokAZ9VM/81nlkpfAVKGobh5Oyagw==
X-Google-Smtp-Source: AGHT+IFUO0GWexMlWFmVGZyWRKXRYXqi9GuE3IAtNVkZu+Qcv2VM1vMv2h2TwAIFIoVB7g2zuypWNw==
X-Received: by 2002:a17:90b:2d8d:b0:305:2d68:8d55 with SMTP id 98e67ed59e1d1-30c3cff56bdmr21416788a91.8.1747067540320;
        Mon, 12 May 2025 09:32:20 -0700 (PDT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com ([49.205.34.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30c39deb39fsm6820150a91.22.2025.05.12.09.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 09:32:19 -0700 (PDT)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: fstests@vger.kernel.org,
	ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	djwong@kernel.org,
	zlang@kernel.org,
	david@fromorbit.com,
	nirjhar.roy.lists@gmail.com,
	cem@kernel.org,
	hch@infradead.org
Subject: [PATCH v6 1/1] xfs: Fail remount with noattr2 on a v5 with v4 enabled
Date: Mon, 12 May 2025 22:00:32 +0530
Message-ID: <9bced01bfc8df96e47f7d4448e562ce8fa47822c.1747067101.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1747067101.git.nirjhar.roy.lists@gmail.com>
References: <cover.1747067101.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Bug: When we compile the kernel with CONFIG_XFS_SUPPORT_V4=y,
remount with "-o remount,noattr2" on a v5 XFS does not
fail explicitly.

Reproduction:
mkfs.xfs -f /dev/loop0
mount /dev/loop0 /mnt/scratch
mount -o remount,noattr2 /dev/loop0 /mnt/scratch

However, with CONFIG_XFS_SUPPORT_V4=n, the remount
correctly fails explicitly. This is because the way the
following 2 functions are defined:

static inline bool xfs_has_attr2 (struct xfs_mount *mp)
{
	return !IS_ENABLED(CONFIG_XFS_SUPPORT_V4) ||
		(mp->m_features & XFS_FEAT_ATTR2);
}
static inline bool xfs_has_noattr2 (const struct xfs_mount *mp)
{
	return mp->m_features & XFS_FEAT_NOATTR2;
}

xfs_has_attr2() returns true when CONFIG_XFS_SUPPORT_V4=n
and hence, the following if condition in
xfs_fs_validate_params() succeeds and returns -EINVAL:

/*
 * We have not read the superblock at this point, so only the attr2
 * mount option can set the attr2 feature by this stage.
 */

if (xfs_has_attr2(mp) && xfs_has_noattr2(mp)) {
	xfs_warn(mp, "attr2 and noattr2 cannot both be specified.");
	return -EINVAL;
}

With CONFIG_XFS_SUPPORT_V4=y, xfs_has_attr2() always return
false and hence no error is returned.

Fix: Check if the existing mount has crc enabled(i.e, of
type v5 and has attr2 enabled) and the
remount has noattr2, if yes, return -EINVAL.

I have tested xfs/{189,539} in fstests with v4
and v5 XFS with both CONFIG_XFS_SUPPORT_V4=y/n and
they both behave as expected.

This patch also fixes remount from noattr2 -> attr2 (on a v4 xfs).

Related discussion in [1]

[1] https://lore.kernel.org/all/Z65o6nWxT00MaUrW@dread.disaster.area/

Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_super.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index b2dd0c0bf509..fb2d370706b1 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2114,6 +2114,21 @@ xfs_fs_reconfigure(
 	if (error)
 		return error;
 
+	/* attr2 -> noattr2 */
+	if (xfs_has_noattr2(new_mp)) {
+		if (xfs_has_crc(mp)) {
+			xfs_warn(mp,
+			"attr2 is always enabled for a V5 filesystem - can't be changed.");
+			return -EINVAL;
+		}
+		mp->m_features &= ~XFS_FEAT_ATTR2;
+		mp->m_features |= XFS_FEAT_NOATTR2;
+	} else if (xfs_has_attr2(new_mp)) {
+		/* noattr2 -> attr2 */
+		mp->m_features &= ~XFS_FEAT_NOATTR2;
+		mp->m_features |= XFS_FEAT_ATTR2;
+	}
+
 	/* inode32 -> inode64 */
 	if (xfs_has_small_inums(mp) && !xfs_has_small_inums(new_mp)) {
 		mp->m_features &= ~XFS_FEAT_SMALL_INUMS;
@@ -2126,6 +2141,17 @@ xfs_fs_reconfigure(
 		mp->m_maxagi = xfs_set_inode_alloc(mp, mp->m_sb.sb_agcount);
 	}
 
+	/*
+	 * Now that mp has been modified according to the remount options, we
+	 * do a final option validation with xfs_finish_flags() just like it is
+	 * just like it is done during mount. We cannot use
+	 * done during mount. We cannot use xfs_finish_flags() on new_mp as it
+	 * contains only the user given options.
+	 */
+	error = xfs_finish_flags(mp);
+	if (error)
+		return error;
+
 	/* ro -> rw */
 	if (xfs_is_readonly(mp) && !(flags & SB_RDONLY)) {
 		error = xfs_remount_rw(mp);
-- 
2.43.5

