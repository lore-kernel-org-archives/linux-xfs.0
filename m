Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B32306B0A
	for <linux-xfs@vger.kernel.org>; Fri, 19 Dec 2025 14:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766152907; cv=none; b=lgh+6PGKmhfWwbpDjWsASY/WfgVUT0lPORnShiImSA6AARmxw9d1hrpiOe0T8l1edcG2zPgjyLG/m98eGiGfiGtCwAdCFIQ5FoKYEVTPt2CAgOUfa0ojmOwgrKdRclS2N6WinVJRmaLvXeAsOLW6M9Rc1GHximsL1ytRiZNZ1+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766152907; c=relaxed/simple;
	bh=1OioLDwhhEplst68BF2sle89E4AoStybwRY5f5c0mT8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W0nz3ymaoNngSebSxDy3hCdC279/h4qw37dDHTvP5HSFs2nj2p4ED54vPhmOO+MENO+3ANKJ7Zxrz2pcjiEKWQyapgeuft9hgHu0sUBvLRoqNJxkfMOPZLjwhu8y+z5RDt5px0O8gr9yVCyrqdxQZWyv+vsS2VVwJvqiZQjOut8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dO4FywHy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dO4FywHy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766152905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XXf+G1cOYVbJNfIBwXMh3xIvqqpCt67mjjk6mGaNKng=;
	b=dO4FywHyztHoKHAg0i4Ar2VTCDbUNGmx6MX1hS8d9xwriKW6fZtafPtu48cZKDgViT4dor
	NMHjYPJqNM80H1FsIRSRSP0EfJsAr5zbK/fvlwCNHKH5xnEu6hvGwn9MzT+CL0++81y6Lm
	TQitNG7O/jx7hG2Ws2E6vFreOH3q7ys=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-363-C7Pg6LYEMnWqhGEshX068Q-1; Fri,
 19 Dec 2025 09:01:41 -0500
X-MC-Unique: C7Pg6LYEMnWqhGEshX068Q-1
X-Mimecast-MFC-AGG-ID: C7Pg6LYEMnWqhGEshX068Q_1766152900
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C9F0C1955D84;
	Fri, 19 Dec 2025 14:01:40 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.2])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 30E921800576;
	Fri, 19 Dec 2025 14:01:40 +0000 (UTC)
Date: Fri, 19 Dec 2025 09:01:38 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: fix XFS_ERRTAG_FORCE_ZERO_RANGE for zoned file
 system
Message-ID: <aUVawo2af1SHS47z@bfoster>
References: <20251215060654.478876-1-hch@lst.de>
 <aUGrpyS6BG0CD-kn@bfoster>
 <20251219052803.GA29788@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219052803.GA29788@lst.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Fri, Dec 19, 2025 at 06:28:03AM +0100, Christoph Hellwig wrote:
> On Tue, Dec 16, 2025 at 01:57:43PM -0500, Brian Foster wrote:
> > > +	if (xfs_is_zoned_inode(ip)) {
> > > +		if (ac->reserved_blocks > XFS_ZONED_ZERO_EDGE_SPACE_RES) {
> > > +			ASSERT(IS_ENABLED(CONFIG_XFS_DEBUG));
> > 
> > JFYI the reason I suggested a config check was as a safeguard against
> > forced zeroing on production kernels. The assert here would compile out
> > in that case, so won't necessarily provide that benefit (unless you
> > wanted to use ASSERT_ALWAYS() or WARN() or something..).
> > 
> > A warning on WARN && !DEBUG is still useful so I don't really care if
> > you leave it as is or tweak it. I just wanted to point that out.
> 
> I really think that anyone who modidifies this area should run a debug
> kernel to test.  And if they the usual automated runs will catch it.
> Having allocation beahvior modified based on CONFIG_XFS_DEBUG, and only
> for a case that isn't supposed to happen seems weird and in would cause
> weird heisenbugs if it ever hit.
> 

I agree on testing but XFS_DEBUG has always included some quirks that
alter algorithms and such to improve test coverage in this way. The
subtlety here is that this will only "catch it" on XFS_WARN (i.e.
!XFS_DEBUG). Otherwise this will quietly do forced zeroing. The
userspace tests should ideally pass because iomap zeroing is generally
expected to work, so there's no presumed test failure to rely on to
detect this. The assert won't fire unless XFS_WARN because either
XFS_DEBUG is enabled (so the assert passes) or if on a production
kernel, then the assert is compiled out.

I think if we broke it we'd eventually catch it one way or another, such
as if anybody is testing XFS_WARN regularly(?), but that loose end was
my reasoning for at least enforcing that production kernels run as
expected no matter what. Alternatively if we changed it to WARN_ON_ONCE
then that might provide more of a guarantee. But again just my .02.

Brian

