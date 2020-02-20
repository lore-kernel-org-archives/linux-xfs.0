Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 089DBC5ACC4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 00:17:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C55C4207FD
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 00:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582157852;
	bh=jM48Q8S80jNO8sEak38pj/s0s4TW2AmLgqOhvZ1fvgc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=y6TqZQgog+WljMF8eMSFxA7pQoVGvAXaK5PG8Bbj+xTNyMJNkMpoBalFHyiFHSArV
	 wu0bCltbINt5mIXzZdiqxi4/bStUBYiahl8wBGAyCZHNKE5uRrAlDRH01rwTLkT6O1
	 nIDySk/kbEe+t+z8fwTRLaMdiwwzAUHol/uJ7uys=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgBTARc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 19:17:32 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44594 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726677AbgBTARc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 19:17:32 -0500
Received: by mail-pf1-f194.google.com with SMTP id y5so934217pfb.11
        for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2020 16:17:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2xuGFeyyFc53TCt1xHINM1avjCVoIVtRCP71wJ8wRF0=;
        b=YqJCd/7xKmeM1YiFe8pkkTWAvih+rH62ReVV1RlzKV6Ltw/XSyQWRwN7D7BMVcfc7W
         /Hdy7cHENPE+F/CmLw1nltHIozpehIskVEcdcV3aQlon61A2rkfYiOCc7Nd7gNCNDui7
         x9tXo0qTFs9H7dgbtVkmdUZjcl6Ts9XdYbY1hYawzQZloQcBmeotpwjfepuf/m8SSfbi
         liHRVRhzSazs1UnZW3TTwcgfxGvWO17fErtZ8o2lZaKZZkkEIKw9GXprovdvF+WsIM+D
         W2AEZcWoDhwf+MlO6Z7K9NxFiuE5omdFCaxDOFW/ABYfPeRmNpv2MLa6bjo/a+oxNFsO
         qM4g==
X-Gm-Message-State: APjAAAXmWCjp0TvecUJNneN7w6C52yXDfAAZ/DRFlQbvOr58v9iWulw2
        uZ5G1FhsDBQ2o3d0sRf4Djk=
X-Google-Smtp-Source: APXvYqwwzhwmlY+5M1i9mcPyowHI/4va4aq7OEGaT9lYF2dnG2BXUla50r7TkTZT1EFXhe9ui9mQVQ==
X-Received: by 2002:a63:2f46:: with SMTP id v67mr31882029pgv.220.1582157851196;
        Wed, 19 Feb 2020 16:17:31 -0800 (PST)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id y3sm793607pff.52.2020.02.19.16.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 16:17:30 -0800 (PST)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 5BD00402D7; Thu, 20 Feb 2020 00:17:29 +0000 (UTC)
Date:   Thu, 20 Feb 2020 00:17:29 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Richard Wareing <rwareing@fb.com>, linux-xfs@vger.kernel.org,
        Anthony Iliopoulos <ailiopoulos@suse.de>,
        Yong Sun <YoSun@suse.com>
Subject: Re: Modern uses of CONFIG_XFS_RT
Message-ID: <20200220001729.GT11244@42.do-not-panic.com>
References: <20200219135715.GZ30113@42.do-not-panic.com>
 <20200219143227.aavgzkbuazttpwky@andromeda>
 <20200219143824.GR11244@42.do-not-panic.com>
 <20200219170945.GN9506@magnolia>
 <20200219175502.GS11244@42.do-not-panic.com>
 <20200219220104.GE9504@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219220104.GE9504@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 02:01:04PM -0800, Darrick J. Wong wrote:
> On Wed, Feb 19, 2020 at 05:55:02PM +0000, Luis Chamberlain wrote:
> > On Wed, Feb 19, 2020 at 09:09:45AM -0800, Darrick J. Wong wrote:
> > > On Wed, Feb 19, 2020 at 02:38:24PM +0000, Luis Chamberlain wrote:
> > > > On Wed, Feb 19, 2020 at 03:32:27PM +0100, Carlos Maiolino wrote:
> > > > > On Wed, Feb 19, 2020 at 01:57:15PM +0000, Luis Chamberlain wrote:
> > > > > > I hear some folks still use CONFIG_XFS_RT, I was curious what was the
> > > > > > actual modern typical use case for it. I thought this was somewhat
> > > > > > realted to DAX use but upon a quick code inspection I see direct
> > > > > > realtionship.
> > > > > 
> > > > > Hm, not sure if there is any other use other than it's original purpose of
> > > > > reducing latency jitters. Also XFS_RT dates way back from the day DAX was even a
> > > > > thing. But anyway, I don't have much experience using XFS_RT by myself, and I
> > > > > probably raised more questions than answers to yours :P
> > > > 
> > > > What about another question, this would certainly drive the users out of
> > > > the corners: can we remove it upstream?
> > > 
> > > My DVR and TV still use it to record video data.
> > 
> > Is anyone productizing on that though?
> > 
> > I was curious since most distros are disabling CONFIG_XFS_RT so I was
> > curious who was actually testing this stuff or caring about it.
> 
> Most != All.  We enabled it here, for development of future products.

Ah great to know, thanks!

> > > I've also been pushing the realtime volume for persistent memory devices
> > > because you can guarantee that all the expensive pmem gets used for data
> > > storage, that the extents will always be perfectly aligned to large page
> > > sizes, and that fs metadata will never defeat that alignment guarantee.
> > 
> > For those that *are* using XFS in production with realtime volume with dax...
> > I wonder whatcha doing about all these tests on fstests which we don't
> > have a proper way to know if the test succeeded / failed [0] when an
> > external logdev is used, this then applies to regular external log dev
> > users as well [1].
> 
> Huh?  How did we jump from realtime devices to external log files?

They share the same problem with fstests when using an alternative log
device, which I pointed out on [0] and [1].

[0] https://github.com/mcgrof/oscheck/blob/master/expunges/linux-next-xfs/xfs/unassigned/xfs_realtimedev.txt
[1] https://github.com/mcgrof/oscheck/blob/master/expunges/linux-next-xfs/xfs/unassigned/xfs_logdev.txt

> > Which makes me also wonder then, what are the typical big users of the
> > regular external log device?
> > 
> > Reviewing a way to address this on fstests has been on my TODO for
> > a while, but it begs the question of how much do we really care first.
> > And that's what I was really trying to figure out.
> > 
> > Can / should we phase out external logdev / realtime dev? Who really is
> > caring about this code these days?
> 
> Not many, I guess. :/
> 
> There seem to be a lot more tests these days that use dmflakey on the
> data device to simulate a temporary disk failure... but those aren't
> going to work for external log devices because they seem to assume that
> what we call the data device is also the log device.

That goes to show that the fstests assumption on a shared data/log device was
not only a thing of the past, its still present, and unless we address
soon, the gap will only get bigger.

OK thanks for the feedback. The situation in terms of testing rtdev or
external logs seems actually worse than I expected given the outlook for
the future and no one seeming to really care too much right now. If the
dax folks didn't care, then the code will likely just bit rot even more.
Is it too nutty for us to consider removing it as a future goal?

  Luis
