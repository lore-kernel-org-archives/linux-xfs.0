Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27377 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752917AbdICPgE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2017 11:36:04 -0400
Date: Sun, 3 Sep 2017 08:35:25 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] mkfs: pass a custom cowextsize into the created
 filesystem
Message-ID: <20170903153525.GF4073@magnolia>
References: <20170901164035.GF3775@magnolia>
 <20170903083857.GB32385@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170903083857.GB32385@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Sun, Sep 03, 2017 at 01:38:57AM -0700, Christoph Hellwig wrote:
> On Fri, Sep 01, 2017 at 09:40:35AM -0700, Darrick J. Wong wrote:
> > Create a -d option to mkfs.xfs that enables administrators to set
> > the CoW extent size hint on the created files.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  libxfs/util.c       |   26 ++++++++++++++++++++++++--
> >  man/man8/mkfs.xfs.8 |    7 +++++++
> >  mkfs/xfs_mkfs.c     |   20 ++++++++++++++++++++
> >  3 files changed, 51 insertions(+), 2 deletions(-)
> > 
> > diff --git a/libxfs/util.c b/libxfs/util.c
> > index 0e2f29e..4f82d7f 100644
> > --- a/libxfs/util.c
> > +++ b/libxfs/util.c
> > @@ -175,6 +175,26 @@ libxfs_trans_ichgtime(
> >  	}
> >  }
> >  
> > +static inline uint16_t
> > +xflags_to_diflags(
> > +	__u32		xflags)
> > +{
> > +	/* bottom 15 xflag bits correspond to diflag bits */
> > +	return xflags & 0x7FFF;
> 
> Do we really want to rely on that fact?
> 
> > +}
> > +
> > +static inline uint64_t
> > +xflags_to_diflags2(
> > +	__u32		xflags)
> > +{
> > +	uint64_t	ret = 0;
> > +
> > +	if (xflags & FS_XFLAG_COWEXTSIZE)
> > +		ret |= XFS_DIFLAG2_COWEXTSIZE;
> > +
> > +	return ret;
> > +}
> 
> It seems like we should just lift the kernels xfs_flags2diflags and
> xfs_flags2diflags2 to libxfs and use them here?

Once that they exist upstream, sure! :)

--D

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
