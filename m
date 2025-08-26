Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84FA3371E87
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 15:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756222918; cv=none; b=XNDEFqmNqh/kZ5VL9K2Za3UDPBLChwRRqvAGoE/JUXIu+frV73ZtewbTX873TbkMp0rW+X9ug7tn+iktAesG/Jd3iIkW7gnOLb/VSjsao6h3GYCbpCFnM8jREGUz3uacB2fEX2JtnGRySlpouQqlcFUs7Kki7c3CMHoXJg432QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756222918; c=relaxed/simple;
	bh=XsaKjFvjn2X2zQJVY/YiX6emHhDV+XFSGzy9JGOtu5U=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=irRLXi7TcJsjEu3TLWME7dba/Vl9I5D91Mo3wkxya75go7pjBZNv7djeJ5pKzcaE/0c5fBIhP1NqLB8AlhOGhji70vaWesqbgV3c+dwrWDDfrYo6pySPyPgJEWabVB75vzx4esETjGhux1qibX8LP1JWNl2tbSALhexkndgheCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=QwR3rDVy; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="QwR3rDVy"
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e96b9022f51so2646333276.0
        for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 08:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1756222915; x=1756827715; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V8PyrEAUPXNhyhibERc9OWnq+up7VaznWDP3y3iEFg8=;
        b=QwR3rDVymZqt8hRveI94+a2iu7hKzHAMVnuzeNt/Mgdlzhokvc2gExOfcoLJxCDQ2C
         LsdMhUm3IpgEKw5PmSF0ktzDGG7/szFPfVrp7YAhJeAjh1NKYGu+/2rSsoYwcTWtymrV
         97wpQkTyY6n4h2I7w0O1HyitlAMjDPWEkp7T0J2CbYTrN3LlE+jRPfV1cY2K0s2hTwFI
         ExUQLowQsIrstjx/DekBOK0ciTD9V47A7bO8qOcXHm2d67C5UcQcWOOPRZM0hZUOx6WR
         jbDhRDNg10r5szKSxsVXYpfhLvY1fyhyxIMCFIvlCvC6pOfnEUXEvwqpQvQr7T49xx6K
         VF5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756222915; x=1756827715;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V8PyrEAUPXNhyhibERc9OWnq+up7VaznWDP3y3iEFg8=;
        b=WR2FxIPbcZYMf5S7ApI8STBuM/CqziB4tApOAKOR++dxiw4BoVwYExRHdF0Um1UHET
         2GpbpdecmbjCsh8GqLIcVgEpEYKIpoYiQlllQnBNKW6AFrjJ5RyLZhKeaS/YVUyxYp5W
         8vY49VJV5ZDDOHV4WLlRFt1ZXAQ/jeJUganhG0qIS4CH/w5lFRFK1isisEvOExsoDOqs
         fqtArz9qrY8+q8k/O8/TC13JgeFZKyytsfBnaatjmaWmvH3NTo0fl35xkgoUz7J/Xi9m
         UZGk2CZWf+F5KruAMZVLoBZiidQOIHHkWIYK5KDnYRWM9OkkcaTzT5OQG+BRlXWQjI8B
         qNNA==
X-Forwarded-Encrypted: i=1; AJvYcCWTTxl4ZpKpSivO+sAN7XsO5K8FRXEglKDasvjN+UVpDENH7tV2UEE3Ca0gPfO5TxtyOsbZCsLxm8o=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWYrP1QRr8cFlvWYIdnRoR35AsizlAJlHS2SY0RwoHKG7Cbbla
	cAZv2r5eyXUTsKJZ/H3x6+v6CNHNAraHbYYqsxBE6JhMyQ1mbhci+gHdXSOhqv8JYyM=
X-Gm-Gg: ASbGncsN4oZG1gYEPcABUDIF+bAKPRZ5i5AXoouJ9PFQ9/6f8HZ+ZF6HlIL3FnrTGxV
	VenHN6p2lQQpb8MIZe1Hi+ZIwqnWCcZSt5tdlml6TSLg3rrTSMcMnhJr9GFY6QIfHmDDOitaP2J
	BWtSbY61UsRBmqYeMU3y5na7ijPYvqSsj2vN7LX2r+rSSSHExJJMfNABegrwx+g77BLBFpJmyIl
	skTQm0Ski/0yyxfT4Ml/I7qaMjmgCyz29q25HfhhPH4wxL5O+1yyCqXK8c/O95M12snspVYN2iw
	VLVFamY+w4X3y3KzFvmfyiMnWaqLS6D4KIJn3hUl8TuBpv2ZoXKoo2h4ZmthgEBQ74qIxjdxk+K
	R8thddoaIlcYriZJrMY+9qcZWpzZbjhRnz1KUnC1JohvnFoCxaPWsHEhvy4HEOMUrHAnNQw==
X-Google-Smtp-Source: AGHT+IHnCtvK0jxYJNkTESswSosZnios2zMRKwe+/SpsjsU6S+aMRrm0t4ADvA18pKD/XqQvgFp4JQ==
X-Received: by 2002:a05:6902:33c5:b0:e90:8278:5ef7 with SMTP id 3f1490d57ef6-e951c3c715emr17788783276.37.1756222914605;
        Tue, 26 Aug 2025 08:41:54 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e96e9fa5d42sm190363276.18.2025.08.26.08.41.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 08:41:53 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk,
	amir73il@gmail.com
Subject: [PATCH v2 45/54] ext4: remove reference to I_FREEING in inode.c
Date: Tue, 26 Aug 2025 11:39:45 -0400
Message-ID: <934a321990245e31ebd29a44e905ed6e5202ea65.1756222465.git.josef@toxicpanda.com>
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

Instead of checking I_FREEING, simply check the i_count reference to see
if this inode is going away.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/ext4/inode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2c777b0f225b..178448fb73df 100644
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
+	if (!(inode->i_state & I_NEW) && icount_read(inode) > 0)
 		WARN_ON(!inode_is_locked(inode));
 	trace_ext4_truncate_enter(inode);
 
-- 
2.49.0

