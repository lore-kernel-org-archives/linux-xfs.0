Return-Path: <SRS0=UWJz=XS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27390C32755
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Sep 2019 12:39:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0753420835
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Sep 2019 12:39:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438610AbfIWMjj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Sep 2019 08:39:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37092 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437280AbfIWMjj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Sep 2019 08:39:39 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5512E83F3D
        for <linux-xfs@vger.kernel.org>; Mon, 23 Sep 2019 12:39:38 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id 4so4976064wmj.6
        for <linux-xfs@vger.kernel.org>; Mon, 23 Sep 2019 05:39:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=2hKa8ASoo3Uvh0W9XmOxxiV5F8mRf+fGtqvjsuDPoL8=;
        b=IKiYqaFv5wRJ795nQuQAHl87OthXncyWnIVXK47+qmPlyFcg1LAwM4iHIUj64lZljb
         xuUTwjTFRPcEIYHZn9Bl4vOU6rWD7LscvbYW4EqNHEuy/IkrpLsTNaZn3dVS1ADRPZL5
         agKla+i1itasJGoA5GzzKSdBCdVl47xmN1pN+F/oHc3WXtoVGDGyAHhs5Dws/0un4MUf
         jRlGxgqt5fOpMSyb4nuniPDK8/arqkAL0iKyY+I6HsYTbfOQqjy5x18jjMzDH3W9QbYE
         AIsG34filogOYLPcu1Fk8+RcrlyROuopKBDvhRJpGFOSd5jpQCnGCB1790SZ4LL6FCZT
         Fm0w==
X-Gm-Message-State: APjAAAVmDozmnKA3psttxQNWCPb/nvfVm7FRRALREZC9AUEzRt17UB8Z
        UAdu7tKzFUIj5Q+afMKmFAY7Mdr/pBxDfi6Q79A8A4ZcsMYjWujxHdhpO5Oqxu4QWnwaYzsXfZD
        nHwhN6GfBZhq2vAOkzLfg
X-Received: by 2002:a5d:408c:: with SMTP id o12mr22188339wrp.312.1569242377090;
        Mon, 23 Sep 2019 05:39:37 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw/TW3ojVeMViRF6bd6fvTQ+aaa/2ztEN8C/GYyACqGxJpYYMZnAF4mOnOEfcYJZGQrBpIIpA==
X-Received: by 2002:a5d:408c:: with SMTP id o12mr22188322wrp.312.1569242376882;
        Mon, 23 Sep 2019 05:39:36 -0700 (PDT)
Received: from pegasus.maiolino.io (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id a3sm11914684wmc.3.2019.09.23.05.39.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2019 05:39:36 -0700 (PDT)
Date:   Mon, 23 Sep 2019 14:39:34 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 2/2] xfs: Limit total allocation request to maximum
 possible
Message-ID: <20190923123934.6zigycei3nmwi54x@pegasus.maiolino.io>
Mail-Followup-To: Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com
References: <20190918082453.25266-1-cmaiolino@redhat.com>
 <20190918082453.25266-3-cmaiolino@redhat.com>
 <20190918122859.GB29377@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918122859.GB29377@bfoster>
User-Agent: NeoMutt/20180716
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 18, 2019 at 08:28:59AM -0400, Brian Foster wrote:
> On Wed, Sep 18, 2019 at 10:24:53AM +0200, Carlos Maiolino wrote:
> > The original allocation request may have a total value way beyond
> > possible limits.
> > 
> > Trim it down to the maximum possible if needed
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> 
> Confused.. what was wrong with the original bma.total patch that it
> needs to be replaced?

At this point in time, what you mean by the 'original' patch? :) Yours? Or
Dave's?

If you meant yours, I was just trying to find out a way to fix it without
modifying the callers, nothing else than that.

If you meant regarding Dave's proposal, as he tagged his proposal as a /* Hack
*/, I was just looking for ways to change total, instead of cropping it to 0.

And giving the fact args.total > blen seems unreasonable, giving it will
certainly tail here, I just thought it might be a reasonable way to change
args.total value.

By no means this patchset was meant to supersede yours or Dave's idea though, I
was just looking for a different approach, if feasible.


> I was assuming we'd replace the allocation retry
> patch with the minlen alignment fixups and combine those with the
> bma.total patch to fix the problem. Hm?
> 
> >  fs/xfs/libxfs/xfs_bmap.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 07aad70f3931..3aa0bf5cc7e3 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -3477,6 +3477,11 @@ xfs_bmap_btalloc(
> >  			error = xfs_bmap_btalloc_filestreams(ap, &args, &blen);
> >  		else
> >  			error = xfs_bmap_btalloc_nullfb(ap, &args, &blen);
> > +
> > +		/* We can never have total larger than blen, so trim it now */
> > +		if (args.total > blen)
> > +			args.total = blen;
> > +
> 
> I don't think this is safe. The reason the original patch only updated
> certain callers is because those callers only used it for extra blocks
> that are already incorported into bma.minleft by the bmap layer itself.
> There are still other callers for which bma.total is specifically
> intended to be larger than the map size.

Afaik, yes, but still, total is basically used to attempt an allocation of data
+ metadata on the same AG if possible, reducing args.total to match blen, the
'worst' case would be to have an allocation of data + metadata on different ags,
which, if total is larger than blen, it will fall into that behavior anyway.


> 
> Brian
> 
> >  		if (error)
> >  			return error;
> >  	} else if (ap->tp->t_flags & XFS_TRANS_LOWMODE) {
> > -- 
> > 2.20.1
> > 

-- 
Carlos
