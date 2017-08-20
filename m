Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:2297 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752274AbdHTCEl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Aug 2017 22:04:41 -0400
Date: Sun, 20 Aug 2017 12:04:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Estimate xfs_repair run time
Message-ID: <20170820020438.GQ10621@dastard>
References: <22ed5cf73260ae39bf59779b302d8ad3@assyoma.it>
 <d80ca25cd28ec433c39a7d7d22c4e371@assyoma.it>
 <20170819154804.GS4796@magnolia>
 <3fcdaa5ea4365a1ddb7c76070236e6b3@assyoma.it>
 <20170819162025.GT4796@magnolia>
 <a42886b91433dcf4d7fdd3f541f2374a@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a42886b91433dcf4d7fdd3f541f2374a@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Sat, Aug 19, 2017 at 06:39:58PM +0200, Gionatan Danti wrote:
> >{yes, yes, depends on which spindle(s) metadata end up on and how many
> >files cross AGs} in that order. :)
> 
> Mmm ok, as expected :)
> Do you have any direct experience of xfs_repair run times on big and
> full XFS filesystems?

Yes. And there's no hard and fast number we can give you because
runtime will depends on the amount and density of the metadata, the
speed of the underlying storage, how much RAM you have and how badly
corrupted the filesystem is.

IOWs, runtime can vary from a few minutes to a few days as you vary
those parameters, and there's really no way to tell in advance where
in that massive variance any specific production filesystem will
land.

Doing a test run (xfs_repair -n) to get a ballpark figure during a
planned downtime period is the only way you'll get any idea of the
*best case* repair duration on a *clean* filesystem. But the moment
repair finds corruptions, all guesses you can make about runtime go
out the window...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
