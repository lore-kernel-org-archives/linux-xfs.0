Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 02C607F37
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 15:12:23 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D08CC304048
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 13:12:22 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	zcBdHZiGaXcDU2S2 for <xfs@oss.sgi.com>;
	Thu, 28 Nov 2013 13:12:18 -0800 (PST)
Date: Fri, 29 Nov 2013 08:12:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Problem with mkfs.xfs on a regular file
Message-ID: <20131128211213.GP10988@dastard>
References: <20131127023119.GB13101@boogeyman> <20131127024713.GE10988@dastard>
	<5296ACFB.4030901@sandeen.net> <20131128051626.GM10988@dastard>
	<5296D5EB.2080008@sandeen.net> <20131128100107.GN10988@dastard>
	<52976210.5070804@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52976210.5070804@sandeen.net>
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

On Thu, Nov 28, 2013 at 09:32:32AM -0600, Eric Sandeen wrote:
> On 11/28/13, 4:01 AM, Dave Chinner wrote:
> > On Wed, Nov 27, 2013 at 11:34:35PM -0600, Eric Sandeen wrote:
> 
> <snip>
> 
> >> Or maybe just stat() it, and DTRT?
> > 
> > Well, we need to stat it to make sure that it's a file if "-d file"
> > is specified, and a block device if it's not. That will prevent this
> > problem.  Every other xfsprogs utility has to be told that it is
> > being pointed at an image file rather than a block device, so why
> > should mkfs be any different?
> 
> The option is there but again I never really knew why.  They work
> fine without -f, at least in general:

Just like mkfs works fine, *in general*. That doesn't mean they will always
work, though:

$ sudo xfs_repair -n /storage/broken.img 
Phase 1 - find and verify superblock...
xfs_repair: read failed: Invalid argument

Repair fails on the file which has a smaller sector size than the
host filesystem, unless you tell it is working on a file, not a
block device:

$ sudo xfs_repair -n -f /storage/broken.img 
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
would have corrected attribute entry count in inode 649642 from 40 to 0
local inode 649790 attr too small (size = 1, min size = 4)
bad attribute fork in inode 649790, would clear attr fork
would have cleared inode 649790
....

And so behaviour is identical to mkfs...

>         - scan filesystem freespace and inode maps...
> ...
> 
> $ xfs_metadump fsfile fsfile.meta
> 
> $ file fsfile.meta
> fsfile.meta: XFS filesystem metadump image
> 
> etc
> 
> > Indeed, if we don't require users to tell mkfs that it's a file,
> > what do we do with non-existent  device names when they are provided
> > by the user? Just create the file rather than returning ENOENT? So
> > suddenly /dev/ fills up with fileystem images because of typos?
> 
> That won't happen because it doesn't create a new file unless -d file
> is specified, so I guess that's one difference.  i.e. with -d file
> it'll create a file of the requested size; without it, it will mkfs
> it to whatever size the file already is, or if it doesn't exist,
> return -ENOENT.
> 
> > Principle of Least Surprise says that ENOENT is the correct
> > behaviour, hence it follows that "-d file" is needed and should be
> > properly checked and enforced. I'll add this to the start of the
> > patch set I'm currently working on that fixes all of the mkfs input
> > parameter validation problems I've found over the past couple of
> > weeks...
> 
> Well, I hope it doesn't stop mkfs.xfs from mkfs'ing an existing
> file image, which has always worked before...

that's what stat() is for.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
