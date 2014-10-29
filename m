Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CA4A27F3F
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 12:19:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B840F8F8033
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 10:19:37 -0700 (PDT)
Received: from mail-qc0-f179.google.com (mail-qc0-f179.google.com
	[209.85.216.179]) by cuda.sgi.com with ESMTP id
	S7vHfNfNwoI6ZFkh (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Oct 2014 10:19:36 -0700 (PDT)
Received: by mail-qc0-f179.google.com with SMTP id o8so2648843qcw.38
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 10:19:36 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 29 Oct 2014 10:19:35 -0700
Message-ID: <CA+r9EUGbxdXxP7uA1ufw=bSKE035VVHcK-Tyatr=fr-t_U=ZAw@mail.gmail.com>
Subject: xfs fs on lvm, failed drive.
From: Gary Artim <gartim@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7802743966413242131=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Gary Artim <gartim@gmail.com>

--===============7802743966413242131==
Content-Type: multipart/alternative; boundary=001a113a9ab6ce1670050692f74a

--001a113a9ab6ce1670050692f74a
Content-Type: text/plain; charset=ISO-8859-1

Hi...wondering if there is anyway I can salvage a directory on the lvm
volume that is xfs? thanks of any help, assembled:

parted /dev/sdx
mklabel gpt
mkpart primary xfs 1 -1 (sometime xfs doesnt work until the xfsprogs are
installed and reboot)
set 1 lvm on

do this for each drive.
pvcreate /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
vgcreate backup /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
lvcreate -L 9T -n backuplv backup
mkfs.xfs -L backuplv /dev/mapper/backup-backuplv
/dev/mapper/backup-backuplv /xfs xfs   (in fstab)

failed drive:
/dev/sdc1

--001a113a9ab6ce1670050692f74a
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:courier =
new,monospace;font-size:x-small">Hi...wondering if there is anyway I can sa=
lvage a directory on the lvm volume that is xfs? thanks of any help, assemb=
led:<br><br>parted /dev/sdx<br>mklabel gpt<br>mkpart primary xfs 1 -1 (some=
time xfs doesnt work until the xfsprogs are installed and reboot)<br>set 1 =
lvm on<br><br>do this for each drive.<br>pvcreate /dev/sdb1 /dev/sdc1 /dev/=
sdd1 /dev/sde1<br>vgcreate backup /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1<b=
r>lvcreate -L 9T -n backuplv backup<br>mkfs.xfs -L backuplv /dev/mapper/bac=
kup-backuplv<br>/dev/mapper/backup-backuplv /xfs xfs=A0=A0 (in fstab)<br><b=
r></div><div class=3D"gmail_default" style=3D"font-family:courier new,monos=
pace;font-size:x-small">failed drive: <br>/dev/sdc1<br><br></div></div>

--001a113a9ab6ce1670050692f74a--


--===============7802743966413242131==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7802743966413242131==--
