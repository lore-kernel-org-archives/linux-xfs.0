Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9A4F47CA0
	for <xfs@oss.sgi.com>; Sat, 23 Jul 2016 17:50:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 464308F8035
	for <xfs@oss.sgi.com>; Sat, 23 Jul 2016 15:50:03 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	lLfWMDwP8R5H4vvo for <xfs@oss.sgi.com>;
	Sat, 23 Jul 2016 15:49:59 -0700 (PDT)
Date: Sun, 24 Jul 2016 08:49:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Metadata corruption detected at xfs_attr3_leaf_write_verify
Message-ID: <20160723224957.GS16044@dastard>
References: <D3B7B1BB.74FB%jonathan.stockley@emc.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <D3B7B1BB.74FB%jonathan.stockley@emc.com>
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
To: "Stockley, Jonathan" <jonathan.stockley@emc.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Jul 22, 2016 at 06:19:25PM +0000, Stockley, Jonathan wrote:
> Hi,
> I just ran into this error while testing an OpenStack SWIFT deployment.
> 
> [130004.933449] XFS (loop1): Metadata corruption detected at xfs_attr3_leaf_write_verify+0xe5/0x100 [xfs], block 0x468d0c8
> [130004.936209] XFS (loop1): Unmount and run xfs_repair
> [130004.937477] XFS (loop1): First 64 bytes of corrupted metadata buffer:
> [130004.939113] ffff880111ddd000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 00 00 00  ................
> [130004.941242] ffff880111ddd010: 10 00 00 00 00 20 0f e0 00 00 00 00 00 00 00 00  ..... ..........

That's a empty attribute leaf block. It probably should be stale
and hence never written to disk. The verifier caught it before it
could be written, so probably just saved you from on-disk
data/filesystem corruption.

> [130004.943327] ffff880111ddd020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [130004.945393] ffff880111ddd030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [130004.947565] XFS (loop1): xfs_do_force_shutdown(0x8) called from line 1249 of file /build/linux-lts-vivid-vt3Z1H/linux-lts-vivid-3.19.0/fs/xfs/xfs_buf.c.  Return address = 0xffffffffc0752c92
> [130004.951692] XFS (loop1): Corruption of in-memory data detected.  Shutting down filesystem

Loops devices are an interesting choice for a production workload
like this. Why?

> Environment information:
> Ubuntu Server 14.04 LTS
> $ uname -a
> Linux 3e2116e0-b4e8-4666-be70-5ddf9c9d9d2b 3.19.0-49-generic #55~14.04.1hf1533043v20160201b1-Ubuntu SMP Mon Feb 1 20:41:00 UT x86_64 x86_64 x86_64 GNU/Linux

A vendor kernel of some kind - have you reported the problem to
Ubuntu, to see if they've already backported a fix?

> I am able to reproduce the problem as follows:
> 
>   *   created a VM based SWIFT cluster

Not something I can do to reproduce here.

....

> In my two test runs the XFS failure occurred around 9 hours after the test was started.
> 
> It looks like I can reproduce the problem, albeit over an extended period of time.
> What can I do to gather more info? Any debug options I can enable that might help?

First of all, add all the stuff missing from here:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Your could also probably run a XFs build that contains all the debug
warnings (CONFIG_XFS_WARN=y) and see if that triggers something.
You could laso try a more recent kernel (e.g. 4.6) and see if that
has the same problem.

If it still occurs, then you are probably going to need to narrow
this down to a much, simpler and more targeted reporducer for

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
