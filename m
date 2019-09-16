Return-Path: <SRS0=IYS1=XL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1905C4CEC7
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 08:36:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F23820650
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 08:36:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731065AbfIPIgv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Sep 2019 04:36:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41094 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729718AbfIPIgv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Sep 2019 04:36:51 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C2532806CE
        for <linux-xfs@vger.kernel.org>; Mon, 16 Sep 2019 08:36:50 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id m14so4212628wru.17
        for <linux-xfs@vger.kernel.org>; Mon, 16 Sep 2019 01:36:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=MzkKNySgQcXSAk0OBLNE+JaRNDsByVNJOOeUrxSfllA=;
        b=pgaSo+hB+L1y40QaGorn0rUfegOf5FOF/2tzQyIhtXPCF8X7OQrWRawa/q4n4Ly+ta
         2PaK4txBYRdeSHlf4IyJpepd4pLlY3LcgVI/2HH8iylnUpHOkc2iaKzqHM55GF/sJgyn
         Xppqy2QwNy/5ugHJlWmeO1lBkzJNdhayMmsn4YNbbVODRsoQBOcghsf8vmpozsVLXlib
         5T/QhN8RwE8KSBL1BFo6IIufjfoNfYQ7C25e/E/UoVcSAN3PIFK/S9DZx1B9pKHaiR8t
         JljdpRTSLHLZYKSyKrWWyZYp7uoifGFARo1bqcdDo6eBSRZZSkrr5XSY8fksowSkDzOY
         Pcjg==
X-Gm-Message-State: APjAAAUlBirPNEPk347SiGrVO2hqnXwZms7KAtYG/pNzIH/WeeuzIAWu
        vXXb4G0qO/QF3awuDtfFCePGsXikd6T4YA6qnXQMELQhVQZmHVtZK3KqQ3lMSttkn1MHt31bquB
        L3lTXW3XZq1o04PlZYSqB
X-Received: by 2002:a1c:a7d2:: with SMTP id q201mr7040441wme.146.1568623009163;
        Mon, 16 Sep 2019 01:36:49 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx+l+e2a5XsItCuaTgLB8/W3nJXWfs/4YhwfWisjHARCWuuzPiFUH7b9TmXtcX+LSOvQmDd5w==
X-Received: by 2002:a1c:a7d2:: with SMTP id q201mr7040430wme.146.1568623008949;
        Mon, 16 Sep 2019 01:36:48 -0700 (PDT)
Received: from pegasus.maiolino.io (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id r9sm54883460wra.19.2019.09.16.01.36.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 01:36:48 -0700 (PDT)
Date:   Mon, 16 Sep 2019 10:36:46 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH REPOST 1/2] xfs: drop minlen before tossing alignment on
 bmap allocs
Message-ID: <20190916083646.3fivv4uqcahczs5q@pegasus.maiolino.io>
Mail-Followup-To: Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20190912143223.24194-1-bfoster@redhat.com>
 <20190912143223.24194-2-bfoster@redhat.com>
 <20190912223519.GP16973@dread.disaster.area>
 <20190913145802.GB28512@bfoster>
 <20190914220035.GY16973@dread.disaster.area>
 <20190915130931.GB37752@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190915130931.GB37752@bfoster>
User-Agent: NeoMutt/20180716
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> > > > aligned.
> > > > 
> > > 
> > > I agree that this addresses the reported issue, but I can reproduce
> > > other corner cases affected by the original patch that aren't affected
> > > by this one. For example, if the allocation request happens to be
> > > slightly less than blen but not enough to allow for alignment, minlen
> > > isn't dropped and we can run through the same allocation retry sequence
> > > that kills off alignment before success.
> > 
> > But isn't that just another variation of the initial conditions
> > (minlen/maxlen) not being set up correctly for alignment when the AG
> > is empty?
> > 
> 
> Perhaps, though I don't think it's exclusive to an empty AG.
> 
> > i.e. Take the above condition and change it like this:
> > 
> >  	/*
> >  	 * Adjust for alignment
> >  	 */
> > -	if (blen > args.alignment && blen <= args.maxlen)
> > +	if (blen > args.alignment && blen <= args.maxlen + args.alignment)
> >  		args.minlen = blen - args.alignment;
> >  	args.minalignslop = 0;
> > 
> > and now we cover all the cases when blen covers an aligned maxlen
> > allocation...
> > 
> 
> Do we want to consider whether minlen goes to 1? Otherwise that looks
> reasonable to me. What I was trying to get at is just that we should
> consider whether there are any other corner cases (that we might care
> about) where this particular allocation might not behave as expected vs.
> just the example used in the original commit log.
> 
> If somebody wants to send a finalized patch or two with these fixes
> along with the bma.total one (or I can tack it on in reply..?), I'll
> think about it further on review as well..

I didn't realize the conversation was already going on before I replied for the
first time, my apologies for unnecessary emails.

I've been working on some patches about this issue since I had this chat with
Dave, but I do not have anything 'mature' yet, exactly because some of the
issues you mentioned above, like the behavior not being exclusive to an empty
AG, and the fact the generic/223 was still failing after the 'fix' has been
applied (the single large fallocated file worked, but generic/223 no), so I was
kind of chasing my own tails on Friday :D

I'll get back to it today and see what I can do with fresh eyes.

Thanks Dave and Brian.

> 
> Brian
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com

-- 
Carlos
