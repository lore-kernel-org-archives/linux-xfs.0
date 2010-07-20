Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6KEfkwt025406 for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 09:41:46 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2558145BB6A
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 07:44:45 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id iW8W7uVfnnXikV1u for
	<xfs@oss.sgi.com>; Tue, 20 Jul 2010 07:44:45 -0700 (PDT)
Received: from harpe.intellique.com (unknown [82.225.196.72])
	by smtp4-g21.free.fr (Postfix) with ESMTP id 001074C814E
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 16:44:37 +0200 (CEST)
Date: Tue, 20 Jul 2010 16:44:44 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Calculating swidth On A RAID6 Volume
Message-ID: <20100720164444.4c1cef88@harpe.intellique.com>
In-Reply-To: <4C45AF09.5090901@dermichi.com>
References: <3C5E029826A0704DB5998577FCFF46F0094DA1AD69@dagobah>
	<201007201522.39455@zmi.at> <4C45AF09.5090901@dermichi.com>
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
To: xfs@oss.sgi.com

Le Tue, 20 Jul 2010 16:13:29 +0200
Michael Weissenbacher <mw@dermichi.com> =E9crivait:

>  =

> IIRC sunit and swidth are both specified in units of 512 bytes (don't
> ask me why) =


Because this is the disk block size for all disks drives ever made
except the very latest ones (4096 bytes blocks) and the special
RAID-formatted 520 bytes sometimes in use in the past.

> so a sunit value of 512 would mean 256KB stripe size which
> is correct :-)

exactly. Or use su and sw to specify the size in k, m, etc.

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
