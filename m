Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6NDlY7e203524 for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 08:47:35 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B31C315C8D83
	for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 06:57:33 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id oG18dMDXiAx622x0 for
	<xfs@oss.sgi.com>; Fri, 23 Jul 2010 06:57:33 -0700 (PDT)
Date: Fri, 23 Jul 2010 15:50:34 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: 4k sector drives
Message-ID: <20100723155034.2a42ccd7@harpe.intellique.com>
In-Reply-To: <20100723133843.GA3397@citd.de>
References: <201007211333.48363.eye.of.the.8eholder@gmail.com>
	<201007230809.28111@zmi.at> <20100723095832.GA23174@infradead.org>
	<201007231259.11714@zmi.at> <4C4994CB.2050200@hardwarefreak.com>
	<20100723133843.GA3397@citd.de>
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
To: Matthias Schniedermeyer <ms@citd.de>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, xfs@oss.sgi.com

Le Fri, 23 Jul 2010 15:38:43 +0200
Matthias Schniedermeyer <ms@citd.de> =E9crivait:

> Only for writes, reads are for practically unaffected.

Sequential writes may be relatively unaffected too; if you write
sequentially a couple of megabytes you'll have only a couple of
additional blocks at the beginning and end of operation.

However random  and small IOs should be seriously hit.

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
