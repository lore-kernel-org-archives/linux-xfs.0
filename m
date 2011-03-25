Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2PN54Js261470 for <xfs@oss.sgi.com>; Fri, 25 Mar 2011 18:05:05 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 140CF15A2D5B
	for <xfs@oss.sgi.com>; Fri, 25 Mar 2011 16:08:07 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	odO1lC6hww8kwFE0 for <xfs@oss.sgi.com>;
	Fri, 25 Mar 2011 16:08:07 -0700 (PDT)
Date: Sat, 26 Mar 2011 10:08:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/6] xfs: register the inode cache shrinker before
	quotachecks
Message-ID: <20110325230805.GS26611@dastard>
References: <1300860870-15471-1-git-send-email-david@fromorbit.com>
	<1300860870-15471-6-git-send-email-david@fromorbit.com>
	<201103232224.03501.arekm@maven.pl> <4D8C90F6.7050500@dermichi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D8C90F6.7050500@dermichi.com>
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
To: Michael Weissenbacher <mw@dermichi.com>
Cc: xfs@oss.sgi.com, aelder@sgi.com

On Fri, Mar 25, 2011 at 01:56:22PM +0100, Michael Weissenbacher wrote:
> > From: Arkadiusz Miskiewicz <arekm@maven.pl>
> > On Wednesday 23 of March 2011, Dave Chinner wrote:
> >> From: Dave Chinner <dchinner@redhat.com>
> > 
> > Thanks a lot for this patch. I was able to mount my two ~800GB filesystems 
> > with quota enabled without out of memory/machine reboot suprises (which were 
> > happening without this patch every time I tried mount with quota).
> Seconded, this also solved my long-standing problems with a Quota mounts
> on some 32-bit i686 and low-mem x64 machines.
> 
> I tested the patch with Kernel 2.6.38.1-i686 on a ~500GB fs which
> refused to mount with quotas for some time now.
> 
> Is there any chance that this patch will be integrated/backparted to
> older kernels like 2.6.32.x, 2.6.35.x?

The patch will be committed with a CC to stable@kernel.org, so that
should happen magically once this is in mainline.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
