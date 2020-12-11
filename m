Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B012CC433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Dec 2020 02:12:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EB4923DE4
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Dec 2020 02:12:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389877AbgLKCLk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Dec 2020 21:11:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28826 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389853AbgLKCLZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Dec 2020 21:11:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607652598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pO7PIxK3SuAhAzUbwGpnFzHAw6oRVCPOTeOfU0ry5Os=;
        b=Lyr0tfLiMGAa0rkwbhfdE5i4oLyAa9HFIZB+ZsDiPFVLa7uYqCZGJSa2g16mbWkPjmooSQ
        uPW1yYt2o3kW/ZFgVMy1Iw8+PU5AGifXn2WVn8yW15EQnzuGsw1jDxEvwZe5v7Ivfk+CUU
        nsjlaTiDQ8mnCiajMQ+VQxE9jByAsVY=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-572-LPQryPuhMA2Uv7V1r0_F2Q-1; Thu, 10 Dec 2020 21:09:56 -0500
X-MC-Unique: LPQryPuhMA2Uv7V1r0_F2Q-1
Received: by mail-pf1-f198.google.com with SMTP id x20so5363992pfm.6
        for <linux-xfs@vger.kernel.org>; Thu, 10 Dec 2020 18:09:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pO7PIxK3SuAhAzUbwGpnFzHAw6oRVCPOTeOfU0ry5Os=;
        b=G046ptrL6otG8eGe6plkqcF7ttqXRYitckWnl3m6mfkU5+f7LXcWz9Q5pOFT5/U5Os
         MTl+O62bG9M8peAzxj/stAh+hYMRQSufyhy3Vaco+X/fObXpfbBVBBJLtwEMffinmcB5
         5TOCDj2dKnKHD4eOWDHO/xyyJsv87hmKTXFGzTaKuHkErhS6pTgvZLblzN6T3FQrzvbl
         aYNeYjjLd3qpaIjbRrEq0tu0LMZsr8JMtIfUZEAGBnaEZnX2ROLsgl3QUicB9NmUj26k
         NLTFPgSRujw3RJD8v7hhado+FOISvkEyt+LTMuyaUSSNsyuAOGQ1m3EPpID6hG2XVC7E
         IVCA==
X-Gm-Message-State: AOAM53095R/cAafJ9vi+9iTByfXjGac+/J36+wYWuauZPvrJia1fehHd
        4hTTVJYzbeKR8P08FR7V4rA2idf1kDFyUYlE778j0U0NlBCyCJ7bWXxM6045n56zN6r0RLXEodm
        ay64myiPCgTHVoL6BZTw0
X-Received: by 2002:a17:90a:5513:: with SMTP id b19mr11018322pji.99.1607652594973;
        Thu, 10 Dec 2020 18:09:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyOgdKwXaPwb0boMCGfGF59jRuLHol7YVn4kZC/y23h1lSVWZVZ0+GYFbjDto2F7iWvrVnfGA==
X-Received: by 2002:a17:90a:5513:: with SMTP id b19mr11018303pji.99.1607652594737;
        Thu, 10 Dec 2020 18:09:54 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f92sm8661890pjk.54.2020.12.10.18.09.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 18:09:54 -0800 (PST)
Date:   Fri, 11 Dec 2020 10:09:44 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: silence a cppcheck warning
Message-ID: <20201211020944.GA487622@xiangao.remote.csb>
References: <20201210235747.469708-1-hsiangkao@redhat.com>
 <20201211011744.GA632069@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201211011744.GA632069@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

On Fri, Dec 11, 2020 at 12:17:44PM +1100, Dave Chinner wrote:
> On Fri, Dec 11, 2020 at 07:57:47AM +0800, Gao Xiang wrote:
> > This patch silences a new cppcheck static analysis warning
> > >> fs/xfs/libxfs/xfs_sb.c:367:21: warning: Boolean result is used in bitwise operation. Clarify expression with parentheses. [clarifyCondition]
> >     if (!!sbp->sb_unit ^ xfs_sb_version_hasdalign(sbp)) {
> > 
> > introduced from my patch. Sorry I didn't test it with cppcheck before.
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> 

...

> > ---
> >  fs/xfs/libxfs/xfs_sb.c | 7 ++-----
> >  1 file changed, 2 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > index bbda117e5d85..ae5df66c2fa0 100644
> > --- a/fs/xfs/libxfs/xfs_sb.c
> > +++ b/fs/xfs/libxfs/xfs_sb.c
> > @@ -360,11 +360,8 @@ xfs_validate_sb_common(
> >  		}
> >  	}
> >  
> > -	/*
> > -	 * Either (sb_unit and !hasdalign) or (!sb_unit and hasdalign)
> > -	 * would imply the image is corrupted.
> > -	 */
> > -	if (!!sbp->sb_unit ^ xfs_sb_version_hasdalign(sbp)) {
> > +	if ((sbp->sb_unit && !xfs_sb_version_hasdalign(sbp)) ||
> > +	    (!sbp->sb_unit && xfs_sb_version_hasdalign(sbp))) {
> >  		xfs_notice(mp, "SB stripe alignment sanity check failed");
> >  		return -EFSCORRUPTED;
> 
> But, ummm, what's the bug here? THe logic looks correct to me -
> !!sbp->sb_unit will have a value of 0 or 1, and
> xfs_sb_version_hasdalign() returns a bool so will also have a value
> of 0 or 1. That means the bitwise XOR does exactly the correct thing
> here as we are operating on two boolean values. So I don't see a bug
> here, nor that it's a particularly useful warning.
> 
> FWIW, I've never heard of this "cppcheck" analysis tool. Certainly
> I've never used it, and this warning seems to be somewhat
> questionable so I'm wondering if this is just a new source of random
> code churn or whether it's actually finding real bugs?

Here is a reference of the original report:
https://www.mail-archive.com/kbuild@lists.01.org/msg05057.html

The reason I didn't add "Fixes:" or "Reported-by:" or use "fix" in the
subject since I (personally) don't think it's worth adding, since I
have no idea when linux kernel runs with "cppcheck" analysis tool
(I only heard "sparse and smatch are using "before.) and I don't think
it's actually a bug here.

If "cppcheck" should be considered, I'm also wondering what kind of
options should be used for linux kernel. And honestly, there are many
other analysis tools on the market, many of them even complain about
"strcpy" and should use "strcpy_s" instead (or many other likewise).

Personally I don't think it's even worth adding some comments about
this since it's a pretty straight-forward boolean algebra on my side
(but yeah, if people don't like it, I can update it as well since
 it's quite minor to me.)

Thanks,
Gao Xiang

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

