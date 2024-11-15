Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F8818C034
	for <linux-xfs@vger.kernel.org>; Fri, 15 Nov 2024 14:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731679304; cv=none; b=e34FufeqHtZlTInS53ZrdiOjdaJkAYBu2grZNSMXUn9E06gn50pE+s2Awa6UnrZJvT8CPiD9K3WkJnrn9Wj8vN5dq4oTkNJ/Haxc/baZr6Xulm7ttIu5BFIYSZWdd9p35b6Y6Agbd+n1O28xO45V0yMi5VxDtJm8NVXtKATjT7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731679304; c=relaxed/simple;
	bh=B4KHL+8l4Uin0NSIEfjnQ3Vj5XtM+B15BTpqbYl19Vg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YAVeno5VFTDF+iJSVF8neOF/KBV/xaukRdf9HamBu9YptFixxR/btlZfDMPlvTb7/Eehg1jnSHEJMlIJXb2chfDSU77qVai+7uxUwh1+t7DXoWmJeuZ51affGtPwEvcTdQkAm51uQqNv1jicozTFeDtir3mM2luRwCgR+vU8TeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MWaNPV8F; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MWaNPV8F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731679301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dmYQVZ33rJyNBXEcWOvkPyU2ctnWfc31NEOf4H61ApE=;
	b=MWaNPV8FbLPNIIxWOtiUKwyKQ6hE7/G/v7kzOzUJbfPm+nFQpdleMQA29Ruvb73DUSBNcZ
	XPblacvZZ9xjj24K97DupsHP+EbOcXVodf0Pb9PWqZD63T8o9EJTeHjpdGPjIDFHmYfWmJ
	UEM5PT4TPEWBrQoli5mQXWn1dO2R1ts=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-489-AGvBuC85MRqwpsu31gl76w-1; Fri,
 15 Nov 2024 09:01:34 -0500
X-MC-Unique: AGvBuC85MRqwpsu31gl76w-1
X-Mimecast-MFC-AGG-ID: AGvBuC85MRqwpsu31gl76w
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9C9BD1975AC7;
	Fri, 15 Nov 2024 14:01:30 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.120])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E5B191953880;
	Fri, 15 Nov 2024 14:01:27 +0000 (UTC)
Date: Fri, 15 Nov 2024 09:03:00 -0500
From: Brian Foster <bfoster@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Long Li <leo.lilong@huawei.com>, brauner@kernel.org, djwong@kernel.org,
	cem@kernel.org, linux-xfs@vger.kernel.org, yi.zhang@huawei.com,
	houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH v2 1/2] iomap: fix zero padding data issue in concurrent
 append writes
Message-ID: <ZzdUlPq2CapfxS9k@bfoster>
References: <20241113091907.56937-1-leo.lilong@huawei.com>
 <ZzTQPdE5V155Soui@bfoster>
 <ZzVhsvyFQu01PnHl@localhost.localdomain>
 <ZzY7r1l5dpBw7UsY@bfoster>
 <ZzZXNoOsFRqcd6ge@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZzZXNoOsFRqcd6ge@dread.disaster.area>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Fri, Nov 15, 2024 at 07:01:58AM +1100, Dave Chinner wrote:
> On Thu, Nov 14, 2024 at 01:04:31PM -0500, Brian Foster wrote:
> > On Thu, Nov 14, 2024 at 10:34:26AM +0800, Long Li wrote:
> > > On Wed, Nov 13, 2024 at 11:13:49AM -0500, Brian Foster wrote:
> > ISTM that for the above merge scenario to happen we'd either need
> > writeback of the thread 1 write to race just right with the thread 2
> > write, or have two writeback cycles where the completion of the first is
> > still pending by the time the second completes. Either of those seem far
> > less likely than either writeback seeing i_size == 8k from the start, or
> > the thread 2 write completing sometime after the thread 1 ioend has
> > already been completed. Hm?
> 
> I think that this should be fairly easy to trigger with concurrent
> sub-block buffered writes to O_DSYNC|O_APPEND opened files. The fact
> we drop the IOLOCK before calling generic_write_sync() to flush the
> data pretty much guarantees that there will be IO in flight whilst
> other write() calls have extended the file in memory and are then
> waiting for the current writeback on the folio to complete before
> submitting their own writeback IO.
> 

Hmmm.. that kind of sounds like opposite to me. Note that the example
given was distinctly not append only, as that allows multiple
technically "merge-worthy" ioends to be in completion at the same time.

If you're doing O_DSYNC|O_APPEND sub-block buffered writes, then by
definition there is going to be folio overlap across writes, and we
don't submit a dirty&&writeback folio for writeback until preexisting
writeback state clears. So ISTM that creates a situation where even if
the append I/O is multithreaded, you'll just end up more likely to
lockstep across writebacks and won't ever submit the second ioend before
the first completes. Hm?

That said, we're kind of getting in the weeds here.. I don't think it
matters that much if these ioends merge..

I'm basically throwing out the proposition that maybe it's not worth the
additional code to ensure that they always do. I.e., suppose we opted to
trim the io_size when appropriate based on i_size so the completion side
size update is accurate, but otherwise just left off the rounding helper
thing and let the existing code work as it is. Would that lack of
guaranteed block alignment have any practical impact on functionality or
performance?

ISTM the add_to_ioend() part is superfluous so it probably wouldn't have
much effect on I/O sizes, if any. The skipped merge example Long Li
gives seems technically possible, but I'm not aware of a workload where
that would occur frequently enough that failing to merge such an ioend
would have a noticeable impact.. hm?

Again.. not something I care tremendously about, just trying to keep
things simple if possible. If it were me and there's not something we
can put to that obviously breaks, I'd start with that and then if that
does prove wrong, it's obviously simple to fix by tacking on the
rounding thing later. Just my .02.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

