Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2003308F38;
	Wed, 25 Mar 2026 20:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774471169; cv=none; b=lGM1if8Y67vsbVD34l9jPwpq7BK4nvCFxv4qvo2p4K/UOaZ0NywkDJdXJ6YSSc/gSsKgX6dGC33OHSZ+CI8rCwzwIygU5OaRSzo+5Utq66hKjmYxUyEvEvKelR4oDfTv5G+ccqirEidtZny5YdwZkcCHI5Ut+csQMDC2Ws51hM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774471169; c=relaxed/simple;
	bh=AMsmI0aU+DwXjnXDp5MgHzE4DmsSNfqSkmJpzQV7Pp4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OT5ZW8orIWkZATkA0PJptupOK+fgdvFkUehHhyE4g+UZhwnI7wlAxVbiMgm68gJo+p2GO8CwXl6EwUFPbKFRfjqOy5UNLdsEXC00hkV4qxXFisTLTHUbYr8vz6vWyDwoq7lYMSwsMKywcdj9ywa4sHwtKlyN9VeYe6czrqm/vOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=o4dEHtRV; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="o4dEHtRV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qX+god1XVd2ivXCYier0tY7NsB6ICtw7odjLzfpR+Aw=; b=o4dEHtRV1qXOf0mlPmYYJI7Li5
	x8pyBl3KLeP8H95MLyv95XfcTpXFj0RR4J/a52leLhCW7ttG0fTz0hqwNNotVSklYRexKk28Pi+1L
	mcjlPNvgZ0Gd2qr35dYqIgUD3YTHCudurWe6B3yOfjYap5P8QxfRTj1tlT6ekKTUPDDWgv7ZpP93E
	t5i9d2nuRSHinYSzvotcMDSsacKfGdWyP1c0dDiSNDE807yrFR0EQMc8dSAGK+5z5fV5Ry+sH1cr1
	MdUoOS3RIk/Elmy2VjrESqB5cqbwrU+QL1Rp0atHaOAP4atcCq2RDO2/YNEi2cVgiXGdhPTHl5FYV
	zGMsX7LQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w5V0b-0000000GVxU-2CYm;
	Wed, 25 Mar 2026 20:39:22 +0000
Date: Wed, 25 Mar 2026 20:39:21 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Dave Chinner <dgc@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC v4 1/3] block: add BIO_COMPLETE_IN_TASK for
 task-context completion
Message-ID: <acRH-fWPKkFFXcLZ@casper.infradead.org>
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-1-c4b56db43f64@columbia.edu>
 <acRE8pp6HxjK7Z74@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acRE8pp6HxjK7Z74@dread>

On Thu, Mar 26, 2026 at 07:26:26AM +1100, Dave Chinner wrote:
> > @@ -1988,6 +2060,16 @@ static int __init init_bio(void)
> >  				SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
> >  	}
> >  
> > +	for_each_possible_cpu(i) {
> > +		struct bio_complete_batch *batch =
> > +			per_cpu_ptr(&bio_complete_batch, i);
> > +
> > +		bio_list_init(&batch->list);
> > +		INIT_WORK(&batch->work, bio_complete_work_fn);
> > +	}
> > +
> > +	cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "block/bio:complete:dead",
> > +				NULL, bio_complete_batch_cpu_dead);
> 
> XFS inodegc tracks the CPUs with work queued via a cpumask and
> iterates the CPU mask for "all CPU" iteration scans. This avoids the
> need for CPU hotplug integration...

Can you elaborate a bit on how this would work in this context?
I understand why inode garbage collection might do an "all CPU"
iteration, but I don't understand the circumstances under which
we'd iterate over all CPUs to complete deferred BIOs.

> > +++ b/include/linux/blk_types.h
> > @@ -322,6 +322,7 @@ enum {
> >  	BIO_REMAPPED,
> >  	BIO_ZONE_WRITE_PLUGGING, /* bio handled through zone write plugging */
> >  	BIO_EMULATES_ZONE_APPEND, /* bio emulates a zone append operation */
> > +	BIO_COMPLETE_IN_TASK, /* complete bi_end_io() in task context */
> 
> Can anyone set this on a bio they submit? i.e. This needs a better
> description. Who can use it, constraints, guarantees, etc.
> 
> I ask, because the higher filesystem layers often know at submission
> time that we need task based IO completion. If we can tell the bio
> we are submitting that it needs task completion and have the block
> layer guarantee that the ->end_io completion only ever runs in task
> context, then we can get rid of mulitple instances of IO completion
> deferal to task context in filesystem code (e.g. iomap - for both
> buffered and direct IO, xfs buffer cache write completions, etc).

Right, that's the idea, this would be entirely general.  I want to do
it for all pagecache writeback so we can change i_pages.xa_lock from
being irq-safe to only taken in task context.
