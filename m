Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE696C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 20:50:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B5A864FD0
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 20:50:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbhCJUt5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 15:49:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28410 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230491AbhCJUtf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Mar 2021 15:49:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615409375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3TbQcWSWtA7INhEAxORmyq3SIe8zcaGg4KwBKK1E+LA=;
        b=N6h+vHaskqk24/2YBiRe4hRNyZrMkFMgNqEEY50nn0JI+DEf4mQchaOtmKv9s3XkRVDJ2f
        gzRjHUHnlV2x+w9Ov8aqjeUGsXRtm7t5Oe6eDaT5pXVddvb0y4aVA8NK6/mJub0TrYB/gL
        WgQj5jrfg/+gW7FnMXJGmWDACvKWEZU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-y9uOyICQNDK4Nn968jYjFw-1; Wed, 10 Mar 2021 15:49:31 -0500
X-MC-Unique: y9uOyICQNDK4Nn968jYjFw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 33CDD80432D;
        Wed, 10 Mar 2021 20:49:30 +0000 (UTC)
Received: from bfoster (ovpn-112-124.rdu2.redhat.com [10.10.112.124])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CB1F818A9E;
        Wed, 10 Mar 2021 20:49:29 +0000 (UTC)
Date:   Wed, 10 Mar 2021 15:49:28 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/45] xfs: journal IO cache flush reductions
Message-ID: <YEkw2CDpeC58iIey@bfoster>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-9-david@fromorbit.com>
 <YEYXtqb7L1zyAHyC@bfoster>
 <20210309011352.GD74031@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309011352.GD74031@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 09, 2021 at 12:13:52PM +1100, Dave Chinner wrote:
> On Mon, Mar 08, 2021 at 07:25:26AM -0500, Brian Foster wrote:
> > On Fri, Mar 05, 2021 at 04:11:06PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Currently every journal IO is issued as REQ_PREFLUSH | REQ_FUA to
> > > guarantee the ordering requirements the journal has w.r.t. metadata
> > > writeback. THe two ordering constraints are:
> ....
> > > The rm -rf times are included because I ran them, but the
> > > differences are largely noise. This workload is largely metadata
> > > read IO latency bound and the changes to the journal cache flushing
> > > doesn't really make any noticable difference to behaviour apart from
> > > a reduction in noiclog events from background CIL pushing.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > 
> > Thoughts on my previous feedback to this patch, particularly the locking
> > bits..? I thought I saw a subsequent patch somewhere that increased the
> > parallelism of this code..
> 
> I seem to have missed that email, too.
> 

Seems this occurs more frequently than it should. :/ Mailer problems?

> I guess you are refering to these two hunks:
> 

Yes.

> > > @@ -2416,10 +2408,21 @@ xlog_write(
> > >  		ASSERT(log_offset <= iclog->ic_size - 1);
> > >  		ptr = iclog->ic_datap + log_offset;
> > >  
> > > -		/* start_lsn is the first lsn written to. That's all we need. */
> > > +		/* Start_lsn is the first lsn written to. */
> > >  		if (start_lsn && !*start_lsn)
> > >  			*start_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> > >  
> > > +		/*
> > > +		 * iclogs containing commit records or unmount records need
> > > +		 * to issue ordering cache flushes and commit immediately
> > > +		 * to stable storage to guarantee journal vs metadata ordering
> > > +		 * is correctly maintained in the storage media.
> > > +		 */
> > > +		if (optype & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS)) {
> > > +			iclog->ic_flags |= (XLOG_ICL_NEED_FLUSH |
> > > +						XLOG_ICL_NEED_FUA);
> > > +		}
> > > +
> > >  		/*
> > >  		 * This loop writes out as many regions as can fit in the amount
> > >  		 * of space which was allocated by xlog_state_get_iclog_space().
> > > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > > index c04d5d37a3a2..263c8d907221 100644
> > > --- a/fs/xfs/xfs_log_cil.c
> > > +++ b/fs/xfs/xfs_log_cil.c
> > > @@ -896,11 +896,16 @@ xlog_cil_push_work(
> > >  
> > >  	/*
> > >  	 * If the checkpoint spans multiple iclogs, wait for all previous
> > > -	 * iclogs to complete before we submit the commit_iclog.
> > > +	 * iclogs to complete before we submit the commit_iclog. If it is in the
> > > +	 * same iclog as the start of the checkpoint, then we can skip the iclog
> > > +	 * cache flush because there are no other iclogs we need to order
> > > +	 * against.
> > >  	 */
> > >  	if (ctx->start_lsn != commit_lsn) {
> > >  		spin_lock(&log->l_icloglock);
> > >  		xlog_wait_on_iclog(commit_iclog->ic_prev);
> > > +	} else {
> > > +		commit_iclog->ic_flags &= ~XLOG_ICL_NEED_FLUSH;
> > >  	}
> 
> .... that set/clear the flags on the iclog?  Yes, they probably
> should be atomic.
> 
> On second thoughts, we can't just clear XLOG_ICL_NEED_FLUSH here
> because there may be multiple commit records on this iclog and a
> previous one might require the flush. I'll just remove this
> optimisation from the patch right now, because it's more complex
> than it initially seemed.
> 

Ok.

> And looking at the aggregated code that I have now (including the
> stuff I haven't sent out), the need for xlog_write() to set the
> flush flags on the iclog is gone. THis is because the unmount record
> flushes the iclog directly itself so it can add flags there, and
> the iclog that the commit record is written to is returned to the
> caller.
> 

Ok.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

