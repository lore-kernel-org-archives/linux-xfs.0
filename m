Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 11 Jul 2007 01:06:06 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6B85xbm009430
	for <xfs@oss.sgi.com>; Wed, 11 Jul 2007 01:06:01 -0700
Date: Wed, 11 Jul 2007 18:05:55 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: REVIEW: fix xfs_bmap -vp confusion
Message-ID: <20070711080555.GS12413810@sgi.com>
References: <op.tu954us03jf8g2@pc-bnaujok.melbourne.sgi.com> <20070711055347.GP12413810@sgi.com> <op.tvads3bs3jf8g2@pc-bnaujok.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.tvads3bs3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: David Chinner <dgc@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Wed, Jul 11, 2007 at 04:04:05PM +1000, Barry Naujok wrote:
> On Wed, 11 Jul 2007 15:53:47 +1000, David Chinner <dgc@sgi.com> wrote:
> 
> >On Wed, Jul 11, 2007 at 01:18:20PM +1000, Barry Naujok wrote:
> >>If xfs_bmap -vp is run on a file without unwritten extents
> >>and the filesystem does not use sunit/swidth, the FLAGS
> >>column is not shown. This leads to some confusion.
> >>
> >>So, when -vp option is used, it will always print the
> >>FLAGS column.
> >
> >I note that it only prints the legend if a flag is set. I guess
> >this is ok, but maybe it would be more consistent to always
> >print the legend? Or even to make the legend optional (which
> >would make dumping more than one file more compact)?
> >
> >Cheers,
> >
> >Dave.
> 
> The legend* is only shown with an extra -v option and the FLAGS
> column displayed.

Ah, that'd be the > 1 check.

Looks good then....

> The updated man pages posted out yesterday documents this.

I haven't had time to read them yet.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
