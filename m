Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90DCF186608
	for <linux-xfs@vger.kernel.org>; Thu,  5 Sep 2024 18:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725560520; cv=none; b=qcsLRdB9m+LaQYLAQ55B4kh7xhdbEc2aAiV15eSvBEtPV0ixhSFXewkLNLbYkUjVMwEL8yfosC/G1wmjCCpLnpO8M+6xKPFOX6JeLfMqPxp0f5KmMVK8RBoiA5ELudmOe0u50AVhGQ84PhuZHjYoEwvlecq60RXW43jJYmu7jik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725560520; c=relaxed/simple;
	bh=iG12Hbt+HUHFWRWYme9P4+XMNeqr8y1lnwAGC3q0VIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SaVI02WF3F1Qy6puh6r1rzTSUsQpBzzKazLEhpAulpQizyBKSfVhgHnFihfXdQ5/yZa7uXKjm4PFNpEvV+oL7Juo4twsojtgQw96CPm45lNF6kjHwyjacSHB4wz0ZuHqoV630Mc8gl891CmZQ8VZ8Jtvgrg8IL2+SZjnGfERK0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lXCaAerM; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lXCaAerM"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2068a7c9286so10967405ad.1
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2024 11:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725560518; x=1726165318; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=22WKvDUkm8sNe/9MUbla1NZCO9YRNA415GHi5o/rV6M=;
        b=lXCaAerMzn0ptnF1nTUCOHuT2JAPxOXElzduzGQOraO5M4KLpXLKG1t4aWDScJhkZi
         C4lrYcT12mtfXqsECdiyIWjf1OLD25rCVGrCpqijdXZQrubgNuFNfOxM+sNeFvnd8N5g
         EdPlFPT8Nrgly0gLpzBGh5QWI9CbrAp5YAnp0qxZ6GC/R7alhhxnZDemapC7y2yvYrtP
         sHtnsgBDkDrozMav73ygJzEiYc27A+nwciUj8SMeOgNmAZwdgv2I2oiZSMmPIV7MPoqI
         ROGkjZcGIOOHi+kXdOZZVEsEBeIBYT2hDERohfQzl+AWdND/QsYbYU6hpFBM0rgXdzco
         OBbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725560518; x=1726165318;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=22WKvDUkm8sNe/9MUbla1NZCO9YRNA415GHi5o/rV6M=;
        b=bBZEOoDVfPQOBBrmNiahTOGk8AfCKAW3o0/VCe8FesY8CMyMG1CBaFCr2zQo0r93Wc
         9K9ZHBHEtFLHgzq41u2nfLLotNlTEELKW1hd8dWBn0PeyzwHaRD+Pm8eA+tGYrtOVPYn
         IJLMiRxtGYFEZCszRBuyb6zCYzvIoCUWCbmZHQugUlTO7mjwEq2ifxd2DP9Ie6HhuSKk
         VtjdAUkSFYNQeyyB4oKUtln4zir1grrm28Gw/gYbEgc4cnsqSL1cYWxDYwet0DY7cL4i
         ERl0WgkK4I1Eyt3xgqrGaZWl5XOIvfOLz1cKhRPR2Tc2XNHo/t52+YI00YhhZrJF7JZ1
         bMMw==
X-Gm-Message-State: AOJu0YxtgtuyYKkwwzuZjiKff14vKNbj5WowjyxSBh/o6OJNZyoDmSKr
	niZrSslOLAs5V5KOPbvNB0wvu31waCXOgsGzw5d31xurt6BeX1E/k7MtJC9C
X-Google-Smtp-Source: AGHT+IGdPi7sW3fFj0qbUnWH179tVtVQrQJDxNwE3JUYp5CtkyGyYCER7aoFq3rB2aEFQ0rO/ttlLQ==
X-Received: by 2002:a17:902:dacb:b0:205:5136:b2fb with SMTP id d9443c01a7336-205841a4376mr165882585ad.23.1725560517558;
        Thu, 05 Sep 2024 11:21:57 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2da2:d734:ef56:7ccf])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206aea684f0sm31374395ad.271.2024.09.05.11.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 11:21:57 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 06/26] xfs: prefer free inodes at ENOSPC over chunk allocation
Date: Thu,  5 Sep 2024 11:21:23 -0700
Message-ID: <20240905182144.2691920-7-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
In-Reply-To: <20240905182144.2691920-1-leah.rumancik@gmail.com>
References: <20240905182144.2691920-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit f08f984c63e9980614ae3a0a574b31eaaef284b2 ]

When an XFS filesystem has free inodes in chunks already allocated
on disk, it will still allocate new inode chunks if the target AG
has no free inodes in it. Normally, this is a good idea as it
preserves locality of all the inodes in a given directory.

However, at ENOSPC this can lead to using the last few remaining
free filesystem blocks to allocate a new chunk when there are many,
many free inodes that could be allocated without consuming free
space. This results in speeding up the consumption of the last few
blocks and inode create operations then returning ENOSPC when there
free inodes available because we don't have enough block left in the
filesystem for directory creation reservations to proceed.

Hence when we are near ENOSPC, we should be attempting to preserve
the remaining blocks for directory block allocation rather than
using them for unnecessary inode chunk creation.

This particular behaviour is exposed by xfs/294, when it drives to
ENOSPC on empty file creation whilst there are still thousands of
free inodes available for allocation in other AGs in the filesystem.

Hence, when we are within 1% of ENOSPC, change the inode allocation
behaviour to prefer to use existing free inodes over allocating new
inode chunks, even though it results is poorer locality of the data
set. It is more important for the allocations to be space efficient
near ENOSPC than to have optimal locality for performance, so lets
modify the inode AG selection code to reflect that fact.

This allows generic/294 to not only pass with this allocator rework
patchset, but to increase the number of post-ENOSPC empty inode
allocations to from ~600 to ~9080 before we hit ENOSPC on the
directory create transaction reservation.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 94db50eb706a..120dbec16f5c 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1737,6 +1737,7 @@ xfs_dialloc(
 	struct xfs_perag	*pag;
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
 	bool			ok_alloc = true;
+	bool			low_space = false;
 	int			flags;
 	xfs_ino_t		ino;
 
@@ -1767,6 +1768,20 @@ xfs_dialloc(
 		ok_alloc = false;
 	}
 
+	/*
+	 * If we are near to ENOSPC, we want to prefer allocation from AGs that
+	 * have free inodes in them rather than use up free space allocating new
+	 * inode chunks. Hence we turn off allocation for the first non-blocking
+	 * pass through the AGs if we are near ENOSPC to consume free inodes
+	 * that we can immediately allocate, but then we allow allocation on the
+	 * second pass if we fail to find an AG with free inodes in it.
+	 */
+	if (percpu_counter_read_positive(&mp->m_fdblocks) <
+			mp->m_low_space[XFS_LOWSP_1_PCNT]) {
+		ok_alloc = false;
+		low_space = true;
+	}
+
 	/*
 	 * Loop until we find an allocation group that either has free inodes
 	 * or in which we can allocate some inodes.  Iterate through the
@@ -1795,6 +1810,8 @@ xfs_dialloc(
 				break;
 			}
 			flags = 0;
+			if (low_space)
+				ok_alloc = true;
 		}
 		xfs_perag_put(pag);
 	}
-- 
2.46.0.598.g6f2099f65c-goog

