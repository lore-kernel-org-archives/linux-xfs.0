Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3FD1369AA
	for <linux-xfs@vger.kernel.org>; Thu, 21 Nov 2024 12:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732192003; cv=none; b=k1uono3y/1xJzXI9qFvDB3C5A+QZR1YrtGKl818/nDCCIdjEiljq/U/NcRQH4Fj5DBNNOA6m+S8V4xTXDSNxfcZNGqKL78m8XO+X7Jq/UlJNzLZ07AAnHFpm5HiT2QPqYeeLn38VYsp/lI1VlBiFH7VdEP6bOA4CSUuWrHLyjYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732192003; c=relaxed/simple;
	bh=2gmw3TtZ74evWqkZQOXp6WpK76bL6NXcauu2H9BR1nU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jShiyh0dYfKVzgvBpREeFF0/Iu49uoqPeVGYhrzeRLUBdG8AR5oxHo3aN+7yQrKv0AHBoUIDV3f9plyqlHc2/ITqpA0UD5sp3oDfu//P9eJZ4n5VB3G0OrI4KPWqLxBLlvg8M3x7hxMtypjWcOUl87rGEpS8Qua+HCu2zIZRaj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XKaDNa+B; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XKaDNa+B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732192001;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qo7XCeVVX8IhUqQcJEWyVxTZVzwZoHMSPGQc0XsIWiM=;
	b=XKaDNa+B86/r6Oq0EEETpAoWchnu+6tZGd679lxU3RkB0FELxij85YjLW1ZIg/w7EuxCF3
	4i3IrvDohrt05g7LsohXYt6MUQUovdeYj3VihzrjiCEPU0qmQZq2N6X3zo1A4EB8YIyt+Q
	z8/rgc5Sc6Ll4fk7bkSY+a30/eMDuuc=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-633-NUpJdBgxOxK71wpBGIq94A-1; Thu,
 21 Nov 2024 07:26:39 -0500
X-MC-Unique: NUpJdBgxOxK71wpBGIq94A-1
X-Mimecast-MFC-AGG-ID: NUpJdBgxOxK71wpBGIq94A
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 54A571955F2D;
	Thu, 21 Nov 2024 12:26:38 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.120])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3C32530000DF;
	Thu, 21 Nov 2024 12:26:37 +0000 (UTC)
Date: Thu, 21 Nov 2024 07:28:09 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 01/12] generic/757: fix various bugs in this test
Message-ID: <Zz8nWa1xGm7c2FHt@bfoster>
References: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs>
 <173197064441.904310.18406008193922603782.stgit@frogsfrogsfrogs>
 <20241121095624.ecpo67lxtrqqdkyh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20241121100555.GA4176@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241121100555.GA4176@lst.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Thu, Nov 21, 2024 at 11:05:55AM +0100, Christoph Hellwig wrote:
> On Thu, Nov 21, 2024 at 05:56:24PM +0800, Zorro Lang wrote:
> > I didn't merge this patch last week, due to we were still talking
> > about the "discards" things:
> > 
> > https://lore.kernel.org/fstests/20241115182821.s3pt4wmkueyjggx3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com/T/#u
> > 
> > Do you think we need to do a force discards at here, or change the
> > SCRATCH_DEV to dmthin to support discards?
> 
> FYI, I'm seeing regular failures with generic/757 when using Darrick's
> not yet merged RT rmap support, but only with that.
> 
> But the whole discard thing leaves me really confused, and the commit
> log in the patch references by the above link doesn't clear that up
> either.
> 
> Why does dmlogwrites require discard for XFS (and apprently XFS only)?
> Note that discard is not required and often does not zero data.  So
> if we need data to be zeroed we need to do that explicitly, and
> preferably in a way that is obvious.
> 

IIRC it was to accommodate the test program, which presumably used
discard for efficiency reasons because it did a lot of context switching
to different point-in-time variations of the fs. If the discard didn't
actually zero the range (depending on the underlying test dev), then at
least on XFS, we'd see odd recovery issues and whatnot from the fs going
forward/back in time.

Therefore the reason for using dm-thin was that it was an easy way to
provide predictable behavior to the test program, where discards punch
out blocks that subsequently return zeroes.

I don't recall all the specifics, but I thought part of the reason for
using discard over explicit zeroing was the latter made the test
impractically slow. I could be misremembering, but if you want to change
it I'd suggest to at least verify runtimes on some of the preexisting
logwrites tests as well.

Brian

