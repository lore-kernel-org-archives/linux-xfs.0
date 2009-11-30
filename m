Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAU6iBux202801 for <xfs@oss.sgi.com>; Mon, 30 Nov 2009 00:44:11 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 860191D9F09F
	for <xfs@oss.sgi.com>; Sun, 29 Nov 2009 22:44:39 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	9WGFj2DT6YzjbtpH for <xfs@oss.sgi.com>;
	Sun, 29 Nov 2009 22:44:39 -0800 (PST)
Date: Mon, 30 Nov 2009 17:43:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Writing journal only in Big Endian format
Message-ID: <20091130064356.GD30608@discord.disaster>
References: <409bd82b0911292117n5aa11961u86e787d20acbd2b3@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <409bd82b0911292117n5aa11961u86e787d20acbd2b3@mail.gmail.com>
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
To: Nitin Arora <nitin.arora.del@gmail.com>
Cc: "sandeen-xfs@sandeen.net" <sandeen-xfs@sandeen.net>, "p.mironchik@velesys.com" <p.mironchik@velesys.com>, "hch@xfs.org" <hch@xfs.org>, xfs@oss.sgi.com

On Mon, Nov 30, 2009 at 10:47:41AM +0530, Nitin Arora wrote:
> The problem is that big endian machine cannot recognize the
> journal which was written in little endian format by the little
> endian machine and once the journal is zerod out it can be
> mouted.
> 
> Now the solution to above problem seems writing journal always in
> big endian format.

Or you could just replay the log on the little endian machine and do
a clean unmount, then you should be able to move it to the big
endian machine without losing anything.

> Please suggest me, Is there any design limitation in XFS for this.

No design limitation, just a *lot* of work to change. If you don't
have a few months handy to work on this, I'd just use the above
method....

> Is it okay and feasible to implement it if yes then please give
> some pointers so that it can be implemented,

All log headers, tails and sector fills need to be converted, every log
item format routine needs a big-endian version, log recovery needs
to be able to read both host-format and big-endian logs, all the
userspace tools need to learn about different log formats, QA tests
need to be written, etc.

> under some suitable
> compile time switch.

It could be done with a superblock feature bit, so the same kernel
could support both big-endian logs and host format.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
