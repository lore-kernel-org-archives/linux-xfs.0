Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3DE15E7EB
	for <linux-xfs@vger.kernel.org>; Tue,  2 Apr 2024 21:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712093750; cv=none; b=PxyZEpdHH8FhOqrrwlgA6CPSa+MajXQFlw/6bkJaFqfP4/eV4i/+Vx1VOWQRNxSBfg0WYZye5cU5QcDLiloTBLIjht0J7GarWhWCUzI8/MDPaRS9+52uIrZZ+bPAo5c9E6zC94VvJwarWNw3Y4ZhPZb/X/3qg+W8Mowi/C2Faz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712093750; c=relaxed/simple;
	bh=cnhqGQS6B4zSCO3oTRbt//5FaU9ATJWT/10+Yxh4PKs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L2YzJpUS7dWntZirn1kBgyiz0FDTL5T/IbEuQFHtSZbq6DaLB6an1XMXp349hTev7qD78lGmoPmtJnxUUuRMufEkcW6dBTJyDRwG6cPK4s7m0syv3KtnXv3UUllsecVX0Ee/eb6nGB9fzaSDVxIuAN/2KuqLXG46XYQxzHWJLyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=U7gqxx4Y; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="U7gqxx4Y"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1dff837d674so44667475ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 02 Apr 2024 14:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712093748; x=1712698548; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9xl4PzADOc1eK2vEz886f13LE4p3W8qAMdKdUaBl/bY=;
        b=U7gqxx4Ybd3tk/ShDRgdaytTXjaQTdUdbohXwaSblRn/sqJUmlewu4Fz2f8OgdRmgK
         Gs1OkWUmVM3T/mhP+yaHGtpYzQ/+H8/7GG2hWKeGjBgtfh5jzdmHkJR/0bwVFEWo6mTb
         u5Q2FL8JvLiXOCVfixZlwAxcLa3ZNef4Bctx9KqN8ZgfUrj6Al9H4p6Ih337fKn02Dv7
         EqdXcKILoLPPuwsOgttO1g1Z0Pbmi8JjConF9GZPBVbp/93dUvHrnY0E99Nq7PXvp6+C
         9sDYQ+k3Lt/ksCA0tc8XspGX+/uaG0r9TR+3dOxOa1fe8ZrK2tUNMLEYhTOFCkvpchDg
         XNDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712093748; x=1712698548;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9xl4PzADOc1eK2vEz886f13LE4p3W8qAMdKdUaBl/bY=;
        b=KextudIqQ1QuLKOvkMY4BIF64GUSJ3Un0qzOZQa/4/3x9/zXosqxJWLjkF4yEhSw9i
         XoT0OD9nPFGv+fd6pOzYhsC/dxwOoaOG5ZaTu/LgmKxIi8xjTIp2VOXpQtCoO2rRiFRn
         9XrCOVM5jvxMyQxrSZZaMWChMO3ivq3FLFDbtyH2q26hunKng9mO2GKNLJm1Ief4OgUy
         QnGeZb6WDF8X+p8bT17L3geU4tZFnTZ4awOK3GdU3QjVgLK43FRJ3YC+wrWDb+vFyA7A
         i7GxryKHdgieNl490rpuAGkxXIWeK8UzlzgVoIrVUxp3yCOzRaEeiTV+jbhbhJJiz9G4
         G9gQ==
X-Gm-Message-State: AOJu0YwPvewBnQox4SN17JxuKVUYphNyBVT3/0VgweX/BSvltz0/qCVs
	rV6XHU7EBE39dtRUzrGKMyxwla1E65V6kSJVmY69jyz0fTPO9gFa+PeazyJe6iwUgACzBup00qN
	E
X-Google-Smtp-Source: AGHT+IHgcaGqDmOSG0rDcR0PGfPUIu3jyULwmZc/iDiEzTGngs2QYAwlKGutVTnjvyDuZq+nYwdcSA==
X-Received: by 2002:a17:902:db04:b0:1e2:2587:d43f with SMTP id m4-20020a170902db0400b001e22587d43fmr14630000plx.36.1712093747888;
        Tue, 02 Apr 2024 14:35:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id lg13-20020a170902fb8d00b001dddbb58d5esm11656169plb.109.2024.04.02.14.35.46
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 14:35:46 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rrlnE-001n77-0T
	for linux-xfs@vger.kernel.org;
	Wed, 03 Apr 2024 08:35:43 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rrlnD-000000052Fa-2l6S
	for linux-xfs@vger.kernel.org;
	Wed, 03 Apr 2024 08:35:43 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 3/5] xfs: silence sparse warning when checking version number
Date: Wed,  3 Apr 2024 08:28:30 +1100
Message-ID: <20240402213541.1199959-4-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240402213541.1199959-1-david@fromorbit.com>
References: <20240402213541.1199959-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

Scrub checks the superblock version number against the known good
feature bits that can be set in the version mask. It calculates
the version mask to compare like so:

	vernum_mask = cpu_to_be16(~XFS_SB_VERSION_OKBITS |
                                  XFS_SB_VERSION_NUMBITS |
                                  XFS_SB_VERSION_ALIGNBIT |
                                  XFS_SB_VERSION_DALIGNBIT |
                                  XFS_SB_VERSION_SHAREDBIT |
                                  XFS_SB_VERSION_LOGV2BIT |
                                  XFS_SB_VERSION_SECTORBIT |
                                  XFS_SB_VERSION_EXTFLGBIT |
                                  XFS_SB_VERSION_DIRV2BIT);

This generates a sparse warning:

fs/xfs/scrub/agheader.c:168:23: warning: cast truncates bits from constant value (ffff3f8f becomes 3f8f)

This is because '~XFS_SB_VERSION_OKBITS' is considered a 32 bit
constant, even though it's value is always under 16 bits.

This is a kinda silly thing to do, because:

/*
 * Supported feature bit list is just all bits in the versionnum field because
 * we've used them all up and understand them all. Except, of course, for the
 * shared superblock bit, which nobody knows what it does and so is unsupported.
 */
#define XFS_SB_VERSION_OKBITS           \
        ((XFS_SB_VERSION_NUMBITS | XFS_SB_VERSION_ALLFBITS) & \
                ~XFS_SB_VERSION_SHAREDBIT)

#define XFS_SB_VERSION_NUMBITS          0x000f
#define XFS_SB_VERSION_ALLFBITS         0xfff0
#define XFS_SB_VERSION_SHAREDBIT        0x0200


XFS_SB_VERSION_OKBITS has a value of 0xfdff, and so
~XFS_SB_VERSION_OKBITS == XFS_SB_VERSION_SHAREDBIT.  The calculated
mask already sets XFS_SB_VERSION_SHAREDBIT, so starting with
~XFS_SB_VERSION_OKBITS is completely redundant....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/scrub/agheader.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index e954f07679dd..d6a1a9fc63c9 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -165,8 +165,7 @@ xchk_superblock(
 		xchk_block_set_corrupt(sc, bp);
 
 	/* Check sb_versionnum bits that are set at mkfs time. */
-	vernum_mask = cpu_to_be16(~XFS_SB_VERSION_OKBITS |
-				  XFS_SB_VERSION_NUMBITS |
+	vernum_mask = cpu_to_be16(XFS_SB_VERSION_NUMBITS |
 				  XFS_SB_VERSION_ALIGNBIT |
 				  XFS_SB_VERSION_DALIGNBIT |
 				  XFS_SB_VERSION_SHAREDBIT |
-- 
2.43.0

