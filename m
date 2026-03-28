Received: from pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.26.1.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C43E1F8691;
	Sat, 28 Mar 2026 17:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.26.1.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774719265; cv=none; b=FWIeU1xPWtLBXhlO12KxUuxZlO9K2FWhUf3QkCxF6c68uz7JExAsctrxZN109EynEjmIgKjfKZ5qP6ygHAiUeAYHMeFpz/GabOJdwKtrUmxNqzCkIK/4lCakb2XnTYH7PlabIkwlb6Av27cBK4se/ggSyY5T8k9W1MHQVBZ8Hpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774719265; c=relaxed/simple;
	bh=Cya3pvOCn7n6qnv0jpt8n8J5Ms1ao7hjqshff4u7JGo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n9WVROlAoUsJawiQtq3FT+QVFJ+RIZyJmwsTvDkrGmnWWfo9SK4hGwV8+yUCBcv/cNTim8JkWsw7Bxzbvfef8Ulz16di1TcQCBctNut1BtJG9JvYG88/JAV25md/zdSfyXNaMBl5fC17fsL4rZGzTYfC2w1RQr4lrW5fYK6urfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=qxL3530+; arc=none smtp.client-ip=52.26.1.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="qxL3530+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1774719264; x=1806255264;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uECJeUV+/3/OKy6DIBk1zna7W1ItnF0abIm96r3OmiA=;
  b=qxL3530+a1R85EOCV9U/rINaMpDaIMLLvMLZQjYnPRINBsAkjrExpqdG
   a7WTbgGy6+bGHIjxEft2jpAGOw8cTg2Jg4uK2QbfoEw+HJdJ7ilMlpxqP
   xjDV00TedZTv4Jm5nAcs/M4/B/Xmml09BzrJfVokDPb/6sXoN6qYYLej3
   6khhEEo5RiZOHXfW5B9vyi+V0b6xyzEh/jJ8rIa8WAwHtvgsK2xINGG8+
   SuHyL66clrPz/GAc4Rbwa4lVD+j5QbNlSdaGMPi65jYkSOiG/9cIvfLvb
   VRZ4Y/3n5QiNJZIRfNJPioz41oOnuxrosGyvHJLncAZIt7vyM6ulSKsi9
   Q==;
X-CSE-ConnectionGUID: fjRTNlyiS8GaIO9SEYQljg==
X-CSE-MsgGUID: 7nA0FplISA6sooJXdoOZEg==
X-IronPort-AV: E=Sophos;i="6.23,146,1770595200"; 
   d="scan'208";a="16051438"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2026 17:34:24 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:22822]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.60.23:2525] with esmtp (Farcaster)
 id 7fdeb89b-a50f-461d-a4a4-962a3daee988; Sat, 28 Mar 2026 17:34:23 +0000 (UTC)
X-Farcaster-Flow-ID: 7fdeb89b-a50f-461d-a4a4-962a3daee988
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sat, 28 Mar 2026 17:34:23 +0000
Received: from c889f3b07a0a.amazon.com (10.106.82.39) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sat, 28 Mar 2026 17:34:22 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: Carlos Maiolino <cem@kernel.org>
CC: Dave Chinner <dchinner@redhat.com>, "Darrick J . Wong"
	<djwong@kernel.org>, <linux-xfs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Yuto Ohnuki <ytohnuki@amazon.com>
Subject: [PATCH 1/2] xfs: fix integer overflow in deferred intent sort comparators
Date: Sat, 28 Mar 2026 17:34:09 +0000
Message-ID: <20260328173407.43057-5-ytohnuki@amazon.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260328173407.43057-4-ytohnuki@amazon.com>
References: <20260328173407.43057-4-ytohnuki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D038UWC002.ant.amazon.com (10.13.139.238) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

xfs_extent_free_diff_items(), xfs_refcount_update_diff_items(), and
xfs_rmap_update_diff_items() subtract two uint32_t group numbers
and return the result as int, which can overflow when the difference
exceeds INT_MAX.

Use cmp_int() instead, as was done in commit 362c49098086 ("xfs:
fix integer overflow in bmap intent sort comparator").

Fixes: c13418e8eb37 ("xfs: give xfs_rmap_intent its own perag reference")
Fixes: f6b384631e1e ("xfs: give xfs_extfree_intent its own perag reference")
Fixes: 00e7b3bac1dc ("xfs: give xfs_refcount_intent its own perag reference")
Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
---
 fs/xfs/xfs_extfree_item.c  | 2 +-
 fs/xfs/xfs_refcount_item.c | 2 +-
 fs/xfs/xfs_rmap_item.c     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 749a4eb9793c..2266d56e37dc 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -387,7 +387,7 @@ xfs_extent_free_diff_items(
 	struct xfs_extent_free_item	*ra = xefi_entry(a);
 	struct xfs_extent_free_item	*rb = xefi_entry(b);
 
-	return ra->xefi_group->xg_gno - rb->xefi_group->xg_gno;
+	return cmp_int(ra->xefi_group->xg_gno, rb->xefi_group->xg_gno);
 }
 
 /* Log a free extent to the intent item. */
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 881c3f3a6a24..8bccf89a7766 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -266,7 +266,7 @@ xfs_refcount_update_diff_items(
 	struct xfs_refcount_intent	*ra = ci_entry(a);
 	struct xfs_refcount_intent	*rb = ci_entry(b);
 
-	return ra->ri_group->xg_gno - rb->ri_group->xg_gno;
+	return cmp_int(ra->ri_group->xg_gno, rb->ri_group->xg_gno);
 }
 
 /* Log refcount updates in the intent item. */
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index a39fe08dcd8f..2a3a73a8566d 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -267,7 +267,7 @@ xfs_rmap_update_diff_items(
 	struct xfs_rmap_intent		*ra = ri_entry(a);
 	struct xfs_rmap_intent		*rb = ri_entry(b);
 
-	return ra->ri_group->xg_gno - rb->ri_group->xg_gno;
+	return cmp_int(ra->ri_group->xg_gno, rb->ri_group->xg_gno);
 }
 
 /* Log rmap updates in the intent item. */
-- 
2.50.1




Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



