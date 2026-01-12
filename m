Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A84C2BE057
	for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 14:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229507; cv=none; b=HURUgotx5hbIcbZ1pK+rnQSfQ6vmdUJKvtKqMeG4/2jjG+XIwAMsYjtUwyzwIW/KopGlBBsOZ8vaquT4l2uQgqdEF/S6ApxDyKbI4gfDkXhscrqYeiJSWBMnzict8Iy19g+YmTQq67wMz/XSBMrw6MRd01iELzPOPLJQ1PslaWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229507; c=relaxed/simple;
	bh=KuVncpruotZd/UsOXvAmuKf4QdktlGEPoHD59smbXrU=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EPrb79FbZUZPKDZhV1hny4kM2pSgQXnVVN51PGqxnNmwYIuNuHnZar534AKmyip3QDTCYW8bMmntJJXzn1Noztq9rhut7+/IJwtSHIoy+3ziN1f8CM4HvEXUV0bc+bD3pX+5OCVyRYHpEuJgN1Zvdmg75vaDD4ha4L0jjH3nmWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GAOhyxWV; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y94NZauG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GAOhyxWV";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y94NZauG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768229505;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SBkDD6Fi/bpRn7zVUlo8hSmg4I+N+3/I24mCz3Q7/v4=;
	b=GAOhyxWV4g97sts6r8IfkLIYd3dlgxzJXQh+4YwuzX/i3DsiEpvYFeJEDdoCpH3Fd60QwK
	a38SUC7gO3M7sFE4PJvAtV1spT5aTWxbGLyN3iHAxYCPYgrrd0OiWndHhVLHCaC0K91KTI
	Xlie6UoH6cxHA6yUty+EtMSfuTh40y0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-365-CdBFA4A6PHynPdmSR1cv3g-1; Mon, 12 Jan 2026 09:51:39 -0500
X-MC-Unique: CdBFA4A6PHynPdmSR1cv3g-1
X-Mimecast-MFC-AGG-ID: CdBFA4A6PHynPdmSR1cv3g_1768229498
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-b86fd61e3b4so176852966b.0
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 06:51:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768229498; x=1768834298; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SBkDD6Fi/bpRn7zVUlo8hSmg4I+N+3/I24mCz3Q7/v4=;
        b=Y94NZauGel3DewOYthCeEdIELMiG5RI5w12oGnPFExihxpEvtNLysYty59VWQvWtLT
         lKO5yzm/ck3crPWYOYNZnuULbsB2pEfSsPWj3TsPM2MNy1cfQD3gyxB57Nnb+jc1rcW9
         hznN0raSXIhej9EB3HqZmB0/xGGUgHKKCW82i/ZE0U7oogRdWDNIyqIbCeVkAs/kG+aX
         ADSHa8kPsbGTRdEMGRCRtWvaGtl/+HACXGAzPh390sPgTwKcZO+83O5hpFiW7v0tKQ3s
         8Xwgrly70PObOPaOatFyUeOQ1U2GfXkS4c6OQ+jIvaWKpugVVLwcwMQRhmGEdLU1HbRX
         5+kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768229498; x=1768834298;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SBkDD6Fi/bpRn7zVUlo8hSmg4I+N+3/I24mCz3Q7/v4=;
        b=DD8xx8SPqyiTGxjyOJ6MAIpDTjPfvtpw/DBXQoqfcnNf9G32x0e7vXPEJiegTEFfKQ
         eeKMk366vUFhoIocuCYCzfru1cyGtBuTWBHhXL7GVsVQ6VTMhbXuLxpsoh+9jRhPlQcn
         A25Hx7Va7pwBoMgkD1XGtHWyF80lL1JhjWUYliLnqDdRCVHK6hq20JkEmYfcdyELL9uq
         pvodY2xsk+F+EUgeKK9ZtWtsoFiybmQCEZiddZZYuJQiuguuhwLr2cCv9P+/GjZxQ6Vx
         l+aSjFk/WOL+9LvRJ90R8UU2BjD7reW7neQyy+BNZF+6PlMmasuyl3KoCCg3YurmZPMO
         Lcjg==
X-Forwarded-Encrypted: i=1; AJvYcCX1JzM+e6GEpNcbgL+q/AGla1K/396OuSSg4MgWtqP123Infqhgb9HL8Q+y9th/gjZTtk5vvdg1hOg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx53aU2ACHmJEAi3dt+lwQGon0kxAHmUAtuNlqWjr9WASrnDgo/
	EQ0oW5vqQFYnKdK5oVv4SxyvKV4ofhsmjhMPqBAeetjfJukvYvtiI3/SZua2z00sdfN2dmWeeE9
	DUW1iHEufLZA9LXzQntsFRK0P30TTNBLPA5f35y37t+JaKii8Ks/jVgN7jEPM
X-Gm-Gg: AY/fxX7wymo3aCe84qCqsgVQOHICXb1C/8GBbca7PnIU3qn976QdRUV105Vma9a5POb
	92f2Gi45MFsoTIjvNonnw6LcdjeRhawbJTofDIFfqDHjIInXTjugfgBokctVTUdNZYZQ59v+dkk
	VtMqzRapZ57Oy9CR9IS4CPFKV8Y6OuxRfgMr7NDmcT3GSi18he0GPUsB0TgGV8maPTzpUcnL1la
	th/G08rdF0YzbK1qQSJvvo4+2bfA6uCFn6UdlPUl1t1pV1B7ulDe7F923orhKpm7RokB5RVg/Ko
	+U1D7ADdnUsY4De40jrrHKlFHUoNSbIhgqcSTctUgd7gGm6yM+09SfjJpnFzvt+1iBE1PhincNU
	=
X-Received: by 2002:a17:906:f599:b0:b83:288a:2bce with SMTP id a640c23a62f3a-b84451f1870mr1947368566b.24.1768229498102;
        Mon, 12 Jan 2026 06:51:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGKhlt85YSYPpY/hF5ITXGpTLxb6PAI0j39GqviSICFmscjl6cOBil351MZnv+wZM9aM3V+qQ==
X-Received: by 2002:a17:906:f599:b0:b83:288a:2bce with SMTP id a640c23a62f3a-b84451f1870mr1947366166b.24.1768229497631;
        Mon, 12 Jan 2026 06:51:37 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8706c2604bsm518177766b.16.2026.01.12.06.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 06:51:37 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 12 Jan 2026 15:51:36 +0100
To: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, 
	ebiggers@kernel.org, linux-fsdevel@vger.kernel.org, aalbersh@kernel.org, 
	aalbersh@redhat.com, djwong@kernel.org
Cc: djwong@kernel.org, david@fromorbit.com, hch@lst.de
Subject: [PATCH v2 15/22] xfs: add writeback and iomap reading of Merkle tree
 pages
Message-ID: <bkwfiiwnqleh3rr3mcge2fx6uucvvj2qzyl3sbzgb4b4sbjm27@nw2i3bz7xvrr>
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

In the writeback path use unbound write interface, meaning that inode
size is not updated and none of the file size checks are applied.

In read path let iomap know that data is stored beyond EOF via flag.
This leads to skipping of post EOF zeroing.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_aops.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 56a5446384..30e38d5322 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -22,6 +22,7 @@
 #include "xfs_icache.h"
 #include "xfs_zone_alloc.h"
 #include "xfs_rtgroup.h"
+#include "xfs_fsverity.h"
 
 struct xfs_writepage_ctx {
 	struct iomap_writepage_ctx ctx;
@@ -334,6 +335,7 @@
 	int			retries = 0;
 	int			error = 0;
 	unsigned int		*seq;
+	unsigned int		iomap_flags = 0;
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
@@ -427,7 +429,9 @@
 	    isnullstartblock(imap.br_startblock))
 		goto allocate_blocks;
 
-	xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, 0, 0, XFS_WPC(wpc)->data_seq);
+	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
+		iomap_flags |= IOMAP_F_BEYOND_EOF;
+	xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, 0, iomap_flags, XFS_WPC(wpc)->data_seq);
 	trace_xfs_map_blocks_found(ip, offset, count, whichfork, &imap);
 	return 0;
 allocate_blocks:
@@ -470,6 +474,9 @@
 			wpc->iomap.length = cow_offset - wpc->iomap.offset;
 	}
 
+	if (offset >= XFS_FSVERITY_REGION_START)
+		wpc->iomap.flags |= IOMAP_F_BEYOND_EOF;
+
 	ASSERT(wpc->iomap.offset <= offset);
 	ASSERT(wpc->iomap.offset + wpc->iomap.length > offset);
 	trace_xfs_map_blocks_alloc(ip, offset, count, whichfork, &imap);
@@ -698,6 +705,17 @@
 			},
 		};
 
+		if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION)) {
+			wbc->range_start = XFS_FSVERITY_REGION_START;
+			wbc->range_end = LLONG_MAX;
+			wbc->nr_to_write = LONG_MAX;
+			/*
+			 * Set IOMAP_F_BEYOND_EOF to skip initial EOF check
+			 * The following iomap->flags would be set in
+			 * xfs_map_blocks()
+			 */
+			wpc.ctx.iomap.flags |= IOMAP_F_BEYOND_EOF;
+		}
 		return iomap_writepages(&wpc.ctx);
 	}
 }

-- 
- Andrey

