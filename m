Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C831DD525
	for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2026 08:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.12.53.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776067591; cv=none; b=lTo69VHUPFsmxas9pVpfnPvpAdoucLHFavXck4AJjm8/OA2aDbcq+7TCFTSpy40c/FW9Qe6zEZMnQdf07nZ4US12IfESiVj6MC5UBNZnS5DDM1Qz/8133btI++pcw6UiyM6Gpe2pQmtEV4khnKp2us21p+gUeTgXcTXndBNxPGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776067591; c=relaxed/simple;
	bh=8PbSNYyqEwps5D0muj+U5DN++L04aQJ75R5oS2OZGhk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZyIraDVZ4bBH02ebvnOU+LUTIgzEHZgXOGXsLijxkn73mDI5Nox6daYEYFh9ZlaLydcup/GhYJyzQBOepKW5fGufajUedZ5l+VsjN4+fmEiUVGDYRNAZDRzlUPSGqwaaz1g5FZCtnqYMkCOudQxkUn4bae/lwgK3MHEVXmdy1wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=skZwA7ft; arc=none smtp.client-ip=52.12.53.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="skZwA7ft"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1776067590; x=1807603590;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J2DAONOduTSYkwY92Jc8lqWJ5zFyU4TFKliZO8efFc0=;
  b=skZwA7ftu/zpg2f+S79SUAcaCGDGgZR5I2iUPLRunxTJ92SBxygcJXwN
   rfsCJcpVTzDLP/7Rc0VsdqJmYygtUMoPm9GfqYx4UBNuCmZKgZykz6BpI
   PqiIMxKCcfHxlj4Xe5k2ipzF7FfFykPUm59qGLuGf3Q4fzvE03ahwxsaK
   8IHWD1fgR7SfV78ewp79L7IeRDPr2GgEB9u+EC0jseG4aHoX1tFXVoAo/
   CcvMRClpFuOnwF13UJVyh+OaUA42kAQ4X+wewO0woHbqXtFsUBTdl5xzF
   7yvhCSOyyjxDWkeuzSJiJavRntsficpRRUzx27HKcgxvB5H6pkSp5anRz
   w==;
X-CSE-ConnectionGUID: fHk2/WJ4QKqME+YdVcrYzA==
X-CSE-MsgGUID: AGDXCc6bRA+DY/zYlv32qA==
X-IronPort-AV: E=Sophos;i="6.23,176,1770595200"; 
   d="scan'208";a="17028684"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2026 08:06:27 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:25322]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.25.2:2525] with esmtp (Farcaster)
 id 227ed196-59a2-455c-85bb-f49c421377bc; Mon, 13 Apr 2026 08:06:27 +0000 (UTC)
X-Farcaster-Flow-ID: 227ed196-59a2-455c-85bb-f49c421377bc
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 13 Apr 2026 08:06:27 +0000
Received: from c889f3b07a0a.amazon.com (10.106.82.9) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 13 Apr 2026 08:06:26 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: <syzbot+c27dee924f3271489c82@syzkaller.appspotmail.com>
CC: <linux-xfs@vger.kernel.org>, <syzkaller-bugs@googlegroups.com>, "Yuto
 Ohnuki" <ytohnuki@amazon.com>
Subject: Re: [syzbot] [xfs?] INFO: task hung in xlog_force_lsn (2)
Date: Mon, 13 Apr 2026 09:06:18 +0100
Message-ID: <20260413080617.12857-2-ytohnuki@amazon.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <68e9715b.050a0220.1186a4.000e.GAE@google.com>
References: <68e9715b.050a0220.1186a4.000e.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D044UWB001.ant.amazon.com (10.13.139.171) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

#syz test

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f807f8f4f705..2645052042bf 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -426,6 +426,23 @@ xlog_state_shutdown_callbacks(
        struct xlog_in_core     *iclog;
        LIST_HEAD(cb_list);
 
+       /*
+        * Shutdown waiters on ic_force_wait do not require callback completion.
+        * Once log shutdown has been established, they only need to wake,
+        * observe xlog_is_shutdown(), and abort with -EIO.
+        *
+        * Wake them before processing callbacks to avoid deadlock if callback
+        * processing blocks on a buffer lock and prevents the wakeup from being
+        * reached.
+        *
+        * Keep ic_write_wait wakeups ordered after callback processing so
+        * shutdown callback side effects still complete before teardown progresses.
+        */
+       iclog = log->l_iclog;
+       do {
+               wake_up_all(&iclog->ic_force_wait);
+       } while ((iclog = iclog->ic_next) != log->l_iclog);
+
        iclog = log->l_iclog;
        do {
                if (atomic_read(&iclog->ic_refcnt)) {
@@ -439,7 +456,6 @@ xlog_state_shutdown_callbacks(
 
                spin_lock(&log->l_icloglock);
                wake_up_all(&iclog->ic_write_wait);
-               wake_up_all(&iclog->ic_force_wait);
        } while ((iclog = iclog->ic_next) != log->l_iclog);
 
        wake_up_all(&log->l_flush_wait);
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index edc368938f30..a4244a8c43e1 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1721,7 +1721,7 @@ xlog_cil_push_now(
        ASSERT(push_seq && push_seq <= cil->xc_current_sequence);
 
        /* start on any pending background push to minimise wait time on it */
-       if (!async)
+       if (!async && !xlog_is_shutdown(log))
                flush_workqueue(cil->xc_push_wq);
 
        spin_lock(&cil->xc_push_lock);
-- 
2.50.1



Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



