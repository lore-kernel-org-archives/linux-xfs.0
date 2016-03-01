Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F0F3E7CB3
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 07:10:46 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B4010304032
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 05:10:43 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id roc79EqEHaPp5qdO (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 01 Mar 2016 05:10:42 -0800 (PST)
Date: Tue, 1 Mar 2016 08:10:39 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH RFC 1/3] xfs: debug mode forced buffered write failure
Message-ID: <20160301131039.GA22465@bfoster.bfoster>
References: <1456756170-51248-1-git-send-email-bfoster@redhat.com>
	<1456756170-51248-2-git-send-email-bfoster@redhat.com>
	<20160301125516.GB3540@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160301125516.GB3540@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Mar 01, 2016 at 04:55:16AM -0800, Christoph Hellwig wrote:
> On Mon, Feb 29, 2016 at 09:29:28AM -0500, Brian Foster wrote:
> > Add a DEBUG mode-only sysfs knob to enable forced buffered write
> > failure. An additional side effect of this mode is brute force killing
> > of delayed allocation blocks in the range of the write. The latter is
> > the prime motiviation behind this patch, as userspace test
> > infrastructure requires a reliable mechanism to create and split
> > delalloc extents without causing extent conversion.
> > 
> > Certain fallocate operations (i.e., zero range) were used for this in
> > the past, but the implementations have changed such that delalloc
> > extents are flushed and converted to real blocks, rendering the test
> > useless.
> 
> Looks harmless, but I'd add a inline function to check for the failed
> writes field so that we can compile it away entirely for !DEBUG builds.

Good idea. The thought of burying this further down in get_blocks or
somewhere around there has also crossed my mind since sending this, so
I'll look into that as well. I'm mainly just curious whether it helps
isolate the necessary changes any better than the current form...

Brian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
