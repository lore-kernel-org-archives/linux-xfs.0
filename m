Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B981718046
	for <linux-xfs@vger.kernel.org>; Wed, 14 Aug 2024 01:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723600436; cv=none; b=NXGOp3yDhtopd1lNMkwEr5rTc25Od6NpZanlCTRLkmqpwKrbGALQi8hyx/6rWDBcTBMqIHwet/dFNQcaxVYygliACxaE17SOGv9wuq+6pefXqBUF5rlcAfJ4k0wwMslhaneSmPBHdm+fK8MINnCyDjXloBTs3+DkEFEfIEqMcmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723600436; c=relaxed/simple;
	bh=ImkM0Fj29IiRsr39SG8TAvHe/Ulm1sWPB60PjrAVgeM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ljUdCcSgdV0jIyt/HdKo+0FW40iGzrm0Bh1qYFPiuUAGEIu1xGIx51PkUHy2OO1JC7MKypj+ImMKGW2wrmMKZlJ//6ySq1n6sU+EZe2NwbeblO+RDZyCUQWDZ6e3ZJeMhzommX27oUQMiV7NzNJREs57i3U3p/0xoGaja8dkFqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=G1BZsCnW; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="G1BZsCnW"
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-5d59e491fefso2989450eaf.1
        for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2024 18:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1723600433; x=1724205233; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uP5npEFHKUYX1HGah1Ur7zuistj13a/fnUU2B8UEJz4=;
        b=G1BZsCnWXb6iTHboe4kgO1PqKe+8udvCiiXlfgAZtVRdOo30XN9qeescKtcBGmD7+1
         SPefIv7/bzDoGFwAuNDgOG9cRspJacnyDnJQnF/3mINrKmu8plFRUn8FMvokyTtusp+8
         EdhdHK2pPKSQVX4eQsCWhasC14R3Qyk0+xHwcEJvMW8yontw0U8VYZSQxLjEr2AWQrWO
         ITeTj0ucIUAUg20ucqW7Yz6CLd+wX3qaReWhuxOTgK7ZsSXYmNVjZ7FPQxnnAp1Cr6vl
         O9oqFE7lDfbs/YwPqn89K7TG7nP1/ZrjbFaYb53Jkh+i6ZTPj/n/F/GLH9C0I9lq9sLy
         HkIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723600433; x=1724205233;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uP5npEFHKUYX1HGah1Ur7zuistj13a/fnUU2B8UEJz4=;
        b=croQev9kX3P7gQQF2AxFsjwqC5BLNAh3DRTemKRcqAOT2s687mEk00UydoBpkZshtf
         Ko7vcjq/O6Klmnii+z36sXoqYNpC3wmxTRKfb0F+U+cQnq1iDLAQTIkyucQpu2qk9wI3
         CmIWjIWixtlS2V7Y5r1W19EjhddZzmDVqDOXJwrni2ZCPZpVBeB48c5ELfqiPTMCl3AL
         Sq42On6gqR7TJ9xBQCwUI1c7A1Q2AImh2EU3c65KPIHhv8l8p4FXtEzRBWkycjRWCwsj
         b2L1+Yr7BVf5B3sE6NjrzybfB9m/GqXSyMbGlMOqP1QOtefzkLVlvVpfMsp6WFPwtDNc
         oV0A==
X-Forwarded-Encrypted: i=1; AJvYcCXxvNy9bjPWth4ecM4Fk7YUN8Z5R/KMeWNpM2KBleRKzLJmiM4jKqdr1Y9xwH7FJyEsGUGsMdm9JqLc921F+qH8nSt6r61tZRcP
X-Gm-Message-State: AOJu0YzwNOQunElaIGmv2WP3vErOw6fOG+RHQJM72N0myEgPuXdqmZ65
	RcbLHzqFQD1y5jBfyHQC5fxq4YAXg8QcJe8ydzz58TPMWkQGsa3TODPRKhQJa7A=
X-Google-Smtp-Source: AGHT+IGcOCqnz24yZ059r/sx5H4UihWOY1sEtpyhHgGkV1SGFCgbM9c4AL6s3Md1QAwJZFEMNB1wOQ==
X-Received: by 2002:a05:6871:e014:b0:261:22a4:9235 with SMTP id 586e51a60fabf-26fe5be0521mr1437259fac.32.1723600433574;
        Tue, 13 Aug 2024 18:53:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-710e5a438a4sm6341175b3a.108.2024.08.13.18.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2024 18:53:53 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1se3Cv-00GGrZ-1g;
	Wed, 14 Aug 2024 11:53:49 +1000
Date: Wed, 14 Aug 2024 11:53:49 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zhang Yi <yi.zhang@huaweicloud.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	hch@infradead.org, brauner@kernel.org, jack@suse.cz,
	willy@infradead.org, yi.zhang@huawei.com, chengzhihao1@huawei.com,
	yukuai3@huawei.com
Subject: Re: [PATCH v2 1/6] iomap: correct the range of a partial dirty clear
Message-ID: <ZrwOLcnPRGUrnSTS@dread.disaster.area>
References: <20240812121159.3775074-1-yi.zhang@huaweicloud.com>
 <20240812121159.3775074-2-yi.zhang@huaweicloud.com>
 <20240812163339.GD6043@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240812163339.GD6043@frogsfrogsfrogs>

On Mon, Aug 12, 2024 at 09:33:39AM -0700, Darrick J. Wong wrote:
> On Mon, Aug 12, 2024 at 08:11:54PM +0800, Zhang Yi wrote:
> > From: Zhang Yi <yi.zhang@huawei.com>
> > 
> > The block range calculation in ifs_clear_range_dirty() is incorrect when
> > partial clear a range in a folio. We can't clear the dirty bit of the
> > first block or the last block if the start or end offset is blocksize
> > unaligned, this has not yet caused any issue since we always clear a
> > whole folio in iomap_writepage_map()->iomap_clear_range_dirty(). Fix
> > this by round up the first block and round down the last block and
> > correct the calculation of nr_blks.
> > 
> > Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> > ---
> >  fs/iomap/buffered-io.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > index f420c53d86ac..4da453394aaf 100644
> > --- a/fs/iomap/buffered-io.c
> > +++ b/fs/iomap/buffered-io.c
> > @@ -138,11 +138,14 @@ static void ifs_clear_range_dirty(struct folio *folio,
> >  {
> >  	struct inode *inode = folio->mapping->host;
> >  	unsigned int blks_per_folio = i_blocks_per_folio(inode, folio);
> > -	unsigned int first_blk = (off >> inode->i_blkbits);
> > -	unsigned int last_blk = (off + len - 1) >> inode->i_blkbits;
> > -	unsigned int nr_blks = last_blk - first_blk + 1;
> > +	unsigned int first_blk = DIV_ROUND_UP(off, i_blocksize(inode));
> 
> Is there a round up macro that doesn't involve integer division?

i_blocksize() is supposed to be a power of 2, so yes:

/**
 * round_up - round up to next specified power of 2
 * @x: the value to round
 * @y: multiple to round up to (must be a power of 2)
 *
 * Rounds @x up to next multiple of @y (which must be a power of 2).
 * To perform arbitrary rounding up, use roundup() below.
 */
#define round_up(x, y) ((((x)-1) | __round_mask(x, y))+1)

-Dave.
-- 
Dave Chinner
david@fromorbit.com
