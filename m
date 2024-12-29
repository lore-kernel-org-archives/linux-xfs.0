Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD6B15B54A
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479546; cv=none; b=I3M+ow1XEk5s7qnz3AKkJH5hYp+9otv4WLAcBMPt5TQImQJUdtLDr3bXFLRXGLNK6jODIT6sczaHLYCpfIMfoi4YRgXMajlrRpEcv4sZFllMbzaNxQNGXX51zZxsAd1+m9Ipd3BdvNWNrpLsUajuOqxOBy72SJtGmjqVvRvq91E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479546; c=relaxed/simple;
	bh=i2Ne3GImbukVLxYXpQOeimEOzXEXSiKn9qwowxUDQDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zmi/kWegQaEHEuhLQA3qp3yG5TbziJDdUTMRZWYmaXZa49l6lnJtfhh2ztzrvkhdegpV4js8VNGYTVeYeXnlvNIXVApKWmqu9uGlUMCVZ/XmRvoxqPUr0QYxQhVS6jcflp+DAunpuajUb8++Xli+sSYTZFe9ViR234hnqTprEr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GnK7/BCH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GnK7/BCH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U8AjF3VizkOa7g83PnPMwpedj+JUQeIKPqJB6UYbXeM=;
	b=GnK7/BCHIReDIfW7/HWJ8aZSLcN+v26lWmHc0fM/4EUJnkFuEaY4r0G/ajGAk9NbuU8i0T
	+4rY2puQWar0SqcJx+KULkkYksoKRUI+igPW0k7H9VC+pQKsTYH47U+PHqvWJhqsK6dq+H
	uxhi0tnWfL1RfHT25XEJNxWYRtGVDR8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-284-UT0-oJhgMl28AhUnhOSezQ-1; Sun, 29 Dec 2024 08:39:03 -0500
X-MC-Unique: UT0-oJhgMl28AhUnhOSezQ-1
X-Mimecast-MFC-AGG-ID: UT0-oJhgMl28AhUnhOSezQ
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-385dcadffebso4267210f8f.0
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:39:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479541; x=1736084341;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U8AjF3VizkOa7g83PnPMwpedj+JUQeIKPqJB6UYbXeM=;
        b=DLAIW8SqbquuSpWgkxp1c3UtXRY1Hb4rqZsVfqryVmckqkMSK8ew18GRCfdzLtpNco
         n2VkDjaCJVvThAaKpfArbbFOBr9Z6pAazNsgWaYxbGLoEwvPF6yuFXLbqV+Cg5moanDX
         0EExW3ElBAuPraRZ/nusIaaQVBQBH0fZ9xmFMZ11pWzXRri721S3n4rM0rYMNbO7Ot+k
         86rxBoz3G6+jmhhF7UsmcUPFaTZzVngantO1QMkly5dZjF/naCiEKXz2EW6a2rJ7IsGh
         2pYK0YhoCExLldBQYdnwpXOzrgkK57sizwupSVMwKYNqrNvOEukkgIkl0/C2RocntTWF
         AuBw==
X-Gm-Message-State: AOJu0YyGFbqe6DxhEASMxgzHKPCS3tZ47pAlaZwHgeJf+KdM0wDMvCJW
	MNIyszRZe5DglbfXLxN+RizzuBr2cBBedO+1i+4MVdG4KQUpCvBajiTt88EMMXdTFKSZGrD+TTy
	NokNNsS/g0jlUf9msLvpKo3ll09s3c4Cz3HIKH/FBYU+9vBb2arrdh0+Gg5Rj3HJKyJqa+1YVqj
	qhMOjnVM1xo+SfNciAQMJgknD0DacpDxMzmiyyZtmZ
X-Gm-Gg: ASbGnctWGa5ZsVS78Ai2UXwLA9gKtEFNlzxIZcpEY7Zji4jAusxE3CNblC4jZStO0sb
	H92xgqY/AnI8wZEn/yPL3Lx5eRtLU9sWzoU++WrBNNGKSUZmVJpyxbI5UwOA32A5JciN13HGYEW
	T+4p34CTXx2ouQwYK9bM5SUlIr9bgemsqZttcmUafgbhplIDLPzdrgMaIYhCFZ1OpMOAwJh/fTr
	ZFT+pmzr/K1qU2l1HFcbUiorQr0tr7dKO4S/xLO85M53SpRQyIESaQxXGE0/JYaLL91bnky57oU
	PpO8qlfNJ5jA6NI=
X-Received: by 2002:a5d:47a5:0:b0:385:f677:8594 with SMTP id ffacd0b85a97d-38a223f5da3mr24374398f8f.43.1735479541203;
        Sun, 29 Dec 2024 05:39:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGEb14NaaaQIpD9FA7qu1HWdNEg2ciH7s34nDpUfvIw5qCEs7dDm9OKKwRCPjnq2qdjywPyfg==
X-Received: by 2002:a5d:47a5:0:b0:385:f677:8594 with SMTP id ffacd0b85a97d-38a223f5da3mr24374383f8f.43.1735479540895;
        Sun, 29 Dec 2024 05:39:00 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c8474c2sm27093127f8f.55.2024.12.29.05.38.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:38:59 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH 08/14] xfs: introduce workqueue for post read processing
Date: Sun, 29 Dec 2024 14:38:30 +0100
Message-ID: <20241229133836.1194272-9-aalbersh@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241229133836.1194272-1-aalbersh@kernel.org>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
 <20241229133836.1194272-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With directly mapped attribute data we need to verify that attribute
data corresponds to the CRC stored in da tree. This need to be done
at IO completion.

Add workqueue for read path work.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_mount.h | 1 +
 fs/xfs/xfs_super.c | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index db9dade7d22a..d772d908ba3c 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -136,6 +136,7 @@ typedef struct xfs_mount {
 	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
 	struct workqueue_struct *m_buf_workqueue;
 	struct workqueue_struct	*m_unwritten_workqueue;
+	struct workqueue_struct	*m_postread_workqueue;
 	struct workqueue_struct	*m_reclaim_workqueue;
 	struct workqueue_struct	*m_sync_workqueue;
 	struct workqueue_struct *m_blockgc_wq;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 394fdf3bb535..4ab93adaab0c 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -559,6 +559,12 @@ xfs_init_mount_workqueues(
 	if (!mp->m_unwritten_workqueue)
 		goto out_destroy_buf;
 
+	mp->m_postread_workqueue = alloc_workqueue("xfs-pread/%s",
+			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM),
+			0, mp->m_super->s_id);
+	if (!mp->m_postread_workqueue)
+		goto out_destroy_postread;
+
 	mp->m_reclaim_workqueue = alloc_workqueue("xfs-reclaim/%s",
 			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM),
 			0, mp->m_super->s_id);
@@ -592,6 +598,8 @@ xfs_init_mount_workqueues(
 	destroy_workqueue(mp->m_reclaim_workqueue);
 out_destroy_unwritten:
 	destroy_workqueue(mp->m_unwritten_workqueue);
+out_destroy_postread:
+	destroy_workqueue(mp->m_postread_workqueue);
 out_destroy_buf:
 	destroy_workqueue(mp->m_buf_workqueue);
 out:
@@ -607,6 +615,7 @@ xfs_destroy_mount_workqueues(
 	destroy_workqueue(mp->m_inodegc_wq);
 	destroy_workqueue(mp->m_reclaim_workqueue);
 	destroy_workqueue(mp->m_unwritten_workqueue);
+	destroy_workqueue(mp->m_postread_workqueue);
 	destroy_workqueue(mp->m_buf_workqueue);
 }
 
-- 
2.47.0

