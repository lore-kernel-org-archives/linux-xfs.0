Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1OGKRve064022 for <xfs@oss.sgi.com>; Fri, 24 Feb 2012 10:20:27 -0600
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id l24VEIH29fHHMZ1O for
	<xfs@oss.sgi.com>; Fri, 24 Feb 2012 08:20:26 -0800 (PST)
Received: from merkaba.localnet (ppp-93-104-130-114.dynamic.mnet-online.de
	[93.104.130.114])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 0ED2FB4
	for <xfs@oss.sgi.com>; Fri, 24 Feb 2012 17:20:24 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: creating a new 80 TB XFS
Date: Fri, 24 Feb 2012 17:20:23 +0100
References: <4F478818.4050803@cape-horn-eng.com>
	<20120224150805.243e4906@harpe.intellique.com>
	<4F47B020.4000202@cape-horn-eng.com>
	(sfid-20120224_171032_352286_A09775B9)
In-Reply-To: <4F47B020.4000202@cape-horn-eng.com>
MIME-Version: 1.0
Message-Id: <201202241720.23581.Martin@lichtvoll.de>
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

Am Freitag, 24. Februar 2012 schrieb Richard Ems:
> >> MOUNT
> >> On mount I will use the options
> >> 
> >> mount -o noatime,nobarrier,nofail,logbufs=8,logbsize=256k,inode64
> >> /dev/sdX1 /mount_point
> >
> > 
> >
> > I think that the logbufs/logbsize option matches the default here.
> > Use delaylog if applicable. See the xfs FAQ.
> 
> Yes, if I trust the mount manual page, it states "The default value is
> 8 buffers for any recent kernel." . I suppose 3.2.6 is "a recent
> kernel", so this could be avoided, but having it explicitly on the
> mkfs.xfs line does not hurt, or?
> And for logbsize: "The default value for any recent kernel is 32768."
> 
> But then at the end of the manual page for mount it says "December
> 2004", so how actual is this information? Can the default mount values
> be shown by running mount with some verbose and dry-run parameters?

Does cat /proc/mounts show them? /proc/mounts is more detailed than mount 
or mount -l.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
