Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2DDF22615
	for <linux-xfs@vger.kernel.org>; Sun,  4 Feb 2024 16:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707062515; cv=none; b=g57EyLzE4i7tBTFh+aIXevNF+ISy+xk/F2xEqews6lnCKIrcyWshq7IYl5Y4xcrxgUecnwGxtiZXWNoz7TkWO7fpy+wC//GmheV1dNvk3ZaY00tineX6GdG2v05R4byc8VJalqyxJ4BdyuxFXrp+PszinM3jgIhZOweSQWexR9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707062515; c=relaxed/simple;
	bh=sEG/mn0mL0mRSoE7Zw8lBkTsneix+O3HHJIMQ+djtek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BN2sAW0qqUdF3n+xtwlRletG+6citXoUy7+t4f3X2d3v91vbmfUqd/erPXCBojrDo7xPsjgndEr6/52eLQMOMqQ2LWzVkVuPIjao4WhrgR6C2pvUONXQcOzxHMHj7v7F9rPBbpDHUQ1VIAG65Vr0H91LY3GlBpO5+Rww7aY1Q/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TbRcIRiL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TbRcIRiL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707062512;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J1ic7UrZstn8733cq7rByObbW0ifSqH7KNOFeiLGjgI=;
	b=TbRcIRiLf6LLzce46jQS/BgVtnHvmUEIBoYjuHWFtqddvFjzPmCyLHg39onQTdOfnBphhv
	omSN0RFHXVHZ1/j3N+siNXApW2vQXBxFOQpxVKMDk5OKlpqWX0vkP3v/OhRnvN3u85BdGE
	Nv2GC0IUbsg34iIyZ8BULULmUTO9D+Y=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-613-k-q4CRGpOAeFbacEIBy8Eg-1; Sun,
 04 Feb 2024 11:01:49 -0500
X-MC-Unique: k-q4CRGpOAeFbacEIBy8Eg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DD1741C05AD0;
	Sun,  4 Feb 2024 16:01:48 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.186])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AEE6C492BC6;
	Sun,  4 Feb 2024 16:01:48 +0000 (UTC)
Date: Sun, 4 Feb 2024 11:03:07 -0500
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v2] xfs: run blockgc on freeze to avoid iget stalls
 after reclaim
Message-ID: <Zb+1O+MlTpzHZ595@bfoster>
References: <20240119193645.354214-1-bfoster@redhat.com>
 <Za3fwLKtjC+B8aZa@dread.disaster.area>
 <ZbJYP63PgykS1CwU@bfoster>
 <ZbLyxHSkE5eCCRRZ@dread.disaster.area>
 <Zbe9+EY5bLjhPPJn@bfoster>
 <Zbrw07Co5vhrDUfd@dread.disaster.area>
 <Zb1FhDn09pwFvE7O@bfoster>
 <20240202233343.GM616564@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240202233343.GM616564@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

On Fri, Feb 02, 2024 at 03:33:43PM -0800, Darrick J. Wong wrote:
> On Fri, Feb 02, 2024 at 02:41:56PM -0500, Brian Foster wrote:
> > On Thu, Feb 01, 2024 at 12:16:03PM +1100, Dave Chinner wrote:
> > > On Mon, Jan 29, 2024 at 10:02:16AM -0500, Brian Foster wrote:
> > > > On Fri, Jan 26, 2024 at 10:46:12AM +1100, Dave Chinner wrote:
> > > > > On Thu, Jan 25, 2024 at 07:46:55AM -0500, Brian Foster wrote:
> > > > > > On Mon, Jan 22, 2024 at 02:23:44PM +1100, Dave Chinner wrote:
> > > > > > > On Fri, Jan 19, 2024 at 02:36:45PM -0500, Brian Foster wrote:
> > ...
> > > Here's the fixes for the iget vs inactive vs freeze problems in the
> > > upstream kernel:
> > > 
> > > https://lore.kernel.org/linux-xfs/20240201005217.1011010-1-david@fromorbit.com/T/#t
> > > 
> > > With that sorted, are there any other issues we know about that
> > > running a blockgc scan during freeze might work around?
> > > 
> > 
> > The primary motivation for the scan patch was the downstream/stable
> > deadlock issue. The reason I posted it upstream is because when I
> > considered the overall behavior change, I thought it uniformly
> > beneficial to both contexts based on the (minor) benefits of the side
> > effects of the scan. You don't need me to enumerate them, and none of
> > them are uniquely important or worth overanalyzing.
> > 
> > The only real question that matters here is do you agree with the
> > general reasoning for a blockgc scan during freeze, or shall I drop the
> > patch?
> 

Hi Darrick,

> I don't see any particular downside to flushing {block,inode}gc work
> during a freeze, other than the loss of speculative preallocations
> sounds painful.
> 

Yeah, that's definitely a tradeoff. The more I thought about that, the
more ISTM that any workload that might be sensitive enough to the
penalty of an extra blockgc scan, the less likely it's probably going to
see freeze cycles all that often.

I suspect the same applies to the bit of extra work added to the freeze
as well , but maybe there's some more painful scenario..?

> Does Dave's patchset to recycle NEEDS_INACTIVE inodes eliminate the
> stall problem?
> 

I assume it does. I think some of the confusion here is that I probably
would have gone in a slightly different direction on that issue, but
that's a separate discussion.

As it relates to this patch, in hindsight I probably should have
rewritten the commit log from the previous version. If I were to do that
now, it might read more like this (factoring out sync vs. non-sync
nuance and whatnot):

"
xfs: run blockgc on freeze to keep inodes off the inactivation queues

blockgc processing is disabled when the filesystem is frozen. This means
<words words words about blockgc> ...

Rather than hold pending blockgc inodes in inactivation queues when
frozen, run a blockgc scan during the freeze sequence to process this
subset of inodes up front. This allows reclaim to potentially free these
inodes while frozen (by keeping them off inactive lists) and produces a
more predictable/consistent on-disk freeze state. The latter is
potentially beneficial for shapshots, as this means no dangling post-eof
preallocs or cowblock recovery.

Potential tradeoffs for this are <yadda yadda, more words from above>
...
"

... but again, the primary motivation for this was still the whole
deadlock thing. I think it's perfectly reasonable to look at this change
and say it's not worth it. Thanks for the feedback.

Brian

> --D
> 
> > Brian
> > 
> > > -Dave.
> > > -- 
> > > Dave Chinner
> > > david@fromorbit.com
> > > 
> > 
> > 
> 

