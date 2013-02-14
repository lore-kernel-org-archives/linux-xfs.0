Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6779E8002
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 08:48:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EED40AC002
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 06:48:45 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id 2GoJBXII2JQ1Z4So for
	<xfs@oss.sgi.com>; Thu, 14 Feb 2013 06:48:44 -0800 (PST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: [PATCH] xfs_mkfs: wipe old signatures from the device
Date: Thu, 14 Feb 2013 15:48:41 +0100
References: <1360667215-14701-1-git-send-email-lczerner@redhat.com>
	<alpine.LFD.2.00.1302140929570.2315@(none)>
	<20130214110423.GN26694@dastard>
	(sfid-20130214_122246_817720_6973E5AA)
In-Reply-To: <20130214110423.GN26694@dastard>
MIME-Version: 1.0
Message-Id: <201302141548.42185.Martin@lichtvoll.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-btrfs@vger.kernel.org
Cc: sandeen@redhat.com, xfs@oss.sgi.com, Karel Zak <kzak@redhat.com>, Zach Brown <zabrown@redhat.com>, =?utf-8?q?Luk=C3=A1=C5=A1_Czerner?= <lczerner@redhat.com>, Chris Murphy <lists@colorremedies.com>

Am Donnerstag, 14. Februar 2013 schrieb Dave Chinner:
> > So I
> > think that it got to the point where users will usually use mkfs.xfs
> > -f all the time. And even if they did not and they would use a wrong
> > device they would probably get the same warning even for the device
> > they wanted to use in the first place.
> 
> I get a couple of queries a year from people saying they
> accidentally ran mkfs.ext4 on the wrong device and want to know if
> they can recover their XFS filesystem. The next question is usually
> "why didn't mkfs.ext4 warn me there was an existing filesystem on
> the device like mkfs.xfs does?".
> 
> That is why the "don't overwrite an existing filesystem by default"
> behaviour is important. Users like to be protected from mistakes
> they weren't aware they made, and far too few of our filesystem
> utilities provide that safety net.
> 
> A couple of users a year losing data like this is a couple of users
> too many. Especially when it would only take a couple of hours of
> your time to implement....
> 
> > So even thoug it might help in some cases I do not think that we
> > should go and change all file systems to do that as well, it would
> > not be very useful anyway.
> 
> Tell that to the next user that trashes their data because a
> filesystem tool simply assumed in correctly that it owned the block
> device.

Full ACK.

I always loved that mkfs.xfs asks in that case.

IMO its just sane to do so.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
