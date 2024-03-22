Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93E18005F
	for <linux-xfs@vger.kernel.org>; Fri, 22 Mar 2024 22:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711145097; cv=none; b=n46FD5e7Q118aCtjfb9Q3Lv63wSo97dTvNLY+r8n70pDMxXjRDSqHE48YWvcsqsO+D0Ou4RkO9sNdgf3Vtfc3Z/aJ3cgxvKHJel0tsbBaRPpm9FyCXTweN+q5Pz25pqqRwWRyh/R0WT5vqb8Waw+x/wFSgoHrSzg1g7pSAjfquU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711145097; c=relaxed/simple;
	bh=VPnIzYQ18efx114E4Rz3PKlQHlrm10Dwua+eiA/dj/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C2Z8dFskNLfcxkGTYg5VssxKi52qG2xVOkAHd4HgUtXSEo83puZuJd5doAR2zbU0a7IfOk7D3Js89YFee2OM6xU6PrrADJuOBTV+YHR8IYm5Oo+UQ7s3r13eAXh/1arkjF+0i3gDwDwcmBjWc8vdFKkn1eu/okg6HOVdBOD9VHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Xn7PRXZG; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Xn7PRXZG"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1def59b537cso16764065ad.2
        for <linux-xfs@vger.kernel.org>; Fri, 22 Mar 2024 15:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1711145095; x=1711749895; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1dp8cZQqp0klZ2XhfoqAxx301d6PkJpSESOS4pWeyPA=;
        b=Xn7PRXZG108RcVvhHnrZ4nJgFajGTfM+UEqz8u0nccYReUdlTArUPR4KuWo265J2L2
         3H/wcZKnDh+VwCp2bxP0MahQFF4/Thpg9h2Kn9YQJM70WezZa81XCByaN3CEKseeOF+v
         bBeyvue4CxQkJvG2o6ekpuTCIhHpWtukMMfGHwpIvOLRbBf5PRssidjYDjQOYgK8Xy7R
         63jQ63M1bOBD46FOd2Bd/qinAFNSbCqV7u5e9+06JWj8WidiVp5oLYaxE9pKBCfwr0W4
         Auw0qkSoSy677uccZUTEe10uozSe9Xe+tlpHG/zBWhIE9tY2YIoRVTB/L2KrnZbQRgY+
         v8/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711145095; x=1711749895;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1dp8cZQqp0klZ2XhfoqAxx301d6PkJpSESOS4pWeyPA=;
        b=Sms8VwKHC912wSCoBe1iMicvxsEpZzymhNQLbgfgsG6Rr0leitYrRLbMIcRYt+HMMW
         BIaimlGD4aAnYIDEwipHQE61zU054RgN1qjevdIjCwZWlqSi2cOhsu06x5s1UI84LTO5
         Ii5xreHWoJJllEzceUAMgOUNxkOBEEKdQ2ta6UfhKWZq0telZLCdV5MJDkMJOVBw/dU3
         lvsHwmwFkZpt+eV39mYJa4sJrJUS9iGUx5fRKgdi04n5junIcFRhqOm+gvLzFWxfjGjU
         osOQccVKUfAh6h97mbtOqEjXunrotTf9x/NT7GwwSJHjdUzc1QUV3PqumHogAPL7Qfl1
         hOLA==
X-Gm-Message-State: AOJu0YzSD2sFQ4rtSom7Z35gxl8lly5xuPgoSFfQ1f0acDRZUaKG6kam
	CXw2MS/lAhblw7lTvFish3IzYuHLT0HGZTdHjfzwMtxGjC4GuEV1q0o6aS3JwRhpEHjqAN9kEsd
	L
X-Google-Smtp-Source: AGHT+IFBtRtNSAak1OniN3Gbwf03qHgKALZgTmzPJxd91RjiXL3DxHTd06asDW/wiNIQ3uyN6kpuuw==
X-Received: by 2002:a17:903:186:b0:1dd:bc31:e9e3 with SMTP id z6-20020a170903018600b001ddbc31e9e3mr1276473plg.56.1711145094794;
        Fri, 22 Mar 2024 15:04:54 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id l21-20020a170902d35500b001dd6958833esm228757plk.242.2024.03.22.15.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Mar 2024 15:04:54 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rnn0N-006Vov-2k;
	Sat, 23 Mar 2024 09:04:51 +1100
Date: Sat, 23 Mar 2024 09:04:51 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: convert buffer cache to use high order folios
Message-ID: <Zf4Ag349VrT/kv8n@dread.disaster.area>
References: <20240318224715.3367463-1-david@fromorbit.com>
 <20240318224715.3367463-4-david@fromorbit.com>
 <wa53es767xeoxleltokuhcn5kccv5h2ocys37qqblpbplox2dc@36hvu3j6z5py>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <wa53es767xeoxleltokuhcn5kccv5h2ocys37qqblpbplox2dc@36hvu3j6z5py>

On Fri, Mar 22, 2024 at 09:02:31AM +0100, Pankaj Raghav (Samsung) wrote:
> >  	 * Bulk filling of pages can take multiple calls. Not filling the entire
> > @@ -426,7 +484,7 @@ _xfs_buf_map_folios(
> >  {
> >  	ASSERT(bp->b_flags & _XBF_FOLIOS);
> >  	if (bp->b_folio_count == 1) {
> > -		/* A single page buffer is always mappable */
> > +		/* A single folio buffer is always mappable */
> >  		bp->b_addr = folio_address(bp->b_folios[0]);
> >  	} else if (flags & XBF_UNMAPPED) {
> >  		bp->b_addr = NULL;
> > @@ -1525,20 +1583,28 @@ xfs_buf_ioapply_map(
> >  	int		*count,
> >  	blk_opf_t	op)
> >  {
> > -	int		page_index;
> > -	unsigned int	total_nr_pages = bp->b_folio_count;
> > -	int		nr_pages;
> > +	int		folio_index;
> > +	unsigned int	total_nr_folios = bp->b_folio_count;
> > +	int		nr_folios;
> >  	struct bio	*bio;
> >  	sector_t	sector =  bp->b_maps[map].bm_bn;
> >  	int		size;
> >  	int		offset;
> >  
> > -	/* skip the pages in the buffer before the start offset */
> > -	page_index = 0;
> > +	/*
> > +	 * If the start offset if larger than a single page, we need to be
> > +	 * careful. We might have a high order folio, in which case the indexing
> > +	 * is from the start of the buffer. However, if we have more than one
> > +	 * folio single page folio in the buffer, we need to skip the folios in
> s/folio single page folio/single page folio/
> 
> > +	 * the buffer before the start offset.
> > +	 */
> > +	folio_index = 0;
> >  	offset = *buf_offset;
> > -	while (offset >= PAGE_SIZE) {
> > -		page_index++;
> > -		offset -= PAGE_SIZE;
> > +	if (bp->b_folio_count > 1) {
> > +		while (offset >= PAGE_SIZE) {
> > +			folio_index++;
> > +			offset -= PAGE_SIZE;
> 
> Can this be:
> folio_index = offset >> PAGE_SHIFT;
> offset = offset_in_page(offset);
> 
> instead of a loop?

It could, but I'm not going to change it or even bother to fix the
comment as this code goes away later in the patch set.

See "[PATCH 7/9] xfs: walk b_addr for buffer I/O" later in the
series - once we can rely on bp->b_addr always being set for buffers
we convert this code to a simpler and more efficient folio based
iteration that is not reliant on pages or PAGE_SIZE at all.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
