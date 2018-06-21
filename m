Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:53436 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933393AbeFUWzd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jun 2018 18:55:33 -0400
Date: Thu, 21 Jun 2018 15:55:08 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] xfs: transactionless xfs_bunmapi shouldn't do format
 conversion
Message-ID: <20180621225508.GL4838@magnolia>
References: <20180619024128.22669-1-david@fromorbit.com>
 <20180619024128.22669-2-david@fromorbit.com>
 <20180619045405.GI8128@magnolia>
 <20180620073142.GA5257@infradead.org>
 <20180621223406.GV19934@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180621223406.GV19934@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Fri, Jun 22, 2018 at 08:34:06AM +1000, Dave Chinner wrote:
> On Wed, Jun 20, 2018 at 12:31:42AM -0700, Christoph Hellwig wrote:
> > On Mon, Jun 18, 2018 at 09:54:05PM -0700, Darrick J. Wong wrote:
> > > ...it's also weird that xfs_bmap_punch_delalloc_range calls xfs_bunmapi
> > > with no transaction and a xfs_defer that we dump on the ground.
> > > 
> > > So yes, I think the patch does fix the crash, but it's kinda gross.
> > > 
> > > Thoughts?
> > 
> > I've got an alternative solution:
> > 
> > http://git.infradead.org/users/hch/xfs.git/commitdiff/a1c0685b2085b448cbe02f0f9ff0c8771e3f4496
> > 
> > The only bit that is missing is removing the now unused support for
> > a NULL tp in __xfs_bunmapi..
> 
> Ah, I forgot about that patch. Thanks for the reminder, Christoph!
> 
> Darrick, can we get Christoph's patch in as a standalone bug fix
> rather than wait for the bufferhead removal to be merged?

Ok, will do.  AFAICT if I merge that patch then I can drop this one,
right?

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
