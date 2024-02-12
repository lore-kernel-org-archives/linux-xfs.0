Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B581A44C87
	for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2024 17:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707757229; cv=none; b=Be/03Pz3r6gkZZp4+5vZ1ZpOxp7MmfAwN3TOYgP4oN+GvRXGwUdTrEJ1MkWxE9mtRqCZpMQElSTPTset52hLC24f1NEmBWTa1WjWJuddylVoPEnR4I+KUmlHllXRcs38Doy456loWhkDcPiPWH08xqpJqCtm4S8nqXAePSKPJDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707757229; c=relaxed/simple;
	bh=L31YpI5cHGwgxPGXiju5BCSchrSCFM+W/kdnKuUSicg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Uf24vOENG0UfpBsUzQT5trH5JnPO0jh2qDtxx3zxHWg1XhjLO8mt4bI22qZwef53F8G9fOZHZk7X5jfjvyqXmTFaF5oIJ1iqfEzWWcCLRUKT4T7Au914UDS9IjKny4O4G15Ht3Kk7e56nrQ0dkjpzMTM93qOkrW5z0UuaYHdcjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IAaxb/WD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IAaxb/WD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707757226;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v8DMtYJWCVCHSCEWBZfbGi3INfqAeJCCNzs6AgTs1hw=;
	b=IAaxb/WDfSq92hkuS/U795Sm7JBGRReZT/jzoGJgyWxX0SMYjmYK4HM16IXNoFgP4Jfu9V
	0gXsOpZZRPoo16E0SaTn9L3mYSh4u5TUyUbKA61uLVYB/O/i8zaVsom5yVBNc5mY80Ur58
	AkZEUiCoXb7rA9efq5TFTPhYf38yNB4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-101-MxPM6WA9NBepQeB0w95ubA-1; Mon, 12 Feb 2024 12:00:23 -0500
X-MC-Unique: MxPM6WA9NBepQeB0w95ubA-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-561601cca8eso9944a12.3
        for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2024 09:00:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707757220; x=1708362020;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v8DMtYJWCVCHSCEWBZfbGi3INfqAeJCCNzs6AgTs1hw=;
        b=CYJUrUYHV3kSEPRLiHQSdfTvqVGXVoDkTXo/7PgTf8t4JMf2O3rSG+1vpVAHpbjye4
         kWieNwVTQwFU4NiEUe6MOKruKT0NIzmdPZEjJ+Dt6uJ9GpzQQ3PRXKLIRHFR2KXcEmMi
         SADGzrzggQP1c5dRyN0JRIixHSoaOSEifzHptktWJCEoJ57EwWfsCm9iygLsjUqKPHF0
         QFbxL5rPj/6Qulwx0LftyoGc/6VlS1V7NPy8aKOftOZ9TIJCAKlDD8v3g0n/gqiKk4u6
         hElpSircTkWfcovlPex3ICOOzZ0OV2lxBoukqHU+72/G9xCxsJOIxqZCBrDb4ToiDFru
         2wYw==
X-Gm-Message-State: AOJu0YwtY4ddIcYxLKf2/Ce235bLLEePmDm8M6jrwKaA7Fz6BrHtf1o8
	j/K+2rA41X68bc7yhCOlatf1smSpKKFYl6e5KS07jIoKDK7GWiDZgV380QUBRItg9/0pFkbNHFE
	C2Bcxxp6HR9CKiFB8bRMVInjxvQO4X9Ubgy8OGVVoDeYjXH7rEFIKvF6Y
X-Received: by 2002:aa7:c71a:0:b0:560:4e6:c442 with SMTP id i26-20020aa7c71a000000b0056004e6c442mr4968905edq.1.1707757219861;
        Mon, 12 Feb 2024 09:00:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHdqLzEkltOhv90/mdAnBYzqC7IUdmnma0K+szge3JGNVz0tYyEgI2sp8chHtI9P5lmUmCjVA==
X-Received: by 2002:aa7:c71a:0:b0:560:4e6:c442 with SMTP id i26-20020aa7c71a000000b0056004e6c442mr4968893edq.1.1707757219573;
        Mon, 12 Feb 2024 09:00:19 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV3N3pdtpy2jDzzn9qjG81jBQ/X5sQeRIfOLG26RPUaUSSngS8BpTycQ3WIoFOMcO1xf9fGHYsQ94U8TsvWWVkCU0bbz6k8resLyTmPIDI5OyfbJpA2iDbStA3VZbVuuwCWj0Pl2k/t2JENFurvj357mNiz0AQE7dVAMsSi0pfW6BEUDkievBaQHTIkytdug4eYIOID5DxYHpZ/cNdPZgzsTnz9sQ8Gv1PX
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id 14-20020a0564021f4e00b0056176e95a88sm2620261edz.32.2024.02.12.09.00.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Feb 2024 09:00:18 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	chandan.babu@oracle.com,
	djwong@kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v4 21/25] xfs: disable direct read path for fs-verity files
Date: Mon, 12 Feb 2024 17:58:18 +0100
Message-Id: <20240212165821.1901300-22-aalbersh@redhat.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240212165821.1901300-1-aalbersh@redhat.com>
References: <20240212165821.1901300-1-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The direct path is not supported on verity files. Attempts to use direct
I/O path on such files should fall back to buffered I/O path.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/xfs_file.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index ed36cd088926..011c311efe22 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -281,7 +281,8 @@ xfs_file_dax_read(
 	struct kiocb		*iocb,
 	struct iov_iter		*to)
 {
-	struct xfs_inode	*ip = XFS_I(iocb->ki_filp->f_mapping->host);
+	struct inode		*inode = iocb->ki_filp->f_mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
 	ssize_t			ret = 0;
 
 	trace_xfs_file_dax_read(iocb, to);
@@ -334,10 +335,18 @@ xfs_file_read_iter(
 
 	if (IS_DAX(inode))
 		ret = xfs_file_dax_read(iocb, to);
-	else if (iocb->ki_flags & IOCB_DIRECT)
+	else if (iocb->ki_flags & IOCB_DIRECT && !fsverity_active(inode))
 		ret = xfs_file_dio_read(iocb, to);
-	else
+	else {
+		/*
+		 * In case fs-verity is enabled, we also fallback to the
+		 * buffered read from the direct read path. Therefore,
+		 * IOCB_DIRECT is set and need to be cleared (see
+		 * generic_file_read_iter())
+		 */
+		iocb->ki_flags &= ~IOCB_DIRECT;
 		ret = xfs_file_buffered_read(iocb, to);
+	}
 
 	if (ret > 0)
 		XFS_STATS_ADD(mp, xs_read_bytes, ret);
-- 
2.42.0

