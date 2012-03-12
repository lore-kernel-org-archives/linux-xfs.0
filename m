Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2C0xOYO227186 for <xfs@oss.sgi.com>; Sun, 11 Mar 2012 19:59:24 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	jgakEuoiKXMNmsyy for <xfs@oss.sgi.com>;
	Sun, 11 Mar 2012 17:59:23 -0700 (PDT)
Date: Mon, 12 Mar 2012 11:59:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 20 wakeups/second/mounted filesystem in xfsaild
Message-ID: <20120312005921.GZ5091@dastard>
References: <4F5BD933.8040101@sfg.quasiparticle.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F5BD933.8040101@sfg.quasiparticle.net>
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
To: Dhivael i-Khial t'Jahlei <dhivael@sfg.quasiparticle.net>
Cc: xfs@oss.sgi.com

On Sat, Mar 10, 2012 at 11:44:03PM +0100, Dhivael i-Khial t'Jahlei wrote:
> Hello,
> 
> i recently switched from ext4 to XFS on some systems. Much to my
> surprise, XFS produces quite a lot of wakeups in kernel 3.2.9.
> 
> On every mounted filesystem, the associated xfsaild will wake up 20
> times per second, when the filesystem is sufficiently loaded, it will
> never wake up. The filesystems are mounted with defaults, I'm seeing the
> problem on virtual IDE drives in virtual machines and SSD < dmcrypt <
> LVM < XFS stacks.
> 
> Am I doing something wrong, or am I seeing expected behaviour in XFS?

Currently expected behaviour - there was a recent bug fix for a
nasty, hard to hit corner case that reintroduced this periodic
wakeup. We're waiting for things to settle down before (i.e. give
users some time to report whether the problem really is fixed before
removing the periodic wakeup again....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
