Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o49FWHQM228970 for <xfs@oss.sgi.com>; Sun, 9 May 2010 10:32:17 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 84E121206652
	for <xfs@oss.sgi.com>; Sun,  9 May 2010 08:34:27 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id UTRKqcHqKX0Tkx81 for
	<xfs@oss.sgi.com>; Sun, 09 May 2010 08:34:27 -0700 (PDT)
Date: Sun, 9 May 2010 17:34:07 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: failed to read root inode
Message-ID: <20100509173407.54467993@galadriel.home>
In-Reply-To: <4BE6CC83.5070305@hardwarefreak.com>
References: <4BE55A63.8070203@purplehaze.ch>
	<4BE5EB5D.5020702@hardwarefreak.com>
	<20100509152818.7481c1e1@galadriel.home>
	<4BE6CC83.5070305@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

Le Sun, 09 May 2010 09:53:55 -0500 vous =E9criviez:

> Oh, btw, when it comes to SATA drives, there is no difference between
> "desktop" and "enterprise" class drives.  They're all the same. =


Yes I know that, however there's an important  difference : the default
firmware setting of desktop drives makes them retry, retry, retry an
retry on error, effectively freezing the array; while "enterprise
drives" simply fails almost instantly at the slightest error (and work
fine 5 minutes later usually).

So a desktop drive failure in a raid array may actually block all IO
for a very long time (like in minutes), and everything goes west if you
then decide that the system must have crashed and pull the plug, if
your RAID controller hasn't any backup battery.

That's why you shouldn't ever use desktop drives in RAID arrays unless
you know how to painfully configure them, one by one, with a friggin
DOS utility ;)

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
