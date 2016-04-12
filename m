Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 89F057CA0
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 08:27:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5C23D8F8035
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 06:27:26 -0700 (PDT)
Received: from mail-yw0-f193.google.com (mail-yw0-f193.google.com
	[209.85.161.193]) by cuda.sgi.com with ESMTP id
	EeFgz1vSvRt3YM4I (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Apr 2016 06:27:24 -0700 (PDT)
Received: by mail-yw0-f193.google.com with SMTP id o63so2316343ywe.0
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 06:27:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160411181001.2760439b@harpe.intellique.com>
References: <CAG=-QKovDGUdLXv9AekeK1o4Dd_bwWNfTTTEcq3VoszBgbmXeQ@mail.gmail.com>
	<20160411181001.2760439b@harpe.intellique.com>
Date: Tue, 12 Apr 2016 21:27:24 +0800
Message-ID: <CAG=-QKp=GpUCodMB6n1H_MtAQzb8m2Q3gKNsdCj3HmQcfCJ=ZQ@mail.gmail.com>
Subject: Re: about the xfs performance
From: Songbo Wang <hack.coo@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7111510406220035471=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

--===============7111510406220035471==
Content-Type: multipart/alternative; boundary=001a1141e82a216c9f0530499f5d

--001a1141e82a216c9f0530499f5d
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi=EF=BC=8CEmmanuel
Thank you for your reply , I have two types of pcie-ssd cards: Intel P3600
 and ES3000 V2 PCIe SSD ;
I did this testing as you mentioned above , but the results are also bad.

2016-04-12 0:10 GMT+08:00 Emmanuel Florac <eflorac@intellique.com>:

> Le Mon, 11 Apr 2016 22:14:06 +0800
> Songbo Wang <hack.coo@gmail.com> =C3=A9crivait:
>
> >      mkfs: mkfs.xfs /dev/hioa2 -f -n size=3D64k -i size=3D512 -d
> > agcount=3D40 -l size=3D1024m.
> >      mount: mount /dev/hioa2 /mnt/  -t xfs -o
> >
> rw,noexec,nodev,noatime,nodiratime,nobarrier,discard,inode64,logbsize=3D2=
56k,delaylog
> > I use the following command to test iops: fio -ioengine=3Dlibaio -bs=3D=
4k
> > -direct=3D1 -thread -rw=3Drandwrite -size=3D50G -filename=3D/mnt/test
> > -name=3D"EBS 4KB randwrite test" -iodepth=3D64 -runtime=3D60
> > The results is normal at the beginning which is about 210k=C2=B1=EF=BC=
=8Cbut some
> > seconds later, the results down to 19k=C2=B1.
>
> You should first try default mkfs settings, with default mount options.
> Normally mkfs.xfs should initiate a TRIM on the SSD, therefore
> performance should remain predictable.
>
> What model of SSD card are you using? With an HGST NVMe SN1x0 I've got
> very consistent results (no degradation with time).
>
> --
> ------------------------------------------------------------------------
> Emmanuel Florac     |   Direction technique
>                     |   Intellique
>                     |   <eflorac@intellique.com>
>                     |   +33 1 78 94 84 02
> ------------------------------------------------------------------------
>

--001a1141e82a216c9f0530499f5d
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><span style=3D"color:rgb(136,136,136);font-size:14px">Hi=
=EF=BC=8CEmmanuel</span><br><div><span style=3D"color:rgb(136,136,136);font=
-size:14px">Thank you for your reply , I have two types of pcie-ssd cards: =
Intel P3600 =C2=A0and=C2=A0</span><font color=3D"#888888"><span style=3D"fo=
nt-size:14px">ES3000 V2 PCIe SSD ;</span></font></div><div><span style=3D"c=
olor:rgb(136,136,136);font-size:14px">I did this testing as you mentioned a=
bove , but the results are also bad.=C2=A0</span></div></div><div class=3D"=
gmail_extra"><br><div class=3D"gmail_quote">2016-04-12 0:10 GMT+08:00 Emman=
uel Florac <span dir=3D"ltr">&lt;<a href=3D"mailto:eflorac@intellique.com" =
target=3D"_blank">eflorac@intellique.com</a>&gt;</span>:<br><blockquote cla=
ss=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;pa=
dding-left:1ex">Le Mon, 11 Apr 2016 22:14:06 +0800<br>
Songbo Wang &lt;<a href=3D"mailto:hack.coo@gmail.com">hack.coo@gmail.com</a=
>&gt; =C3=A9crivait:<br>
<span class=3D""><br>
&gt;=C2=A0 =C2=A0 =C2=A0 mkfs: mkfs.xfs /dev/hioa2 -f -n size=3D64k -i size=
=3D512 -d<br>
&gt; agcount=3D40 -l size=3D1024m.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 mount: mount /dev/hioa2 /mnt/=C2=A0 -t xfs -o<br>
&gt; rw,noexec,nodev,noatime,nodiratime,nobarrier,discard,inode64,logbsize=
=3D256k,delaylog<br>
&gt; I use the following command to test iops: fio -ioengine=3Dlibaio -bs=
=3D4k<br>
&gt; -direct=3D1 -thread -rw=3Drandwrite -size=3D50G -filename=3D/mnt/test<=
br>
&gt; -name=3D&quot;EBS 4KB randwrite test&quot; -iodepth=3D64 -runtime=3D60=
<br>
&gt; The results is normal at the beginning which is about 210k=C2=B1=EF=BC=
=8Cbut some<br>
&gt; seconds later, the results down to 19k=C2=B1.<br>
<br>
</span>You should first try default mkfs settings, with default mount optio=
ns.<br>
Normally mkfs.xfs should initiate a TRIM on the SSD, therefore<br>
performance should remain predictable.<br>
<br>
What model of SSD card are you using? With an HGST NVMe SN1x0 I&#39;ve got<=
br>
very consistent results (no degradation with time).<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
------------------------------------------------------------------------<br=
>
Emmanuel Florac=C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A0Direction technique<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=
=A0 =C2=A0Intellique<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=
=A0 =C2=A0&lt;<a href=3D"mailto:eflorac@intellique.com">eflorac@intellique.=
com</a>&gt;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=
=A0 =C2=A0<a href=3D"tel:%2B33%201%2078%2094%2084%2002" value=3D"+331789484=
02">+33 1 78 94 84 02</a><br>
------------------------------------------------------------------------<br=
>
</font></span></blockquote></div><br></div>

--001a1141e82a216c9f0530499f5d--


--===============7111510406220035471==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7111510406220035471==--
