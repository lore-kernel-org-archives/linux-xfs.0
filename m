Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2FF2C7F59
	for <xfs@oss.sgi.com>; Thu,  2 Apr 2015 17:36:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1DF548F8054
	for <xfs@oss.sgi.com>; Thu,  2 Apr 2015 15:36:28 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Oyiw7mDBMqlXDFiV for <xfs@oss.sgi.com>;
	Thu, 02 Apr 2015 15:36:23 -0700 (PDT)
Date: Fri, 3 Apr 2015 09:36:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Slightly Urgent:  XFS No Space Left On Device
Message-ID: <20150402223608.GF8465@dastard>
References: <551993CF.4060908@binghamton.edu> <20150330194510.GD28621@dastard>
	<551C4CB8.7@binghamton.edu> <20150402001235.GI28621@dastard>
	<551D5316.8050201@binghamton.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <551D5316.8050201@binghamton.edu>
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

On Thu, Apr 02, 2015 at 10:32:54AM -0400, Dave Hall wrote:
> Thanks for the help.  Rookie error.  I didn't set these mount
> options, but I see that this option is set for all of the other XFS
> volumes I have.
> 
> I am wondering why XFS would default this way though.  Seems like
> heuristically you could assume that a large volume on a 64-bit OS
> would need 64-bit inodes.

The historical argument against inode64 on 64 bit machines was NFS
export and 32 bit clients, which could then break if we used 64 bit
inodes. The Linux NFS client handles this just fine on 32bit
machines (has for a few years), so there's no reason for us to care
very much about this anymore....

> At least perhaps put out a message from
> mkfs.xfs suggesting the use of inode64 on the mount command?

inode64 is now the default for upstream kernels (has been for a
couple of years), but older distros are not going to get those
kernel updates, or anything we might have put in xfsprogs...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
