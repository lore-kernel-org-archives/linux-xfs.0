Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1EA5E7F7B
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2015 04:19:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ABF13AC006
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2015 02:19:56 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Dcerl7BqG2KJhaET (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 19 Aug 2015 02:19:37 -0700 (PDT)
Date: Wed, 19 Aug 2015 02:19:36 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/11] xfsprogs: missing and dummy calls for OS X support
Message-ID: <20150819091936.GA12804@infradead.org>
References: <1439828606-7886-1-git-send-email-jtulak@redhat.com>
	<1439828606-7886-6-git-send-email-jtulak@redhat.com>
	<20150818214557.GC3902@dastard>
	<20150819080940.GA13130@infradead.org>
	<CACj3i71T77Hov5PyAfgGGmh3Ga4Q8Rk67sZ7yxVWtOYYUaEQYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACj3i71T77Hov5PyAfgGGmh3Ga4Q8Rk67sZ7yxVWtOYYUaEQYQ@mail.gmail.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On Wed, Aug 19, 2015 at 11:14:42AM +0200, Jan Tulak wrote:
> I proposed dropping some tools earlier, but there was a valid point about
> the possibility to break something when not even trying to compile it.
> i.e. with the XATTR_ -> XFS_XATTR mentioned in the first reply to this patch
> (which I already moved to a separate patch), it is necessary to add
> 
> #include "xfs/xfs_arch.h"
> #include "xfs/xfs_format.h"
> 
> into libhandle/handle.c. But

I think we'll need another define for libhandle - it's at least
in theory supposed to be a somewhat generic library.  In fact using
the existing XATTR_ values sort of makes sense for libattr, so I'd
say define a LIBHANDE_ version as well.

> So I think
> ??? ???
> it is better to have "bad dummy stuff" than not compile it
> at all

In general yes, for fsr I don't think so.  One is the pure amount
of broken stubs it would need, the second is that fsr is the only
program that requires a _mounted_ XFS file system anyway.  Most other
programs just use the on disk format, or in case of xfs_io are useful
for any file system.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
