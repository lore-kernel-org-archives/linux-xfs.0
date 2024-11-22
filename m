Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E285F23741
	for <linux-xfs@vger.kernel.org>; Fri, 22 Nov 2024 13:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732283298; cv=none; b=qKGBKJJCHJCSbN3oDozwXowxku3YgxYBwHyfKgdRjRx/2HocsHz8noSOMbiN5xHMQURhDA69R/fNub3IHUBKbVKcfp4tI8xkCPE+EfcRFOf9y1mJLIxZDqvvBkZ6DmWS5u35/wJU1KRUKuAFrKbXIEy8ldha+aaNaL4zxzv0b7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732283298; c=relaxed/simple;
	bh=AsnF7uMvN0eRtGXYhFrqMAg6m7h8jnSsCf6Fw641YuU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UnVLaKEMSqSuzWCmz2FItwqDhs0svJWdGX8AIiultQ6lyqgkoAjCYJIKicXEgD/BNR8WMO/VWAo1D8Rm/6IEj1VY09jvna5lovZV53W1m2C8Uz1d8LOTK58CUv4ERAoEhsfiVjdw/hRTftp3CnELXLyw91QwS7qgMxRN3YDilnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LcCIijKe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LcCIijKe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732283294;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bBZKEWhGhdVbuceKbj/OueVJxQ9kBbTeFdr8hEoXgCQ=;
	b=LcCIijKe3gN3d8kLWXhR6vUdVg8us8ZAidpPhV6Vs/3d854nBUkyIilTWER4ZDP5x3wpl/
	tmcU9QYZM2YuKJjlbKKUifYy8Iuhqt5Fhox1DmQ/phE3kLpqTyzIPRczEiQRcZQVtxFqx4
	h3ROM1ACOfAVhAz0sG0gXgp4E4d6Xuk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-597-qgktbsB4PtK-xRxHKOZNCA-1; Fri,
 22 Nov 2024 08:48:11 -0500
X-MC-Unique: qgktbsB4PtK-xRxHKOZNCA-1
X-Mimecast-MFC-AGG-ID: qgktbsB4PtK-xRxHKOZNCA
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 68D6A195FE06;
	Fri, 22 Nov 2024 13:48:10 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.120])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 50C6630000DF;
	Fri, 22 Nov 2024 13:48:09 +0000 (UTC)
Date: Fri, 22 Nov 2024 08:49:42 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 01/12] generic/757: fix various bugs in this test
Message-ID: <Z0CL9mrUeHxgwFFg@bfoster>
References: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs>
 <173197064441.904310.18406008193922603782.stgit@frogsfrogsfrogs>
 <20241121095624.ecpo67lxtrqqdkyh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20241121100555.GA4176@lst.de>
 <Zz8nWa1xGm7c2FHt@bfoster>
 <20241121131239.GA28064@lst.de>
 <Zz8_rFRio0vp07rd@bfoster>
 <20241122123133.GA26198@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241122123133.GA26198@lst.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Fri, Nov 22, 2024 at 01:31:33PM +0100, Christoph Hellwig wrote:
> On Thu, Nov 21, 2024 at 09:11:56AM -0500, Brian Foster wrote:
> > > I'm all for speeding up tests.  But relying on a unspecified side effect
> > > of an operation and then requiring a driver that implements that side
> > > effect without documenting that isn't really good practice.
> > > 
> > 
> > It's a hack to facilitate test coverage. It would obviously need to be
> > revisited if behavior changed sufficiently to break the test.
> > 
> > I'm not really sure what you're asking for wrt documentation. A quick
> > scan of the git history shows the first such commit is 65cc9a235919
> > ("generic/482: use thin volume as data device"), the commit log for
> > which seems to explain the reasoning.
> 
> A comment on _log_writes_init that it must only be used by dm-thin
> because it relies on the undocumented behavior that dm-trim zeroes
> all blocks discarded.
> 
> Or even better my moving the dm-think setup boilerplate into the log
> writes helpers, so that it gets done automatically.
> 

A related idea might be to incorporate your BLKZEROOUT fix so the core
tool is fundamentally correct, but then wrap the existing discard
behavior in a param or something that the dm-thin oriented tests can
pass to enable it as a fast zero hack/optimization.

But that all seems reasonable to me either way. I'm not sure that's
something I would have fully abstracted into the logwrites stuff
initially, but here we are ~5 years later and it seems pretty much every
additional logwrites test has wanted the same treatment. If whoever
wants to convert this newer test over wants to start by refactoring
things that way, that sounds like a welcome cleanup to me.

Brian

