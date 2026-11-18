Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794962940;
	b=wfPCGLhZXcnKNqF85sIIl+YT4eB8QwHn2a8lXtbYpn9hXr1UIPCZToO3wTbtoAb7++0B
	 /kk5QR7b565fcdsf2Sh39FL2kPA5OAtGD/jfP88PPFI61RTvJgaRu1qUD8WJa2TO4Yess
	 zVU2fUf/VNIVP0u0ncCn6Bzyy97QUP6MFj7J3VniAW8mM5Q+9EUBFM9lmJ4qqgxPDVY9p
	 XffoGtoc6L2yfg6WgGTQEqrA02T06PnSG3ZLIj3qauQrKbV+xvX711NRQr/nH8Q1+YVYj
	 SaqXTHTkUJewuCYHJQcwZEqJXxuJRGxyYFkAKyP2WnQt9c1J82VyJFuKHMOnPU2BnvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794962940;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JT5GitO9guQMxmpDsN7N3JTT9ZwlLUCA63pj7Wlo4Ow=;
	b=G8829Uo/p9pEug9YXmiSvM8oG6dKkq0RYlKVQrucBiG5N0BXGlAIpQ6JcGdtS4DtxQWI
	 o7nvcSRdak3R8TSVqrudb+oZNWtdrXAQdT5Ro+5D45K0+KASxmQgvlPtBgm9tz1bP/10A
	 MXrXSNDuIrwOXPNioDjZMPgUqWp45H80iR4y85o+Dzf0aymmflx1MDxLEZ3y6c8mOeA+m
	 dBnhyKWsFW/lhfXnAcVLGjCDaEUnZaYbImf7fj0safp9xN8j+OxnY1mRHw3YZEuJtHjfL
	 bfYqGYt52vT9yBjr9xkO0lDAjZM1u2XbOeyVYHBCLyRYhLldWhdvCkDBpxryOHQR8Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=dubeyko.com;
	spf=pass smtp.mailfrom=dubeyko.com;
	dkim=pass header.d=dubeyko-com.20260707.gappssmtp.com header.i=@dubeyko-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=gsVY7QIi;
	arc=none smtp.remote-ip=74.125.224.50
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B69606A886
	for <linux-xfs@vger.kernel.org>; Wed, 18 Nov 2026 00:48:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79B69606A886
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20260707.gappssmtp.com header.i=@dubeyko-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=gsVY7QIi
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-67da69e7c31so297406d50.3
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2026 16:48:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20260707.gappssmtp.com; s=20260707; t=1794962937; x=1795567737; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JT5GitO9guQMxmpDsN7N3JTT9ZwlLUCA63pj7Wlo4Ow=;
        b=gsVY7QIiaHuhXw9hDeLuIoiMd7+78YSHKcBI9sh7vklFBT18aPuLoJ/EvDFS5jWINs
         A8A+MhYvjG5S5diQqSdSqdaPIkk5E6Dgqm3AFJ++EZdT0hD/zxy7599MQIFvC9ljaMBv
         bc+x/vl1OKmKcsPcR15R+h9UaLmVgYRvE8285uSTgRJCrD1TJDlZCZQM+r4YG2t//5L7
         JJ3H7a5uK7cr2zKAhn97lL6DVH/mXjcVgHNiDZzUPSO4iijb02o2X/d/fBRNOxAc7sIw
         C4vQVo3ArK8dsDolaUO4laRWjoBDohTdoiBtEEeul4wFrboxl8AGWUj5m2Ng7jzslNRT
         5McQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794962937; x=1795567737;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JT5GitO9guQMxmpDsN7N3JTT9ZwlLUCA63pj7Wlo4Ow=;
        b=xce/MZeURIOMQpb/RRB3JEoowoPYifBgUW/KmcZxw4g8IOhL9Sa9fSM0xbhS8ElndP
         JIbihlgipXC6WaUvNdiUzZXYfB99BGL/5Zzz9s6DquioBWWPwMcmGNGwUZtiRYIOf3Z9
         cxFgi/M4rcluYLAR/i8nqD55Uz4HGVpcbCmc4R1antbVReR7R37w9wUYSDhub5NaldzW
         l4JKtD7aoW/1A8LtJwMfgZzubGntWbFe9t45k+grlcD8sEabi6O1UTYV/lpp3vb/dGKR
         3ItJ0U2OUfPyGDwUBVHsSR+ldAxicgD47Qz4BUF4b6m24trZEIzB0nqo8MRCwARKlVit
         B+0w==
X-Forwarded-Encrypted: i=1; AL+hErGVE0MLWpgNQ5161pjAeET9Qge+e4lOaMyj++S2Il17Gs1l7BtE3NyiAc/la22T2pdMHCA7QyiRzs4=@vger.kernel.org
X-Gm-Message-State: APuU4Z/w5bps7dwEVTzXHW297ENQIpI8SLqwK4oKhKCHmt+3tGmTkxH3
	3opFvanRrmez/S5fsQyqVLwFiDrT5n+q1nwaqVsBhxkc2pMgqb3eGCIblfo4RAn89nlMqv6YHB7
	2pjisAHY6Aw==
X-Gm-Gg: AZFdTZcPz5aKEjHMcWr8j/KO3Bujm5ePAd1SXzMHnItwo8iny0PlqbYocZHGYhorHqy
	+cPkwfkiJXQhbG7xfZlXhkLck/EAf25zFEhcDT9fIZbK1hcPdJd01eYSDfoZ9rHlbEHEbOMmBlg
	Iyx7zHogsy7qQy4XefPCRfOm3WSiVGyK6RHUskAOYnKSyzvDQxuCfiEmhXz4gf1c/XTvrCsqJK5
	CAKhlyvuK+9tzH8qa43quqd/sntwSFG3ia0Tx/2N+jQSJB6YRQBw7ZVAm1NcfLiz0ez9Vmg2kfK
	PL9V6wjMmj72a7QE/DHuHTznZQABYPfnuDfgP0WSKO/DkQbUM9euRA0eomAnTggI526suiRUVsN
	6i+uq1hSE1ztuXvbXJn/wQDLb2LuAOGnI3K9W2tU9nJeMf0fTuvQpwKMOy8DpWKH9IdGa55REVj
	JCxoeVgb3mlvOuaWLDsUW0CGS9tHCEoY7OcTUyiqObeAS8xknZqOocFXpERBwBSQbzG2kR6CUEy
	0meYyMz+7AoMm7ReKOw5DM+OP1Qz7uACR4RzxBqbYhyBBH0OgDcFqLy63MAxRjTyG0BZc+CnTOU
	lj2J5GQmTpzuikz//531k0LljwbeVnFjUpnAoq26nem+tNkP5Zbv8DVAOhJkgq0MYoKulbltfTW
	wsljYiRNdA1Htemi5oloJh6I9gXy03qJ1RPy/iWi2gQfqbUb/LhE1rNa6/yGo/Jkidf7ElFI=
X-Received: by 2002:a05:690e:1348:b0:67d:bb89:acd8 with SMTP id 956f58d0204a3-67dd459e236mr521095d50.76.1794962937364;
        Tue, 17 Nov 2026 16:48:57 -0800 (PST)
Received: from system76-laptop.attlocal.net ([2600:1700:6476:1430:5fae:4d02:7055:94ad])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67dd56ead87sm729575d50.1.2026.11.17.16.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 16:48:56 -0800 (PST)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: glaubitz@physik.fu-berlin.de,
	frank.li@vivo.com,
	hch@lst.de
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	vdubeyko@coreweave.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v5 1/5] iomap: add iomap_dio_end_io() helper
Date: Tue, 17 Nov 2026 16:48:40 -0800
Message-ID: <20261118004844.3849979-2-slava@dubeyko.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261118004844.3849979-1-slava@dubeyko.com>
References: <20261118004844.3849979-1-slava@dubeyko.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Several file systems implement an almost identical ->end_io callback
for direct writes: if the write succeeded and went beyond the current
end-of-file, update i_size and mark the inode dirty (for example,
ext2_dio_write_end_io()). Add a generic iomap_dio_end_io() helper for
this case, so that file systems don't need to open-code it.

The helper updates i_size without any locking, so it can be used only
by file systems that issue all direct writes extending i_size
synchronously (IOMAP_DIO_FORCE_WAIT) under inode_lock.

The first user will be HFS+.

cc: Christian Brauner <brauner@kernel.org>
cc: Christoph Hellwig <hch@lst.de>
cc: Darrick J. Wong <djwong@kernel.org>
cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
cc: Yangtao Li <frank.li@vivo.com>
cc: linux-xfs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
---
 include/linux/iomap.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 5254430844b2..616abe7ebad9 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -672,6 +672,26 @@ struct iomap_dio_ops {
 	struct bio_set *bio_set;
 };
 
+/*
+ * Direct I/O completion handler
+ */
+static inline
+int iomap_dio_end_io(struct kiocb *iocb, ssize_t size,
+		     int error, unsigned int flags)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+
+	if (error)
+		return error;
+
+	if (size && i_size_read(inode) < iocb->ki_pos + size) {
+		i_size_write(inode, iocb->ki_pos + size);
+		mark_inode_dirty(inode);
+	}
+
+	return 0;
+}
+
 /*
  * Wait for the I/O to complete in iomap_dio_rw even if the kiocb is not
  * synchronous.
-- 
2.53.0

