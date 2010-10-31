Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9VKdFti141917 for <xfs@oss.sgi.com>; Sun, 31 Oct 2010 15:39:15 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 69A4C14127A
	for <xfs@oss.sgi.com>; Sun, 31 Oct 2010 13:40:34 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id CItTAUOKU0qcNaD4 for
	<xfs@oss.sgi.com>; Sun, 31 Oct 2010 13:40:34 -0700 (PDT)
Date: Sun, 31 Oct 2010 21:40:21 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: xfs_repair of critical volume
Message-ID: <20101031214021.686f43b8@galadriel.home>
In-Reply-To: <C17C2CB6-A695-41B2-B12A-1CBF6DAD556F@ucsc.edu>
References: <C17C2CB6-A695-41B2-B12A-1CBF6DAD556F@ucsc.edu>
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
To: Eli Morris <ermorris@ucsc.edu>
Cc: xfs@oss.sgi.com

Le Sun, 31 Oct 2010 12:56:33 -0700 vous =E9criviez:

> OK, that's a long tale of woe. Thanks for any advise. =


oK, so what we'd like to do is get the backup RAID volume back in
working order. You said it's made of 2TB Caviar green drives, but
didn't mention the RAID controller type... As I understand it, you
power-cycled the RAID array, so the cache is gone, whatever have been
in it... =


All arrays I know will happily reassemble a working RAID if you
succesfully revive the failed drives.

Logically the failed drives are almost certainly not really dead, but
in a temporary failure state mode. First, you must check WD support and
utilities to see if something may apply to your configuration. Anyway,
checking the failed drives' health with the western digital disk
utility should allow you to determine if they're toast or not.

In the case they're not actually dead, you could try to revive the
badblocks with Spinrite (www.grc.com), it saved my life a couple of
times, however it's quite risky when used with SMART-tripped drives.

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
