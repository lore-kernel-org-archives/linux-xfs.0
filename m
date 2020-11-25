Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1E77C56201
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Nov 2020 23:57:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8738B20DD4
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Nov 2020 23:57:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="GSfuslRT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbgKYX5Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Nov 2020 18:57:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgKYX5Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Nov 2020 18:57:24 -0500
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19F6C0613D4
        for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2020 15:57:23 -0800 (PST)
Received: by mail-qk1-x743.google.com with SMTP id v143so170235qkb.2
        for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2020 15:57:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1gLJhkwZL5WHnwEIFNB/JO9CIv8V2CHzH3Td89zgurk=;
        b=GSfuslRTJrgxqEjDVUBmPEGmyMIn2pC+5TfmYI0jmUTxknWfVqTuN+vWRct7yucSZb
         /pNmb3h40HTTGcy3Ru1Co7qqVywsR8Npt3aXTjec65ac4TIWAh5jwL1Gt5kQhOeGDdZ2
         Jtx16L3J0Ct2uGH7EcUaMgwvDmWbcOqUUIUFzOSrVcb7vwyb7rQx/d3vEIaOXKEIHCT5
         VWW0is8j2/kxqkVEwgvNjDgJNXvPtSpiqhfXUZTgg4kDxUPLVDwlhqSd42OX8SIB0MyG
         bhMCpQFCPF/wUgJcMI4+CjUNy8JwyOaqJPOHHoLhXx4N9ssLqfFUMA9SW1xc62E2wZ8I
         XxaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1gLJhkwZL5WHnwEIFNB/JO9CIv8V2CHzH3Td89zgurk=;
        b=q0dldqzyk0bLdFnCoQHbnwspGOBV6sw+msa2+SINq8bqn2YTpymkqMpJ6mrbPQyy1Z
         a5ZhcjvTkEeZMV9Dgyj8ShdzTw/Li++EqV7nDjexXeUPtRaOld2U5OcdTEFBx87rOIrZ
         3WxHCvFWa62ar7qQFL73cfiikK0u/BjOnPBIsbto5RchHIKDbAvc39X1ICYZtV33MJm3
         I4X/n3QQMNDWJ608xH1OoRWghSaoEScETvZxAC2h1CVGNn8MHXyuDK8UqEH9KaEUChbu
         hKmL+oRR0+bjeT/7SIBQMC3wZVcLhqYmsrtAx6Va1jnvhEdM1lmy+ClSOTRukTioZ+kB
         dO1A==
X-Gm-Message-State: AOAM532Mwc6cnzRQ2NIgoy6CKxbC/qMsJHk7ox3/1SBeitnC5PT/Qnzy
        zeM6TONO9FItvUAFAZq129+5pQ==
X-Google-Smtp-Source: ABdhPJyaalvrOWdezNgB6SjAER/qll6NTs9Dt1njWus9sIdv1t5iA8R0eLQMngEdaAP+frmCSD+eGg==
X-Received: by 2002:a37:4893:: with SMTP id v141mr574084qka.361.1606348642398;
        Wed, 25 Nov 2020 15:57:22 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id x19sm901590qtr.65.2020.11.25.15.57.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 15:57:21 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1ki4f2-001QAA-Pf; Wed, 25 Nov 2020 19:57:20 -0400
Date:   Wed, 25 Nov 2020 19:57:20 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Linux MM <linux-mm@kvack.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Brian Paul <brianp@vmware.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Christian Koenig <christian.koenig@amd.com>,
        Huang Rui <ray.huang@amd.com>
Subject: Re: [PATCH] drm/ttm: don't set page->mapping
Message-ID: <20201125235720.GR5487@ziepe.ca>
References: <20201125162532.1299794-1-daniel.vetter@ffwll.ch>
 <20201125162532.1299794-5-daniel.vetter@ffwll.ch>
 <CAKMK7uGXfqaPUtnX=VgA3tFn3S+Gt9GV+kPguakZ6FF_n8LKuA@mail.gmail.com>
 <20201125180606.GQ5487@ziepe.ca>
 <20201125181129.GA1858@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201125181129.GA1858@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 25, 2020 at 06:11:29PM +0000, Christoph Hellwig wrote:
> On Wed, Nov 25, 2020 at 02:06:06PM -0400, Jason Gunthorpe wrote:
> > It uses a empty 'cover-letter' commit and automatically transforms it
> > into exactly the right stuff. Keeps track of everything you send in
> > git, and there is a little tool to auto-run git range-diff to help
> > build change logs..
> > 
> > https://github.com/jgunthorpe/Kernel-Maintainer-Tools/blob/master/gj_tools/cmd_send_patches.py
> > 
> > I've been occasionaly wondering if I should suggest Konstantin add a
> > sending side to b4, maybe using some of those ideas..
> > 
> > (careful if you run it, it does autosend without prompting)
> 
> The looks pretty fancy.  Here is my trivial patchbomb.sh script
> 
> #!/bin/sh
> 
> COVERLETTER=$1
> PATCHES=$2
> 
> git send-email --annotate --to-cover --cc-cover $1 $2
> 
> still needs the git basecommit..endcommit notation, but it fires
> up the series for review.

annotate is OK, I used that for a long time..

My main gripe was it didn't setup the to/cc until after the annotate
editor closes.

Jason
