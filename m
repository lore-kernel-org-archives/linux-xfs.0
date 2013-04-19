Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A525D7CBF
	for <xfs@oss.sgi.com>; Fri, 19 Apr 2013 10:13:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 67DF78F8052
	for <xfs@oss.sgi.com>; Fri, 19 Apr 2013 08:13:21 -0700 (PDT)
Received: from mail-ia0-f177.google.com (mail-ia0-f177.google.com
	[209.85.210.177]) by cuda.sgi.com with ESMTP id
	U6zjjtv5N6EiBrPE (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Apr 2013 08:13:19 -0700 (PDT)
Received: by mail-ia0-f177.google.com with SMTP id y26so959975iab.22
	for <xfs@oss.sgi.com>; Fri, 19 Apr 2013 08:13:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51715BD4.8080501@sandeen.net>
References: <516C89DF.4070904@redhat.com> <20130416162417.GC13938@destitution>
	<516D87E3.2010605@redhat.com>
	<CADFMGuLgU2++ym4U9axhevV_L2t-2CMVaDoT5cyQcew2YZMsBA@mail.gmail.com>
	<CADFMGuK3cPSmqZoMdFSSqOnUz3GLv+c01xXHDhzv9_dfUNUPPA@mail.gmail.com>
	<CADFMGu+XD=-NJm3CAsnKpiMWykPj67t2LHgtxkPpyTpVmG3LDA@mail.gmail.com>
	<CADFMGu+z32O5mVBfO6gb8F03y9mrwB5=nf+7LMbky4ttk2mbFw@mail.gmail.com>
	<BA50C18A-BE51-4658-B05E-3EDB0F11BE36@sandeen.net>
	<CADFMGuKfXwY=Z9dg6+wyX7mKzppu1hQhsqxcr9Fd=DjP4hii9w@mail.gmail.com>
	<CADFMGuLDwde8te0Cs4-T9fdVmq2v22fmSTgkYbULHS3voHzw6A@mail.gmail.com>
	<CADFMGuKmmJCz+FxsFL9KegqzNhhHsG2ZbVjrwCDyNCh1R_Zgpw@mail.gmail.com>
	<516FDBDE.1070406@redhat.com>
	<CADFMGuJ-An9MMmYtOKEjt5JdHmvu-cc0G+y361e_fioYf4j7HQ@mail.gmail.com>
	<51705EC4.4000306@redhat.com>
	<CADFMGu+hPV9RanG7298TAYY4p9gMiBOk0+mq5gf5rhQUWXf4TQ@mail.gmail.com>
	<CADFMGuJYDp-YrPDqsz2KKx6_2RCkP37ZNGPLzdTVOpEgKDMsjA@mail.gmail.com>
	<51715BD4.8080501@sandeen.net>
Date: Fri, 19 Apr 2013 23:13:18 +0800
Message-ID: <CADFMGuLjsNBeWE8wTDBgophhpixm3p+wY=9QWwk5u483zL0C4g@mail.gmail.com>
Subject: Re: xfs_iunlink_remove: xfs_inotobp() returned error 22 -- debugging
From: =?GB2312?B?t/vTwMzO?= <yongtaofu@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0586602974841907527=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Brian Foster <bfoster@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============0586602974841907527==
Content-Type: multipart/alternative; boundary=14dae9340b5fbba3e004dab82800

--14dae9340b5fbba3e004dab82800
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

Sure the serious thing here is that it corrupt the unlinked list. The inode
0x1bd33 which trigger xfs shutdown is not  0x6b133.


2013/4/19 Eric Sandeen <sandeen@sandeen.net>

> On 4/19/13 4:41 AM, =B7=FB=D3=C0=CC=CE wrote:
> > Dear Brian and Eric,
> >
> > kernel kernel-2.6.32-279.19.1.el6.x86_64.rpm <
> http://mirror.linux.duke.edu/pub/centos/6.3/updates/x86_64/Packages/kerne=
l-2.6.32-279.19.1.el6.x86_64.rpm>
> still have this problem
> > I build the kernel from this srpm
> >
> https://oss.oracle.com/ol6/SRPMS-updates/kernel-2.6.32-279.19.1.el6.src.r=
pm
> >
> > today the shutdown happens again during test.
> > Seelogs bellow:
> >
> > /var/log/message
> > Apr 19 16:40:05 10 kernel: XFS (sdb): xfs_iunlink_remove: xfs_inotobp()
> returned error 22.
> > Apr 19 16:40:05 10 kernel: XFS (sdb): xfs_inactive: xfs_ifree returned
> error 22
> > Apr 19 16:40:05 10 kernel: XFS (sdb): xfs_do_force_shutdown(0x1) called
> from line 1184 of file fs/xfs/xfs_vnodeops.c.  Return address =3D
> 0xffffffffa02d4bda
> > Apr 19 16:40:05 10 kernel: XFS (sdb): I/O Error Detected. Shutting down
> filesystem
> > Apr 19 16:40:05 10 kernel: XFS (sdb): Please umount the filesystem and
> rectify the problem(s)
> > Apr 19 16:40:07 10 kernel: XFS (sdb): xfs_log_force: error 5 returned.
> > Apr 19 16:40:37 10 kernel: XFS (sdb): xfs_log_force: error 5 returned.
> >
> > systemtap script output:
> > --- xfs_imap -- module("xfs").function("xfs_imap@fs/xfs/xfs_ialloc.c:12=
57").return
> -- return=3D0x16
> > vars: mp=3D0xffff88101801e800 tp=3D0xffff880ff143ac70 ino=3D0xffffffff
> imap=3D0xffff88100e93bc08 flags=3D0x0 agbno=3D? agino=3D? agno=3D? blks_p=
er_cluster=3D?
> chunk_agbno=3D? cluster_agbno=3D? error=3D? offset=3D? offset_agbno=3D? _=
_func__=3D[...]
> > mp: m_agno_log =3D 0x5, m_agino_log =3D 0x20
> > mp->m_sb: sb_agcount =3D 0x1c, sb_agblocks =3D 0xffffff0, sb_inopblog =
=3D 0x4,
> sb_agblklog =3D 0x1c, sb_dblocks =3D 0x1b4900000
> > imap: im_blkno =3D 0x0, im_len =3D 0xe778, im_boffset =3D 0xd997
> > kernel backtrace:
> > Returning from:  0xffffffffa02b4260 : xfs_imap+0x0/0x280 [xfs]
> > Returning to  :  0xffffffffa02b9d59 : xfs_inotobp+0x49/0xc0 [xfs]
> >  0xffffffffa02b9ec1 : xfs_iunlink_remove+0xf1/0x360 [xfs]
> >  0xffffffff814ede89
> >  0x0 (inexact)
> > user backtrace:
> >  0x3ec260e5ad [/lib64/libpthread-2.12.so <http://libpthread-2.12.so
> >+0xe5ad/0x219000]
> >
> > --- xfs_iunlink_remove -- module("xfs").function("xfs_iunlink_remove@fs=
/xfs/xfs_inode.c:1681").return
> -- return=3D0x16
> > vars: tp=3D0xffff880ff143ac70 ip=3D0xffff8811ed111000 next_ino=3D? mp=
=3D? agi=3D?
> dip=3D? agibp=3D? ibp=3D? agno=3D? agino=3D? next_agino=3D? last_ibp=3D?
> last_dip=3D0xffff881000000001 bucket_index=3D? offset=3D?
> last_offset=3D0xffffffffffff8811 error=3D? __func__=3D[...]
> > ip: i_ino =3D 0x1bd33, i_flags =3D 0x0
> > ip->i_d: di_nlink =3D 0x0, di_gen =3D 0x53068791
> >
> > debugfs events trace:
> >
> https://docs.google.com/file/d/0B7n2C4T5tfNCREZtdC1yamc0RnM/edit?usp=3Dsh=
aring
>
> Same issue, one file was unlinked twice in a race:
>
> =3D=3D=3D ino 0x6b133 =3D=3D=3D
>            <...>-4477  [003]  2721.176790: xfs_iunlink: dev 8:16 ino
> 0x6b133
>            <...>-4477  [003]  2721.176839: xfs_iunlink_remove: dev 8:16
> ino 0x6b133
>            <...>-4477  [009]  3320.127227: xfs_iunlink: dev 8:16 ino
> 0x6b133
>            <...>-4477  [001]  3320.141126: xfs_iunlink_remove: dev 8:16
> ino 0x6b133
>            <...>-4477  [003]  7973.136368: xfs_iunlink: dev 8:16 ino
> 0x6b133
>            <...>-4479  [018]  7973.158457: xfs_iunlink: dev 8:16 ino
> 0x6b133
>            <...>-4479  [018]  7973.158497: xfs_iunlink_remove: dev 8:16
> ino 0x6b133
>
> -Eric
>
>


--=20
=B7=FB=D3=C0=CC=CE

--14dae9340b5fbba3e004dab82800
Content-Type: text/html; charset=GB2312
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Sure the serious thing here is that it corrupt the unlinke=
d list. The inode 0x1bd33 which trigger xfs shutdown is not&nbsp; 0x6b133.<=
/div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">2013/4/1=
9 Eric Sandeen <span dir=3D"ltr">&lt;<a href=3D"mailto:sandeen@sandeen.net"=
 target=3D"_blank">sandeen@sandeen.net</a>&gt;</span><br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"im">On 4/19/13 4:41 AM, =B7=FB=
=D3=C0=CC=CE wrote:<br>
&gt; Dear Brian and Eric,<br>
&gt;<br>
</div>&gt; kernel kernel-2.6.32-279.19.1.el6.x86_64.rpm &lt;<a href=3D"http=
://mirror.linux.duke.edu/pub/centos/6.3/updates/x86_64/Packages/kernel-2.6.=
32-279.19.1.el6.x86_64.rpm" target=3D"_blank">http://mirror.linux.duke.edu/=
pub/centos/6.3/updates/x86_64/Packages/kernel-2.6.32-279.19.1.el6.x86_64.rp=
m</a>&gt; still have this problem<br>

<div><div class=3D"h5">&gt; I build the kernel from this srpm<br>
&gt; <a href=3D"https://oss.oracle.com/ol6/SRPMS-updates/kernel-2.6.32-279.=
19.1.el6.src.rpm" target=3D"_blank">https://oss.oracle.com/ol6/SRPMS-update=
s/kernel-2.6.32-279.19.1.el6.src.rpm</a><br>
&gt;<br>
&gt; today the shutdown happens again during test.<br>
&gt; Seelogs bellow:<br>
&gt;<br>
&gt; /var/log/message<br>
&gt; Apr 19 16:40:05 10 kernel: XFS (sdb): xfs_iunlink_remove: xfs_inotobp(=
) returned error 22.<br>
&gt; Apr 19 16:40:05 10 kernel: XFS (sdb): xfs_inactive: xfs_ifree returned=
 error 22<br>
&gt; Apr 19 16:40:05 10 kernel: XFS (sdb): xfs_do_force_shutdown(0x1) calle=
d from line 1184 of file fs/xfs/xfs_vnodeops.c. &nbsp;Return address =3D 0x=
ffffffffa02d4bda<br>
&gt; Apr 19 16:40:05 10 kernel: XFS (sdb): I/O Error Detected. Shutting dow=
n filesystem<br>
&gt; Apr 19 16:40:05 10 kernel: XFS (sdb): Please umount the filesystem and=
 rectify the problem(s)<br>
&gt; Apr 19 16:40:07 10 kernel: XFS (sdb): xfs_log_force: error 5 returned.=
<br>
&gt; Apr 19 16:40:37 10 kernel: XFS (sdb): xfs_log_force: error 5 returned.=
<br>
&gt;<br>
&gt; systemtap script output:<br>
&gt; --- xfs_imap -- module(&quot;xfs&quot;).function(&quot;xfs_imap@fs/xfs=
/xfs_ialloc.c:1257&quot;).return -- return=3D0x16<br>
&gt; vars: mp=3D0xffff88101801e800 tp=3D0xffff880ff143ac70 ino=3D0xffffffff=
 imap=3D0xffff88100e93bc08 flags=3D0x0 agbno=3D? agino=3D? agno=3D? blks_pe=
r_cluster=3D? chunk_agbno=3D? cluster_agbno=3D? error=3D? offset=3D? offset=
_agbno=3D? __func__=3D[...]<br>

&gt; mp: m_agno_log =3D 0x5, m_agino_log =3D 0x20<br>
&gt; mp-&gt;m_sb: sb_agcount =3D 0x1c, sb_agblocks =3D 0xffffff0, sb_inopbl=
og =3D 0x4, sb_agblklog =3D 0x1c, sb_dblocks =3D 0x1b4900000<br>
&gt; imap: im_blkno =3D 0x0, im_len =3D 0xe778, im_boffset =3D 0xd997<br>
&gt; kernel backtrace:<br>
&gt; Returning from: &nbsp;0xffffffffa02b4260 : xfs_imap+0x0/0x280 [xfs]<br=
>
&gt; Returning to &nbsp;: &nbsp;0xffffffffa02b9d59 : xfs_inotobp+0x49/0xc0 =
[xfs]<br>
&gt; &nbsp;0xffffffffa02b9ec1 : xfs_iunlink_remove+0xf1/0x360 [xfs]<br>
&gt; &nbsp;0xffffffff814ede89<br>
&gt; &nbsp;0x0 (inexact)<br>
&gt; user backtrace:<br>
</div></div>&gt; &nbsp;0x3ec260e5ad [/lib64/<a href=3D"http://libpthread-2.=
12.so" target=3D"_blank">libpthread-2.12.so</a> &lt;<a href=3D"http://libpt=
hread-2.12.so" target=3D"_blank">http://libpthread-2.12.so</a>&gt;+0xe5ad/0=
x219000]<br>

<div class=3D"im">&gt;<br>
&gt; --- xfs_iunlink_remove -- module(&quot;xfs&quot;).function(&quot;xfs_i=
unlink_remove@fs/xfs/xfs_inode.c:1681&quot;).return -- return=3D0x16<br>
&gt; vars: tp=3D0xffff880ff143ac70 ip=3D0xffff8811ed111000 next_ino=3D? mp=
=3D? agi=3D? dip=3D? agibp=3D? ibp=3D? agno=3D? agino=3D? next_agino=3D? la=
st_ibp=3D? last_dip=3D0xffff881000000001 bucket_index=3D? offset=3D? last_o=
ffset=3D0xffffffffffff8811 error=3D? __func__=3D[...]<br>

&gt; ip: i_ino =3D 0x1bd33, i_flags =3D 0x0<br>
&gt; ip-&gt;i_d: di_nlink =3D 0x0, di_gen =3D 0x53068791<br>
&gt;<br>
&gt; debugfs events trace:<br>
&gt; <a href=3D"https://docs.google.com/file/d/0B7n2C4T5tfNCREZtdC1yamc0RnM=
/edit?usp=3Dsharing" target=3D"_blank">https://docs.google.com/file/d/0B7n2=
C4T5tfNCREZtdC1yamc0RnM/edit?usp=3Dsharing</a><br>
<br>
</div>Same issue, one file was unlinked twice in a race:<br>
<br>
=3D=3D=3D ino 0x6b133 =3D=3D=3D<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&lt;...&gt;-4477 &nbsp;[003] &nbsp=
;2721.176790: xfs_iunlink: dev 8:16 ino 0x6b133<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&lt;...&gt;-4477 &nbsp;[003] &nbsp=
;2721.176839: xfs_iunlink_remove: dev 8:16 ino 0x6b133<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&lt;...&gt;-4477 &nbsp;[009] &nbsp=
;3320.127227: xfs_iunlink: dev 8:16 ino 0x6b133<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&lt;...&gt;-4477 &nbsp;[001] &nbsp=
;3320.141126: xfs_iunlink_remove: dev 8:16 ino 0x6b133<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&lt;...&gt;-4477 &nbsp;[003] &nbsp=
;7973.136368: xfs_iunlink: dev 8:16 ino 0x6b133<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&lt;...&gt;-4479 &nbsp;[018] &nbsp=
;7973.158457: xfs_iunlink: dev 8:16 ino 0x6b133<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&lt;...&gt;-4479 &nbsp;[018] &nbsp=
;7973.158497: xfs_iunlink_remove: dev 8:16 ino 0x6b133<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
-Eric<br>
<br>
</font></span></blockquote></div><br><br clear=3D"all"><br>-- <br>=B7=FB=D3=
=C0=CC=CE
</div>

--14dae9340b5fbba3e004dab82800--


--===============0586602974841907527==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0586602974841907527==--
