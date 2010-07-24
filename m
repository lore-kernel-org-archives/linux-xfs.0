Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6O06m4M230556 for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 19:06:49 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C99E546A99E
	for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 17:09:49 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	ZLKPOaela6Y0Z8QJ for <xfs@oss.sgi.com>;
	Fri, 23 Jul 2010 17:09:49 -0700 (PDT)
Date: Sat, 24 Jul 2010 10:09:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC, PATCH 0/3] serialise concurrent direct IO sub-block zeroing
Message-ID: <20100724000946.GK32635@dastard>
References: <1279881678-1660-1-git-send-email-david@fromorbit.com>
	<4C49EB67.6020509@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C49EB67.6020509@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Fri, Jul 23, 2010 at 02:20:07PM -0500, Eric Sandeen wrote:
> Dave Chinner wrote:
> > Patches for discussion seeing as git.kernel.org is being slow to update.
> > 
> 
> I can confirm that this fixes the qemu problems, too.
> 
> Also makes the install take about 30min vs. 10 ;)

Yeah, that's no surprise - it'll be serialising all the IO even when
it doesn't need to. Good to know that we've found the cause of the
problem, though, so we can work from here towards a more robust
solution.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
