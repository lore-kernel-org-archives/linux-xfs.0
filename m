Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1NEiAtW065594 for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 08:44:10 -0600
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 269D02F5A3C
	for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 06:46:52 -0800 (PST)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id sTgS7BCKlyCi6QZv for
	<xfs@oss.sgi.com>; Wed, 23 Feb 2011 06:46:52 -0800 (PST)
Date: Wed, 23 Feb 2011 15:46:51 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS corruption on 3ware RAID6-volume
Message-ID: <20110223154651.54f0a8dc@harpe.intellique.com>
In-Reply-To: <AANLkTinWByYooMnPL7BryPowDexBeiHJdh3aVh+fdm-a@mail.gmail.com>
References: <AANLkTinWByYooMnPL7BryPowDexBeiHJdh3aVh+fdm-a@mail.gmail.com>
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

Le Wed, 23 Feb 2011 14:27:27 +0100
Erik Gulliksson <erik@gulliksson.org> =E9crivait:

> I have bumped in to a corruption problem with one a XFS filesystems.
> The filesystem lives on a RAID6-volume on a 3ware 9650SE-24M8 with
> battery backup and writecache enabled.

What firmware version are you using?

( tw_cli /cX show firmware )

> RAID6-configuration is 11 2.0TB
> WD15EARS disks and the volume is reported as OK by the RAID-card.

Augh. That sounds pretty bad. What does " tw_cli /cX/uY show all" look
like?

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
