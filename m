Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC04828373;
	Sat, 26 Apr 2025 13:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745675307; cv=none; b=E4S/VTizPzpTQCyk/HyR7IlQs2WoXCG4l9NPdnEBPjelqncTE443xb2fn9N+nA6tcU1cY718zMbtXiZYos1u4P0GsOfpV/O38joOzymIco5bYk22t89/a/waO7PfuCyAJFSVgJwobaCh+xiZr2lwxGe+JL8TXYF+bGeiVNaz6AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745675307; c=relaxed/simple;
	bh=nrZSCfPbnk5nx5eNvJ+bauiybIFi8fpp8A71FO4JFzg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SsA6Eb9DJvoR6p6yZsXVFxlt///Q4ESQT4mUdgrUzzEWizJTirWSgGCKgF+giUVHXgtJbVz0gcuguLvuONc35IZ03bukRA6kOXcvOAnYpexoDE13mSX/Mg8AOWre/yZzHy4wQUHlVBrJSMrxatUZa272kjG0Mzm7DmZb0yAXYW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=K+bpHxuT; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="K+bpHxuT"
Received: from fedora.intra.ispras.ru (unknown [10.10.165.5])
	by mail.ispras.ru (Postfix) with ESMTPSA id 63D7B40737DD;
	Sat, 26 Apr 2025 13:48:22 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 63D7B40737DD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1745675302;
	bh=IUpEVYdhOlEyZsxKVHyuvQMfByNjhpVm12RTwE2N+Zk=;
	h=From:To:Cc:Subject:Date:From;
	b=K+bpHxuTfxmPSkqnNRFn+jcirmWbEDHJg5vwzMyvfIdHQWtVLXTMenJSmmA3y9DrG
	 LOohz1Lqz3JwwFHYFw8/UTZL4vMau8JdpJQRYieLrhsNCL5kRq7RNj7VqiZaVb1rv3
	 cvP5q3XxNrDPBS8uWkbJGgvRkBdVAjcQsYRs2cHA=
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Fedor Pchelkin <pchelkin@ispras.ru>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Alexey Nepomnyashih <sdl@nppct.ru>,
	stable@vger.kernel.org
Subject: [PATCH] xfs: fix diff_two_keys calculation for cnt btree
Date: Sat, 26 Apr 2025 16:42:31 +0300
Message-ID: <20250426134232.128864-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently the difference is computed on 32-bit unsigned values although
eventually it is stored in a variable of int64_t type. This gives awkward
results, e.g. when the diff _should_ be negative, it is represented as
some large positive int64_t value.

Perform the calculations directly in int64_t as all other diff_two_keys
routines actually do.

Found by Linux Verification Center (linuxtesting.org) with Svace static
analysis tool.

Fixes: 08438b1e386b ("xfs: plumb in needed functions for range querying of the freespace btrees")
Cc: stable@vger.kernel.org
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
 fs/xfs/libxfs/xfs_alloc_btree.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index a4ac37ba5d51..b3c54ae90e25 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -238,13 +238,13 @@ xfs_cntbt_diff_two_keys(
 	ASSERT(!mask || (mask->alloc.ar_blockcount &&
 			 mask->alloc.ar_startblock));
 
-	diff =  be32_to_cpu(k1->alloc.ar_blockcount) -
-		be32_to_cpu(k2->alloc.ar_blockcount);
+	diff = (int64_t)be32_to_cpu(k1->alloc.ar_blockcount) -
+			be32_to_cpu(k2->alloc.ar_blockcount);
 	if (diff)
 		return diff;
 
-	return  be32_to_cpu(k1->alloc.ar_startblock) -
-		be32_to_cpu(k2->alloc.ar_startblock);
+	return (int64_t)be32_to_cpu(k1->alloc.ar_startblock) -
+			be32_to_cpu(k2->alloc.ar_startblock);
 }
 
 static xfs_failaddr_t
-- 
2.49.0

