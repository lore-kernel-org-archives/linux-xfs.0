Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309FB370
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jul 2024 01:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721956528; cv=none; b=bxTSgmCLjVEZqoRtKNyPSPlafIGs252L1ldu5+KdLwb4DZSoo31u/cuT4+d6SLTYwMLf2NYc6BOhqLYZnBi1xSOb+b/Oq46s8D+oGJ7Mx0lK6zvdiena5/gPZYKR5IimCFbh/XV8ekEkEA864MLgsZK7hR1FwQOhq3O16flIu3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721956528; c=relaxed/simple;
	bh=8kO7poFXGEkTILWkl9Tednw2Elh5J8Drk+xUQFQhyKA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uBmc+Hy4KHSDLqae42W9/5Y/44Nd63EE4oF3O56uli+VfiONPQjhiKYOv6rTlBGgE9u2K0btSj5rLxvA/oGTTzH7/XpAivGBzelIoxyboNfRL/5epzXeVuB9wS7i/9PVRVb25TRScABETchqcX6NtckCBGecItvBE83R5j70x7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=EtbEjDzI; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="EtbEjDzI"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-70d199fb3dfso418674b3a.3
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2024 18:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1721956526; x=1722561326; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VBsdcBOYXToqabGrTHQHO0wTPp8SM5MBqPoAGMU1Fb4=;
        b=EtbEjDzIR9rlLLVbBvr9ZyqdDXIAbGzJSdY3sLH4ZkHXqo7peWBh7/1czRraOqckZa
         e/LMFEgcMeM38V7PpKZCI1OMJrGYplVHbYP8wcH83E0zplz0b/0LcazaESukrVyd36Zo
         vMvdUMuMIuHYfRnm/O68c9WuNcWGu0Dsu9/6lDrEWN8ZGRcC2qJmhnq/A8K3M3IeMdM9
         TnOZJ4lN0X798znphNn2vkF9T1AMYEBWvDDOmUhwTbTlufyWkz0PV4748mfs2Qp6QOqj
         Ks4jrrVmIED9V/lBPQVZVfPAqVOxJUb9sDA/kx7/tYwYukSuWV5hYc5yVnBO95ChXhMh
         7IXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721956526; x=1722561326;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VBsdcBOYXToqabGrTHQHO0wTPp8SM5MBqPoAGMU1Fb4=;
        b=PiNWCTnWC9mbzQUcow3k5OW4PgS17F1FVQV4Q9J7mmmvcc2n/ou/nJqwcmKXAUVZeA
         +At0Q6h3IG0VNeEcFRl4+SRG+4+8JdF3dCjjBeDbUIzMqkXQ1q8uPq+GpARFFHehUC9i
         tNivR+bm1pGcfmvVKdlR1GOorDriJy4ej8anB4GQZeDRcWIgAxn5U5W08oGgy+R7EOSe
         S/JB2prE36oVZIkmL88/9rDn3xUcrO9fLLo8gBtzimbYB3sjYi0RENFZmKDkMPaxiRCD
         fH17WMWbnCJryLY7vOPJJpv3i6+wI2OejwaavIhTivJJRkc3LoY+bjSqqhStYirmbwpk
         mMrQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/egc/YEYfPM5nejfGtc8zzd30YEzMNzdt3y3duSrfnjlSiL18VJhKlMG7lAt48pS9jJnU/TStqKpzyQQSxNaiUkfNs6srYzks
X-Gm-Message-State: AOJu0YwXNPtlH6rJMYDzJ0IEB37DfXwTRgIL/1ZnJbu2RT07mGY63vbM
	jFsMvtjpz8tu79/MgV5LNbKmrdIpGLtY8oZrIDdLSMMGQ2gcb6yKscrnzYLvgjOhKykcihJ6+oo
	j
X-Google-Smtp-Source: AGHT+IFpDoxTzzE58cx4caZuf/0zyJBoVkzVO1AeCbyHv3iJoJGEot70FPp0CCik7N8smfUfjfUsRg==
X-Received: by 2002:a05:6a00:3a18:b0:70d:3104:425a with SMTP id d2e1a72fcca58-70eaa936b15mr5608519b3a.23.1721956526265;
        Thu, 25 Jul 2024 18:15:26 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70ead7156easm1703911b3a.85.2024.07.25.18.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jul 2024 18:15:25 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sX9YJ-00BTF7-0E;
	Fri, 26 Jul 2024 11:15:23 +1000
Date: Fri, 26 Jul 2024 11:15:23 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
	cem@kernel.org
Subject: Re: [RFC] xfs: opting in or out of online repair
Message-ID: <ZqL4q/NikzqbRIUq@dread.disaster.area>
References: <20240724213852.GA612460@frogsfrogsfrogs>
 <ZqGy5qcZAbHtY61r@dread.disaster.area>
 <20240725141413.GA27725@lst.de>
 <ZqLSni/5VREgrCkA@dread.disaster.area>
 <20240726004154.GD612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240726004154.GD612460@frogsfrogsfrogs>

On Thu, Jul 25, 2024 at 05:41:54PM -0700, Darrick J. Wong wrote:
> On Fri, Jul 26, 2024 at 08:33:02AM +1000, Dave Chinner wrote:
> > On Thu, Jul 25, 2024 at 04:14:13PM +0200, Christoph Hellwig wrote:
> > > On Thu, Jul 25, 2024 at 12:05:26PM +1000, Dave Chinner wrote:
> > > > Maybe I'm missing something important - this doesn't feel like
> > > > on-disk format stuff. Why would having online repair enabled make
> > > > the fileystem unmountable on older kernels?
> > > 
> > > Yes, that's the downside of the feature flag.
> > > 
> > > > Hmmm. Could this be implemented with an xattr on the root inode
> > > > that says "self healing allowed"?
> > > 
> > > The annoying thing about stuff in the public file system namespace
> > > is that chowning the root of a file system to a random user isn't
> > > that uncommon, an that would give that user more privileges than
> > > intended.  So it could not hust be a normal xattr but would have
> > > to be a privileged one,
> > 
> > 
> > I'm not sure I understand what the problem is. We have a generic
> > xattr namespace for this sort of userspace sysadmin info already.
> > 
> > $ man 7 xattr
> > ....
> > Trusted extended attributes
> >        Trusted extended attributes are visible and accessible only
> >        to processes that have the CAP_SYS_ADMIN capability.
> >        Attributes in this class are used to implement mechanisms
> >        in user space (i.e., outside the kernel) which keep
> >        information in extended attributes to which ordinary
> >        processes should not have access.
> > 
> > > and with my VFS hat on I'd really like
> > > to avoid creating all these toally overloaded random non-user
> > > namespace xattrs that are a complete mess.
> > 
> > There's no need to create a new xattr namespace at all here.
> > Userspace could manipulate a trusted.xfs.self_healing xattr to do
> > exactly what we need. It's automatically protected by
> > CAP_SYS_ADMIN in the init namespace, hence it provides all the
> > requirements that have been presented so far...
> 
> <nod> Ok, how about an ATTR_ROOT xattr "xfs.self_healing" that can be
> one of "none", "check", or "repair".  No xattr means "check".

Sounds good to me.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
