Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27960 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750708AbdK3WBY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Nov 2017 17:01:24 -0500
Date: Thu, 30 Nov 2017 14:01:18 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/5] xfs_db: print structure padding fields consistently
Message-ID: <20171130220118.GM21412@magnolia>
References: <151094860143.27182.12022983202520916281.stgit@magnolia>
 <151094860737.27182.5422098949147661107.stgit@magnolia>
 <5fc6a92d-b7f7-2dae-862c-d266cc46df99@sandeen.net>
 <20171130215149.GL21412@magnolia>
 <a19255b1-f186-2db1-0a87-ff432ac6b7fe@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a19255b1-f186-2db1-0a87-ff432ac6b7fe@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Thu, Nov 30, 2017 at 03:57:16PM -0600, Eric Sandeen wrote:
> 
> 
> On 11/30/17 3:51 PM, Darrick J. Wong wrote:
> > On Thu, Nov 30, 2017 at 03:37:54PM -0600, Eric Sandeen wrote:
> >> On 11/17/17 1:56 PM, Darrick J. Wong wrote:
> >>> From: Darrick J. Wong <darrick.wong@oracle.com>
> >>>
> >>> We are very inconsistent about how we print padding fields in on-disk
> >>> structures -- sometimes we hide it from printall, sometimes we deviate
> >>> from unsigned hex values, etc.  Make this all consistent -- never hide
> >>> padding values, always print them as unsigned hex integers.
> >>
> >> I'm not sure I see the point to cluttering up structure printing
> >> with padding, and would prefer to hide them /all/ by default (and
> >> set them all to hex printing when explicitly asked for).
> >>
> >> Consistency is good but I'm not sure we need to consistently print
> >> values that are never even used...?
> > 
> > Ok.  Will you take a patch that changes them all to FLD_SKIPALL?
> 
> and sets them all to hex type, and adds missing ones?  Sure.
> 
> If you love the idea of printing padding or need it, that's ok,
> I'd just like a little justification for the extra clutter,
> if you need it. :)

Originally it was so that the fuzz tests could test whether or not
fsck/scrub notice garbage in the padding fields but then I observed that
we don't consistently write zeroes to padd fields, which means that we
can't check them in any meaningful manner.

--D

> Thanks,
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
