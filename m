Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA1DSLXx213814 for <xfs@oss.sgi.com>; Mon, 1 Nov 2010 08:28:21 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 66703137D58E
	for <xfs@oss.sgi.com>; Mon,  1 Nov 2010 06:45:46 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id oo7MkfDB88GYA5uD for
	<xfs@oss.sgi.com>; Mon, 01 Nov 2010 06:45:46 -0700 (PDT)
Date: Mon, 1 Nov 2010 14:29:33 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Pid: 8345, comm: rsync Not tainted 2.6.32.22intel #1
Message-ID: <20101101142933.4911a30c@galadriel.home>
In-Reply-To: <4CCEB27E.1000605@profihost.ag>
References: <4CC67450.9020602@profihost.ag>
	<20101026092205.086c0d89@galadriel.home>
	<4CC68249.7050409@profihost.ag> <4CCE73C8.8070705@profihost.ag>
	<20101101122751.GL2715@dastard> <4CCEB27E.1000605@profihost.ag>
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
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: xfs@oss.sgi.com

Le Mon, 01 Nov 2010 13:28:46 +0100 vous =E9criviez:

> no, as Emmanuel told me i don't have todo that.

Did you run the "verify" round on the array after the upgrade? That
would rebuild all checksum and insure that the RAID is fully coherent.
If the verify comes out with any message, there is a sloght chance that
the data on disk wasn't entirely coherent or clean.

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
