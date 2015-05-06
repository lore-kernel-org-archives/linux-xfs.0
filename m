Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 36D297F37
	for <xfs@oss.sgi.com>; Wed,  6 May 2015 16:58:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EF9BF304039
	for <xfs@oss.sgi.com>; Wed,  6 May 2015 14:58:22 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	qLZMlpRyUeW5W2sb for <xfs@oss.sgi.com>;
	Wed, 06 May 2015 14:58:19 -0700 (PDT)
Date: Thu, 7 May 2015 07:58:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: SGI Version 1 XFS on Linux
Message-ID: <20150506215816.GE4327@dastard>
References: <2994A55DE0FBBE41B8FE47F9885D74221BC0569C@ARLEXCHMBX02.lst.link.l-3com.com>
	<20150506171222.GA22744@sgi.com>
	<2994A55DE0FBBE41B8FE47F9885D74221BC056F3@ARLEXCHMBX02.lst.link.l-3com.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2994A55DE0FBBE41B8FE47F9885D74221BC056F3@ARLEXCHMBX02.lst.link.l-3com.com>
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
To: "Scott, Edmund J @ SSG - Link" <edmund.scott@l-3com.com>
Cc: Ben Myers <bpm@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, May 06, 2015 at 07:47:51PM +0000, Scott, Edmund J @ SSG -
Link wrote:
> Hi,
> 
> We are in a thunderstorm right now so we had to shut down, be a
> while until we get things back up. We're in Utah with a rolling
> t-storm coming through. 
> 
> We did find documentation that XFS version 1 was pulled out of the
> linux kernel around or after kernel 2.4. and the messages kind of
> support that. I'm looking into digging up an old Red Hat OS to see
> if it is old enough to have the version 1 XFS in it.

You'd be talking about the directory version, then, not the version
of the filesystem? Irix 6.2 introduced Version 4 filesystems, but
version 2 directories didn't come along until a couple of years
later. See Slides 6-7 here:

http://events.linuxfoundation.org/sites/events/files/slides/dchinner-xfs-there-and-back.pdf

As it is, the dirv1 removal commit says "Never functioned on Linux,
just pure bloat".

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=archive/xfs-import.git;a=commitdiff;h=b84149405b9c2ecbc445d2684053e4acc03342ee

So I suspect that the only way you are going to be able to read
those filesystems is with an Irix machine....

> While it was up, we've done the blkid command and it recognizes at
> least 1 partition on the SGI drive to be xfs, others were efs. We
> also used the hardware browser and got the same readings.

Yeah, that's old ;)

> We've also tried to make a disk image. If I try to mount the image
> on the linux computer, it will essentially give me the same error
> about version 1 xfs. Not that this was unexpected, it should error
> out just like the drive did. I also happen to have an O2 up and
> running, so I copied the image over to the O2 expecting to try and
> mount the image so it would/should automatically handle the xfs
> issue, but it looks like the O2 mount command does not have the
> loop or knows how to handle mounting an image like the Linux does.

http://www.nekochan.net/wiki/Loopback_Filesystems

Nekochan is the place to go for information about old SGI boxes.
It might be worth posting there to see if there is anyone local to
you with working hardware that would enable you to pull the
information off the disks....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
