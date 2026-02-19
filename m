Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6169F2EB87E
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 12:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771504077; cv=none; b=eun9+umRu4TJOiqa1QNFALzc1b6D9/jtaXoxoE2p8ROrU3D5r0mh/tOX9ujrt/fGSg1yllBPu/DesCOMGRobBtErAIp5QO2uvUERRKV6Cf0RKmxoQdOUh8ICNmItzbAfCNWMpztS9RXYMh4nDu40z5VgO+cjK8iCue4Q8UwLswQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771504077; c=relaxed/simple;
	bh=EDx8FryHxIAZRwRNlicUl1+uu9x6LbeOBuYZocMQ30I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qNoS9CGE+HzACaJaGSekGUpeyvWsdcOi/0glZOaFHswCKMMWBm1qNcbfAjyg4ePtmZnT8+dZW57y85p1EKlPpxJ5BDyVTsErV+LdpVVpLQW3c7ZYzI2Hw3KjmhrJldHJBohOQ5ZGdR0iNe72n9OzwF84UT7YusMWVvWsxdz0jgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NuVIh1LF; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=doShqaY8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NuVIh1LF";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="doShqaY8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771504075;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LCXhggTxc1o7a68agx3rWoCqxTRmf4Yj32SklYi3Ezs=;
	b=NuVIh1LF3INVOhDu7ub+SLf4HZk31F32gMpnLMO/1mMNU0mU9vX2YogcGuyzef4FS7nIta
	0wSumR2zgYdpQTj7sEMkwg2ueGCz7Lzweb1Ji6nB+huVYHYg4owcGJ37u/BKsOVVqYA5h3
	BG1ViygKF18/QV9fOFKPG3mLoJuvLnI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-hy1A0_lcMiePX9ox8tQ21g-1; Thu, 19 Feb 2026 07:27:54 -0500
X-MC-Unique: hy1A0_lcMiePX9ox8tQ21g-1
X-Mimecast-MFC-AGG-ID: hy1A0_lcMiePX9ox8tQ21g_1771504073
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-4363333c102so680995f8f.1
        for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 04:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771504073; x=1772108873; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LCXhggTxc1o7a68agx3rWoCqxTRmf4Yj32SklYi3Ezs=;
        b=doShqaY8X5G1zQ1Gbw7oiKlp7sVhboZsHKJyz1XI6nKF3gQSpUFkCTyRFwUx7Ncnnj
         Lxe0dqd8AiqQImVio0LuS6JJoeoP66l7hxhd6eoS2l6FHN594SZvNvUkEWI3KNLJHS90
         e3rwiR2VhRwo4kEn0YQ4wg6pCW2xnHD4LdZIqn9mPFmCwksAm+2D3R16fHk7iI+fdKpM
         TweOowdc+81oM4QckO1ejdByYKv5QkRB2T9FRcJwN/PkVFpXIPX0MefCih3c+VcNEJJu
         dj/ROZFMdD0FZzA1zUok3Uh/1weXqJ4F5+6Ud/9Mr/AQYoXTV7oyfIWqrWyJYHnXeYGh
         y1VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771504073; x=1772108873;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LCXhggTxc1o7a68agx3rWoCqxTRmf4Yj32SklYi3Ezs=;
        b=gX964X5GpRIaTxCVCF9dqebDWIP+iWs6yupBaqsCuzu6NRUkxjK9q1Tnw7ETqMxJbN
         x6u06dU9Xm2iYJdLHD7t6zG7LCpAU144r2fiK2wpb36Pnszp0W9HeOAgwFMTTpMkjdnh
         w8PmuSAVu4QkUhlbJfmHqcbgtX7ff5ctNQ+GJdUDKFBrCWXsoI26aKf93rghmLHC9UBQ
         pLKO57Irk6A/74XcIPMaSmodjF36g8WFO1T6W+gYPkGD5XA0g5AkLKpOw7Ts/486tvwL
         P8jUi1XxLG8YfV45jMW4h0flvWNBg1XQChmP2DuE5F1g8hiDXQQJ99WvOfpsN6Vp1AOd
         8h2Q==
X-Forwarded-Encrypted: i=1; AJvYcCVzmhVc0QlD6A9uDu8JmTEPaXHXyN1cZvM3ZxPLkA0VM1sz4Xv38appggrhL+9CUXJLQgRV9lwCF2A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yykn8H4wByHwbxE389kfOcJZ4DMm/rIaaHvYXg9lw+iVq7t1A8j
	ooxg2hckLhFYASGL6UBz7gcPVlzUiSufqdLvsuTe59QEXbrRG1H9/WWVw36gZ32FiUM/pGHLicd
	boszIMUQ+knsL4188Btd+9krnDyhA3nhQU9gLQZYamLJXi0D9twpezE0642bX
X-Gm-Gg: AZuq6aKxn20aJGkEp3Y9SyCGPe253XsuU3Lf4m+BCf/jkvAvy8tQLblro6/8nB5WpIF
	3mW9VkbTug/1RaKai0zNZmJW6ZR8cvzxR0CAJ7V3VoTd62V1JSAugDuiLa3kyF/O/+ePSV1COfN
	p4nnlAJmYdz7BawjuuUJVF6FUmbKa81m/i8aF4W5+QiWBlTieLdDquxE6hgpqQ1xkAcaKk6X2e6
	UKp13o3MmcMNvdRVPDe2I7EURtwW5ZjwRmJITorSzf+ITwntAvxkIkniZ07PmfIuDrvT3tpmO/A
	AZ5kzm7ZBM3u6glBMWem+JCTKGKRA7VjllO/6Ec+Iuy3X+91ALXB9CDCke3jPClCWGq9O9y8plU
	jW5J85dnNevE=
X-Received: by 2002:a05:600c:3f0e:b0:47a:7fd0:9eea with SMTP id 5b1f17b1804b1-48398a42840mr90767005e9.3.1771504072820;
        Thu, 19 Feb 2026 04:27:52 -0800 (PST)
X-Received: by 2002:a05:600c:3f0e:b0:47a:7fd0:9eea with SMTP id 5b1f17b1804b1-48398a42840mr90766495e9.3.1771504072258;
        Thu, 19 Feb 2026 04:27:52 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4839f985e4asm17268675e9.20.2026.02.19.04.27.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 04:27:51 -0800 (PST)
Date: Thu, 19 Feb 2026 13:27:51 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de
Subject: Re: [PATCH v3 08/35] iomap: don't limit fsverity metadata by EOF in
 writeback
Message-ID: <oecxvzv56qk5qnlf2e4dwaaeyeyvpautlqfqnozurplikewopw@q7y6toosmyed>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
 <20260217231937.1183679-9-aalbersh@kernel.org>
 <20260218230504.GG6467@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260218230504.GG6467@frogsfrogsfrogs>

On 2026-02-18 15:05:04, Darrick J. Wong wrote:
> On Wed, Feb 18, 2026 at 12:19:08AM +0100, Andrey Albershteyn wrote:
> > fsverity metadata is stored at the next folio after largest folio
> > containing EOF.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> 
> I think this should be in the previous patch since writeback is part of
> pagecache writes.

ok, sure

> 
> Also, should there be a (debug) check somewhere that an IOMAP_F_FSVERITY
> mapping gets mapped to a folio that's entirely above EOF?

I rewrote it as below and added 
	WARN_ON_ONCE(folio_pos(folio) < isize)

-- 
- Andrey

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 4cf9d0991dc1..ef9a5f542354 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1746,13 +1746,21 @@ static int iomap_writeback_range(struct iomap_writepage_ctx *wpc,
  * Check interaction of the folio with the file end.
  *
  * If the folio is entirely beyond i_size, return false.  If it straddles
- * i_size, adjust end_pos and zero all data beyond i_size.
+ * i_size, adjust end_pos and zero all data beyond i_size. Don't skip fsverity
+ * folios as those are beyond i_size.
  */
-static bool iomap_writeback_handle_eof(struct folio *folio, struct inode *inode,
-               u64 *end_pos)
+static bool iomap_writeback_handle_eof(struct folio *folio,
+                                      struct iomap_writepage_ctx *wpc,
+                                      u64 *end_pos)
 {
+       struct inode *inode = wpc->inode;
        u64 isize = i_size_read(inode);
 
+       if (wpc->iomap.flags & IOMAP_F_FSVERITY) {
+               WARN_ON_ONCE(folio_pos(folio) < isize);
+               return true;
+       }
+
        if (*end_pos > isize) {
                size_t poff = offset_in_folio(folio, isize);
                pgoff_t end_index = isize >> PAGE_SHIFT;
@@ -1817,7 +1825,7 @@ int iomap_writeback_folio(struct iomap_writepage_ctx *wpc, struct folio *folio)
 
        trace_iomap_writeback_folio(inode, pos, folio_size(folio));
 
-       if (!iomap_writeback_handle_eof(folio, inode, &end_pos))
+       if (!iomap_writeback_handle_eof(folio, wpc, &end_pos))
                return 0;
        WARN_ON_ONCE(end_pos <= pos);

