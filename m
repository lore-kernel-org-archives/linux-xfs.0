Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9K9rdSr051119 for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 04:53:39 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C5BFB1E7E442
	for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 02:54:50 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id 3VGx38v95DFRsJ3f for
	<xfs@oss.sgi.com>; Wed, 20 Oct 2010 02:54:50 -0700 (PDT)
Date: Wed, 20 Oct 2010 11:54:46 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Interesting possible XFS crash condition
Message-ID: <20101020115446.5d606b44@harpe.intellique.com>
In-Reply-To: <4CBE887F.6020506@dolphinlogic.com>
References: <4CBE887F.6020506@dolphinlogic.com>
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

Le Wed, 20 Oct 2010 01:13:19 -0500
Shawn Usry <shawn@dolphinlogic.com> =E9crivait:

> The latter statement and observations lead me to believe that perhaps =

> this was simply a yucky controller that was failing under heavy
> I/O.   =


I've set up quite a lot of those RAID cards (about 100) and there is a
significant failure rate on these (much higher than the newer 9650). I
had both cases of bad controller RAM and CPU overheating several times.

Try unmounting the filesystem and start a RAID verify:

tw_cli /cX/uY start verify

This will generate high IO. Check dmesg for controller errors. Try
remounting after a couple of hours of verification. If the controller
is fried, it most probably fail, but shouldn't crash the system.

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
