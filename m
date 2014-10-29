Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E53177F4E
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 13:54:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D0F028F8037
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 11:54:27 -0700 (PDT)
Received: from mail-qg0-f42.google.com (mail-qg0-f42.google.com
	[209.85.192.42]) by cuda.sgi.com with ESMTP id UfxXeTrFb1WIrnMX
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 29 Oct 2014 11:54:26 -0700 (PDT)
Received: by mail-qg0-f42.google.com with SMTP id i50so1844770qgf.15
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 11:54:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <54512F62.2080303@hardwarefreak.com>
References: <CA+r9EUGbxdXxP7uA1ufw=bSKE035VVHcK-Tyatr=fr-t_U=ZAw@mail.gmail.com>
	<54512F62.2080303@hardwarefreak.com>
Date: Wed, 29 Oct 2014 11:54:26 -0700
Message-ID: <CA+r9EUHm+UtU=km42XANX_5jcFGG9jO-zoYKJrDh1rdA6BSg0g@mail.gmail.com>
Subject: Re: xfs fs on lvm, failed drive.
From: Gary Artim <gartim@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4706269990421999664=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

--===============4706269990421999664==
Content-Type: multipart/alternative; boundary=001a11355afef966ed0506944a7e

--001a11355afef966ed0506944a7e
Content-Type: text/plain; charset=ISO-8859-1

will try running xfs_repair...been trouble using lvm. thanks!

On Wed, Oct 29, 2014 at 11:18 AM, Stan Hoeppner <stan@hardwarefreak.com>
wrote:

> On 10/29/2014 12:19 PM, Gary Artim wrote:
> > Hi...wondering if there is anyway I can salvage a directory on the lvm
> > volume that is xfs? thanks of any help, assembled:
> >
> > parted /dev/sdx
> > mklabel gpt
> > mkpart primary xfs 1 -1 (sometime xfs doesnt work until the xfsprogs are
> > installed and reboot)
> > set 1 lvm on
> >
> > do this for each drive.
> > pvcreate /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
> > vgcreate backup /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
> > lvcreate -L 9T -n backuplv backup
> > mkfs.xfs -L backuplv /dev/mapper/backup-backuplv
> > /dev/mapper/backup-backuplv /xfs xfs   (in fstab)
> >
> > failed drive:
> > /dev/sdc1
>
> You've created an XFS filesystem atop a concatenation of non-redundant
> drives so this condition should not be unexpected.  It's not a directory
> you want to salvage, but the files within it.  If they reside on sdc1
> you're out of luck without using data recovery tools.  If they reside on
> sdb1, sdd1, or sde1, then running xfs_repair might make the FS mountable
> and get you access to them again.
>
> That's assuming LVM is still running with one drive gone, or will still
> assemble the concatenation with one drive missing.  I don't use LVM.
>
> Cheers,
> Stan
>

--001a11355afef966ed0506944a7e
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:courier =
new,monospace;font-size:x-small">will try running  xfs_repair...been troubl=
e using lvm. thanks!<br></div></div><div class=3D"gmail_extra"><br><div cla=
ss=3D"gmail_quote">On Wed, Oct 29, 2014 at 11:18 AM, Stan Hoeppner <span di=
r=3D"ltr">&lt;<a href=3D"mailto:stan@hardwarefreak.com" target=3D"_blank">s=
tan@hardwarefreak.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_q=
uote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1e=
x"><div class=3D"HOEnZb"><div class=3D"h5">On 10/29/2014 12:19 PM, Gary Art=
im wrote:<br>
&gt; Hi...wondering if there is anyway I can salvage a directory on the lvm=
<br>
&gt; volume that is xfs? thanks of any help, assembled:<br>
&gt;<br>
&gt; parted /dev/sdx<br>
&gt; mklabel gpt<br>
&gt; mkpart primary xfs 1 -1 (sometime xfs doesnt work until the xfsprogs a=
re<br>
&gt; installed and reboot)<br>
&gt; set 1 lvm on<br>
&gt;<br>
&gt; do this for each drive.<br>
&gt; pvcreate /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1<br>
&gt; vgcreate backup /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1<br>
&gt; lvcreate -L 9T -n backuplv backup<br>
&gt; mkfs.xfs -L backuplv /dev/mapper/backup-backuplv<br>
&gt; /dev/mapper/backup-backuplv /xfs xfs=A0 =A0(in fstab)<br>
&gt;<br>
&gt; failed drive:<br>
&gt; /dev/sdc1<br>
<br>
</div></div>You&#39;ve created an XFS filesystem atop a concatenation of no=
n-redundant<br>
drives so this condition should not be unexpected.=A0 It&#39;s not a direct=
ory<br>
you want to salvage, but the files within it.=A0 If they reside on sdc1<br>
you&#39;re out of luck without using data recovery tools.=A0 If they reside=
 on<br>
sdb1, sdd1, or sde1, then running xfs_repair might make the FS mountable<br=
>
and get you access to them again.<br>
<br>
That&#39;s assuming LVM is still running with one drive gone, or will still=
<br>
assemble the concatenation with one drive missing.=A0 I don&#39;t use LVM.<=
br>
<br>
Cheers,<br>
Stan<br>
</blockquote></div><br></div>

--001a11355afef966ed0506944a7e--


--===============4706269990421999664==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4706269990421999664==--
