Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 Nov 2007 21:09:35 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAU59Nqc014183
	for <linux-xfs@oss.sgi.com>; Thu, 29 Nov 2007 21:09:25 -0800
Date: Fri, 30 Nov 2007 15:58:08 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS performance problems on Linux x86_64
Message-ID: <20071130045808.GK119954183@sgi.com>
References: <474C8A05.3020604@e-626.net> <20071127220536.GL119954183@sgi.com> <fii8bm$6h5$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fii8bm$6h5$1@ger.gmane.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bernd Schubert <bernd-schubert@gmx.de>
Cc: linux-xfs@oss.sgi.com

On Wed, Nov 28, 2007 at 12:13:57AM +0100, Bernd Schubert wrote:
> Hello David,
> 
> David Chinner wrote:
> > 
> > # mkfs.xfs -f -l lazy-count=1,version=2,size=128m -i attr=2 -d agcount=4
> > # <dev> mount -o logbsize=256k <dev> <mtpt>
> 
> thanks, I was also going to ask which are optimal parameters. Just didn't
> have the time yet :)
> Any idea when these options will be default? 

They should already be the defaults in the current CVS tree. ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
