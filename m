Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CFCE97F51
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 09:32:34 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A75458F8033
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 07:32:34 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Y0huYTzPFZAjafQk for <xfs@oss.sgi.com>;
	Thu, 28 Nov 2013 07:32:33 -0800 (PST)
Message-ID: <52976210.5070804@sandeen.net>
Date: Thu, 28 Nov 2013 09:32:32 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Problem with mkfs.xfs on a regular file
References: <20131127023119.GB13101@boogeyman>
	<20131127024713.GE10988@dastard>	<5296ACFB.4030901@sandeen.net>
	<20131128051626.GM10988@dastard>	<5296D5EB.2080008@sandeen.net>
	<20131128100107.GN10988@dastard>
In-Reply-To: <20131128100107.GN10988@dastard>
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
Cc: Phil White <cerise-xfs@l.armory.com>, xfs@oss.sgi.com

On 11/28/13, 4:01 AM, Dave Chinner wrote:
> On Wed, Nov 27, 2013 at 11:34:35PM -0600, Eric Sandeen wrote:

<snip>

>> Or maybe just stat() it, and DTRT?
> 
> Well, we need to stat it to make sure that it's a file if "-d file"
> is specified, and a block device if it's not. That will prevent this
> problem.  Every other xfsprogs utility has to be told that it is
> being pointed at an image file rather than a block device, so why
> should mkfs be any different?

The option is there but again I never really knew why.  They work
fine without -f, at least in general:

$ xfs_db fsfile
xfs_db> 

$ xfs_repair fsfile
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
...

$ xfs_metadump fsfile fsfile.meta

$ file fsfile.meta
fsfile.meta: XFS filesystem metadump image

etc

> Indeed, if we don't require users to tell mkfs that it's a file,
> what do we do with non-existent  device names when they are provided
> by the user? Just create the file rather than returning ENOENT? So
> suddenly /dev/ fills up with fileystem images because of typos?

That won't happen because it doesn't create a new file unless -d file
is specified, so I guess that's one difference.  i.e. with -d file
it'll create a file of the requested size; without it, it will mkfs
it to whatever size the file already is, or if it doesn't exist,
return -ENOENT.

> Principle of Least Surprise says that ENOENT is the correct
> behaviour, hence it follows that "-d file" is needed and should be
> properly checked and enforced. I'll add this to the start of the
> patch set I'm currently working on that fixes all of the mkfs input
> parameter validation problems I've found over the past couple of
> weeks...

Well, I hope it doesn't stop mkfs.xfs from mkfs'ing an existing
file image, which has always worked before...

Thanks,
-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
