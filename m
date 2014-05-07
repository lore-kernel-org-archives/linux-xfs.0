Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 794AE7F52
	for <xfs@oss.sgi.com>; Wed,  7 May 2014 07:43:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4C1D8304059
	for <xfs@oss.sgi.com>; Wed,  7 May 2014 05:43:52 -0700 (PDT)
Received: from mail-ob0-f178.google.com (mail-ob0-f178.google.com
	[209.85.214.178]) by cuda.sgi.com with ESMTP id
	mMkNoDKYPdfAxKoZ (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 07 May 2014 05:43:49 -0700 (PDT)
Received: by mail-ob0-f178.google.com with SMTP id va2so1108890obc.9
	for <xfs@oss.sgi.com>; Wed, 07 May 2014 05:43:48 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 7 May 2014 14:43:47 +0200
Message-ID: <CAPrERe02bfrW6+5c+oZPgd9c_7AUx=BEUcAOAj2dT_iYn=P_1w@mail.gmail.com>
Subject: Alignment: XFS + LVM2
From: Marc Caubet <mcaubet@pic.es>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6601206009612850419=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============6601206009612850419==
Content-Type: multipart/alternative; boundary=089e0111bce03d2fa104f8ceb7c7

--089e0111bce03d2fa104f8ceb7c7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi all,

I am trying to setup a storage pool with correct disk alignment and I hope
somebody can help me to understand some unclear parts to me when
configuring XFS over LVM2.

Actually we have few storage pools with the following settings each:

- LSI Controller with 3xRAID6
- Each RAID6 is configured with 10 data disks + 2 for double-parity.
- Each disk has a capacity of 4TB, 512e and physical sector size of 4K.
- 3x(10+2) configuration was considered in order to gain best performance
and data safety (less disks per RAID less probability of data corruption)

>From the O.S. side we see:

[root@stgpool01 ~]# fdisk -l /dev/sda /dev/sdb /dev/sdc

Disk /dev/sda: 40000.0 GB, 39999997214720 bytes
255 heads, 63 sectors/track, 4863055 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk identifier: 0x00000000

Disk /dev/sdb: 40000.0 GB, 39999997214720 bytes
255 heads, 63 sectors/track, 4863055 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk identifier: 0x00000000

Disk /dev/sdc: 40000.0 GB, 39999997214720 bytes
255 heads, 63 sectors/track, 4863055 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk identifier: 0x00000000

The idea is to aggregate the above devices and show only 1 storage space.
We did as follows:

vgcreate dcvg_a /dev/sda /dev/sdb /dev/sdc
lvcreate -i 3 -I 4096 -n dcpool -l 100%FREE -v dcvg_a

Hence, stripe of the 3 RAID6 in a LV.

And here is my first question: How can I check if the storage and the LV
are correctly aligned?

On the other hand, I have formatted XFS as follows:

mkfs.xfs -d su=3D256k,sw=3D10 -l size=3D128m,lazy-count=3D1 /dev/dcvg_a/dcp=
ool

So my second question is, are the above 'su' and 'sw' parameters correct on
the current LV configuration? If not, which values should I have and why?
AFAIK su is the stripe size configured in the controller side, but in this
case we have a LV. Also, sw is the number of data disks in a RAID, but
again, we have a LV with 3 stripes, and I am not sure if the number of data
disks should be 30 instead.

Thanks a lot,
--=20
Marc Caubet Serrabou
PIC (Port d'Informaci=C3=B3 Cient=C3=ADfica)
Campus UAB, Edificio D
E-08193 Bellaterra, Barcelona
Tel: +34 93 581 33 22
Fax: +34 93 581 41 10
http://www.pic.es
Avis - Aviso - Legal Notice: http://www.ifae.es/legal.html

--089e0111bce03d2fa104f8ceb7c7
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi all,<br><br>I am trying to setup a storage pool with co=
rrect disk alignment and I hope somebody can help me to understand some unc=
lear parts to me when configuring XFS over LVM2.<br><br>Actually we have fe=
w storage pools with the following settings each:<br>
<br>- LSI Controller with 3xRAID6<br>- Each RAID6 is configured with 10 dat=
a disks + 2 for double-parity.<br>- Each disk has a capacity of 4TB, 512e a=
nd physical sector size of 4K.<br>- 3x(10+2) configuration was considered i=
n order to gain best performance and data safety (less disks per RAID less =
probability of data corruption)<br>
<br>From the O.S. side we see:<br><br><span style=3D"font-family:courier ne=
w,monospace">[root@stgpool01 ~]# fdisk -l /dev/sda /dev/sdb /dev/sdc<br><br=
>Disk /dev/sda: 40000.0 GB, 39999997214720 bytes<br>255 heads, 63 sectors/t=
rack, 4863055 cylinders<br>
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes<br>Sector size (logica=
l/physical): 512 bytes / 4096 bytes<br>I/O size (minimum/optimal): 4096 byt=
es / 4096 bytes<br>Disk identifier: 0x00000000<br><br>Disk /dev/sdb: 40000.=
0 GB, 39999997214720 bytes<br>
255 heads, 63 sectors/track, 4863055 cylinders<br>Units =3D cylinders of 16=
065 * 512 =3D 8225280 bytes<br>Sector size (logical/physical): 512 bytes / =
4096 bytes<br>I/O size (minimum/optimal): 4096 bytes / 4096 bytes<br>Disk i=
dentifier: 0x00000000<br>
<br>Disk /dev/sdc: 40000.0 GB, 39999997214720 bytes<br>255 heads, 63 sector=
s/track, 4863055 cylinders<br>Units =3D cylinders of 16065 * 512 =3D 822528=
0 bytes<br>Sector size (logical/physical): 512 bytes / 4096 bytes<br>I/O si=
ze (minimum/optimal): 4096 bytes / 4096 bytes<br>
Disk identifier: 0x00000000<br></span><br>The idea is to aggregate the abov=
e devices and show only 1 storage space. We did as follows:<br><span style=
=3D"font-family:courier new,monospace"><br>vgcreate dcvg_a /dev/sda /dev/sd=
b /dev/sdc<br>
lvcreate -i 3 -I 4096 -n dcpool -l 100%FREE -v dcvg_a<br></span><br>Hence, =
stripe of the 3 RAID6 in a LV.<br><br>And here is my first question: How ca=
n I check if the storage and the LV are correctly aligned?<br><br>On the ot=
her hand, I have formatted XFS as follows:<br>
<br><span style=3D"font-family:courier new,monospace">mkfs.xfs -d su=3D256k=
,sw=3D10 -l size=3D128m,lazy-count=3D1 /dev/dcvg_a/dcpool</span><br><br>So =
my second question is, are the above &#39;su&#39; and &#39;sw&#39; paramete=
rs correct on the current LV configuration? If not, which values should I h=
ave and why? AFAIK su is the stripe size configured in the controller side,=
 but in this case we have a LV. Also, sw is the number of data disks in a R=
AID, but again, we have a LV with 3 stripes, and I am not sure if the numbe=
r of data disks should be 30 instead.<br>
<br>Thanks a lot,<br>-- <br>Marc Caubet Serrabou<br>PIC (Port d&#39;Informa=
ci=C3=B3 Cient=C3=ADfica)<br>Campus UAB, Edificio D<br>E-08193 Bellaterra, =
Barcelona<br>Tel: +34 93 581 33 22<br>Fax: +34 93 581 41 10<br><a href=3D"h=
ttp://www.pic.es" target=3D"_blank">http://www.pic.es</a><br>
Avis - Aviso - Legal Notice: <a href=3D"http://www.ifae.es/legal.html" targ=
et=3D"_blank">http://www.ifae.es/legal.html</a>
</div>

--089e0111bce03d2fa104f8ceb7c7--


--===============6601206009612850419==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6601206009612850419==--
