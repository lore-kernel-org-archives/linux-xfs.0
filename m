Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFADD101F7
	for <linux-xfs@vger.kernel.org>; Wed, 16 Oct 2024 03:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729050509; cv=none; b=TJSCn0i9Hat8+kO737YRLAw/aZUHiBzDd5eKeVJm5dgyi20trDELNv+nEPcD+XBCvq5shpipJNjA49VF87zPC+4wJ4up5FE9tIt+zkpbKGSpfVsBPuLcKMyogFJLOWBu5kGj8wmI2qWBXwe1Ao9j5iZsYocwTDlRX2r1W+36EiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729050509; c=relaxed/simple;
	bh=HCVov1OcTQBbgomkyf+fWIPz776moYiRawiq25Bgrg8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b6arL8WeWICkGqruGKdIl7vF4ObIieK3Qpg29vybl//cBVdR3sCmlFLF+1NOJoituf5kBl9clYGmCK3+TJLYFu05y9Q6i1aRJP9Va23ai2hh6po9G+gVSEb2gzP8yu5M99sylEytrxIDDEoE5SerMT+rvaf2PpKztXS938TlaFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Su4UJYZj; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Su4UJYZj"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-7db238d07b3so5314469a12.2
        for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 20:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1729050507; x=1729655307; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dCX4RGXazCoTHMH2UjsiSeKguf/KQQIrcDCLTwuJDWM=;
        b=Su4UJYZjsr9VyiV5CQPmBbi8/sTBxpcW8yYKMTbIZSmyNfVS78+V1TwpICn5GN4ZSd
         /ZS9pzZBAqa1wDkyZWs6NIY2lNylcrI5lOCHfM+45A+/ESJ3FhYHyFnAZCSJY7DQrATl
         MP4vfZ8UA5Lsx/94Cr1yI3qBYCEmEeBPYyF0SZ8OcdGDqtkRKR6zPpSLd6mSW3uaD2MV
         Ja6ScdbBFmcX1S3ZUFyLZuZkmCtjRR1NeAv5P9eGM05Husuv/KFmmAdMvzAX6pBwMh9N
         /L0vfvZ9J1h9sxWPbogjDjl5ZVlbnMwr8NQWYLT1eJ/2+5iGuKCAy3eavXFyexB5z5mF
         IUmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729050507; x=1729655307;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dCX4RGXazCoTHMH2UjsiSeKguf/KQQIrcDCLTwuJDWM=;
        b=k27mrSjWHRvRtolETMW5f+QUqd+gOpVoK6QM7APG7QVIAaSqi9mW0ODwyYlQsROjDq
         XbwQgAYCBY6Ma7jM9v02SkzPA3/nCfXzD82wFa+Jkl7nyKMAzyqRM/LlvHDxwNjlepwt
         LvCg/plDpIO+zFrcFzUDUbI3PqKNawSn2NhGPvhteZMBwq0mqo3w+rqA4rkyrAk302Ue
         UfDFImIi3wMbh/458BK+PvUotR6ogqO7eEtLw0C6a5iwy+ouMUEQCIIoyn03gfyYTxjP
         9AcCR1CKo/FcN31puL80N31U/WHvuMsl5iHTkbxDYZkKIdG3VpJQPFFWTe2DXLnmT/lV
         hsIg==
X-Gm-Message-State: AOJu0YwotoQwsZR4RHm9Tkfhg/yfsxScl2Ql4XaKR32Qitcbw583mRWr
	UvORxNMX34C038QYMMUDyjjq6PXGv7aaMAwZJDC93ML4DBTPixoFWzeRoqm2WfY=
X-Google-Smtp-Source: AGHT+IEKO5LQuRGLhgu7NYpjmAAZODc4wmJnZJEm7c85UndteerVALAsobK967jkOzEsGT/5ge0DnQ==
X-Received: by 2002:a17:90b:f8d:b0:2e2:a96c:f00d with SMTP id 98e67ed59e1d1-2e3ab8217b3mr3014718a91.21.1729050506886;
        Tue, 15 Oct 2024 20:48:26 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-209-182.pa.vic.optusnet.com.au. [49.186.209.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e392f755e2sm2839991a91.50.2024.10.15.20.48.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2024 20:48:26 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t0v1L-001PnP-0w;
	Wed, 16 Oct 2024 14:48:23 +1100
Date: Wed, 16 Oct 2024 14:48:23 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 03/28] xfs: define the on-disk format for the metadir
 feature
Message-ID: <Zw83h2swL9fqs3xm@dread.disaster.area>
References: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
 <172860642064.4176876.13567674130190367379.stgit@frogsfrogsfrogs>
 <Zw3rjkSklol5xOzE@dread.disaster.area>
 <20241015182541.GE21853@frogsfrogsfrogs>
 <Zw70vBF6adb0GAzA@dread.disaster.area>
 <20241016002051.GK21877@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241016002051.GK21877@frogsfrogsfrogs>

On Tue, Oct 15, 2024 at 05:20:51PM -0700, Darrick J. Wong wrote:
> On Wed, Oct 16, 2024 at 10:03:24AM +1100, Dave Chinner wrote:
> > On Tue, Oct 15, 2024 at 11:25:41AM -0700, Darrick J. Wong wrote:
> > > > > +	if (xfs_has_metadir(mp))
> > > > > +		xfs_warn(mp,
> > > > > +"EXPERIMENTAL metadata directory feature in use. Use at your own risk!");
> > > > > +
> > > > 
> > > > We really need a 'xfs_mark_experimental(mp, "Metadata directory")'
> > > > function to format all these experimental feature warnings the same
> > > > way....
> > > 
> > > We already have xfs_warn_mount for functionality that isn't sb feature
> > > bits.  Maybe xfs_warn_feat?
> > 
> > xfs_warn_mount() is only used for experimental warnings, so maybe we
> > should simply rename that xfs_mark_experiental().  Then we can use
> > it's inherent "warn once" behaviour for all the places where we
> > issue an experimental warning regardless of how the experimental
> > feature is enabled/detected. 
> > 
> > This means we'd have a single location that formats all experimental
> > feature warnings the same way. Having a single function explicitly
> > for this makes it trivial to audit and manage all the experimental
> > features supported by a given kernel version because we are no
> > longer reliant on grepping for custom format strings to find
> > experimental features.
> > 
> > It also means that adding a kernel taint flag indicating that the
> > kernel is running experimental code is trivial to do...
> 
> ...and I guess this means you can discover which forbidden features are
> turned on from crash dumps.  Ok, sounds good to me.

Yes, though I don't consider experimental features as "forbidden".

This is more about enabling experimental filesystem features to be
shipped under tech preview constraints(*). Knowing that an
experimental feature is in use will help manage support expectations
and workload. This, in turn, will also allow us to stay closer to
the upstream XFS code base and behaviour....

> Do you want it to return an int so that you (as a distributor, not you
> personally) can decide that nobody gets to use the experimental
> features?

I considered suggesting that earlier, but if we want to disable
specific experimental features we'll have to patch the kernel
anyway. Hence I don't think there's any reason for having the
upstream code doing anything other than tracking what experimental
features are in use.

-Dave.

(*) https://access.redhat.com/solutions/21101

"Technology Preview features are not fully supported, may not be
functionally complete, and are not suitable for deployment in
production. However, these features are provided to the customer as
a courtesy and the primary goal is for the feature to gain wider
exposure with the goal of full support in the future."

-- 
Dave Chinner
david@fromorbit.com
