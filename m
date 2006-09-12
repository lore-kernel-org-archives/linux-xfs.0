Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Sep 2006 23:22:03 -0700 (PDT)
Received: from mail.crc.dk (mail.crc.dk [130.226.184.8])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8C6Loif023087
	for <linux-xfs@oss.sgi.com>; Mon, 11 Sep 2006 23:21:54 -0700
Received: from localhost (localhost [127.0.0.1])
	by mail.crc.dk (8.12.11.20060308/8.12.11) with ESMTP id k8C6LFdb007897
	for <linux-xfs@oss.sgi.com>; Tue, 12 Sep 2006 08:21:15 +0200
Received: from mail.crc.dk ([127.0.0.1])
 by localhost (mail.crc.dk [127.0.0.1]) (amavisd-new, port 10024) with LMTP
 id 16765-10 for <linux-xfs@oss.sgi.com>;
 Tue, 12 Sep 2006 08:21:13 +0200 (CEST)
Received: from [130.226.183.100] (mkx.crc.dk [130.226.183.100])
	by mail.crc.dk (8.12.11.20060308/8.12.11) with ESMTP id k8C6L9QX007892
	for <linux-xfs@oss.sgi.com>; Tue, 12 Sep 2006 08:21:09 +0200
Message-ID: <450651D5.2010706@crc.dk>
Date: Tue, 12 Sep 2006 08:21:09 +0200
From: Mogens Kjaer <mk@crc.dk>
MIME-Version: 1.0
Subject: Re: Mounting IRIX disk on Linux
References: <45053B2D.50203@crc.dk> <1157991715.3651.14.camel@xenon.msp.redhat.com>
In-Reply-To: <1157991715.3651.14.camel@xenon.msp.redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Russell Cattelan wrote:
> Was this disk cleanly unmounted from the SGI box?
> 
> If the log is dirty linux won't be able to mount it since it will be
> in the wrong endian format (well assuming you are using a 
> little endian linux box)
> 
> If you can cleanly mount and unmount on the sgi box
> if that is not possible run xfs_repair -L to clear
> the log. But not that will potentially loose important
> file system info.

Some of the disks are dirty, some are clean (the Origin boots,
but halt during the boot phase because of multiple fan failure -
a little strange as all fans are running).

I could mount one of the disks after the xfs_repair -L trick,
but it gave massive file system corruption.

Not a big deal, we have backups of everything.

Mogens
-- 
Mogens Kjaer, Carlsberg A/S, Computer Department
Gamle Carlsberg Vej 10, DK-2500 Valby, Denmark
Phone: +45 33 27 53 25, Fax: +45 33 27 47 08
Email: mk@crc.dk Homepage: http://www.crc.dk
