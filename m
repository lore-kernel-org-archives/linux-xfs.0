Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9097E7F37
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 20:26:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3C56FAC001
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 18:26:30 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	wInVcbFpMTcAKfd4 for <xfs@oss.sgi.com>;
	Thu, 23 May 2013 18:26:28 -0700 (PDT)
Date: Fri, 24 May 2013 11:26:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS assertion from truncate. (3.10-rc2)
Message-ID: <20130524012625.GH24543@dastard>
References: <20130522025605.GA29767@redhat.com>
	<20130522040318.GG29466@dastard> <20130522041521.GA1837@redhat.com>
	<20130522051243.GH29466@dastard> <20130522052938.GA2573@redhat.com>
	<20130522055147.GI29466@dastard> <20130522215454.GL29466@dastard>
	<20130523184948.GA11151@redhat.com>
	<20130523223038.GB24543@dastard>
	<20130524004906.GA21171@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130524004906.GA21171@redhat.com>
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
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Thu, May 23, 2013 at 08:49:06PM -0400, Dave Jones wrote:
> On Fri, May 24, 2013 at 08:30:38AM +1000, Dave Chinner wrote:
> 
>  > >  > Which I put just before the assert that is firing on your machine.
>  > >  > 
>  > >  > And, obviously, it isn't firing on mine and obviously shouldn't be firing on a
>  > >  > mask of 0xa068.
>  > > 
>  > > With this, I get a spew of these when I start a kernel build..
>  > > 
>  > > [  964.378690] XFS (sda2): xfs_setattr_size: mask 0xa068, masked 0x0 ii 0xffff88020a95dac0, d 0xffff880221b5d970 path /davej/tmp/ccN2RrM5.s
>  > > [  964.651927] XFS (sda2): xfs_setattr_size: mask 0xa068, masked 0x0 ii 0xffff88020a95dac0, d 0xffff88020ff80b90 path /davej/tmp/ccB1Cdmo.s
>  > > [  964.867444] XFS (sda2): xfs_setattr_size: mask 0xa068, masked 0x0 ii 0xffff88020a95dac0, d 0xffff8802218a5bc0 path /davej/tmp/ccCUaXbG.s
>  > > [  965.102661] XFS (sda2): xfs_setattr_size: mask 0xa068, masked 0x0 ii 0xffff88020a95dac0, d 0xffff88020ffacde0 path /davej/tmp/cckMLf2X.s
>  > > [  967.743312] XFS (sda2): xfs_setattr_size: mask 0xa068, masked 0x0 ii 0xffff88020a93c200, d 0xffff88022212c250 path /davej/tmp/ccFMkBbA.s
>  > > [  967.947154] XFS (sda2): xfs_setattr_size: mask 0xa068, masked 0x0 ii 0xffff88020a93c200, d 0xffff8802226cc6f0 path /davej/tmp/cc5iX4SR.s
>  > > [  968.009414] XFS (sda2): xfs_setattr_size: mask 0xa068, masked 0x0 ii 0xffff88020a988000, d 0xffff8802219f1970 path /davej/tmp/ccvWCHTZ.o
>  > > [  968.091504] XFS (sda2): xfs_setattr_size: mask 0xa068, masked 0x0 ii 0xffff88020a9898c0, d 0xffff88022208de10 path /davej/tmp/cc9n6fnm.ld
>  > > [  968.107997] XFS (sda2): xfs_setattr_size: mask 0xa068, masked 0x0 ii 0xffff88020a98dac0, d 0xffff880221160de0 path /davej/tmp/cc5rlvHu.le
>  > 
>  > Right, It's printing them out for every truncate that is done.
>  > Just print on the conditional that is was triggering the assert...
> 
> I'm missing something.. That's what I did ?
> 
> -       ASSERT((mask & (ATTR_MODE|ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
> +
> +       if ((mask & (ATTR_MODE|ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
>                         ATTR_MTIME_SET|ATTR_KILL_SUID|ATTR_KILL_SGID|
> -                       ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
> +                       ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0) {

You want to print the debug output if the masked value != 0.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
