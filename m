Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8M8Var4055450 for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 03:31:37 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 70E69183AC2F
	for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 01:32:29 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	sO6zwkLF6f9BHpee for <xfs@oss.sgi.com>;
	Wed, 22 Sep 2010 01:32:29 -0700 (PDT)
Date: Wed, 22 Sep 2010 18:32:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS internal error xfs_da_do_buf(2)
Message-ID: <20100922083226.GF2614@dastard>
References: <20100922072653.GA23326@pirx.askja.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100922072653.GA23326@pirx.askja.de>
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
To: Ralf Gross <Ralf-Lists@ralfgross.de>
Cc: xfs@oss.sgi.com

On Wed, Sep 22, 2010 at 09:26:53AM +0200, Ralf Gross wrote:
> Hi,
> 
> we've a fileserver withe the following setup:
> 
> Debian Lenny AMD64, 2.6.32 bpo Kernel
> 
> Infortrend RAID with BBU -> DRBD -> LVM -> XFS
> 
> This system is running since beginning of August and replaced some
> older hardware.
> 
> Last week xfs began to print some warnings to syslog. The day before a DRBD
> verify ended without showing differences between the 2 cluster nodes.

That doesn't mean there is no corruption - it means the corruption
got propagted to both nodes.

....

> This seems not to happen all the time, the server was running 5 weeks without
> these messages. And there were some full backups running during this
> time which read every file on the fs.

Which implies that it is recent. Knowing when the directory was last
modified and what was done to it would be useful, but I know you
won't have that information....

> Any hints what to look for or what to do to notice this corruption as soon as possible?

You won't find an error on disk without scrubbing of some kind.
In the case of filesystem metadata, you need to read all the
metadata and validity check it to find random corruptions. The best
you can do is traverse and stat every file regularly...

> Sep 13 12:30:30 VU0EM003 kernel: [2834063.439771] block drbd0: conn( Connected -> VerifyS ) 
> Sep 13 12:30:30 VU0EM003 kernel: [2834063.439803] block drbd0: Starting Online Verify from sector 0
> Sep 15 03:06:59 VU0EM003 kernel: [2972785.494729] block drbd0: Online verify  done (total 138989 sec; paused 0 sec; 33716 K/sec)
> Sep 15 03:06:59 VU0EM003 kernel: [2972785.494794] block drbd0: conn( VerifyS -> Connected ) 
> 
> Sep 16 12:18:16 VU0EM003 kernel: [3092032.035881] ffff8803e65c8000: 49 4e 00 00 02 02 00 00 00 00 14 1b 00 00 04 26  IN.............&
> Sep 16 12:18:16 VU0EM003 kernel: [3092032.035936] Filesystem "dm-2": XFS internal error xfs_da_do_buf(2) at line 2112 of file /tmp/buildd/linux-2.6-2.6.32/debian/build/source_amd64_none/fs/xfs/xfs_da_btree.c.  Caller 0xffffffffa02b0a52

So it found an inode cluster rather than a directory block. Implies
a bad block pointer. Without the repair output, there's no way of
knowing what it might have been incorrect (either the directory
btree block pointers or the block contents), so there's not much
that can be guessed from this...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
