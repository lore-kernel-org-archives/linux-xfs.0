Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 296667CA0
	for <xfs@oss.sgi.com>; Mon, 11 Apr 2016 12:15:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0219F304048
	for <xfs@oss.sgi.com>; Mon, 11 Apr 2016 10:15:46 -0700 (PDT)
Received: from mx0b-00003501.pphosted.com (mx0b-00003501.pphosted.com
	[67.231.152.68]) by cuda.sgi.com with ESMTP id GLMcyoAFO2Sxu2Xz
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 11 Apr 2016 10:15:44 -0700 (PDT)
Received: from pps.filterd (m0075030.ppops.net [127.0.0.1])
	by mx0b-00003501.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id
	u3BHFVB0024844 for <xfs@oss.sgi.com>; Mon, 11 Apr 2016 13:15:44 -0400
Received: from mail-ig0-f176.google.com (mail-ig0-f176.google.com
	[209.85.213.176])
	by mx0b-00003501.pphosted.com with ESMTP id 228g5rg04f-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NOT) for <xfs@oss.sgi.com>; Mon, 11 Apr 2016 13:15:43 -0400
Received: by mail-ig0-f176.google.com with SMTP id ui10so79775101igc.1
	for <xfs@oss.sgi.com>; Mon, 11 Apr 2016 10:15:43 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 11 Apr 2016 12:15:41 -0500
Message-ID: <CAD4UnC9OKuUjF9tfe2dNrTYHOxsZ9coaxi2HTCvBC_KfbaQU1g@mail.gmail.com>
Subject: Re: Use latest xfs_repair on older file systems
From: Chris M Moser <chris.m.moser@seagate.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6498531916497768036=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============6498531916497768036==
Content-Type: multipart/alternative; boundary=047d7b414162bcdab2053038b18f

--047d7b414162bcdab2053038b18f
Content-Type: text/plain; charset=UTF-8

Thank you kindly for you responses.

-Chris


On Fri, Apr 8, 2016 at 3:37 PM, Chris M Moser <chris.m.moser@seagate.com>
wrote:

> Hello,
>
> I have a file system that experienced issues and would not mount. The
> system would not boot either as this file system was listed in /etc/fstab.
> I booted to a debian image with xfsprogs 3.2.1 and ran xfs_repair
>
> The host OS now boots and the file system mounts but has only a handful of
> the original files.
> I unmounted and ran xfs_repair 2.9.4 form the host OS a few more times. (I
> read somewhere that running xfs_repair multiple times can find more files)
> I still see the same handful of files.
>
> A previous thread (http://oss.sgi.com/archives/xfs/2014-06/msg00204.html)
> suggests running the latest xfs_repair as it may be able to reattach more
> files.
>
> I booted to a fedora 23 live image and updated xfsprogs to 4.5.0.
> (openSUSE Tumbleweed has xfsprogs 4.5.0 but I was not able to get their
> live image working) When running xfs_repair on the file system it
> complains: xfs_repair: V1 inodes unsupported. Please try an older
> xfsporgs.
>
> Is it reasonable to assume that xfs_repair has done all it can and I
> should now use photorec from the testdisk package to recover what I can?
>
> Thank you for your feedback.
>
> -Chris
>
> --
> Christopher M Moser
>
> Seagate Technology LLC
> Cluster Lab Administrator
> NRM Bldg A/A1-3
> chris.m.moser@seagate.com
> 952-402-8269
>
>


-- 
Christopher M Moser

Seagate Technology LLC
Cluster Lab Administrator
NRM Bldg A/A1-3
chris.m.moser@seagate.com
952-402-8269

--047d7b414162bcdab2053038b18f
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Thank you kindly for you responses.<br><br></div>-Chr=
is<br><br><div><div><div class=3D"gmail_extra"><br><div class=3D"gmail_quot=
e">On Fri, Apr 8, 2016 at 3:37 PM, Chris M Moser <span dir=3D"ltr">&lt;<a h=
ref=3D"mailto:chris.m.moser@seagate.com" target=3D"_blank">chris.m.moser@se=
agate.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div dir=
=3D"ltr"><div><div><div><div><div><div><div>Hello,<br><br></div>I have a fi=
le system that experienced issues and would not mount. The system would not=
 boot either as this file system was listed in /etc/fstab.<br></div>I boote=
d to a debian image with xfsprogs 3.2.1 and ran xfs_repair<br><br></div>The=
 host OS now boots and the file system mounts but has only a handful of the=
 original files.<br></div>I unmounted and ran xfs_repair 2.9.4 form the hos=
t OS a few more times. (I read somewhere that running xfs_repair multiple t=
imes can find more files) I still see the same handful of files.<br></div><=
br></div>A previous thread (<a href=3D"http://oss.sgi.com/archives/xfs/2014=
-06/msg00204.html" target=3D"_blank">http://oss.sgi.com/archives/xfs/2014-0=
6/msg00204.html</a>) suggests running the latest xfs_repair as it may be ab=
le to reattach more files.<br><br></div>I booted to a fedora 23 live image =
and updated xfsprogs to 4.5.0. (openSUSE Tumbleweed has xfsprogs 4.5.0 but =
I was not able to get their live image working) When running xfs_repair on =
the file system it complains: <span dir=3D"ltr" style=3D"text-align:left">x=
fs_repair: V1 inodes unsupported. Please try an older xfsporgs.</span><div>=
<div><div><div><div><div><div><div><div><br></div><div>Is it reasonable to =
assume that xfs_repair has done all it can and I should now use photorec fr=
om the testdisk package to recover what I can?<br><br></div><div>Thank you =
for your feedback.<span class=3D"HOEnZb"><font color=3D"#888888"><br><br></=
font></span></div><span class=3D"HOEnZb"><font color=3D"#888888"><div>-Chri=
s<br></div><div><br></div><div>-- <br><div><div dir=3D"ltr"><div><div><div>=
<span style=3D"color:rgb(102,102,102)">Christopher M Moser<br></span></div>=
<span style=3D"color:rgb(102,102,102)"><br>Seagate Technology LLC<br>Cluste=
r Lab Administrator<br></span></div><span style=3D"color:rgb(102,102,102)">=
NRM Bldg A/A1-3<br></span></div><span style=3D"color:rgb(102,102,102)"><a h=
ref=3D"mailto:chris.m.moser@seagate.com" target=3D"_blank">chris.m.moser@se=
agate.com</a><br><a href=3D"tel:952-402-8269" value=3D"+19524028269" target=
=3D"_blank">952-402-8269</a></span><br><div><div><div><div><div><br></div><=
/div></div></div></div></div></div>
</div></font></span></div></div></div></div></div></div></div></div></div>
</blockquote></div><br><br clear=3D"all"><br>-- <br><div class=3D"gmail_sig=
nature"><div dir=3D"ltr"><div><div><div><span style=3D"color:rgb(102,102,10=
2)">Christopher M Moser<br></span></div><span style=3D"color:rgb(102,102,10=
2)"><br>Seagate Technology LLC<br>Cluster Lab Administrator<br></span></div=
><span style=3D"color:rgb(102,102,102)">NRM Bldg A/A1-3<br></span></div><sp=
an style=3D"color:rgb(102,102,102)"><a href=3D"mailto:chris.m.moser@seagate=
.com" target=3D"_blank">chris.m.moser@seagate.com</a><br>952-402-8269</span=
><br><div><div><div><div><div><br></div></div></div></div></div></div></div=
>
</div></div></div></div>

--047d7b414162bcdab2053038b18f--


--===============6498531916497768036==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6498531916497768036==--
