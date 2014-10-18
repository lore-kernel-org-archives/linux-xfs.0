Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2036E7F3F
	for <xfs@oss.sgi.com>; Sat, 18 Oct 2014 04:26:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C0762AC004
	for <xfs@oss.sgi.com>; Sat, 18 Oct 2014 02:26:42 -0700 (PDT)
Received: from mail-qg0-f43.google.com (mail-qg0-f43.google.com
	[209.85.192.43]) by cuda.sgi.com with ESMTP id kv4nICdtOgBbfgLS
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 18 Oct 2014 02:26:41 -0700 (PDT)
Received: by mail-qg0-f43.google.com with SMTP id j107so1579088qga.2
	for <xfs@oss.sgi.com>; Sat, 18 Oct 2014 02:26:40 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 18 Oct 2014 17:26:40 +0800
Message-ID: <CALSoAzD4ccHXBuD6mT3ggqMf1j_kDEK-RNMOeRLq+N+NiWVQXg@mail.gmail.com>
Subject: Problem about very high Average Read/Write Request Time
From: quanjun hu <huquanjun@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7723553068838953914=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============7723553068838953914==
Content-Type: multipart/alternative; boundary=001a11c11fca3e7f820505af14a9

--001a11c11fca3e7f820505af14a9
Content-Type: text/plain; charset=UTF-8

Hi,
   I am using xfs on a raid 5 (~100TB) and put log on external ssd device,
the mount information is:
/dev/sdc on /data/fhgfs/fhgfs_storage type xfs
(rw,relatime,attr2,delaylog,logdev=/dev/sdb1,sunit=512,swidth=15872,noquota).
  when doing only reading / only writing , the speed is very fast(~1.5G),
but when do both the speed is very slow (100M), and high r_await(160) and
w_await(200000).
   1. how can I reduce average request time?
   2. can I use ssd as write/read cache for xfs?

Best regards,
Quanjun

--001a11c11fca3e7f820505af14a9
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div>=C2=A0 =C2=A0I am using xfs on a raid 5 (~100TB) a=
nd put log on external ssd device, the mount information is:</div><div>/dev=
/sdc on /data/fhgfs/fhgfs_storage type xfs (rw,relatime,attr2,delaylog,logd=
ev=3D/dev/sdb1,sunit=3D512,swidth=3D15872,noquota).<br></div><div>=C2=A0 wh=
en doing only reading / only writing , the speed is very fast(~1.5G), but w=
hen do both the speed is very slow (100M), and high r_await(160) and w_awai=
t(200000).</div><div>=C2=A0 =C2=A01. how can I reduce average request time?=
</div><div>=C2=A0 =C2=A02. can I use ssd as write/read cache for xfs?</div>=
<div><br></div><div><span class=3D"" style=3D"font-family:arial,sans-serif;=
font-size:12.8000001907349px;background:rgb(255,255,204)">Best</span><span =
style=3D"font-family:arial,sans-serif;font-size:12.8000001907349px">=C2=A0r=
egards,</span><br></div><div><span style=3D"font-family:arial,sans-serif;fo=
nt-size:12.8000001907349px">Quanjun</span></div><div><br></div></div>

--001a11c11fca3e7f820505af14a9--


--===============7723553068838953914==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7723553068838953914==--
