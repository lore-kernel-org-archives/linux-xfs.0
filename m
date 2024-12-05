Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0EF1B2186
	for <linux-xfs@vger.kernel.org>; Thu,  5 Dec 2024 07:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733384426; cv=none; b=nn6o5mCdfLrSqrTwQv9ZovnGR3AxfMj50i3bdLLaziI4c/yB4OUuyVATG/q7nqvr2ZwvQqhWYVvFGDkhsiUF2yR28nlNC5gmCv8Fj4CIbj2d3FIa1ODWF3TLjq07f3p7rpLVFLS85p16OhAGiQVLcu4H4JEVAgyJhduNYa5K6ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733384426; c=relaxed/simple;
	bh=5GjnelmaP2oQ2PHAsX1VRCtjj6gP1e1XeeZt6xTfyP8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NETEUdx7VdOcuK5pVrHfEZbkYGRwbnNPcp2SQTjd7OCB19MnCBK0SFBdrS2js6qF/97VARVfcFiw20l5eSEaoj/ZF9+30xISBTeDK0c9eGOilCODNORyLIJvfzAUzMahHmdW+RvUAofND01OMtmEFNeBrPUZOs8FD8v6H77YDMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FR9wnoQ0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FR9wnoQ0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733384423;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Aal832r3Ge6Stj/1MEPFvVSfymKbtnfyjDG8NMwEYT8=;
	b=FR9wnoQ0xuWzyzksUg6svfKV+5F/EGt1waF4+CON4t1xv0pWFu1Q88Ak8Fl6vRrdFczo7D
	sC/y+ZoYZNt+MCvT1xvnb9zbrQ48WTGFhTzTBedVyoqIJ0RfoAYOsPpaaNBx257c4XjGmE
	pRwkiiCUR0b+D2WnxC+Dq1TF1v+rGyI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-690-5y7ZpaWRNMuahYy7YV7jSA-1; Thu,
 05 Dec 2024 02:40:19 -0500
X-MC-Unique: 5y7ZpaWRNMuahYy7YV7jSA-1
X-Mimecast-MFC-AGG-ID: 5y7ZpaWRNMuahYy7YV7jSA
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 811611955F3F;
	Thu,  5 Dec 2024 07:40:18 +0000 (UTC)
Received: from redhat.com (unknown [10.22.64.4])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C48701956054;
	Thu,  5 Dec 2024 07:40:16 +0000 (UTC)
Date: Thu, 5 Dec 2024 01:40:14 -0600
From: Bill O'Donnell <bodonnel@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	stable@vger.kernel.org, jlayton@kernel.org,
	linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCHSET v2] xfs: proposed bug fixes for 6.13
Message-ID: <Z1FY3jJdTFryZOFn@redhat.com>
References: <173328106571.1145623.3212405760436181793.stgit@frogsfrogsfrogs>
 <Z1EBXqpMWGL306sh@redhat.com>
 <20241205064243.GD7837@frogsfrogsfrogs>
 <Z1FNqV27x5hjnqQ9@redhat.com>
 <Z1FPGXpTIJ1Fc2Xy@infradead.org>
 <Z1FQdYEXLR5BoOE-@redhat.com>
 <20241205073321.GH7837@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241205073321.GH7837@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Wed, Dec 04, 2024 at 11:33:21PM -0800, Darrick J. Wong wrote:
> On Thu, Dec 05, 2024 at 01:04:21AM -0600, Bill O'Donnell wrote:
> > On Wed, Dec 04, 2024 at 10:58:33PM -0800, Christoph Hellwig wrote:
> > > On Thu, Dec 05, 2024 at 12:52:25AM -0600, Bill O'Donnell wrote:
> > > > > 1) Our vaunted^Wshitty review process didn't catch various coding bugs,
> > > > > and testing didn't trip over them until I started (ab)using precommit
> > > > > hooks for spot checking of inode/dquot/buffer log items.
> > > > 
> > > > You give little time for the review process.
> 
> Seriously?!
> 
> Metadir has been out for review in some form or another since January
> 2019[1].  If five years and eleven months is not sufficient for you to
> review a patchset or even to make enough noise that I'm aware that
> you're even reading my code, then I don't want you ever to touch any of
> my patchsets ever again.
> 
> > > I don't really think that is true.  But if you feel you need more time
> > > please clearly ask for it.  I've done that in the past and most of the
> > > time the relevant people acted on it (not always).
> > > 
> > > > > 2) Most of the metadir/rtgroups fixes are for things that hch reworked
> > > > > towards the end of the six years the patchset has been under
> > > > > development, and that introduced bugs.  Did it make things easier for a
> > > > > second person to understand?  Yes.
> > > > 
> > > > No.
> > > 
> > > So you speak for other people here?
> > 
> > No. I speak for myself. A lowly downstream developer.
> > 
> > > 
> > > > I call bullshit. You guys are fast and loose with your patches. Giving
> > > > little time for review and soaking.
> > > 
> > > I'm not sure who "you" is, but please say what is going wrong and what
> > > you'd like to do better.
> > 
> > You and Darrick. Can I be much clearer?
> > 
> > > 
> > > > > > becoming rather dodgy these days. Do things need to be this
> > > > > > complicated?
> > > > > 
> > > > > Yeah, they do.  We left behind the kindly old world where people didn't
> > > > > feed computers fuzzed datafiles and nobody got fired for a computer
> > > > > crashing periodically.  Nowadays it seems that everything has to be
> > > > > bulletproofed AND fast. :(
> > > > 
> > > > Cop-out answer.
> > > 
> > > What Darrick wrote feels a little snarky, but he has a very valid
> > > point.  A lot of recent bug fixes come from better test coverage, where
> > > better test coverage is mostly two new fuzzers hitting things, or
> > > people using existing code for different things that weren't tested
> > > much before.  And Darrick is single handedly responsible for a large
> > > part of the better test coverage, both due to fuzzing and specific
> > > xfstests.  As someone who's done a fair amount of new development
> > > recently I'm extremely glad about all this extra coverage.
> > > 
> > I think you are killing xfs with your fast and loose patches.
> 
> Go work on the maintenance mode filesystems like JFS then.  Shaggy would
> probably love it if someone took on some of that.
> 
> > Downstreamers like me are having to clean up the mess you make of
> > things.
> 
> What are you doing downstream these days, exactly?  You don't
> participate in the LTS process at all, and your employer boasts about
> ignoring that community process.  If your employer chooses to perform
> independent forklift upgrades of the XFS codebase in its product every
> three months and you don't like that, take it up with them, not
> upstream.

Thanks for your reply. You win.

> 
> --D
> 
> [1] https://lore.kernel.org/linux-xfs/154630934595.21716.17416691804044507782.stgit@magnolia/
> 
> 
> > 
> > > 
> > 
> > 
> 

