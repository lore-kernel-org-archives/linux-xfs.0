Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1OCBTx7134755 for <xfs@oss.sgi.com>; Thu, 24 Feb 2011 06:11:29 -0600
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 644A22F8E92
	for <xfs@oss.sgi.com>; Thu, 24 Feb 2011 04:14:12 -0800 (PST)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id SoxqdmtotBwQb7gb for
	<xfs@oss.sgi.com>; Thu, 24 Feb 2011 04:14:12 -0800 (PST)
Date: Thu, 24 Feb 2011 13:14:11 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS corruption on 3ware RAID6-volume
Message-ID: <20110224131411.5f9ee7f7@harpe.intellique.com>
In-Reply-To: <AANLkTi=ERpJLUUGWO_0xjecTPV3=w1GmXKBk0-uCch1L@mail.gmail.com>
References: <AANLkTinWByYooMnPL7BryPowDexBeiHJdh3aVh+fdm-a@mail.gmail.com>
	<20110223154651.54f0a8dc@harpe.intellique.com>
	<AANLkTinsfwr5E7KkffwWOweWJLCmaLnLdtYA4g_m--b0@mail.gmail.com>
	<alpine.DEB.2.02.1102231022470.15181@p34.internal.lan>
	<AANLkTi=ERpJLUUGWO_0xjecTPV3=w1GmXKBk0-uCch1L@mail.gmail.com>
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
To: Erik Gulliksson <erik@gulliksson.org>
Cc: xfs@oss.sgi.com

Le Thu, 24 Feb 2011 11:35:30 +0100
Erik Gulliksson <erik@gulliksson.org> =E9crivait:

> If the journal is corrupt, is there anyway to salvage only that part
> so that the log replay will proceed further (ie "xfs_log_repair")?

Your best bet is to try booting a bleeding-edge kernel with the very
latest xfs version. It could possibly go somewhat further (that is, if
the log is not complete garbage).

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
