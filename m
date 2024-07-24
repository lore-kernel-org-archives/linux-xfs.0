Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9CB13AA4E
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2024 22:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721859154; cv=none; b=I49Swg+NeeQbsfTxfpWxJnNziseVj8jVAnelhKVZWI94jbMYQ3P0jhTkV3OFWvYbxsb5WrlMxu9eJHIrOwjC1za/Q2lz5v8MfmrolHhjU5R2ZKTqHH8sUuVJ8p7S/0+taDQhpl+mpGk0/GeM4U1K+Mg24+ZZHL+S6O9jZFMQMTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721859154; c=relaxed/simple;
	bh=e3X1dCFmZ1Z8RIooBfLAmSR3yXsvrSJV0DGcB/G9pNo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lai7bV/YnfMqR4wVxBq7p3KWf4Qu4pbGkiNszl0tV2XgcB4rZIwXMzFseC0WSFjBF03pFMuytwEscM21cvQnGhep7tILH6CXoGqLhLiSPEd6h2vzpONsfIOcyVtOMdC7eRvc9Z4Z1PFJ4i1iOOuiijcvjj0H7fKgxsk39H+fmTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RKBeN6fn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RKBeN6fn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A4DC32781;
	Wed, 24 Jul 2024 22:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721859153;
	bh=e3X1dCFmZ1Z8RIooBfLAmSR3yXsvrSJV0DGcB/G9pNo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RKBeN6fnbHPhd9blD6oaizEDhYgtyWwe1echKVQdp2Uk3MdFcxObD+mpsLGJPGFil
	 be/bDB4o2pByr2sllRjnJDL1944FTEUuHNuqm6QQERLR4Rt20sekqYLkz6G1yJ3FQb
	 aUqRipMwJ7JwbyOadROG6wIX99FKTRF4QrYGqp3iq2QoOTIqZKOQiCOgoO+/fi4noA
	 U25zLblBmvaWeUuqpvg1g9c+hbNak5PltYGNhT+r5aQpeY7AuIqem1nkRbb1MYo12N
	 wxMLS0r1b1fkavoQs8YB0/z/e3/KVXMFut5OuR2shC0Ai8E49/eLOhxNmDUbQ0B4L9
	 E/+yxlsZ+y6kA==
Date: Wed, 24 Jul 2024 15:12:33 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] xfs: filesystem expansion design documentation
Message-ID: <20240724221233.GB612460@frogsfrogsfrogs>
References: <20240721230100.4159699-1-david@fromorbit.com>
 <345207bd-343a-417c-80b9-71e3c8d4ff28@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <345207bd-343a-417c-80b9-71e3c8d4ff28@sandeen.net>

On Wed, Jul 24, 2024 at 05:06:58PM -0500, Eric Sandeen wrote:
> On 7/21/24 6:01 PM, Dave Chinner wrote:
> > +The solution should already be obvious: we can exploit the sparseness of FSBNO
> > +addressing to allow AGs to grow to 1TB (maximum size) simply by configuring
> > +sb_agblklog appropriately at mkfs.xfs time. Hence if we have 16MB AGs (minimum
> > +size) and sb_agblklog = 30 (1TB max AG size), we can expand the AG size up
> > +to their maximum size before we start appending new AGs.
> 
> there's a check in xfs_validate_sb_common() that tests whether sg_agblklog is
> really the next power of two from sb_agblklog:
> 
> sbp->sb_agblklog != xfs_highbit32(sbp->sb_agblocks - 1) + 1
> 
> so I think the proposed idea would require a feature flag, right?
> 
> That might make it a little trickier as a drop-in replacement for cloud
> providers because these new expandable filesystem images would only work on
> kernels that understand the (trivial) new feature, unless I'm missing
> something.

agblklog and agblocks would both be set correctly if you did mkfs.xfs -d
agsize=1T on a small image; afaict it's only mkfs that cares that
dblocks >= agblocks.

--D

> -Eric
> 
