Return-Path: <SRS0=POS4=YF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC6B4ECE58E
	for <linux-xfs@archiver.kernel.org>; Sat, 12 Oct 2019 00:19:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A720621835
	for <linux-xfs@archiver.kernel.org>; Sat, 12 Oct 2019 00:19:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="cR3zj9Qq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbfJLATY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Oct 2019 20:19:24 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33214 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727345AbfJLATY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Oct 2019 20:19:24 -0400
Received: by mail-qt1-f196.google.com with SMTP id r5so16468195qtd.0
        for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2019 17:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sP8HW4cnr13JQ9Tgtb6yVwceIcj+0+sDklR8/gApWqw=;
        b=cR3zj9Qql7kG9GpPxfYCuKNUUNbDiBlJ/Ui7C2d1cL2+QM65yqPTNjbV9JbTARB4Yy
         KEfJfnMh557qqgYFT1XHYPtzH9ONT6qkHjxIlCFoEZzQ4ZGswrqBdxzc6oweEGAU5ur+
         xJELJSKHTYKU7K0PQmOy8HruWihvJahIFnjI5VDGdUYir1heYgJoboYmLX2Qe1VTTKvs
         oH4TFU9okxA10c9ZOFxh284/E63t4FYHNLA44HmHiSf2furN5XD70hf/AeWrc6hZh+ks
         fS6vlRwHZ3Jr4rWR3Ri0IfTGAK567CLYZJ+fgNawIQafZnVaBo2fnxatd3rOg4h0o/cM
         OznA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sP8HW4cnr13JQ9Tgtb6yVwceIcj+0+sDklR8/gApWqw=;
        b=VfCnSR3JxQYDeSyrRry1VpmmUj362H0+6NADvLlfEaBfN2qCdkXXUqrNPOZvLJpSB5
         0jB1p/lRBApCWQBfjU3ArMrUbVo2MeHrg2SgzZLSUhx/dDiZ02PHKnx0aDCUsZ+TH5Ke
         RwZqR/VztMUBShcHYqWzMzJ3npOv2nGIrw44mZpR8BA0OUOPegDOq1mJFt4gI8jZiHDQ
         tZyuBe1so/+5Z+oPPvAB+7ZXglEIUu69l+i3Rak9OjIVM4aSzU65Hyz/58Ia13wGVIO2
         zhJwmQ2T3p26IO8MVAzD2bFcS7tMJE36N4Fw5y7zQgxw9jyIPax2hzkqwv//egtqWRuI
         poeA==
X-Gm-Message-State: APjAAAW5JjUAh7SY87GpgNWS1jw40s/FatpfFlRro+wNGl1mhmxdlfgc
        Eqq41r1ObXfkfiHjom610SIsjg==
X-Google-Smtp-Source: APXvYqxWIXOP4Z52KJMcefy+9D5D6SKAoYIhhWNU+dSOWCOleqgSV74M58GLHL9vPSgtV8bFeFwmkg==
X-Received: by 2002:a0c:ef87:: with SMTP id w7mr19241403qvr.49.1570839563472;
        Fri, 11 Oct 2019 17:19:23 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::677f])
        by smtp.gmail.com with ESMTPSA id t19sm4254918qto.55.2019.10.11.17.19.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Oct 2019 17:19:22 -0700 (PDT)
Date:   Fri, 11 Oct 2019 20:19:21 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH V2 00/26] mm, xfs: non-blocking inode reclaim
Message-ID: <20191012001919.lknks3k2at5xpxwf@macbook-pro-91.dhcp.thefacebook.com>
References: <20191009032124.10541-1-david@fromorbit.com>
 <20191011190305.towurweq7gsah4vr@macbook-pro-91.dhcp.thefacebook.com>
 <20191011234842.GQ16973@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011234842.GQ16973@dread.disaster.area>
User-Agent: NeoMutt/20180716
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Oct 12, 2019 at 10:48:42AM +1100, Dave Chinner wrote:
> On Fri, Oct 11, 2019 at 03:03:08PM -0400, Josef Bacik wrote:
> > On Wed, Oct 09, 2019 at 02:20:58PM +1100, Dave Chinner wrote:
> > > Hi folks,
> > > 
> > > This is the second version of the RFC I originally posted here:
> > > 
> > > https://lore.kernel.org/linux-xfs/20190801021752.4986-1-david@fromorbit.com/
> > > 
> > > The original description of the patchset is below, the issues and
> > > approach to solving them has not changed. THere is some
> > > restructuring of the patch set - the first few patches are all the
> > > XFS fixes that can be merged regardless of the rest of the patchset,
> > > but the non-blocking reclaim is somewhat dependent of them for
> > > correct behaviour. The second set of patches are the shrinker
> > > infrastructure changes needed for the shrinkers to feed back
> > > reclaim progress to the main reclaim instructure and act on the
> > > feedback. The last set of patches are the XFS changes needed to
> > > convert inode reclaim over to a non-blocking, IO-less algorithm.
> > 
> > I looked through the MM patches and other than the congestion thing they look
> > reasonable.  I think I can probably use this stuff to drop the use of the btree
> > inode.  However I'm wondering if it would be a good idea to add an explicit
> > backoff thing for heavy metadata dirty'ing operations.  Btrfs generates a lot
> > more dirty metadata than most, partly why my attempt to deal with this was tied
> > to using balance dirty pages since it already has all of the backoff logic.
> 
> That's an orthorgonal problem, I think. We still need the IO-less
> reclaim in XFS regardless of how we throttle build up of dirty
> metadata...
> 
> > Perhaps an explict balance_dirty_metadata() that we put after all
> > metadata operations so we have a good way to throttle dirtiers
> > when we aren't able to keep up?  Just a thought, based on my
> > previous experiences trying to tackle this issue for btrfs, what
> > you've done already may be enough to address these concerns.
> 
> The biggest issue is that different filesystems need different
> mechanisms for throttling dirty metadata build-up. In ext4/XFS, the
> amount of dirty metadata is bound by the log size, but that can
> still be massively more metadata than the disk subsystem can handle
> in a finite time.
> 
> IOWs, for XFS, the way to throttle dirty metadata buildup is to
> limit the amount of log space we allow the filesystem to use when we
> are able to throttle incoming transaction reservations. Nothing in
> the VFS/mm subsystem can see any of this inside XFS, so I'm not
> really sure how generic we could make a metadata dirtying throttle
> implementation....
>

Ok, I just read the mm patches and made assumptions about what you were trying
to accomplish.  I suppose I should probably dig my stuff back out.  Thanks,

Josef 
