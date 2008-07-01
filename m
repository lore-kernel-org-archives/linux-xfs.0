Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Jul 2008 08:48:57 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m61FmtS3014919
	for <xfs@oss.sgi.com>; Tue, 1 Jul 2008 08:48:55 -0700
Date: Tue, 1 Jul 2008 11:49:46 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH] Give a transaction to xfs_attr_set_int
Message-ID: <20080701154946.GB20383@josefsipek.net>
References: <1214196150-5427-1-git-send-email-xaiki@sgi.com> <1214196150-5427-2-git-send-email-xaiki@sgi.com> <1214196150-5427-3-git-send-email-xaiki@sgi.com> <1214196150-5427-4-git-send-email-xaiki@sgi.com> <1214196150-5427-5-git-send-email-xaiki@sgi.com> <20080629220859.GL29319@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080629220859.GL29319@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>, xfs@oss.sgi.com, Niv Sardi <xaiki@debian.org>

On Mon, Jun 30, 2008 at 08:08:59AM +1000, Dave Chinner wrote:
...
> > @@ -356,6 +381,8 @@ xfs_attr_set_int(xfs_inode_t *dp, const char *name, int namelen,
> >  			if (!error && (flags & ATTR_KERNOTIME) == 0) {
> >  				xfs_ichgtime(dp, XFS_ICHGTIME_CHG);
> >  			}
> > +			if (tpp)
> > +				tpp = &args.trans;
> 
> That's busted too. Can you please review all the places where you
> return transactio pointers to the caller via a function parameterrr
> for this bug as you've made in at least a couple of places.

Niv: Why not return the pointer as a return value?

Josef 'Jeff' Sipek.

-- 
Humans were created by water to transport it upward.
