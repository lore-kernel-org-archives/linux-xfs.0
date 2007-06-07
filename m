Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Jun 2007 05:34:48 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l57CYiWt031174
	for <xfs@oss.sgi.com>; Thu, 7 Jun 2007 05:34:46 -0700
Date: Thu, 7 Jun 2007 13:18:53 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: review: xfs_growfs_data_private() not logging agf length change
Message-ID: <20070607121853.GA29442@infradead.org>
References: <4667ADAF.7000904@sgi.com> <20070607073034.GP86004887@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070607073034.GP86004887@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Tim Shimmin <tes@sgi.com>, xfs-dev@sgi.com, xfs@oss.sgi.com

On Thu, Jun 07, 2007 at 05:30:34PM +1000, David Chinner wrote:
> On Thu, Jun 07, 2007 at 05:03:11PM +1000, Tim Shimmin wrote:
> > Looks like we forgot to log the agf_length change here.
> > 
> > (cut 'n' pasted patch)
> > 
> > --Tim
> > 
> > ===========================================================================
> > Index: fs/xfs/xfs_fsops.c
> > ===========================================================================
> > 
> > --- a/fs/xfs/xfs_fsops.c    2007-04-17 18:02:46.000000000 +1000
> > +++ b/fs/xfs/xfs_fsops.c    2007-04-17 17:59:44.467987572 +1000
> > @@ -328,6 +328,7 @@ xfs_growfs_data_private(
> >         be32_add(&agf->agf_length, new);
> >         ASSERT(be32_to_cpu(agf->agf_length) ==
> >                be32_to_cpu(agi->agi_length));
> > +        xfs_alloc_log_agf(tp, bp, XFS_AGF_LENGTH);
> >         /*
> >          * Free the new space.
> >          */
> 
> Yup, looks ok to me.

Except for the whitespace damage, of course - but that might have been
the cut & pasting.
