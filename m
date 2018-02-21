Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:5313 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751163AbeBUVQJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Feb 2018 16:16:09 -0500
Date: Thu, 22 Feb 2018 08:16:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 0/4] xfs: fix v5 AGFL wrapping
Message-ID: <20180221211606.GG7000@dastard>
References: <151863191996.12012.10898223924122487735.stgit@magnolia>
 <20180214195651.GB43414@bfoster.bfoster>
 <20180215020548.GN5217@magnolia>
 <20180215131630.GA48590@bfoster.bfoster>
 <20180216175701.GA27629@magnolia>
 <20180219135456.GB65426@bfoster.bfoster>
 <20180220170830.GF27629@magnolia>
 <20180221133915.GA29048@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180221133915.GA29048@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Wed, Feb 21, 2018 at 08:39:16AM -0500, Brian Foster wrote:
> On Tue, Feb 20, 2018 at 09:08:30AM -0800, Darrick J. Wong wrote:
> > On Mon, Feb 19, 2018 at 08:54:57AM -0500, Brian Foster wrote:
> > > On Fri, Feb 16, 2018 at 09:57:01AM -0800, Darrick J. Wong wrote:
> > > I guess I haven't really noticed it enough to consider it an ongoing
> > > issue (which doesn't mean it isn't :P). Any pattern to the use cache
> > > behind these continued reports..?
> > 
> > No particular pattern, other than using/freeing agfl blocks.
> > 
> 
> I'm more curious about the use case than the workload. E.g., what's the
> purpose for using two kernels? Was it bad luck on an upgrade or
> something that implies the problematic state could reoccur (i.e., active
> switching between good/bad kernels)?

It's the absurb cloud image creation/deployment hoops that seem
popular these days, where an image is created on one machine,
it's mounted, modified and made ready for production on another,
and then deployed to a third machine.

We've seen this quite a few times now where the original image and
deployment targets are running the same kernel, but the machine that
does the "make ready for production" step runs a different kernel.
I've seen several setups where RHEL7 kernels were used for steps 1&3,
and a near TOT stable kernel was running step 2....

That's the problem case we have to care about here. People are
moving filesystem images from machine to machine, backwards and
forwards, because they don't have any idea that different machines
in the cloud workflow are running different kernels.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
