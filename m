Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3GNjXOV020755 for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 18:45:34 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F4110FFF1CA
	for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 16:47:28 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	wkQeS0I02FLUhqHp for <xfs@oss.sgi.com>;
	Fri, 16 Apr 2010 16:47:28 -0700 (PDT)
Date: Sat, 17 Apr 2010 09:47:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.32.11 hangs with xfstest 104
Message-ID: <20100416234724.GD2493@dastard>
References: <cone.1271414893.151380.55874.1001@bork.lsof.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <cone.1271414893.151380.55874.1001@bork.lsof.org>
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
To: Roel van Meer <rolek@bokxing.nl>
Cc: xfs@oss.sgi.com

On Fri, Apr 16, 2010 at 12:48:13PM +0200, Roel van Meer wrote:
> Hi list,
> 
> I've been running xfstests on a slackware linux server with kernel
> 2.6.32.11.
> I've noticed that xfstest # 104 reliably hangs the kernel. Attached
> are two call traces.

Yes, it does, and has done since test 104 was written to exercise a
growfs deadlock years ago. I re-enabled it in the auto group because
it's been fixed it and those fixes are now in the 2.6.34-rc tree.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
