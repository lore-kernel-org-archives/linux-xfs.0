Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19FA3009D6
	for <linux-xfs@vger.kernel.org>; Wed, 10 Dec 2025 17:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765386885; cv=none; b=Ej0AcIpG7fEMr1WZUk3ZoNYGirCqiXFibpBa8MqmOubo49Um73wYHqBqstITtoI+iLNpDkZj++J3hxluOkSQvlIEvTpbpatMKdZcMKgh4O3YTAW85+oblIRldDjPzMU/aV900j0+i96r1dFSoeUen7NkJWhVkr06qsSBNRh7NqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765386885; c=relaxed/simple;
	bh=7nG1QghGNmmCauE27VToiVGcUeYG/mJZwHbiXlIrBQE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UwVHzRqFk6OU+H+bpprWjOwOdA6QqX5IEhh91fcklp5YmwZR06GUeAOVMcfjdDPh4OWw2nGEGIK8Ioa5aH3QULnLU0pwYdxs7l2Aimt5uj6WCrV6ylcmKpTgrj06rmHNGIKLJU1sDqGCW0lnhurAI6Wqykc8Cmmj8EzzMVDEVUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qn3JP/KW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qn3JP/KW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765386882;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VS7Cap72j6jprQH09OR7yQlkWzlCg8BJPmYd1w1llj4=;
	b=Qn3JP/KWBaYuwjtVQRfQwgQK2fVSSjaWufN61bG8xG2vM4y73CZYPUOGPda57zI0pLcit+
	LxIvI76VEqsNIjU2O/uBbnYM43X0Pxc7MtpjMbNepJKGT3xuuiv3AjkD8BZjmalh3LKzdY
	Sn1nXICUXryR/JMJJzd/Q314FcPRkhI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-250-WWH7JWccPPWuNBtD7QWRKA-1; Wed,
 10 Dec 2025 12:14:39 -0500
X-MC-Unique: WWH7JWccPPWuNBtD7QWRKA-1
X-Mimecast-MFC-AGG-ID: WWH7JWccPPWuNBtD7QWRKA_1765386878
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 27C701800342;
	Wed, 10 Dec 2025 17:14:38 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.2])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7BD17180049F;
	Wed, 10 Dec 2025 17:14:37 +0000 (UTC)
Date: Wed, 10 Dec 2025 12:14:35 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix XFS_ERRTAG_FORCE_ZERO_RANGE for zoned file
 system
Message-ID: <aTmqe3lDL2BkZe3b@bfoster>
References: <20251210090400.3642383-1-hch@lst.de>
 <aTmTl_khrrNz9yLY@bfoster>
 <20251210154016.GA3851@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210154016.GA3851@lst.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Wed, Dec 10, 2025 at 04:40:16PM +0100, Christoph Hellwig wrote:
> On Wed, Dec 10, 2025 at 10:36:55AM -0500, Brian Foster wrote:
> > Is there a reason in particular for testing this with the zone mode?
> > It's just a DEBUG thing for the zeroing mechanism. Why not just filter
> > out the is_zoned_inode() case at the injection site?
> 
> Because I also want to be able to test the zeroing code for zoned
> file systems, especially given zeroing is a bit of painful area
> for out of place write file systems like zoned XFS.
> 
> > I suppose you could argue there is a point if we have separate zoned
> > mode iomap callbacks and whatnot, but I agree the factoring here is a
> > little unfortunate. I wonder if it would be nicer if we could set a flag
> > or something on an ac and toggle the zone mode off that, but on a quick
> > look I don't see a flag field in the zone ctx.
> 
> I don't really follow what you mean here.
> 

I was just rambling about if/how we might be able to use the ac..

> > Hmm.. I wonder if we could still do something more clever where the zone
> > mode has its own injection site to bump the res, and then the lower
> > level logic just checks whether the reservation is sufficient for a full
> > zero..? I'm not totally sure if that's ultimately cleaner, but maybe
> > worth a thought..
> 
> We could have a different site for that injection, but we'd still need
> to move the current one or at least make it conditional so that it
> can't trigger for zoned mode.  I doubt that's less ugly than this
> version.
> 

Well yeah, it would look something like this at the current site:

	if (!is_inode_zoned() && XFS_TEST_ERROR(...) ||
	    ac->reserved_blocks == magic_default_res + len)
		xfs_zero_range(...);
	else
		xfs_free_file_space(...);

... and the higher level zoned code would clone the XFS_TEST_ERROR() to
create the block reservation condition to trigger it.

Alternatively perhaps you could make that check look something like:

	if (XFS_TEST_ERROR() && (!ac || ac->res > len))
		...
	else
		...

... and let the res side always bump the res in DEBUG mode, with a
fallback on -ENOSPC or something.

Actually the latter sounds potentially more clean to me, but I don't
object to this if not.

Brian

