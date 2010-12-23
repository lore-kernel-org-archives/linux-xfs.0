Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBNLh16j255800 for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 15:43:02 -0600
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E12AC147E73F
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 13:44:58 -0800 (PST)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id RxnWSPTniNGpidmG for
	<xfs@oss.sgi.com>; Thu, 23 Dec 2010 13:44:58 -0800 (PST)
Date: Thu, 23 Dec 2010 22:44:45 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: able to mount a fs, unable to repair it
Message-ID: <20101223224445.12ce6dde@galadriel.home>
In-Reply-To: <87zkrws2pa.fsf@ezri.u-picardie.fr>
References: <87r5d9uuez.fsf@ezri.u-picardie.fr>
	<20101223183531.19464601@galadriel.home>
	<87zkrws2pa.fsf@ezri.u-picardie.fr>
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
To: laurent+xfs@u-picardie.fr
Cc: xfs@oss.sgi.com

Le Thu, 23 Dec 2010 20:34:41 +0100 vous =E9criviez:

> > My advice : software RAID stinks under high CPU load/ high IO. Use
> > hardware RAID whenever possible because it provides more predictable
> > performance and remove many weird software interactions from the
> > picture.  =

> =

> The 3w9550sx doesn't raid6, but I admit I've been thinking of using
> its raid5 instead of the slow soft raid6.

Ah that's a valid reason :) RAID-5 is reasonable with disks under 1TB
and arrays up to 6 TB. Further it's a bet against the law of physics :)

However, a reliable RAID-5 is probably safer than an experimental
RAID-6 overall :)

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
