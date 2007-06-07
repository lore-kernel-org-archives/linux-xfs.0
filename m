Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Jun 2007 05:49:27 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l57CnKWt003194
	for <xfs@oss.sgi.com>; Thu, 7 Jun 2007 05:49:23 -0700
Date: Thu, 7 Jun 2007 22:49:14 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: review: xfs_growfs_data_private() not logging agf length change
Message-ID: <20070607124914.GD85884050@sgi.com>
References: <4667ADAF.7000904@sgi.com> <20070607073034.GP86004887@sgi.com> <20070607121853.GA29442@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070607121853.GA29442@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, Tim Shimmin <tes@sgi.com>, xfs-dev@sgi.com, xfs@oss.sgi.com

On Thu, Jun 07, 2007 at 01:18:53PM +0100, Christoph Hellwig wrote:
> On Thu, Jun 07, 2007 at 05:30:34PM +1000, David Chinner wrote:
> > On Thu, Jun 07, 2007 at 05:03:11PM +1000, Tim Shimmin wrote:
> > > Looks like we forgot to log the agf_length change here.
> > > 
> > > (cut 'n' pasted patch)
> > > 
> > > --Tim
.....
> > 
> > Yup, looks ok to me.
> 
> Except for the whitespace damage, of course - but that might have been
> the cut & pasting.

The attached patch had no ws damage. ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
