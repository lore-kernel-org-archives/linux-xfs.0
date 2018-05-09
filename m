Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44010 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751052AbeEIMHj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 May 2018 08:07:39 -0400
Date: Wed, 9 May 2018 05:07:38 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/3] xfs: add bmapi nodiscard flag
Message-ID: <20180509120738.GA1050@infradead.org>
References: <20180508172231.53570-1-bfoster@redhat.com>
 <20180508172231.53570-2-bfoster@redhat.com>
 <20180509074629.GC19933@infradead.org>
 <20180509105853.GD64624@bfoster.bfoster>
 <20180509113942.GA17093@infradead.org>
 <20180509120150.GA65322@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180509120150.GA65322@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>

On Wed, May 09, 2018 at 08:01:51AM -0400, Brian Foster wrote:
> > self-documenting, very much unlike a 'true' or 'false' argument.
> 
> I'm fine with replacing the bool argument(s) with flags where applicable
> if we do eliminate the wrappers. I'm just hesitant to change it given
> the previous feedback to move away from something very close..
> 
> Dave, care to chime in here? As mentioned, I'll do a refactored v3 if
> there's some kind of consensus/agreement on a final approach.

I've read the thread on the original patch now.  While not my preference
I'm fine with doing an xfs_itruncate_extents_flags with a single
xfs_itruncate_extents wrapper and the same for bmapi, as long as we pass
flags instead of the bool, and don't add pointless wrappers for the
nodiscard case - those are just trickle down flags in general, so we
should keep things as simple as possible.
