Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4CHGL3k196889 for <xfs@oss.sgi.com>; Sat, 12 May 2012 12:16:21 -0500
Received: from zarafa14.zmi.at (zarafa14.zmi.at [212.69.164.59]) by
	cuda.sgi.com with ESMTP id F11fAqRt0FUvjoxy (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 12 May 2012 10:16:18 -0700 (PDT)
Subject: Re: badly destroyed XFS (on LVM) - how to repair?
From: =?windows-1252?Q?Michael_Monnerie?=
	<michael.monnerie@is.it-management.at>
Date: Sat, 12 May 2012 19:16:16 +0200
Mime-Version: 1.0
Message-Id: <vmime.4fae9ae0.550.78dcfc20f42c98e0@zarafa14.zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: =?windows-1252?Q? Emmanuel_Florac ?= <eflorac@intellique.com>
Cc: "=?windows-1252?Q? xfs=40oss.sgi.com ?=" <xfs@oss.sgi.com>

I even rebooted the server, because a "vgchange -ay" hangs that session. St=
ill after the reboot it does this, I can't go around this. =


So if lvm is correct, then xfs_repair and xfs_metadump have a problem, as t=
hey both seem to not work correctly here. =


Vom iPhone gesendet, bitte Tippfehler zu entschuldigen.
Michael Monnerie
+436604156531

Am 12.05.2012 um 15:43 schrieb "Emmanuel Florac" <eflorac@intellique.com>:

> Le Sat, 12 May 2012 14:49:56 +0200 vous =E9criviez:
> =

>> The volume is accessible only via /dev/dm-0, it seems this might be
>> my problem?
> =

> Did you restart the LVM service to reassemble everything properly? So
> far you've done everything I would have thought of...
> =

> -- =

> ------------------------------------------------------------------------
> Emmanuel Florac     |   Direction technique
>                    |   Intellique
>                    |    <eflorac@intellique.com>
>                    |   +33 1 78 94 84 02
> ------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
