Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43DC282F0A
	for <linux-xfs@vger.kernel.org>; Fri, 17 Jul 2026 14:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784297600; cv=none; b=ATTuHHNUchqJqlRDdpkGprBWUOLKAyVpgtj8z6C3ShZogrn4GSu6J+O2m3PWvOPec5ycjVJ+0rk2qEBjMaiwS0Q1rQ9WqoGqQMkF5Mfb8onFMxgs8W47h5dHsYFEYd5d3q93RHfkaM87EWT+yiOdo3Jw2XP7ngZ8g9/Ve9n5Cqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784297600; c=relaxed/simple;
	bh=ZfbLmBwaw+8SYRCs+q5wR2WKvWNdo/gDw0/9mdBJMK0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CK+RInnvR7OInALTIDUOhAbpli+PBFRD6jdRQP1KQ7F9Wus00M3lQ8lJ0qBsSG6rowYc4jMF9eM8I+ruKKEWrsGUD3Kvh20Onv2mwA8rX1IUj9RdXtGFR1bO7bdZY2ebJxPvG0+SO+FUAwghA5KZA8gfVpxnnpFNCD7M4TifhA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PKMvIz5i; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PKMvIz5i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784297597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xjUAUQ1Gr6hL4GKDP0CBhOkbK0uEYNzYWH6Mvqu21Xs=;
	b=PKMvIz5iYKeecS1CaCPkisghFmzg8/UQmGIfQ0QZKJ4vAOPLK4Cu4D8WHeRcdlBM6Aq2mI
	JKYnymHzgAkuUn/YwolZgI9LaITLwa/XokRJuGTxKerUpOBvIfyxXxDrvnYdBufVD9MyfU
	TIfxvP8+DhPQQVWG96m5MTqwDx+u6Hk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-474-cMGX3nO6NOOvf6Dpq85B2Q-1; Fri,
 17 Jul 2026 10:13:14 -0400
X-MC-Unique: cMGX3nO6NOOvf6Dpq85B2Q-1
X-Mimecast-MFC-AGG-ID: cMGX3nO6NOOvf6Dpq85B2Q_1784297593
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 51E3A1800771;
	Fri, 17 Jul 2026 14:13:13 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.111])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8C5421955D89;
	Fri, 17 Jul 2026 14:13:12 +0000 (UTC)
Date: Fri, 17 Jul 2026 10:13:10 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/12] xfs: consolidate buffer locking in xfs_buf_get_map
Message-ID: <alo4doLYG7BzuCfO@bfoster>
References: <20260715145147.95654-1-hch@lst.de>
 <20260715145147.95654-3-hch@lst.de>
 <aljY0uI6jY8y2b3Z@bfoster>
 <20260717085950.GA32056@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717085950.GA32056@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Fri, Jul 17, 2026 at 10:59:50AM +0200, Christoph Hellwig wrote:
> On Thu, Jul 16, 2026 at 09:12:50AM -0400, Brian Foster wrote:
> > > -	/*
> > > -	 * A new buffer is held and locked by the owner.  This ensures that the
> > > -	 * buffer is owned by the caller and racing RCU lookups right after
> > > -	 * inserting into the hash table are safe (and will have to wait for
> > > -	 * the unlock to do anything non-trivial).
> > > -	 */
> > >  	lockref_init(&bp->b_lockref);
> > > -	sema_init(&bp->b_sema, 0); /* held, no waiters */
> > > +	sema_init(&bp->b_sema, 1); /* unlocked */
> > 
> > Maybe I'm missing something, but I thought the point of the locked init
> > was to ensure that the allocator owns the buffer and can't end up
> > blocking on the lock with a racing lookup. I.e., the buffer is locked
> > before it becomes available for external lookup. Do we plan to do that
> > another way, or are we just dropping that assumption?
> 
> The comment has been stale for a while.  b_sema is not involved in
> lookup synchronization in any way.  Only the lockref is needed to actually
> get a stable buffer reference.  Once we have a stable buffer reference,
> b_sema is used to protect again multiple readers trying to actually
> read the data (for xfs_buf_read*), but we don't care if that is done
> by the thread that allocated the buffer or not.
> 

Hm, Ok. I read the comment as wanting to guarantee that the allocator
gets first crack at the buffer lock, but looking at it again it says it
ensures "racing RCU lookups right after inserting into the hash table
are safe," and indeed that seems to be a little different.

I see that you're intentionally separating out the lookup from the buf
data locking, but it does still look like we're making a potential
functional tradeoff here by changing the insertion side locking. Note
that I don't object or know that it matters in any way, I'd just suggest
to add a note about this in the commit log in case somebody has to refer
back to this in the future.

Otherwise I read through the rest of the series and modulo a nit on
patch 10, it all looks reasonable to me. For the series:

Reviewed-by: Brian Foster <bfoster@redhat.com>

