Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0B3147F37
	for <xfs@oss.sgi.com>; Thu, 27 Aug 2015 01:09:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F0C24304039
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 23:09:47 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id LlMeiD694U5bEEXG (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 26 Aug 2015 23:09:47 -0700 (PDT)
Date: Thu, 27 Aug 2015 14:09:44 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] xfs: return errors from partial I/O failures to files
Message-ID: <20150827060943.GX17933@dhcp-13-216.nay.redhat.com>
References: <20150826190636.GA16540@rage.redhat.com>
	<20150826221951.GE3902@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150826221951.GE3902@dastard>
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
Cc: David Jeffery <djeffery@redhat.com>, xfs@oss.sgi.com

On Thu, Aug 27, 2015 at 08:19:52AM +1000, Dave Chinner wrote:
> On Wed, Aug 26, 2015 at 03:06:36PM -0400, David Jeffery wrote:
> > There is an issue with xfs's error reporting in some cases of I/O partially
> > failing and partially succeeding. Calls like fsync() can report success even
> > though not all I/O was successful.
> 
> Hi David,
> 
> I read your bug report last night and after considering all the work
> you put into it, I was going to ask if you wanted to finish off the
> job by writing the patch to fix it. But you beat me to it.
> 
> Nice work! :)
> 
> > The issue can occur when there are multiple bio per xfs_ioend struct.
> > Each call to xfs_end_bio() for a bio completing will write a value to
> > ioend->io_error.  If a successful bio completes after any failed bio, no
> > error is reported do to it writing 0 over the error code set by any failed bio.
> > The I/O error information is now lost and when the ioend is completed
> > only success is reported back up the filesystem stack.
> 
> It's worth mentioning the case that this was seen in - a single
> failed disk in a raid 0 stripe, and the error from the bio to the
> failed disk was overwritten by the successes from the bios to the
> other disks.
> 
> FWIW, I think that we also need to create an xfstest for this case,
> too, because it's clear that this is a big hole in our test coverage
> (i.e.  partial block device failure). It might be best to talk to
> Eryu (cc'd) to get your reproducer converted into a xfstest case
> that we can then test all filesystems against?

Sure, I'll look into the reproducer and work on a fstests case.

Thanks,
Eryu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
