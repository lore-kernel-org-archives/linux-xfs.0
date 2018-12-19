Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:48238 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725290AbeLSFaJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Dec 2018 00:30:09 -0500
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gZUQi-0001H8-OO
        for linux-xfs@vger.kernel.org; Wed, 19 Dec 2018 16:30:00 +1100
Date: Wed, 19 Dec 2018 16:30:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: reflink status?
Message-ID: <20181219053000.GA4205@dastard>
References: <20181218212207.GA27985@teal.hq.k1024.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181218212207.GA27985@teal.hq.k1024.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Tue, Dec 18, 2018 at 10:22:07PM +0100, Iustin Pop wrote:
> Apologies if this information is available somewhere, but a quick scan
> at the list archives failed to clarify things for me.
> 
> How production ready is the reflink/clone code?

The XFS code is pretty robust - I've been using it in anger for
filesystem image duplication on my test machines for well over a
year now, so it gets beaten on every day by my test machines...

> I saw a patch series in
> October for 4.19rc-something with many fixes ("fixes for serious
> clone/dedupe problems"), so I guess pre-4.19 kernels are not quite
> recommended yet? Is 4.19 OK for it?

... but the vfs interfaces were not so good. The original APIs were
overly complex and not very well defined or implemented, so there
were lots of little corner cases where things could go very wrong.

IOWs, if you are doing basic stuff like cloning entire files (e.g.
cp --reflink=always) then they work just fine. However, if you have
custom apps that do partial file operations (i.e.  use the "range"
part of the API) and/or overwrite parts of existing files using
clones, then there's lots of corner cases where stuff can go wrong.

best advice right now is to use the most recent kernel you can -
4.19 has the worst problems already fixed - and upgrade to 4.20 when
it is released.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
