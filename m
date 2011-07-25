Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6PGPJtI011519 for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 11:25:19 -0500
Date: Mon, 25 Jul 2011 12:25:13 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/12] xfs: Remove the macro XFS_BUF_SET_PTR
Message-ID: <20110725162513.GA2434@infradead.org>
References: <20110722003226.21069.58401.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110722003333.21069.32295.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<1311363510.2771.103.camel@doink>
	<20110724113543.GB26332@infradead.org>
	<1311609456.2914.24.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1311609456.2914.24.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Chandra Seetharaman <sekharan@us.ibm.com>, xfs@oss.sgi.com

On Mon, Jul 25, 2011 at 10:57:36AM -0500, Alex Elder wrote:
> > Btw, nice follow-on cleanups would be to kill off the xfs_caddr_t and
> > __psint_t/__psunsigned_t types entirely.
> 
> Yes.  What do you suggest to use for a pointer-sized
> type?  Just cast to (long) and rely on the usual arithmetic
> conversions to do the right thing?

The correct C99 type is (u)intptr_t.  In the kernel we only have
uintptr_t, with ACPI defining a local version of intptr_t.  I'd suggest
trying to stick to uintptr_t if we can, and if we really need a signed
version add intptr_t to the common headers - it can unconditionally be
typedef to long in Linux anyway.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
