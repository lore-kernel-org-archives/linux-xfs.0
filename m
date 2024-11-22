Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E191CD1F
	for <linux-xfs@vger.kernel.org>; Fri, 22 Nov 2024 16:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732293122; cv=none; b=YFFV/L8RqhRvsOyFWh1ltdrRYR+2qjI7GYanF8VGDOPrZpO2qHV2m2CVhAZwaZxVDwYTJgLjm8pJ2nCbVPd6yQprb3i7VFNoUKLB/PI253+rvA+rgh2Zvd6gClGxrgrj7RZiqd1tGb0Ipil1Y7Y3UffvMCJlqFqhOMeN2uFCrT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732293122; c=relaxed/simple;
	bh=+/tJRw7H2Ay7pglgrxS52dOS6AQOu3WoFu1t1FIqtqI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fEeApacESAfWwXRvJzsTXDAlA1gGz/2OXCDBjN2oNAcbvDM0f5N92BHQzmCSaoEfuuPMXORfot29C5h9WVY49SYxzxURsJPoXmZjiW/VsjhqjPi3zdgCpgk3T+e3qbtA+i6EETNLHcfZJAQB4VzMmEncml9HxNm38TFpVypODFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fyoCss2A; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fyoCss2A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732293119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P1WpnqqKKsuqzXdB0shT8FPKd8Nc3blA1kWmDETsRHk=;
	b=fyoCss2Ac5ILcS7vqSD5zW5Z/UbnEFnWdrO8mvxahmW0vck878Awa7BhQVk4itX95A14jW
	2hxAPZykGGQNe8xn1BF4JLR5TdG1YRfxE8Y01l4TB9NijcTXNBLgWJP9MNRY85NFUhlYGI
	MUX486BS9lgGRcCos8Z22FzxT637RHc=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-615-x-pCGF8SP5uXkR-F_YiRYA-1; Fri,
 22 Nov 2024 11:31:56 -0500
X-MC-Unique: x-pCGF8SP5uXkR-F_YiRYA-1
X-Mimecast-MFC-AGG-ID: x-pCGF8SP5uXkR-F_YiRYA
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9255419540F2;
	Fri, 22 Nov 2024 16:31:52 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.120])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 81FC019560A3;
	Fri, 22 Nov 2024 16:31:51 +0000 (UTC)
Date: Fri, 22 Nov 2024 11:33:24 -0500
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@redhat.com>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 01/12] generic/757: fix various bugs in this test
Message-ID: <Z0CyVHd4MmhurX8B@bfoster>
References: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs>
 <173197064441.904310.18406008193922603782.stgit@frogsfrogsfrogs>
 <20241121095624.ecpo67lxtrqqdkyh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20241121100555.GA4176@lst.de>
 <Zz8nWa1xGm7c2FHt@bfoster>
 <20241121131239.GA28064@lst.de>
 <Zz8_rFRio0vp07rd@bfoster>
 <20241122123133.GA26198@lst.de>
 <Z0CL9mrUeHxgwFFg@bfoster>
 <20241122161347.GA9425@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241122161347.GA9425@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Fri, Nov 22, 2024 at 08:13:47AM -0800, Darrick J. Wong wrote:
> On Fri, Nov 22, 2024 at 08:49:42AM -0500, Brian Foster wrote:
> > On Fri, Nov 22, 2024 at 01:31:33PM +0100, Christoph Hellwig wrote:
> > > On Thu, Nov 21, 2024 at 09:11:56AM -0500, Brian Foster wrote:
> > > > > I'm all for speeding up tests.  But relying on a unspecified side effect
> > > > > of an operation and then requiring a driver that implements that side
> > > > > effect without documenting that isn't really good practice.
> > > > > 
> > > > 
> > > > It's a hack to facilitate test coverage. It would obviously need to be
> > > > revisited if behavior changed sufficiently to break the test.
> > > > 
> > > > I'm not really sure what you're asking for wrt documentation. A quick
> > > > scan of the git history shows the first such commit is 65cc9a235919
> > > > ("generic/482: use thin volume as data device"), the commit log for
> > > > which seems to explain the reasoning.
> > > 
> > > A comment on _log_writes_init that it must only be used by dm-thin
> > > because it relies on the undocumented behavior that dm-trim zeroes
> > > all blocks discarded.
> > > 
> > > Or even better my moving the dm-think setup boilerplate into the log
> > > writes helpers, so that it gets done automatically.
> > > 
> > 
> > A related idea might be to incorporate your BLKZEROOUT fix so the core
> > tool is fundamentally correct, but then wrap the existing discard
> > behavior in a param or something that the dm-thin oriented tests can
> > pass to enable it as a fast zero hack/optimization.
> > 
> > But that all seems reasonable to me either way. I'm not sure that's
> > something I would have fully abstracted into the logwrites stuff
> > initially, but here we are ~5 years later and it seems pretty much every
> > additional logwrites test has wanted the same treatment. If whoever
> > wants to convert this newer test over wants to start by refactoring
> > things that way, that sounds like a welcome cleanup to me.
> 
> Ugh, I just want to fix this stupid test and move on with the bugfixes,
> not refactor every logwrites user in the codebase just to reduce one
> test's runtime from hours to 90s.
> 
> It's not as simple as making the logwrites init function set up thinp on
> its own, because there's at least one test out there (generic/470) that
> takes care of its own discarding, and then there's whatever the strange
> stuff that the tests/btrfs/ users do -- it looks fairly simple, but I
> don't really want to go digging into that just to make sure I didn't
> break their testing.
> 
> I'll send what I have currently, which adds a warning about running
> logwrites on a device that supports discard but isn't thinp... in
> addition to fixing the xfs log recovery thing, and in addition to fixing
> the loop duration.
> 
> I guess I can add yet another patch to switch the replay program to use
> BLKDISCARD if the _init function thinks it's ok, but seriously... you
> guys need to send start sending patches implementing the new
> functionality that you suggest.
> 

Sorry, I should have been more clear. I certainly don't insist on it as
an immediate change or to gatekeep the current patch. I'm just acking
the idea, and I think it's perfectly fair to say "more time consuming
than I have time for right now" if you planned to just fixup the test
itself. I may get to it opportunistically someday, or if hch cares
enough about it he's certainly capable of picking it up sooner.

For future reference, I'm generally not trying to tell people what to do
with their patches or force work on people, etc. I realize we have a
tendency to do that. I don't like it either. It would be nice if we had
a clearer way to express/discuss an idea without implying it as a
demand.

Brian

> --D
> 
> > Brian
> > 
> > 
> 

