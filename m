Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAO7hKTH078708 for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 01:43:20 -0600
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D7FFE1A122B
	for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 23:44:55 -0800 (PST)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id KALXy4xY9VRF5iWD for
	<xfs@oss.sgi.com>; Tue, 23 Nov 2010 23:44:55 -0800 (PST)
Date: Wed, 24 Nov 2010 08:44:43 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Xfs delaylog hanged up
Message-ID: <20101124084443.2968d63f@galadriel.home>
In-Reply-To: <4CEC5E15.7080307@shiftmail.org>
References: <4CEAC412.9000406@shiftmail.org> <20101122232929.GJ13830@dastard>
	<4CEBA2D5.2020708@shiftmail.org> <20101123204609.GW22876@dastard>
	<20101123234811.0ea3c41c@galadriel.home>
	<4CEC5E15.7080307@shiftmail.org>
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
To: Spelic <spelic@shiftmail.org>
Cc: xfs@oss.sgi.com

Le Wed, 24 Nov 2010 01:36:37 +0100 vous =E9criviez:

> What would be the advantage of using hardware raid?

More predictable performance under heavy load (nfs kernel server,
typically). BTW the 3Ware is not a very good sata controller; I've found
that it is actually one of the worst of its class when it comes to
IOPS, the Areca 16xx, LSI Megaraid and Adaptec 5xx5 all perform better
as simple controllers in combination with MD (tested with 8 SSDs).

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
