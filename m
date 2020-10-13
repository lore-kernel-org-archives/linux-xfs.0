Return-Path: <SRS0=8N9+=DU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C084C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 13:50:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C832C24766
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 13:50:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HORQKTAD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387996AbgJMNuE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Oct 2020 09:50:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37347 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387949AbgJMNuE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Oct 2020 09:50:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602597002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u0D25lrydV5pgCL2UW7ClhL4B2jVhF1wW2P69JAD3nQ=;
        b=HORQKTADQxv6awAXGltrcf++UOJZUAO6LmrQxE/3Bt68rXUcyi4zPI9mmNm37aEMMzi98m
        YbWi5wnYYzhxIb/gbyMF8mG22uG5NLax6iaAMJfB5ZyAhD4O2dd0fLUj2rfhO5torHi1+K
        rVldtLB9uUrKr4TURx0kcHiipJfCqyo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-5Okw04gxPbKY6v_nUW0L1A-1; Tue, 13 Oct 2020 09:50:01 -0400
X-MC-Unique: 5Okw04gxPbKY6v_nUW0L1A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23B13ADC27
        for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2020 13:50:00 +0000 (UTC)
Received: from bfoster (ovpn-112-249.rdu2.redhat.com [10.10.112.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B72455D9CD;
        Tue, 13 Oct 2020 13:49:59 +0000 (UTC)
Date:   Tue, 13 Oct 2020 09:49:57 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v11 4/4] xfs: replace mrlock_t with rw_semaphores
Message-ID: <20201013134957.GG966478@bfoster>
References: <20201009195515.82889-1-preichl@redhat.com>
 <20201009195515.82889-5-preichl@redhat.com>
 <20201012160412.GK917726@bfoster>
 <ffc87f66-759d-ac3c-5749-0972aa41924f@redhat.com>
 <20201013110427.GB966478@bfoster>
 <d780c465-a305-c3d2-e583-82d70a1f964e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d780c465-a305-c3d2-e583-82d70a1f964e@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 13, 2020 at 03:39:03PM +0200, Pavel Reichl wrote:
> 
> 
> On 10/13/20 1:04 PM, Brian Foster wrote:
> > On Mon, Oct 12, 2020 at 10:44:38PM +0200, Pavel Reichl wrote:
> >>
> >>
> >> On 10/12/20 6:04 PM, Brian Foster wrote:
> >>> ...
> >>>> @@ -2863,8 +2875,20 @@ xfs_btree_split(
> >>>>  	args.done = &done;
> >>>>  	args.kswapd = current_is_kswapd();
> >>>>  	INIT_WORK_ONSTACK(&args.work, xfs_btree_split_worker);
> >>>> +	/*
> >>>> +	 * Update lockdep's ownership information to reflect that we
> >>>> +	 * will be transferring the ilock from this thread to the
> >>>> +	 * worker.
> >>>> +	 */
> >>>
> >>> Can we update this comment to explain why we need to do this? E.g., I'm
> >>> assuming there's a lockdep splat somewhere down in the split worker
> >>> without it, but it's not immediately clear where and so it might not be
> >>> obvious if we're ever able to remove this.
> >>
> >> Hi, would something like this work for you?
> >>
> >> 	/*
> >> +	 * Update lockdep's ownership information to reflect that we
> >> +	 * will be transferring the ilock from this thread to the
> >> +	 * worker (xfs_btree_split_worker() run via queue_work()).
> >> +	 * If the ownership transfer would not happen lockdep would
> >> +	 * assert in the worker thread because the ilock would be owned
> >> +	 * by the original thread.
> >> +	 */
> >>
> > 
> > That doesn't really answer the question. Do you have a record of the
> > lockdep error message that occurs without this state transfer, by
> > chance?
> > 
> > Brian
> 
> Hi, please see this mail from Darrick - he hit the issue first - http://mail.spinics.net/lists/linux-xfs/msg38967.html
> 

Ah, I see.. thanks. I was thinking there was some kind of lock imbalance
warning or something, but in reality I think something like the
following is sufficient:

"Update lockdep's ownership information to reflect transfer of the ilock
from the current task to the worker. Otherwise assertions that the lock
is held (such as when logging the inode) might fail due to incorrect
task owner state."

Brian

> > 
> >>
> > 
> 

