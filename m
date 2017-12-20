Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:55176 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751491AbdLTFVl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Dec 2017 00:21:41 -0500
Date: Tue, 19 Dec 2017 21:21:36 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 7/7] mkfs: remove logarithm based CLI options
Message-ID: <20171220052136.GQ12613@magnolia>
References: <20171218091158.14537-1-david@fromorbit.com>
 <20171218091158.14537-8-david@fromorbit.com>
 <20171220030111.GO12613@magnolia>
 <20171220040131.GF4094@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171220040131.GF4094@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Dec 20, 2017 at 03:01:31PM +1100, Dave Chinner wrote:
> On Tue, Dec 19, 2017 at 07:01:12PM -0800, Darrick J. Wong wrote:
> > On Mon, Dec 18, 2017 at 08:11:58PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Very few people use the log2 based size options for various mkfs
> > > parameters and they just clutter up the code. Get rid of them.
> > 
> > Maybe we should deprecate them for at least one release instead of
> > just hard breaking everyone's scripts?
> 
> Yet we don't even test that these options give the right results :/
> i.e. this patch does not cause any new regressions in xfstests...  I
> know of only one person who used them, and that was a guy that did
> testing for us in his spare time a few years ago.
> 
> Hence I'm of the opinion we should just remove them, just
> like we don't give people any warning of default mkfs values
> changing. Eric can decide what to do, but I wrote this patch after
> he pondered aloud on #xfs if we should just remove these options :P

Ahhh, so we can blame the maintainer then!  In that case,

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

8-)

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
