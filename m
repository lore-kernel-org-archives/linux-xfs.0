Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C0C22756A
	for <linux-xfs@vger.kernel.org>; Sat, 27 Sep 2025 23:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759015384; cv=none; b=sxhFyx20KFNp/47xlQuIJB0t75r48LqyrkWHKdf05PZfeqw42A/O3rLKKoUlyh+es54JU8qlQDeHup+SX5PugNEp/5dV5xIh5M1QUrDZAZiR7bfw/fVVa+4p2TheN8BGxp5QxYPrFsVQI45NIJbfZTO4cINbQ+Fas1MA7iEROo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759015384; c=relaxed/simple;
	bh=0dozFF+XcvbMUNz/ESznXupg45d1uL0nud8dO1E8zxo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JxaFhmT/mkWeM16h55RGR8a9vFshqxt+gy4wQD1Fj9SIxtRvz0kbintiY5YBEQZl1dFTKajhMECeXJvgs1WR/r7ndk5nZtl2+odwHv8LgwTTuRz0Whq5rn/K1VLJ9eiL7n9b98b3PTXm6UxIfOS2xAlTYVsRYmh/j8SIowMFKMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=nQMPQUdX; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="nQMPQUdX"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b4755f37c3eso3148483a12.3
        for <linux-xfs@vger.kernel.org>; Sat, 27 Sep 2025 16:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1759015382; x=1759620182; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7BPal4grXGjSuhprZrLzxxyaEnZcQycsl1275MiHUx8=;
        b=nQMPQUdXt3rk5YIAqEt62HGF1GIdZlbj9yRjkY/rHiQhuRaG+YROYuwlhH1KlxZsKZ
         yShfZmYKvmHxg2ZSbBMM7cAETrDVQ96HytDrv1O6JRobki75dE7Nt7Sm/DmYUT2RplKv
         2eH8s8EqY66z9EUIRvHTUNXxpESN0MdARspGhALabsaPmqJmrgc9ybC6fYRYV7T0TF4q
         Jhx7fdf7MUke0eO337EdeEBtnk5rEgB8q1UnHuOxxireUtIyHgMgd4K1rTHI0iiSSFSM
         EH027Nm30V7TrKZmBTNGOnYqhMMaDNrYYBLeyc67hZRA3HxPg57NIw7CVKsLzkA8Prkm
         vWzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759015382; x=1759620182;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7BPal4grXGjSuhprZrLzxxyaEnZcQycsl1275MiHUx8=;
        b=S2iBGeHHiOtGyuq1hSGZjOgd9gRs9u00+3DiLIGR1v9L8WHMK2O67xka0AM/LPszCd
         64iRwai8acc189CXFXBU1kELTrkW2kIYLWbh4rXhAgo7xF8WQaDo5wrpcBWdHFGTjNDW
         gug8S2Rqd6Mbjf4r1lwCr5M7qrKIANw8NlL9RxOyy38T5qP5Yhc9/N+5RlYkrzVSffm2
         RpihtX7+kdU7dAzfxMg8RaeBA9tipFmwqs5Xpyx0Cd/l7A4w838XZjHy//iL5RMZjyR8
         haY3agmW4+2C32IqAjN5tbB/RYRL0+ikVYPSlzTsS3LBZJwrFxEtdkbzmesXQNcGzueu
         Cu3w==
X-Forwarded-Encrypted: i=1; AJvYcCXzROKjyrz7t5vrS+7kvW+H0lPegS+nopI8WRa6BRMLfNFX2BBzQTN160zBq6lIJy0oGMqBm55kXAg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzK693srwsDgM8eyYHLnGncRmLFIqj8V0Uugs0hfaOVZD1X2XMy
	85fu3K0UCvWZWOXYDEnOecagtT6scAduWac1vaRhSM5TdCwQHbLPGrFH/n5OVqy+5zo=
X-Gm-Gg: ASbGncvJHpG0rDzsYN3Qfg8gtci5JllS5Jl8tjP8aMtZ9paPy4+e96gT8Jdjh8WjdZ/
	+7ZzIrvwDb5RDm2iX3wyI/8sPOYtqGc71stMnQg6qj3Maoq1WGdtnEwzzV6LBcmmY2cRMH04aUm
	wk3c2mNGWW0PXqNf+4RbKss2jdXYiQ90EP1zfoNGa6PYUwyWqwZYZz3Vt7sMcBCcER5l83OlyG1
	VrGKSAZvd4rpaevSdHmjgYoorN/YrtUEiE7YOML+JNYBPp5KZ5V26P3O7mDOnCpI/mTIfBIWYZY
	r1Tz89rcvTXBRtNun4Lr/uGqq1SWysn1KJo2VfDCe2rWHVce16h4MWFdcTcwLOywMb005okb69p
	EeLUfAdX4wxtUK1r+EGc745MqdZ1dvcuiUXJuj3nP0AL9DMeVn8zDSan2uzUfBXrPg5WLuwmTYQ
	==
X-Google-Smtp-Source: AGHT+IEf4pIN7m37tSE9WcE49bdctX1EznSxjthSNMMbuJXe6TT4gCNisbhB6zVCQ8v4TV/NxIxFcg==
X-Received: by 2002:a17:903:1aec:b0:27e:e1f3:f853 with SMTP id d9443c01a7336-2828d00d69cmr27832495ad.8.1759015381658;
        Sat, 27 Sep 2025 16:23:01 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed6886f4esm89909865ad.80.2025.09.27.16.23.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Sep 2025 16:23:00 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1v2eFl-00000007afZ-1i7F;
	Sun, 28 Sep 2025 09:22:57 +1000
Date: Sun, 28 Sep 2025 09:22:57 +1000
From: Dave Chinner <david@fromorbit.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: "hubert ." <hubjin657@outlook.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: xfs_metadump segmentation fault on large fs - xfsprogs 6.1
Message-ID: <aNhx0SD3zOasGhpp@dread.disaster.area>
References: <6tqlc3mcf3ovkbzf4345m7oztoeagevfycpdnxizrtdbhq53p2@mrlmjhs6n7gy>
 <LV3PR05MB104071E0D6E7CAD06C7728DACFA26A@LV3PR05MB10407.namprd05.prod.outlook.com>
 <kZ0Ndjz5Uh9rHFbs-iYYoEFNVWoxMtkvK-3nrx6mrlxpglTxelNWuY_lqxKmfrItAPWl4M4ng-BzenCqcFiOaA==@protonmail.internalid>
 <IA0PR05MB99750EB3605E36DEF8874BACFA31A@IA0PR05MB9975.namprd05.prod.outlook.com>
 <gjogpxo65cozoccj4fps6e4fzeu4ncibeofymhkyzys4hsclzy@vvrl2kndu7k6>
 <IA0PR05MB9975ADAF48C73797473737BEFA38A@IA0PR05MB9975.namprd05.prod.outlook.com>
 <IA0PR05MB99755ED06F9965745B20D9DAFA1EA@IA0PR05MB9975.namprd05.prod.outlook.com>
 <7qd0IjCTUj1UpKLm2g6sPrhFI8HEoYrqIQ23o_ANTShTu58S7x7bgoMYTvXfR_fpqPdB85XxZoz16xrnllDcvA==@protonmail.internalid>
 <aNZfRuIVgIOiP6Qp@dread.disaster.area>
 <ip6g2acleif3cyslm65uzdxd47dgzfum57xxgpmk73r4223poy@shhld7q7ls7i>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ip6g2acleif3cyslm65uzdxd47dgzfum57xxgpmk73r4223poy@shhld7q7ls7i>

On Fri, Sep 26, 2025 at 03:45:17PM +0200, Carlos Maiolino wrote:
> On Fri, Sep 26, 2025 at 07:39:18PM +1000, Dave Chinner wrote:
> > So there must be a bounds checking bug in process_exinode():
> > 
> > static int
> > process_exinode(
> >         struct xfs_dinode       *dip,
> >         int                     whichfork)
> > {
> >         xfs_extnum_t            max_nex = xfs_iext_max_nextents(
> >                         xfs_dinode_has_large_extent_counts(dip), whichfork);
> >         xfs_extnum_t            nex = xfs_dfork_nextents(dip, whichfork);
> >         int                     used = nex * sizeof(struct xfs_bmbt_rec);
> > 
> >         if (nex > max_nex || used > XFS_DFORK_SIZE(dip, mp, whichfork)) {
> >                 if (metadump.show_warnings)
> >                         print_warning("bad number of extents %llu in inode %lld",
> >                                 (unsigned long long)nex,
> >                                 (long long)metadump.cur_ino);
> >                 return 1;
> >         }
> > 
> > Can you spot it?
> > 
> > Hint: ((2^28 + 1) * 2^4) - 1 as an int is?
> 
> Perhaps the patch below will suffice?
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 34f2d61700fe..1dd38ab84ade 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -2395,7 +2395,7 @@ process_btinode(
>  
>  static int
>  process_exinode(
> -	struct xfs_dinode 	*dip,
> +	struct xfs_dinode	*dip,
>  	int			whichfork)
>  {
>  	xfs_extnum_t		max_nex = xfs_iext_max_nextents(
> @@ -2403,7 +2403,13 @@ process_exinode(
>  	xfs_extnum_t		nex = xfs_dfork_nextents(dip, whichfork);
>  	int			used = nex * sizeof(struct xfs_bmbt_rec);
>  
> -	if (nex > max_nex || used > XFS_DFORK_SIZE(dip, mp, whichfork)) {
> +	/*
> +	 * We need to check for overflow of used counter.
> +	 * If the inode extent count is corrupted, we risk having a
> +	 * big enough number of extents to overflow it.
> +	 */
> +	if (used < nex || nex > max_nex ||
> +	    used > XFS_DFORK_SIZE(dip, mp, whichfork)) {
>  		if (metadump.show_warnings)
>  			print_warning("bad number of extents %llu in inode %lld",
>  				(unsigned long long)nex,
> 

That fixes this specific problem, but now it will reject valid
inodes with valid but large extent counts.

What type does XFS_SB_FEAT_INCOMPAT_NREXT64 require for extent
count calculations?  i.e. what's the size of xfs_extnum_t?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
