Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C9E27FD4B
	for <linux-xfs@vger.kernel.org>; Thu, 18 Jun 2026 14:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781793708; cv=none; b=GZtekEyzoWxLLHN3jDvjcfPaxLjX+hJF/e1gjSJvMXHmJYFvD/MoUUqYfxGO16kM7IvEc1znfBwz53Z/RArh7c5Aw/xsCRTbCPezLjjS4afU0DTGSeeGLPvm5STL0KuY5rWnCLpXmh418fDh3cPCcDuIXEA1fcL+az4Yacbs9y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781793708; c=relaxed/simple;
	bh=/lZMMQ6vAe8RJdh9C/6jeLxyly6OgUf1sJLzBGLGGzU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mvCz6rqbY3P2dqU4e82EXN0LMoXHHm37M4pTwRHn/eV7I/EdqtmCJ3iQQRHDmgib03HGxIS83EebRJoSPxoi6oa87RcenKNS9Cdr21wKyKMW5j9INCfWrUsy5vlrVKJKzSnYGARk6YyD6dCRc5XnFLk+R5TpcobT2jN+lrsPYnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EUQAl77C; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=t/ta+GHf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EUQAl77C";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="t/ta+GHf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781793706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=W6niK79Uh7JrcT6GCfrgjeLqhMhhcMy+nrLNdKDBkmE=;
	b=EUQAl77CY8UjCgu2gZHnMXSY3Do/KQ9YP09kw8A+r5d1s27sPHxQk45h5Q65F1VNsgkMxv
	NoTYrH4Kt7tgn35a0zWMIDyTJ2bXl5NF81krLpJlD3n2x6AS8FsMzJqmV3W7CQc3Hj+2jQ
	9/1uiDUqEWBv5ShsfHpTMn9ccDPXdug=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-86-jj7XUqEbNd2vF24FB2EgPg-1; Thu, 18 Jun 2026 10:41:45 -0400
X-MC-Unique: jj7XUqEbNd2vF24FB2EgPg-1
X-Mimecast-MFC-AGG-ID: jj7XUqEbNd2vF24FB2EgPg_1781793704
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2bf11699875so14166635ad.1
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jun 2026 07:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1781793704; x=1782398504; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=W6niK79Uh7JrcT6GCfrgjeLqhMhhcMy+nrLNdKDBkmE=;
        b=t/ta+GHfveDrRLiqo02racMxiSYDQJ6/BtkSsJWUXYDY4O0eo9ynMAEeUDuAbu6See
         PMWPWujQhpZwgwgn1oajTLL8PI0MHlW6ucG8fleaOeUYBUAA4b7feDWbhjnD03ci9gNf
         qyXGFSuRsD+QP3zrQG87jFxeJBXrKVqud/ckwj6/NoQJ7/PWJsKhTLYHJqcIJW6pS0w7
         f61dN+2zxdyuqsRSlZ1HAxUozGNC26nZ/eCzMqeu9yM56VtBgo0uReJoVXA5HqndlW6q
         BPUULglbdxDCMnQmTO45S9eRuK/SX027j1Gs+ymPujfzXozNlBewj/BreSwM84fX+X9C
         B8vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781793704; x=1782398504;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W6niK79Uh7JrcT6GCfrgjeLqhMhhcMy+nrLNdKDBkmE=;
        b=S2eXttspJmjKweekyEzwvxAq6hJSkUMktTm63RzlgXR1fAYpyZGPMXxTyB1C0+MOPz
         VH4kkf0BrJBaEoSv7rRT3RRPm3OsHzablyVHpy7RqZtE07hJh0mro/G+4pHG2BBHKoap
         8viHUbw9GqOacJlN3yov2bRy5ym+UfC9St8FkPd1yKya4WE1LksmMPXKzsHnRrsQJVfl
         gIIVPs5TkMSgodhAjvTRtS3/O1uN07gss3LWZkmhaO5R7HcvjdDbnytnSYQezji9jQL7
         43gZsC8xFgi2abkAX9ZMEnSAwtA1ODxvlfzIU+yQpYJzzSzgGTg2n57nNyzEbqm7IJrD
         oJFg==
X-Gm-Message-State: AOJu0Yzwi+lj91caGYEBOKp3KOueMZSmdVDVfGcf4WrAOjXVZ12qa3mM
	LzEbMsCSUkr3HB8cdE+BAi12U1idSHHSQtv9nMhRmAhDAbZkusoV5v+E2i4y6dRYKreNj7Syj3U
	sAPaYb6wNqOjQkHEzWQjAjKHHQIXpc5kFVTkLIlWumvPWl+sWQFFQ6aBeqmye0pABlOxUgkI0e2
	SXhqk2XchjZ5vKhnbAS7W41FPNAeR5eF/Wq7rHWTByTkSf9w==
X-Gm-Gg: AfdE7cn2fiIqElZGcVnmLuMVsDZmYRdwjYiCZ4SdvnPSr1gVP3nsJLKYgC/JnT0dOoF
	PiIAh5FaiCmfTABLx3UkHrHpLS+nGqNGSnz7sz0eY6wHAmeO47bhRnOwyFbmeL6Zy9s/Y/ZMs77
	z5UMIZZCpeNKOAoQ3Nn6fRb17YmHW1sfktPmmAKKuREsq7lCquc9lDG/s7axn+eUe1sbICxQbT7
	ysXFFU4mCNdmG2aDKT2azYj+jn3T5BebOBRgqqgB+prTHLGjrxZ9rSj/OQOnQ3xOOBzT1c1D80i
	yDWkuLBqQTl9mxJsTvZOjpNzMe6D4xLjzXM39V74xcokP+pKV2Eu5WBCNon5ksFglLR0nkfxbLD
	fR8n8dhoriJu/kl6EhmfokhSl7keqGBpWYqg4/shosC6aVztxKA==
X-Received: by 2002:a17:902:da86:b0:2c1:88a1:9839 with SMTP id d9443c01a7336-2c6de510376mr39102735ad.11.1781793703994;
        Thu, 18 Jun 2026 07:41:43 -0700 (PDT)
X-Received: by 2002:a17:902:da86:b0:2c1:88a1:9839 with SMTP id d9443c01a7336-2c6de510376mr39102135ad.11.1781793703196;
        Thu, 18 Jun 2026 07:41:43 -0700 (PDT)
Received: from msinguru-thinkpadp1gen4i.bengluru.csb ([2401:4900:883b:a538:bbed:f34c:15f2:e487])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c433558449sm210367665ad.78.2026.06.18.07.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 07:41:42 -0700 (PDT)
From: Manognya Singuru <msinguru@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@redhat.com,
	Manognya Singuru <msinguru@redhat.com>
Subject: [PATCH] mkfs: fix filesystem and log size units
Date: Thu, 18 Jun 2026 20:11:11 +0530
Message-ID: <20260618144111.178311-1-msinguru@redhat.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The actual thresholds enforced by mkfs are in MiB and GiB but the
error messages and documentation report the limits as MB and GB.

Update the filesystem and log size threshold messages, comments,
and man page to use MiB and GiB.

Signed-off-by: Manognya Singuru <msinguru@redhat.com>
---
 man/man8/mkfs.xfs.8.in |  6 +++---
 mkfs/xfs_mkfs.c        | 14 +++++++-------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index fbafc5c7..c4dee4fe 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -463,7 +463,7 @@ is required if
 is given. Otherwise, it is only needed if the filesystem should occupy
 less space than the size of the special file.
 
-The data section must be at least 300MB in size.
+The data section must be at least 300MiB in size.
 .TP
 .BI sunit= value
 This is used to specify the stripe unit for a RAID device or a
@@ -805,8 +805,8 @@ described above. The overriding minimum value for size is 512 blocks.
 With some combinations of filesystem block size, inode size,
 and directory block size, the minimum log size is larger than 512 blocks.
 
-The log must be at least 64MB in size.
-The log cannot be more than 2GB in size.
+The log must be at least 64MiB in size.
+The log cannot be more than 2GiB in size.
 .TP
 .BI version= value
 This specifies the version of the log. The current default is 2,
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index dd8a48c3..cbc703cc 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -25,10 +25,10 @@
 #define MEGABLOCKS(count, blog)	((uint64_t)(count) << (20 - (blog)))
 
 /*
- * Realistically, the log should never be smaller than 64MB.  Studies by the
+ * Realistically, the log should never be smaller than 64MiB.  Studies by the
  * kernel maintainer in early 2022 have shown a dramatic reduction in long tail
  * latency of the xlog grant head waitqueue when running a heavy metadata
- * update workload when the log size is at least 64MB.
+ * update workload when the log size is at least 64MiB.
  */
 #define XFS_MIN_REALISTIC_LOG_BLOCKS(blog)	(MEGABLOCKS(64, (blog)))
 
@@ -3435,19 +3435,19 @@ validate_supported(
 		return;
 
 	/*
-	 * We don't support filesystems smaller than 300MB anymore.  Tiny
+	 * We don't support filesystems smaller than 300MiB anymore.  Tiny
 	 * filesystems have never been XFS' design target.  This limit has been
 	 * carefully calculated to prevent formatting with a log smaller than
 	 * the "realistic" size.
 	 *
-	 * If the realistic log size is 64MB, there are four AGs, and the log
+	 * If the realistic log size is 64MiB, there are four AGs, and the log
 	 * AG should be at least 1/8 free after formatting, this gives us:
 	 *
-	 * 64MB * (8 / 7) * 4 = 293MB
+	 * 64MiB * (8 / 7) * 4 = 293MiB
 	 */
 	if (mp->m_sb.sb_dblocks < MEGABLOCKS(300, mp->m_sb.sb_blocklog)) {
 		fprintf(stderr,
- _("Filesystem must be larger than 300MB.\n"));
+ _("Filesystem must be larger than 300MiB.\n"));
 		usage();
 	}
 
@@ -3458,7 +3458,7 @@ validate_supported(
 	if (mp->m_sb.sb_logblocks <
 			XFS_MIN_REALISTIC_LOG_BLOCKS(mp->m_sb.sb_blocklog)) {
 		fprintf(stderr,
- _("Log size must be at least 64MB.\n"));
+ _("Log size must be at least 64MiB.\n"));
 		usage();
 	}
 
-- 
2.54.0

