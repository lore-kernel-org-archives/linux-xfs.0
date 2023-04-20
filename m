Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1697C7618E
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Apr 2023 22:54:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232719AbjDTWyY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Apr 2023 18:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbjDTWyX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Apr 2023 18:54:23 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 673333C06
        for <linux-xfs@vger.kernel.org>; Thu, 20 Apr 2023 15:54:22 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-63b87d23729so1403116b3a.0
        for <linux-xfs@vger.kernel.org>; Thu, 20 Apr 2023 15:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1682031262; x=1684623262;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kZSbuoiPSP9G0UkYrhhATJ8XJbsqlTPc25y6VuDNBBU=;
        b=BXdN/s0wDns+blju+1CObEYpPdX0++IBchDldvurjIRMo7PxUPq0JG0nniSuhezvUF
         3ozre2zIIb1OHYoHEFkYa7On5yds2N1A/+ORfiWuyj+v3FQGphMK2Lu/DaIKlRajZtfh
         4SFmT5Hw3PQFRSjoUOPLh2nAA7GO4b9ZE/QBQ4rW/x8F++cmlqGdSBq7ZnzN2PQBoJmg
         gf7zO8pmrVWr0yBOpwU5ykMSkRpPv0VJTUyHqd8e78Dk91NsyIo9mj6JDyqTytVfwpjI
         ABSO4AsMjkmoFg+53jAUud3ZtkyI2EJurntLW11JpocZaQGMeEWkDI38NuQ3tme8y52c
         2aDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682031262; x=1684623262;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kZSbuoiPSP9G0UkYrhhATJ8XJbsqlTPc25y6VuDNBBU=;
        b=bYimziKoaEhkq4wvVvp/Y6BV8Y/yT1n0LVoLRJkeMdoWbj4pe9ie2BNgbKiN+sFF5w
         y/7dqWbOKtVi9EG4MvgZd7cWRT+BQlX2aFTaFMVGaL81nfYgr9W2L6tq6BGLvES+S1CA
         cRpRZ7eEbG1TmlkLwz37JbmbTrp4VXh0IaIFWyZR23jLGH/4IVec8KkGlq4q/dj9qHvB
         eLNEYWZ0I42Czr8x5ykplB8dPHsbyyR4qaMqYqj9ISDo7EtHNGG21Z3gQacPEHCdjPIB
         NrC6Ame7/nkCZBj6dlcRddhc2Z0niJnUh4hvrSQULBAY0sMcqwvxb+FIp/gG4cCkyEXW
         mgPQ==
X-Gm-Message-State: AAQBX9dMi8YNta4O7aN5KQKQtVBE23p1VZ79UwZqqQGISxv7Fn0Ugm7c
        i4zhsU8J5p6iT0PrX4EOlJOp0g==
X-Google-Smtp-Source: AKy350YZ0/3HotQWDxefjmf+bI6pCOywKKW0sdCuF92oafYn1AR/lsRaQb2xcud+Ma9uUvzBYPutaQ==
X-Received: by 2002:a05:6a00:1143:b0:63b:6149:7ad6 with SMTP id b3-20020a056a00114300b0063b61497ad6mr3716465pfm.34.1682031261819;
        Thu, 20 Apr 2023 15:54:21 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id fd22-20020a056a002e9600b0063b6e3e5a39sm1734764pfb.52.2023.04.20.15.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 15:54:21 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ppdAQ-005pXv-5u; Fri, 21 Apr 2023 08:54:18 +1000
Date:   Fri, 21 Apr 2023 08:54:18 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs: log recovery stage split EFIs with multiple
 extents
Message-ID: <20230420225418.GY3223426@dread.disaster.area>
References: <20230414225836.8952-1-wen.gang.wang@oracle.com>
 <20230414225836.8952-3-wen.gang.wang@oracle.com>
 <20230420003050.GX3223426@dread.disaster.area>
 <C92853D7-A856-4BCC-880E-6DE6D3CC4EF8@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <C92853D7-A856-4BCC-880E-6DE6D3CC4EF8@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 20, 2023 at 05:10:42PM +0000, Wengang Wang wrote:
> 
> 
> > On Apr 19, 2023, at 5:30 PM, Dave Chinner <david@fromorbit.com> wrote:
> > 
> > On Fri, Apr 14, 2023 at 03:58:36PM -0700, Wengang Wang wrote:
> >> At log recovery stage, we need to split EFIs with multiple extents. For each
> >> orginal multiple-extent EFI, split it into new EFIs each including one extent
> >> from the original EFI. By that we avoid deadlock when allocating blocks for
> >> AGFL waiting for the held busy extents by current transaction to be flushed.
> >> 
> >> For the original EFI, the process is
> >> 1. Create and log new EFIs each covering one extent from the
> >>    original EFI.
> >> 2. Don't free extent with the original EFI.
> >> 3. Log EFD for the original EFI.
> >>    Make sure we log the new EFIs and original EFD in this order:
> >>      new EFI 1
> >>      new EFI 2
> >>      ...
> >>      new EFI N
> >>      original EFD
> >> The original extents are freed with the new EFIs.
> > 
> > We may not have the log space available during recovery to explode a
> > single EFI out into many EFIs like this. The EFI only had enough
> > space reserved for processing a single EFI, and exploding a single
> > EFI out like this requires an individual log reservation for each
> > new EFI. Hence this de-multiplexing process risks running out of log
> > space and deadlocking before we've been able to process anything.
> > 
> 
> Oh, yes, got it.
> 
> > Hence the only option we really have here is to replicate how CUIs
> > are handled.  We must process the first extent with a whole EFD and
> > a new EFI containing the remaining unprocessed extents as defered
> > operations.  i.e.
> > 
> > 1. free the first extent in the original EFI
> > 2. log an EFD for the original EFI
> > 3. Add all the remaining extents in the original EFI to an xefi chain
> > 4. Call xfs_defer_ops_capture_and_commit() to create a new EFI from
> >   the xefi chain and commit the current transaction.
> > 
> > xfs_defer_ops_capture_and_commit() will then add a work item to the
> > defered list which will come back to the new EFI and process it
> > through the normal runtime deferred ops intent processing path.
> > 
> 
> So you meant this?
> 
> Orig EFI with extent1 extent2 extent3
> free first extent1
> Full EFD to orig EFI
> transaction roll,
> xfs_defer_ops_capture_and_commit() to take care of extent2 and extent3

No. We do not need a transaction roll there if we rebuild a new
xefi list with the remaining extents from the original efi. At that
point, we call:

	<create transaction>
	<free first extent>
	<create new xefi list>
	<create and log EFD>
	xfs_defer_ops_capture_and_commit()
	  xfs_defer_ops_capture()
	    xfs_defer_create_intents()
	      for each tp->t_dfops
	        ->create intent
		  xfs_extent_free_create_intent()
		    create new EFI
		    walk each xefi and add it to the new intent
	    <captures remaining defered work>
	  xfs_trans_commit()

i.e. xfs_defer_ops_capture_and_commit() can builds new EFI for us
from the xefi list as part of defering the work that remains to be
done. Once it has done that, it queues the remaining work and
commits the transaction. Hence all we need to do in recovery of the
first extent is free it, create the xefi list and log the full EFD.
xfs_defer_ops_capture_and_commit() does the rest.

> If so, I don’t think it’s safe.
> Consider that case that kernel panic happened after the transaction roll,
> during next log replay, the original EFI has the matching EFD, so this EFI
> is ignored, but actually extent2 and extent3 are not freed.
> 
> If you didn’t mean above, but instead this:
> 
> Orig EFI with extent1 extent2 extent3
> free first extent1
> New EFI extent2 extent3
> Full EFD to orig EFI
> transaction roll,
> xfs_defer_ops_capture_and_commit() to take care of extent2 and extent3
> 
> The problem will comeback to the log space issue, are we ensured we have
> the space for the new EFI? 

Yes, because logging the full EFD cancels the original EFI and so it
no longer consumes log space. hence we can log a new EFI using the
space the original EFI consumed.

> > The first patch changed that path to only create intents with a
> > single extent, so the continued defer ops would then do the right
> > thing with that change in place. However, I think that we also need
> > the runtime code to process a single extent per intent per commit in
> > the same manner as above. i.e. we process the first extent in the
> > intent, then relog all the remaining unprocessed extents as a single
> > new intent.
> > 
> > Note that this is similar to how we already relog intents to roll
> > them forward in the journal. The only difference for single extent
> > processing is that an intent relog duplicates the entire extent list
> > in the EFD and the new EFI, whilst what we want is the new EFI to
> > contain all the extents except the one we just processed...
> > 
> 
> The problem to me is that where we place the new EFI, it can’t be after the EFD.
> I explained why above.

Yes it can. The only thing that matters is that the EFD and new EFI
are committed in the same transaction. Remember: transactions are
atomic change sets - either all the changes in the transaction are
replayed on recovery, or none of them are.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
