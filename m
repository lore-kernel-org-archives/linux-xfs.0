Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D6B8B7CA1
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 15:21:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4D07BAC002
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 13:21:54 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id cvBRD9GhTTB5hmZC for <xfs@oss.sgi.com>;
	Thu, 07 Apr 2016 13:21:48 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 1A705142D
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 15:21:43 -0500 (CDT)
Subject: Re: Determining whether stripe unit and stripe size were detected
	correctly
References: <5BDD118B6525E24D82051EDA520EB5FC0105339D@IS-EXMB07-RP.ad.reyrey.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5706C157.5070400@sandeen.net>
Date: Thu, 7 Apr 2016 15:21:43 -0500
MIME-Version: 1.0
In-Reply-To: <5BDD118B6525E24D82051EDA520EB5FC0105339D@IS-EXMB07-RP.ad.reyrey.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com



On 4/7/16 3:16 PM, Simpson, John R wrote:
> Greetings,
> =

>  =

> =

>                 I=92m in the process of tracking down lower than expected=
 performance and occasional blocked tasks on some internal file servers wit=
h XFS datastores.  Several sources have pointed out the importance of using=
 the correct stripe unit and stripe size when formatting and mounting XFS f=
ilesystems, and that XFS can detect these values for some, but not all, har=
dware RAID controllers.  The servers in question are PowerEdge R510b server=
s with PERC H700 controllers.  Datastores are RAID5 with a 128K stripe.
>                 Is there any way to determine if the stripe unit and stri=
pe size were detected correctly?  These values were not specified when the =
filesystems were formatted or mounted.  If they were not detected, is there=
 any way to determine them programmatically?
>                 If this is not the correct forum for this question please=
 point me in the right direction.
> =

>  =

> =

> Best regards,

> # xfs_info /DS01
> =

> meta-data=3D/dev/sdb1              isize=3D256    agcount=3D5, agsize=3D2=
68435455 blks
>          =3D                       sectsz=3D512   attr=3D2, projid32bit=
=3D0
> data     =3D                       bsize=3D4096   blocks=3D1212415488, im=
axpct=3D5
>          =3D                       sunit=3D0      swidth=3D0 blks

sunit =3D=3D swidth =3D=3D 0, so no geometry is present on this filesystem.

> naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
> log      =3Dinternal               bsize=3D4096   blocks=3D521728, versio=
n=3D2
>          =3D                       sectsz=3D512   sunit=3D0 blks, lazy-co=
unt=3D1
> realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=
=3D0

mkfs.xfs uses values exported by the block device, and can be seen by using
blockdev to query them, i.e.

blockdev --getiomin --getioopt /dev/sdb1

If it returns 0, no geometry is exported by the device, and you'd need to u=
se
your own knowledge of the device to set appropriate values (and to properly
partition on aligned boundaries as well)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
