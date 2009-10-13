Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9DFksmK125406 for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 10:46:54 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 58D0417792BE
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 08:48:23 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id XWirWGdXEb6DOEL2 for
	<xfs@oss.sgi.com>; Tue, 13 Oct 2009 08:48:23 -0700 (PDT)
Message-ID: <4AD4A140.9010109@sandeen.net>
Date: Tue, 13 Oct 2009 10:48:16 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_force_shutdown
References: <CEBA5E865263FA4D8848D53D92E6A9AE0412EC23@DAKLAK.cybersoft-vn.com>
	<4AD32DED.4050402@sandeen.net>
	<CEBA5E865263FA4D8848D53D92E6A9AE0416AB0B@DAKLAK.cybersoft-vn.com>
	<4AD493FE.6000403@sandeen.net>
	<CEBA5E865263FA4D8848D53D92E6A9AE0416AC5C@DAKLAK.cybersoft-vn.com>
	<4AD49D63.9030609@sandeen.net>
	<CEBA5E865263FA4D8848D53D92E6A9AE0416AC65@DAKLAK.cybersoft-vn.com>
In-Reply-To: <CEBA5E865263FA4D8848D53D92E6A9AE0416AC65@DAKLAK.cybersoft-vn.com>
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
To: Hieu Le Trung <hieult@Cybersoft-VN.com>
Cc: xfs@oss.sgi.com

Hieu Le Trung wrote:

> How to check if barrier is supported in my environment?

There will be a mount-time message if barrier IO fails.

> If it is hardware related issue, it's fine to ignore. But currently
> there's no point to say that it is a hardware issue.

Yes, I think there is:

  <3>ata1.00: speed down requested but no transfer mode left
  <3>ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x10c00000 action 0x2
  <3>ata1.00: tag 0 cmd 0x30 Emask 0x10 stat 0x51 err 0x84 (ATA bus
error)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
