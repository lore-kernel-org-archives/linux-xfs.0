Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q75B6xaw195460 for <xfs@oss.sgi.com>; Sun, 5 Aug 2012 06:06:59 -0500
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id KdousH1z6UI1aGkV for
	<xfs@oss.sgi.com>; Sun, 05 Aug 2012 04:06:58 -0700 (PDT)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: xfs_growfs / planned resize / performance impact
Date: Sun, 5 Aug 2012 13:06:56 +0200
References: <5017E426.2040709@profihost.ag> <20120804224336.GS2877@dastard>
	<C4E0639A-87DE-4D38-8097-9B71D0947ABE@profihost.ag>
	(sfid-20120805_095300_150817_93C5E635)
In-Reply-To: <C4E0639A-87DE-4D38-8097-9B71D0947ABE@profihost.ag>
MIME-Version: 1.0
Message-Id: <201208051306.56937.Martin@lichtvoll.de>
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
Cc: Stefan Priebe <s.priebe@profihost.ag>

Am Sonntag, 5. August 2012 schrieb Stefan Priebe:
> Am 05.08.2012 um 00:43 schrieb Dave Chinner <david@fromorbit.com>:
> > On Tue, Jul 31, 2012 at 03:56:54PM +0200, Stefan Priebe - Profihost AG 
wrote:
> >> Hello list,
> >> 
> >> i'm planning to create a couple of VMs with just 30GB of space while
> >> using xfs as the main filesystem.
> >> 
> >> Now i alreay know that some of the VMs will grow up to 250GB while
> >> resizing the block device and using xfs_growfs.
> > 
> > Just use thin provisioning and make it 250GB to begin with. Thin
> > provisioning mades filsystem grow/shrink pretty much redundant....
> 
> But dm thin isn't stable isn't it? Does xfs reallocate used parts of
> the block Device before using new parts? Otherwise deleting and
> recreating files will result in full used space pretty fast.

A periodic fstrim might help if the TRIM/DISCARD is supported in all 
layers. And whether it is is a good question that depends on well where 
your data is stored and what layers in the kernel are involved in storing 
it and the kernel version of course.

> >> Is it a problem if this grow will happen in small portions (30GB =>
> >> 50GB => 75GB => 100GB => ... 300GB)?
> > 
> > Growing a filesystem by an order of magnitude is the limit of what
> > I'd suggest is sane. Growing it by two orders of magnitude
> > (espcially if you start with a 16 AG filesystem because of stripe
> > alignment) is going to cause problems with the number of AGs and
> > the subsequent freespace management scale issue....
> 
> I would start with ag=4 and end up in ag 48 in my tests.

Thats IMHO quite much for upto 500 GiB. But it still depends on what kind 
of storage this is located.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
