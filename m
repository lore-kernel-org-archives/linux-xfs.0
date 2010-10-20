Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9KLR0sv127158 for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 16:27:00 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DF886111091
	for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 14:28:11 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id KihmzhjNaXQwdjP6 for
	<xfs@oss.sgi.com>; Wed, 20 Oct 2010 14:28:11 -0700 (PDT)
Date: Wed, 20 Oct 2010 23:27:58 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Interesting possible XFS crash condition
Message-ID: <20101020232758.51ac507a@galadriel.home>
In-Reply-To: <4CBF3C6C.2020803@dolphinlogic.com>
References: <4CBE887F.6020506@dolphinlogic.com> <201010201012.39778@zmi.at>
	<4CBF3C6C.2020803@dolphinlogic.com>
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
To: Shawn Usry <shawn@dolphinlogic.com>
Cc: xfs@oss.sgi.com

Le Wed, 20 Oct 2010 14:01:00 -0500 vous =E9criviez:

> 2.  I did upgrade the firmware on the controller to a newer version =

> AFTER the issue appeared, hoping this would resolve it.  Same results.
> =

> At this point I'm leaning toward faulty hardware somewhere.

Another possibility is a memory problem, possibly making the machine
crash under heavy load; if most RAM is used as filesystem caching, this
maybe may lead to apparently xfs related errors. You could try running
memtest86+ on the system for a couple of hours.

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
