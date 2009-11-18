Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAICKm70153883 for <xfs@oss.sgi.com>; Wed, 18 Nov 2009 06:20:49 -0600
Received: from wombat.diezmil.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DBE5C96851
	for <xfs@oss.sgi.com>; Wed, 18 Nov 2009 04:21:10 -0800 (PST)
Received: from wombat.diezmil.com (aa.81.b6.static.xlhost.com
	[207.182.129.170]) by cuda.sgi.com with ESMTP id
	J65kRDqDdPvf03EK for <xfs@oss.sgi.com>;
	Wed, 18 Nov 2009 04:21:10 -0800 (PST)
Received: from wombat (wombat [127.0.0.1])
	by wombat.diezmil.com (8.14.2/8.14.2) with ESMTP id nAICL8Xk015307
	for <xfs@oss.sgi.com>; Wed, 18 Nov 2009 07:21:08 -0500
Date: Wed, 18 Nov 2009 07:21:08 -0500
From: oferh@marvell.com
Message-ID: <14274282.01258546868484.JavaMail.root@wombat>
Subject: XFS support for ARMv5
MIME-Version: 1.0
Reply-To: oferh@marvell.com
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

Hi,

I have noticed that XFS on ARMv5TE with latest kernel (2.6.31.6) fails to mount after copying some data and reboot the system.

I get "mount: /dev/sda1: can't read superblock", I understand that there were some problems with virtual aliasing that was added to XFS some time ago but ARM arch has not dealt with this properly.

Is there any patch for this bug?

xfsprogs version used: 2.10.2

-Ofer

--
This message was sent on behalf of oferh@marvell.com at openSubscriber.com
http://www.opensubscriber.com/messages/xfs@oss.sgi.com/topic.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
