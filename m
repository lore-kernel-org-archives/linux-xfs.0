Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79751BE6C
	for <linux-xfs@vger.kernel.org>; Thu, 20 Mar 2025 21:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742505730; cv=none; b=Fo0JjydRuytP/vffN/oKz2VRC5ov1j//HExqH7K3UXAAbvAvMOGK33whTqQib2kTfWjmzfvp0oAJuViWTnXBB+7FGaCWNATXlty9ZmmV+YR9fg1YRHNi4YqILQk4bGr9ZKPxT83gjvQ4iGi8zw0b3AmZ6qAiGcCiv36q4e0OunU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742505730; c=relaxed/simple;
	bh=2fvbLQRNbaqFQyk3Tr9C4wKUuipbpIRuvZk24Xx3UNw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uHLOt8cag3SekhxuaHwFuz/N6CW3WEF5yR0+iSSdiwkv00qG4VNHY6KQmMRBt+Knq/hPOrVFAWYByhNXuHNkoFOdHmet78jiG3/bl674iXDrp2I34NImg/okgYKAATnJEy+vpXKMBNklUODxIo0WTffr9raioe/Cf+QTBOgQ0fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=UjbcYoOr; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="UjbcYoOr"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-223fd89d036so25544175ad.1
        for <linux-xfs@vger.kernel.org>; Thu, 20 Mar 2025 14:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1742505727; x=1743110527; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Lb0c6pgJWPfEZcsRHWDpWmnJDY10lWvatTWzJ2ydxTU=;
        b=UjbcYoOrQ9h6o/fRboSnTOR5FUgxYz/YW7gMxnNBlZK5yisdjP41EeAFDAyHyYEHXu
         bcN8Ihwk8e2+d7oY5nyO5x2QJbsgtZpjfzpQ+n4JmC7Bg6Kls5TZht/rkRKNw0an8bdl
         L/7HXPWKSqlSEt9i6IBvUpaiXGk+JBLNR2QANedOArJml5NYlO7mEOz60otrAlYro+2D
         71fSKy67pBTA3mO0SaMzwZ19y5nqR8kdwxz8q8Ddt/IHttvemDLXARvJis9SW79Sx7Y/
         GVNJof0ietxSct2fwwWYi5TIAmYirBFhGYr/9DGCtYQIBsdHYc/1ZGm3PWaDYbmUAumy
         9/vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742505727; x=1743110527;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lb0c6pgJWPfEZcsRHWDpWmnJDY10lWvatTWzJ2ydxTU=;
        b=cpvx63oY2MM56aIlkPxg89uwabnv8j/DZinya/HBzCpZMda7T3h1Hs8jAYUeOadkfX
         vi4gMfov/7SI41w4lPNjLYB30tArqcvJxGhk+QniybRPc/NNDIOnfhBpChaiam0hiigG
         s9Uw7+9HTdW+9GVTOFP27sL7r73OBsN3JrK9rWi03Zt/EB/oKPT5v6uJxx2iyaqQu90h
         OiG55E1ORZImWor9ICXZPs3/fNlr79tKszcf+twDZkze2AV5OkLWRdVi3COZaC36ogpJ
         bOdpQa+cZzhHzzpKu4t6iaj9C7kZoojCspTenEdxonEoxqksM27fROdgHdFUfdhAQu38
         5xJg==
X-Gm-Message-State: AOJu0YwVp5uU0GIMGP3CkUeoOECfdfM/fB1TmUtjTiaB8ipOKr3SOt9m
	RArOoO9S5lu48FMfQW1wquMeQRlaolSi2buwM7wwN5TP0q4gjuDSs7ADRWSoBm0=
X-Gm-Gg: ASbGncu8x+wyUOwbgb/+GX9/WRZPLcolQSz/bt272XC42uk/SY6+VT2YzeztrIaA6KN
	B4hRitkk4pterZtrhIdW5akOTYse8s6aySw/ANLeNboQ4nzD0P4Yzl4xus7tRzEpskvzBWXeph9
	ZMzP4dWU7eygrLOF7j6TjsOxuu1OH79kKrcAEjYbQ9WOPDXjDZTdIWWjh0uI89HTZ5tAU++C/sh
	gzYA3PcmugDosFbtKE/xh/a+yjjRETR7PcidjkKmJlusiDHAOCIunhMkcB508SxBg4viYV+RuIa
	yXmGI+mZclKEiO+1zczajNrHAVmicwxqYrjymGkilo/6Vpc3FaVpncwaZsCzO2HqziUBjZ9cNOZ
	+PjXAVu1y+dPor8CQIKkq
X-Google-Smtp-Source: AGHT+IFeHise/wMGS+lr0A9iAsMq8Ces21MRkjKWhyMVih4Mt5IVb5j0GMvnw9//9ONYHPRfzHMe4w==
X-Received: by 2002:a05:6a00:1301:b0:736:51ab:7aed with SMTP id d2e1a72fcca58-739059ffa18mr1448311b3a.16.1742505727518;
        Thu, 20 Mar 2025 14:22:07 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-36-239.pa.vic.optusnet.com.au. [49.186.36.239])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af8a2a233a8sm363962a12.52.2025.03.20.14.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 14:22:06 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tvNL1-0000000Fj0i-05DK;
	Fri, 21 Mar 2025 08:22:03 +1100
Date: Fri, 21 Mar 2025 08:22:02 +1100
From: Dave Chinner <david@fromorbit.com>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, hch <hch@lst.de>
Subject: Re: [RFC PATCH] xfs: add mount option for zone gc pressure
Message-ID: <Z9yG-sn0IHFDUEvZ@dread.disaster.area>
References: <20250319081818.6406-1-hans.holmberg@wdc.com>
 <Z9qKUt1iPsQTTKu-@dread.disaster.area>
 <caaff621-2da9-4c7a-b6c1-76cd2317022b@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <caaff621-2da9-4c7a-b6c1-76cd2317022b@wdc.com>

On Thu, Mar 20, 2025 at 12:51:24PM +0000, Hans Holmberg wrote:
> On 19/03/2025 10:11, Dave Chinner wrote:
> > On Wed, Mar 19, 2025 at 08:19:19AM +0000, Hans Holmberg wrote:
> >> +
> >> +	free = xfs_estimate_freecounter(mp, XC_FREE_RTEXTENTS);
> >> +	if (available < div_s64(free * mp->m_gc_pressure, 100))
> > 
> > mult_frac(free, mp->m_gc_pressure, 100) to avoid overflow.
> > 
> > Also, this is really a free space threshold, not a dynamic
> > "pressure" measurement...
> > 
> 
> Yeah, naming is hard. I can't come up with a better name off
> the bat, but I'll give it some thought.

The current lowspace thresholds are called:

struct xfs_mount {
....
        uint64_t                m_low_space[XFS_LOWSP_MAX];
        uint64_t                m_low_rtexts[XFS_LOWSP_MAX];
.....

As we have multiple thresholds that increase severity of action
as we get closer and closer to ENOSPC. These are pre-calculated
as fixed values so we don't have to do mult/div when checking low
space thresholds on every allocation.

And note that in the xfs_mount we also have:

	void __percpu           *m_inodegc;     /* percpu inodegc structures */
	.....
	struct workqueue_struct *m_blockgc_wq;
        struct workqueue_struct *m_inodegc_wq;
	.....
	struct shrinker         *m_inodegc_shrinker;
	.....
	struct cpumask          m_inodegc_cpumask;
	.....

Multiple different subsystem GC state fields. Hence anything related
to zone GC really needs a m_zonegc_... prefix.

So my 2c worth is that something like "m_zonegc_low_space" would be
appropriate as it indicates that it is for zonegc (rather than
blockgc or inodegc), and it's a low space threshold...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
