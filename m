Received: from pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.26.1.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F1D1F5858;
	Sat, 28 Mar 2026 17:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.26.1.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774719264; cv=none; b=IrQW3IL5KC36U/HGVHHeqQ8HhA5sABU2IAJspe54YpV6vg9FhiLajkdWFNsAJlQ5z/klXL5VBUd6bSOUXbKDPQhmV2C6NUWzbNsixEG/dFc1i2bcYCuAQUN06E4oOFRAoCuH5Hb2YqI3bcAwS+0TgKWwIWO6H6uDzsKspFo/7KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774719264; c=relaxed/simple;
	bh=hbvMcNCM2WFQn7kh9271aUgxYu/cad6ChyGFsdFhXHU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YcYj+UW48+zwc8tmrg1XZ0ryJJ9mj/Fkv4ZWT3BCH+YevaxhAy/Ch2o0B/1crxbB/6L0Caq/THcI4rR3WUctTxhan3xyDiQ/A2bKnQ3PLyAwMDrq0WWa0WgJfUzv/8bXjUYHAhDc66hA28guq++IHu6uuXXUR5M4iKTu8a2D6vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=R30fwPGn; arc=none smtp.client-ip=52.26.1.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="R30fwPGn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1774719263; x=1806255263;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wa6R41/C1TkKbbQEhDEVS/KwkRLCgeeN4OLBr7um0Nc=;
  b=R30fwPGn9PYOkNSQMt+ha0rpWSO3X6N8HmmugPISb7EZBPqIgzFB2HxB
   lxeHChLQAf7+bfNdzlHSQR3cxhscC7lTIDHAxj3CS6vkjsD7rN/mCguGr
   GKW8/cys9W3wcbysCu/QM0d2DT+O20dj+DCG0NeQkVPl3UPuakPYiCX24
   chtMOOWYg4ruNTUA+KCBdwhKh4VX8GMM6kY5CNZHpKJH6imTrn81shVuj
   /Oebo6RlEd2AFTba3lh5wWTT0Lj55gaVz6fAhVh0CnKNfhbc1My0dvrqB
   tZqmjdf8v62fM9UXTeWCtxvMgqsaXKkl10/8OsfHYcbkleY5o8IhJUU+8
   Q==;
X-CSE-ConnectionGUID: 39wYYMZdQUChChwoTGFiNA==
X-CSE-MsgGUID: yhkZBCd2TAKCvkOcLNnDfg==
X-IronPort-AV: E=Sophos;i="6.23,146,1770595200"; 
   d="scan'208";a="16051426"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2026 17:34:20 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.105:13920]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.38.193:2525] with esmtp (Farcaster)
 id bc58132d-e4cd-49d0-80e5-4ca83c1ab4e8; Sat, 28 Mar 2026 17:34:20 +0000 (UTC)
X-Farcaster-Flow-ID: bc58132d-e4cd-49d0-80e5-4ca83c1ab4e8
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sat, 28 Mar 2026 17:34:19 +0000
Received: from c889f3b07a0a.amazon.com (10.106.82.39) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sat, 28 Mar 2026 17:34:18 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: Carlos Maiolino <cem@kernel.org>
CC: Dave Chinner <dchinner@redhat.com>, "Darrick J . Wong"
	<djwong@kernel.org>, <linux-xfs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Yuto Ohnuki <ytohnuki@amazon.com>
Subject: [PATCH 0/2] xfs: fix potential integer overflow in sort comparators
Date: Sat, 28 Mar 2026 17:34:08 +0000
Message-ID: <20260328173407.43057-4-ytohnuki@amazon.com>
X-Mailer: git-send-email 2.50.0
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

Several sort comparators in XFS subtract two uint32_t values and
return the result as int, which can overflow when the difference
exceeds INT_MAX.

Use cmp_int() instead, as was done in commit 362c49098086
("xfs: fix integer overflow in bmap intent sort comparator").

Patch 1 fixes the deferred intent comparators (rmap, extfree, refcount).
Patch 2 fixes the busy extent comparator.

Yuto Ohnuki (2):
  xfs: fix integer overflow in deferred intent sort comparators
  xfs: fix integer overflow in busy extent sort comparator

 fs/xfs/xfs_extent_busy.c   | 4 ++--
 fs/xfs/xfs_extfree_item.c  | 2 +-
 fs/xfs/xfs_refcount_item.c | 2 +-
 fs/xfs/xfs_rmap_item.c     | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

-- 
2.50.1




Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



