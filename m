Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9QBjpni069216 for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 06:45:51 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0C105125AEC
	for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 04:47:07 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id O1W3FyWwZte74z2L for
	<xfs@oss.sgi.com>; Tue, 26 Oct 2010 04:47:07 -0700 (PDT)
Date: Tue, 26 Oct 2010 13:47:03 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Pid: 8345, comm: rsync Not tainted 2.6.32.22intel #1
Message-ID: <20101026134703.3f06cfda@harpe.intellique.com>
In-Reply-To: <CFFC47E79E870F4EBAD0CA24D8CD7652ED04A5F7F8@CRW-EXM01.int.cggveritas.com>
References: <4CC67450.9020602@profihost.ag>
	<20101026092205.086c0d89@galadriel.home>
	<4CC68249.7050409@profihost.ag>
	<20101026094111.48670eb7@galadriel.home>
	<4CC688FE.7010206@profihost.ag>
	<20101026130103.7cc43aec@harpe.intellique.com>
	<4CC6B56B.7020007@profihost.ag>
	<CFFC47E79E870F4EBAD0CA24D8CD7652ED04A5F7F8@CRW-EXM01.int.cggveritas.com>
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
To: Tore =?ISO-8859-1?Q?H=F8ivaag?= <tore.hoivaag.larsen@cggveritas.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Stefan Priebe - Profihost AG <s.priebe@profihost.ag>

Le Tue, 26 Oct 2010 12:30:22 +0100
Larsen, Tore H=F8ivaag <tore.hoivaag.larsen@cggveritas.com> =E9crivait:

> You should keep the driver and firmware ins sync wither kernel.
> Choose e.g. latest 9.4.3 iso for 2.6.9, and 9.5.3 for
> RHEL5/SLES11/Fedora13. Do not use 9.5.3 firmware with RHEL4/SLES10
> native driver. If I remeber correctly tw_update doesn't even let you
> mix a downgrade driver with new firmware, and vs.versus.

Yes, it will complain in case your driver/api isn't compatible with the
newer firmware. Of course, only actually upgrade if it tells you :
"proceed to update".

However I'm pretty sure 2.6.23 is safe for 4.x firmware (2.6.24
definitely is).

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
