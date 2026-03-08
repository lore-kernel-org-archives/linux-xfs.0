Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0197033E348;
	Sun,  8 Mar 2026 18:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.42.203.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772994505; cv=none; b=pjpitdxKw7jmxxjNRoLhDt6R3ERgNvUcWjvMSdwQBDQvNwomt7T2LzvG24YtcWGsRILEHNqEObvqci0F5QYLznLMqIJbOol3H/y5OprBSO6epo6NKfMJUcCpeCCFdnzC95jyX+Qce3IiEIqvOWPe8l5VfFRaD9Tb2NJ9Z41qRo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772994505; c=relaxed/simple;
	bh=8PNyLdCufw1wJ+Rudba2u0ehjT9bec5MnnyztAojW1I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XjT2ssZdztQtTQPhWz/Unj6jMLNdngYkETylgnmkoH1dW2AZTMkI88CaoUY/4bWC2kGyJPCoDpD/SU9SizQx1YwuVYAe5kkh/SvMXondks8msAwMyFCtJq7jfUkbrQpf+GyGVUUtwiZLdk+Zxwcw6Z5wbPZnezeTAzjUFMKoF7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=b0QafEy1; arc=none smtp.client-ip=52.42.203.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="b0QafEy1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1772994503; x=1804530503;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uKZECHlQvfktn+FLrbd1kXbKtr6B4SpmpC7n4bWVYv4=;
  b=b0QafEy1eoJYT+g8ne68ZK8i0hK8wD4x8rpUh3cqJ5Z0xn4RURuZ5cyQ
   vJoXZNgOEPPBzPdmqe1qV3QLSHN7o9P+IcrrT2Ansc3cJjtW0E1sGSevb
   DFieV7Bc2A8jcCRd14oAjgjMNzi6mCxvd6qAdcLAHBb8A6Z4JuOKP9l3I
   aglWW7eZ++MaxDeA5zKSKmaKb3/vBGW/dW05pHu9w0l6OinuK8LMqUTNV
   dFGEfGI0LKpk+6YuQsbR6VddI0OeAkDtnIJ7bGCbgaspU8JeDpfNLrX5B
   swPl6oO13KHV4b0NFyLYLSUtVW8RTU9fls+pFIVreYKAxRRV2R3g1ujH5
   w==;
X-CSE-ConnectionGUID: EdYEGu9ERZKcgbKmHZFn1Q==
X-CSE-MsgGUID: LHpB2xutSaWjq4kji7Dqgg==
X-IronPort-AV: E=Sophos;i="6.23,109,1770595200"; 
   d="scan'208";a="14575495"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2026 18:28:21 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:6285]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.4.108:2525] with esmtp (Farcaster)
 id b6cf0bb0-76a1-4bab-a1b3-0ef9b7112b6b; Sun, 8 Mar 2026 18:28:21 +0000 (UTC)
X-Farcaster-Flow-ID: b6cf0bb0-76a1-4bab-a1b3-0ef9b7112b6b
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sun, 8 Mar 2026 18:28:20 +0000
Received: from c889f3b07a0a.amazon.com (10.106.82.18) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sun, 8 Mar 2026 18:28:18 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>
CC: "Darrick J . Wong" <darrick.wong@oracle.com>, Brian Foster
	<bfoster@redhat.com>, <linux-xfs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Yuto Ohnuki <ytohnuki@amazon.com>,
	<syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH v3 1/4] xfs: stop reclaim before pushing AIL during unmount
Date: Sun, 8 Mar 2026 18:28:06 +0000
Message-ID: <20260308182804.33127-7-ytohnuki@amazon.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260308182804.33127-6-ytohnuki@amazon.com>
References: <20260308182804.33127-6-ytohnuki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D036UWB004.ant.amazon.com (10.13.139.170) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The unmount sequence in xfs_unmount_flush_inodes() pushed the AIL while
background reclaim and inodegc are still running. This creates a race
where reclaim can free inodes and their log items while the AIL push is
still referencing them.

Reorder xfs_unmount_flush_inodes() to cancel background reclaim and stop
inodegc before pushing the AIL, so that background reclaim and inodegc
are no longer running while the AIL is pushed.

Reported-by: syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=652af2b3c5569c4ab63c
Fixes: 90c60e164012 ("xfs: xfs_iflush() is no longer necessary")
Cc: <stable@vger.kernel.org> # v5.9
Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
---
 fs/xfs/xfs_mount.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 9c295abd0a0a..786e1fc720e5 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -621,9 +621,9 @@ xfs_unmount_flush_inodes(
 
 	xfs_set_unmounting(mp);
 
-	xfs_ail_push_all_sync(mp->m_ail);
-	xfs_inodegc_stop(mp);
 	cancel_delayed_work_sync(&mp->m_reclaim_work);
+	xfs_inodegc_stop(mp);
+	xfs_ail_push_all_sync(mp->m_ail);
 	xfs_reclaim_inodes(mp);
 	xfs_health_unmount(mp);
 	xfs_healthmon_unmount(mp);
-- 
2.50.1




Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



