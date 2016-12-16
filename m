Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:32446 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754177AbcLPEVm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Dec 2016 23:21:42 -0500
Date: Fri, 16 Dec 2016 15:21:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/6] xfs_io: make various commands one-shot only
Message-ID: <20161216042113.GL4326@dastard>
References: <20161207034724.1613-1-david@fromorbit.com>
 <20161207034724.1613-6-david@fromorbit.com>
 <fec1a6dd-cebd-1ff4-e916-f696139b876e@sandeen.net>
 <20161216005326.GK4326@dastard>
 <533e20be-406a-c028-f51f-9c90775a8b66@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533e20be-406a-c028-f51f-9c90775a8b66@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, amir73il@gmail.com

On Thu, Dec 15, 2016 at 07:50:33PM -0600, Eric Sandeen wrote:
> On 12/15/16 6:53 PM, Dave Chinner wrote:
> > On Thu, Dec 15, 2016 at 12:21:43PM -0600, Eric Sandeen wrote:
> > Because they are aimed at single, specific filesystem operations
> > only. It just doesn't make sense to iterate them across all open
> > files inside xfs_io. If you have multiple filesystems youneed to
> > query/modify, then do an xfs_io call for each. 
> 
> Ok, I guess this finally clicked for me; a very easily described
> test for whether the flag gets set:
> 
>   Only operations which specifically operate on /files/ will iterate*.
> 
>   System-wide and fs-wide operations (even if they happen to take a
>   file as an argument, as i.e. freeze can) do /not/ iterate.
> 
> *and open doesn't iterate because recursion :)
> 
> I'm happy with that, though I think it should be documented clearly.
> 
> Sorry if I was slow getting to your point.

No, you're not slow, I simply couldn't explain my rationale as
clearly and obviously as you've just done. I'll add that to my man
page updates, and repost the series for you.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
