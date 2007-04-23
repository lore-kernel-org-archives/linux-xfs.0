Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Apr 2007 16:13:54 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3NNDnfB021234
	for <xfs@oss.sgi.com>; Mon, 23 Apr 2007 16:13:51 -0700
Date: Tue, 24 Apr 2007 09:13:37 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: review: don't block non-blocking writes when frozen
Message-ID: <20070423231337.GN32602149@melbourne.sgi.com>
References: <20070423002616.GY32602149@melbourne.sgi.com> <20070423212715.GF13572@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423212715.GF13572@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, gnb@sgi.com, xfs-oss <xfs@oss.sgi.com>, nfs@lists.sourceforge.net

On Mon, Apr 23, 2007 at 10:27:15PM +0100, Christoph Hellwig wrote:
> On Mon, Apr 23, 2007 at 10:26:16AM +1000, David Chinner wrote:
> > 
> > Prevent nfsds for blocking trying to write to a frozen filesystem
> > or a filesystem in the process of freezing.
> 
> Looks good for trees actually having support for non-blocking file
> I/O, which doesn't include mainline.  (So please don't send this
> upstead)

Yeah - you NACKed that a year ago based on the fact it would never
get used by mainline code:

http://marc.info/?l=linux-nfs&m=114683005119982&w=2

So, given the catch-22 you've just presented us can we revisit the
nfsd non-blocking I/O issue again?  This affects anyone using DM
snapshots on their NFS servers and has nothing to do with HSMs
or DMAPI...

FWIW, you can still do non-blocking userspace I/O to a file, so this
XFS patch is still valid for mainline (that's how I tested it).

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
