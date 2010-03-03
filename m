Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o23GJdpe088983 for <xfs@oss.sgi.com>; Wed, 3 Mar 2010 10:19:39 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 220A721478F
	for <xfs@oss.sgi.com>; Wed,  3 Mar 2010 08:21:06 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id 2E13RWhYzn6ijTtE for
	<xfs@oss.sgi.com>; Wed, 03 Mar 2010 08:21:06 -0800 (PST)
Message-ID: <4B8E8C72.1010403@sandeen.net>
Date: Wed, 03 Mar 2010 10:21:06 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] xfsqa: fix size specification for scratch mkfs
References: <1267597162-12092-1-git-send-email-david@fromorbit.com>	<1267597162-12092-3-git-send-email-david@fromorbit.com>
	<20100303125809.GB26672@infradead.org>
In-Reply-To: <20100303125809.GB26672@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Wed, Mar 03, 2010 at 05:19:21PM +1100, Dave Chinner wrote:
>> When making a specifically sized scratch filesystem, we need to
>> calculate the size rather than assigning the caclculation expression
>> to a variable and passing that into the _scratch_mkfs_sized
>> function. Currently sized filesystems are failing to be made and the
>> code is falling back to full sized filesystems so we are not testing
>> enospc issues correctly.
> 
> This seems rather fragile.  Maybe instead of calculating the bignums
> which I suspect are the problem could we pass symbolic values like 104M
> in and parse them in _scratch_mkfs_sized?


How about making _scratch_mkfs_sized something like:

_scratch_mkfs_sized()
{
    fssize=`echo $1 | bc`
    ...


as a quick test this seems to work:

#!/bin/bash

my_function()
{
	SIZE=$1
	echo $SIZE
	SIZE2=`echo $SIZE | bc`
	echo $SIZE2
}

SIZE=24*1024*1024
my_function $SIZE
SIZE=2410241024
my_function $SIZE

yields the right answers for both numbers & expressions passed in:

#./testit.sh 
24*1024*1024
25165824
2410241024
2410241024

 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
