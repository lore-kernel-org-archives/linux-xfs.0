Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B245B322E
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 01:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724722622; cv=none; b=adajghEzec2KSRIQeN8CUt0whSBYTtwMzk2EEm3wYHEIErRm3AE3i8MO50jPNa0ZDr/d4z9Bsvevd65tHV1bJmpASWT/mkZprgqFCVDO560lVuWLOtRg1VcgshVErHaP+4T5mQjz6iZ5XkJz2bX4Jsr/IQSPzt12ZywnWsqnmao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724722622; c=relaxed/simple;
	bh=MAZ+/CVWtijc4ARSxksWA9nLZM9i8Op6OQHLtW1vsE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RLDNhTFclweOLBQoKSmAVRLcX1p5pb2R86Q+BmlYxMRIkbL0dYZoDmcLhBGLa2ImKKhSLEDjngKCOu+GiyVYWYtZLhaFuE9Mf3ChiFDbbvOMvpG+zN9gbFHXnZqG94FO2FXvIgwV9V46g6vZZ3GbCSryQexR+m7XrfM2rr6kiLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=JIkFLrQZ; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="JIkFLrQZ"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-714263cb074so3422438b3a.1
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2024 18:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724722620; x=1725327420; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+9LVkoGtTavbErnrLPIBauVORRDfAKYcmcIS8uWHns0=;
        b=JIkFLrQZnAL5ugG9RCOEXrw+m6jV/KT8j8D5e4nZdSDWxfQe4o4XtMwJzrGeip4tSh
         fDVMoCebuM87rd2mqXSJU73MPLGWSVUYaQagsiYhzvg+innmeklBBxmpxjmVDtRFNSjX
         jpHd0oxeJPJK8rFw78+i1OPYCB0cof7kHSZU9UBopR35dlX75RfkF8qH1jQJrFXw8kG5
         GRumLHMqFyXk0mFFMlzL+8MSOkOlBQTGA3tnnfSGucE/Ph+NYWQRLFZ4XCrUiS/GpHjI
         S4pSTpQNXelr4m2+gNWyWvbHMXuJ5uNRjERyHNPIUZJx/4n67zgkU/zSeUi2j1cwAgnX
         WLvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724722620; x=1725327420;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+9LVkoGtTavbErnrLPIBauVORRDfAKYcmcIS8uWHns0=;
        b=COYmOC/fwmnB79pg2XBf9wMkQ1wP8/nXpgLfQwMGC2SD5T4Fdu3ju9CXvbUhonu7Cs
         4dNeH00ICPmuJb6n4ow4uTWuk8WMb6xywSfLMYhNJugQhJaN+BwPodneS+rs1wM6YevJ
         m/qCj1Tt3dtwjiU02qwR9T0TaVdDNNAbTfqMCiXyHkWkiMRtM3fZgUTkrHSMrNzOmIDV
         hWKjRm0c19h9WJ8jUjI2EjRcx63MS3tKX+19RTcriBiQ+04BSDD4oqwGY2doJvcIZgA/
         fxMdh4Aht+U/nC0AmPZUaFuUYNCTeK+gllVqm6mBsb8hDLzpkXmJ30mNn1Jv5FLM3/nq
         9Rhw==
X-Forwarded-Encrypted: i=1; AJvYcCXYD1qAK1ppbr8mM6jkfzARl14QbZ3Xrs2b5uVBoeOE3c7kYPUGZzzKfaTrZFIy9a5cg0hqJGane8c=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcVHS4Z0+YXa1GaW0JsozZKIOxIokcMIBReXRtzArHfpF3vOEV
	UszmjNEv86ULZi+0EsznB68aD0jNUCkhlAnY/KZNNoRZ4bweWsNHO+qoOgBUD5c=
X-Google-Smtp-Source: AGHT+IEHTGid6JaZN7UQXq5P9m1RAFdZHwhq59O2a1js58H6eem9g18K+Gex1k5kBJSyKZSVSpGyxw==
X-Received: by 2002:a05:6a00:b46:b0:714:271e:7c3e with SMTP id d2e1a72fcca58-71445d0ecccmr12545530b3a.9.1724722619897;
        Mon, 26 Aug 2024 18:36:59 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71434309676sm7860737b3a.174.2024.08.26.18.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 18:36:59 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sil8j-00E0VZ-0v;
	Tue, 27 Aug 2024 11:36:57 +1000
Date: Tue, 27 Aug 2024 11:36:57 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/26] xfs: support logging EFIs for realtime extents
Message-ID: <Zs0tuQlJbleBPND/@dread.disaster.area>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
 <172437088816.60592.12361252562494894102.stgit@frogsfrogsfrogs>
 <ZswFhKNrMh4I8QGm@dread.disaster.area>
 <20240826193835.GD865349@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240826193835.GD865349@frogsfrogsfrogs>

On Mon, Aug 26, 2024 at 12:38:35PM -0700, Darrick J. Wong wrote:
> On Mon, Aug 26, 2024 at 02:33:08PM +1000, Dave Chinner wrote:
> > On Thu, Aug 22, 2024 at 05:25:36PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Teach the EFI mechanism how to free realtime extents.  We're going to
> > > need this to enforce proper ordering of operations when we enable
> > > realtime rmap.
> > > 
> > > Declare a new log intent item type (XFS_LI_EFI_RT) and a separate defer
> > > ops for rt extents.  This keeps the ondisk artifacts and processing code
> > > completely separate between the rt and non-rt cases.  Hopefully this
> > > will make it easier to debug filesystem problems.
> > 
> > Doesn't this now require busy extent tracking for rt extents that
> > are being freed?  i.e. they get marked as free with the EFD, but
> > cannot be reallocated (or discarded) until the EFD is committed to
> > disk.
> > 
> > we don't allow user data allocation on the data device to reuse busy
> > ranges because the freeing of the extent has not yet been committed
> > to the journal. Because we use async transaction commits, that means
> > we can return to userspace without even the EFI in the journal - it
> > can still be in memory in the CIL. Hence we cannot allow userspace
> > to reallocate that range and write to it, even though it is marked free in the
> > in-memory metadata.
> 
> Ah, that's a good point -- in memory the bunmapi -> RTEFI -> RTEFD ->
> rtalloc -> bmapi transactions succeed, userspace writes to the file
> blocks, then the log goes down without completing /any/ of those
> transactions, and now a read of the old file gets new contents.

*nod*

> > If userspace then does a write and then we crash without the
> > original EFI on disk, then we've just violated metadata vs data
> > update ordering because recovery will not replay the extent free nor
> > the new allocation, yet the data in that extent will have been
> > changed.
> > 
> > Hence I think that if we are moving to intent based freeing of real
> > time extents, we absolutely need to add support for busy extent
> > tracking to realtime groups before we enable EFIs on realtime
> > groups.....
> 
> Yep.  As a fringe benefit, we'd be able to support issuing discards from
> FITRIM without holding the rtbitmap lock, and -o discard on rt extents
> too.

Yes. And I suspect that if we unify the perag and rtg into a single
group abstraction, the busy extent tracking will work for both
allocators without much functional change being needed at all...

> > Also ....
> > 
> > > @@ -447,6 +467,17 @@ xfs_extent_free_defer_add(
> > >  
> > >  	trace_xfs_extent_free_defer(mp, xefi);
> > >  
> > > +	if (xfs_efi_is_realtime(xefi)) {
> > > +		xfs_rgnumber_t		rgno;
> > > +
> > > +		rgno = xfs_rtb_to_rgno(mp, xefi->xefi_startblock);
> > > +		xefi->xefi_rtg = xfs_rtgroup_get(mp, rgno);
> > > +
> > > +		*dfpp = xfs_defer_add(tp, &xefi->xefi_list,
> > > +				&xfs_rtextent_free_defer_type);
> > > +		return;
> > > +	}
> > > +
> > >  	xefi->xefi_pag = xfs_perag_intent_get(mp, xefi->xefi_startblock);
> > >  	if (xefi->xefi_agresv == XFS_AG_RESV_AGFL)
> > >  		*dfpp = xfs_defer_add(tp, &xefi->xefi_list,
> > 
> > Hmmmm. Isn't this also missing the xfs_drain intent interlocks that
> > allow online repair to wait until all the intents outstanding on a
> > group complete?
> 
> Yep.  I forgot about that.

Same comment about unified group infrastructure ;)

> > > +
> > > +/* Cancel a realtime extent freeing. */
> > > +STATIC void
> > > +xfs_rtextent_free_cancel_item(
> > > +	struct list_head		*item)
> > > +{
> > > +	struct xfs_extent_free_item	*xefi = xefi_entry(item);
> > > +
> > > +	xfs_rtgroup_put(xefi->xefi_rtg);
> > > +	kmem_cache_free(xfs_extfree_item_cache, xefi);
> > > +}
> > > +
> > > +/* Process a free realtime extent. */
> > > +STATIC int
> > > +xfs_rtextent_free_finish_item(
> > > +	struct xfs_trans		*tp,
> > > +	struct xfs_log_item		*done,
> > > +	struct list_head		*item,
> > > +	struct xfs_btree_cur		**state)
> > 
> > btree cursor ....
> > 
> > > +{
> > > +	struct xfs_mount		*mp = tp->t_mountp;
> > > +	struct xfs_extent_free_item	*xefi = xefi_entry(item);
> > > +	struct xfs_efd_log_item		*efdp = EFD_ITEM(done);
> > > +	struct xfs_rtgroup		**rtgp = (struct xfs_rtgroup **)state;
> > 
> > ... but is apparently holding a xfs_rtgroup. that's kinda nasty, and
> > the rtg the xefi is supposed to be associated with is already held
> > by the xefi, so....
> 
> It's very nasty, and I preferred when it was just a void**.  Maybe we
> should just change that to a:
> 
> struct xfs_intent_item_state {
> 	struct xfs_btree_cur	*cur;
> 	struct xfs_rtgroup	*rtg;
> };
> 
> and pass that around?  At least then the compiler can typecheck that for
> us.

Sounds good to me. :)

-Dave.

-- 
Dave Chinner
david@fromorbit.com
