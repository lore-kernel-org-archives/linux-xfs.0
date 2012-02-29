Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1TJkcIQ041803 for <xfs@oss.sgi.com>; Wed, 29 Feb 2012 13:46:38 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id lO64cFGZxm6uJfhx for <xfs@oss.sgi.com>;
	Wed, 29 Feb 2012 11:46:36 -0800 (PST)
Message-ID: <4F4E809A.40308@sandeen.net>
Date: Wed, 29 Feb 2012 13:46:34 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Poor performance using discard
References: <1330469778.9688.7.camel@core24> <20120229012259.GW3592@dastard>
	<1330480826.9688.23.camel@core24> <20120229040819.GZ3592@dastard>
In-Reply-To: <20120229040819.GZ3592@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Thomas Lynema <lyz27@yahoo.com>, xfs@oss.sgi.com

On 2/28/12 10:08 PM, Dave Chinner wrote:

> Also, I think you need to provide a block trace (output of
> blktrace/blkparse for the rm -rf workloads) for both the XFS and
> ext4 cases so we can see what discards are actually being issued and
> how long they take to complete....
> 

I ran a quick test on a loopback device on 3.3.0-rc4.  Loopback supports
discards.  I made 1G filesystems on loopback on ext4 & xfs, mounted with
-o discard, cloned a git tree to them, and ran rm -rf; sync under blktrace.

XFS took about 11 seconds, ext4 took about 1.7.

(without trim, times were roughly the same - but discard/trim is probably
quite fast on the looback file)

Both files were reduced in disk usage about the same amount, so online
discard was working for both:

# du -h ext4_fsfile xfs_fsfile
497M	ext4_fsfile
491M	xfs_fsfile

XFS issued many more discards than ext4:

# blkparse xfs.trace | grep -w D | wc -l
40205
# blkparse ext4.trace | grep -w D | wc -l
123

XFS issued many small discards (4k/8 sectors) and a few larger ones:

[sectors | # discards]

8 20079
16 6762
24 3627
32 2798
40 1439
...
1840 1
7256 1
26720 1

ext4 issued far fewer discards, but in much larger chunks:

8 29
16 9
24 4
32 6
...
35152 1
35248 1
53744 1
192320 1
261624 1
262144 1

So that could certainly explain the relative speed.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
