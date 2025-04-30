Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0141334545
	for <linux-xfs@vger.kernel.org>; Wed, 30 Apr 2025 23:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746055650; cv=none; b=rEsQ+07TDcTjI+3vuDDRjzxog5le07P2Fn7yP6vEOCXho/hSf4RuTcftA7vldJyLoKUDQ8BLzBMfrt3ZDVWehB8/p/7soiqfFGJe21zlcqAdI/94bo95Mq2bA/JeKNF3pJLSeCpV8aATToFIbmT4fhWocKeBrAKHDjBwr7FzvSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746055650; c=relaxed/simple;
	bh=mCoRj9VBhKhhlopfxix2pWlo1q4pCEedYsEw3EL8hJo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=WVvV7hTLvBBolo8jdDKC3nyCksVsQbYXkyuHJgizh6oWLIysC5oIp5Q+pEEAIcgLd8aTVjl07dOh8iRiwQM88rtKU2EtxsvVqTjZ7pXaK3t5eBzkintqq4GnpLZw73gWEPfSQ+mkOqTqCSrUkKdsVDyXEQolEqtpUoefPYtqZfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=nPF0Ux52; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="nPF0Ux52"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-227d6b530d8so4149325ad.3
        for <linux-xfs@vger.kernel.org>; Wed, 30 Apr 2025 16:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1746055648; x=1746660448; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=EM66D8sop9aR7EhodZMJFi3nGQoFLe0oKk49sQRM+Co=;
        b=nPF0Ux52FlMxOOX0n5mdNwlWurx/u853MP0P0IayfwlejYEHmV35jGuFAmlvBVyXz3
         tLnR7X4Ivfrrf+/zJsnrWzot/cFEt+4k5xjEW6mQnd6QCsy6Gbv9d9AuRbjz4u68Wi19
         Gi1Ri/LbG9Hnw0O+y33JzYuwZ+Z6kRzX3jNdBPmg/29KzhsT3wkIUgSiJYOkPxi+f/Mf
         2MIwYBN9U3FGE5u8h8WYF5HlRhiAbi8dYJEjGH2PlbF9ewv5D2kkRbyH524BaU6PcJFv
         otlXvOL/Br1KARPia5giNhGB7wJNcyZOsPMY7bVtLip+Szt3wyxq3hk2X9QkLk5dZokS
         z45A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746055648; x=1746660448;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EM66D8sop9aR7EhodZMJFi3nGQoFLe0oKk49sQRM+Co=;
        b=l1LWaqpBDIIaTBlqIO73cKXg1NV5kMtQe0xpRSu22XyEec7jmjhXQwIx0fNP/mjTkP
         gZKLzktHg4Thkd5QqU2MHLAi1kZbDNUVPoWBDFZ4jhBTw0z+e1SnZSJezkeiqWPWawzL
         yRJS7t5ZI/hQSJpKkObMXctjD9HOaW4ApXyaUihyeviUCMFoTvharw7Q/Si8g2WUXVT+
         Z2L9a8GMrKrHUSYNDumawn3abpewv7c3zpn8yKG277UXpjv2rwqq3+8NyaHB/I54IUaQ
         na+LrhviCJOUcwBdtdXg/nHp7KL578/KMLH96taawmasQyAq9gjrQx8oxOxuROyJ/5Se
         cFNg==
X-Gm-Message-State: AOJu0YxFqLYcNQlg/3UmjAO4MB2cPzE2VeANpqxcpHncYO2A6zKc5yOi
	Xisgm93UhHjT9QtBgloJcpxBud6sfJlYEJ+MZKev1spoZKOMRdIWAcwqzDboVR3SqJc1mPQRdgJ
	4
X-Gm-Gg: ASbGncusp5E1EFc4XTVjAYoxeBaIWk3jxqAEp0EHFwTZYSxb2vPehp48dfJmTtj2rJi
	+HfABZPz8KlL+dgd//o4bGOFNrm0ZNJx4XzaHpeFPuqYIxY4RObJECQGxSt705KC1RbHZZAA2tv
	5jgyLmT4E6xAW1cMwgvb7y+aUqjyfsplA8LUAkvKYIoplFxwS20d/V3CZmWkoDYhptSYOMR55Ul
	PQPQrRgqeznlYNkx5VkPn/ZemKWhuwCLVf0t99zlSxjnCrAn7o6848KyvUHueLOh+TUPYlTvc9i
	tTcH5+i8t5REVC35u+kREXr010fB8lRh0MqrDdY0QvE2tzmDUYTWp0nZCfY3cGZiaXYFMJuKFwH
	9VF8OWRMZlbFg
X-Google-Smtp-Source: AGHT+IHgRI6JJDmFCYVxy11raVLlQvp0qycgqZqJd/x6QJ72lyR4R86aUzF00auzA3Z3Zl0uWZ3PvQ==
X-Received: by 2002:a17:903:1a8d:b0:224:76f:9e4a with SMTP id d9443c01a7336-22e08428a84mr6361405ad.14.1746055648153;
        Wed, 30 Apr 2025 16:27:28 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-60-96.pa.nsw.optusnet.com.au. [49.181.60.96])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db521664asm128233775ad.220.2025.04.30.16.27.27
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 16:27:27 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.98.2)
	(envelope-from <dave@fromorbit.com>)
	id 1uAGpo-0000000FPs4-1mSA
	for linux-xfs@vger.kernel.org;
	Thu, 01 May 2025 09:27:24 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.98)
	(envelope-from <dave@devoid.disaster.area>)
	id 1uAGpo-00000001zaz-1Si5
	for linux-xfs@vger.kernel.org;
	Thu, 01 May 2025 09:27:24 +1000
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: don't assume perags are initialised when trimming AGs
Date: Thu,  1 May 2025 09:27:24 +1000
Message-ID: <20250430232724.475092-1-david@fromorbit.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

When running fstrim immediately after mounting a V4 filesystem,
the fstrim fails to trim all the free space in the filesystem. It
only trims the first extent in the by-size free space tree in each
AG and then returns. If a second fstrim is then run, it runs
correctly and the entire free space in the filesystem is iterated
and discarded correctly.

The problem lies in the setup of the trim cursor - it assumes that
pag->pagf_longest is valid without either reading the AGF first or
checking if xfs_perag_initialised_agf(pag) is true or not.

As a result, when a filesystem is mounted without reading the AGF
(e.g. a clean mount on a v4 filesystem) and the first operation is a
fstrim call, pag->pagf_longest is zero and so the free extent search
starts at the wrong end of the by-size btree and exits after
discarding the first record in the tree.

Fix this by deferring the initialisation of tcur->count to after
we have locked the AGF and guaranteed that the perag is properly
initialised. We trigger this on tcur->count == 0 after locking the
AGF, as this will only occur on the first call to
xfs_trim_gather_extents() for each AG. If we need to iterate,
tcur->count will be set to the length of the record we need to
restart at, so we can use this to ensure we only sample a valid
pag->pagf_longest value for the iteration.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_discard.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index c1a306268ae4..94d0873bcd62 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -167,6 +167,14 @@ xfs_discard_extents(
 	return error;
 }
 
+/*
+ * Care must be taken setting up the trim cursor as the perags may not have been
+ * initialised when the cursor is initialised. e.g. a clean mount which hasn't
+ * read in AGFs and the first operation run on the mounted fs is a trim. This
+ * can result in perag fields that aren't initialised until
+ * xfs_trim_gather_extents() calls xfs_alloc_read_agf() to lock down the AG for
+ * the free space search.
+ */
 struct xfs_trim_cur {
 	xfs_agblock_t	start;
 	xfs_extlen_t	count;
@@ -204,6 +212,14 @@ xfs_trim_gather_extents(
 	if (error)
 		goto out_trans_cancel;
 
+	/*
+	 * First time through tcur->count will not have been initialised as
+	 * pag->pagf_longest is not guaranteed to be valid before we read
+	 * the AGF buffer above.
+	 */
+	if (!tcur->count)
+		tcur->count = pag->pagf_longest;
+
 	if (tcur->by_bno) {
 		/* sub-AG discard request always starts at tcur->start */
 		cur = xfs_bnobt_init_cursor(mp, tp, agbp, pag);
@@ -350,7 +366,6 @@ xfs_trim_perag_extents(
 {
 	struct xfs_trim_cur	tcur = {
 		.start		= start,
-		.count		= pag->pagf_longest,
 		.end		= end,
 		.minlen		= minlen,
 	};
-- 
2.45.2

