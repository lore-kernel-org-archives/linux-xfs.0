Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516327A70E
	for <linux-xfs@vger.kernel.org>; Mon,  4 Mar 2024 19:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709579546; cv=none; b=c+yjyFZ6ashC2hbnrcOc+kNEW3kyKXDlEplxY2XA2+qJ1qftoFWRiIBpcyX/gU9fvRtBk/8Ox+HELp2NOvixXSFzTcs2+7XHIrpmOE8RzAKGZQ9fu8PuXdip6II0hS6shK10klKaD7Uh64NIpnJX5Af5lQUnbGDFDVOUWdPLgjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709579546; c=relaxed/simple;
	bh=HHQ81S2hPxColFzvYzIn9dIw5ty7YjE1Xuf7rj1qYOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rTbtCN1N+8Icp9yVVgBQCv1phMXqTL7PEw/WZJvLD8BGAL/dHiTOtvaiH5wFVPpZf9hEc2JpQc4nSdv0oZapadmxpiDtfmENW/iixUY/Y5qFEdKj0Es/R1157q8syWQWfjfXDDjo5Aa565Uymup8lpqrUgdmvpTOa1Rn3dBeaiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=apXf7aSF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="apXf7aSF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709579543;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=far6zlrIyHC61tMfvysiCXbI0A2uQYiTQAm6dVAsqUo=;
	b=apXf7aSFxUbjvNQ2yUFxs9aVuyZ7VB9lKC5LsMQx38r8XOD1JHaWj0b+h5F+i9Eh5ntWVh
	QhInVC6Ef5UFAztlS0fivJnRb68HPH/8LsaytAP51BE9LirquR+/mwf8Pf2KgHTz7WmEbL
	9KSfvTEchNDTVOsmXfDTchIYuKlFwrI=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-138-dh0fMRZeMj6h_5rw3aoonQ-1; Mon, 04 Mar 2024 14:12:22 -0500
X-MC-Unique: dh0fMRZeMj6h_5rw3aoonQ-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a26f2da3c7bso407199266b.0
        for <linux-xfs@vger.kernel.org>; Mon, 04 Mar 2024 11:12:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709579541; x=1710184341;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=far6zlrIyHC61tMfvysiCXbI0A2uQYiTQAm6dVAsqUo=;
        b=urhOlaF5GDDzVK6bTHn7cLOKtc55I0ybBK0GlYRES0jBjPydskmHmgxz/5XThhg282
         NXFKW/ajqIw1CbQi430b3ngeY20h08XZInJAe3lXckE7yR+X77OlitFSK20LfE5/N/7i
         KgWhSfkTi4rva7VD6Gs/hQ1tKIfZ36Ex2HJcXzsHLXO+RLQTPEfQm0ZFs9y7Rirv3NOi
         3FoSj3PbG4+3fjmpZe7ixQivLrjJE9Z9DKAlEI9+eljgH+NU8liV+4dlpj8KDDTmfmDW
         ayh36zD+9AXJR9jNldrLm0mFOiSJwKqoLjHekZhnWOZVvMMfQaKxil8OhHf8ZWR5cofB
         lNqg==
X-Forwarded-Encrypted: i=1; AJvYcCWIs9JPY9wwyltmzrPgr8CsFFe8hOoLyeTnduX5mrF8VMlyrOWmEaAiqnlqwFKg3T5bCAP0x7ESOAs68K3kRIS1CSAv8xNVo/s9
X-Gm-Message-State: AOJu0YyInK5jUkNwIJWQDAccx0a0FLp3m/R29bOiTyegwve5quXuAqpY
	Uj4JPbiK1q6kiglD8QcyHct4n6Ub5UnXQ88ig130vMg4qn1vEyQSo7Wrn35G5Oayw9bdOs4SXIu
	xehoVMopSd/H+AYaMOrf2m6O72voxuLulkjFTyOsWyg1txBweXNixq8BG
X-Received: by 2002:a17:906:3508:b0:a44:d042:887b with SMTP id r8-20020a170906350800b00a44d042887bmr4066258eja.8.1709579541051;
        Mon, 04 Mar 2024 11:12:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEk7B3tup0Er2HlIPaQGDDhxylodjsavVO98JJAa6+X9m5TWmampICNTZgEFh4QY5BNyEOlZw==
X-Received: by 2002:a17:906:3508:b0:a44:d042:887b with SMTP id r8-20020a170906350800b00a44d042887bmr4066253eja.8.1709579540844;
        Mon, 04 Mar 2024 11:12:20 -0800 (PST)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id a11-20020a1709064a4b00b00a44a04aa3cfsm3783319ejv.225.2024.03.04.11.12.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Mar 2024 11:12:20 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	chandan.babu@oracle.com,
	djwong@kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v5 11/24] xfs: add XBF_VERITY_SEEN xfs_buf flag
Date: Mon,  4 Mar 2024 20:10:34 +0100
Message-ID: <20240304191046.157464-13-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240304191046.157464-2-aalbersh@redhat.com>
References: <20240304191046.157464-2-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

One of essential ideas of fs-verity is that pages which are already
verified won't need to be re-verified if they still in page cache.

XFS will store Merkle tree blocks in extended file attributes. When
read extended attribute data is put into xfs_buf.

fs-verity uses PG_checked flag to track status of the blocks in the
page. This flag can has two meanings - page was re-instantiated and
the only block in the page is verified.

However, in XFS, the data in the buffer is not aligned with xfs_buf
pages and we don't have a reference to these pages. Moreover, these
pages are released when value is copied out in xfs_attr code. In
other words, we can not directly mark underlying xfs_buf's pages as
verified as it's done by fs-verity for other filesystems.

One way to track that these pages were processed by fs-verity is to
mark buffer as verified instead. If buffer is evicted the incore
XBF_VERITY_SEEN flag is lost. When the xattr is read again
xfs_attr_get() returns new buffer without the flag. The xfs_buf's
flag is then used to tell fs-verity this buffer was cached or not.

The second state indicated by PG_checked is if the only block in the
PAGE is verified. This is not the case for XFS as there could be
multiple blocks in single buffer (page size 64k block size 4k). This
is handled by fs-verity bitmap. fs-verity is always uses bitmap for
XFS despite of Merkle tree block size.

The meaning of the flag is that value of the extended attribute in
the buffer is processed by fs-verity.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/xfs_buf.h | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 73249abca968..2a73918193ba 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -24,14 +24,15 @@ struct xfs_buf;
 
 #define XFS_BUF_DADDR_NULL	((xfs_daddr_t) (-1LL))
 
-#define XBF_READ	 (1u << 0) /* buffer intended for reading from device */
-#define XBF_WRITE	 (1u << 1) /* buffer intended for writing to device */
-#define XBF_READ_AHEAD	 (1u << 2) /* asynchronous read-ahead */
-#define XBF_NO_IOACCT	 (1u << 3) /* bypass I/O accounting (non-LRU bufs) */
-#define XBF_ASYNC	 (1u << 4) /* initiator will not wait for completion */
-#define XBF_DONE	 (1u << 5) /* all pages in the buffer uptodate */
-#define XBF_STALE	 (1u << 6) /* buffer has been staled, do not find it */
-#define XBF_WRITE_FAIL	 (1u << 7) /* async writes have failed on this buffer */
+#define XBF_READ		(1u << 0) /* buffer intended for reading from device */
+#define XBF_WRITE		(1u << 1) /* buffer intended for writing to device */
+#define XBF_READ_AHEAD		(1u << 2) /* asynchronous read-ahead */
+#define XBF_NO_IOACCT		(1u << 3) /* bypass I/O accounting (non-LRU bufs) */
+#define XBF_ASYNC		(1u << 4) /* initiator will not wait for completion */
+#define XBF_DONE		(1u << 5) /* all pages in the buffer uptodate */
+#define XBF_STALE		(1u << 6) /* buffer has been staled, do not find it */
+#define XBF_WRITE_FAIL		(1u << 7) /* async writes have failed on this buffer */
+#define XBF_VERITY_SEEN		(1u << 8) /* buffer was processed by fs-verity */
 
 /* buffer type flags for write callbacks */
 #define _XBF_INODES	 (1u << 16)/* inode buffer */
@@ -65,6 +66,7 @@ typedef unsigned int xfs_buf_flags_t;
 	{ XBF_DONE,		"DONE" }, \
 	{ XBF_STALE,		"STALE" }, \
 	{ XBF_WRITE_FAIL,	"WRITE_FAIL" }, \
+	{ XBF_VERITY_SEEN,	"VERITY_SEEN" }, \
 	{ _XBF_INODES,		"INODES" }, \
 	{ _XBF_DQUOTS,		"DQUOTS" }, \
 	{ _XBF_LOGRECOVERY,	"LOG_RECOVERY" }, \
-- 
2.42.0

