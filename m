Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34289 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731661AbeGSRNk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Jul 2018 13:13:40 -0400
Date: Thu, 19 Jul 2018 18:32:33 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/6] xfs: maintain a sequence count for inode fork
        manipulations
Message-ID: <20180719163233.GA24047@lst.de>
References: <20180717232405.18511-1-hch@lst.de> <20180717232405.18511-6-hch@lst.de> <20180718144004.bvvrssvtcpd2b2uw@odin.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180718144004.bvvrssvtcpd2b2uw@odin.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, Jul 18, 2018 at 04:40:04PM +0200, Carlos Maiolino wrote:
> 
> 
> >  struct xfs_ifork {
> >  	int			if_bytes;	/* bytes in if_u1 */
> > +	unsigned int		if_seq;
> 
> I wonder if a comment here wouldn't be helpful in the future, like: /* ext list modification counter */

Does that really add more value?  If so I'm happy having it added
when applying.
