Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7F3277F37
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 18:57:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 44B238F8059
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 16:57:07 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	18XQfuuGCEp0oNm7 for <xfs@oss.sgi.com>;
	Wed, 13 Mar 2013 16:57:05 -0700 (PDT)
Date: Thu, 14 Mar 2013 10:57:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_fsr, sunit, and swidth
Message-ID: <20130313235703.GX21651@dastard>
References: <5140C147.7070205@binghamton.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5140C147.7070205@binghamton.edu>
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
To: Dave Hall <kdhall@binghamton.edu>
Cc: xfs@oss.sgi.com

On Wed, Mar 13, 2013 at 02:11:19PM -0400, Dave Hall wrote:
> Does xfs_fsr react in any way to the sunit and swidth attributes of
> the file system?

Not directly.

> In other words, with an XFS filesytem set up
> directly on a hardware RAID, it is recommended that the mount
> command be changed to specify sunit and swidth values that reflect
> the new geometry of the RAID.

The mount option does nothing if sunit/swidth weren't specified at
mkfs time. sunit/swidth affect the initial layout of the filesystem,
and that cannot be altered after the fact. Hence you can't
arbitrarily change sunit/swidth after mkfs - you are limited to
changes that are compatible with the existing alignment. If you have
no alignment specified, then there isn't a new alignment that can be
verified as compatible with the existing layout.....

> In my case, these values were not
> specified on the mkfs.xfs of a rather large file system running on a
> RAID 6 array.

Which means the mount option won't work.

> I am wondering adding sunit and swidth parameters to
> the fstab will cause xfs_fsr to do anything different than it is
> already doing.  Most importantly, will it improve performace in any
> way?

It will make no difference at all.

A more important question: why do you even need to run xfs_fsr?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
