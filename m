Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9RBO5ZR162168 for <xfs@oss.sgi.com>; Wed, 27 Oct 2010 06:24:05 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ABED71299DF
	for <xfs@oss.sgi.com>; Wed, 27 Oct 2010 04:14:26 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id ZX6FWCTD0BJXSGaf for
	<xfs@oss.sgi.com>; Wed, 27 Oct 2010 04:14:26 -0700 (PDT)
Date: Wed, 27 Oct 2010 13:14:23 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Pid: 8345, comm: rsync Not tainted 2.6.32.22intel #1
Message-ID: <20101027131423.3b2ab381@harpe.intellique.com>
In-Reply-To: <4CC7FD77.7030706@profihost.ag>
References: <4CC67450.9020602@profihost.ag> <4CC6B56B.7020007@profihost.ag>
	<20101026132505.6af29d5d@harpe.intellique.com>
	<201010270124.44846@zmi.at>
	<20101027080454.31a59a3c@galadriel.home>
	<4CC7CDF6.3080405@profihost.ag>
	<20101027120628.7b4b2e20@harpe.intellique.com>
	<4CC7FA39.4030502@profihost.ag>
	<20101027121240.4e8ca83a@harpe.intellique.com>
	<4CC7FD77.7030706@profihost.ag>
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
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

Le Wed, 27 Oct 2010 12:22:47 +0200
Stefan Priebe - Profihost AG <s.priebe@profihost.ag> =E9crivait:

>  > Yes, the initiator values are more important here. Basically, the
>  > iscsitarget service should transmit the initiator's requests as
>  > they come.  =

> What do you mean by this sentence? Sorry no native english speaker.

The settings that you apply on the initiator side are sent to the
target ; the target applies them to the underlying device.

This is valid only when exporting a block device (lv, partition), it
wouldn't work the same for fileio.

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
