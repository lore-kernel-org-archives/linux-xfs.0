Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B6DD47F5A
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 10:38:19 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 92B948F8035
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 08:38:19 -0800 (PST)
Received: from mail-yk0-f182.google.com (mail-yk0-f182.google.com
	[209.85.160.182]) by cuda.sgi.com with ESMTP id
	PwtWgsdDaaXH1IS7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 01 Dec 2015 08:38:18 -0800 (PST)
Received: by ykdv3 with SMTP id v3so13729169ykd.0
	for <xfs@oss.sgi.com>; Tue, 01 Dec 2015 08:38:17 -0800 (PST)
Date: Tue, 1 Dec 2015 11:38:15 -0500
From: Tejun Heo <tj@kernel.org>
Subject: Re: automatic testing of cgroup writeback limiting (was: Re: Does
	XFS support cgroup writeback limiting?)
Message-ID: <20151201163815.GB12922@mtj.duckdns.org>
References: <5652F311.7000406@5t9.de> <20151125213500.GK26718@dastard>
	<565B70F9.8060707@5t9.de> <1711940.cDn6AztRgi@merkaba>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1711940.cDn6AztRgi@merkaba>
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
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-fsdevel@vger.kernel.org, Lutz Vieweg <lvml@5t9.de>, xfs@oss.sgi.com

Hello,

On Tue, Dec 01, 2015 at 09:38:03AM +0100, Martin Steigerwald wrote:
> > > echo "<major>:<minor>  <rate_bytes_per_second>" >
> > > /cgrp/blkio.throttle.read_bps_device
> > document how to configure limits per block device.
> > 
> > Now after reading through the new Writeback section of blkio-controller.txt
> > again I am somewhat confused - the text states
> > 
> > > writeback operates on inode basis

As opposed to pages.  cgroup ownership is tracked per inode, not per
page, so if multiple cgroups write to the same inode at the same time,
some IOs will be incorrectly attributed.

> > and if that means inodes as in "file system inodes", this would
> > indeed mean limits would be enforced "per filesystem" - and yet
> > there are no options documented to specify limits for any specific
> > filesystem.

cgroup ownership is per-inode.  IO throttling is per-device, so as
long as multiple filesystems map to the same device, they fall under
the same limit.

> > > Metadata IO not throttled - it is owned by the filesystem and hence
> > > root cgroup.
> > 
> > Ouch. That kind of defeats the purpose of limiting evil processes'
> > ability to DOS other processes.

cgroup isn't a security mechanism and has to make active tradeoffs
between isolation and overhead.  It doesn't provide protection against
malicious users and in general it's a pretty bad idea to depend on
cgroup for protection against hostile entities.  Although some
controller do better isolation than others, given how filesystems are
implemented, filesystem io control getting there will likely take a
while.

> > Wouldn't it be possible to assign some arbitrary cost to meta-data
> > operations - like "account one page write for each meta-data change
> > to the originating process of that change"? While certainly not
> > allowing for limiting to byte-precise limits of write bandwidth,
> > this would regain the ability to defend against DOS situations,
> > and for well-behaved processes, the "cost" accounted for their
> > not-so-frequent meta-data operations would probably not really hurt their
> > writing
> > speed.

For aggregate consumers, this sort of approaches does make sense -
measure total consumption by common operations and distribute the
charges afterwards; however, this will require quite a bit of work on
both io controller and filesystem sides.

> > (I understand that if one used the absolute "blkio.throttle.write*" options
> > pressure back could apply before the dirty buffer cache was maxed out,
> > but in real-world scenarios people will almost always use the relative
> > "blkio.weight" based limiting, after all, you usually don't want to throttle
> > processes if there is plenty of bandwidth left no other process wants at
> > the same time.)

I'd recommend configuring both memory.high and io.weight so that the
buffer area isn't crazy high compared to io bandwidth.  It should be
able to reach the configured ratio that way and also avoids two io
domains competing in the same io domain which can skew the results.

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
