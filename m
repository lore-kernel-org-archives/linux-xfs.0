Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:38800 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751544AbeBBVve (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Feb 2018 16:51:34 -0500
Date: Fri, 2 Feb 2018 13:51:30 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xfs_scrub: call for testing
Message-ID: <20180202215130.GD4849@magnolia>
References: <e0ada9ef-aafb-5179-2729-447d67bd6265@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0ada9ef-aafb-5179-2729-447d67bd6265@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Feb 02, 2018 at 03:36:33PM -0600, Eric Sandeen wrote:
> Hey all - 
> 
> Darrick's done a great job with landing the xfs_scrub code in
> upstream kernel v4.15, and now merged on the for-next branch of
> xfsprogs to be released in xfsprogs-4.15.0.
> 
> As with any big new body of code, there might be some rough
> edges despite best efforts.  It'd be great to have people do
> some testing at this semi-early stage.
> 
> The 10,000ft overview is that the new xfs_scrub command can
> /validate/ a lot of what's on disk while the filesystem
> is mounted; and the ability to repair will come in the future.
> 
> For now, with the 4.15 kernel, functionality is limited to
> "scrubbing" meaning that it will simply check for consistency;
> in 4.15 there is no facility to repair or optimize/preen the
> filesystem.

FWIW the 4.16 kernel enhances scrub to cross-reference metadata with
each other for strengthened checking (not to mention picking up a pile
of bug fixes), so eventually you'll want to move on to that for testing.
Ofc we're not even to -rc1 yet so meh. :)

Longer term, I also have landed the dangerous_repair xfstest group that
uses xfs_db to fuzz every field in a filesystem to see if scrub will
complain and xfs_repair does something about it.  Right now it's a bit
of a mess because it'll trip over scrub/repair not complaining about
fields that have no bad values (think inode timestamps) but I'm working
on a larger analysis of triaging known failures and fixing things that
the tools should catch but don't.

> I'd really value feedback on scrub as it stand at this point -
> Is the documentation clear?  Is the output correct?  Do the
> tool's arguments make sense?  Does it segfault?  Does it
> find real errors?  Does it crash your kernel? Does it
> eat your data?

Yes, please look at those things!


Thanks to Eric for reviewing all the userspace patches, and Dave and
Brian for reviewing all the kernel patches!

--D

> (haha no it won't eat your data)
> ((haha no can't promise that with 100% certainty))
> 
> Thanks,
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
