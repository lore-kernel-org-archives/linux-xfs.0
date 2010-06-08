Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o58CQsTH208087 for <xfs@oss.sgi.com>; Tue, 8 Jun 2010 07:26:54 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 232A03A2460
	for <xfs@oss.sgi.com>; Tue,  8 Jun 2010 05:29:23 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	Vvu2E9DAbzs2XjTO for <xfs@oss.sgi.com>;
	Tue, 08 Jun 2010 05:29:23 -0700 (PDT)
Date: Tue, 8 Jun 2010 22:29:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs, aacraid 2.6.27 => 2.6.32 results in 6 times slowdown
Message-ID: <20100608122919.GC7869@dastard>
References: <4C0E13A7.20402@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C0E13A7.20402@msgid.tls.msk.ru>
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
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com


[ cc'd XFS list ]

On Tue, Jun 08, 2010 at 01:55:51PM +0400, Michael Tokarev wrote:
> Hello.
> 
> I've got a.. difficult issue here, and am asking if anyone else
> has some expirence or information about it.
> 
> Production environment (database).  Machine with an Adaptec
> RAID SCSI controller, 6 drives in raid10 array, XFS filesystem
> and Oracle database on top of it (with - hopefully - proper
> sunit/swidth).
> 
> Upgrading kernel from 2.6.27 to 2.6.32, and users starts screaming
> about very bad performance.  Iostat reports increased I/O latencies,
> I/O time increases from ~5ms to ~30ms.  Switching back to 2.6.27,
> and everything is back to normal (or, rather, usual).
> 
> I tried testing I/O with a sample program which performs direct random
> I/O on a given device, and all speeds are actually better in .32
> compared with .27, except of random concurrent r+w test, where .27
> gives a bit more chances to reads than .32.  Looking at the synthetic
> tests I'd expect .32 to be faster, but apparently it is not.
> 
> This is only one machine here which is still running 2.6.27, all the
> rest are upgraded to 2.6.32, and I see good performance of .32 there.
> But this is also the only machine with hardware raid controller, which
> is onboard and hence not easy to get rid of, so I'm sorta forced to
> use it (I prefer software raid solution because of numerous reasons).
> 
> One possible cause of this that comes to mind is block device write
> barriers.  But I can't find when they're actually implemented.
> 
> The most problematic issue here is that this is only one machine that
> behaves like this, and it is a production server, so I've very little
> chances to experiment with it.
> 
> So before the next try, I'd love to have some suggestions about what
> to look for.   In particular, I think it's worth the effort to look
> at write barriers, but again, I don't know how to check if they're
> actually being used.
> 
> Anyone have suggestions for me to collect and to look at?

http://xfs.org/index.php/XFS_FAQ#Q._Should_barriers_be_enabled_with_storage_which_has_a_persistent_write_cache.3F

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
