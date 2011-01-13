Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0DMXP4K190634 for <xfs@oss.sgi.com>; Thu, 13 Jan 2011 16:33:25 -0600
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D2F2626344E
	for <xfs@oss.sgi.com>; Thu, 13 Jan 2011 14:35:37 -0800 (PST)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id BZDOeeLqXwt5Sdfr for
	<xfs@oss.sgi.com>; Thu, 13 Jan 2011 14:35:37 -0800 (PST)
Date: Thu, 13 Jan 2011 23:35:27 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: extremely slow write performance plaintext
Message-ID: <20110113233527.6dca104d@galadriel.home>
In-Reply-To: <3205_1294953756_4D2F6D1C_3205_1943_1_4D2F6D1C.2060409@davisvision.com>
References: <3205_1294953756_4D2F6D1C_3205_1943_1_4D2F6D1C.2060409@davisvision.com>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Cory Coager <ccoager@davisvision.com>
Cc: xfs@oss.sgi.com

Le Thu, 13 Jan 2011 16:22:36 -0500 vous =E9criviez:

>  I am getting over =

> 180MB/s read speeds and 40MB/s write speeds on all the LV's except
> one. =


This is pretty bad. My last 14 SAS drives RAID-6 array achieved 500
MB/s write, 1GB/s read sustained. What is the SAS controller? the RAID
controller? Please provide more details about the =

enclosure/drives/cabling too.

What is the kernel/distro? Did you striped your LVs across multiple
physical volumes except the last one? What's the output for pvdisplay,
vgdisplay, lvdisplay?

-- =

------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
