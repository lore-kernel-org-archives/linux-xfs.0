Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Mar 2008 02:18:14 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2C9HcBv026999
	for <xfs@oss.sgi.com>; Wed, 12 Mar 2008 02:17:42 -0700
Date: Wed, 12 Mar 2008 20:17:55 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: can I shrink an xfs?
Message-ID: <20080312091755.GQ155407@sgi.com>
References: <20080311172958.GA31833@apartia.fr> <20080311180210.GB5767@josefsipek.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080311180210.GB5767@josefsipek.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: xfs@oss.sgi.com, ruben.porras@linworks.de

On Tue, Mar 11, 2008 at 02:02:10PM -0400, Josef 'Jeff' Sipek wrote:
> On Tue, Mar 11, 2008 at 06:29:58PM +0100, Louis-David Mitterrand wrote:
> > Hi,
> > 
> > Is it possible to shrink an xfs? I tried using xfs_growfs to no avail.
>  
> There's no official/supported way to do it. There might be some tool to do
> it, but I'm not aware of any.
> 
> Dave, et. al.: why not support shrinking? I know, inode numbers and whatnot,
> but that's already being messed up (at least to a degree) with the noikeep
> mount option. I think that shrinking would be useful to have - even if you
> have to pass it --i-know-what-i-am-doing kind of option. Maybe a offline
> shrink via repair would be more viable?

It's being worked on - have a look in the achives at what Ruben Porras has
been doing (and the patches he recently sent). Shrinking involves a lot of
bits to come together sucessful, and we're slowly getting them together.
If you want to get it done faster - help Ruben ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
