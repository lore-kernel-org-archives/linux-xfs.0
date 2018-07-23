Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38680 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387801AbeGWNMj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jul 2018 09:12:39 -0400
Received: by mail-wr1-f68.google.com with SMTP id v14-v6so470755wro.5
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jul 2018 05:11:44 -0700 (PDT)
Date: Mon, 23 Jul 2018 14:11:40 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 5/6] xfs: maintain a sequence count for inode fork
 manipulations
Message-ID: <20180723121140.lpcjgdpyasop2744@odin.usersys.redhat.com>
References: <20180717232405.18511-1-hch@lst.de>
 <20180717232405.18511-6-hch@lst.de>
 <20180718144004.bvvrssvtcpd2b2uw@odin.usersys.redhat.com>
 <20180719163233.GA24047@lst.de>
 <20180719182715.GL4813@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180719182715.GL4813@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, Jul 19, 2018 at 11:27:16AM -0700, Darrick J. Wong wrote:
> On Thu, Jul 19, 2018 at 06:32:33PM +0200, Christoph Hellwig wrote:
> > On Wed, Jul 18, 2018 at 04:40:04PM +0200, Carlos Maiolino wrote:
> > > 
> > > 
> > > >  struct xfs_ifork {
> > > >  	int			if_bytes;	/* bytes in if_u1 */
> > > > +	unsigned int		if_seq;
> > > 
> > > I wonder if a comment here wouldn't be helpful in the future, like: /* ext list modification counter */
> > 
> > Does that really add more value?  If so I'm happy having it added
> > when applying.
> 

For me at least it adds, IMHO, it's simpler to see a small comment in the struct
definition other than search what exactly it's supposed to mean in the
implementation, but well, this is my view.

> Seeing as we have anecdotal evidence that more work will be needed if we
> ever want to use it to track change count in the data fork, I think I'll
> add the following comment:
> 
> 	unsigned int		if_seq;		/* cow fork mod count */
>

/me didn't understand, but *shurg*
 
> --D
> 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
