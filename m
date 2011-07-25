Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6PGwk1R014996 for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 11:58:46 -0500
Subject: Re: [PATCH 08/12] xfs: Remove the macro XFS_BUF_SET_PTR
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110725162513.GA2434@infradead.org>
References: <20110722003226.21069.58401.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110722003333.21069.32295.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<1311363510.2771.103.camel@doink>
	<20110724113543.GB26332@infradead.org>
	<1311609456.2914.24.camel@doink> <20110725162513.GA2434@infradead.org>
Date: Mon, 25 Jul 2011 11:58:42 -0500
Message-ID: <1311613122.2914.35.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, xfs@oss.sgi.com

On Mon, 2011-07-25 at 12:25 -0400, Christoph Hellwig wrote:
> On Mon, Jul 25, 2011 at 10:57:36AM -0500, Alex Elder wrote:
> > > Btw, nice follow-on cleanups would be to kill off the xfs_caddr_t and
> > > __psint_t/__psunsigned_t types entirely.
> > 
> > Yes.  What do you suggest to use for a pointer-sized
> > type?  Just cast to (long) and rely on the usual arithmetic
> > conversions to do the right thing?
> 
> The correct C99 type is (u)intptr_t.  In the kernel we only have
> uintptr_t, with ACPI defining a local version of intptr_t.  I'd suggest
> trying to stick to uintptr_t if we can, and if we really need a signed
> version add intptr_t to the common headers - it can unconditionally be
> typedef to long in Linux anyway.

I *knew* there was a standard type but I couldn't
remember what it was called.  I even scanned through
my C spec but gave up looking pretty quickly.  I
think I had "size" somehow stuck in my mind and that
didn't help.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
