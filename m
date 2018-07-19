Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:42130 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732030AbeGSTLm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jul 2018 15:11:42 -0400
Date: Thu, 19 Jul 2018 11:27:16 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/6] xfs: maintain a sequence count for inode fork
 manipulations
Message-ID: <20180719182715.GL4813@magnolia>
References: <20180717232405.18511-1-hch@lst.de>
 <20180717232405.18511-6-hch@lst.de>
 <20180718144004.bvvrssvtcpd2b2uw@odin.usersys.redhat.com>
 <20180719163233.GA24047@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180719163233.GA24047@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 19, 2018 at 06:32:33PM +0200, Christoph Hellwig wrote:
> On Wed, Jul 18, 2018 at 04:40:04PM +0200, Carlos Maiolino wrote:
> > 
> > 
> > >  struct xfs_ifork {
> > >  	int			if_bytes;	/* bytes in if_u1 */
> > > +	unsigned int		if_seq;
> > 
> > I wonder if a comment here wouldn't be helpful in the future, like: /* ext list modification counter */
> 
> Does that really add more value?  If so I'm happy having it added
> when applying.

Seeing as we have anecdotal evidence that more work will be needed if we
ever want to use it to track change count in the data fork, I think I'll
add the following comment:

	unsigned int		if_seq;		/* cow fork mod count */

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
