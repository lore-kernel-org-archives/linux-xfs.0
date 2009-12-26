Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBQG0K06057029 for <xfs@oss.sgi.com>; Sat, 26 Dec 2009 10:00:21 -0600
Received: from g5t0008.atlanta.hp.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 717BF1C184BC
	for <xfs@oss.sgi.com>; Sat, 26 Dec 2009 08:01:05 -0800 (PST)
Received: from g5t0008.atlanta.hp.com (g5t0008.atlanta.hp.com [15.192.0.45])
	by cuda.sgi.com with ESMTP id 9dd0sSSbxrz88GqJ for
	<xfs@oss.sgi.com>; Sat, 26 Dec 2009 08:01:05 -0800 (PST)
Message-ID: <4B36333B.3030600@hp.com>
Date: Sat, 26 Dec 2009 11:00:59 -0500
From: jim owens <jowens@hp.com>
MIME-Version: 1.0
Subject: Re: [Jfs-discussion] benchmark results
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
	<19251.26403.762180.228181@tree.ty.sabi.co.uk>
	<20091224212756.GM21594@thunk.org>
	<alpine.DEB.2.01.0912241739160.3483@bogon.housecafe.de>
	<20091225161453.GD32757@thunk.org>
	<20091225162238.GB19303@bitmover.com>
	<alpine.DEB.2.01.0912251042540.3483@bogon.housecafe.de>
In-Reply-To: <alpine.DEB.2.01.0912251042540.3483@bogon.housecafe.de>
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
To: Christian Kujau <lists@nerdbynature.de>
Cc: Peter Grandi <pg_jf2@jf2.for.sabi.co.UK>, jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, tytso@mit.edu, linux-ext4@vger.kernel.org, Larry McVoy <lm@bitmover.com>, reiserfs-devel@vger.kernel.org, ext-users <ext3-users@redhat.com>, xfs@oss.sgi.com, linux-btrfs@vger.kernel.org

Christian Kujau wrote:
 
> I was using "sync" to make sure that the data "should" be on the disks 

Good, but not good enough for many tests... info sync

CONFORMING TO
       POSIX.2

NOTES
       On Linux, sync is only guaranteed to  schedule  the  dirty  blocks  for
       writing;  it  can  actually take a short time before all the blocks are
       finally written.

This is consistent with all the feels-like-unix OSes I have used.

And to make it even more random, the hardware (drive/controller)
write cache state needs to be accounted for, and what the filesystem
does if anything to try to ensure device-cache-to-media consistency.

That does not mean I'm saying the tests are invalid or not useful,
only that people need to evaluate "what do they really tell me".

jim

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
