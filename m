Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF2C1AD3F6;
	Tue, 24 Sep 2024 18:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727203147; cv=none; b=L0Sy2W0fJmke62o3ZlCqhIoxuj5yras5X8nRw5+nDfrXUrhpTsTII2YV2niYhqmf3EJyOdjbAsSqe/SIizwBcOeEtQ5RdS9sFQH08x+zQAMoEQmm24N64CDnpw1gWPdrBvCbm2ZgHJxyO0Un/h8KP0vL7bxtrpCWx3sZuEv0+cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727203147; c=relaxed/simple;
	bh=am+Y4T1NQl/tlZCwmeXR0o5BHsCaaofEOZ6qz64MIOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oXfr2gBxzL3ZyoaMMKegpbdp/eLuJjh5UxJt8od3D9UzBPzZWZgeNcfi72d2JyiLtNlUU4LX9TG1vUPVpCc9YVkr6YWDX25rMoG81mcrtGuiAJki9rY6vrlTV+mDGv3J2DCG669Nj6a8CRTdPP9FAnvKnjzVUKm/3nkF4sAeEWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aUvObVI+; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aUvObVI+"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2059112f0a7so52892805ad.3;
        Tue, 24 Sep 2024 11:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727203145; x=1727807945; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q843SYhjoS7VY8SW3D2zo4cn2xBljLaNd63UP9CYYI4=;
        b=aUvObVI+01Jzdegb2ywu5lYPNanes9RH5bA979PExz75cgrpyFh4DyOSe7cJDER/rT
         RT45XRN/OP0snFDuqfvnyMP2o4rT+0i98lNTjupkyFuB6bW/iTkxvWCENXi7yKSlOgVG
         z6Fbje3tKtphdO8ScezfHDwENJ9Q+RRCBE0+VYwVgUJoacfFm01N6tA7BUFP3fX5nkVO
         poSeYPQcKVYn2vGh2hMLnZOAOsmIQFH0UBoq3oJ0iHgAA5iwwh3NYE2i79blBh6b7UG8
         MpBfRcLqR1J/3LJQiCPAeRz0LGbnx2F/Ix8Ub+XRR9x6CQopfE/xKkjsvj/V9ASjBJDw
         It7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727203145; x=1727807945;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q843SYhjoS7VY8SW3D2zo4cn2xBljLaNd63UP9CYYI4=;
        b=Wqpgz8cUboqqNPx1kPFV9mZ3Wh+/IJBxeJ8bU1vwstypQQQZKB7tWo8QNT2nbWPhxf
         88kpYs2uJg2uDcoJ7ZljWQ12xmDpDtTV/YhhUZg/qTMzjVNllAmmDgzk+NdK2/6Wb8Dh
         kwnn4O/LaqDOZoLcY9A8/WUb9a+huG2itRN69rFqSuWKYh1T7zCLqv9eDcm7uox+ASK9
         he86xeHBwvaSbyCvfLm1TtqZwSCWe3ZWF9VDJpAQ++IHVgHkkHwk7UgJpmp51VGn2oNb
         QWbyXwwSFtNzWFj7IyUSzzv98fyC9SBb1y0qvguSkIHouLtvbIg2QgJzpTRh4m/FvcUk
         5iYw==
X-Gm-Message-State: AOJu0YxlAmTkrF3OuhcMi+QxhOavYz/Y8dwvIG7tqGqUjxnzI4WIolsA
	F8BRd+dkKA71fjQPIzUwiqlhWgpCRT1Db1MHEO8gDC7yKsKpltOpe+s7Vhqk
X-Google-Smtp-Source: AGHT+IGJp5XbQG4YLviq+JW6fMywZOA3Vf6miLROyjqvTb70vBxmvGpub9SViLki3uyR6bvecgscmQ==
X-Received: by 2002:a17:90a:8a14:b0:2d3:b748:96dd with SMTP id 98e67ed59e1d1-2e06afb8f02mr83366a91.25.1727203145525;
        Tue, 24 Sep 2024 11:39:05 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:3987:6b77:4621:58ca])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dd6ef93b2fsm11644349a91.49.2024.09.24.11.39.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 11:39:05 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	cem@kernel.org,
	catherine.hoang@oracle.com,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 06/26] xfs: prefer free inodes at ENOSPC over chunk allocation
Date: Tue, 24 Sep 2024 11:38:31 -0700
Message-ID: <20240924183851.1901667-7-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.792.g87dc391469-goog
In-Reply-To: <20240924183851.1901667-1-leah.rumancik@gmail.com>
References: <20240924183851.1901667-1-leah.rumancik@gmail.com>
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
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
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
2.46.0.792.g87dc391469-goog

