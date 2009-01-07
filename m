Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n07IiQ7L022461 for <xfs@oss.sgi.com>; Wed, 7 Jan 2009 12:44:26 -0600
Received: from zaphod.dth.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3AAB11BA1A32
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2009 10:44:25 -0800 (PST)
Received: from zaphod.dth.net (zaphod.dth.net [85.159.112.68]) by cuda.sgi.com
	with ESMTP id qWD7fuveynAKybJM for <xfs@oss.sgi.com>;
	Wed, 07 Jan 2009 10:44:25 -0800 (PST)
Date: Wed, 7 Jan 2009 19:44:20 +0100
From: Danny ter Haar <dth@dth.net>
Subject: Re: problems showing up as XFS problems on kernels after 2.6.28-git2
Message-ID: <20090107184420.GA15653@dth.net>
References: <20090107165218.GA11132@dth.net>
	<20090107180246.GA15218@infradead.org>
	<20090107182415.GA12039@dth.net>
	<20090107183115.GA6261@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090107183115.GA6261@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

Quoting Christoph Hellwig (hch@infradead.org):
> And error when compiling the kernel or you got the same error again?

same error while trying to boot (this time on sda (pata with libata))
root filesystem of the OS partition.

> In case you can actually reproduce this error, I would be very
> interested in a metadump of the filesystem that causes this error.

See the errorlog on: http://www.dth.net/kernel/c3/netconsole_2.6.28-git9-error.txt

> The dbuegging should be really easy as long you actually have a tree /
> config 

kernel tree is still on my laptop available.

> with which the oops happened so that the oops has the same
> addresses.
> Compared to your config we would need CONFIG_DEBUG_INFO,
> but that's something we could turn on after the fact as it shouldn't
> change the reported address.  After that we can just do a trivial
> command in gdb to find the source lines for the addresses reported
> (this can easily be done on the system where you compile the kernel,
> doesn't have to be on the NAS box).

ok, pointer to a howto by anychange ?
still looking/googling. [think i found something]

> Btw, turning on CONFIG_XFS_DEBUG would be useful to see more output
> in case you can reproduce this issue.  Just make sure to turn it
> off again when you want to use the box for a real workload..

Will compile a new kernel in the mean time with those 2 options:
CONFIG_XFS_DEBUG & CONFIG_DEBUG_INFO


-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
