Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E346F3E6DF2
	for <linux-xfs@vger.kernel.org>; Tue, 14 Apr 2026 13:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776174825; cv=none; b=Hop12aqSHy4A8LNuTkw6lVI49+nFOmCbDmqrHSL1xQ1YZvYObxFwz3f+8ck2C0d8qdjXbm7KEXudXgrqrOzqgQaQQ1XYngP1LeEViqKqI7TS38E1/lX4DseuubCoFvUdFCIQWD0uwzenkXc1vM3VY8zZYTH9te9FxeeOEfXfJoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776174825; c=relaxed/simple;
	bh=zqDrKV4/Tx3b7Hkm4HZGlLUnVsA7Xl9FQkWdRSU4yPE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i+xLWL7CF+gJ5aLbwTnCYqXbdUL4SFYnStvYyt0xhF+oNp33puezaujRsj57ujwL6E5BaQ2KDtvaMFB9o7uyW6bwxBkwWXWhA0OgtFs6wiz4YDSefx7RHieXios5ZBDZfgKAOU54TNFVXm1r30Wze5s7YahXG76ExuX/DX9toNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SBNKXcuu; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=CVoH5aN4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SBNKXcuu";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="CVoH5aN4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776174821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YY1Mbdcw/s+c+i+V6kA9q5Q93RsUlrrtxkE/+YiJlwM=;
	b=SBNKXcuuXicvW3yBITJHxAHD0uZTxX2YPH8/wZAImg5DK3UOiC9qaZs+yRvvypbdqbwoxW
	6TmsIIrvuL7WTloLVdi1ZDO2H3Tbu89T6ywkvT2YhoEmUaPj+zswo17Rhgym3pjNojguGy
	td2LhwZCnqAy2GnvJcb5yHtO8S9ZioI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-367-80mf9br0PfSRxDhlbRLwpQ-1; Tue, 14 Apr 2026 09:53:40 -0400
X-MC-Unique: 80mf9br0PfSRxDhlbRLwpQ-1
X-Mimecast-MFC-AGG-ID: 80mf9br0PfSRxDhlbRLwpQ_1776174819
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-488c74405ecso34916955e9.1
        for <linux-xfs@vger.kernel.org>; Tue, 14 Apr 2026 06:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1776174819; x=1776779619; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YY1Mbdcw/s+c+i+V6kA9q5Q93RsUlrrtxkE/+YiJlwM=;
        b=CVoH5aN4DpoqApDooihL61VKCQD7mFM41Zitzeq66vznwU7tOa1d0XKtW1LNO7l/D6
         BD1tUII0Sn8Sx9hKw4JwImDScNyL7HvnQY7B5m96+UEnBoaYZhGh7BUN2r9rGIrVxwYT
         xl/wAi88G9UPbLpmmTLE56vRZ0BflAYcrVNeQppN9jY7vE1RaMVCgAu3P16WXb11BA/p
         UpdTomNoWia9jThlVsAodPz0nTh3Dti64QlGuXrjuevNS4YnONfP9+svmi9AsHEc51gG
         8c6IoA9x/Y60mwKYHdTYrPobJgu2A8FYj/fii1Q6kKO+8/gNZ9DwAWxGohbvHqR0oqA9
         OdRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776174819; x=1776779619;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YY1Mbdcw/s+c+i+V6kA9q5Q93RsUlrrtxkE/+YiJlwM=;
        b=EDbFmZo/QdvBYkYJXJTXaUkfxWMT6EMSHiwrDDOUk55Mk0g822YSqQx1lw1+ykYllS
         8fPnPt69sFHhaHzq04JShNl5r55rCJyhEtrZK9zLAGcg88eabyad9LSA3KmZFMcJ8EsG
         m8Va4t4g12IZuzKzhyAPVPEog/MEh6qt29LQb4nRPOe9WBSqtY9eFuDTcL4Yfs5QCD66
         N36S8/XTkGOy6usI3VFNI4wtL1dNVcTxqqTnkOH8ndyUtcu3R/QEd2MsCen7qHOC5Hfl
         KAYE0xmi0PXx7yT/z8PBZN7S/AQLrc36qvWd4WUckWEw0Qv535cFVAPm9hw1S2qXJDAg
         mTwg==
X-Forwarded-Encrypted: i=1; AFNElJ8HGzrKxv1wC8XueyqweYXxSUlpz0b2wBJ43mB4l7BwKmRaNn6NdnuA/BOzMtUSFT7gSiEljfRUjc8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFiL4wJSIq/RnboLBPOuN8d912NTjSsJBJmwddM9Y+IVBFvgFn
	bilpiFiHIwaQ0lSFDDvTsrW5KjgV2VufU1eFZgpbBjYqvFjV/vZSQ42Yr7dplfhsbAvrnB+jleq
	5bO//fP4fwLhWkO6tAz8qHW9EQhqRKbI7ToM7OeUBSe2wuqJrMm8o39XOWkc7
X-Gm-Gg: AeBDies/f1z2J94FiVxO1SF5fG//qMt3TVm5at9x99QfmIP3lhhSp6HwA01znfF0dxf
	aI2udxqM7gYFnAidddb9Dt7+kaz44D67rkrrxcDJ9Ei/YlxiehF+um2o4GbGzNNOkvuHj0Q8Yb6
	8zZcZ07Id4leBRsfgWEngc+3wBfY2SjoGHDB713u8mqGiVJJHsmArn/qVJfigiK3IVTS/G2A+Oi
	OSgtV/mVFPQUl9tirzx6+rSAXXcAOLgDLzarTTnMRDLeQ0HjJtGhm8qsH0FtzFreiaIat+OTPRA
	pbl0VLQmYL1m0S6Vk/KS+w/lBAbri8E2FljKvoLRzE+TfSllByYyf7iYL2ni2QrILGpghkOeS35
	Cq7OLj5XDXOJw7A==
X-Received: by 2002:a05:600c:a109:b0:477:76bf:e1fb with SMTP id 5b1f17b1804b1-488d6843245mr171916575e9.16.1776174818769;
        Tue, 14 Apr 2026 06:53:38 -0700 (PDT)
X-Received: by 2002:a05:600c:a109:b0:477:76bf:e1fb with SMTP id 5b1f17b1804b1-488d6843245mr171916275e9.16.1776174818293;
        Tue, 14 Apr 2026 06:53:38 -0700 (PDT)
Received: from thinky ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d5cfeb2dsm124119015e9.0.2026.04.14.06.53.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 06:53:37 -0700 (PDT)
Date: Tue, 14 Apr 2026 15:53:36 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v7 03/22] ovl: use core fsverity ensure info interface
Message-ID: <u3szxuhjrv7vyxwyrepuflwhzeucss7xj3cxj73mnpm5kal2da@jck24ig4oxxa>
References: <20260409131404.1545834-1-aalbersh@kernel.org>
 <20260409131404.1545834-4-aalbersh@kernel.org>
 <20260414081301.GB11138@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260414081301.GB11138@lst.de>

On 2026-04-14 10:13:01, Christoph Hellwig wrote:
> On Thu, Apr 09, 2026 at 03:13:35PM +0200, Andrey Albershteyn wrote:
> > -	if (!fsverity_active(inode) && IS_VERITY(inode)) {
> > -		/*
> > -		 * If this inode was not yet opened, the verity info hasn't been
> > -		 * loaded yet, so we need to do that here to force it into memory.
> > -		 */
> > -		filp = kernel_file_open(datapath, O_RDONLY, current_cred());
> > -		if (IS_ERR(filp))
> > -			return PTR_ERR(filp);
> > -		fput(filp);
> > -	}
> > +	if (fsverity_active(inode))
> > +		fsverity_ensure_verity_info(inode);
> 
> fsverity_ensure_verity_info already is a no-op for !fsverity_active,
> so the check could be remove.

I don't think it is. For non-fsverity inodes it will try to call into
descriptor reading callback and fail.

> Also we should probably propagate the
> error return from fsverity_ensure_verity_info here.

oh right, thanks!

-- 
- Andrey

