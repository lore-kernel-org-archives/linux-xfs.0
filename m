Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:34814 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752034AbeDHBiB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 7 Apr 2018 21:38:01 -0400
Date: Sat, 7 Apr 2018 18:37:57 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 0/6] xfs: quota fixes and enhancements
Message-ID: <20180408013757.GN7500@magnolia>
References: <f0856054-551f-9139-39f7-1d5439910903@sandeen.net>
 <6479893d-7f01-f262-6ec5-84a33237d2d8@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6479893d-7f01-f262-6ec5-84a33237d2d8@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Sat, Apr 07, 2018 at 05:00:13PM -0500, Eric Sandeen wrote:
> On 4/4/18 1:47 PM, Eric Sandeen wrote:
> > A semi-random smattering of quota stuff.  First three seem quite
> > good to go, the rest are more along the lines of a suggestion
> > or conversation-starter.  ;)
> > 
> > (the first patch is just removing an unused arg).
> > 
> > xfs_repair doesn't look at quota blocks.  At all.  It relies
> > on quotacheck in the kernel to fix them up as needed.
> 
> I'm starting to rethink a lot of this hackery.  Why doesn't xfs_repair
> just fix things up?  (leave quotacheck to the next mount, but the
> "repair" stuff in the kernel seems like a really strange wart.)
> 
> I think I'll look at teaching repair to sanity check the quota
> inodes, but if anyone knows why that's a bad idea please let me
> know.  ;)

/me shrugs, we still need to fix the kernel's quota verifiers to check
the uuid and all that, right?  Which means that both are going to need
patches, afaict.

--D

> Thanks,
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
