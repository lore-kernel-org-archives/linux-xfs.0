Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618774;
	b=f3WqmgXoEtdcUPbks5LHR/XLHE7hqS6+TANgQE31TyYtU+RdDqj+mJabarUCA5D1gI+8
	 Fk4npq5mG8vzy/+wTb9LKNP57usdcHa1MvTSEVFjbWH45gPq//ct9NhGOI2+XxJNwkeTp
	 TB7jCXc1aEPqFAIsRilq2rlPwWaLbbvmU8lI6HgEpc+3L9oXWdfS+rROatPOgJUCUEw5P
	 /V0WpI3wSrSapC2rSJ0yyQh0JtuI4JlCF009RzVbEmtQCGxyRmUPn81HYwHnDqDPCMJVr
	 qRipc9LkQY589x3AfRFvawEVYRloivnTIoeeEvT8sELctaA5IsOVv+TQe0dbMCOjZzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618774;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding;
	bh=XC2QUBHmj2G1tj4pefmJXOx7ehHVSaXH3xnNoSU8UE8=;
	b=gWUTov7XxoXBxUcCX5/Mnlm4Z0L7KNBYPVMYBm3RBHjfa4KGRPealcujoFNQGRgr+wxC
	 0poAlHp1EPg3p0IjB82LX3i0yPTefFWyk2QlnsvOKFFN+6EaIgdKBpIJaXZcLQyH1qzgp
	 nkN5hlA3vRmAvySx3HRHDDAGr7EbDoCVSgG3ARWg50zQy4Yd/PoiWllZL1DSOd8fog59D
	 Vg/cSXWc+v2QbaKpud6mSXKnJ33ZkMK50UqWHJExL0jwRM1Gs2y39S6uEDXQUH7gOy63y
	 hsO4pEKdlCGhLUVR4G4X5dG+vREngth/2xCRTX3ioMZu/DFYDh5P1s0iZ8o5nnJu+sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ymfY2YQ0;
	arc=none smtp.remote-ip=74.125.82.43
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD448606A321
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 14:59:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD448606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ymfY2YQ0
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-1b3acec6677so8752015c88.1
        for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 06:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795618773; x=1796223573; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XC2QUBHmj2G1tj4pefmJXOx7ehHVSaXH3xnNoSU8UE8=;
        b=ymfY2YQ0ET6DcvleQzZKnfr0gxRDGfIVDBeZPFbIAWAoWMrBeVVHqlLEnIwU4D91sh
         k57XlYyQq+gC2WgAQkqpIFjeQak+Eh2fLGvxnZt1SCaydy403xFJYKl7N0lKfZetvVeM
         XvtmBrAg80Dys3IlEQrn3FAwypF4VR7xMkQC5LpNHVpX8AKdXUhJtCgNJPDy+ls/jRye
         JYQ/YmyF27wnLaWdtsbMqT0PtbrvDtliUEoc0u/v2zuoICwWIYQe/kH+t2lC8WGoNQaM
         GP+sUu3MULj9JZ6OomdIuncvBk3t+7V95zYpdewfBmK0TFi4I6ghtICBbTGymoQjtj+x
         uxPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795618773; x=1796223573;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XC2QUBHmj2G1tj4pefmJXOx7ehHVSaXH3xnNoSU8UE8=;
        b=n552Ea9+s4JtwmOAjNz9DOFfbDcAyjxWZeb2j5dAssvyQada+iZkw3/eFI/0GEqiCf
         gx7/Jhu1yqjabayOO8NrydWrq7XxocHftfBhEZ0STy2t7sdr3L599ZlP7KxINUZUkmgC
         8VpZUQFcIoAnzK/OV0iL6qQB/R4bm0cxL75fhJWUpZVMPUG6j8zTEujLQe+aLLPallcc
         esHfX/+CxtVQCekzuhBxoGblJh8DFDxNaELNahfj/PrDOGko/bKbKdw8Kbtg3NgqsUFA
         CNdpachiywh2PPt1GYmEkMFfdv4OyAz1nczmCw7aM80xN2WbwfNbDmps0iM8J+Hoq23v
         pcng==
X-Forwarded-Encrypted: i=1; AL+hErExbnEr2F6dINSElUXbHZL72HnPbPr8Et+aJldT9xSTvpjNaEQK4lFvXWo43YI2JzclzzIlzPKserE=@vger.kernel.org
X-Gm-Message-State: APuU4Z8QCIo0hRKfyA+tL0icfe2yF80P+U4ApqTcA8HxGePVCtu+Bv+y
	pLx/SJri+I+ndlrhlgIuYKEMmPR0BtL/vl0IyuaNUMvDQ5M1auC1k6P1NFlSQgZ9
X-Gm-Gg: AZFdTZeBreyCBFJK78hyNk+s3Cl8AgLEB/LWiRoMNugbKLLjJGckFeUDG0OqB5Fyrgk
	1EsskQCAuXKDHH1A7WfMVMx3+cFO14sXEAl7qOAoRfNTr4k1TEBI63J0eg5XQYvYaUNHQJCLCtd
	ojSQoLTeMp2iD7FF/8upBJYHqzo3kCGzUKU8op3YA7J08Xng1/2YfAJzOuC+jlW+bi4uxUVVktf
	jWHCirKXxmZ52BQqShHVVnfYf6Vzza1hP3YEzkoWWdbSX/AGUM5nDvt5IZsWS9tNVOUMtYThCrp
	wDrvFaf3VfuS+zdCEhUBl/4F1ZWx5nyGBWvJ5R/uCMv4grcG8BAoJstrAIeyNvnE0zDBlfFmm4k
	FeGpaE9qrbteUATbRj4J7RPi7EFwtJXNA2w1GAx3lp7J098kJIjHtE6N7OlCQjM13+lqq1AgNoy
	4CcRgTMfj9glnEIgIWevJsRBGNcE32b4NouyCkumropj1H/fDNwtpkESh3tCmSfQ7xIJMvkwz6Y
	dcM8fYb9NP7regInlPhnEwWldSWSulf7Fx0f5LGw3vc+A9QvjIpfO2M5Zz9br9Hg8oOJzQn9Gok
	1nF3ZUQZSI511sPH+Sj9kGcZEn0GRfPB89unyf+lubeNk29dKZScciNJvjD1RFIqPLk=
X-Received: by 2002:a05:693c:8955:10b0:386:9cae:abef with SMTP id 5a478bee46e88-386bf39f8b9mr5885843eec.36.1795618772691;
        Wed, 25 Nov 2026 06:59:32 -0800 (PST)
Received: from d20be28ee783.tail196be.ts.net (vldb.skku.ac.kr. [115.145.173.180])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385677c0c1dsm61060566eec.21.2026.11.25.06.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 06:59:31 -0800 (PST)
From: Kyuwon Cho <kyuwoncho18@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] xfs: reject a hole in a remote xattr value
Date: Wed, 25 Nov 2026 23:59:28 +0900
Message-ID: <179559978502.2875040.12926533524466805036@gmail.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_attr_rmtval_get() maps the blocks of a remote xattr value from the
on-disk value length and only asserts that a mapping is not a hole. The
leaf verifier caps the length at XFS_XATTR_SIZE_MAX but does not check
it against the blocks the value owns, so a larger length makes the read
reach a hole. Without CONFIG_XFS_DEBUG the hole becomes a disk address
past the end of the device:

  xfs_buf_map_verify: daddr 0x258000001a7f0 out of range, EOFS 0x96000
  WARNING: fs/xfs/xfs_buf.c:423 at xfs_find_get_buf+0x160f/0x2350
  Call Trace:
   xfs_buf_read_map (fs/xfs/xfs_buf.c:648)
   xfs_attr_rmtval_get (fs/xfs/libxfs/xfs_attr_remote.c:434)
   xfs_attr3_leaf_getvalue (fs/xfs/libxfs/xfs_attr_leaf.c:2718)

Check for a hole or a delalloc extent at run time and return
-EFSCORRUPTED, as xfs_attr_rmtval_stale() does.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kyuwon Cho <kyuwoncho18@gmail.com>
---
v2:
- Read the start block into a local so that the checks fit in 80
  columns, and post the patch as its own thread (Christoph).
v1: https://lore.kernel.org/linux-xfs/179523678723.1642977.7101755246592074809@gmail.com/
Report: https://lore.kernel.org/linux-xfs/179505710272.3511680.12978324583605871086@gmail.com/

An image with crafted metadata and recomputed CRCs is outside the XFS
threat model, so this is a hardening fix for such an image, not a
security fix.

The issue was found by an LLM-guided test generator that we are
developing as a research prototype. The patch was written with LLM
assistance; we reviewed and tested it. It applies to the xfs for-next
branch. With it, the reproducer from the report no longer triggers the
warning, and XFS reports the corruption instead.

 fs/xfs/libxfs/xfs_attr_remote.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index e6c8dd1a997a..7cd3f2de1a80 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -424,12 +424,16 @@ xfs_attr_rmtval_get(
 		ASSERT(nmap >= 1);
 
 		for (i = 0; (i < nmap) && (valuelen > 0); i++) {
+			xfs_fsblock_t	fsbno = map[i].br_startblock;
 			xfs_daddr_t	dblkno;
 			int		dblkcnt;
 
-			ASSERT((map[i].br_startblock != DELAYSTARTBLOCK) &&
-			       (map[i].br_startblock != HOLESTARTBLOCK));
-			dblkno = XFS_FSB_TO_DADDR(mp, map[i].br_startblock);
+			if (XFS_IS_CORRUPT(mp, fsbno == DELAYSTARTBLOCK) ||
+			    XFS_IS_CORRUPT(mp, fsbno == HOLESTARTBLOCK)) {
+				xfs_bmap_mark_sick(args->dp, XFS_ATTR_FORK);
+				return -EFSCORRUPTED;
+			}
+			dblkno = XFS_FSB_TO_DADDR(mp, fsbno);
 			dblkcnt = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
 			error = xfs_buf_read(mp->m_ddev_targp, dblkno, dblkcnt,
 					0, &bp, &xfs_attr3_rmt_buf_ops);
-- 
2.43.0

