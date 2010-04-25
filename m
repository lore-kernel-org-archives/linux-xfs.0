Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3PD0Jk3004557 for <xfs@oss.sgi.com>; Sun, 25 Apr 2010 08:00:19 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 016348CAD0E
	for <xfs@oss.sgi.com>; Sun, 25 Apr 2010 06:02:18 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id 9EQPnmY1g44ccC93 for
	<xfs@oss.sgi.com>; Sun, 25 Apr 2010 06:02:18 -0700 (PDT)
Date: Sun, 25 Apr 2010 15:02:09 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: xfs_fsr question for improvement
Message-ID: <20100425150209.5167fe96@galadriel.home>
In-Reply-To: <19412.9412.177637.116303@tree.ty.sabi.co.uk>
References: <201004161043.11243@zmi.at> <20100417012415.GE2493@dastard>
	<20100417091357.4e7ad1e0@galadriel.home>
	<19412.9412.177637.116303@tree.ty.sabi.co.uk>
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
To: Peter Grandi <pg_xf2@xf2.for.sabi.co.UK>
Cc: Linux XFS <xfs@oss.sgi.com>

Le Sun, 25 Apr 2010 12:17:24 +0100 vous =E9criviez:

> > my test VMware server (performance dropped down to abysmal
> > level until I set up a daily xfs_fsr cron job),  =

> =

> That should not be the case unless you are using very sparse
> VM image files, in which case you get what you pay for.
> =


This is a development and test VM Ware server, so it hosts lots ( 100
or so) of test VM with sparse image files (when you start a VM to host
a quick test, you don't want to spend 15 minutes initializing the
drives).

> > and a write-intensive video server.  =

> =

> That also should not be the case unless your applications write
> strategy is wrong and you get extremely interleaved streams, in
> which case you get what you paid for the application programmer.

The application write strategy is as simple as possible; several
different machines unaware of every other write huge media files to a
samba share. I don't know how it could be worse, however it could
hardly be enhanced in any way.

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
