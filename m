Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E7D38DE4
	for <linux-xfs@vger.kernel.org>; Fri, 10 May 2024 12:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715344464; cv=none; b=cRszws6NgKSiWVzKVVNQGxdsemMS/9ZtR0kjocb3fjcy2hJHED8dwG+KJHQawBQOaoN3yhttfRvBXsDAzrYHQnUFmiqn2bDthMS/27sbMiGDn9jCwv5OeVkhbAyL7syeYpjuDcSLVYDtddBmJietcQdHXeFNdxfqWOAwuJV4wSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715344464; c=relaxed/simple;
	bh=w8IuNDadnJ7e8otkTUQy/FUNUIhp2R3uUkcDfs1p0eA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m078Y/jHxPNloTBFx7MFsvmVE1/gx9Sgmsg89+GFdddgs6c74EqZYhyzI25T2Dr7SZdqabwPsytlf5sUkeVNAqpNfRBDy/XuiHVxe7/Lq121KVpQaCaB5bvVy09gLgH6ldjuGyfwk2rrbs0hEnoYuGH/DJ3w4gKZk8RRul8/s5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q2qjMvwd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q2qjMvwd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715344462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b3CKXkB7ANmM9fkAoMCAuvj+mrvULo3W+QZBbYxgBNk=;
	b=Q2qjMvwdIs9ph4PmANk2Xw3uz+uqz6ghutoZDJTsg582UaL/kXq/LikP7bN17vw1KQzocV
	TsgXBiTEmBayVW4rcapMBAUu6Mml19B9E3gYoG12WMOhYmiv5RqM9SwdHF99amy+sIs1B9
	qijK05jpwlg7qz1RWqydm/K3Ndyl3jM=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-528-V0BOj0HhNnyOeoOYftkXnQ-1; Fri,
 10 May 2024 08:34:18 -0400
X-MC-Unique: V0BOj0HhNnyOeoOYftkXnQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 264973806723;
	Fri, 10 May 2024 12:34:17 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.146])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BBD8449B522;
	Fri, 10 May 2024 12:34:16 +0000 (UTC)
Date: Fri, 10 May 2024 08:34:35 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Sam Sun <samsun1006219@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: restrict the h_size fixup in
 xlog_do_recovery_pass
Message-ID: <Zj4UW8bzYv7RGoST@bfoster>
References: <20240429070200.1586537-1-hch@lst.de>
 <20240429070200.1586537-3-hch@lst.de>
 <Zi-QJG3tuRptnDVX@bfoster>
 <20240429171552.GE31337@lst.de>
 <ZjDPIwcuh-j9JIjT@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZjDPIwcuh-j9JIjT@bfoster>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

On Tue, Apr 30, 2024 at 06:59:47AM -0400, Brian Foster wrote:
> On Mon, Apr 29, 2024 at 07:15:52PM +0200, Christoph Hellwig wrote:
> > On Mon, Apr 29, 2024 at 08:18:44AM -0400, Brian Foster wrote:
> > > > -		if (h_len > h_size && h_len <= log->l_mp->m_logbsize &&
> > > > +		if (!xfs_has_reflink(log->l_mp) && xfs_has_reflink(log->l_mp) &&
> > > > +		    h_len > h_size && h_len <= log->l_mp->m_logbsize &&
> > > 
> > > ... but I'm going to assume this hasn't been tested. ;) Do you mean to
> > > also check !rmapbt here?
> > 
> > Heh.  Well, it has been tested in that we don't do the fixup for the
> > reproducer fixed by the previous patch and in that xfstests still passes.
> > I guess nothing in there hits the old mkfs fixup, which isn't surprising.
> > 
> 
> Yeah.. (sorry, just teasing about the testing.. ;).
> 
> > > Can you please also just double check that we still handle the original
> > > mkfs problem correctly after these changes? I think that just means mkfs
> > > from a sufficiently old xfsprogs using a larger log stripe unit, and
> > > confirm the fs mounts (with a warning).
> > 
> > Yeah.  Is there any way to commit a fs image to xfstests so that we
> > actually regularly test for it?
> > 
> 
> Not sure.. ideally we could fuzz the log record header somehow or
> another to test for these various scenarios, since we clearly broke this
> once already.
> 
> I don't quite recall if I looked into that at the time of the original
> workaround. To Darrick's point, I wonder if there would be some use to
> an expert logformat command or something that allowed for some bonkers
> parameters (assuming something like that doesn't exist already).
> 
> I'm out on PTO for (at least) today, but I can take a closer look at
> that once I'm back and caught up...
> 

I've had a chance to poke at this a bit and so far I don't think it's as
straightforward as I'd hoped. The logformat command already exists,
which makes it pretty easy to malformat a log record, but the recovery
code only runs into this path on a dirty log. I suspect the original
issue that prompted this logic was something like a crash-recovery test
leading to log record trimming (i.e. simulated torn log writes) and then
happening onto previously mkfs-formatted log records that way, but that
is a guess at this point.

I did play around a bit with fuzzing h_size for those sorts of tests
(i.e. xfs/141), but that ran into other issues. I went back to using
xfsprogs v4.3 or so and that eventually also produces an unmountable
filesystem with a similar error (even with the h_size fix patch). It
fails to locate the head/tail, which is obviously necessary in order to
process the log and perform record validation, so I'm wondering if
something else changed on the kernel side to further gate this scenario.
Of course it's also possible I'm looking at things wrong and this is
just orthogonal to the original problem.

But given all of that, I am a little skeptical on the value of retaining
this logic at all. Does whatever test case that recently uncovered the
h_size problem leave a mountable filesystem, or does it just work around
bad behavior to provide a more graceful failure condition?

Brian

