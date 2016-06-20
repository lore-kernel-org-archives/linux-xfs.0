Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3C6F57CA0
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 18:19:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AB8A6AC004
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 16:18:59 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	jPCZPzcAwZGKqdDN for <xfs@oss.sgi.com>;
	Mon, 20 Jun 2016 16:18:30 -0700 (PDT)
Date: Tue, 21 Jun 2016 09:18:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] Remove off64_t from linux.h
Message-ID: <20160620231804.GK26977@dastard>
References: <20160618145238.GA17768@nyan> <20160620020414.GH26977@dastard>
	<20160620065348.GA431@nyan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160620065348.GA431@nyan>
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
To: Felix Janda <felix.janda@posteo.de>
Cc: xfs@oss.sgi.com

On Mon, Jun 20, 2016 at 08:53:48AM +0200, Felix Janda wrote:
> Dave Chinner wrote:
> 
> Thanks for asking for clarification.
> 
> > On Sat, Jun 18, 2016 at 04:52:38PM +0200, Felix Janda wrote:
> > > The off64_t type is usually only conditionally exposed under the
> > > feature test macro _LARGEFILE64_SOURCE (also defined by _GNU_SOURCE).
> > > To make the public xfs headers more standalone therefore off64_t should
> > > be avoided.
> > 
> > "more standalone"?
> > 
> > What does that mean?
> 
> Programs including the xfs headers while not defining _GNU_SOURCE or
> _LARGEFILE64_SOURCE will not fail with compile errors. My previous
> patch changing loff_t to off64_t had the unintented consequences that
> downstreams of xfs-progs like ceph had to define _LARGEFILE64_SOURCE
> on linux.

That needs to be in the patch description - it's the motivation for
the change (i.e. that downstream apps need to add new defines).

> > And what does it mean for all the xfsprogs code that still uses
> > off64_t?
> 
> off_t and off64_t are now synomyms and 64 bit on all architectures.
> So no difference for code using off64_t.
> 
> Under some conditions there can be a difference for code using
> off_t.

Right, I understand that there is a difference - what I'm asking for
is a description of the difference and an explanation of why:

$ git grep off64_t | wc -l
62
$

the other ~60 uses of off64_t in the xfsprogs code are not being
removed, too. i.e. if the code now won't compile if off_t isn't 64
bits, then why keep off64_t at all in any of the code?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
