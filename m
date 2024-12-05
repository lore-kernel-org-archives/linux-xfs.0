Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94462F56
	for <linux-xfs@vger.kernel.org>; Thu,  5 Dec 2024 07:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733382272; cv=none; b=dUyFhG5LNZyao9ddEhVEQ1SKMH3Cfm6xEvEx/zuS/6FJOFUuvdo4NZj+YNdqM+76iz/k30CytYVZjDIfDlrgYP9wNiISkvwxaIpEcq/+jMh4+/U+8ZFV0MFLYjFO6JitORiKdSNzLWSZzD/v4W4u1JT//Fyj3hHcjVBnf9QaSgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733382272; c=relaxed/simple;
	bh=2BcsyHMdUDSmw397jbYGwPEeUvn4mIDWvN+Zr8u/fDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CDIZ6BYFxu47qdt8ZxAAJrWSfFFR0V34atEV7H6NuJ5sJ7wlJKnOad1oMyhi19Y4iNsH36LQIcx7yxsMNUBYxMx0XLMbxH5huVqYCyL/9qp0cTjiPRhn6Oh/j+prQP9K8TRzRBNB/NoTy1P53DJwzEPCDLTKG9EsLCAjPoNq1Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qi+DLM5t; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qi+DLM5t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733382269;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5oD4Xvvk6YCSCRI3isn6HGpglYA00TLuI7GvD/LeelE=;
	b=Qi+DLM5tszQ/3Me4mMpSL+fyQ1MLzLKJ46jp9Woezx311fMQCA7jQdAhpGdCx1iVp1BlYM
	rbuYP/XOy7kWp+QpWuFmH4d/e8NdhISFGIr7nX0T3wRHuRgvjKHA+Cxo9hcK1A8McmkJOI
	q2ASuF1pxUdKE9LnL848UspvxiGgAhk=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-520-1lMrPFkaMpqT_pVwMTToag-1; Thu,
 05 Dec 2024 02:04:27 -0500
X-MC-Unique: 1lMrPFkaMpqT_pVwMTToag-1
X-Mimecast-MFC-AGG-ID: 1lMrPFkaMpqT_pVwMTToag
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A43071955DCB;
	Thu,  5 Dec 2024 07:04:25 +0000 (UTC)
Received: from redhat.com (unknown [10.22.64.4])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EC7EB3000197;
	Thu,  5 Dec 2024 07:04:23 +0000 (UTC)
Date: Thu, 5 Dec 2024 01:04:21 -0600
From: Bill O'Donnell <bodonnel@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, cem@kernel.org,
	stable@vger.kernel.org, jlayton@kernel.org,
	linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCHSET v2] xfs: proposed bug fixes for 6.13
Message-ID: <Z1FQdYEXLR5BoOE-@redhat.com>
References: <173328106571.1145623.3212405760436181793.stgit@frogsfrogsfrogs>
 <Z1EBXqpMWGL306sh@redhat.com>
 <20241205064243.GD7837@frogsfrogsfrogs>
 <Z1FNqV27x5hjnqQ9@redhat.com>
 <Z1FPGXpTIJ1Fc2Xy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1FPGXpTIJ1Fc2Xy@infradead.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Wed, Dec 04, 2024 at 10:58:33PM -0800, Christoph Hellwig wrote:
> On Thu, Dec 05, 2024 at 12:52:25AM -0600, Bill O'Donnell wrote:
> > > 1) Our vaunted^Wshitty review process didn't catch various coding bugs,
> > > and testing didn't trip over them until I started (ab)using precommit
> > > hooks for spot checking of inode/dquot/buffer log items.
> > 
> > You give little time for the review process.
> 
> I don't really think that is true.  But if you feel you need more time
> please clearly ask for it.  I've done that in the past and most of the
> time the relevant people acted on it (not always).
> 
> > > 2) Most of the metadir/rtgroups fixes are for things that hch reworked
> > > towards the end of the six years the patchset has been under
> > > development, and that introduced bugs.  Did it make things easier for a
> > > second person to understand?  Yes.
> > 
> > No.
> 
> So you speak for other people here?

No. I speak for myself. A lowly downstream developer.

> 
> > I call bullshit. You guys are fast and loose with your patches. Giving
> > little time for review and soaking.
> 
> I'm not sure who "you" is, but please say what is going wrong and what
> you'd like to do better.

You and Darrick. Can I be much clearer?

> 
> > > > becoming rather dodgy these days. Do things need to be this
> > > > complicated?
> > > 
> > > Yeah, they do.  We left behind the kindly old world where people didn't
> > > feed computers fuzzed datafiles and nobody got fired for a computer
> > > crashing periodically.  Nowadays it seems that everything has to be
> > > bulletproofed AND fast. :(
> > 
> > Cop-out answer.
> 
> What Darrick wrote feels a little snarky, but he has a very valid
> point.  A lot of recent bug fixes come from better test coverage, where
> better test coverage is mostly two new fuzzers hitting things, or
> people using existing code for different things that weren't tested
> much before.  And Darrick is single handedly responsible for a large
> part of the better test coverage, both due to fuzzing and specific
> xfstests.  As someone who's done a fair amount of new development
> recently I'm extremely glad about all this extra coverage.
> 
I think you are killing xfs with your fast and loose patches. Downstreamers
like me are having to clean up the mess you make of things.


> 

