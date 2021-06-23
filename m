Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DD5BC4743C
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Jun 2021 10:18:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7C8B61164
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Jun 2021 10:18:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbhFWKVN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Jun 2021 06:21:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25641 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229833AbhFWKVM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Jun 2021 06:21:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624443535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uLB7su9bfNdFifSbLwSrVC/occnJihW8FJl8MeBy86Q=;
        b=Se20YS9DKWitypP22PYveJoKbTqBPaBqP+R5vxM8ixCwV7/5ksC9oe7JAwXsu1JPvb1bPa
        OqLrQeQW1oZedzBccDp5mdmisxm5IS0Zixw/pnqZZzo+30irxzX+7NyxIur5/1DohGpCuN
        A/Sve/9IZgod8zz2iy3h8rJ2LqYsRSk=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-ZSIZM3mNM72-4w47VsI0uQ-1; Wed, 23 Jun 2021 06:18:53 -0400
X-MC-Unique: ZSIZM3mNM72-4w47VsI0uQ-1
Received: by mail-qk1-f198.google.com with SMTP id 142-20020a370d940000b02903b12767b75aso1924988qkn.6
        for <linux-xfs@vger.kernel.org>; Wed, 23 Jun 2021 03:18:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uLB7su9bfNdFifSbLwSrVC/occnJihW8FJl8MeBy86Q=;
        b=QFhvzLNaHcJ3/S4GYJj+SoJ/MP+n4vHvzxRRbCGJEGzfRcx9yeXdc1My/pDc/v3Aqs
         YYhFFQrsku4u9TUFVDxOis6slpXVXOkyCQB1oUFF7DFwgP9vKOHislLDVfGvm63dGbOW
         BwDqLkUbA41KR+Mbtu9RSw9Vtc8Y4dieJuXnylJF4cPpfjW4W7h2NYX9DnTXggkfUT33
         gNZuelnSDwPwl8WEZIjLE1b1l8JUK9wJj+lKZYqsqkcv49JR2UQNHA/VoBumtdz8S/Rr
         TxWDdXajQMb/0PsH/jCkcgqd5VcBt86qvEf9lXDum2aDdbYCH9xdwBrHqiLJEX3ibrBf
         yd/w==
X-Gm-Message-State: AOAM532LXmLySLildB7qx0HPlN3BtKMXLUqQe7sSV88tIVb2coO/DyLu
        wA+RzsX5a/6WIrfUEpdHoxfWA2SH3iQKdFs1pGE1oZK1vxTCojjzAS/4gOSciu4tv6Yh/j2cT5/
        4MSqkwROlPYAWzTuRi0UM
X-Received: by 2002:ac8:6f37:: with SMTP id i23mr3204212qtv.376.1624443533499;
        Wed, 23 Jun 2021 03:18:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwrzXN30qFVpAR2ejGrCYDQYELWCHDxbYKuZsjvngf4XZl0odMsXN2I4KlSCeCXPt1bguEYUQ==
X-Received: by 2002:ac8:6f37:: with SMTP id i23mr3204199qtv.376.1624443533302;
        Wed, 23 Jun 2021 03:18:53 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id h5sm15415971qkg.122.2021.06.23.03.18.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 03:18:52 -0700 (PDT)
Date:   Wed, 23 Jun 2021 06:18:51 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: don't nest icloglock inside ic_callback_lock
Message-ID: <YNMKi4JzPmdnIHNg@bfoster>
References: <20210622040604.1290539-1-david@fromorbit.com>
 <20210622040604.1290539-2-david@fromorbit.com>
 <YNHZ4Bsr27u53TxG@bfoster>
 <20210622224247.GY664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622224247.GY664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 23, 2021 at 08:42:47AM +1000, Dave Chinner wrote:
> On Tue, Jun 22, 2021 at 08:38:56AM -0400, Brian Foster wrote:
> > On Tue, Jun 22, 2021 at 02:06:01PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > It's completely unnecessary because callbacks are added to iclogs
> > > without holding the icloglock, hence no amount of ordering between
> > > the icloglock and ic_callback_lock will order the removal of
> > > callbacks from the iclog.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/xfs_log.c | 18 ++++--------------
> > >  1 file changed, 4 insertions(+), 14 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > > index e93cac6b5378..bb4390942275 100644
> > > --- a/fs/xfs/xfs_log.c
> > > +++ b/fs/xfs/xfs_log.c
> > > @@ -2773,11 +2773,8 @@ static void
> > >  xlog_state_do_iclog_callbacks(
> > >  	struct xlog		*log,
> > >  	struct xlog_in_core	*iclog)
> > > -		__releases(&log->l_icloglock)
> > > -		__acquires(&log->l_icloglock)
> > >  {
> > >  	trace_xlog_iclog_callbacks_start(iclog, _RET_IP_);
> > > -	spin_unlock(&log->l_icloglock);
> > >  	spin_lock(&iclog->ic_callback_lock);
> > >  	while (!list_empty(&iclog->ic_callbacks)) {
> > >  		LIST_HEAD(tmp);
> > > @@ -2789,12 +2786,6 @@ xlog_state_do_iclog_callbacks(
> > >  		spin_lock(&iclog->ic_callback_lock);
> > >  	}
> > >  
> > > -	/*
> > > -	 * Pick up the icloglock while still holding the callback lock so we
> > > -	 * serialise against anyone trying to add more callbacks to this iclog
> > > -	 * now we've finished processing.
> > > -	 */
> > 
> > This makes sense wrt to the current locking, but I'd like to better
> > understand what's being removed. When would we add callbacks to an iclog
> > that's made it to this stage (i.e., already completed I/O)? Is this some
> > historical case or attempt at defensive logic?
> 
> This was done in 2008. It's very likely that, at the time, nobody
> (including me) understood the iclog state machine well enough to
> determine if we could race with adding iclogs at this time. Maybe
> they did race and this was a bandaid over, say, a shutdown race condition.
> But, more likely, it was just defensive to try to prevent callbacks
> from being added before the iclog was marked ACTIVE again...
> 
> Really, though, nobody is going to be able to tell you why the code
> was written like this in the first place because even the author
> doesn't remember...
> 

Ok, just wanted to be sure there wasn't some context I was missing. The
patch seems fine to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

