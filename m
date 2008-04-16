Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 Apr 2008 23:37:17 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3G6apNH004038
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2008 23:36:55 -0700
Date: Wed, 16 Apr 2008 16:37:12 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] split xfs_ioc_xattr
Message-ID: <20080416063712.GN108924158@sgi.com>
References: <20080319204014.GA23644@lst.de> <ncciqylf7q0.fsf@sgi.com> <20080414032940.GA10579@lst.de> <ncclk3ejwam.fsf@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ncclk3ejwam.fsf@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@cxhome.ath.cx>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Wed, Apr 16, 2008 at 01:47:13PM +1000, Niv Sardi wrote:
> Christoph Hellwig <hch@lst.de> writes:
> 
> > On Mon, Apr 14, 2008 at 01:14:47PM +1000, Niv Sardi wrote:
> >> 
> >> 
> >> Christoph Hellwig <hch@lst.de> writes:
> >> > The three subcases of xfs_ioc_xattr don't share any semantics and almost
> >> > no code, so split it into three separate helpers.
> >> >
> >> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> >> 
> >> Looks good to me, aren't the likely() unlinkely() deprecated ? shouldn't
> >> they be killed ?
> >
> > Why would they be deprecated?
> 
> just an impression I had from on of Dave's comment to one of my patches:
> « Can we kill all the likely() crap out of here? Modern hardware
>   branch predictors are far better than static prediction hints. »

And the context which you haven't quoted? A repugnant hunk of code
with one broken use of likely() in two unnecessary 'if
(likely(!error) ...' branches, and 20 lines of my comment after the
above quote demonstrating of how to restructure it so it was neater,
faster and didn't need the prediction hints at all.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
