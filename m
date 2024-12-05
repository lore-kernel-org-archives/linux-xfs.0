Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C826A193064
	for <linux-xfs@vger.kernel.org>; Thu,  5 Dec 2024 07:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733383854; cv=none; b=EGB4PQiEuri9W3ta4nH3+dID9159ueXNKuAphBRr4ICPBUasFQL/sM8rvMI9rX1YIYZNYQh6yr51dfhGkf2RE1yGnu8H9WXtvaBIR9cZk7GlwWKtdxMFL6IORgg4hpzaheVJGsDAk4RUN34wwsf6L8NTxg0g0VDeILWOioAT8PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733383854; c=relaxed/simple;
	bh=OlRNBUjASL7FVNGtWoyFFzTei7wVTiYRgktEzUrextU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jq6CGOejVRjPjEFSLcIhchtRRRqH4hXgavEe3M/FkcVIKMONB9BDf6oRsTsTV5yc12DeTiwlouFgzMhn81qiVMiKydaK9KE1F2t98S/UmbtaaAppm8l/0GcD4O2pYEwreVK6mSbWxczWJscUqNiqsARBqFhRqGXJlsBotDAqUOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hUOqu3po; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hUOqu3po"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733383851;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lgSEU4ckanSgk0HuuZW1mGMR1MCqcuQYAI+6N7Ir2cg=;
	b=hUOqu3pohP1qC38cAQIpIDNFDIs8lzv7K4uFVEMQTVkspui6ERhJELcBbO3cz7LOyag9bQ
	2DSs//ZvOJh4YK7jDvbZyJ4RXrhyaOu4d5COKINe0rcjPOCrTBVc/4WcwJwwGn6z2kSQ47
	7CVUENWeAwiPG8fkz+14M5p3q7zpSJs=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-47-TJwhZTnXMC6wBve6kCH3zA-1; Thu,
 05 Dec 2024 02:30:48 -0500
X-MC-Unique: TJwhZTnXMC6wBve6kCH3zA-1
X-Mimecast-MFC-AGG-ID: TJwhZTnXMC6wBve6kCH3zA
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D445D1955DC8;
	Thu,  5 Dec 2024 07:30:46 +0000 (UTC)
Received: from redhat.com (unknown [10.22.64.4])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1517F1956054;
	Thu,  5 Dec 2024 07:30:44 +0000 (UTC)
Date: Thu, 5 Dec 2024 01:30:42 -0600
From: Bill O'Donnell <bodonnel@redhat.com>
To: Bill O'Donnell <bodonnel@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"Darrick J. Wong" <djwong@kernel.org>, cem@kernel.org,
	stable@vger.kernel.org, jlayton@kernel.org,
	linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCHSET v2] xfs: proposed bug fixes for 6.13
Message-ID: <Z1FWojAndtCxEt-d@redhat.com>
References: <173328106571.1145623.3212405760436181793.stgit@frogsfrogsfrogs>
 <Z1EBXqpMWGL306sh@redhat.com>
 <20241205064243.GD7837@frogsfrogsfrogs>
 <Z1FNqV27x5hjnqQ9@redhat.com>
 <Z1FPGXpTIJ1Fc2Xy@infradead.org>
 <Z1FQdYEXLR5BoOE-@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1FQdYEXLR5BoOE-@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Thu, Dec 05, 2024 at 01:04:21AM -0600, Bill O'Donnell wrote:
> On Wed, Dec 04, 2024 at 10:58:33PM -0800, Christoph Hellwig wrote:
> > On Thu, Dec 05, 2024 at 12:52:25AM -0600, Bill O'Donnell wrote:
> > > > 1) Our vaunted^Wshitty review process didn't catch various coding bugs,
> > > > and testing didn't trip over them until I started (ab)using precommit
> > > > hooks for spot checking of inode/dquot/buffer log items.
> > > 
> > > You give little time for the review process.
> > 
> > I don't really think that is true.  But if you feel you need more time
> > please clearly ask for it.  I've done that in the past and most of the
> > time the relevant people acted on it (not always).
> > 
> > > > 2) Most of the metadir/rtgroups fixes are for things that hch reworked
> > > > towards the end of the six years the patchset has been under
> > > > development, and that introduced bugs.  Did it make things easier for a
> > > > second person to understand?  Yes.
> > > 
> > > No.
> > 
> > So you speak for other people here?
> 
> No. I speak for myself. A lowly downstream developer.
> 
scrub is the worst offender. What the hell is it, and why do you insist its imortance?

> > 
> > > I call bullshit. You guys are fast and loose with your patches. Giving
> > > little time for review and soaking.
> > 
> > I'm not sure who "you" is, but please say what is going wrong and what
> > you'd like to do better.
> 
> You and Darrick. Can I be much clearer?
> 
> > 
> > > > > becoming rather dodgy these days. Do things need to be this
> > > > > complicated?
> > > > 
> > > > Yeah, they do.  We left behind the kindly old world where people didn't
> > > > feed computers fuzzed datafiles and nobody got fired for a computer
> > > > crashing periodically.  Nowadays it seems that everything has to be
> > > > bulletproofed AND fast. :(
> > > 
> > > Cop-out answer.
> > 
> > What Darrick wrote feels a little snarky, but he has a very valid
> > point.  A lot of recent bug fixes come from better test coverage, where
> > better test coverage is mostly two new fuzzers hitting things, or
> > people using existing code for different things that weren't tested
> > much before.  And Darrick is single handedly responsible for a large
> > part of the better test coverage, both due to fuzzing and specific
> > xfstests.  As someone who's done a fair amount of new development
> > recently I'm extremely glad about all this extra coverage.
> > 
> I think you are killing xfs with your fast and loose patches. Downstreamers
> like me are having to clean up the mess you make of things.
> 
> 
> > 
> 
> 

