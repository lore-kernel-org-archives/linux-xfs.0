Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:35528 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752329AbeFHBXz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jun 2018 21:23:55 -0400
Date: Thu, 7 Jun 2018 18:23:51 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 01/14] xfs: repair the AGF and AGFL
Message-ID: <20180608012351.GP25007@magnolia>
References: <152770863951.11611.5866814627357136911.stgit@magnolia>
 <152770864591.11611.5564813732568495676.stgit@magnolia>
 <20180604015255.GJ10363@dastard>
 <20180605231856.GO9437@magnolia>
 <20180606040624.GO10363@dastard>
 <20180606045603.GV9437@magnolia>
 <20180607003132.GQ10363@dastard>
 <20180607044255.GB25007@magnolia>
 <20180608005517.GY10363@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180608005517.GY10363@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jun 08, 2018 at 10:55:17AM +1000, Dave Chinner wrote:
> On Wed, Jun 06, 2018 at 09:42:55PM -0700, Darrick J. Wong wrote:
> > On Thu, Jun 07, 2018 at 10:31:32AM +1000, Dave Chinner wrote:
> > > On Tue, Jun 05, 2018 at 09:56:03PM -0700, Darrick J. Wong wrote:
> > > > On Wed, Jun 06, 2018 at 02:06:24PM +1000, Dave Chinner wrote:
> > > > > On Tue, Jun 05, 2018 at 04:18:56PM -0700, Darrick J. Wong wrote:
> > > > > > On Mon, Jun 04, 2018 at 11:52:55AM +1000, Dave Chinner wrote:
> 
> [big snip]
> 
> I think we're in agreement with the direction we need to head, so
> rather than bikeshed it to death, I'll just say "yes, sounds like a
> good plan" and leave the rest to you, Darrick. :)

Ok!

> > Ok, so two extra scrub ioctl flags, then:
> > 
> > _IFLAG_FREEZE_OK	/* userspace allows repair to freeze the fs */
> > _OFLAG_AVOIDED_FREEZE	/* would have done something but couldn't freeze */
> > 
> > I'll think about how to add a new scrubber to take care of the global
> > summary counters, and in the meantime I think I'll nominate online
> > rmapbt repair and online quotacheck for _IFLAG_FREEZE_OK.
> 
> That's reasonable - I'm guessing the new global counter
> repair/scrubber will need this too?

Most likely.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
