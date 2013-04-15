Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C04B07F4C
	for <xfs@oss.sgi.com>; Mon, 15 Apr 2013 09:21:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AD45130404E
	for <xfs@oss.sgi.com>; Mon, 15 Apr 2013 07:21:38 -0700 (PDT)
Received: from mail-ie0-f180.google.com (mail-ie0-f180.google.com
	[209.85.223.180]) by cuda.sgi.com with ESMTP id
	MVGw8MkAZyX6we0N (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 15 Apr 2013 07:21:37 -0700 (PDT)
Received: by mail-ie0-f180.google.com with SMTP id qd14so40776ieb.25
	for <xfs@oss.sgi.com>; Mon, 15 Apr 2013 07:21:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <516C0752.8070007@sandeen.net>
References: <CADFMGuJm5bPPwbbUtYwrCVDL23KExJTw_-VRX2UEEdZjo+i5oA@mail.gmail.com>
	<CADFMGuLxgBFU=FUK94tPsCh+qxRW0rEELxSXYoMQLFJ1u3=q0Q@mail.gmail.com>
	<516746AC.3090808@redhat.com>
	<CADFMGuK-tJQFQzN9wN0LiWWj6SY4tg_c0W9dJadctg=ytegB+w@mail.gmail.com>
	<516798AE.9050908@sandeen.net>
	<CADFMGuK67G85+J3LAjS=w_nkkSrj7At9HnPLSL-DBO6g0V=ThA@mail.gmail.com>
	<CADFMGuLNmSpA+e2Wo0qS5y2evQM=q_oVJJPf6kZkfAP4jfk=6w@mail.gmail.com>
	<CADFMGuJoar_uKB_Lrq0nKFsbdjyZWFaHXU-ni2ky3sToSQwUSQ@mail.gmail.com>
	<516800F7.80502@redhat.com>
	<CADFMGuKH_jYhuxzMQ_4mj_Zv4EgPfpuBYR=fpqBfJPWf=POJPQ@mail.gmail.com>
	<CADFMGuJmNLTcyb4aQmbto--dgFBgP55QWeaP+grAoPL+q8eRCg@mail.gmail.com>
	<CADFMGuKsDHFt_XOvjHKR=s6c7LsJYw=Jr5DXvTyswrXQT2g7yA@mail.gmail.com>
	<CADFMGuJMjKc1QoS-Ewt6wG2uSWjyWfQevQg7ZVMer0XSpx3Vjg@mail.gmail.com>
	<CADFMGuJDhq810CRE1TMJga6LN25i+Xm9EeGEhO_wTZrbXe8EFg@mail.gmail.com>
	<CADFMGuKdUJ6U5_tVNGStZRyALp94n=M7x7C_CVqAfAbEwsuBFw@mail.gmail.com>
	<CADFMGuJ5vngJZDKUPn0=i32-Y_8fpJC+DRzutZ7+D9NSrfCy=Q@mail.gmail.com>
	<516C0752.8070007@sandeen.net>
Date: Mon, 15 Apr 2013 22:21:36 +0800
Message-ID: <CADFMGuJEiqqxn8cOftjLEHjFe2NRaW2f=ay-y55nurezPvkDuA@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============1615944671216813740=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Brian Foster <bfoster@redhat.com>, Ben Myers <bpm@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============1615944671216813740==
Content-Type: multipart/alternative; boundary=047d7b10d1b77b7a5704da66f804

--047d7b10d1b77b7a5704da66f804
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

Hi Eric,
I'm sorry for spaming.
And I got some more info and hope you're interested.
In glusterfs3.3
glusterfsd/src/glusterfsd.c line 1332 there's an unlink operation.
        if (ctx->cmd_args.pid_file) {
                unlink (ctx->cmd_args.pid_file);
                ctx->cmd_args.pid_file =3D NULL;
        }
Glusterfs try to unlink the rebalance pid file after complete and may be
this is where the issue happens.
See logs bellow:
1.
/var/log/secure indicates I start rebalance on Apr 15 11:58:11
Apr 15 11:58:11 10 sudo:     root : TTY=3Dpts/2 ; PWD=3D/root ; USER=3Droot=
 ;
COMMAND=3D/usr/sbin/gluster volume rebalance testbug start
2.
After xfs shutdown I got the following log:
--- xfs_iunlink_remove --
module("xfs").function("xfs_iunlink_remove@fs/xfs/xfs_inode.c:1680").return
-- return=3D0x16
vars: tp=3D0xffff881c81797c70 ip=3D0xffff881003c13c00 next_ino=3D? mp=3D? a=
gi=3D?
dip=3D? agibp=3D0xffff880109b47e20 ibp=3D? agno=3D? agino=3D? next_agino=3D=
? last_ibp=3D?
last_dip=3D0xffff882000000000 bucket_index=3D? offset=3D?
last_offset=3D0xffffffffffff8810 error=3D? __func__=3D[...]
ip: i_ino =3D 0x113, i_flags =3D 0x0
the inode is lead to xfs shutdown is
0x113
3.
I repair xfs and in lost+foud I find the inode:
[root@10.23.72.93 lost+found]# pwd
/mnt/xfsd/lost+found
[root@10.23.72.93 lost+found]# ls -l 275
---------T 1 root root 0 Apr 15 11:58 275
[root@10.23.72.93 lost+found]# stat 275
  File: `275'
  Size: 0               Blocks: 0          IO Block: 4096   regular empty
file
Device: 810h/2064d      Inode: 275         Links: 1
Access: (1000/---------T)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2013-04-15 11:58:25.833443445 +0800
Modify: 2013-04-15 11:58:25.912461256 +0800
Change: 2013-04-15 11:58:25.915442091 +0800
This file is created aroud 2013-04-15 11:58.
And the other files in lost+foud has extended attribute but this file
doesn't. Which means it is not part of glusterfs backend files. It should
be the rebalance pid file.

So may be unlink the rebalance pid file leads to xfs shutdown.

Thank you.



2013/4/15 Eric Sandeen <sandeen@sandeen.net>

> On 4/15/13 8:45 AM, =B7=FB=D3=C0=CC=CE wrote:
> > And at the same time we got the following error log of glusterfs:
> > [2013-04-15 20:43:03.851163] I
> [dht-rebalance.c:1611:gf_defrag_status_get] 0-glusterfs: Rebalance is
> completed
> > [2013-04-15 20:43:03.851248] I
> [dht-rebalance.c:1614:gf_defrag_status_get] 0-glusterfs: Files migrated:
> 1629, size: 1582329065954, lookups: 11036, failures: 561
> > [2013-04-15 20:43:03.887634] W [glusterfsd.c:831:cleanup_and_exit]
> (-->/lib64/libc.so.6(clone+0x6d) [0x3bd16e767d]
> (-->/lib64/libpthread.so.0() [0x3bd1a07851]
> (-->/usr/sbin/glusterfs(glusterfs_sigwaiter+0xdd) [0x405c9d]))) 0-:
> received signum (15), shutting down
> > [2013-04-15 20:43:03.887878] E
> [rpcsvc.c:1155:rpcsvc_program_unregister_portmap] 0-rpc-service: Could no=
t
> unregister with portmap
> >
>
> We'll take a look, thanks.
>
> Going forward, could I ask that you take a few minutes to batch up the
> information, rather than sending several emails in a row?  It makes it mu=
ch
> harder to collect the information when it's spread across so many emails.
>
> Thanks,
> -Eric
>
>


--=20
=B7=FB=D3=C0=CC=CE

--047d7b10d1b77b7a5704da66f804
Content-Type: text/html; charset=GB2312
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div><div><div><div><div><div><div><div><di=
v><div>Hi <span name=3D"Eric Sandeen" class=3D"">Eric,<br></span></div><spa=
n name=3D"Eric Sandeen" class=3D"">I&#39;m sorry for spaming. <br></span></=
div><span name=3D"Eric Sandeen" class=3D"">And I got some more info and hop=
e you&#39;re interested.<br>
</span></div><span name=3D"Eric Sandeen" class=3D"">In glusterfs3.3<br></sp=
an></div><span name=3D"Eric Sandeen" class=3D"">glusterfsd/src/glusterfsd.c=
 line 1332 there&#39;s an unlink operation.<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; if (ctx-&gt;cmd_args.pid_file) {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; unlink (ctx-&gt;cmd_args.pid_file);<br>&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ctx-=
&gt;cmd_args.pid_file =3D NULL;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; }<br></span></div><span name=3D"Eric Sandeen" class=3D"">Glusterfs try t=
o unlink the rebalance pid file after complete and may be this is where the=
 issue happens.<br>
</span></div><span name=3D"Eric Sandeen" class=3D"">See logs bellow:<br>1.<=
br></span></div><span name=3D"Eric Sandeen" class=3D"">/var/log/secure indi=
cates I start rebalance on Apr 15 11:58:11<br>Apr 15 11:58:11 10 sudo:&nbsp=
;&nbsp;&nbsp;&nbsp; root : TTY=3Dpts/2 ; PWD=3D/root ; USER=3Droot ; COMMAN=
D=3D/usr/sbin/gluster volume rebalance testbug start<br>
2.<br></span></div><span name=3D"Eric Sandeen" class=3D"">After xfs shutdow=
n I got the following log:<br>--- xfs_iunlink_remove -- module(&quot;xfs&qu=
ot;).function(&quot;xfs_iunlink_remove@fs/xfs/xfs_inode.c:1680&quot;).retur=
n -- return=3D0x16<br>
vars: tp=3D0xffff881c81797c70 ip=3D0xffff881003c13c00 next_ino=3D? mp=3D? a=
gi=3D? dip=3D? agibp=3D0xffff880109b47e20 ibp=3D? agno=3D? agino=3D? next_a=
gino=3D? last_ibp=3D? last_dip=3D0xffff882000000000 bucket_index=3D? offset=
=3D? last_offset=3D0xffffffffffff8810 error=3D? __func__=3D[...]<br>
ip: i_ino =3D 0x113, i_flags =3D 0x0<br></span></div><span name=3D"Eric San=
deen" class=3D"">the inode is </span>lead to xfs shutdown is<br><span name=
=3D"Eric Sandeen" class=3D"">0x113<br>3. <br></span></div><span name=3D"Eri=
c Sandeen" class=3D"">I repair xfs and in lost+foud I find the inode:<br>
[<a href=3D"mailto:root@10.23.72.93">root@10.23.72.93</a> lost+found]# pwd<=
br>/mnt/xfsd/lost+found<br>[<a href=3D"mailto:root@10.23.72.93">root@10.23.=
72.93</a> lost+found]# ls -l 275<br>---------T 1 root root 0 Apr 15 11:58 2=
75<br>
[<a href=3D"mailto:root@10.23.72.93">root@10.23.72.93</a> lost+found]# stat=
 275<br>&nbsp; File: `275&#39;<br>&nbsp; Size: 0&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Blocks: 0&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; IO Block: 4096&nbsp;&nbsp; r=
egular empty file<br>Device: 810h/2064d&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Inode=
: 275&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Links: 1<br>
Access: (1000/---------T)&nbsp; Uid: (&nbsp;&nbsp;&nbsp; 0/&nbsp;&nbsp;&nbs=
p; root)&nbsp;&nbsp; Gid: (&nbsp;&nbsp;&nbsp; 0/&nbsp;&nbsp;&nbsp; root)<br=
>Access: 2013-04-15 11:58:25.833443445 +0800<br>Modify: 2013-04-15 11:58:25=
.912461256 +0800<br>Change: 2013-04-15 11:58:25.915442091 +0800<br></span><=
/div>
<div><span name=3D"Eric Sandeen" class=3D"">This file is created aroud </sp=
an><span name=3D"Eric Sandeen" class=3D"">2013-04-15 11:58.</span></div><sp=
an name=3D"Eric Sandeen" class=3D"">And the other files in lost+foud has ex=
tended attribute but this file doesn&#39;t. Which means it is not part of g=
lusterfs backend files. It should be the rebalance pid file.<br>
<br></span></div><span name=3D"Eric Sandeen" class=3D"">So may be unlink th=
e rebalance pid file leads to xfs shutdown.<br><br></span></div><span name=
=3D"Eric Sandeen" class=3D"">Thank you.<br></span><div><div><div><div><div>=
<div>
<span name=3D"Eric Sandeen" class=3D""><br></span></div></div></div></div><=
/div></div></div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quo=
te">2013/4/15 Eric Sandeen <span dir=3D"ltr">&lt;<a href=3D"mailto:sandeen@=
sandeen.net" target=3D"_blank">sandeen@sandeen.net</a>&gt;</span><br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"im">On 4/15/13 8:45 AM, =B7=FB=
=D3=C0=CC=CE wrote:<br>
&gt; And at the same time we got the following error log of glusterfs:<br>
&gt; [2013-04-15 20:43:03.851163] I [dht-rebalance.c:1611:gf_defrag_status_=
get] 0-glusterfs: Rebalance is completed<br>
&gt; [2013-04-15 20:43:03.851248] I [dht-rebalance.c:1614:gf_defrag_status_=
get] 0-glusterfs: Files migrated: 1629, size: 1582329065954, lookups: 11036=
, failures: 561<br>
&gt; [2013-04-15 20:43:03.887634] W [glusterfsd.c:831:cleanup_and_exit] (--=
&gt;/lib64/libc.so.6(clone+0x6d) [0x3bd16e767d] (--&gt;/lib64/libpthread.so=
.0() [0x3bd1a07851] (--&gt;/usr/sbin/glusterfs(glusterfs_sigwaiter+0xdd) [0=
x405c9d]))) 0-: received signum (15), shutting down<br>

&gt; [2013-04-15 20:43:03.887878] E [rpcsvc.c:1155:rpcsvc_program_unregiste=
r_portmap] 0-rpc-service: Could not unregister with portmap<br>
&gt;<br>
<br>
</div>We&#39;ll take a look, thanks.<br>
<br>
Going forward, could I ask that you take a few minutes to batch up the info=
rmation, rather than sending several emails in a row? &nbsp;It makes it muc=
h harder to collect the information when it&#39;s spread across so many ema=
ils.<br>

<br>
Thanks,<br>
-Eric<br>
<br>
</blockquote></div><br><br clear=3D"all"><br>-- <br>=B7=FB=D3=C0=CC=CE
</div>

--047d7b10d1b77b7a5704da66f804--


--===============1615944671216813740==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1615944671216813740==--
