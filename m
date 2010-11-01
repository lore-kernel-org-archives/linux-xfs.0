Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA13dAto162480 for <xfs@oss.sgi.com>; Sun, 31 Oct 2010 22:39:10 -0500
Received: from ucsc.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C6829137AF8C
	for <xfs@oss.sgi.com>; Sun, 31 Oct 2010 20:56:34 -0700 (PDT)
Received: from ucsc.edu (email-prod-out-1.ucsc.edu [128.114.129.85]) by
	cuda.sgi.com with ESMTP id cL03zVMrP73RJKvg for
	<xfs@oss.sgi.com>; Sun, 31 Oct 2010 20:56:34 -0700 (PDT)
Subject: Re: xfs_repair of critical volume
Mime-Version: 1.0 (Apple Message framework v1081)
From: Eli Morris <ermorris@ucsc.edu>
In-Reply-To: <20101031214021.686f43b8@galadriel.home>
Date: Sun, 31 Oct 2010 20:40:20 -0700
Message-Id: <1A57C61E-463F-4CB4-967C-DD6B66857E28@ucsc.edu>
References: <C17C2CB6-A695-41B2-B12A-1CBF6DAD556F@ucsc.edu>
	<20101031214021.686f43b8@galadriel.home>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com


On Oct 31, 2010, at 1:40 PM, Emmanuel Florac wrote:

> Le Sun, 31 Oct 2010 12:56:33 -0700 vous =E9criviez:
> =

>> OK, that's a long tale of woe. Thanks for any advise. =

> =

> oK, so what we'd like to do is get the backup RAID volume back in
> working order. You said it's made of 2TB Caviar green drives, but
> didn't mention the RAID controller type... As I understand it, you
> power-cycled the RAID array, so the cache is gone, whatever have been
> in it... =

> =

> All arrays I know will happily reassemble a working RAID if you
> succesfully revive the failed drives.
> =

> Logically the failed drives are almost certainly not really dead, but
> in a temporary failure state mode. First, you must check WD support and
> utilities to see if something may apply to your configuration. Anyway,
> checking the failed drives' health with the western digital disk
> utility should allow you to determine if they're toast or not.
> =

> In the case they're not actually dead, you could try to revive the
> badblocks with Spinrite (www.grc.com), it saved my life a couple of
> times, however it's quite risky when used with SMART-tripped drives.
> =

> -- =

> ------------------------------------------------------------------------
> Emmanuel Florac     |   Direction technique
>                    |   Intellique
>                    |	<eflorac@intellique.com>
>                    |   +33 1 78 94 84 02
> ------------------------------------------------------------------------

Hi,

Thanks for your help. The RAID is a SCSI connected direct attached storage =
16 bay unit made by Maxtronic. It is a Janus 6640, is case that helps anyth=
ing. At the time of its problem, it was mounted read-only as I was trying t=
o be careful of the data, since the main volume failed and this was our onl=
y copy. So maybe the cache isn't a big deal. I'll try the "dead" drives tom=
orrow with a WD utility. I'll give Spinrite a try, if the WD utility doesn'=
t revive them.

thanks a lot for the help. I'll let you all know how things go.

Eli =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
