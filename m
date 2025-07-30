Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8245478F37
	for <linux-xfs@vger.kernel.org>; Wed, 30 Jul 2025 00:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753836730; cv=none; b=X6gEvX951DH6tDPo3RtVwpP3gizcd8X12Or0friOOJ1wOgEL13TIViZQQGKzwP1BKl5k+UmMA2EMp11zz7+UvinGnZ6xUQ1nLRx+0hjbZx1nugI1ZWPf+3TyS84vmQGatuwvHfiZ/9rkhw8FoU1dQNZ7B8LQz0cDtYbd19ViMbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753836730; c=relaxed/simple;
	bh=K55yfrmOAgZyuht6by9RhaCl9tnqxjffX2Sf34/XSXI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nXdmE7AhEPosmNp/A4koqk+lUBYQm3/0ChNR10/hqrQBTgiyLvPVQz+ORoukfiUuAxDISCe5ygPaXT1zVtHl7i7nDRAfcfi+ephKNkCUb2f6fuvKI2JTzNStKf3R33TQ6b0CSa8NkPNqmLVsPmMeDedMZI0jsihxxhC88zjc94U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=DbsWvAkt; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="DbsWvAkt"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-236377f00a1so54871975ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 29 Jul 2025 17:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1753836728; x=1754441528; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q3+0fPD4oAPKgGx3/6LlKQLIWFdF50ERDWtVLnGX0c4=;
        b=DbsWvAktSLQ1q9fV8KALw0+r98lpxiPmqf/2V1w4xB+PJREVmlF/M3lUOj3vb7id46
         MsXaONMIE2c814J8VQzYO9/8W30oHV1GNYDnUsSQ4mIpdrcSDN9W9bsEccKAiBL2LmHl
         41aubhn+Yqr6zsx9DcGCWkF1slzbkIFrFRr7vGXSFHuY6CGqfIe63Ljcn2dptkHBwvpp
         ItcV2cE1PpeaSj6Yq8T7X7/gf7lSV98OY+Xx9fVX9l6SgJPpQbwwpHAOp18Zv6es3X2v
         mVUw41y16xgZsT06zLEmkH12O0JZUpZVgy/+V7LKJv5rab1CLCrqilPq4FJN6cvq8qQL
         xQHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753836728; x=1754441528;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q3+0fPD4oAPKgGx3/6LlKQLIWFdF50ERDWtVLnGX0c4=;
        b=WgYgsOrOBN/BsVnuySgKtgynbS/EwsD45mk8BrzLbuDab9qUP0brqQri+8ybcGHQXm
         tdz5U36jkwjxRVw0nvan83L6sp6u2N/jIDsPrEBrUmRK/1OYIiLoB4u2G2pd32CPwb+v
         5mX53LG7q98YyMo0s8iFkRzuJy0/rClLDOkCz88l4053bbXdf9ccSSa3axrFC3QPS+U3
         7M0NB1Sjr50lh2U2q1FwDIRHXI1K/P3Eio6ggtp48e2I2UijlVN63/7rdQPilCL8HysT
         C7KFW7AYhJpkCGyvmmfLw372cXNNJ/1B2ClIUSK2M5zU0UN/p9IAJxRLhkOPMXXhdQkK
         iL6Q==
X-Forwarded-Encrypted: i=1; AJvYcCWFwBXdXiS+PtTlaa4mtiKj70HMKyD58pxlUY+PMX5iyflUpc5C4NlmBPiQXT9JZMkdGRKek0lIXws=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6d1oDIrCieSzyyVkrkedB2Ycb18cStxFhc7fDf+a/weLnKHMg
	oQ5c2J8AiVFe26+DK1jbc2C/MHPAZoJ57PIOa+iPxdnHBtSKiI07Q0biSXeCoITbvGLsMxN+ZzM
	7N5Yi
X-Gm-Gg: ASbGnct49r+gcyGjnRphRILwQ4iFA1d0NqKnplL5jhOfQs3yAtHHerK49Y5CRbc527U
	OVPqJDWU/u5PYCDquAJwSPDYMfHB0pgliDQJcgQWUjd4QNNFuiYB4cwnyVpMDWexEIjKTDkHIwo
	TKwl90vLyzLCK2U+OaJb3tZfrYwO3x4eeA/ZlAioR1zTzkoPcHxGGWEyejxWdU7FIbUYQ3Bh7U9
	Opgpee7eNq2Cab7SXgrDXKLtJ+yq2LvdWhozOYhdlB56mKueMOyngGgBY30hDX989bwiT0nA2XN
	QJFaMis/qvcwnMiHvKNf2HxN+/l0k9dx+8RD+KR5nk/I0jDNBWK4eNm1A5hW0UetR+m7DMD7Q96
	Pt9CPD5nDAA0Sj4FzZ6j+vohU3tMc/t0Wl+X8wKsMw9SGmm1QtlnsvnHDNs/zLmqEju4rAJZ84H
	8fFCVOhuAb
X-Google-Smtp-Source: AGHT+IHkORekrsc1P7gAq4NM+SMvbGxBMz8RFSwmBgPVjXtpoGecdqjtTizgxax0+6dsRPmU0LGDIQ==
X-Received: by 2002:a17:902:d482:b0:234:986c:66bf with SMTP id d9443c01a7336-24096a4f534mr17428045ad.11.1753836727661;
        Tue, 29 Jul 2025 17:52:07 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-64-170.pa.nsw.optusnet.com.au. [49.181.64.170])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fe648707asm76888805ad.135.2025.07.29.17.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 17:52:07 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1ugv36-0000000HNDV-0H38;
	Wed, 30 Jul 2025 10:52:04 +1000
Date: Wed, 30 Jul 2025 10:52:04 +1000
From: Dave Chinner <david@fromorbit.com>
To: Tony Battersby <tonyb@cybernetics.com>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-raid@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] iomap: align writeback to RAID stripe boundaries
Message-ID: <aIlstOWckYGw34rM@dread.disaster.area>
References: <55deda1d-967d-4d68-a9ba-4d5139374a37@cybernetics.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55deda1d-967d-4d68-a9ba-4d5139374a37@cybernetics.com>

On Tue, Jul 29, 2025 at 12:13:42PM -0400, Tony Battersby wrote:
> Improve writeback performance to RAID-4/5/6 by aligning writes to stripe
> boundaries.  This relies on io_opt being set to the stripe size (or
> a multiple) when BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE is set.

This is the wrong layer to be pulling filesystem write alignments
from.

Filesystems already have alignment information in their on-disk
formats. XFS has stripe unit and stripe width information in the
filesysetm superblock that is set by mkfs.xfs.

This information comes from the block device io-opt/io-min values
exposed to userspace at mkfs time, so the filesystem already knows
what the optimal IO alignment parameters are for the storage stack
underneath it.

Indeed, we already align extent allocations to these parameters, so
aligning filesystem writeback to the same configured alignment makes
a lot more sense than pulling random stuff from block devices during
IO submission...

> @@ -1685,81 +1685,118 @@ static int iomap_add_to_ioend(struct iomap_writepage_ctx *wpc,
>  		struct inode *inode, loff_t pos, loff_t end_pos,
>  		unsigned len)
>  {
> -	struct iomap_folio_state *ifs = folio->private;
> -	size_t poff = offset_in_folio(folio, pos);
> -	unsigned int ioend_flags = 0;
> -	int error;
> -
> -	if (wpc->iomap.type == IOMAP_UNWRITTEN)
> -		ioend_flags |= IOMAP_IOEND_UNWRITTEN;
> -	if (wpc->iomap.flags & IOMAP_F_SHARED)
> -		ioend_flags |= IOMAP_IOEND_SHARED;
> -	if (folio_test_dropbehind(folio))
> -		ioend_flags |= IOMAP_IOEND_DONTCACHE;
> -	if (pos == wpc->iomap.offset && (wpc->iomap.flags & IOMAP_F_BOUNDARY))
> -		ioend_flags |= IOMAP_IOEND_BOUNDARY;
> +	struct queue_limits *lim = bdev_limits(wpc->iomap.bdev);
> +	unsigned int io_align =
> +		(lim->features & BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE) ?
> +		lim->io_opt >> SECTOR_SHIFT : 0;

i.e. this alignment should come from the filesystem, not the block
device.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
