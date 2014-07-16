Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 52E987FD3
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 17:31:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 349EF8F8035
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 15:31:54 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	j2KLA0VCzVgKzCFr for <xfs@oss.sgi.com>;
	Wed, 16 Jul 2014 15:31:52 -0700 (PDT)
Date: Thu, 17 Jul 2014 08:31:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: v0.80.4 Firefly released
Message-ID: <20140716223150.GE4453@dastard>
References: <alpine.DEB.2.00.1407151634250.21336@cobra.newdream.net>
	<20140716092226.GA23561@infradead.org>
	<CAPYLRziqpnjHbViaFw2MtXcYKiCDE9wz8qaqiQjAJGDoUbG7cg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPYLRziqpnjHbViaFw2MtXcYKiCDE9wz8qaqiQjAJGDoUbG7cg@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Gregory Farnum <gregory.farnum@dreamhost.com>
Cc: Christoph Hellwig <hch@infradead.org>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, Sage Weil <sage@inktank.com>, Samuel Just <sam.just@inktank.com>, xfs@oss.sgi.com

On Wed, Jul 16, 2014 at 10:26:23AM -0700, Gregory Farnum wrote:
> On Wed, Jul 16, 2014 at 2:22 AM, Christoph Hellwig <hch@infradead.org> wrote:
> > On Tue, Jul 15, 2014 at 04:45:59PM -0700, Sage Weil wrote:
> >> This Firefly point release fixes an potential data corruption problem
> >> when ceph-osd daemons run on top of XFS and service Firefly librbd
> >> clients.  A recently added allocation hint that RBD utilizes triggers
> >> an XFS bug on some kernels (Linux 3.2, and likely others) that leads
> >> to data corruption and deep-scrub errors (and inconsistent PGs).  This
> >> release avoids the situation by disabling the allocation hint until we
> >> can validate which kernels are affected and/or are known to be safe to
> >> use the hint on.
> >
> > I've not really seen an report for that on the XFS list, could it be
> > that you're running into the issue fixed by
> >
> >  "xfs: Use preallocation for inodes with extsz hints"
> >
> > (commit aff3a9edb7080f69f07fe76a8bd089b3dfa4cb5d)?
> 
> Sam reported the issue we're seeing in "consequences of
> XFS_IOC_FSSETXATTR on non-empty file?",

Assuming you've created an extent size hint with a file with delayed
allocation on it and no blocks, then that's more than likely the
same issue. The above commit uses preallocation to allocate
unwritten extents rather than delayed allocation for files with
extent size hints because delayed allocation doesn't write zeros
over ranges in the allocated extents that don't have dirty data over
them.

Moral of the story: any time you get what appears to be data
corruption in the underlying data store, you should report it to the
relevant filesystem list rather than try to work around it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
