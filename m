Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6RAiqx6180067 for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 05:44:52 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B1D5047582D
	for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 03:47:55 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id mBaJEZJbc16ourrN for
	<xfs@oss.sgi.com>; Tue, 27 Jul 2010 03:47:55 -0700 (PDT)
Date: Tue, 27 Jul 2010 12:47:50 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: High latencies writing to a memory mapped file
Message-ID: <20100727124750.30bb3209@harpe.intellique.com>
In-Reply-To: <20100727092452.GA23307@citd.de>
References: <20100722144706.GA2840@BohrerMBP.rgmadvisors.com>
	<20100727092452.GA23307@citd.de>
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
Cc: Shawn Bohrer <shawn.bohrer@gmail.com>, xfs@oss.sgi.com

Le Tue, 27 Jul 2010 11:24:52 +0200
Matthias Schniedermeyer <ms@citd.de> =E9crivait:

> In case anybody has an idea what i could do to identify and/or
> isolate the root-cause, i'm open for suggestions.
> =


I'd thought that the io scheduler is the culprit. I've generally found
that the default CFQ scheduler (default) is terrible for file servers.

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
