Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2E515B96F
	for <linux-xfs@vger.kernel.org>; Wed, 29 May 2024 22:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717023480; cv=none; b=YryAo2SYJAAHT2OgjlkZm8a1Dn/FH1T1vGJFb6sdWwfsmqLJKXXX+Vd57wsDupJ13zgjW+dUcSWk3/Md6o7w3ym3Aa4eetyyTwQPCVeFFBPQGKhMZwz39YltjYvRc6W+Rcf+VaEwHwqy2EejGw1jjTNkmnnzmswxTEi3MSsV8+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717023480; c=relaxed/simple;
	bh=0rE0OntTNMC0RuayBPygNQt9D2uaUIMA0Pp4PDn5Ono=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=s/6cLffzbpXD6JiRuwsP8DYDi5YMZF5HDUwOxK67PMJHsz8rTXnzOfee33M3IhW1qdyKl9/8DhBhglHcA0P6sVy2mlHE0KKiS4TIHD0Rzr0eHTX1UQKD6yOcaR5+F3BKzLgfgkrVYuYwhYtD74m3gMpXdtRBSi1bvyAxHkispYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NkSBZK+w; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NkSBZK+w"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1f47f07acd3so2779575ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2024 15:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717023478; x=1717628278; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EGqXHvCVKzbKMq8BA7OITh+mD89jJo6RiFCtc1rRPBA=;
        b=NkSBZK+wpqlnlZQ1vIy+Ao1UsBoikD5td4GU0zcyjQNL7wWTTs47lez2VQOFV/rIXw
         VpmamFSfn0IdtmCzViP/fdQZ+qZBOzF+P/1TlrKW0Ptdr4nVNhe0dtEunDKWST1qc1JT
         AaB9OF1F4p5LuXvI0/IELSEeRP60vrjg+B/SCvqmU2Qi1nC9OcB8DtZ2+GbB2SCGqUkx
         vm/XksnY3PQ+wEuYql8gt+pZzUnRXFjdjZ6HqFSFFHL1A8XYWpzJLTrweOkXbbKktTYW
         n8O7UO+NaIb3LY3g5l0mDYDT2oLWWarQYxljlH+0E3T+/JSjZnRzJLll3SuKy/q9PZI8
         zo4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717023478; x=1717628278;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EGqXHvCVKzbKMq8BA7OITh+mD89jJo6RiFCtc1rRPBA=;
        b=iZReTuxCHd6h1UPTDZzSRBVeHaUxMAIoVSpiL0kgV/UcpJfgsiIu4SN4tMN0FLrgDj
         WjbTHoz/O553L4PrxSg6ZY769SgFvPb3p++SO0MLHnj12uQwlNGLop0QGDAsuClYMm+u
         N1qWE//QG4AxtlTYUVgbl4fhm28JSqrnvjSL2/DdmO8IkGOPq/wp/eB+dJo9TC30Uh1h
         YGN8e0OB+MTG51PG01Bw+hOWAKDNxsrqY8wgCYxQLhiiU2kRSgDmku7R8y+pO1fNfZhA
         xVHrE1pWRwGjHPfj9iwm9tUSpNfCQvPkv5RmM8g2RbvTfV9XoZMblQlzVYsHmUo5QBjl
         tCcw==
X-Forwarded-Encrypted: i=1; AJvYcCUgXOIH0rVjS70vqIPxquXO4K7uOUg8sePO+UvOeFldErrVEjMk1BOhrTqGMl4+mlemey2uXNqybmEF1mhLbtp6L484sEOlu6iC
X-Gm-Message-State: AOJu0YwwrlTivMz4zRHeuQcWCV17j1k3cd/d2qgHA4Ev/ZbXxALDxmbG
	Xsf+RsW08/YNhyfW8pxiKOvkEIvsDQHldd17fbV0a1hgS9WfCL+n
X-Google-Smtp-Source: AGHT+IFQCUQt87sFHduT1ho378xVyDC8C0VLjUPbtWnRYdzVQ9kORdneaAK5LYulj7F0oCcSpwj/bg==
X-Received: by 2002:a17:903:2385:b0:1f3:375f:3bb8 with SMTP id d9443c01a7336-1f61961f9c2mr5023335ad.41.1717023478261;
        Wed, 29 May 2024 15:57:58 -0700 (PDT)
Received: from localhost.localdomain ([47.238.252.167])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6173a2325sm2902795ad.20.2024.05.29.15.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 May 2024 15:57:58 -0700 (PDT)
From: lei lu <llfamsec@gmail.com>
To: djwong@kernel.org,
	linux-xfs@vger.kernel.org
Cc: chandan.babu@oracle.com,
	lei lu <llfamsec@gmail.com>
Subject: [PATCH] xfs: don't walk off the end of a directory data block
Date: Thu, 30 May 2024 06:57:36 +0800
Message-Id: <20240529225736.21028-1-llfamsec@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds sanity checks for xfs_dir2_data_unused and xfs_dir2_data_entry
to make sure don't stray beyond valid memory region. It just checks start
offset < end without checking end offset < end. So if last entry is
xfs_dir2_data_unused, and is located at the end of ag. We can change
dup->length to dup->length-1 and leave 1 byte of space. In the next
traversal, this space will be considered as dup or dep. We may encounter
an out-of-bound read when accessing the fixed members.

Signed-off-by: lei lu <llfamsec@gmail.com>
---
 fs/xfs/libxfs/xfs_dir2_data.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index dbcf58979a59..08c18e0c1baa 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -178,6 +178,9 @@ __xfs_dir3_data_check(
 		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
 		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
 
+		if (offset + sizeof(*dup) > end)
+			return __this_address;
+
 		/*
 		 * If it's unused, look for the space in the bestfree table.
 		 * If we find it, account for that, else make sure it
@@ -210,6 +213,10 @@ __xfs_dir3_data_check(
 			lastfree = 1;
 			continue;
 		}
+
+		if (offset + sizeof(*dep) > end)
+			return __this_address;
+
 		/*
 		 * It's a real entry.  Validate the fields.
 		 * If this is a block directory then make sure it's
-- 
2.34.1

