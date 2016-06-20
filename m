Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EBB037CA1
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 01:55:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 79A12AC001
	for <xfs@oss.sgi.com>; Sun, 19 Jun 2016 23:55:14 -0700 (PDT)
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65]) by
	cuda.sgi.com with ESMTP id hS2wdU1wBbkcxW7o (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 19 Jun 2016 23:55:08 -0700 (PDT)
Received: from dovecot03.posteo.de (dovecot03.posteo.de [172.16.0.13])
	by mout01.posteo.de (Postfix) with ESMTPS id 9F2C220C5A
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 08:55:05 +0200 (CEST)
Date: Mon, 20 Jun 2016 08:53:48 +0200
From: Felix Janda <felix.janda@posteo.de>
Subject: Re: [PATCH 1/4] Remove off64_t from linux.h
Message-ID: <20160620065348.GA431@nyan>
References: <20160618145238.GA17768@nyan>
 <20160620020414.GH26977@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160620020414.GH26977@dastard>
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

Thanks for asking for clarification.

> On Sat, Jun 18, 2016 at 04:52:38PM +0200, Felix Janda wrote:
> > The off64_t type is usually only conditionally exposed under the
> > feature test macro _LARGEFILE64_SOURCE (also defined by _GNU_SOURCE).
> > To make the public xfs headers more standalone therefore off64_t should
> > be avoided.
> 
> "more standalone"?
> 
> What does that mean?

Programs including the xfs headers while not defining _GNU_SOURCE or
_LARGEFILE64_SOURCE will not fail with compile errors. My previous
patch changing loff_t to off64_t had the unintented consequences that
downstreams of xfs-progs like ceph had to define _LARGEFILE64_SOURCE
on linux.

> And what does it mean for all the xfsprogs code that still uses
> off64_t?

off_t and off64_t are now synomyms and 64 bit on all architectures.
So no difference for code using off64_t.

Under some conditions there can be a difference for code using
off_t.

> i.e. if you are going to make xfsprogs fail to compile on configs
> that don't define off64_t, then it makes no sense to leave all the
> users of off64_t in the xfsprogs code....

On all supported systems except for current default linux (glibc)
configurations either there does not exist off64_t or it is the same
as off_t. The configure test will define _FILE_OFFSET_BITS=64 on linux
systems (i.e. enabling transparent large file support) with the result
that now even on linux off_t is 64 bit wide in all cases.

The "assert" ensures that programs using the xfs headers do not
compile when the expectation sizeof(off_t)=8 is not met. This makes
programs on 32 bit linux systems using the xfs headers but not
defining _FILE_OFFSET_BITS=64 not compile. I would consider this as
beneficial because such programs easily can have bugs regarding
support of files of size >2GB on 32 bit systems.

Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
