Received: from pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.245.243.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0073A40DFD5
	for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2026 06:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.245.243.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776061197; cv=none; b=d3R6LeANaNsdyPvBEhnLo8dJV38KIzPbMSr1sgpycbYRVc4ar7stY7CXSPGavKN5i6P8ecoAP49rlheucJy3PLlzMjSSr6SMq8HgNVHwUBREow8xi69XEYpKjy78GWNpm/SXoiBj3UiNKUhOdwYGJJYCtjWgTyAP+1tebgxt3Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776061197; c=relaxed/simple;
	bh=RP2ms2D+i3PsmugYkH+1GEieLy6pITzcRxRbXkH43U8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tR2Y8ImZWq2UIFYhvx8wJBZz3aiHw3xnqCK4k7W0/a4COsDeAXTUATx5ryR796URCqVHa9EoFyth6ybm4tMF3Lj3FhHdtsErCEqxz8C0Vb+iR31kcDARg+OkjrWAYIP1t1PhlHQCmSC/eRt7yAYt79mgPwJU9qQP6oxS3mpE7+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=QeDa0xNi; arc=none smtp.client-ip=44.245.243.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="QeDa0xNi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1776061196; x=1807597196;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i/KsHEqptJFHs8ygzUWL4Dbcx5HL033YZ0+gF4227Tc=;
  b=QeDa0xNiKWQzQAGA3eEm0zGB9xjVAJlQpKtGmtISRsID9M0aoreq+ysF
   QYrOY0W2E8lbpUky0pVNXNO4LeOPG3klymHO7/fCxfShc+VyKb/4Qu0aF
   oGWjcFsY20ohtbrzqZtmnY6zUNqHs4GPIDEXKIbmfNwRSbgvZiT8IUQAz
   XZLV0OtFPDl9MwRltpG8YYrUGB8c1tnTrqn3X/BPjDHFSH7ggtdy9b36i
   Dv78Cj5imeaA1JuOsKy3ymLYUUs1yaTiNnVyRd0xUNT1kBZHvbVyTFuSr
   +q6Yb8H4w2a8uj5B/vCk89w1Qv4fykXTZlk8MgDZv1oe7KwdRSRqxsb6u
   A==;
X-CSE-ConnectionGUID: A7uKj9GIQNufiBlv9+n8+Q==
X-CSE-MsgGUID: IjkWguoKRLyurXOv1n2/7Q==
X-IronPort-AV: E=Sophos;i="6.23,176,1770595200"; 
   d="scan'208";a="16665754"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2026 06:19:52 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.48:22524]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.60.232:2525] with esmtp (Farcaster)
 id 46b5f54b-460f-42a9-8584-b55fb363e01d; Mon, 13 Apr 2026 06:19:51 +0000 (UTC)
X-Farcaster-Flow-ID: 46b5f54b-460f-42a9-8584-b55fb363e01d
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 13 Apr 2026 06:19:50 +0000
Received: from c889f3b07a0a.amazon.com (10.106.82.38) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 13 Apr 2026 06:19:49 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: <syzbot+c27dee924f3271489c82@syzkaller.appspotmail.com>
CC: <linux-xfs@vger.kernel.org>, <syzkaller-bugs@googlegroups.com>, "Yuto
 Ohnuki" <ytohnuki@amazon.com>
Subject: Re: [syzbot] [xfs?] INFO: task hung in xlog_force_lsn (2)
Date: Mon, 13 Apr 2026 07:19:18 +0100
Message-ID: <20260413061917.18327-2-ytohnuki@amazon.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <68e9715b.050a0220.1186a4.000e.GAE@google.com>
References: <68e9715b.050a0220.1186a4.000e.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D040UWA001.ant.amazon.com (10.13.139.22) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

#syz test

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f807f8f4f705..2645052042bf 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -426,6 +426,23 @@ xlog_state_shutdown_callbacks(
 	struct xlog_in_core	*iclog;
 	LIST_HEAD(cb_list);
 
+	/*
+	 * Shutdown waiters on ic_force_wait do not require callback completion.
+	 * Once log shutdown has been established, they only need to wake,
+	 * observe xlog_is_shutdown(), and abort with -EIO.
+	 *
+	 * Wake them before processing callbacks to avoid deadlock if callback
+	 * processing blocks on a buffer lock and prevents the wakeup from being
+	 * reached.
+	 *
+	 * Keep ic_write_wait wakeups ordered after callback processing so
+	 * shutdown callback side effects still complete before teardown progresses.
+	 */
+	iclog = log->l_iclog;
+	do {
+		wake_up_all(&iclog->ic_force_wait);
+	} while ((iclog = iclog->ic_next) != log->l_iclog);
+
 	iclog = log->l_iclog;
 	do {
 		if (atomic_read(&iclog->ic_refcnt)) {
@@ -439,7 +456,6 @@ xlog_state_shutdown_callbacks(
 
 		spin_lock(&log->l_icloglock);
 		wake_up_all(&iclog->ic_write_wait);
-		wake_up_all(&iclog->ic_force_wait);
 	} while ((iclog = iclog->ic_next) != log->l_iclog);
 
 	wake_up_all(&log->l_flush_wait);
-- 
2.50.1




Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



