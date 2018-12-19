Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ed1-f44.google.com ([209.85.208.44]:41027 "EHLO
        mail-ed1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728724AbeLSVaW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Dec 2018 16:30:22 -0500
Received: by mail-ed1-f44.google.com with SMTP id g19so11603502edy.8
        for <linux-xfs@vger.kernel.org>; Wed, 19 Dec 2018 13:30:21 -0800 (PST)
Received: from teal.hq.k1024.org (77-59-128-99.dclient.hispeed.ch. [77.59.128.99])
        by smtp.gmail.com with ESMTPSA id w24-v6sm2955973eja.71.2018.12.19.13.30.19
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Dec 2018 13:30:20 -0800 (PST)
Date: Wed, 19 Dec 2018 22:30:19 +0100
From: Iustin Pop <iustin@k1024.org>
Subject: Re: reflink status?
Message-ID: <20181219213019.GG14820@teal.hq.k1024.org>
References: <20181218212207.GA27985@teal.hq.k1024.org>
 <20181219053000.GA4205@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181219053000.GA4205@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On 2018-12-19 16:30:00, Dave Chinner wrote:
> On Tue, Dec 18, 2018 at 10:22:07PM +0100, Iustin Pop wrote:
> > Apologies if this information is available somewhere, but a quick scan
> > at the list archives failed to clarify things for me.
> > 
> > How production ready is the reflink/clone code?
> 
> The XFS code is pretty robust - I've been using it in anger for
> filesystem image duplication on my test machines for well over a
> year now, so it gets beaten on every day by my test machines...

Got it, thanks.

> > I saw a patch series in
> > October for 4.19rc-something with many fixes ("fixes for serious
> > clone/dedupe problems"), so I guess pre-4.19 kernels are not quite
> > recommended yet? Is 4.19 OK for it?
> 
> ... but the vfs interfaces were not so good. The original APIs were
> overly complex and not very well defined or implemented, so there
> were lots of little corner cases where things could go very wrong.

Interesting.

> IOWs, if you are doing basic stuff like cloning entire files (e.g.
> cp --reflink=always) then they work just fine. However, if you have
> custom apps that do partial file operations (i.e.  use the "range"
> part of the API) and/or overwrite parts of existing files using
> clones, then there's lots of corner cases where stuff can go wrong.

I see. Yes, this is my intended use case, so I'll hold off for now.

> best advice right now is to use the most recent kernel you can -
> 4.19 has the worst problems already fixed - and upgrade to 4.20 when
> it is released.....

I was hoping 4.19 is "good to go", since it's an LTS version; I prefer
to keep to LTS to reduce upgrade churn.

But, it also means the next LTS will be even more stable in this regard,
so all is good.

Thanks for the fast reply!

iustin
