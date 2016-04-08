Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B727B7CA1
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 15:37:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8DC4A304032
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 13:37:15 -0700 (PDT)
Received: from mx0b-00003501.pphosted.com (mx0b-00003501.pphosted.com
	[67.231.152.68]) by cuda.sgi.com with ESMTP id b7JE1Q39dTC12CRM
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 08 Apr 2016 13:37:13 -0700 (PDT)
Received: from pps.filterd (m0075033.ppops.net [127.0.0.1])
	by mx0b-00003501.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id
	u38KXhZg032926 for <xfs@oss.sgi.com>; Fri, 8 Apr 2016 16:37:13 -0400
Received: from mail-io0-f170.google.com (mail-io0-f170.google.com
	[209.85.223.170])
	by mx0b-00003501.pphosted.com with ESMTP id 226ksgg1c2-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NOT) for <xfs@oss.sgi.com>; Fri, 08 Apr 2016 16:37:13 -0400
Received: by mail-io0-f170.google.com with SMTP id g185so145497547ioa.2
	for <xfs@oss.sgi.com>; Fri, 08 Apr 2016 13:37:13 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 8 Apr 2016 15:37:12 -0500
Message-ID: <CAD4UnC8M32_GO1+2rfi=v6f3R02T70dhxQJeZtnGFi_muL2z9g@mail.gmail.com>
Subject: Use latest xfs_repair on older file systems
From: Chris M Moser <chris.m.moser@seagate.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8809094124423313391=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8809094124423313391==
Content-Type: multipart/alternative; boundary=001a113f2b4ce3ffd8052fff285a

--001a113f2b4ce3ffd8052fff285a
Content-Type: text/plain; charset=UTF-8

Hello,

I have a file system that experienced issues and would not mount. The
system would not boot either as this file system was listed in /etc/fstab.
I booted to a debian image with xfsprogs 3.2.1 and ran xfs_repair

The host OS now boots and the file system mounts but has only a handful of
the original files.
I unmounted and ran xfs_repair 2.9.4 form the host OS a few more times. (I
read somewhere that running xfs_repair multiple times can find more files)
I still see the same handful of files.

A previous thread (http://oss.sgi.com/archives/xfs/2014-06/msg00204.html)
suggests running the latest xfs_repair as it may be able to reattach more
files.

I booted to a fedora 23 live image and updated xfsprogs to 4.5.0. (openSUSE
Tumbleweed has xfsprogs 4.5.0 but I was not able to get their live image
working) When running xfs_repair on the file system it complains: xfs_repair:
V1 inodes unsupported. Please try an older xfsporgs.

Is it reasonable to assume that xfs_repair has done all it can and I should
now use photorec from the testdisk package to recover what I can?

Thank you for your feedback.

-Chris

-- 
Christopher M Moser

Seagate Technology LLC
Cluster Lab Administrator
NRM Bldg A/A1-3
chris.m.moser@seagate.com
952-402-8269

--001a113f2b4ce3ffd8052fff285a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div><div><div><div>Hello,<br><br></div>I h=
ave a file system that experienced issues and would not mount. The system w=
ould not boot either as this file system was listed in /etc/fstab.<br></div=
>I booted to a debian image with xfsprogs 3.2.1 and ran xfs_repair<br><br><=
/div>The host OS now boots and the file system mounts but has only a handfu=
l of the original files.<br></div>I unmounted and ran xfs_repair 2.9.4 form=
 the host OS a few more times. (I read somewhere that running xfs_repair mu=
ltiple times can find more files) I still see the same handful of files.<br=
></div><br></div>A previous thread (<a href=3D"http://oss.sgi.com/archives/=
xfs/2014-06/msg00204.html">http://oss.sgi.com/archives/xfs/2014-06/msg00204=
.html</a>) suggests running the latest xfs_repair as it may be able to reat=
tach more files.<br><br></div>I booted to a fedora 23 live image and update=
d xfsprogs to 4.5.0. (openSUSE Tumbleweed has xfsprogs 4.5.0 but I was not =
able to get their live image working) When running xfs_repair on the file s=
ystem it complains: <span dir=3D"ltr" style=3D"text-align:left" id=3D":5x.c=
o" class=3D"">xfs_repair: V1 inodes unsupported. Please try an older xfspor=
gs.</span><div><div><div><div><div><div><div><div><div><br></div><div>Is it=
 reasonable to assume that xfs_repair has done all it can and I should now =
use photorec from the testdisk package to recover what I can?<br><br></div>=
<div>Thank you for your feedback.<br><br></div><div>-Chris<br></div><div><b=
r></div><div>-- <br><div class=3D"gmail_signature"><div dir=3D"ltr"><div><d=
iv><div><span style=3D"color:rgb(102,102,102)">Christopher M Moser<br></spa=
n></div><span style=3D"color:rgb(102,102,102)"><br>Seagate Technology LLC<b=
r>Cluster Lab Administrator<br></span></div><span style=3D"color:rgb(102,10=
2,102)">NRM Bldg A/A1-3<br></span></div><span style=3D"color:rgb(102,102,10=
2)"><a href=3D"mailto:chris.m.moser@seagate.com" target=3D"_blank">chris.m.=
moser@seagate.com</a><br>952-402-8269</span><br><div><div><div><div><div><b=
r></div></div></div></div></div></div></div>
</div></div></div></div></div></div></div></div></div></div>

--001a113f2b4ce3ffd8052fff285a--


--===============8809094124423313391==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8809094124423313391==--
