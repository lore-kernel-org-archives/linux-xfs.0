Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373701802AB
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479611; cv=none; b=SawIVvCPSvtTPQxYgaHGAvD67sSnUhDBuBIR7M+HB0B+eTGwDW82LIoj9x2vn+Oe3s7l0VlDqMFDyykGcRuT2RCQJzp4MC7WadGCuC8IMoV/775a9YEdmQqXHch7NKYZg4xtkrmDk53dBqWbuBQGdBhC9h69I4z9NjmRNfn3CBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479611; c=relaxed/simple;
	bh=2etNIHJX1cUMBUrOy3mjDINBs4hdyJ1LNN60xaPcMoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ubARM/BgU7GNxPZMYeCTfemFelz4hdq89HFYlSjWFXiEPU8AJiX1uN8YUi5wnMb9xMGqThndiCfWAgAnj+82kO7iCgTz8cwKosE0wMZvdyUNXvv0eRIj0wZ5TpVOq5TMuvLQRkq1Fd8G+FledfxHhnysppd0TGppMhD/E1gEmnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f4hYHnKc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f4hYHnKc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479609;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8KXtwd7kZb511gKUyjHXPqRvu6lVG9Lwj5SXMU90UaE=;
	b=f4hYHnKcWs2ALKfLDrrAcwOTWKddEdazEsjUXpVPmpy8+mObLHBtDtlGKM+jmFCfPIi2LD
	04Q1GjWZOh8uB0EEseQfjuznaRYXYSOPnEKvKKlQh4q3286gHZcXYLZD/ytHAhzBQdZgBq
	LyO+i5P4HWoZsN5evIUM8PfS3+cRJVI=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-100-t4biDXTkMVyEKyc_IR-pLA-1; Sun, 29 Dec 2024 08:40:08 -0500
X-MC-Unique: t4biDXTkMVyEKyc_IR-pLA-1
X-Mimecast-MFC-AGG-ID: t4biDXTkMVyEKyc_IR-pLA
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-aa67fcbb549so143095766b.0
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:40:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479607; x=1736084407;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8KXtwd7kZb511gKUyjHXPqRvu6lVG9Lwj5SXMU90UaE=;
        b=KTah/U73gXsDS8/IbYwUzccnWwJuOVMy+nm3x8pUZiSET8ve4sohofiDnNRW6tNl3T
         vRMF0u0lqWQXknBBBUjyBa40ZhKrD6HQ0eMaSwl7SWOCDPbjoU1RgqNx/c4VZPYOEj4h
         N6MoBj3RPlwJfYajumP3Uc3liPA4aWzzqh9SNNYi9Y77FO+W7gzm/JqNsxEgPH7JCJbQ
         hKv6xHYFUlkT32sbeAgmm0TQOTqVHrt4cFtq/7TEJH0b0RuSflsQ9BiMTOQ5FcoHNoxz
         Syi1jcW065Co2axc4cYmdB/M04n/lLs5HQ7op1OuWWc0leN/4oFbMeXaLMftegXC1PBA
         KbtQ==
X-Gm-Message-State: AOJu0Yxs7iuOa+ip1Kk++5+e3gQMApHj8eyN4SsDZ3QqtzpoCroPioME
	iRUDkTEkdqV/qwvWmzbC3hULkFC87/h1WjB886iebt8LzRpMQgmY7BEinD4HS7PyOKgY/NlClNC
	3xCx8gkRMuvRQ3bBAnLHdbaL++rw7UKgki8XTGDodqo8niHN5F1R3Ef26L+fhNQ3umPK+grif/b
	iINn9/4bdRi5sNWYXyJTMvM0wiVMAqjiALz/zb8AoT
X-Gm-Gg: ASbGnctDwMCYiUk0P3N1IiRUuFWcuwwUsJrqm1oNNzBwL24AZZ8tWD38/RyYTq2QQDU
	mwqtFiS27VdQaOIDi+TV20szFDlg239QBz8da5YI/mVocpOTCqRaJSFO3T3hIh69hVf+Hrp2Q44
	VAJm+QKuW6ac8qlr5uG2KZ69Ent7e0oim20hwVEadx6ltBbS2fwywheCjmMdrbygqs2ikspK+w4
	FJxnZneC49bQ5xeDjN703wToIgrj348kkEjsK6iqF20e23R3GFHCQddCqniJOkG994ISoOLcXGH
	NBSiu9K91vX7usw=
X-Received: by 2002:a17:907:268d:b0:aa6:b4b3:5925 with SMTP id a640c23a62f3a-aac2ad8476amr2333806766b.14.1735479606807;
        Sun, 29 Dec 2024 05:40:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG3WMifOpNbSrxeq/36j9lI+SK6BZmNFICjeFonwIixpoqpLF3eVg6K0vE5WGYmjQ8braAAvA==
X-Received: by 2002:a17:907:268d:b0:aa6:b4b3:5925 with SMTP id a640c23a62f3a-aac2ad8476amr2333804566b.14.1735479606327;
        Sun, 29 Dec 2024 05:40:06 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f070a7bsm1355017766b.201.2024.12.29.05.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:40:05 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 16/24] xfs: disable direct read path for fs-verity files
Date: Sun, 29 Dec 2024 14:39:19 +0100
Message-ID: <20241229133927.1194609-17-aalbersh@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241229133927.1194609-1-aalbersh@kernel.org>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
 <20241229133927.1194609-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Andrey Albershteyn <aalbersh@redhat.com>

The direct path is not supported on verity files. Attempts to use direct
I/O path on such files should fall back to buffered I/O path.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: fix braces]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 67381e728b41..8c26347a0a2f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -257,7 +257,8 @@ xfs_file_dax_read(
 	struct kiocb		*iocb,
 	struct iov_iter		*to)
 {
-	struct xfs_inode	*ip = XFS_I(iocb->ki_filp->f_mapping->host);
+	struct inode		*inode = iocb->ki_filp->f_mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
 	ssize_t			ret = 0;
 
 	trace_xfs_file_dax_read(iocb, to);
@@ -310,10 +311,18 @@ xfs_file_read_iter(
 
 	if (IS_DAX(inode))
 		ret = xfs_file_dax_read(iocb, to);
-	else if (iocb->ki_flags & IOCB_DIRECT)
+	else if ((iocb->ki_flags & IOCB_DIRECT) && !fsverity_active(inode))
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
2.47.0

