Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B295542E43A
	for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2026 09:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787823246; cv=none; b=PrIIuKhFiTvYYtfCg0UgYGa72MKSqgN5BRyhG3LQJW9WwqHZcO8jj6kF22qhQL7DbBY8WoKGbOyC1AJq3tgttkjK4wgGmtr3FI4DZVGyUmdns1H4srcaf7DwmGmbLNiC7XPDvQ2mbMNnNM9J8i67LNaZ3Tz7R0qtCr+W7yOI10U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787823246; c=relaxed/simple;
	bh=fZDB6o8z+OtlEiSe+jpzVuadLZVlCBntZmpc5heGJHM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EQ4rYMsmvQSDUuY7x0JEypB62kVxlRdNt2vHmReRQd6uaVVgAzk0OAj2oEBH7IsIWHtnETpIK2WvzDCxfhxKoxGcuaGBumvLZxAwZujlCAr1hsC9jREY/+kakq8TptWVX4zbiKlu204bxRRY4nY8ksnEK9iKFBWbusf37NANbLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oe7mJMe+; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oe7mJMe+"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2ce7d2adef4so26083155ad.3
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2026 02:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787823233; x=1788428033; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pHol47atlejuJtDqQMnwRUYn1hWF/V1mWeFNS5X2gEg=;
        b=oe7mJMe+1Hx4Xqvao/lm9ceFpqxkCtOhADHgx1puSV/qxnHh3wuK9a8kIwaVFgVOos
         m9/6SC7MQQPHrBpdSvUPpvQHeOKoniv5tn+li+rwFATxOCsGx+kXrr9gNHIUW63042rh
         GIUrT8m3Yd++UqoUl012ycUXNP6JlAIQZE03u1U7PznRSJdhRDcQRQOxGshLUlm38mP0
         rpVmZIwStuTdp6Wfc2dsFFNw0Ock19vEeS+xjHd2FdVXkKR3cMWOPa27MY+XURdPiwb5
         WKDwqjZC8R9sdMp7e1LbWz0korSilXzhwONqIqSRdrSvzVTZpUuVRORhcgQNpkr+fRS+
         aNWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787823233; x=1788428033;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pHol47atlejuJtDqQMnwRUYn1hWF/V1mWeFNS5X2gEg=;
        b=LXLqtbbSryhArvD8eAw1P71p+Qe/n0bBpR2lYvuZyYpRVDSmWV2SzRVx6A5/osr5NK
         71D0O7QdQthni2u2pOKvw9vYf+9YAPEltBpVeeFgI+ucIg0wdiqOkJ4QUAcmQw0uXvXq
         pX1Ue5bG2Wk3TjESMmLz08P8d/Xfrz/rSKGCvdXE60Bk91nPAlVztnteOde+9iqdIioj
         TaYqHW3YBsVgn8lLPJbPiYxMhTSyoRVBAgOsq/FWkjKGHUwWk+irM2d2E8pVTAA8JLJc
         KCnpOi/zKvUYsuJXY3Thq9W6BwxPd3BSFCEMOs20xtj2wwvOmPxnU+NCwbVyqb0BAltj
         hscg==
X-Forwarded-Encrypted: i=1; AHgh+RoRbwGITYnSF6rUoSOx9dTPzog/XPhJuH4edrjXLLam4mP1CpAhSo42zwTULkYiItSIGei3LawuiJE=@vger.kernel.org
X-Gm-Message-State: AFuF++nZXULL1yoGtAneAqP+qa1f7wsR3orUHfrrRaylKbHGiDruPlDu
	d8HZPVwGn5MpqvXpkegvELDSyhaC5vfwPIPTAgr5PAi50b3/n+LlCqA=
X-Gm-Gg: AR+sD10khFeXo25oPIAY1/U7wzYZxwxMi3Obbxy3cNxkfHp13AcRt5+PyUk1eLzjODz
	rLJVwJgv0junK1piHlX4YNV2QZ1nhuGCOiQTjTo2LCfrPuTxhsuqe5M/hZ05kbpIsMeVP41vs8H
	RlUzWViNvgRpzGvGU9l8D035uT2szehNUS4+Qhqw85guRpJsQUktfLXZocELBEmw3NLoGZEAXr0
	Sh2DUC/Jhqi0u1AaGT7C/E6u6uxyNjsNi+hxBmcbZecZ4n0hj9kfBn+sHToPeoRgmdZbog35b/X
	dlECR6qIwn1din1Uek/j4rrV0/nb3TUzG7yL6A1z+GjyAMEoFT3nRFGcbK+BuhT+9mT3wO4AQlL
	amAIrWmDg4qiodaVQ3R9UJjkyS21OlgFlA7mWYZyHSKoA8WsZB5NAdgvl4HWHNyFSw0NYrC6VER
	jjwR3EWmtglGHGOpZdyUyI/NYF9Nhc5jKmBfKHSIHfY2pC9OAb20NSGIYoylU63Ret3X5Qb5EJm
	CaxhQhkIWdVwT7dgJFk6Kii/Mjyrjg/hxV7lpk=
X-Received: by 2002:a17:90b:1fd0:b0:38e:70d5:b12d with SMTP id 98e67ed59e1d1-3966d3ed042mr29682993a91.6.1787823233035;
        Thu, 27 Aug 2026 02:33:53 -0700 (PDT)
Received: from anuj-MacBookPro ([2406:7400:63:4a2f:cca2:d012:36c1:4a36])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3283fa89e8fsm25343615eec.8.2026.08.27.02.33.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 02:33:52 -0700 (PDT)
Date: Thu, 27 Aug 2026 15:03:46 +0530
From: Anuj Gupta <anuj1072538@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: port healthmon event list to list_head
Message-ID: <mut2xsmp77543bjkmrzpmx6cbbua7gjt7sty4kg7zuf7lwudfp@33ksdiowtxwm>
References: <178780640541.3528467.13867917797753503580.stgit@frogsfrogsfrogs>
 <178780640625.3528467.15741375660976356976.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178780640625.3528467.15741375660976356976.stgit@frogsfrogsfrogs>

> -	if (xfs_healthmon_merge_events(hm->last_event, &lost_event)) {
> -		trace_xfs_healthmon_merge(hm, hm->last_event);
> +	if (xfs_healthmon_merge_events(hm, &lost_event)) {
> +		trace_xfs_healthmon_merge(hm, &lost_event);

This traces the lost_event now, but the merge updates existing tail
event. Is the change in behaviour intentional?

>  	/* Try to merge with the newest event */
> -	if (xfs_healthmon_merge_events(hm->last_event, template)) {
> -		trace_xfs_healthmon_merge(hm, hm->last_event);
> +	if (xfs_healthmon_merge_events(hm, template)) {
> +		trace_xfs_healthmon_merge(hm, template);

Same: the merge updates the existing tail event, but this traces the
incoming template/event. Before this patch, surviving post-merge tail
was traced.
