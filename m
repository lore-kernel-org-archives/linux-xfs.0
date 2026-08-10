Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BDF42AF8A
	for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 16:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786380207; cv=none; b=qUajB55u7fuoc82dqJoQV0qL6vf/rvRNOhwlbCES3l9+wWI0ehXHqtE93GhAvsnOYuaO63nfzgiXOpA4Ll/4g3GqI4Km34TAZCbWBVdCxC9bx0edUXI6pBsER+fT9+MOAV82/EzsdJEqIvmJTYlWmkbAbXhmvlIal8VFdUCn7MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786380207; c=relaxed/simple;
	bh=c4fSmyNB4m5oQ8lZfExUsQGukvI1B3sAmLc9u8/mj5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQwvVsSztGtaVRIyyCMl6gHtw3T/bWgq0CQHpy6xoAc98orFbX4AnmnIA2607kYPFKo4LOluzF4MXyN85ZYry8a8z/jwNXK5tlTh6IoEmjO3iJkut9/uUIrmaxIGdTJdEEHh/UGng8i5p3Qv0MQhRXeuI2xGm7jm0EQxENqykMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com; spf=pass smtp.mailfrom=peridio.com; dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b=w+WbApYe; arc=none smtp.client-ip=209.85.217.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=peridio.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b="w+WbApYe"
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-737d7440b6eso58961137.3
        for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 09:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=peridio.com; s=google; t=1786380204; x=1786985004; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xGxAii+GkeS62oW/NXkupU8ykf66W6U2MtKUhTFewv4=;
        b=w+WbApYee2JVL3BDvw+cAmS5dYbL5IY5mKFDHHJNvNtr7340ugFW4ElG9fD5Bk54Hg
         uE6r37hzhUX/Ob8r5FJ3HbdLoY2LW1NecBF7kt3dOm0MkBYJieqF7DMYst2tVn4cnpIK
         NbhEKRURpQZn5XfY9XypZvt2k7X+wIcd+B5ZhpvM0EgF7f6C3A5fBX5OVD83E3NX4Z0E
         p32slj20OL0D+YrlfDjIiK2h4UH0SIJ4l1neCLyj+9c1nVj+TY6G/OPB+bhw/9zgOcfu
         JO4wMkrd1oRa4Bsf3A+S18azyg12uPnkj5ytIy7ORLrRHahanRGfSobBbt90ZSnvJ4LE
         kAiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786380204; x=1786985004;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xGxAii+GkeS62oW/NXkupU8ykf66W6U2MtKUhTFewv4=;
        b=fO9NSYVZr9wayALtRgvcrmwovnYA62nBa3/y6G/rwO15iQdhUxPx01U0gtL+9UVcpp
         w4Muhx4nn6iWQ+r8gWrDzfhY6YRDZKmr/VQQyueSL5KmQnFwLkCs1iN08/JuPVbbU2Qx
         vgKiX0Ie+Xsu8u8xS/jQbMDsqhTuJTEggJm5QFW0101tZ5wzq9jq1acc9o0wZkonj6DK
         WUPIhT1yQLz1jNA+IuI4n4iVGuoAP+cYYidP9TkF2cY6N8ZZokL/IyfHLORVwS+n37ex
         ju3m849akMBSnHUeNSyHTyCnYYocpgLBB6TTmnkiP5bWSvPDhg5+2lrjsS8CmlhIbcHS
         tESA==
X-Forwarded-Encrypted: i=1; AHgh+Rp8GG7dnGhyl66yFFQgtNp2j8Xkfbyn/7ZUhtvbF1mK3rkNTUj26lT9Zbh/ej6rkePviKxaAUX0kS8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwR+ToQVA/+kgeHYVu5+VwbafZtlcECRXkju0xLraztTxpN6uq3
	XVglabwwH7zokpVln/zqLjM99Rj6iL9WX0t4CQ4grQC5X5hdy+yF5P2V+EJziCZDP44=
X-Gm-Gg: AR+sD10lyQk4r0g80MtAZH1DhB+/sDW8X7DqzOofTAxXrLUThONP6MhnNzs3Gyjvbn+
	G7Pgz3HjdCeac98+eTLoknKbiuGN/IufUXEYe1sbnuWX83r0FOUE92xQ8cMqV2gypn1TrGr+PH5
	HGFmPF58N5O5T9Mwb7So2Bm6pwt+g7yetag85/bc2G+YnWSyPf/TE5Os36/eNrEa5S8Uj+3r6Fc
	nJf5jdkjFhJ+TtOsErZhwHEql9aDSqyWhIEQ7QHeft7oLfvRn0U4cBVOja/LmiRWQ1cy+iihsXH
	DrnJHMcJadX8bym1S8tDFSynQ94kFLzp5HtdZp8mSWHxuNwdYhdC8OYS4MIrqkH8/smC4j1iswX
	XQkgrOpbivYflKhNz5n9PBRCsL3jqzaohcKdCkYYIFpIeIFPG6+PnW8wHYyNxPzgxHRoZJTueLK
	h5xjxiU+p5zjwmAJXPHSqFtG9FWQ1uwbM9LSzSUS6mYoVmk2f62NQOCjY/uKkE4c1C
X-Received: by 2002:a05:6102:3ed6:b0:738:9abd:9ebc with SMTP id ada2fe7eead31-760e79e969amr6371775137.0.1786380203875;
        Mon, 10 Aug 2026 09:43:23 -0700 (PDT)
Received: from localhost ([190.113.101.40])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-979ffbdd8besm2934121241.2.2026.08.10.09.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 09:43:23 -0700 (PDT)
Sender: Javier Tia <j.tia@peridio.com>
From: Javier Tia <javier@peridio.com>
X-Google-Original-From: Javier Tia <floss@jetm.me>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2 5/6] xfs: initialise args->total for parent pointer updates
Date: Mon, 10 Aug 2026 10:43:18 -0600
Message-ID: <20260810164312.960721-13-floss@jetm.me>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260810164312.960721-8-floss@jetm.me>
References: <20260808234016.246054-7-floss@jetm.me>
 <20260810164312.960721-8-floss@jetm.me>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2476; i=floss@jetm.me; h=from:subject; bh=c4fSmyNB4m5oQ8lZfExUsQGukvI1B3sAmLc9u8/mj5U=; b=owEB7QES/pANAwAKAbXuwwuoZ3cfAcsmYgBqef+hRIGiF74Jb6/aVidlMF/bNycp0hpb4sogI TuDxy05+peJAbMEAAEKAB0WIQSbE7ILzw7eI0VKk8m17sMLqGd3HwUCann/oQAKCRC17sMLqGd3 HzF+DACSYpq5TFDCIpcKCPZrDIPpswdfRaDz72dOdUR0qFUfFSm6ke93hu1jeluazL5nTIe9PNF ZPyJfNxNBSw2ECWhd7qdY4TRBooGXvKPvJtLH4M3V24m17NE6CRRPgwfFWxw62xCRVHOAIO61CO YnwTGe0AFpoJtPIJVGM5Gn19FVWEdf1d1HGXCN0StGVStKlGoHC6GLjnTZjx67Z6d2APLI3JjCM 3bXfgTOR8ou/qleyn15ey/0hNkABgIBvuQAZbO4nD0JBKsUNjAAW90f4xBtCKi3jfhNdZh9j4m1 fupLiN5V6qwb9gRZ5U8D4qoVmhz/TITUu0kRCKeqWhyHrbN2v8IQo0JP7imyGHNngiuIn6pmNB3 Y1LdECJSvj0CvOmvrOO8Lx6HAEFIOIvfWGaomaZGRNTmOVeEC1EOY9NLtF3TyKW/XYoiRUJ1DCF PAkyQx5WDlLEWoAHt9PvtpsVBsha58N2bRCWxRLNCWx831oEHZDIQxzs2jZZc5v+U1Z7s=
X-Developer-Key: i=floss@jetm.me; a=openpgp; fpr=9B13B20BCF0EDE23454A93C9B5EEC30BA867771F
Content-Transfer-Encoding: 8bit

xfs_parent_da_args_init() builds an xfs_da_args from a zeroed
xfs_parent_args (kmem_cache_zalloc), leaving args->total == 0.
xfs_da_grow_inode_int() treats that field as a running block reservation
and subtracts from it; because it is an xfs_extlen_t (uint32_t), the
first attr-fork growth wraps it to ~0U.  That defeats the free-space
check in xfs_alloc_space_available(), and when it coincides with an AG
that has exactly zero available blocks the allocation is clamped to
maxlen 0 and returns -ENOSPC, which xfs_defer_finish_noroll() escalates
to a filesystem shutdown.

Set args->total the way the log recovery path does
(xfs_attri_recover_work(), xfs_attr_item.c:706), in the add and replace
paths that can grow the fork.  Removals and lookups never grow it, so
they leave the field alone, matching that switch.

Fixes: b7c62d90c12c ("xfs: parent pointer attribute creation")
Cc: <stable@vger.kernel.org> # v6.10
Signed-off-by: Javier Tia <floss@jetm.me>
---
 fs/xfs/libxfs/xfs_parent.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 3509cc4b2175..312f33086d53 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -194,7 +194,7 @@ xfs_parent_addname(
 	const struct xfs_name	*parent_name,
 	struct xfs_inode	*child)
 {
-	int			error;
+	int			error, local;
 
 	error = xfs_parent_iread_extents(tp, child);
 	if (error)
@@ -204,6 +204,10 @@ xfs_parent_addname(
 	xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->rec, child,
 			child->i_ino, parent_name);
 
+	/* Growing the attr fork needs a real reservation in args->total. */
+	ppargs->args.total = xfs_attr_calc_size(&ppargs->args, &local);
+	ASSERT(local);
+
 	return xfs_attr_setname(&ppargs->args, 0);
 }
 
@@ -240,7 +244,7 @@ xfs_parent_replacename(
 	const struct xfs_name	*new_name,
 	struct xfs_inode	*child)
 {
-	int			error;
+	int			error, local;
 
 	error = xfs_parent_iread_extents(tp, child);
 	if (error)
@@ -250,6 +254,10 @@ xfs_parent_replacename(
 	xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->rec, child,
 			child->i_ino, old_name);
 
+	/* Growing the attr fork needs a real reservation in args->total. */
+	ppargs->args.total = xfs_attr_calc_size(&ppargs->args, &local);
+	ASSERT(local);
+
 	xfs_inode_to_parent_rec(&ppargs->new_rec, new_dp);
 
 	ppargs->args.new_name = new_name->name;
-- 
Javier Tia

