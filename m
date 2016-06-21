Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 44F1D7CA1
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2016 15:09:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CCF01AC002
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2016 13:09:03 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id 4avL0mknIlHZLT9m (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 21 Jun 2016 13:09:00 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id BF48C20988
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2016 22:08:58 +0200 (CEST)
Date: Tue, 21 Jun 2016 22:07:34 +0200
From: Felix Janda <felix.janda@posteo.de>
Subject: Re: [PATCH 1/4] Remove off64_t from linux.h
Message-ID: <20160621200734.GA1151@nyan>
References: <20160618145238.GA17768@nyan> <20160620020414.GH26977@dastard>
	<20160620065348.GA431@nyan> <20160620231804.GK26977@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160620231804.GK26977@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave Chinner wrote:
> On Mon, Jun 20, 2016 at 08:53:48AM +0200, Felix Janda wrote:
> > Dave Chinner wrote:
> > 
> > Thanks for asking for clarification.
> > 
> > > On Sat, Jun 18, 2016 at 04:52:38PM +0200, Felix Janda wrote:
> > > > The off64_t type is usually only conditionally exposed under the
> > > > feature test macro _LARGEFILE64_SOURCE (also defined by _GNU_SOURCE).
> > > > To make the public xfs headers more standalone therefore off64_t should
> > > > be avoided.
> > > 
> > > "more standalone"?
> > > 
> > > What does that mean?
> > 
> > Programs including the xfs headers while not defining _GNU_SOURCE or
> > _LARGEFILE64_SOURCE will not fail with compile errors. My previous
> > patch changing loff_t to off64_t had the unintented consequences that
> > downstreams of xfs-progs like ceph had to define _LARGEFILE64_SOURCE
> > on linux.
> 
> That needs to be in the patch description - it's the motivation for
> the change (i.e. that downstream apps need to add new defines).

Sure.

> > > And what does it mean for all the xfsprogs code that still uses
> > > off64_t?
> > 
> > off_t and off64_t are now synomyms and 64 bit on all architectures.
> > So no difference for code using off64_t.
> > 
> > Under some conditions there can be a difference for code using
> > off_t.
> 
> Right, I understand that there is a difference - what I'm asking for
> is a description of the difference and an explanation of why:
> 
> $ git grep off64_t | wc -l
> 62
> $
> 
> the other ~60 uses of off64_t in the xfsprogs code are not being
> removed, too. i.e. if the code now won't compile if off_t isn't 64
> bits, then why keep off64_t at all in any of the code?

On 32bit systems using glibc the following changes happen:

1. off_t is now 64 bit instead of 32 bit
2. all functions and structures using off_t are mapped to versions
   using the 64 bit off_t

1. means that off_t and off64_t are now equivalents, whereas 2. means
that struct stat and struct stat64, open() and open64() and many others
become equivalent.

Because, in addition to off64_t, "64"-functions and structures are
used very consistently in the code I have hold off sending a patch
changing these. I recall also seeing in some commit messages that at
some sites off64_t was changed to int64_t (or __int64_t...) for header
portability; for these sites it might be nice to change back to off_t.

Grepping the code I found one occurence in fsr/xfs_fsr.c of off_t (not
off64_t) which will be affected by the change (on 32bit linux). Right
now the F_GETLK fcntl with the struct flock is used there instead of
F_GETLK64 with struct flock64. The current usage is ok because the
off_t arguments are only used for the value 0 which happily fits into
variables of any size. After the change, the fcntl F_GETLK64, struct
flock64 and off64_t will be used instead, leading to no visible change
in behavior.

Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
