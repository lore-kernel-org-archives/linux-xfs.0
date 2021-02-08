Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 924FFC433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Feb 2021 21:28:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E66364E6F
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Feb 2021 21:28:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236553AbhBHV1T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Feb 2021 16:27:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22076 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235781AbhBHVZu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Feb 2021 16:25:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612819461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ylHSNjGQDLAeZgbqtgLAWbopR2CWLdiy6rZ9AkMcZPI=;
        b=F8dGyPWZz1l4rGLg02leQcu7hoCbX1piwEJi4hFLU0RZywkO6iKzXvwUzFAKg0XGpwGWQd
        CD2k0+ghdTG6MG1JFqSpb/XXVYydTJwTXU+47OLnS6PZewcVTInCH41sRdtem6d0ErddR8
        mHO/+2nzBLggNqNbpQ6A/ZXYRagmfCQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-563-pmmcOR5QOke1RaGcjqQX2w-1; Mon, 08 Feb 2021 16:24:18 -0500
X-MC-Unique: pmmcOR5QOke1RaGcjqQX2w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CCE2D107ACE3;
        Mon,  8 Feb 2021 21:24:15 +0000 (UTC)
Received: from bfoster (ovpn-114-152.rdu2.redhat.com [10.10.114.152])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 086C410016DB;
        Mon,  8 Feb 2021 21:24:13 +0000 (UTC)
Date:   Mon, 8 Feb 2021 16:24:12 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        rcu@vger.kernel.org, it+linux-rcu@molgen.mpg.de,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: rcu: INFO: rcu_sched self-detected stall on CPU: Workqueue:
 xfs-conv/md0 xfs_end_io
Message-ID: <20210208212412.GA189280@bfoster>
References: <1b07e849-cffd-db1f-f01b-2b8b45ce8c36@molgen.mpg.de>
 <20210205171240.GN2743@paulmck-ThinkPad-P72>
 <20210208140724.GA126859@bfoster>
 <20210208145723.GT2743@paulmck-ThinkPad-P72>
 <20210208154458.GB126859@bfoster>
 <20210208171140.GV2743@paulmck-ThinkPad-P72>
 <20210208172824.GA7209@magnolia>
 <20210208204314.GY4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208204314.GY4662@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 09, 2021 at 07:43:14AM +1100, Dave Chinner wrote:
> On Mon, Feb 08, 2021 at 09:28:24AM -0800, Darrick J. Wong wrote:
> > On Mon, Feb 09, 2021 at 09:11:40AM -0800, Paul E. McKenney wrote:
> > > On Mon, Feb 08, 2021 at 10:44:58AM -0500, Brian Foster wrote:
> > > > There was a v2 inline that incorporated some directed feedback.
> > > > Otherwise there were questions and ideas about making the whole thing
> > > > faster, but I've no idea if that addresses the problem or not (if so,
> > > > that would be an entirely different set of patches). I'll wait and see
> > > > what Darrick thinks about this and rebase/repost if the approach is
> > > > agreeable..
> > > 
> > > There is always the school of thought that says that the best way to
> > > get people to focus on this is to rebase and repost.  Otherwise, they
> > > are all too likely to assume that you lost interest in this.
> > 
> > I was hoping that a better solution would emerge for clearing
> > PageWriteback on hundreds of thousands of pages, but nothing easy popped
> > out.
> > 
> > The hardcoded threshold in "[PATCH v2 2/2] xfs: kick extra large ioends
> > to completion workqueue" gives me unease because who's to say if marking
> > 262,144 pages on a particular CPU will actually stall it long enough to
> > trip the hangcheck?  Is the number lower on (say) some pokey NAS box
> > with a lot of storage but a slow CPU?
> 
> It's also not the right thing to do given the IO completion
> workqueue is a bound workqueue. Anything that is doing large amounts
> of CPU intensive work should be on a unbound workqueue so that the
> scheduler can bounce it around different CPUs as needed.
> 
> Quite frankly, the problem is a huge long ioend chain being built by
> the submission code. We need to keep ioend completion overhead down.
> It runs in either softirq or bound workqueue context and so
> individual items of work that are performed in this context must not
> be -unbounded- in size or time. Unbounded ioend chains are bad for
> IO latency, they are bad for memory reclaim and they are bad for CPU
> scheduling.
> 
> As I've said previously, we gain nothing by aggregating ioends past
> a few tens of megabytes of submitted IO. The batching gains are
> completely diminished once we've got enough IO in flight to keep the
> submission queue full. We're talking here about gigabytes of
> sequential IOs in a single ioend chain which are 2-3 orders of
> magnitude larger than needed for optimal background IO submission
> and completion efficiency and throughput. IOWs, we really should be
> limiting the ioend chain length at submission time, not trying to
> patch over bad completion behaviour that results from sub-optimal IO
> submission behaviour...
> 

That was the patch I posted prior to the aforementioned set. Granted, it
was an RFC, but for reference:

https://lore.kernel.org/linux-fsdevel/20200825144917.GA321765@bfoster/

(IIRC, you also had a variant that was essentially the same change.)

The discussion that followed in that thread was around the preference to
move completion of large chains into workqueue context instead of
breaking up the chains. The series referenced in my first reply fell out
of that as a targeted fix for the stall warning.

> > That said, /some/ threshold is probably better than no threshold.  Could
> > someone try to confirm if that series of Brian's fixes this problem too?
> 
> 262144 pages is still too much work to be doing in a single softirq
> IO completion callback. It's likely to be too much work for a bound
> workqueue, too, especially when you consider that the workqueue
> completion code will merge sequential ioends into one ioend, hence
> making the IO completion loop counts bigger and latency problems worse
> rather than better...
> 

That was just a conservative number picked based on observation of the
original report (10+ GB ioends IIRC). I figured the review cycle would
involve narrowing it down to something more generically reasonable
(10s-100s of MB?) once we found an acceptable approach (and hopefully
received some testing feedback), but we've never really got to that
point..

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

