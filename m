Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:8994 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753890AbdLTECF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Dec 2017 23:02:05 -0500
Date: Wed, 20 Dec 2017 15:01:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 7/7] mkfs: remove logarithm based CLI options
Message-ID: <20171220040131.GF4094@dastard>
References: <20171218091158.14537-1-david@fromorbit.com>
 <20171218091158.14537-8-david@fromorbit.com>
 <20171220030111.GO12613@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171220030111.GO12613@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Dec 19, 2017 at 07:01:12PM -0800, Darrick J. Wong wrote:
> On Mon, Dec 18, 2017 at 08:11:58PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Very few people use the log2 based size options for various mkfs
> > parameters and they just clutter up the code. Get rid of them.
> 
> Maybe we should deprecate them for at least one release instead of
> just hard breaking everyone's scripts?

Yet we don't even test that these options give the right results :/
i.e. this patch does not cause any new regressions in xfstests...  I
know of only one person who used them, and that was a guy that did
testing for us in his spare time a few years ago.

Hence I'm of the opinion we should just remove them, just
like we don't give people any warning of default mkfs values
changing. Eric can decide what to do, but I wrote this patch after
he pondered aloud on #xfs if we should just remove these options :P

-Dave.
-- 
Dave Chinner
david@fromorbit.com
