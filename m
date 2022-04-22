Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59EF2C433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Apr 2022 16:22:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381788AbiDVQZa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Apr 2022 12:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381784AbiDVQZ1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Apr 2022 12:25:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F1DEB5DE77
        for <linux-xfs@vger.kernel.org>; Fri, 22 Apr 2022 09:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650644553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=91guVFhA4c6rMSnJbNy065R1r+hZGV4CGuBJvar4hZ4=;
        b=QJbFnd3x2xLfwlopYG0/OqlojmKRYttKRMjLHRpDWYHiqpjtbwSU8zWf0ibI+oEBNQn3+l
        a3Eq5sotuRJ47ZAIo+u3N/eS47XhwS1UTsOWHO3WEqS4/t7EfkB7RFtMAd0Z5Mcf2hYith
        chrJG6qu7itSooBY6AnAlQevj+mCImg=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-148-zOCVpsVjO_21Rrt1Z1QgLg-1; Fri, 22 Apr 2022 12:22:31 -0400
X-MC-Unique: zOCVpsVjO_21Rrt1Z1QgLg-1
Received: by mail-qk1-f199.google.com with SMTP id t3-20020a05620a034300b0069e60a0760cso5702102qkm.20
        for <linux-xfs@vger.kernel.org>; Fri, 22 Apr 2022 09:22:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=91guVFhA4c6rMSnJbNy065R1r+hZGV4CGuBJvar4hZ4=;
        b=cbFgZFOb8EAHfIccrFkRzRD17hR3Jns+9WMYPxWzU+94ZUJV7FFY1Rog02e8kLaG/d
         8Hg3oBDB+ry/uo25Gdjgr698bQHwBjWafeTE1awASnX/Rj+ht0lOgtzoybaZ5BE+pRP3
         odm4lhoN6/2vSA0AOgYT8ZMvNIgZSzfrKyStHZ4qmyMAyVjZj3YIlMxJXqZ53W5vG1nH
         6sudU169Mzv5qCXQzqc4RCwoFz+8UrMXbybwOSQC6WHGKVOnGzxlst72bOqe5eIav2+K
         HTnsF3RY49mXoEHunl/FTezfLJuBlsuEF8b0P8eAa3D15ezqh+f+rt+v63OotsZBNWsK
         tkzQ==
X-Gm-Message-State: AOAM532ikEm7h8JupJtyFGfqOQuo4xw3/Y1aSb9Ij5DGyMkvuZj49yLo
        P0BsuT459vo0EOMPJgtd2zT/q8MojmUx5FDbgDTKxzFAzSGu5AdUU3wbg3kMtBv9Y1l+ci/hif3
        X8f8U+OiWAv+mzhpmxGfE
X-Received: by 2002:a05:622a:191:b0:2f1:ffe6:283c with SMTP id s17-20020a05622a019100b002f1ffe6283cmr3763856qtw.557.1650644551275;
        Fri, 22 Apr 2022 09:22:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzr/g9eL0NXPiiZSlLtnLRfqAoQm1t5WmQ1V810/XXBpWLBqK94uIqmFckHXGsM/S+dSePrcw==
X-Received: by 2002:a05:622a:191:b0:2f1:ffe6:283c with SMTP id s17-20020a05622a019100b002f1ffe6283cmr3763840qtw.557.1650644551045;
        Fri, 22 Apr 2022 09:22:31 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id j131-20020a37a089000000b0069e7ebc625bsm1066807qke.78.2022.04.22.09.22.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 09:22:30 -0700 (PDT)
Date:   Fri, 22 Apr 2022 12:22:28 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix soft lockup via spinning in filestream ag
 selection loop
Message-ID: <YmLWRBjTSP43r6Cs@bfoster>
References: <20220422141226.1831426-1-bfoster@redhat.com>
 <20220422160021.GB17025@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422160021.GB17025@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 22, 2022 at 09:00:21AM -0700, Darrick J. Wong wrote:
> On Fri, Apr 22, 2022 at 10:12:26AM -0400, Brian Foster wrote:
> > The filestream AG selection loop uses pagf data to aid in AG
> > selection, which depends on pagf initialization. If the in-core
> > structure is not initialized, the caller invokes the AGF read path
> > to do so and carries on. If another task enters the loop and finds
> > a pagf init already in progress, the AGF read returns -EAGAIN and
> > the task continues the loop. This does not increment the current ag
> > index, however, which means the task spins on the current AGF buffer
> > until unlocked.
> > 
> > If the AGF read I/O submitted by the initial task happens to be
> > delayed for whatever reason, this results in soft lockup warnings
> 
> Is there a specific 'whatever reason' going on here?
> 

Presumably.. given this seems to reproduce reliably or not at all in
certain environments/configs, my suspicion was that either the timing of
the test changes enough such that some other task involved with the test
is able to load the bdev, or otherwise timing changes just enough to
trigger the pagf_init race and the subsequent spinning is what
exacerbates the delay (i.e. burning cpu and subsequent soft lockup BUG
starve out some part(s) of the I/O submission/completion processing).
I've no tangible evidence for either aside from the latter seems fairly
logical when you consider that the test consistently completes in 3-4
seconds with the fix in place, but without it we consistently hit
multiple instances of the soft lockup detector (on ~20s intervals IIRC)
and the system seems to melt down indefinitely. *shrug*

Brian

> > via the spinning task. This is reproduced by xfs/170. To avoid this
> > problem, fix the AGF trylock failure path to properly iterate to the
> > next AG. If a task iterates all AGs without making progress, the
> > trylock behavior is dropped in favor of blocking locks and thus a
> > soft lockup is no longer possible.
> > 
> > Fixes: f48e2df8a877ca1c ("xfs: make xfs_*read_agf return EAGAIN to ALLOC_FLAG_TRYLOCK callers")
> 
> Ooops, this was a major braino on my part.
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> --D
> 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > I included the Fixes: tag because this looks like a regression in said
> > commit, but I've not explicitly verified.
> > 
> > Brian
> > 
> >  fs/xfs/xfs_filestream.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> > index 6a3ce0f6dc9e..be9bcf8a1f99 100644
> > --- a/fs/xfs/xfs_filestream.c
> > +++ b/fs/xfs/xfs_filestream.c
> > @@ -128,11 +128,12 @@ xfs_filestream_pick_ag(
> >  		if (!pag->pagf_init) {
> >  			err = xfs_alloc_pagf_init(mp, NULL, ag, trylock);
> >  			if (err) {
> > -				xfs_perag_put(pag);
> > -				if (err != -EAGAIN)
> > +				if (err != -EAGAIN) {
> > +					xfs_perag_put(pag);
> >  					return err;
> > +				}
> >  				/* Couldn't lock the AGF, skip this AG. */
> > -				continue;
> > +				goto next_ag;
> >  			}
> >  		}
> >  
> > -- 
> > 2.34.1
> > 
> 

