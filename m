Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 85B9B7FB4
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 10:07:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2F3D58F804C
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 08:07:50 -0700 (PDT)
Received: from mail-ia0-f172.google.com (mail-ia0-f172.google.com
	[209.85.210.172]) by cuda.sgi.com with ESMTP id
	RsRnH7gfAtNyP8dd (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 09 Apr 2013 08:07:48 -0700 (PDT)
Received: by mail-ia0-f172.google.com with SMTP id k38so2688055iah.31
	for <xfs@oss.sgi.com>; Tue, 09 Apr 2013 08:07:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130409145238.GE22182@sgi.com>
References: <CADFMGuJm5bPPwbbUtYwrCVDL23KExJTw_-VRX2UEEdZjo+i5oA@mail.gmail.com>
	<CADFMGu+=MM2yc=_peboV7JTNJ8F05TJfexmEErzcf0D8mAWFRg@mail.gmail.com>
	<CADFMGuKqkPbpcU=taqjTR4sA3o=w1LLAnKoEuj=OhJqEbQVijw@mail.gmail.com>
	<20130409145238.GE22182@sgi.com>
Date: Tue, 9 Apr 2013 23:07:47 +0800
Message-ID: <CADFMGuJaiH0wuxOHrDjDn7qRVH+vQkLOOSPUyqSdXnLcS47t3w@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============5270640638114012699=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

--===============5270640638114012699==
Content-Type: multipart/alternative; boundary=bcaec5101ccb959bb604d9eeeafc

--bcaec5101ccb959bb604d9eeeafc
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

before xfs force shutdown happens there seems no useful log in
/var/log/messages

Apr  9 10:38:08 cqdx smbd[4597]:   Unable to connect to CUPS server
localhost:631 - Connection refused
Apr  9 10:38:08 cqdx smbd[3394]: [2013/04/09 10:38:08.944125,  0]
printing/print_cups.c:468(cups_async_callback)
Apr  9 10:38:08 cqdx smbd[3394]:   failed to retrieve printer list:
NT_STATUS_UNSUCCESSFUL
Apr  9 10:51:09 cqdx smbd[5205]: [2013/04/09 10:51:09.723610,  0]
printing/print_cups.c:109(cups_connect)
Apr  9 10:51:09 cqdx smbd[5205]:   Unable to connect to CUPS server
localhost:631 - Connection refused
Apr  9 10:51:09 cqdx smbd[3394]: [2013/04/09 10:51:09.724132,  0]
printing/print_cups.c:468(cups_async_callback)
Apr  9 10:51:09 cqdx smbd[3394]:   failed to retrieve printer list:
NT_STATUS_UNSUCCESSFUL
Apr  9 11:01:30 cqdx kernel: XFS (sdb): xfs_iunlink_remove: xfs_inotobp()
returned error 22.
Apr  9 11:01:30 cqdx kernel: XFS (sdb): xfs_inactive: xfs_ifree returned
error 22
Apr  9 11:01:30 cqdx kernel: XFS (sdb): xfs_do_force_shutdown(0x1) called
from line 1184 of file fs/xfs/xfs_vnodeops.c.  Return address =3D
0xffffffffa02ee20a
Apr  9 11:01:30 cqdx kernel: XFS (sdb): I/O Error Detected. Shutting down
filesystem
Apr  9 11:01:30 cqdx kernel: XFS (sdb): Please umount the filesystem and
rectify the problem(s)
Apr  9 11:01:51 cqdx kernel: XFS (sdb): xfs_log_force: error 5 returned.
Apr  9 11:02:21 cqdx kernel: XFS (sdb): xfs_log_force: error 5 returned.
Apr  9 11:02:51 cqdx kernel: XFS (sdb): xfs_log_force: error 5 returned.
Apr  9 11:03:21 cqdx kernel: XFS (sdb): xfs_log_force: error 5 returned.
Apr  9 11:03:51 cqdx kernel: XFS (sdb): xfs_log_force: error 5 returned.
Apr  9 11:03:57 cqdx init: tty (/dev/tty1) main process (3427) killed by
TERM signal
Apr  9 11:03:57 cqdx init: tty (/dev/tty2) main process (3429) killed by
TERM signal



2013/4/9 Ben Myers <bpm@sgi.com>

> Hey Yongtaofu,
>
> On Tue, Apr 09, 2013 at 09:05:32PM +0800, =B7=FB=D3=C0=CC=CE wrote:
> > Also I want to know why all the server, all crash with the same crash
> stack?
> > Thank you, really need your help.
>
> What you've posted so far looks like evidence of a forced shutdown and no=
t
> a
> crash.  Is there a crash in addition to this forced shutdown?  If so, can
> you
> post the stack for that too?
>
> >
> > 2013/4/9, =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com>:
> > > BTW
> > > xfs_info /dev/sdb
> > > meta-data=3D/dev/sdb               isize=3D256    agcount=3D28,
> agsize=3D268435440
> > > blks
> > >          =3D                       sectsz=3D512   attr=3D2
> > > data     =3D                       bsize=3D4096   blocks=3D7324303360=
,
> imaxpct=3D5
> > >          =3D                       sunit=3D16     swidth=3D160 blks
> > > naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
> > > log      =3Dinternal               bsize=3D4096   blocks=3D521728, ve=
rsion=3D2
> > >          =3D                       sectsz=3D512   sunit=3D16 blks,
> lazy-count=3D1
> > > realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtexten=
ts=3D0
> > >
> > > 2013/4/9, =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com>:
> > >> Dear xfs experts,
> > >> I really need your help sincerely!!! In our production enviroment we
> > >> run glusterfs over top of xfs on Dell x720D(Raid 6). And the xfs fil=
e
> > >> system crash on some of the server frequently about every two weeks.
> > >> Can you help to give me a direction about how to debug this issue an=
d
> > >> how to avoid it? Thank you very very much!
> > >>
> > >> uname -a
> > >> Linux cqdx.miaoyan.cluster1.node11.qiyi.domain 2.6.32-279.el6.x86_64
> > >> #1 SMP Wed Jun 13 18:24:36 EDT 2012 x86_64 x86_64 x86_64 GNU/Linux
> > >>
> > >> Every time the crash log is same, as following
>
> An initial guess is that somehow it is looking up a bad inode number, e.g=
.
> it
> is beyond the end of the filesystem and xfs_dilocate returns EINVAL.
>
> You could 'xfs_repair -n' to see what it finds (without modifying the
> filesystem) as a first step.
>
> > >> 038 Apr  9 09:41:36 cqdx kernel: XFS (sdb): xfs_iunlink_remove:
> > >> xfs_inotobp() returned error 22.
>
> Were there any lines of output before this?  In some codebases there are
> prints
> in xfs_inotobp that would help show what happened.
>
> > >> 1039 Apr  9 09:41:36 cqdx kernel: XFS (sdb): xfs_inactive: xfs_ifree
> > >> returned error 22
> > >> 1040 Apr  9 09:41:36 cqdx kernel: XFS (sdb):
> > >> xfs_do_force_shutdown(0x1) called from line 1184 of file
> > >> fs/xfs/xfs_vnodeops.c.  Return address =3D 0xffffffffa02ee20a
> > >> 1041 Apr  9 09:41:36 cqdx kernel: XFS (sdb): I/O Error Detected.
> > >> Shutting down filesystem
> > >> 1042 Apr  9 09:41:36 cqdx kernel: XFS (sdb): Please umount the
> > >> filesystem and rectify the problem(s)
> > >> 1043 Apr  9 09:41:53 cqdx kernel: XFS (sdb): xfs_log_force: error 5
> > >> returned.
> > >> 1044 Apr  9 09:42:23 cqdx kernel: XFS (sdb): xfs_log_force: error 5
> > >> returned.
> > >> 1045 Apr  9 09:42:53 cqdx kernel: XFS (sdb): xfs_log_force: error 5
> > >> returned.
> > >> 1046 Apr  9 09:43:23 cqdx kernel: XFS (sdb): xfs_log_force: error 5
> > >> returned.
>
> The error 5 (EIO) look scary but they are due to the forced shutdown, don=
't
> worry about them.
>
> Thanks,
>         Ben
>



--=20
=B7=FB=D3=C0=CC=CE

--bcaec5101ccb959bb604d9eeeafc
Content-Type: text/html; charset=GB2312
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">before xfs force shutdown happens there seems no useful lo=
g in /var/log/messages<br><br>Apr&nbsp; 9 10:38:08 cqdx smbd[4597]:&nbsp;&n=
bsp; Unable to connect to CUPS server localhost:631 - Connection refused<br=
>Apr&nbsp; 9 10:38:08 cqdx smbd[3394]: [2013/04/09 10:38:08.944125,&nbsp; 0=
] printing/print_cups.c:468(cups_async_callback)<br>
Apr&nbsp; 9 10:38:08 cqdx smbd[3394]:&nbsp;&nbsp; failed to retrieve printe=
r list: NT_STATUS_UNSUCCESSFUL<br>Apr&nbsp; 9 10:51:09 cqdx smbd[5205]: [20=
13/04/09 10:51:09.723610,&nbsp; 0] printing/print_cups.c:109(cups_connect)<=
br>Apr&nbsp; 9 10:51:09 cqdx smbd[5205]:&nbsp;&nbsp; Unable to connect to C=
UPS server localhost:631 - Connection refused<br>
Apr&nbsp; 9 10:51:09 cqdx smbd[3394]: [2013/04/09 10:51:09.724132,&nbsp; 0]=
 printing/print_cups.c:468(cups_async_callback)<br>Apr&nbsp; 9 10:51:09 cqd=
x smbd[3394]:&nbsp;&nbsp; failed to retrieve printer list: NT_STATUS_UNSUCC=
ESSFUL<br>Apr&nbsp; 9 11:01:30 cqdx kernel: XFS (sdb): xfs_iunlink_remove: =
xfs_inotobp() returned error 22.<br>
Apr&nbsp; 9 11:01:30 cqdx kernel: XFS (sdb): xfs_inactive: xfs_ifree return=
ed error 22<br>Apr&nbsp; 9 11:01:30 cqdx kernel: XFS (sdb): xfs_do_force_sh=
utdown(0x1) called from line 1184 of file fs/xfs/xfs_vnodeops.c.&nbsp; Retu=
rn address =3D 0xffffffffa02ee20a<br>
Apr&nbsp; 9 11:01:30 cqdx kernel: XFS (sdb): I/O Error Detected. Shutting d=
own filesystem<br>Apr&nbsp; 9 11:01:30 cqdx kernel: XFS (sdb): Please umoun=
t the filesystem and rectify the problem(s)<br>Apr&nbsp; 9 11:01:51 cqdx ke=
rnel: XFS (sdb): xfs_log_force: error 5 returned.<br>
Apr&nbsp; 9 11:02:21 cqdx kernel: XFS (sdb): xfs_log_force: error 5 returne=
d.<br>Apr&nbsp; 9 11:02:51 cqdx kernel: XFS (sdb): xfs_log_force: error 5 r=
eturned.<br>Apr&nbsp; 9 11:03:21 cqdx kernel: XFS (sdb): xfs_log_force: err=
or 5 returned.<br>
Apr&nbsp; 9 11:03:51 cqdx kernel: XFS (sdb): xfs_log_force: error 5 returne=
d.<br>Apr&nbsp; 9 11:03:57 cqdx init: tty (/dev/tty1) main process (3427) k=
illed by TERM signal<br>Apr&nbsp; 9 11:03:57 cqdx init: tty (/dev/tty2) mai=
n process (3429) killed by TERM signal<br>
<br></div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">201=
3/4/9 Ben Myers <span dir=3D"ltr">&lt;<a href=3D"mailto:bpm@sgi.com" target=
=3D"_blank">bpm@sgi.com</a>&gt;</span><br><blockquote class=3D"gmail_quote"=
 style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
Hey Yongtaofu,<br>
<div class=3D"im"><br>
On Tue, Apr 09, 2013 at 09:05:32PM +0800, =B7=FB=D3=C0=CC=CE wrote:<br>
&gt; Also I want to know why all the server, all crash with the same crash =
stack?<br>
&gt; Thank you, really need your help.<br>
<br>
</div>What you&#39;ve posted so far looks like evidence of a forced shutdow=
n and not a<br>
crash. &nbsp;Is there a crash in addition to this forced shutdown? &nbsp;If=
 so, can you<br>
post the stack for that too?<br>
<div class=3D"im"><br>
&gt;<br>
&gt; 2013/4/9, =B7=FB=D3=C0=CC=CE &lt;<a href=3D"mailto:yongtaofu@gmail.com=
">yongtaofu@gmail.com</a>&gt;:<br>
&gt; &gt; BTW<br>
&gt; &gt; xfs_info /dev/sdb<br>
&gt; &gt; meta-data=3D/dev/sdb &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; isize=3D256 &nbsp; &nbsp;agcount=3D28, agsize=3D268435440<br>
&gt; &gt; blks<br>
&gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=3D &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; sectsz=3D512 &nbsp; attr=
=3D2<br>
&gt; &gt; data &nbsp; &nbsp; =3D &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; bsize=3D4096 &nbsp; blocks=3D7324303360,=
 imaxpct=3D5<br>
&gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=3D &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; sunit=3D16 &nbsp; &nbsp; =
swidth=3D160 blks<br>
&gt; &gt; naming &nbsp; =3Dversion 2 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp;bsize=3D4096 &nbsp; ascii-ci=3D0<br>
&gt; &gt; log &nbsp; &nbsp; &nbsp;=3Dinternal &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; bsize=3D4096 &nbsp; blocks=3D521728, version=3D2<br>
&gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=3D &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; sectsz=3D512 &nbsp; sunit=
=3D16 blks, lazy-count=3D1<br>
&gt; &gt; realtime =3Dnone &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; extsz=3D4096 &nbsp; blocks=3D0, rtextents=3D0<br>
&gt; &gt;<br>
&gt; &gt; 2013/4/9, =B7=FB=D3=C0=CC=CE &lt;<a href=3D"mailto:yongtaofu@gmai=
l.com">yongtaofu@gmail.com</a>&gt;:<br>
&gt; &gt;&gt; Dear xfs experts,<br>
&gt; &gt;&gt; I really need your help sincerely!!! In our production enviro=
ment we<br>
&gt; &gt;&gt; run glusterfs over top of xfs on Dell x720D(Raid 6). And the =
xfs file<br>
&gt; &gt;&gt; system crash on some of the server frequently about every two=
 weeks.<br>
&gt; &gt;&gt; Can you help to give me a direction about how to debug this i=
ssue and<br>
&gt; &gt;&gt; how to avoid it? Thank you very very much!<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; uname -a<br>
&gt; &gt;&gt; Linux cqdx.miaoyan.cluster1.node11.qiyi.domain 2.6.32-279.el6=
.x86_64<br>
&gt; &gt;&gt; #1 SMP Wed Jun 13 18:24:36 EDT 2012 x86_64 x86_64 x86_64 GNU/=
Linux<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; Every time the crash log is same, as following<br>
<br>
</div>An initial guess is that somehow it is looking up a bad inode number,=
 e.g. it<br>
is beyond the end of the filesystem and xfs_dilocate returns EINVAL.<br>
<br>
You could &#39;xfs_repair -n&#39; to see what it finds (without modifying t=
he<br>
filesystem) as a first step.<br>
<div class=3D"im"><br>
&gt; &gt;&gt; 038 Apr &nbsp;9 09:41:36 cqdx kernel: XFS (sdb): xfs_iunlink_=
remove:<br>
&gt; &gt;&gt; xfs_inotobp() returned error 22.<br>
<br>
</div>Were there any lines of output before this? &nbsp;In some codebases t=
here are prints<br>
in xfs_inotobp that would help show what happened.<br>
<div class=3D"im"><br>
&gt; &gt;&gt; 1039 Apr &nbsp;9 09:41:36 cqdx kernel: XFS (sdb): xfs_inactiv=
e: xfs_ifree<br>
&gt; &gt;&gt; returned error 22<br>
&gt; &gt;&gt; 1040 Apr &nbsp;9 09:41:36 cqdx kernel: XFS (sdb):<br>
&gt; &gt;&gt; xfs_do_force_shutdown(0x1) called from line 1184 of file<br>
&gt; &gt;&gt; fs/xfs/xfs_vnodeops.c. &nbsp;Return address =3D 0xffffffffa02=
ee20a<br>
&gt; &gt;&gt; 1041 Apr &nbsp;9 09:41:36 cqdx kernel: XFS (sdb): I/O Error D=
etected.<br>
&gt; &gt;&gt; Shutting down filesystem<br>
&gt; &gt;&gt; 1042 Apr &nbsp;9 09:41:36 cqdx kernel: XFS (sdb): Please umou=
nt the<br>
&gt; &gt;&gt; filesystem and rectify the problem(s)<br>
&gt; &gt;&gt; 1043 Apr &nbsp;9 09:41:53 cqdx kernel: XFS (sdb): xfs_log_for=
ce: error 5<br>
&gt; &gt;&gt; returned.<br>
&gt; &gt;&gt; 1044 Apr &nbsp;9 09:42:23 cqdx kernel: XFS (sdb): xfs_log_for=
ce: error 5<br>
&gt; &gt;&gt; returned.<br>
&gt; &gt;&gt; 1045 Apr &nbsp;9 09:42:53 cqdx kernel: XFS (sdb): xfs_log_for=
ce: error 5<br>
&gt; &gt;&gt; returned.<br>
&gt; &gt;&gt; 1046 Apr &nbsp;9 09:43:23 cqdx kernel: XFS (sdb): xfs_log_for=
ce: error 5<br>
&gt; &gt;&gt; returned.<br>
<br>
</div>The error 5 (EIO) look scary but they are due to the forced shutdown,=
 don&#39;t<br>
worry about them.<br>
<br>
Thanks,<br>
&nbsp; &nbsp; &nbsp; &nbsp; Ben<br>
</blockquote></div><br><br clear=3D"all"><br>-- <br>=B7=FB=D3=C0=CC=CE
</div>

--bcaec5101ccb959bb604d9eeeafc--


--===============5270640638114012699==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5270640638114012699==--
