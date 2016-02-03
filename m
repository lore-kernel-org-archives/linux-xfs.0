Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F1D637CA1
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 17:13:10 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DFDF1304039
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 15:13:10 -0800 (PST)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20]) by
	cuda.sgi.com with ESMTP id CqXXsdg6SzezdjcI for
	<xfs@oss.sgi.com>; Wed, 03 Feb 2016 15:13:10 -0800 (PST)
Date: Wed, 3 Feb 2016 16:12:59 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: real-time device warning
Message-ID: <20160203231259.GA5137@linux.intel.com>
References: <20160203165031.GB29275@linux.intel.com>
	<20160203215555.GF459@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160203215555.GF459@dastard>
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
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, xfs@oss.sgi.com

On Thu, Feb 04, 2016 at 08:55:55AM +1100, Dave Chinner wrote:
> On Wed, Feb 03, 2016 at 09:50:31AM -0700, Ross Zwisler wrote:
> > I've been doing some more real-time device testing with XFS, and I was able to
> > get past the BUG I reported here:
> > 
> > http://www.spinics.net/lists/xfs/msg37445.html
> > 
> > by setting CONFIG_XFS_DEBUG=n as Dave suggested.
> > 
> > After that I/O seems to work, although it doesn't look like the DAX mount
> > option is applied to I/Os that go to the real-time device.
> > 
> > After the first I/O, though, the following warning is hit:
> > 
> > [  413.086897] XFS (ram1): _xfs_buf_ioapply: no ops on block 0xa0/0x8
> 
> This series:
> 
> http://oss.sgi.com/archives/xfs/2016-02/msg00017.html

Ah, I wasn't aware of that work.  Can you please CC me next time so I can give
you a Tested-by?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
