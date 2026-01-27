Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC2B2F3632
	for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 15:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769528546; cv=none; b=G/TkXvxmDz7cnasjTI9NnhUXd8kE8x61IMGI5Ypby3aqSP4XNb5PepAkvGZZikzJ9oxCIoxAk33mh413gQfpqlY0L+xyddahVdxXayGw8TdXA2z2qrDQgoicOFeba61Cy+mBcrKM49CczfoIvdhc4a1D7t8KOBct5pRKW562HTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769528546; c=relaxed/simple;
	bh=KYKLe70Qb6SFk/a7sWwnSIVktGHjct6bA1ZYjyaQz8U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pZTavM8lsH/KncIlwYxbuPAi1aUCavDgokoenRI6J/nMZtzx23175gxJOeCgIv8IKTGA7qx3lx8asO2j2pWx5lqXsGSvyeozUaSSpbdtUq23geaae3CFuQ+FYPN5EBbECcJBu+e5aq8gvnKYdmiKp85qmuekr1v4HbD5dZPUIJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DMAHMLgE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DMAHMLgE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769528544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Hkoq285+MOp9hbZjMMIDEA2fX0nM6u7tKYaFImAuLTY=;
	b=DMAHMLgE9tiwpmCCBn+mOtxXAR9PFrSw2bBA0pdwS71Ew0hh8Fp4d/W/BmmrHtLukAYdzt
	cG7/+Gq/bte9JhCCII+/iRuK0m0FdP7C8DO6/vtq2ylQC0ThD3lGWv/w4E21iecqMGONOq
	t9JrjnNFeU0PkZySYk9KuikrZzk0z/M=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-606-VVsv-3rgO3W6rsX10dkq7A-1; Tue,
 27 Jan 2026 10:42:23 -0500
X-MC-Unique: VVsv-3rgO3W6rsX10dkq7A-1
X-Mimecast-MFC-AGG-ID: VVsv-3rgO3W6rsX10dkq7A_1769528542
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B471D18002C4;
	Tue, 27 Jan 2026 15:42:21 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CF7A018002A6;
	Tue, 27 Jan 2026 15:42:20 +0000 (UTC)
Date: Tue, 27 Jan 2026 10:42:18 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 1/3] xfs: don't keep a reference for buffers on the LRU
Message-ID: <aXjc2gsNToSSANmn@bfoster>
References: <20260126053825.1420158-1-hch@lst.de>
 <20260126053825.1420158-2-hch@lst.de>
 <aXe-EkVrEB-UhNy2@bfoster>
 <20260127052050.GB24364@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127052050.GB24364@lst.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Tue, Jan 27, 2026 at 06:20:50AM +0100, Christoph Hellwig wrote:
> On Mon, Jan 26, 2026 at 02:18:42PM -0500, Brian Foster wrote:
> > > +	/*
> > > +	 * If the buffer is in use, remove it from the LRU for now as we can't
> > > +	 * free it.  It will be added to the LRU again when the reference count
> > > +	 * hits zero.
> > > +	 */
> > > +	if (bp->b_hold > 0) {
> > > +		list_lru_isolate(lru, &bp->b_lru);
> > > +		spin_unlock(&bp->b_lock);
> > > +		return LRU_REMOVED;
> > > +	}
> > > +
> > 
> > Sorry I missed this on my first look at this, but I don't think I quite
> > realized why this was here. This looks like a subtle change in behavior
> > where a buffer that makes it onto the LRU and then is subsequently held
> > can no longer be cycled off the LRU by background shrinker activity.
> > Instead, we drop the buffer off the LRU entirely where it will no longer
> > be visible from ongoing shrinker activity.
> 
> Yes.
> 
> > AFAICT the reason for this is we no longer support the ability for the
> > shrinker to drop the LRU b_hold ref to indicate a buffer is fully cycled
> > out and can go direct to freeing when the current b_hold lifecycle ends.
> > Am I following that correctly?
> 
> Yes.
> 
> > If so, that doesn't necessarily seem like a showstopper as I'm not sure
> > realistically a significant amount of memory would be caught up like
> > this in practice, even under significant pressure. But regardless, why
> > not do this preventative LRU removal only after the lru ref count is
> > fully depleted? Wouldn't that more accurately preserve existing
> > behavior, or am I missing something?
> 
> It would more closely resemble the current behavior, which seems wrong
> and an artifact of the current reference counting.  A buffer that is
> in use really should not be counted down on the LRU, which really is
> for unused buffers.  So starting the countdown only once the buffer
> is unused is the right thing to do.  I should have explained this
> much better, though.
> 

Ok, but right or wrong it's been that way for quite some time (forever?)
and this sort of change probably shouldn't be buried implicitly in this
patch. For one, the LRU refcounting behavior doesn't depend on this work
because we could have always done something like skip the decrement and
rotate held buffers, but nobody has ever proposed such a change to my
knowledge. Also, ISTM this patch could fairly easily preserve existing
behavior by decrementing lru ref and deferring list removal to when the
lru ref drops to zero but the buffer is still held.

IOW, I'm not arguing for or against a change in buffer lifetime behavior
here, just that it should probably be done separately with some more
careful analysis. The secondary advantage is that if this behavior does
somehow uncover something problematic, we can bisect/revert back to
historical lifetime behavior without having to walk back these
functional changes.

Brian

