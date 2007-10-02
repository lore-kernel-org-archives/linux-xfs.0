Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 02 Oct 2007 14:32:13 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l92LW4xX012421
	for <xfs@oss.sgi.com>; Tue, 2 Oct 2007 14:32:07 -0700
Date: Wed, 3 Oct 2007 07:31:53 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Creation time in XFS
Message-ID: <20071002213153.GI995458@sgi.com>
References: <200709302124.38164.Martin@lichtvoll.de> <470042DC.2040009@sgi.com> <p73ve9r6v3a.fsf@bingen.suse.de> <20071002092509.GF995458@sgi.com> <20071002093822.GA24907@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071002093822.GA24907@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, Andi Kleen <andi@firstfloor.org>, Timothy Shimmin <tes@sgi.com>, Martin Steigerwald <Martin@lichtvoll.de>, xfs@oss.sgi.com

On Tue, Oct 02, 2007 at 10:38:22AM +0100, Christoph Hellwig wrote:
> On Tue, Oct 02, 2007 at 07:25:10PM +1000, David Chinner wrote:
> > > I don't think it is at all currently:
> > 
> > So what is the point? Forensic analysis?
> 
> Windows wants it, so I guess they added when they had to bump the inode
> version anyway in preparation of a user interface for samba.

<groan>

Can you point me to whatever list this was discussed on? This
is exactly the sort of stuff that needs to be discussed on -fsdevel.

> We probably
> should do the same for XFS when bumping the inode version for the crcs.

Perhaps. I don't really like the idea of adding unused fields to
the on disk structure just in case it is needed in the future....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
