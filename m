Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BA32BEC43
	for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 14:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229424; cv=none; b=fY8IzMKNDcUYSR8mA9N/yYIA8FzhAry0XaazvVgDXHHAdgAaiuzuOgw97WSTsLa+GYH0u3npx1bEfNVoFKEeoyT1K/lp4CYytpLfx3lbuIluru3i0YkPfYR5iSk4kCPEBJXPwTGtW+Es8DLM/H1zrECHxqCCeE01UKfsPjcAhEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229424; c=relaxed/simple;
	bh=srquItat3iIisx24yelRLxoGuZRV8LO1BEtV0r7CHkc=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Slk32tHJmZglSQjsEJwJ3SbSqdynfeXSsp/VCoDz6Ea2gkvhp80CNpKUtWVMKPcqv0BbQe8tF4t0ILLShaD/RoEqA9ux05b2vbGSKRrzxzbIN2XF4D73SsepQLxYlBJzmJrmFkBv9awcnyMoH05/h4w8itpeAWFH/nMMzw+/QRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LCUsojSy; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ij/wwzLN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LCUsojSy";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ij/wwzLN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768229422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7m5yP4ArOwgDB+QQS/sWnqQ++oA8WiS4/X74cxkt+wA=;
	b=LCUsojSy46BFuPN8qhw/wnBrcrYdkRpUXqDI/tNR0S70INwT7rXjdu2hlBDtZMV/B+Hf1P
	P740Yg+4vy+lSKP/iNlFq5WSPw/o19mA+Pjxp0dVLj13k+H4njioPOuCtvBUqWmGcyqf9/
	EnyMWoMnKXLhBqZN2W9O2iV1yAUkQUw=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-88-AzcX6iFFO6yuKJW73-oN3w-1; Mon, 12 Jan 2026 09:50:21 -0500
X-MC-Unique: AzcX6iFFO6yuKJW73-oN3w-1
X-Mimecast-MFC-AGG-ID: AzcX6iFFO6yuKJW73-oN3w_1768229420
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-b800ee1a176so1130199266b.1
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 06:50:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768229420; x=1768834220; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7m5yP4ArOwgDB+QQS/sWnqQ++oA8WiS4/X74cxkt+wA=;
        b=Ij/wwzLNC6HHDKZhUKuIDT6vzsLFXF3k5rV74hEsRv7wvrXgVfc/LXzuqGCip5q1Re
         lg8wshyrHH45VD6ZclLabX0gzx7h5I+X13nPUpJvlCvs8f3E3AAkN3N2ETUX4n6JdnfO
         i2iWgt0C24VLX+ruK8VKQaeF6DzHPD8tB20QE2HMUEExzSoyh+hG/4Wq3jkWEPmJnUmi
         inIj580DrR164coUbZvpYAKUANuR2Omtsyg85AhIymSwinfN+U8jZO6qCnD7FKR4dUSg
         cpNqrPo7MfHFNw3eHrf8EqEtAaWiev7H+w34zleyEmT02ww/FLJ2bctAKmedlp9t4lUl
         isRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768229420; x=1768834220;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7m5yP4ArOwgDB+QQS/sWnqQ++oA8WiS4/X74cxkt+wA=;
        b=aJWFhou3pB/rn3s+XOt/LtzKSrr5asMHPjdHfTzzBH5W4I3W9yYxs199zHVqI9GbNQ
         hrVfpOpzme8UCrmMfbvXh2T03n/Nf7Bc6tPRmPXtAXsVKokAYl72TfNbqcFyN33VYjs8
         jBzlDMB2kBknHDkIZ3nUM7O9Gaioyts3imCnjF6Wy+nrXxMQix2M2l3kqaCZvGhtm61c
         q6cdJa0X1awCRJ93kQzuxfUfZaz3av421dALMc6dYzsVG/kq7Jhq9NUXuUL1bES6874k
         hNNyY7fMamx2L01R7DKiJozK5Ceyky3iYVMQ/le91oT9kEvhn0EFw0fJnP84UUXnvhAd
         irmw==
X-Forwarded-Encrypted: i=1; AJvYcCWTkTR97auwXHkuyIdy31B3lA96+DwZvAqBZg+uMik/zOJ8j1J5q0JKwzXKzpEMfxObgCmJvg5zW6A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7s906j6w2yQgG1disL3dd4Mzuy1Ja8BnR22KrOGi6t4fVN9Nd
	zvLdbYwjFpysrZxG0lxPFzSYcNSo7MgEcHsOfYK6l6cbBNd6VUc+FlofTpPaQ+U4RPGLX0dZw3y
	g1j7UCcnTuHBgKKW2+nALF/2n4hFdQsEgnOkRT6tII7evDUAcVoBt0wcvpstK
X-Gm-Gg: AY/fxX4b9xCP7GKCFdAdiDO7bch9kPmmvOzUC2lgMJ2qx+l8CA3rtq/00ai2DzHmQmF
	Ww+MZFHjLQbQirptV95u+3jE49PIvWfL5++5RRrFWDVeYvZcvMLQyaB/guZ1jxljUU3N2nLvP5j
	yqM2S2juHLpKyDoi8ZfMxl+8COsGivMkSJ5tc/58r/kXphWxKnxm6l8DZQLquoOdI3HrHCQOk7G
	NioDv6VgkHQKvggFTYYBq0jNIFTE+qsjpQlks2gvikYB2MoaWqaUnbF8OJnH9fRha7KDCm0H+vc
	cOR6oPaf25meh4mZC6Ox6QH7H8fwuzMgBa2hSA+9jueI+foZbK1kbWQuaI9H2ZJCsm+3NISe7J0
	=
X-Received: by 2002:a17:907:8693:b0:b80:40cd:ea6c with SMTP id a640c23a62f3a-b844540fafbmr1740778966b.61.1768229419952;
        Mon, 12 Jan 2026 06:50:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFrXKO0CxWBOf2w/I7WXqz590chwScxO7BnYwI6Yf1sI5Y18FioHghi8Y+cIJhX4GNkkBv03A==
X-Received: by 2002:a17:907:8693:b0:b80:40cd:ea6c with SMTP id a640c23a62f3a-b844540fafbmr1740777166b.61.1768229419488;
        Mon, 12 Jan 2026 06:50:19 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b87207e08a7sm232426666b.55.2026.01.12.06.50.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 06:50:19 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 12 Jan 2026 15:50:18 +0100
To: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, 
	ebiggers@kernel.org, linux-fsdevel@vger.kernel.org, aalbersh@kernel.org, 
	aalbersh@redhat.com, djwong@kernel.org
Cc: djwong@kernel.org, david@fromorbit.com, hch@lst.de
Subject: [PATCH v2 4/22] iomap: allow iomap_file_buffered_write() take iocb
 without file
Message-ID: <kibhid6bipmrndfn774tlbm6wcitya5qydhjws3n6tnjvbd4a3@bui63p535b3q>
References: <cover.1768229271.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1768229271.patch-series@thinky>

This will be necessary for XFS to use iomap_file_buffered_write() in
context without file pointer.

As the only user of this is XFS fsverity let's set necessary
IOMAP_F_BEYOND_EOF flag if no file provided instead of adding new flags
to iocb->ki_flags.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/iomap/buffered-io.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index cc1cbf2a4c..79d1c97f02 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1173,7 +1173,6 @@
 		const struct iomap_write_ops *write_ops, void *private)
 {
 	struct iomap_iter iter = {
-		.inode		= iocb->ki_filp->f_mapping->host,
 		.pos		= iocb->ki_pos,
 		.len		= iov_iter_count(i),
 		.flags		= IOMAP_WRITE,
@@ -1181,6 +1180,13 @@
 	};
 	ssize_t ret;
 
+	if (iocb->ki_filp) {
+		iter.inode = iocb->ki_filp->f_mapping->host;
+	} else {
+		iter.inode = (struct inode *)private;
+		iter.flags |= IOMAP_F_BEYOND_EOF;
+	}
+
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		iter.flags |= IOMAP_NOWAIT;
 	if (iocb->ki_flags & IOCB_DONTCACHE)

-- 
- Andrey

