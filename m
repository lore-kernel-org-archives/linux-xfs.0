Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99248C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Mar 2022 15:55:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235914AbiCAPz5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Mar 2022 10:55:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235865AbiCAPz4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Mar 2022 10:55:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 34F403BBE2
        for <linux-xfs@vger.kernel.org>; Tue,  1 Mar 2022 07:55:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646150112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FvJSbYHssX9DDYvDYsxxJxLk8F6CHwLG1iylHwV5A3Q=;
        b=ZHiuT855BYUm10+3b/YTXUE6pI1rFcaHUYyKohRV4GV5TGpH31DlS9YrJMju73BXPO0M4Z
        M6Nnl5KoxbgO3xgigzjpTuvNSgkCY/4toEvw+qnb4KxD01+RGGgWD5ZQfkSeuBhLbdKopv
        dRqOh6uYc8Ig8IbTc3jbPw6aZLyZOXo=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-163--v3RAv2jOPSuzy_fFZiRsA-1; Tue, 01 Mar 2022 10:55:11 -0500
X-MC-Unique: -v3RAv2jOPSuzy_fFZiRsA-1
Received: by mail-qk1-f198.google.com with SMTP id u12-20020a05620a0c4c00b00475a9324977so14192793qki.13
        for <linux-xfs@vger.kernel.org>; Tue, 01 Mar 2022 07:55:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FvJSbYHssX9DDYvDYsxxJxLk8F6CHwLG1iylHwV5A3Q=;
        b=HRFaRXSB4FBDOhYjoKnOm7fblL6jeYbDkgGyfKMvQYSMMEJ62b3rxtX7Nlxn6z7L0t
         /K6WPv6MavcQjP8UWTgeAmTafp97XOX9KuaVY2IFP7zIniFzcVMhB+8n0bo0VqZ+wSxS
         wtmpOkB+Z5PRCk3cSHHNhwkOq7KnSs0fqdkuO0n4Z6ZuCJAjz93kPDFfnisO3cyjYwFG
         9pvbIVHddmnO8Xl0935LrSzqK1jCPWtBOtcJ8CrZ4xP/H/A/UrvanSWGYNmUEfjI8WH/
         fq3EpXBQL0iIpem85BfhLUBmJSH+eYYpxTd1LMYuvcrckfim2wjdkD6F79z/FvbZoo+I
         MP2g==
X-Gm-Message-State: AOAM530tQg+wRFD9g0KIaGq3KfxerpILMcxIDyAeM8HqaLQbLLX6i/Co
        8ykjsEOduWBI35Gszjqo+r/kgt4ZeUt6n9CN3MZlFijsvjoRiCKdzKZbj8Yjr9rN5DxodNDdG1A
        RQcfE124/cY8S+6MNMAnb
X-Received: by 2002:ad4:5f0f:0:b0:433:8ff:681b with SMTP id fo15-20020ad45f0f000000b0043308ff681bmr8538288qvb.2.1646150110641;
        Tue, 01 Mar 2022 07:55:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyypHO8eftqFE4GjXinZ5znPkmy29B9zUXybcnLvT4DuiCZIqi2xzphqwKfnQbpkW7eil+Ipg==
X-Received: by 2002:ad4:5f0f:0:b0:433:8ff:681b with SMTP id fo15-20020ad45f0f000000b0043308ff681bmr8538266qvb.2.1646150110321;
        Tue, 01 Mar 2022 07:55:10 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id c6-20020ac87d86000000b002ddd9f33ed1sm8933657qtd.44.2022.03.01.07.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 07:55:09 -0800 (PST)
Date:   Tue, 1 Mar 2022 10:55:07 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, sandeen@sandeen.net,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-xfs@vger.kernel.org,
        allison.henderson@oracle.com
Subject: Re: [PATCH 19/17] mkfs: increase default log size for new (aka
 bigtime) filesystems
Message-ID: <Yh5B2+SCzL1lqQAa@bfoster>
References: <20220226213720.GQ59715@dread.disaster.area>
 <20220228232211.GA117732@magnolia>
 <20220301004249.GT59715@dread.disaster.area>
 <20220301023822.GD117732@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301023822.GD117732@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 28, 2022 at 06:38:22PM -0800, Darrick J. Wong wrote:
> On Tue, Mar 01, 2022 at 11:42:49AM +1100, Dave Chinner wrote:
> > On Mon, Feb 28, 2022 at 03:22:11PM -0800, Darrick J. Wong wrote:
> > > On Sun, Feb 27, 2022 at 08:37:20AM +1100, Dave Chinner wrote:
> > > > On Fri, Feb 25, 2022 at 06:54:50PM -0800, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > > 
> > > > > Recently, the upstream kernel maintainer has been taking a lot of heat on
> > > > > account of writer threads encountering high latency when asking for log
> > > > > grant space when the log is small.  The reported use case is a heavily
> > > > > threaded indexing product logging trace information to a filesystem
> > > > > ranging in size between 20 and 250GB.  The meetings that result from the
> > > > > complaints about latency and stall warnings in dmesg both from this use
> > > > > case and also a large well known cloud product are now consuming 25% of
> > > > > the maintainer's weekly time and have been for months.
> > > > 
> > > > Is the transaction reservation space exhaustion caused by, as I
> > > > pointed out in another thread yesterday, the unbound concurrency in
> > > > IO completion?
> > > 
> > > No.  They're using synchronous directio writes to write trace data in 4k
> > 
> > synchronous as in O_(D)SYNC or as in "not using AIO"? Is is also
> > append data, and is it one file per logging thread or multiple
> > threads writing to a single file?
> 
> One file per <cough> tenant, and multiple threads spread across all the
> tenants on a system.  This means that all the threads can end up
> pounding on a single file, or each thread can write to a single file.
> The scenario that generated all those numbers (I think) is opening the
> file O_DIRECT|O_SYNC and pwrite()ing blocks at EOF.
> 
> > > chunks.  The number of files does not exceed the number of writer
> > > threads, and the number of writer threads can be up to 10*NR_CPUS (~400
> > > on the test system).  If I'm reading the iomap directio code correctly,
> > > the writer threads block and do not issue more IO until the first IO
> > > completes...
> > 
> > So, up to 400 threads concurrently issuing IO that does block
> > allocation and performing unwritten extent conversion, so up to ~800
> > concurrent running allocation related transactions at a time?
> 
> Assuming you got 800 from the 400 writers + 400 bmbt allocations, yes.
> Though I wouldn't count /quite/ that high for bmbt expansions.
> 
> > > > i.e. we have hundreds of active concurrent
> > > > transactions that then block on common objects between them (e.g.
> > > > inode locks) and serialise?
> > > 
> > > ...so yes, there are hundreds of active transactions, but (AFAICT) they
> > > mostly don't share objects, other than the log itself.  Once we made the
> > > log bigger, the hotspot moved to the AGF buffers.  I'm not sure what to
> > > do about /that/, since a 5GB AG is pretty small.  That aside...
> > 
> > No surprise, AG selection is based on the is based on trying to get
> > an adjacent extent for file extension. Hence assuming random
> > distribution because of contention and skipping done by the search
> > algorithm, then if we have ~50 AGs and 400 writers trying to
> > allocate at the same time then you've got, on average, 8 allocations
> > per AG being attempted roughly concurrently.
> > 
> > Of course, append write workloads tend to respond really well to
> > extent size hints - make sure you allocate a large chunk that
> > extents beyond EOF on the first write, then subsequent extending
> > writes only need unwritten extent conversion which shouldn't need
> > AGF access because it won't require BMBT block allocation during
> > conversion because it's just taking away from the unwritten extent
> > and putting the space into the adjacent written extent.
> 
> Yes, I know, I've been battling $internalgroups for over a year now to
> get extent size hints turned on for things like append logs and VM
> images.  If the IO sizes get larger (or they turn on extent size hints)
> then the heat goes down...
> 
> > > > Hence only handful of completions can
> > > > actually run concurrently, depsite every completion holding a full
> > > > reservation of log space to allow them to run concurrently?
> > > 
> > > ...this is still an issue for different scenarios.  I would still be
> > > interested in experimenting with constraining the number of writeback
> > > completion workers that get started, even though that isn't at play
> > > here.
> > 
> > Well, the "running out of log space" problem is still going to
> > largely be caused by having up to 400 concurrent unwritten extent
> > conversion transactions running at any given point in time...
> 
> I know!  But right now the default log size you get with a 220G volume
> is 110MB.  An 800MB log just pushes the scaling problems around the
> system, but on the plus side the latency is no longer so high that the
> heartbeat timers trip, which causes node evictions, which leads to even
> /worse/ escalations from customers whose systems experience high rates
> of failure.  Every single customer who escalates this causes another
> round of bug reports and another round of meetings for me, even though
> the causes and the bandaids are the same.
> 
> > > > I also wonder if the right thing to do here is just set a minimum
> > > > log size of 32MB? The worst of the long tail latencies are mitigated
> > > > by this point, and so even small filesystems grown out to 200GB will
> > > > have a log size that results in decent performance for this sort of
> > > > workload.
> > > 
> > > Are you asking for a second patch where mkfs refuses to format a log
> > > smaller than 32MB (e.g. 8GB with the x86 defaults)?  Or a second patch
> > > that cranks the minimum log size up to 32MB, even if that leads to
> > > absurd results (e.g. 66MB filesystems with 2 AGs and a 32MB log)?
> > 
> > I'm suggesting the latter.
> > 
> > Along with a refusal to make an XFS filesystem smaller than, say,
> > 256MB, because allowing users to make tiny XFS filesystems seems to
> > always just lead to future troubles.
> 
> I'm going to drop this patch, because I don't have the strength to push
> back against you /and/ Eric.  I'm once again in a crunch because I've
> spent so much of the past few weeks in meetings about bugs that I didn't
> have time to try out Allison's LARP patches so I basically have nothing
> to push for 5.18 because we're past -rc6 and it's too late, too late for
> anything.  Hell, I can't even get that capable() thing reviewed, and
> (right now) that's causing me even more meetingsgalore pain.
> 
> Is it so dangerous to turn this on so that real users can experiment
> with the new setting?
> 
> Frankly I'm also thinking about throwing away six years of online repair
> work because I just don't see myself being able to summon the mental
> energy to run the review process when simple things are this hard.
> Every week I sit down and ask myself if I really have what it takes to
> keep going, and I've reached the point where the answer is NO.  I was
> really hoping that some of our discussions about process improvements
> would have made things better, but instead I realize that I have failed
> as maintainer.
> 

What process improvement discussions? I vaguely recall seeing something
around per-release planning or some such (??) in the not so distant
past, but not necessarily dealing with our ad hoc and wildly
inconsistent development process overall. For whatever it's worth, I've
lost a fair amount of patience with upstream XFS over probably the past
year or so, to the point where I basically consider it a dysfunctional
process. My only recourse to preserve sanity has been to limit the
amount of time and energy I contribute and refocus it elsewhere, so I
certainly sympathize with your sentiment.

However, I also think that an open development process is independent of
individual maintainership and much more of a function of what each
regular developer contributes to the process (in terms of code, review,
tone and quality of discussion, willingness to compromise at a level
commensurate with expectations of others, etc. etc.). IOW, we all share
responsibility in this regard and probably need to consider some
adjustments in behaviors and expectations if things are to improve.

I don't want to get too deep into the weeds here; I'm not cognizant of
all the various challenges that might impact folks differently, whether
it be maintainer, architect or developers of varying levels of
experience, etc. Suffice it to say that I'm open to any discussion aimed
toward trying to make the broader development experience smoother and
more consistent going forward.

Brian

> --D
> 
> > -Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> 

