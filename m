Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 27 Jun 2008 06:02:47 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5RD2iGG004575
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 06:02:44 -0700
Date: Fri, 27 Jun 2008 09:03:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Move xfs_attr_rolltrans to xfs_trans_roll
Message-ID: <20080627130344.GA1327@infradead.org>
References: <1214196150-5427-1-git-send-email-xaiki@sgi.com> <1214196150-5427-2-git-send-email-xaiki@sgi.com> <1214196150-5427-3-git-send-email-xaiki@sgi.com> <20080626082827.GC23954@infradead.org> <ncctzff1o7e.fsf@sgi.com> <20080627130310.GA4659@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627130310.GA4659@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

But this isn't actually the patch described by the subject..

On Fri, Jun 27, 2008 at 09:03:10AM -0400, Christoph Hellwig wrote:
> Looks good except for a tiny nitpick:
> 
> > +/*
> > + * Calculate how many blocks we need for the new attribute,
> > + */
> > +int
> > +xfs_attr_calc_size(
> > +	struct xfs_inode *ip,
> > +	int		namelen,
> > +	int		valuelen,
> > +	int		*local)
> > +{
> > +	struct xfs_mount *mp = ip->i_mount;
> 
> Add another tab before the variable names so that it aligns nicely.
