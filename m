Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3CB2ERH146592 for <xfs@oss.sgi.com>; Tue, 12 Apr 2011 06:02:14 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 39CA11B6DDC7
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2011 04:05:34 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	DhFaklWLUurTquWf for <xfs@oss.sgi.com>;
	Tue, 12 Apr 2011 04:05:34 -0700 (PDT)
Date: Tue, 12 Apr 2011 21:05:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: fs corruption
Message-ID: <20110412110532.GB31057@dastard>
References: <31377534.post@talk.nabble.com> <20110412094917.GY31057@dastard>
	<38287.10078.qm@web112901.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <38287.10078.qm@web112901.mail.gq1.yahoo.com>
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
To: Leo Davis <leo1783@yahoo.com>
Cc: xfs@oss.sgi.com

On Tue, Apr 12, 2011 at 03:51:20AM -0700, Leo Davis wrote:
> You have a corrupted free space btree.
> 
> Err... apologies for my ignorance, but what is a free space btree?

A tree that indexes the free space in the filesystem. Every time you
write a file or remove a file you are allocating or freeing space,
and these tree keep track of that free space.

If you want to know - at a high level - how XFS is structured (good
for understanding what a free space tree is), read this paper:

http://oss.sgi.com/projects/xfs/papers/xfs_usenix/index.html

It's from 1996, but still correct on all the major structural
details.

> I had serial trace from raid controller which i just checked and
> it logged some 'Loose cabling', but this was months back.....  not
> sure whether that can be the cause of this.. strange if that is
> the case since it's been a long time

it's possible that it took a couple of months to trip over a random
metadata corruption. I've seen that before in directory trees and
inode clusters where corruption is not detected until next time they
are read from disk....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
