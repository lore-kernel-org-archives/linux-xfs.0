Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Jun 2007 17:40:01 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l580dtWt011168
	for <xfs@oss.sgi.com>; Thu, 7 Jun 2007 17:39:57 -0700
Date: Fri, 8 Jun 2007 10:39:41 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] use filldir internally
Message-ID: <20070608003941.GN85884050@sgi.com>
References: <20070604143958.GB9081@lst.de> <20070607232716.GK85884050@sgi.com> <20070608002049.GM85884050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070608002049.GM85884050@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Fri, Jun 08, 2007 at 10:20:49AM +1000, David Chinner wrote:
> On Fri, Jun 08, 2007 at 09:27:16AM +1000, David Chinner wrote:
> > On Mon, Jun 04, 2007 at 04:39:58PM +0200, Christoph Hellwig wrote:
> > > Currently xfs has a rather complicated internal scheme to allow for
> > > different directory formats in IRIX.  This patch rips all code related
> > > to this out and pushes useage of the Linux filldir callback into the
> > > lowlevel directory code.  This does not make the code any less portable
> > > because filldir can be used to create dirents of all possible variations
> > > (including the IRIX ones as proved by the IRIX binary emulation code
> > > under arch/mips/).
> > > 
> > > This patch get rid of an unessecary copy in the readdir path, about
> > > 250 lines of code and one of the last two users of the uio structure.
> > 
> > Looks like a nice cleanup at a quick glance, but I need to spend more time
> > looking at it which I don't have right now. I'll add it to my QA in the
> > meantime....

Hmmmm, this breaks dmapi which calls xfs_get_dirents() directly and
that function was removed by this patch. I'm going to have to drop
this patch for the moment because I don't have time to fix it up....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
