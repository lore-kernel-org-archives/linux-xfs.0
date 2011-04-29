Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3TGPGu2071299 for <xfs@oss.sgi.com>; Fri, 29 Apr 2011 11:25:16 -0500
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C58F51B800C5
	for <xfs@oss.sgi.com>; Fri, 29 Apr 2011 09:28:49 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id 2CtI6KtZfWcJyZDW for
	<xfs@oss.sgi.com>; Fri, 29 Apr 2011 09:28:49 -0700 (PDT)
Subject: Re: xfs performance problem
From: Martin Steigerwald <Martin@lichtvoll.de>
Date: Fri, 29 Apr 2011 18:28:45 +0200
MIME-Version: 1.0
Message-Id: <201104291828.46420.Martin@lichtvoll.de>
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
To: xfs@oss.sgi.com, Dave Chinner <david@fromorbit.com>
Cc: Benjamin Schindler <bschindler@inf.ethz.ch>

sorry, forgot to cc.

Am Mittwoch, 27. April 2011 schrieb Dave Chinner:
> On Tue, Apr 26, 2011 at 09:44:04PM +0200, Benjamin Schindler wrote:
> > Hi
> > 
> > Since upgrading to newer kernels I have serious problems with xfs
> > performance on my root fs.
> > It runs on a software raid 0 with 2 disks. On the same two disks,
> > there are two more partitions running a software raid-1 with ext3.
> > On the ext3 system, I have no issue, so I assume the drives are
> > fine.
> > But on the xfs filesystem, extracting a linux kernel archive takes 5
> > minutes or more, running ldconfig similarily long. The harddrives are
> > sata-2.
> > I'm running gentoo linux with kernel 2.6.38-gentoo-r1. I'm attaching
> > the kernel config but I guess more info is needed - just let me know
> > what is needed.
> 
> more than likely your problem is that barriers have been enabled for
> MD/DM devices on the new kernel, and they aren't on the old kernel.
> XFS uses barriers by default, ext3 does not. Hence XFS performance
> will change while ext3 will not. Check dmesg output when mounting
> the filesystems on the different kernels.

But didn't 2.6.38 replace barriers by explicit flushes the filesystem has to 
wait for - mitigating most of the performance problems with barriers?

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
