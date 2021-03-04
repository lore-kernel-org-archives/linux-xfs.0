Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3F6EC433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 13:15:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F3AF64F40
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 13:15:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241172AbhCDNO7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Mar 2021 08:14:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30163 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236017AbhCDNOi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Mar 2021 08:14:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614863592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z1aQ1UPWbxpkWKkkCA6R0Nat/WAPm+dvluhRCde7Z60=;
        b=PHROsS2YSkPPCCAAJ58RLRX8Aba1WJvlsyNEWZroe5hUbFGHRt0m6MMj3PqIcVVaemQpZB
        YRNwyvt4/I2WSdEv4WQVO3+xkMqVWYhFYYvGmfX5zeTJQBLJbGy0DNFGdgp3+JcNGujzqo
        bIL6w5gLfy0dChNHtsICnRt6H5TJzYQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-QkL-hU9xNFOeviWfgz4NvA-1; Thu, 04 Mar 2021 08:13:11 -0500
X-MC-Unique: QkL-hU9xNFOeviWfgz4NvA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0BEFB801814;
        Thu,  4 Mar 2021 13:13:10 +0000 (UTC)
Received: from bfoster (ovpn-112-112.rdu2.redhat.com [10.10.112.112])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AEC3F62A24;
        Thu,  4 Mar 2021 13:13:09 +0000 (UTC)
Date:   Thu, 4 Mar 2021 08:13:07 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3 v2] xfs: AIL needs asynchronous CIL forcing
Message-ID: <YEDc42Z1GjHBXi6S@bfoster>
References: <20210223053212.3287398-1-david@fromorbit.com>
 <20210223053212.3287398-3-david@fromorbit.com>
 <20210224211058.GA4662@dread.disaster.area>
 <20210224232600.GH4662@dread.disaster.area>
 <YD6xrJHgkkHi+7a3@bfoster>
 <20210303005752.GM4662@dread.disaster.area>
 <YD/IN66S3aM1lEQh@bfoster>
 <20210304015933.GO4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210304015933.GO4662@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 04, 2021 at 12:59:33PM +1100, Dave Chinner wrote:
> On Wed, Mar 03, 2021 at 12:32:39PM -0500, Brian Foster wrote:
> > On Wed, Mar 03, 2021 at 11:57:52AM +1100, Dave Chinner wrote:
> > > On Tue, Mar 02, 2021 at 04:44:12PM -0500, Brian Foster wrote:
> > > > On Thu, Feb 25, 2021 at 10:26:00AM +1100, Dave Chinner wrote:
> > > > >  	 * xlog_cil_push() handles racing pushes for the same sequence,
> > > > >  	 * so no need to deal with it here.
> > > > >  	 */
> > > > >  restart:
> > > > > -	xlog_cil_push_now(log, sequence);
> > > > > +	xlog_cil_push_now(log, sequence, flags & XFS_LOG_SYNC);
> > > > > +	if (!(flags & XFS_LOG_SYNC))
> > > > > +		return commit_lsn;
> > > > 
> > > > Hm, so now we have sync and async log force and sync and async CIL push.
> > > > A log force always requires a sync CIL push and commit record submit;
> > > > the difference is simply whether or not we wait on commit record I/O
> > > > completion. The sync CIL push drains the CIL of log items but does not
> > > > switch out the commit record iclog, while the async CIL push executes in
> > > > the workqueue context so the drain is async, but it does switch out the
> > > > commit record iclog before it completes. IOW, the async CIL push is
> > > > basically a "more async" async log force.
> > > 
> > > Yes.
> > > 
> > > > I can see the need for the behavior of the async CIL push here, but that
> > > > leaves a mess of interfaces and behavior matrix. Is there any reason we
> > > > couldn't just make async log forces unconditionally behave equivalent to
> > > > the async CIL push as defined by this patch? There's only a handful of
> > > > existing users and I don't see any obvious reason why they might care
> > > > whether the underlying CIL push is synchronous or not...
> > > 
> > > I'm not touching the rest of the log force code in this series - it
> > > is out of scope of this bug fix and the rest of the series that it
> > > is part of.
> > > 
> > 
> > But you already have altered the log force code by changing
> > xlog_cil_force_seq(), which implicitly changes how xfs_log_force_seq()
> > behaves.
> 
> The behaviour of the function when called from xfs_log_force*()
> should be unchanged. Can you be specific about exactly what
> behaviour did I change for non-synchronous xfs_log_force*() callers
> so I can fix it? I have not intended to change it at all, so
> whatever you are refering is an issue I need to fix...
> 

xfs_log_force_seq() passes flags from the caller to xlog_cil_force_seq()
(whereas this patch presumably wants it to pass XFS_LOG_SYNC
unconditionally). IOW, xfs_log_force(mp, 0) behavior is different from
xfs_log_force_seq(mp, seq, 0, ...).

> > So not only does this patch expose subsystem internals to
> > external layers and create more log forcing interfaces/behaviors to
> 
> Sorry, I don't follow. What "subsystem internals" are being exposed
> and what external layer are they being exposed to?
> 
> > > Cleaning up the mess that is the xfs_log_* and xlog_* interfaces and
> > > changing things like log force behaviour and implementation is for
> > > a future series.
> > > 
> > 
> > TBH I think this patch is kind of a mess on its own. I think the
> > mechanism it wants to provide is sane, but I've not even got to the
> > point of reviewing _that_ yet because of the seeming dismissal of higher
> > level feedback. I'd rather not go around in circles on this so I'll just
> > offer my summarized feedback to this patch...
> 
> I'm not dismissing review nor am I saying the API cannot or should
> not be improved. I'm simply telling you that I think the additional
> changes you are proposing are outside the scope of the problem I am
> addressing here. I already plan to rework the log force API (and
> others) but doing so it not something that this patchset needs to
> address, or indeed should address.
> 

I'm not proposing additional changes nor to rework the log force API.
I'm pointing out that I find this implementation to be extremely and
unnecessarily confusing. To improve it, I'm suggesting to either coopt
the existing async log force API...

> There are already enough subtle changes being made to core code and
> algorithms that mixing them with unrelated high level external
> behavioural changes that it greatly increases the risk of unexpected
> regressions in the patchset. The log force are paths are used in
> data integrity paths, so I want to limit the scope of behavioural
> change to just the AIL where the log force has no data integrity
> requirement associcated with it.
> 

... or if we really want a special async log force just for xfsaild (why
is still not clear to me), then tie it to an XFS_LOG_REALLY_ASYNC flag
or some such, pass that to the existing log force call, and document the
purpose/behavior of the new mode in detail. That at least won't require
a developer to wonder what !(flags & XFS_LOG_SYNC) happens to mean
depending on the particular log force function.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

