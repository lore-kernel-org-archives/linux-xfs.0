Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AB82729DF8
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 20:58:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 19549AC009
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 18:58:42 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	zvYvL1bBMxUHSKDk for <xfs@oss.sgi.com>;
	Wed, 12 Jun 2013 18:58:40 -0700 (PDT)
Date: Thu, 13 Jun 2013 11:58:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/27] xfs: current patch queue for 3.11
Message-ID: <20130613015836.GF29338@dastard>
References: <1371032567-21772-1-git-send-email-david@fromorbit.com>
	<20130612141743.GV20932@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130612141743.GV20932@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Jun 12, 2013 at 09:17:43AM -0500, Ben Myers wrote:
> Hey Dave,
> 
> On Wed, Jun 12, 2013 at 08:22:20PM +1000, Dave Chinner wrote:
> > Thoughts, comments, flames?
> 
> Do you have any performance numbers recorded for the block queue plugging for
> bulkstat and the new inode create transaction?

The new inode create transaction doesn't change performance on my
test rigs. It significantly reduces log traffic under heavey create
workloads (up to 50% lower). However, given the reduction is only
from 60MB/s down to 30MB/s at 110,000 inodes/s being created,  log
performance is not a performance limiting factor on any of my test
rigs.

That said, the reason for the change is not so much for immediate
improvements in inode create performance.  Want to allocate a stripe
width of inodes at a time?  The new transaction can do that
atomically....

Ordered buffers allow all sorts of interesting things to be done -
do you want to add an ext3/4 style data=ordered mode? We can do that
with ordered buffers.  Synchronous writes of remote attribute data?
Ordered buffers can be used to make that async and driven by AIL
flushing.

Want to use intent-based logging for operations rather than physical
object logging? Ordered log items and metadata stamped with the last
modification LSN are necessary, and with this icreate transaction we
end up with all the pieces we need to do this....

And for bulkstat, performance differences were documented in
this email where I found the problem:

http://oss.sgi.com/pipermail/xfs/2013-June/026922.html

It took a mulithreaded bulkstat from being IO bound at 450,000
inodes/s @ 220MB/s and 27,000 IOPS to being CPU bound at 750,000
inodes/s @ 350MB/s and 14000 IOPS.

And given that it increased IO sizes from 8k to 16k for 256 byte
inodes and to 32k for 512 byte inodes, that is going to increase
performance on any busy filesystem simply through the fact that
bulkstat IOPS overhead goes down by a factor of 2/4/8/16 depending
on inode size.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
