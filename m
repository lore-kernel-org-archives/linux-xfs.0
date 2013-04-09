Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4724629DFA
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 17:16:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E0B1FAC001
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 15:16:35 -0700 (PDT)
Received: from mail-vb0-f48.google.com (mail-vb0-f48.google.com
	[209.85.212.48]) by cuda.sgi.com with ESMTP id 2St3vS96Z2sewz3A
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Apr 2013 15:16:31 -0700 (PDT)
Received: by mail-vb0-f48.google.com with SMTP id p13so5129798vbe.35
	for <xfs@oss.sgi.com>; Tue, 09 Apr 2013 15:16:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADFMGu+=MM2yc=_peboV7JTNJ8F05TJfexmEErzcf0D8mAWFRg@mail.gmail.com>
References: <CADFMGuJm5bPPwbbUtYwrCVDL23KExJTw_-VRX2UEEdZjo+i5oA@mail.gmail.com>
	<CADFMGu+=MM2yc=_peboV7JTNJ8F05TJfexmEErzcf0D8mAWFRg@mail.gmail.com>
Date: Tue, 9 Apr 2013 18:16:30 -0400
Message-ID: <CAJzLF9k3f7ix7GD==26+JDg=5=AQWnJe3aopAHnQxXmzNPRkOw@mail.gmail.com>
Subject: Re: need help how to debug xfs crash issue xfs_iunlink_remove:
	xfs_inotobp() returned error 22
From: "Michael L. Semon" <mlsemon35@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5050935781675453072=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: =?UTF-8?B?56ym5rC45rab?= <yongtaofu@gmail.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============5050935781675453072==
Content-Type: multipart/alternative; boundary=bcaec548a5f9c3978e04d9f4e719

--bcaec548a5f9c3978e04d9f4e719
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

A meager non-expert user question with full ignorance of glusterfs:  Why
are you having I/O errors once every two weeks?

This looks like XFS behavior I've seen under 2 conditions: 1) when I test
XFS on the device-mapper flakey object, using XFS without an external
journal, and 2) when I try to press my hard-drive connectors against the
motherboard while the PC is still running.  Your error message looks more
like the result of (2) than of (1).

XFS behavior on flakey is not the best, and I wish it would recover in such
situations.  In Case (2), I'm fairly sure that the PC is confused on a
hardware level because the drive light does not go out.  Then again, seeing
the behavior of other file systems that fight through the errors, maybe
it's for the best.  If you're fighting I/O errors, there is no winner, and
it's best to get rid of the I/O error.

OK, I'm off the soapbox and will quietly wait for a RAID expert like Dave
or Stan to jump in and make me feel like a complete amateur...

MIchael

On Tue, Apr 9, 2013 at 9:03 AM, =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com> wr=
ote:

> BTW
> xfs_info /dev/sdb
> meta-data=3D/dev/sdb               isize=3D256    agcount=3D28, agsize=3D=
268435440
> blks
>          =3D                       sectsz=3D512   attr=3D2
> data     =3D                       bsize=3D4096   blocks=3D7324303360, im=
axpct=3D5
>          =3D                       sunit=3D16     swidth=3D160 blks
> naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
> log      =3Dinternal               bsize=3D4096   blocks=3D521728, versio=
n=3D2
>          =3D                       sectsz=3D512   sunit=3D16 blks, lazy-c=
ount=3D1
> realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=
=3D0
>
> 2013/4/9, =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com>:
> > Dear xfs experts,
> > I really need your help sincerely!!! In our production enviroment we
> > run glusterfs over top of xfs on Dell x720D(Raid 6). And the xfs file
> > system crash on some of the server frequently about every two weeks.
> > Can you help to give me a direction about how to debug this issue and
> > how to avoid it? Thank you very very much!
> >
> > uname -a
> > Linux cqdx.miaoyan.cluster1.node11.qiyi.domain 2.6.32-279.el6.x86_64
> > #1 SMP Wed Jun 13 18:24:36 EDT 2012 x86_64 x86_64 x86_64 GNU/Linux
> >
> > Every time the crash log is same, as following
> >
> > 038 Apr  9 09:41:36 cqdx kernel: XFS (sdb): xfs_iunlink_remove:
> > xfs_inotobp() returned error 22.
> > 1039 Apr  9 09:41:36 cqdx kernel: XFS (sdb): xfs_inactive: xfs_ifree
> > returned error 22
> > 1040 Apr  9 09:41:36 cqdx kernel: XFS (sdb):
> > xfs_do_force_shutdown(0x1) called from line 1184 of file
> > fs/xfs/xfs_vnodeops.c.  Return address =3D 0xffffffffa02ee20a
> > 1041 Apr  9 09:41:36 cqdx kernel: XFS (sdb): I/O Error Detected.
> > Shutting down filesystem
> > 1042 Apr  9 09:41:36 cqdx kernel: XFS (sdb): Please umount the
> > filesystem and rectify the problem(s)
> > 1043 Apr  9 09:41:53 cqdx kernel: XFS (sdb): xfs_log_force: error 5
> > returned.
> > 1044 Apr  9 09:42:23 cqdx kernel: XFS (sdb): xfs_log_force: error 5
> > returned.
> > 1045 Apr  9 09:42:53 cqdx kernel: XFS (sdb): xfs_log_force: error 5
> > returned.
> > 1046 Apr  9 09:43:23 cqdx kernel: XFS (sdb): xfs_log_force: error 5
> > returned.
> >
> > --
> > =B7=FB=D3=C0=CC=CE
> >
>
>
> --
> =B7=FB=D3=C0=CC=CE
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

--bcaec548a5f9c3978e04d9f4e719
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">A meager non-expert user question with full ignorance of g=
lusterfs:=C2=A0 Why are you having I/O errors once every two weeks?<br><div=
><div><div class=3D"gmail_extra"><br></div><div class=3D"gmail_extra">This =
looks like XFS behavior I&#39;ve seen under 2 conditions: 1) when I test XF=
S on the device-mapper flakey object, using XFS without an external journal=
, and 2) when I try to press my hard-drive connectors against the motherboa=
rd while the PC is still running.=C2=A0 Your error message looks more like =
the result of (2) than of (1).<br>
<br></div><div class=3D"gmail_extra">XFS behavior on flakey is not the best=
, and I wish it would recover in such situations.=C2=A0 In Case (2), I&#39;=
m fairly sure that the PC is confused on a hardware level because the drive=
 light does not go out.=C2=A0 Then again, seeing the behavior of other file=
 systems that fight through the errors, maybe it&#39;s for the best.=C2=A0 =
If you&#39;re fighting I/O errors, there is no winner, and it&#39;s best to=
 get rid of the I/O error.<br>
<br></div><div class=3D"gmail_extra">OK, I&#39;m off the soapbox and will q=
uietly wait for a RAID expert like Dave or Stan to jump in and make me feel=
 like a complete amateur...<br><br>MIchael<br></div><div class=3D"gmail_ext=
ra">
<br><div class=3D"gmail_quote">On Tue, Apr 9, 2013 at 9:03 AM, =E7=AC=A6=E6=
=B0=B8=E6=B6=9B <span dir=3D"ltr">&lt;<a href=3D"mailto:yongtaofu@gmail.com=
" target=3D"_blank">yongtaofu@gmail.com</a>&gt;</span> wrote:<br><blockquot=
e class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc sol=
id;padding-left:1ex">
BTW<br>
xfs_info /dev/sdb<br>
meta-data=3D/dev/sdb =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 isize=
=3D256 =C2=A0 =C2=A0agcount=3D28, agsize=3D268435440 blks<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sectsz=3D512 =C2=A0 attr=3D2<br>
data =C2=A0 =C2=A0 =3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 bsize=3D4096 =C2=A0 blocks=3D<a href=3D"tel:732430=
3360" value=3D"+17324303360">7324303360</a>, imaxpct=3D5<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sunit=3D16 =C2=A0 =C2=A0 swidth=
=3D160 blks<br>
naming =C2=A0 =3Dversion 2 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
bsize=3D4096 =C2=A0 ascii-ci=3D0<br>
log =C2=A0 =C2=A0 =C2=A0=3Dinternal =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 bsize=3D4096 =C2=A0 blocks=3D521728, version=3D2<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sectsz=3D512 =C2=A0 sunit=3D16 bl=
ks, lazy-count=3D1<br>
realtime =3Dnone =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 extsz=3D4096 =C2=A0 blocks=3D0, rtextents=3D0<br>
<br>
2013/4/9, =E7=AC=A6=E6=B0=B8=E6=B6=9B &lt;<a href=3D"mailto:yongtaofu@gmail=
.com">yongtaofu@gmail.com</a>&gt;:<br>
&gt; Dear xfs experts,<br>
&gt; I really need your help sincerely!!! In our production enviroment we<b=
r>
&gt; run glusterfs over top of xfs on Dell x720D(Raid 6). And the xfs file<=
br>
&gt; system crash on some of the server frequently about every two weeks.<b=
r>
&gt; Can you help to give me a direction about how to debug this issue and<=
br>
&gt; how to avoid it? Thank you very very much!<br>
&gt;<br>
&gt; uname -a<br>
&gt; Linux cqdx.miaoyan.cluster1.node11.qiyi.domain 2.6.32-279.el6.x86_64<b=
r>
&gt; #1 SMP Wed Jun 13 18:24:36 EDT 2012 x86_64 x86_64 x86_64 GNU/Linux<br>
&gt;<br>
&gt; Every time the crash log is same, as following<br>
&gt;<br>
&gt; 038 Apr =C2=A09 09:41:36 cqdx kernel: XFS (sdb): xfs_iunlink_remove:<b=
r>
&gt; xfs_inotobp() returned error 22.<br>
&gt; 1039 Apr =C2=A09 09:41:36 cqdx kernel: XFS (sdb): xfs_inactive: xfs_if=
ree<br>
&gt; returned error 22<br>
&gt; 1040 Apr =C2=A09 09:41:36 cqdx kernel: XFS (sdb):<br>
&gt; xfs_do_force_shutdown(0x1) called from line 1184 of file<br>
&gt; fs/xfs/xfs_vnodeops.c. =C2=A0Return address =3D 0xffffffffa02ee20a<br>
&gt; 1041 Apr =C2=A09 09:41:36 cqdx kernel: XFS (sdb): I/O Error Detected.<=
br>
&gt; Shutting down filesystem<br>
&gt; 1042 Apr =C2=A09 09:41:36 cqdx kernel: XFS (sdb): Please umount the<br=
>
&gt; filesystem and rectify the problem(s)<br>
&gt; 1043 Apr =C2=A09 09:41:53 cqdx kernel: XFS (sdb): xfs_log_force: error=
 5<br>
&gt; returned.<br>
&gt; 1044 Apr =C2=A09 09:42:23 cqdx kernel: XFS (sdb): xfs_log_force: error=
 5<br>
&gt; returned.<br>
&gt; 1045 Apr =C2=A09 09:42:53 cqdx kernel: XFS (sdb): xfs_log_force: error=
 5<br>
&gt; returned.<br>
&gt; 1046 Apr =C2=A09 09:43:23 cqdx kernel: XFS (sdb): xfs_log_force: error=
 5<br>
&gt; returned.<br>
<span class=3D"HOEnZb"><font color=3D"#888888">&gt;<br>
&gt; --<br>
&gt; =E7=AC=A6=E6=B0=B8=E6=B6=9B<br>
&gt;<br>
<br>
<br>
--<br>
=E7=AC=A6=E6=B0=B8=E6=B6=9B<br>
<br>
_______________________________________________<br>
xfs mailing list<br>
<a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
<a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">http:=
//oss.sgi.com/mailman/listinfo/xfs</a><br>
</font></span></blockquote></div><br></div></div></div></div>

--bcaec548a5f9c3978e04d9f4e719--


--===============5050935781675453072==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5050935781675453072==--
