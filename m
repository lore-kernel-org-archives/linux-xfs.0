Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 503387F37
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 19:28:30 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 36E4B304066
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 17:28:29 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	DvCfqgsFPIKyCBVj for <xfs@oss.sgi.com>;
	Thu, 28 Nov 2013 17:28:26 -0800 (PST)
Date: Fri, 29 Nov 2013 12:28:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Problem with mkfs.xfs on a regular file
Message-ID: <20131129012822.GT10988@dastard>
References: <20131127023119.GB13101@boogeyman> <20131127024713.GE10988@dastard>
	<5296ACFB.4030901@sandeen.net> <20131128051626.GM10988@dastard>
	<5296D5EB.2080008@sandeen.net> <20131128100107.GN10988@dastard>
	<52976210.5070804@sandeen.net> <20131128211213.GP10988@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131128211213.GP10988@dastard>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Phil White <cerise-xfs@l.armory.com>, xfs@oss.sgi.com

On Fri, Nov 29, 2013 at 08:12:13AM +1100, Dave Chinner wrote:
> On Thu, Nov 28, 2013 at 09:32:32AM -0600, Eric Sandeen wrote:
> > On 11/28/13, 4:01 AM, Dave Chinner wrote:
> > > On Wed, Nov 27, 2013 at 11:34:35PM -0600, Eric Sandeen wrote:
> > 
> > <snip>
> > 
> > >> Or maybe just stat() it, and DTRT?
> > > 
> > > Well, we need to stat it to make sure that it's a file if "-d file"
> > > is specified, and a block device if it's not. That will prevent this
> > > problem.  Every other xfsprogs utility has to be told that it is
> > > being pointed at an image file rather than a block device, so why
> > > should mkfs be any different?
> > 
> > The option is there but again I never really knew why.  They work
> > fine without -f, at least in general:
> 
> Just like mkfs works fine, *in general*. That doesn't mean they will always
> work, though:

FYI, here's the list of stuff on top of making mkfs detect files and
set the proper flags and avoid direct IO that I found while doing
this:

Other file/blockdev issues fixed:
        - use getstr to detect specifying the data device name
          twice.
        - check file/size/name parameters before anything else.
        - overwrite checks need to be done before the image file is
          opened and potentially truncated.
        - blkid_get_topology() should not be called for image files,
          so warn when it is called that way.
        - zero_old_xfs_structures() emits a spurious error:
                "existing superblock read failed: Success"
          when it is run on a truncated image file. Don't warn if we
          see this problem on an image file.
        - Don't issue discards on image files.
        - Use fsync() for image files, not BLKFLSBUF in
          platform_flush_device() for Linux.

And so now "-d file" is only needed to trigger creation of the
image file, or if you want to truncate the old file away completely
first...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
