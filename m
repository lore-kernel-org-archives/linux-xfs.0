Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 74F777F37
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 20:36:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 00FD3AC001
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 18:36:36 -0700 (PDT)
Received: from mail-ve0-f180.google.com (mail-ve0-f180.google.com
	[209.85.128.180]) by cuda.sgi.com with ESMTP id
	EkCwpJedlIVaL0mU (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 11 Apr 2013 18:36:35 -0700 (PDT)
Received: by mail-ve0-f180.google.com with SMTP id da11so149741veb.25
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 18:36:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51675E67.7030600@sandeen.net>
References: <CADFMGuJm5bPPwbbUtYwrCVDL23KExJTw_-VRX2UEEdZjo+i5oA@mail.gmail.com>
	<CADFMGu+=MM2yc=_peboV7JTNJ8F05TJfexmEErzcf0D8mAWFRg@mail.gmail.com>
	<CADFMGuKqkPbpcU=taqjTR4sA3o=w1LLAnKoEuj=OhJqEbQVijw@mail.gmail.com>
	<20130409145238.GE22182@sgi.com>
	<CADFMGuJaiH0wuxOHrDjDn7qRVH+vQkLOOSPUyqSdXnLcS47t3w@mail.gmail.com>
	<CADFMGu+TdyjTjMTWMwpdHqmszhpCU162UA4Y-njARwSEjM1xNw@mail.gmail.com>
	<20130410121025.78a42b22@harpe.intellique.com>
	<CADFMGu+yCg4ux0n6S98bqm_cXc=VCcijVBTqwRxvxmtKt_JO-A@mail.gmail.com>
	<CADFMGuLxgBFU=FUK94tPsCh+qxRW0rEELxSXYoMQLFJ1u3=q0Q@mail.gmail.com>
	<516746AC.3090808@redhat.com> <51675E67.7030600@sandeen.net>
Date: Fri, 12 Apr 2013 09:36:34 +0800
Message-ID: <CADFMGu+_ppTcr0iZ6YmCGkUT0MJUcLX4iSOOCdURdHVyxKKd6A@mail.gmail.com>
Subject: Re: need help how to debug xfs crash issue xfs_iunlink_remove:
	xfs_inotobp() returned error 22
From: =?GB2312?B?t/vTwMzO?= <yongtaofu@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0471875920028318332=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Brian Foster <bfoster@redhat.com>, Ben Myers <bpm@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============0471875920028318332==
Content-Type: multipart/alternative; boundary=001a11c1ed32fa496f04da1fee6d

--001a11c1ed32fa496f04da1fee6d
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

Sorry I didn't dump the meta right after unmounting post-failure, I have
dumped meta after a mount/umount, I'll share the meta to you soon.


2013/4/12 Eric Sandeen <sandeen@sandeen.net>

> On 4/11/13 6:26 PM, Brian Foster wrote:
> > On 04/11/2013 03:11 PM, =B7=FB=D3=C0=CC=CE wrote:
> >> It happens tonight again on one of our servers, how to debug the root
> >> cause? Thank you.
> >>
> >
> > Hi,
> >
> > I've attached a system tap script (stap -v xfs.stp) that should
> > hopefully print out a bit more data should the issue happen again. Do
> > you have a small enough number of nodes (or predictable enough pattern)
> > that you could run this on the nodes that tend to fail and collect the
> > output?
> >
> > Also, could you collect an xfs_metadump of the filesystem in question
> > and make it available for download and analysis somewhere? I believe th=
e
> > ideal approach is to mount/umount the filesystem first to replay the lo=
g
> > before collecting a metadump, but somebody could correct me on that (to
> > be safe, you could collect multiple dumps: pre-mount and post-mount).
>
> Dave suggested yesterday that this would be best: metadump right
> after unmounting post-failure, then mount/umount & generate another
> metadump.
>
> -Eric
>
> > Could you also describe your workload a little bit? Thanks.
> >
> > Brian
> >
> >> Apr 12 02:32:10 cqdx kernel: XFS (sdb): xfs_iunlink_remove:
> >> xfs_inotobp() returned error 22.
> >> Apr 12 02:32:10 cqdx kernel: XFS (sdb): xfs_inactive: xfs_ifree return=
ed
> >> error 22
> >> Apr 12 02:32:10 cqdx kernel: XFS (sdb): xfs_do_force_shutdown(0x1)
> >> called from line 1184 of file fs/xfs/xfs_vnodeops.c.  Return address =
=3D
> >> 0xffffffffa02ee20a
> >> Apr 12 02:32:10 cqdx kernel: XFS (sdb): I/O Error Detected. Shutting
> >> down filesystem
> >> Apr 12 02:32:10 cqdx kernel: XFS (sdb): Please umount the filesystem a=
nd
> >> rectify the problem(s)
> >> Apr 12 02:32:19 cqdx kernel: XFS (sdb): xfs_log_force: error 5 returne=
d.
> >> Apr 12 02:32:49 cqdx kernel: XFS (sdb): xfs_log_force: error 5 returne=
d.
> >> Apr 12 02:33:19 cqdx kernel: XFS (sdb): xfs_log_force: error 5 returne=
d.
> >> Apr 12 02:33:49 cqdx kernel: XFS (sdb): xfs_log_force: error 5 returne=
d.
> >>
>
>


--=20
=B7=FB=D3=C0=CC=CE

--001a11c1ed32fa496f04da1fee6d
Content-Type: text/html; charset=GB2312
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Sorry I didn&#39;t dump the meta right after unmounting po=
st-failure, I have dumped meta after a mount/umount, I&#39;ll share the met=
a to you soon.<br></div><div class=3D"gmail_extra"><br><br><div class=3D"gm=
ail_quote">
2013/4/12 Eric Sandeen <span dir=3D"ltr">&lt;<a href=3D"mailto:sandeen@sand=
een.net" target=3D"_blank">sandeen@sandeen.net</a>&gt;</span><br><blockquot=
e class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc sol=
id;padding-left:1ex">
<div class=3D"im">On 4/11/13 6:26 PM, Brian Foster wrote:<br>
&gt; On 04/11/2013 03:11 PM, =B7=FB=D3=C0=CC=CE wrote:<br>
&gt;&gt; It happens tonight again on one of our servers, how to debug the r=
oot<br>
&gt;&gt; cause? Thank you.<br>
&gt;&gt;<br>
&gt;<br>
&gt; Hi,<br>
&gt;<br>
&gt; I&#39;ve attached a system tap script (stap -v xfs.stp) that should<br=
>
&gt; hopefully print out a bit more data should the issue happen again. Do<=
br>
&gt; you have a small enough number of nodes (or predictable enough pattern=
)<br>
&gt; that you could run this on the nodes that tend to fail and collect the=
<br>
&gt; output?<br>
&gt;<br>
&gt; Also, could you collect an xfs_metadump of the filesystem in question<=
br>
&gt; and make it available for download and analysis somewhere? I believe t=
he<br>
&gt; ideal approach is to mount/umount the filesystem first to replay the l=
og<br>
&gt; before collecting a metadump, but somebody could correct me on that (t=
o<br>
&gt; be safe, you could collect multiple dumps: pre-mount and post-mount).<=
br>
<br>
</div>Dave suggested yesterday that this would be best: metadump right<br>
after unmounting post-failure, then mount/umount &amp; generate another met=
adump.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
-Eric<br>
</font></span><div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt; Could you also describe your workload a little bit? Thanks.<br>
&gt;<br>
&gt; Brian<br>
&gt;<br>
&gt;&gt; Apr 12 02:32:10 cqdx kernel: XFS (sdb): xfs_iunlink_remove:<br>
&gt;&gt; xfs_inotobp() returned error 22.<br>
&gt;&gt; Apr 12 02:32:10 cqdx kernel: XFS (sdb): xfs_inactive: xfs_ifree re=
turned<br>
&gt;&gt; error 22<br>
&gt;&gt; Apr 12 02:32:10 cqdx kernel: XFS (sdb): xfs_do_force_shutdown(0x1)=
<br>
&gt;&gt; called from line 1184 of file fs/xfs/xfs_vnodeops.c. &nbsp;Return =
address =3D<br>
&gt;&gt; 0xffffffffa02ee20a<br>
&gt;&gt; Apr 12 02:32:10 cqdx kernel: XFS (sdb): I/O Error Detected. Shutti=
ng<br>
&gt;&gt; down filesystem<br>
&gt;&gt; Apr 12 02:32:10 cqdx kernel: XFS (sdb): Please umount the filesyst=
em and<br>
&gt;&gt; rectify the problem(s)<br>
&gt;&gt; Apr 12 02:32:19 cqdx kernel: XFS (sdb): xfs_log_force: error 5 ret=
urned.<br>
&gt;&gt; Apr 12 02:32:49 cqdx kernel: XFS (sdb): xfs_log_force: error 5 ret=
urned.<br>
&gt;&gt; Apr 12 02:33:19 cqdx kernel: XFS (sdb): xfs_log_force: error 5 ret=
urned.<br>
&gt;&gt; Apr 12 02:33:49 cqdx kernel: XFS (sdb): xfs_log_force: error 5 ret=
urned.<br>
&gt;&gt;<br>
<br>
</div></div></blockquote></div><br><br clear=3D"all"><br>-- <br>=B7=FB=D3=
=C0=CC=CE
</div>

--001a11c1ed32fa496f04da1fee6d--


--===============0471875920028318332==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0471875920028318332==--
