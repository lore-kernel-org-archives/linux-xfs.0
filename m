Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B01E1B27D
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709001454; cv=none; b=lo59AQoYLU+09YqFuusigdRbIB52rYtS0Dzqf6Ee8hvZkcYvAdBAOWQZT8KRMBkwBS+VFIqMsJsy3ugcTAcCTuzp43mSQkeJmao6dRMR3M26B80YZkOVibmv9TSx/UejMrXsDFEzloxrS+rPyJvp4Tivbn+D+v0/EEMc6uAg1Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709001454; c=relaxed/simple;
	bh=L15phMYx1T1sLT6YH3Us7F/LMTP6M6dzkqxIWCItvpk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qPrLIsgnzhA5JV6hbYwGvvv0NpsVc7wBxvt5orAQIeWcNYOefONU1BrFGo02EfoPlXfKMF12dsSC889EDKE3u/W1XwD4Lk/gXWViDqaHZEfqITdk73M3PLq6psQROSwPXfNcHZCfwxoyiUT87NGwQ7SLOkyXdV3lEPBvjzoIq3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=v3KiYK7M; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="v3KiYK7M"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-299e4b352cdso2820953a91.0
        for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2024 18:37:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1709001452; x=1709606252; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/qPV42Y8ErRmVB3z8WrFoN60gZU4anj3wlnwq2ahzmc=;
        b=v3KiYK7M8Zd21+U1w/JhWM/cgGW2+qdwJGNIzoyyrKvra4wdn1ke+pb0hlEsAdeSfS
         YNhp+T3HN2fXUwTfCDDFujaN+Zpn7f0xWorjp2WKpTx0tKxBfT09w3YTBFep1CGqfLbF
         wddJCknX6pflpqY2gqHMm3wEvTRLdQ2GGyLj7k7A/C/aMcFmUOxVHLjIHJ4+tGDKraT4
         d833Eoi3ux/uyDyIM6be/ClxsR+VNwVDP6UpsK1QqHjNO31HyRWIxBfK4517gQ/iMYEA
         6aCGU9TlfxLJEoDcLREEzrE17/LQ5piurG9EAESwa3nLgp33wuLZRw9R76WCLGZzHEjE
         exVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709001452; x=1709606252;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/qPV42Y8ErRmVB3z8WrFoN60gZU4anj3wlnwq2ahzmc=;
        b=ZacRznP+mwbj1ggrzjoyXec6PvuB2CQK2vEGXpBToqe6ewZwyH2kZccbjlxVNxnkzs
         u3RBrJR+f0FViYCpKRaK24217+iqWtUCFxkIn61GZTn62qarq94ossk0CYcp7N3z2xYc
         /rmkD8AuPVIRq3cJq7AjQ3W3yan4ns97bc7WR+i/MLP+1GFyTUuYwNTJHIqvQfBY4HI5
         5sZMf0Fhnlberen/5umXe6KgnKGqYxXs4sSoKLXLkVX/xV4IAvIPIcgSPDTfH5jweU5m
         cOGkZ5AQKy/S2mcAeS/PU3eOjnswRzBGPdh5tw94PHFUlE11DITu9IwuFr9uhRkzPtx7
         2lrQ==
X-Gm-Message-State: AOJu0YydmGwz6bERIF755c4A7ptQLQ5Crk7SCg4pA8qMNsL25PZbNj85
	c1Eemtqe4mZ5D4Amtcm/SgxY1cT+CIE2csIT19GP26NmE3RVh3XhBl14XYZ6eJm/1JoVSGPqQEL
	e
X-Google-Smtp-Source: AGHT+IGmmYKKyDS5rKxOePbm8rdT5hdwnDpia4kgWK9nE2GgygFc89lRzpBW402DURYzino6oqq73w==
X-Received: by 2002:a17:90b:4d92:b0:29a:ce2b:7611 with SMTP id oj18-20020a17090b4d9200b0029ace2b7611mr2793394pjb.28.1709001451759;
        Mon, 26 Feb 2024 18:37:31 -0800 (PST)
Received: from dread.disaster.area (pa49-181-247-196.pa.nsw.optusnet.com.au. [49.181.247.196])
        by smtp.gmail.com with ESMTPSA id p1-20020a17090ac00100b0029969cc66f2sm5146381pjt.48.2024.02.26.18.37.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 18:37:31 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1renLU-00C1P5-2t;
	Tue, 27 Feb 2024 13:37:28 +1100
Date: Tue, 27 Feb 2024 13:37:28 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, chandanbabu@kernel.org
Subject: Re: [PATCH 2/2] xfs: use kvfree() in xlog_cil_free_logvec()
Message-ID: <Zd1K6L/VAn0GMtp0@dread.disaster.area>
References: <20240227001135.718165-1-david@fromorbit.com>
 <20240227001135.718165-3-david@fromorbit.com>
 <20240227004621.GN616564@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240227004621.GN616564@frogsfrogsfrogs>

On Mon, Feb 26, 2024 at 04:46:21PM -0800, Darrick J. Wong wrote:
> On Tue, Feb 27, 2024 at 11:05:32AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The xfs_log_vec items are allocated by xlog_kvmalloc(), and so need
> > to be freed with kvfree. This was missed when coverting from the
> > kmem_free() API.
> > 
> > Reported-by: Chandan Babu R <chandanbabu@kernel.org>
> > Fixes: 49292576136f ("xfs: convert kmem_free() for kvmalloc users to kvfree()")
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log_cil.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index f15735d0296a..9544ddaef066 100644
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -877,7 +877,7 @@ xlog_cil_free_logvec(
> >  	while (!list_empty(lv_chain)) {
> >  		lv = list_first_entry(lv_chain, struct xfs_log_vec, lv_list);
> >  		list_del_init(&lv->lv_list);
> > -		kfree(lv);
> > +		kvfree(lv);
> 
> Is it necessary to s/kfree/kvfree/ in xlog_cil_process_intents when we
> free the xfs_log_vec that's attached to a xfs_log_item?

Yes, it should, even though intents are pretty much
guaranteed to be small enough they will never use vmalloc.

Good catch.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
