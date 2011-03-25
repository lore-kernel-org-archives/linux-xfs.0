Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2PCrL1K223210 for <xfs@oss.sgi.com>; Fri, 25 Mar 2011 07:53:22 -0500
Message-ID: <4D8C90F6.7050500@dermichi.com>
Date: Fri, 25 Mar 2011 13:56:22 +0100
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 5/6] xfs: register the inode cache shrinker
	before	quotachecks
References: <1300860870-15471-1-git-send-email-david@fromorbit.com>	<1300860870-15471-6-git-send-email-david@fromorbit.com>
	<201103232224.03501.arekm@maven.pl>
In-Reply-To: <201103232224.03501.arekm@maven.pl>
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
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: aelder@sgi.com, xfs@oss.sgi.com

> From: Arkadiusz Miskiewicz <arekm@maven.pl>
> On Wednesday 23 of March 2011, Dave Chinner wrote:
>> From: Dave Chinner <dchinner@redhat.com>
> 
> Thanks a lot for this patch. I was able to mount my two ~800GB filesystems 
> with quota enabled without out of memory/machine reboot suprises (which were 
> happening without this patch every time I tried mount with quota).
Seconded, this also solved my long-standing problems with a Quota mounts
on some 32-bit i686 and low-mem x64 machines.

I tested the patch with Kernel 2.6.38.1-i686 on a ~500GB fs which
refused to mount with quotas for some time now.

Is there any chance that this patch will be integrated/backparted to
older kernels like 2.6.32.x, 2.6.35.x?

thanks,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
