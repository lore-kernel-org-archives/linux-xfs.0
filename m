Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7BI8Krf153709
	for <linux-xfs@oss.sgi.com>; Wed, 11 Aug 2010 13:08:21 -0500
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9EDACC8167B
	for <linux-xfs@oss.sgi.com>; Wed, 11 Aug 2010 11:17:26 -0700 (PDT)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id Smsvlse4bC1C5CW0 for <linux-xfs@oss.sgi.com>;
	Wed, 11 Aug 2010 11:17:26 -0700 (PDT)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1OjFjF-00062n-Ff
	for linux-xfs@oss.sgi.com; Wed, 11 Aug 2010 20:08:41 +0200
Received: from barriere.frankfurter-softwarefabrik.de ([217.11.197.1])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Wed, 11 Aug 2010 20:08:41 +0200
Received: from niemayer by barriere.frankfurter-softwarefabrik.de with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Wed, 11 Aug 2010 20:08:41 +0200
From: Peter Niemayer <niemayer@isg.de>
Subject: Re: observed significant performance improvement using "delaylog"
	in a real-world application
Date: Wed, 11 Aug 2010 20:08:33 +0200
Message-ID: <i3uov1$ugj$1@dough.gmane.org>
References: <i3rt4t$46c$1@dough.gmane.org> <20100811000854.GL26402@dastard>
Mime-Version: 1.0
In-Reply-To: <20100811000854.GL26402@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

On 08/11/2010 02:08 AM, Dave Chinner wrote:
> One thing that you might want to try to
> further improve performance is the logbsize=262144 option as well.
> That will help flush log IO faster by doing less IOs.

Tried that - but this did not have a positive effect.
(In fact a slightly negative one, but that could be within
the measurement accuracy).

> Also, if your workload is doing lots of fsync calls, then the
> optimisations I posted a few days ago should also help improve
> delaylog throughput.

We don't to any fsync's.

Regards,

Peter Niemayer


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
