Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3A7Yh6X064746 for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 02:34:43 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id bxnmaADpcwlMYC9U
	for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 00:34:42 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 6DB636C105
	for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 02:34:41 -0500 (CDT)
Message-ID: <4F83E293.8000509@hardwarefreak.com>
Date: Tue, 10 Apr 2012 02:34:43 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20350.9643.379841.771496@tree.ty.sabi.co.UK>
	<20350.13616.901974.523140@tree.ty.sabi.co.UK>
	<CAAxjCEzkemiYin4KYZX62Ei6QLUFbgZESdwS8krBy0dSqOn6aA@mail.gmail.com>
	<20352.28730.273834.568559@tree.ty.sabi.co.UK>
	<4F8074EC.2030108@gmail.com> <4F82063F.4070609@hardwarefreak.com>
	<4F826FFA.4050207@hardwarefreak.com>
	<CAAxjCExcd6T9gUM5AHzZM535e1kyb9WJd_ib2MFkeC_DbU7TXA@mail.gmail.com>
In-Reply-To: <CAAxjCExcd6T9gUM5AHzZM535e1kyb9WJd_ib2MFkeC_DbU7TXA@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
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
To: xfs@oss.sgi.com

On 4/9/2012 6:52 AM, Stefan Ring wrote:

> Whatever the problem with the controller may be, it behaves quite
> nicely usually. It seems clear though, that, regardless of the storage
> technology, it cannot be a good idea to schedule tiny blocks in the
> order that XFS schedules them in my case.
> 
> This:
> AG0 *   *   *
> AG1  *   *   *
> AG2   *   *   *
> AG3    *   *   *
> 
> cannot be better than this:
> 
> AG0 ***
> AG1    ***
> AG2       ***
> AG3          ***

With 4 AGs this must represent the RAID6 or RAID10 case.  Those don't
seem to show any overlapping concurrency.  Maybe I'm missing something,
but it should look more like this, at least in the concat case:

AG0 ***
AG1 ***
AG2 ***

> Yes, in theory, a good cache controller should be able to sort this
> out. But at least this particular controller is not able to do so and
> could use a little help. 

Is the cache in write-through or write-back mode?  The latter should
allow for aggressive reordering.  The former none, or very little.  And
is all of it dedicated to writes, or is it split?  If split, dedicate it
all to writes.  Linux is going to cache block reads anyway, so it makes
little sense to cache them in the controller as well.

> Also, a single consumer-grade drive is
> certainly not helped by this write ordering.

Are you referring to the Mushkin SSD I mentioned?  The SandForce 2281
onboard the Enhanced Chronos Deluxe is capable of a *sustained* 20,000
4KB random write IOPs, 60,000 peak.  Mushkin states 90,000, which may be
due to their use of Toggle Mode NAND instead ONFi, and/or they're simply
fudging.  Regardless, 20K real write IOPS is enough to make
scheduling/ordering mostly irrelevant I'd think.  Just format with 8 AGs
to be on the safe side for DLP (directory level parallelism), and you're
off to the races.  The features of the SF2000 series make MLC SSDs based
on it much more like 'enterprise' SLC SSDs in most respects.  The lines
between "consumer" and "enterprise" SSDs have already been blurred as
many vendors have already been selling "enterprise" MLC SSDs for a while
now, including Intel, Kingston, OCZ, PNY, and Seagate.  All are based on
the same SandForce 2281 as in this Mushkin, or the 2282, which is
required for devices over 512GB.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
