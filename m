Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E61E12FF97
	for <linux-xfs@vger.kernel.org>; Tue,  6 Feb 2024 13:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707226015; cv=none; b=lp4oMJBVDAy6rQ4oCPQ1MZHpt6BBnmWQ6YIzl2O+nAbfo2HoWnjAwLZ+WWIGCRX/kf+Ft0aqc6J4YiZcRfAsYMI3/KFNGtMD/Q69MGTnAGfP9CGHITJ38ksP7LlSq2TKCREnWNtYoKCmTSzXPFe1GdabsOxo0NmyrLJFCi1+snU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707226015; c=relaxed/simple;
	bh=OWnDHninWBGlsK6kde8sahvh/MkST80LhRjNny40YLc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HI8QqGGDLJ/Ktrepi6iCSmMYILo9GoAI5BXG/akxRi9P/2rZwsySSBSHTbE6F/QXss+o83szXiSskYQSt32kUJgg//1Pgh09UjRoYRg6/Yh1TxbTZeWnkN6Wf80BEXHygowQqdQBO/uSICQr2sBbISGw5rIK2Zx9YWYKzC+IL+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WGrFrwRg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WGrFrwRg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707226012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jwYHRgJ7LgUPOh7+K2kkuIL88qPOFIBPuIz2q7F9AHs=;
	b=WGrFrwRgkwzwpAlgdL7Vob+ku/rq8ASuPj39vMjyRM+uMoYMfwnd82zZaVav8k7wa+k07J
	AyCFANc9gLewbfP9ak+UFyh/pKnsfC2QHcJ89lK/aI+D91MnSPHKjCA0A7MZF2TRhiW7JU
	GPrYsm9VvnI7b+gIiABNMLyproVO0A4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-161-9tUncrrXP-yJHw4GsbO93w-1; Tue, 06 Feb 2024 08:26:51 -0500
X-MC-Unique: 9tUncrrXP-yJHw4GsbO93w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 10F18835347;
	Tue,  6 Feb 2024 13:26:51 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.186])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D05772026D06;
	Tue,  6 Feb 2024 13:26:50 +0000 (UTC)
Date: Tue, 6 Feb 2024 08:28:09 -0500
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v2] xfs: run blockgc on freeze to avoid iget stalls
 after reclaim
Message-ID: <ZcIz6V7EAYLW7cgO@bfoster>
References: <20240119193645.354214-1-bfoster@redhat.com>
 <Za3fwLKtjC+B8aZa@dread.disaster.area>
 <ZbJYP63PgykS1CwU@bfoster>
 <ZbLyxHSkE5eCCRRZ@dread.disaster.area>
 <Zbe9+EY5bLjhPPJn@bfoster>
 <Zbrw07Co5vhrDUfd@dread.disaster.area>
 <Zb1FhDn09pwFvE7O@bfoster>
 <20240202233343.GM616564@frogsfrogsfrogs>
 <Zb+1O+MlTpzHZ595@bfoster>
 <20240205220727.GN616564@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240205220727.GN616564@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On Mon, Feb 05, 2024 at 02:07:27PM -0800, Darrick J. Wong wrote:
> On Sun, Feb 04, 2024 at 11:03:07AM -0500, Brian Foster wrote:
> > On Fri, Feb 02, 2024 at 03:33:43PM -0800, Darrick J. Wong wrote:
> > > On Fri, Feb 02, 2024 at 02:41:56PM -0500, Brian Foster wrote:
> > > > On Thu, Feb 01, 2024 at 12:16:03PM +1100, Dave Chinner wrote:
> > > > > On Mon, Jan 29, 2024 at 10:02:16AM -0500, Brian Foster wrote:
> > > > > > On Fri, Jan 26, 2024 at 10:46:12AM +1100, Dave Chinner wrote:
> > > > > > > On Thu, Jan 25, 2024 at 07:46:55AM -0500, Brian Foster wrote:
> > > > > > > > On Mon, Jan 22, 2024 at 02:23:44PM +1100, Dave Chinner wrote:
> > > > > > > > > On Fri, Jan 19, 2024 at 02:36:45PM -0500, Brian Foster wrote:
> > > > ...
> > > > > Here's the fixes for the iget vs inactive vs freeze problems in the
> > > > > upstream kernel:
> > > > > 
> > > > > https://lore.kernel.org/linux-xfs/20240201005217.1011010-1-david@fromorbit.com/T/#t
> > > > > 
> > > > > With that sorted, are there any other issues we know about that
> > > > > running a blockgc scan during freeze might work around?
> > > > > 
> > > > 
> > > > The primary motivation for the scan patch was the downstream/stable
> > > > deadlock issue. The reason I posted it upstream is because when I
> > > > considered the overall behavior change, I thought it uniformly
> > > > beneficial to both contexts based on the (minor) benefits of the side
> > > > effects of the scan. You don't need me to enumerate them, and none of
> > > > them are uniquely important or worth overanalyzing.
> > > > 
> > > > The only real question that matters here is do you agree with the
> > > > general reasoning for a blockgc scan during freeze, or shall I drop the
> > > > patch?
> > > 
> > 
> > Hi Darrick,
> > 
> > > I don't see any particular downside to flushing {block,inode}gc work
> > > during a freeze, other than the loss of speculative preallocations
> > > sounds painful.
> > > 
> > 
> > Yeah, that's definitely a tradeoff. The more I thought about that, the
> > more ISTM that any workload that might be sensitive enough to the
> > penalty of an extra blockgc scan, the less likely it's probably going to
> > see freeze cycles all that often.
> > 
> > I suspect the same applies to the bit of extra work added to the freeze
> > as well , but maybe there's some more painful scenario..?
> 
> <shrug> I suppose if you had a few gigabytes of speculative
> preallocations across a bunch of log files (or log structured tree
> files, or whatever) then you could lose those preallocations and make
> fragmentation worse.  Since blockgc can run on open files, maybe we
> should leave that out of the freeze preparation syncfs?
> 

By "leave that out," do you mean leave out the blockgc scan on freeze,
or use a special mode that explicitly skips over opened/writeable files?

FWIW, this sounds more like a generic improvement to the background scan
to me. Background blockgc currently filters out on things like whether
the file is dirty in pagecache. If you have a log file or something, I
would think the regular background scan may end up processing such files
more frequently than a freeze induced one will..? And for anything that
isn't under active or continuous modification, freeze is already going
to flush everything out for the first post-unfreeze background scan to
take care of.

So I dunno, I think I agree and disagree. :) I think it would be
perfectly reasonable to add an open/writeable file filter check to the
regular background scan to make it less aggressive. This patch does
invoke the background scan, but only because of the wonky read into a
mapped buffer use case. I still think freeze should (eventually) rather
invoke the more aggressive sync scan and process all pending work before
quiesce and not alter behavior based on heuristics.

> OTOH most of the inodes on those lists are not open at all, so perhaps
> we /should/ kick inodegc while preparing for freeze?  Such a patch could
> reuse the justification below after s/blockgc/inodegc/.  Too bad we
> didn't think far enough into the FIFREEZE design to allow userspace to
> indicate if they want us to minimize freeze time or post-freeze
> recovery time.
> 

Yeah, I think this potentially ties in interestingly with the
security/post freeze drop caches thing Christian brought up on fsdevel
recently. It would be more ideal if freeze actually had some controls
that different use cases could use to suggest how aggressive (or not) to
be with such things. Maybe that somewhat relates to the per-stage
->freeze_fs() prototype thing I posted earlier in the thread [1] to help
support running a sync scan.

Given the current implementation, I think ultimately it just depends on
your perspective of what freeze is supposed to do. To me, it should
reliably put the filesystem into a predictable state on-disk (based on
the common snapshot use case). It is a big hammer that should be
scheduled with care wrt to any performance sensitive workloads, and
should be minimally disruptive to the system when held for a
non-deterministic/extended amount of time. Departures from that are
either optimizations or extra feature/modifiers that we currently don't
have a great way to control. Just my .02.

Brian

[1] Appended to this reply:
  https://lore.kernel.org/linux-xfs/ZbJYP63PgykS1CwU@bfoster/

> --D
> 
> > > Does Dave's patchset to recycle NEEDS_INACTIVE inodes eliminate the
> > > stall problem?
> > > 
> > 
> > I assume it does. I think some of the confusion here is that I probably
> > would have gone in a slightly different direction on that issue, but
> > that's a separate discussion.
> > 
> > As it relates to this patch, in hindsight I probably should have
> > rewritten the commit log from the previous version. If I were to do that
> > now, it might read more like this (factoring out sync vs. non-sync
> > nuance and whatnot):
> > 
> > "
> > xfs: run blockgc on freeze to keep inodes off the inactivation queues
> > 
> > blockgc processing is disabled when the filesystem is frozen. This means
> > <words words words about blockgc> ...
> > 
> > Rather than hold pending blockgc inodes in inactivation queues when
> > frozen, run a blockgc scan during the freeze sequence to process this
> > subset of inodes up front. This allows reclaim to potentially free these
> > inodes while frozen (by keeping them off inactive lists) and produces a
> > more predictable/consistent on-disk freeze state. The latter is
> > potentially beneficial for shapshots, as this means no dangling post-eof
> > preallocs or cowblock recovery.
> > 
> > Potential tradeoffs for this are <yadda yadda, more words from above>
> > ...
> > "
> > 
> > ... but again, the primary motivation for this was still the whole
> > deadlock thing. I think it's perfectly reasonable to look at this change
> > and say it's not worth it. Thanks for the feedback.
> > 
> > Brian
> > 
> > > --D
> > > 
> > > > Brian
> > > > 
> > > > > -Dave.
> > > > > -- 
> > > > > Dave Chinner
> > > > > david@fromorbit.com
> > > > > 
> > > > 
> > > > 
> > > 
> > 
> > 
> 

