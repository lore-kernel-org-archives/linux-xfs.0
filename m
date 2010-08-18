Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7IBmUPX111232 for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 06:48:30 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 287785607
	for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 04:48:58 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	5NLrEx5VJp2mczLY for <xfs@oss.sgi.com>;
	Wed, 18 Aug 2010 04:48:58 -0700 (PDT)
Date: Wed, 18 Aug 2010 21:48:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Review: xfsprogs with libblkid enabled for Debian
Message-ID: <20100818114856.GT10429@dastard>
References: <472498892.114291282107960876.JavaMail.root@mail-au.aconex.com>
	<86828409.114311282107988740.JavaMail.root@mail-au.aconex.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <86828409.114311282107988740.JavaMail.root@mail-au.aconex.com>
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
To: nathans@aconex.com
Cc: xfs <xfs@oss.sgi.com>

On Wed, Aug 18, 2010 at 03:06:28PM +1000, nathans@aconex.com wrote:
> Hi guys,
> 
> Attached patch adds support for libblkid in Debian builds.
> There's a couple of other trivial things fixed up while the
> package was building - man page typos reported by lintian,
> fix source tarball generation (and deb build) when libblkid
> is enabled (*must* descend into libdisk to pick up sources)
> ... but its all pretty straight forward.
> 
> I've checked that mkfs.xfs is linked as expected too. :)

Looks OK to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
