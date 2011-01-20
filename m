Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0KC6nR4079389 for <xfs@oss.sgi.com>; Thu, 20 Jan 2011 06:06:49 -0600
Received: from passage.avira.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2449E27A0CC
	for <xfs@oss.sgi.com>; Thu, 20 Jan 2011 04:09:05 -0800 (PST)
Received: from passage.avira.com (passage.avira.com [89.238.222.20]) by
	cuda.sgi.com with ESMTP id GnEWAxI4zVc05LkJ for
	<xfs@oss.sgi.com>; Thu, 20 Jan 2011 04:09:05 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by passage.avira.com (Postfix/AVIRA) with ESMTP id 3EF41124939
	for <xfs@oss.sgi.com>; Thu, 20 Jan 2011 14:09:01 +0200 (EET)
Received: from naliboat.bu.avira.com (dasapass.avira.com [89.238.222.18])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "mail.bu.avira.com",
	Issuer "Avira Intermediate Certificate Authority 2010-2020" (not
	verified))
	by passage.avira.com (Postfix/AVIRA) with ESMTPS id 185E2124939
	for <xfs@oss.sgi.com>; Thu, 20 Jan 2011 14:09:01 +0200 (EET)
Date: Thu, 20 Jan 2011 14:07:00 +0200
From: Petre Rodan <petre.rodan@simplex.ro>
Subject: Re: xfssyncd and disk spin down
Message-ID: <20110120120700.GA5449@peter.simplex.ro>
References: <20101223165532.GA23813@peter.simplex.ro>
	<20101227021904.GA24828@dastard>
	<20101227061629.GA2275@pandora.simplex.ro>
	<20101227140750.GB24828@dastard>
	<20101227171939.GA7759@pandora.simplex.ro>
	<20101231001323.GD15179@dastard>
	<20110120100143.GA2007@peter.simplex.ro>
	<20110120110605.GU16267@dastard>
MIME-Version: 1.0
In-Reply-To: <20110120110605.GU16267@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8607833217688722652=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


--===============8607833217688722652==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H+4ONPRPur6+Ovig"
Content-Disposition: inline


--H+4ONPRPur6+Ovig
Content-Type: multipart/mixed; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hello Dave,

On Thu, Jan 20, 2011 at 10:06:05PM +1100, Dave Chinner wrote:
> ....
> > in other words xfsyncd and xfsbufd now alternate at 18s intervals
> > keeping the drive busy with nothing constructive hours after the
> > last write to the drive.
[..]
> > meta-data=3D/dev/sdc1              isize=3D256    agcount=3D4, agsize=
=3D61047552 blks
> >          =3D                       sectsz=3D512   attr=3D2
> > data     =3D                       bsize=3D4096   blocks=3D244190208, i=
maxpct=3D25
> >          =3D                       sunit=3D0      swidth=3D0 blks
> > naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
> > log      =3Dinternal               bsize=3D4096   blocks=3D119233, vers=
ion=3D2
> >          =3D                       sectsz=3D512   sunit=3D0 blks, lazy-=
count=3D0
>                                                               ^^^^^^^^^^^^
> > realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=
=3D0
>=20
> It's something to do with lazy-count=3D0. I'm look into it when I get
> the chance - I almost never test w/ lazy-count=3D0 because =3D1 is
> the default value.

thanks for the tip. looks like I'm using xfsprogs 3.0.3 (latest version in =
the gentoo stable tree) to mkfs these filesystems. can the antique version =
be somehow the root of the problem?

anyhow, changed it to:

meta-data=3D/dev/sdc1              isize=3D256    agcount=3D4, agsize=3D610=
47552 blks
         =3D                       sectsz=3D512   attr=3D2
data     =3D                       bsize=3D4096   blocks=3D244190208, imaxp=
ct=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D119233, version=
=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0

used:
xfsprogs-3.0.3
Linux starshine 2.6.38-rc1-s001 #1 SMP Thu Jan 20 10:49:20 EET 2011 x86_64 =
AMD Athlon(tm) II Neo N36L Dual-Core Processor AuthenticAMD GNU/Linux
Seagate Barracuda ES.2 ST31000340NS
Hitachi HUA722020ALA330
default (for 3.0.3 xfsprogs) mkfs options, 'noatime,nodev,nosuid,noexec' as=
 mount options.

and the behaviour did not change at all, trace attached.

it's very easy to reproduce this. all it took was

reboot
cp -a /usr/src/linux* /mnt/foo
sleep 1800
grab trace


cheers,
peter


>=20
> I'd recommend that you convert the fs to lazy-count=3D1 when you get a
> chance, anyway, because of the fact it reduces the latency of
> transactions significantly...
>=20
> Cheers,
>=20
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com

--=20
petre rodan
<petre.rodan@simplex.ro>
Technical Manager
Simplex SRL, Bucharest

--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=trace
Content-Transfer-Encoding: quoted-printable

# tracer: nop
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
   xfssyncd/sdc1-1409  [000]  2198.419444: xfs_log_reserve: dev 8:33 type D=
UMMY1 t_ocnt 1 t_cnt 1 t_curr_res 2740 t_unit_res 2740 t_flags XLOG_TIC_INI=
TED reserveq empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 4=
5622272 grant_write_cycle 1 grant_write_bytes 45622272 curr_cycle 1 curr_bl=
ock 89106 tail_cycle 1 tail_block 35956
   xfssyncd/sdc1-1409  [000]  2198.419449: xfs_log_grant_enter: dev 8:33 ty=
pe DUMMY1 t_ocnt 1 t_cnt 1 t_curr_res 2740 t_unit_res 2740 t_flags XLOG_TIC=
_INITED reserveq empty writeq empty grant_reserve_cycle 1 grant_reserve_byt=
es 45622272 grant_write_cycle 1 grant_write_bytes 45622272 curr_cycle 1 cur=
r_block 89106 tail_cycle 1 tail_block 35956
   xfssyncd/sdc1-1409  [000]  2198.419451: xfs_log_grant_exit: dev 8:33 typ=
e DUMMY1 t_ocnt 1 t_cnt 1 t_curr_res 2740 t_unit_res 2740 t_flags XLOG_TIC_=
INITED reserveq empty writeq empty grant_reserve_cycle 1 grant_reserve_byte=
s 45625012 grant_write_cycle 1 grant_write_bytes 45625012 curr_cycle 1 curr=
_block 89106 tail_cycle 1 tail_block 35956
   xfssyncd/sdc1-1409  [000]  2198.419453: xfs_buf_lock: dev 8:33 bno 0x0 l=
en 0x200 hold 1 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|PAGES caller xfs_=
getsb
   xfssyncd/sdc1-1409  [000]  2198.419455: xfs_buf_lock_done: dev 8:33 bno =
0x0 len 0x200 hold 1 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|PAGES caller=
 xfs_getsb
   xfssyncd/sdc1-1409  [000]  2198.419456: xfs_buf_hold: dev 8:33 bno 0x0 l=
en 0x200 hold 1 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|PAGES caller xfs_=
getsb
   xfssyncd/sdc1-1409  [000]  2198.419458: xfs_buf_hold: dev 8:33 bno 0x0 l=
en 0x200 hold 2 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|PAGES caller xfs_=
buf_item_init
   xfssyncd/sdc1-1409  [000]  2198.419460: xfs_trans_getsb: dev 8:33 bno 0x=
0 len 0x200 hold 3 pincount 0 lock 0 flags |MAPPED|ASYNC|DONE|PAGES recur 0=
 refcount 1 bliflags  lidesc 0xffff880106b4b570 liflags=20
   xfssyncd/sdc1-1409  [000]  2198.419462: xfs_trans_log_buf: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags |MAPPED|ASYNC|DONE|DELWRI|PAGE=
S recur 0 refcount 1 bliflags  lidesc 0xffff880106b4b570 liflags=20
   xfssyncd/sdc1-1409  [000]  2198.419465: xfs_buf_item_size: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags |MAPPED|ASYNC|DONE|DELWRI|PAGE=
S recur 0 refcount 1 bliflags |DIRTY|LOGGED lidesc 0xffff880106b4b570 lifla=
gs=20
   xfssyncd/sdc1-1409  [000]  2198.419467: xfs_buf_item_format: dev 8:33 bn=
o 0x0 len 0x200 hold 3 pincount 0 lock 0 flags |MAPPED|ASYNC|DONE|DELWRI|PA=
GES recur 0 refcount 1 bliflags |DIRTY|LOGGED lidesc 0xffff880106b4b570 lif=
lags=20
   xfssyncd/sdc1-1409  [000]  2198.419468: xfs_buf_item_pin: dev 8:33 bno 0=
x0 len 0x200 hold 3 pincount 0 lock 0 flags |MAPPED|ASYNC|DONE|DELWRI|PAGES=
 recur 0 refcount 1 bliflags |DIRTY|LOGGED lidesc 0xffff880106b4b570 liflag=
s=20
   xfssyncd/sdc1-1409  [000]  2198.419474: xfs_log_done_nonperm: dev 8:33 t=
ype DUMMY1 t_ocnt 1 t_cnt 1 t_curr_res 2000 t_unit_res 2740 t_flags  reserv=
eq empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 45625012 gr=
ant_write_cycle 1 grant_write_bytes 45625012 curr_cycle 1 curr_block 89106 =
tail_cycle 1 tail_block 35956
   xfssyncd/sdc1-1409  [000]  2198.419475: xfs_log_ungrant_enter: dev 8:33 =
type DUMMY1 t_ocnt 1 t_cnt 0 t_curr_res 2000 t_unit_res 2740 t_flags  reser=
veq empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 45625012 g=
rant_write_cycle 1 grant_write_bytes 45625012 curr_cycle 1 curr_block 89106=
 tail_cycle 1 tail_block 35956
   xfssyncd/sdc1-1409  [000]  2198.419476: xfs_log_ungrant_sub: dev 8:33 ty=
pe DUMMY1 t_ocnt 1 t_cnt 0 t_curr_res 2000 t_unit_res 2740 t_flags  reserve=
q empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 45625012 gra=
nt_write_cycle 1 grant_write_bytes 45625012 curr_cycle 1 curr_block 89106 t=
ail_cycle 1 tail_block 35956
   xfssyncd/sdc1-1409  [000]  2198.419476: xfs_log_ungrant_exit: dev 8:33 t=
ype DUMMY1 t_ocnt 1 t_cnt 0 t_curr_res 2000 t_unit_res 2740 t_flags  reserv=
eq empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 45623012 gr=
ant_write_cycle 1 grant_write_bytes 45623012 curr_cycle 1 curr_block 89106 =
tail_cycle 1 tail_block 35956
   xfssyncd/sdc1-1409  [000]  2198.419479: xfs_trans_commit_lsn: dev 8:33 t=
rans 0xffff880101c58b58 commit_lsn 0x100015c12
   xfssyncd/sdc1-1409  [000]  2198.419482: xfs_buf_item_unlock: dev 8:33 bn=
o 0x0 len 0x200 hold 3 pincount 1 lock 0 flags |MAPPED|ASYNC|DONE|DELWRI|PA=
GES recur 0 refcount 2 bliflags |DIRTY lidesc 0x          (null) liflags=20
   xfssyncd/sdc1-1409  [000]  2198.419483: xfs_buf_delwri_queue: dev 8:33 b=
no 0x0 len 0x200 hold 4 pincount 1 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PA=
GES caller xfs_buf_unlock
   xfssyncd/sdc1-1409  [000]  2198.419488: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 4 pincount 1 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_item_unlock
   xfssyncd/sdc1-1409  [000]  2198.419489: xfs_buf_rele: dev 8:33 bno 0x0 l=
en 0x200 hold 4 pincount 1 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DELW=
RI_Q caller xfs_buf_item_unlock
   xfssyncd/sdc1-1409  [000]  2198.419493: xfs_buf_iorequest: dev 8:33 bno =
0x3a398c32 len 0x8000 hold 1 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DON=
E|ORDERED|PAGES|RUN_QUEUES|0x2000 caller xlog_bdstrat
   xfssyncd/sdc1-1409  [000]  2198.419494: xfs_buf_hold: dev 8:33 bno 0x3a3=
98c32 len 0x8000 hold 1 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|ORD=
ERED|PAGES|RUN_QUEUES|0x2000 caller xfs_buf_iorequest
   xfssyncd/sdc1-1409  [000]  2198.419530: xfs_buf_rele: dev 8:33 bno 0x3a3=
98c32 len 0x8000 hold 2 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|ORD=
ERED|PAGES|RUN_QUEUES|0x2000 caller xfs_buf_iorequest
          <idle>-0     [000]  2198.439397: xfs_buf_ioerror: dev 8:33 bno 0x=
3a398c32 len 0x8000 hold 1 pincount 0 lock 0 error 0 flags WRITE|MAPPED|ASY=
NC|DONE|ORDERED|PAGES|RUN_QUEUES|0x2000 caller xfs_buf_bio_end_io
          <idle>-0     [000]  2198.439402: xfs_buf_iodone: dev 8:33 bno 0x3=
a398c32 len 0x8000 hold 1 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|O=
RDERED|PAGES|RUN_QUEUES|0x2000 caller _xfs_buf_ioend
     kworker/0:1-10    [000]  2198.439444: xfs_buf_item_committed: dev 8:33=
 bno 0x0 len 0x200 hold 3 pincount 1 lock 1 flags |MAPPED|ASYNC|DONE|DELWRI=
|PAGES|DELWRI_Q recur 0 refcount 1 bliflags |DIRTY lidesc 0x          (null=
) liflags=20
     kworker/0:1-10    [000]  2198.439447: xfs_buf_item_unpin: dev 8:33 bno=
 0x0 len 0x200 hold 3 pincount 1 lock 1 flags |MAPPED|ASYNC|DONE|DELWRI|PAG=
ES|DELWRI_Q recur 0 refcount 1 bliflags |DIRTY lidesc 0x          (null) li=
flags IN_AIL
    xfsbufd/sdc1-1407  [001]  2199.621878: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  2199.621882: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  2200.824324: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  2200.824329: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  2202.026783: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  2202.026787: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  2203.229229: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  2203.229233: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  2204.431687: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  2204.431692: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  2205.634134: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  2205.634139: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  2206.836595: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  2206.836600: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  2208.039039: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  2208.039044: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  2209.241491: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  2209.241495: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  2210.443954: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  2210.443959: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  2211.646365: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  2211.646370: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  2212.844825: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  2212.844830: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  2214.043282: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  2214.043287: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  2215.241740: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  2215.241745: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  2216.440198: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  2216.440201: xfs_buf_delwri_split: dev 8:33 b=
no 0x0 len 0x200 hold 3 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|PAG=
ES caller xfsbufd
    xfsbufd/sdc1-1407  [001]  2216.440204: xfs_buf_iorequest: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|PAGES =
caller xfs_bdstrat_cb
    xfsbufd/sdc1-1407  [001]  2216.440205: xfs_buf_hold: dev 8:33 bno 0x0 l=
en 0x200 hold 3 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|PAGES calle=
r xfs_buf_iorequest
    xfsbufd/sdc1-1407  [001]  2216.440224: xfs_buf_rele: dev 8:33 bno 0x0 l=
en 0x200 hold 4 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|PAGES calle=
r xfs_buf_iorequest
          <idle>-0     [001]  2216.440695: xfs_buf_ioerror: dev 8:33 bno 0x=
0 len 0x200 hold 3 pincount 0 lock 0 error 0 flags WRITE|MAPPED|ASYNC|DONE|=
PAGES caller xfs_buf_bio_end_io
          <idle>-0     [001]  2216.440700: xfs_buf_iodone: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|PAGES cal=
ler _xfs_buf_ioend
     kworker/1:2-1448  [001]  2216.440737: xfs_buf_rele: dev 8:33 bno 0x0 l=
en 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|PAGES caller xfs_=
buf_iodone
     kworker/1:2-1448  [001]  2216.440739: xfs_buf_iodone: dev 8:33 bno 0x0=
 len 0x200 hold 2 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|PAGES caller xf=
s_buf_iodone_callbacks
     kworker/1:2-1448  [001]  2216.440740: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 2 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|PAGES caller xf=
s_buf_iodone_work
     kworker/1:2-1448  [001]  2216.440741: xfs_buf_rele: dev 8:33 bno 0x0 l=
en 0x200 hold 2 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|PAGES caller xfs_=
buf_iodone_work
   xfssyncd/sdc1-1409  [001]  2234.393111: xfs_log_reserve: dev 8:33 type D=
UMMY1 t_ocnt 1 t_cnt 1 t_curr_res 2740 t_unit_res 2740 t_flags XLOG_TIC_INI=
TED reserveq empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 4=
5623296 grant_write_cycle 1 grant_write_bytes 45623296 curr_cycle 1 curr_bl=
ock 89108 tail_cycle 1 tail_block 35956
   xfssyncd/sdc1-1409  [001]  2234.393113: xfs_log_grant_enter: dev 8:33 ty=
pe DUMMY1 t_ocnt 1 t_cnt 1 t_curr_res 2740 t_unit_res 2740 t_flags XLOG_TIC=
_INITED reserveq empty writeq empty grant_reserve_cycle 1 grant_reserve_byt=
es 45623296 grant_write_cycle 1 grant_write_bytes 45623296 curr_cycle 1 cur=
r_block 89108 tail_cycle 1 tail_block 35956
   xfssyncd/sdc1-1409  [001]  2234.393115: xfs_log_grant_exit: dev 8:33 typ=
e DUMMY1 t_ocnt 1 t_cnt 1 t_curr_res 2740 t_unit_res 2740 t_flags XLOG_TIC_=
INITED reserveq empty writeq empty grant_reserve_cycle 1 grant_reserve_byte=
s 45626036 grant_write_cycle 1 grant_write_bytes 45626036 curr_cycle 1 curr=
_block 89108 tail_cycle 1 tail_block 35956
   xfssyncd/sdc1-1409  [001]  2234.393117: xfs_buf_lock: dev 8:33 bno 0x0 l=
en 0x200 hold 1 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|PAGES caller xfs_=
getsb
   xfssyncd/sdc1-1409  [001]  2234.393118: xfs_buf_lock_done: dev 8:33 bno =
0x0 len 0x200 hold 1 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|PAGES caller=
 xfs_getsb
   xfssyncd/sdc1-1409  [001]  2234.393119: xfs_buf_hold: dev 8:33 bno 0x0 l=
en 0x200 hold 1 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|PAGES caller xfs_=
getsb
   xfssyncd/sdc1-1409  [001]  2234.393122: xfs_buf_hold: dev 8:33 bno 0x0 l=
en 0x200 hold 2 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|PAGES caller xfs_=
buf_item_init
   xfssyncd/sdc1-1409  [001]  2234.393123: xfs_trans_getsb: dev 8:33 bno 0x=
0 len 0x200 hold 3 pincount 0 lock 0 flags |MAPPED|ASYNC|DONE|PAGES recur 0=
 refcount 1 bliflags  lidesc 0xffff880101f1f370 liflags=20
   xfssyncd/sdc1-1409  [001]  2234.393125: xfs_trans_log_buf: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags |MAPPED|ASYNC|DONE|DELWRI|PAGE=
S recur 0 refcount 1 bliflags  lidesc 0xffff880101f1f370 liflags=20
   xfssyncd/sdc1-1409  [001]  2234.393128: xfs_buf_item_size: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags |MAPPED|ASYNC|DONE|DELWRI|PAGE=
S recur 0 refcount 1 bliflags |DIRTY|LOGGED lidesc 0xffff880101f1f370 lifla=
gs=20
   xfssyncd/sdc1-1409  [001]  2234.393130: xfs_buf_item_format: dev 8:33 bn=
o 0x0 len 0x200 hold 3 pincount 0 lock 0 flags |MAPPED|ASYNC|DONE|DELWRI|PA=
GES recur 0 refcount 1 bliflags |DIRTY|LOGGED lidesc 0xffff880101f1f370 lif=
lags=20
   xfssyncd/sdc1-1409  [001]  2234.393131: xfs_buf_item_pin: dev 8:33 bno 0=
x0 len 0x200 hold 3 pincount 0 lock 0 flags |MAPPED|ASYNC|DONE|DELWRI|PAGES=
 recur 0 refcount 1 bliflags |DIRTY|LOGGED lidesc 0xffff880101f1f370 liflag=
s=20
   xfssyncd/sdc1-1409  [001]  2234.393137: xfs_log_done_nonperm: dev 8:33 t=
ype DUMMY1 t_ocnt 1 t_cnt 1 t_curr_res 2000 t_unit_res 2740 t_flags  reserv=
eq empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 45626036 gr=
ant_write_cycle 1 grant_write_bytes 45626036 curr_cycle 1 curr_block 89108 =
tail_cycle 1 tail_block 35956
   xfssyncd/sdc1-1409  [001]  2234.393138: xfs_log_ungrant_enter: dev 8:33 =
type DUMMY1 t_ocnt 1 t_cnt 0 t_curr_res 2000 t_unit_res 2740 t_flags  reser=
veq empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 45626036 g=
rant_write_cycle 1 grant_write_bytes 45626036 curr_cycle 1 curr_block 89108=
 tail_cycle 1 tail_block 35956
   xfssyncd/sdc1-1409  [001]  2234.393140: xfs_log_ungrant_sub: dev 8:33 ty=
pe DUMMY1 t_ocnt 1 t_cnt 0 t_curr_res 2000 t_unit_res 2740 t_flags  reserve=
q empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 45626036 gra=
nt_write_cycle 1 grant_write_bytes 45626036 curr_cycle 1 curr_block 89108 t=
ail_cycle 1 tail_block 35956
   xfssyncd/sdc1-1409  [001]  2234.393141: xfs_log_ungrant_exit: dev 8:33 t=
ype DUMMY1 t_ocnt 1 t_cnt 0 t_curr_res 2000 t_unit_res 2740 t_flags  reserv=
eq empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 45624036 gr=
ant_write_cycle 1 grant_write_bytes 45624036 curr_cycle 1 curr_block 89108 =
tail_cycle 1 tail_block 35956
   xfssyncd/sdc1-1409  [001]  2234.393143: xfs_trans_commit_lsn: dev 8:33 t=
rans 0xffff88011da67b58 commit_lsn 0x100015c14
   xfssyncd/sdc1-1409  [001]  2234.393146: xfs_buf_item_unlock: dev 8:33 bn=
o 0x0 len 0x200 hold 3 pincount 1 lock 0 flags |MAPPED|ASYNC|DONE|DELWRI|PA=
GES recur 0 refcount 2 bliflags |DIRTY lidesc 0x          (null) liflags=20
   xfssyncd/sdc1-1409  [001]  2234.393147: xfs_buf_delwri_queue: dev 8:33 b=
no 0x0 len 0x200 hold 4 pincount 1 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PA=
GES caller xfs_buf_unlock
   xfssyncd/sdc1-1409  [001]  2234.393152: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 4 pincount 1 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_item_unlock
   xfssyncd/sdc1-1409  [001]  2234.393153: xfs_buf_rele: dev 8:33 bno 0x0 l=
en 0x200 hold 4 pincount 1 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DELW=
RI_Q caller xfs_buf_item_unlock
   xfssyncd/sdc1-1409  [001]  2234.393157: xfs_buf_iorequest: dev 8:33 bno =
0x3a398c34 len 0x8000 hold 1 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DON=
E|ORDERED|PAGES|RUN_QUEUES|0x2000 caller xlog_bdstrat
   xfssyncd/sdc1-1409  [001]  2234.393158: xfs_buf_hold: dev 8:33 bno 0x3a3=
98c34 len 0x8000 hold 1 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|ORD=
ERED|PAGES|RUN_QUEUES|0x2000 caller xfs_buf_iorequest
   xfssyncd/sdc1-1409  [001]  2234.393194: xfs_buf_rele: dev 8:33 bno 0x3a3=
98c34 len 0x8000 hold 2 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|ORD=
ERED|PAGES|RUN_QUEUES|0x2000 caller xfs_buf_iorequest
          <idle>-0     [001]  2234.411005: xfs_buf_ioerror: dev 8:33 bno 0x=
3a398c34 len 0x8000 hold 1 pincount 0 lock 0 error 0 flags WRITE|MAPPED|ASY=
NC|DONE|ORDERED|PAGES|RUN_QUEUES|0x2000 caller xfs_buf_bio_end_io
          <idle>-0     [001]  2234.411009: xfs_buf_iodone: dev 8:33 bno 0x3=
a398c34 len 0x8000 hold 1 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|O=
RDERED|PAGES|RUN_QUEUES|0x2000 caller _xfs_buf_ioend
     kworker/1:2-1448  [001]  2234.411044: xfs_buf_item_committed: dev 8:33=
 bno 0x0 len 0x200 hold 3 pincount 1 lock 1 flags |MAPPED|ASYNC|DONE|DELWRI=
|PAGES|DELWRI_Q recur 0 refcount 1 bliflags |DIRTY lidesc 0x          (null=
) liflags=20
     kworker/1:2-1448  [001]  2234.411047: xfs_buf_item_unpin: dev 8:33 bno=
 0x0 len 0x200 hold 3 pincount 1 lock 1 flags |MAPPED|ASYNC|DONE|DELWRI|PAG=
ES|DELWRI_Q recur 0 refcount 1 bliflags |DIRTY lidesc 0x          (null) li=
flags IN_AIL
    xfsbufd/sdc1-1407  [000]  2235.591555: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2235.591560: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2236.790013: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2236.790018: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2237.988479: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2237.988484: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2239.186952: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2239.186956: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2240.385424: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2240.385428: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2241.583884: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2241.583888: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2242.782341: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2242.782345: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2243.980799: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2243.980804: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2245.179256: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2245.179260: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2246.377715: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2246.377719: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2247.576172: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2247.576177: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2248.774630: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2248.774635: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2249.973087: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2249.973092: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2251.171547: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2251.171552: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2252.370002: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2252.370006: xfs_buf_delwri_split: dev 8:33 b=
no 0x0 len 0x200 hold 3 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|PAG=
ES caller xfsbufd
    xfsbufd/sdc1-1407  [000]  2252.370008: xfs_buf_iorequest: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|PAGES =
caller xfs_bdstrat_cb
    xfsbufd/sdc1-1407  [000]  2252.370009: xfs_buf_hold: dev 8:33 bno 0x0 l=
en 0x200 hold 3 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|PAGES calle=
r xfs_buf_iorequest
    xfsbufd/sdc1-1407  [000]  2252.370029: xfs_buf_rele: dev 8:33 bno 0x0 l=
en 0x200 hold 4 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|PAGES calle=
r xfs_buf_iorequest
          <idle>-0     [001]  2252.370505: xfs_buf_ioerror: dev 8:33 bno 0x=
0 len 0x200 hold 3 pincount 0 lock 0 error 0 flags WRITE|MAPPED|ASYNC|DONE|=
PAGES caller xfs_buf_bio_end_io
          <idle>-0     [001]  2252.370510: xfs_buf_iodone: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|PAGES cal=
ler _xfs_buf_ioend
     kworker/1:2-1448  [001]  2252.370547: xfs_buf_rele: dev 8:33 bno 0x0 l=
en 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|PAGES caller xfs_=
buf_iodone
     kworker/1:2-1448  [001]  2252.370549: xfs_buf_iodone: dev 8:33 bno 0x0=
 len 0x200 hold 2 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|PAGES caller xf=
s_buf_iodone_callbacks
     kworker/1:2-1448  [001]  2252.370551: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 2 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|PAGES caller xf=
s_buf_iodone_work
     kworker/1:2-1448  [001]  2252.370551: xfs_buf_rele: dev 8:33 bno 0x0 l=
en 0x200 hold 2 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|PAGES caller xfs_=
buf_iodone_work
   xfssyncd/sdc1-1409  [000]  2270.362854: xfs_log_reserve: dev 8:33 type D=
UMMY1 t_ocnt 1 t_cnt 1 t_curr_res 2740 t_unit_res 2740 t_flags XLOG_TIC_INI=
TED reserveq empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 4=
5624320 grant_write_cycle 1 grant_write_bytes 45624320 curr_cycle 1 curr_bl=
ock 89110 tail_cycle 1 tail_block 35956
   xfssyncd/sdc1-1409  [000]  2270.362858: xfs_log_grant_enter: dev 8:33 ty=
pe DUMMY1 t_ocnt 1 t_cnt 1 t_curr_res 2740 t_unit_res 2740 t_flags XLOG_TIC=
_INITED reserveq empty writeq empty grant_reserve_cycle 1 grant_reserve_byt=
es 45624320 grant_write_cycle 1 grant_write_bytes 45624320 curr_cycle 1 cur=
r_block 89110 tail_cycle 1 tail_block 35956
   xfssyncd/sdc1-1409  [000]  2270.362860: xfs_log_grant_exit: dev 8:33 typ=
e DUMMY1 t_ocnt 1 t_cnt 1 t_curr_res 2740 t_unit_res 2740 t_flags XLOG_TIC_=
INITED reserveq empty writeq empty grant_reserve_cycle 1 grant_reserve_byte=
s 45627060 grant_write_cycle 1 grant_write_bytes 45627060 curr_cycle 1 curr=
_block 89110 tail_cycle 1 tail_block 35956
   xfssyncd/sdc1-1409  [000]  2270.362862: xfs_buf_lock: dev 8:33 bno 0x0 l=
en 0x200 hold 1 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|PAGES caller xfs_=
getsb
   xfssyncd/sdc1-1409  [000]  2270.362863: xfs_buf_lock_done: dev 8:33 bno =
0x0 len 0x200 hold 1 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|PAGES caller=
 xfs_getsb
   xfssyncd/sdc1-1409  [000]  2270.362864: xfs_buf_hold: dev 8:33 bno 0x0 l=
en 0x200 hold 1 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|PAGES caller xfs_=
getsb
   xfssyncd/sdc1-1409  [000]  2270.362866: xfs_buf_hold: dev 8:33 bno 0x0 l=
en 0x200 hold 2 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|PAGES caller xfs_=
buf_item_init
   xfssyncd/sdc1-1409  [000]  2270.362868: xfs_trans_getsb: dev 8:33 bno 0x=
0 len 0x200 hold 3 pincount 0 lock 0 flags |MAPPED|ASYNC|DONE|PAGES recur 0=
 refcount 1 bliflags  lidesc 0xffff880106aa3350 liflags=20
   xfssyncd/sdc1-1409  [000]  2270.362870: xfs_trans_log_buf: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags |MAPPED|ASYNC|DONE|DELWRI|PAGE=
S recur 0 refcount 1 bliflags  lidesc 0xffff880106aa3350 liflags=20
   xfssyncd/sdc1-1409  [000]  2270.362873: xfs_buf_item_size: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags |MAPPED|ASYNC|DONE|DELWRI|PAGE=
S recur 0 refcount 1 bliflags |DIRTY|LOGGED lidesc 0xffff880106aa3350 lifla=
gs=20
   xfssyncd/sdc1-1409  [000]  2270.362875: xfs_buf_item_format: dev 8:33 bn=
o 0x0 len 0x200 hold 3 pincount 0 lock 0 flags |MAPPED|ASYNC|DONE|DELWRI|PA=
GES recur 0 refcount 1 bliflags |DIRTY|LOGGED lidesc 0xffff880106aa3350 lif=
lags=20
   xfssyncd/sdc1-1409  [000]  2270.362876: xfs_buf_item_pin: dev 8:33 bno 0=
x0 len 0x200 hold 3 pincount 0 lock 0 flags |MAPPED|ASYNC|DONE|DELWRI|PAGES=
 recur 0 refcount 1 bliflags |DIRTY|LOGGED lidesc 0xffff880106aa3350 liflag=
s=20
   xfssyncd/sdc1-1409  [000]  2270.362882: xfs_log_done_nonperm: dev 8:33 t=
ype DUMMY1 t_ocnt 1 t_cnt 1 t_curr_res 2000 t_unit_res 2740 t_flags  reserv=
eq empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 45627060 gr=
ant_write_cycle 1 grant_write_bytes 45627060 curr_cycle 1 curr_block 89110 =
tail_cycle 1 tail_block 35956
   xfssyncd/sdc1-1409  [000]  2270.362883: xfs_log_ungrant_enter: dev 8:33 =
type DUMMY1 t_ocnt 1 t_cnt 0 t_curr_res 2000 t_unit_res 2740 t_flags  reser=
veq empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 45627060 g=
rant_write_cycle 1 grant_write_bytes 45627060 curr_cycle 1 curr_block 89110=
 tail_cycle 1 tail_block 35956
   xfssyncd/sdc1-1409  [000]  2270.362883: xfs_log_ungrant_sub: dev 8:33 ty=
pe DUMMY1 t_ocnt 1 t_cnt 0 t_curr_res 2000 t_unit_res 2740 t_flags  reserve=
q empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 45627060 gra=
nt_write_cycle 1 grant_write_bytes 45627060 curr_cycle 1 curr_block 89110 t=
ail_cycle 1 tail_block 35956
   xfssyncd/sdc1-1409  [000]  2270.362884: xfs_log_ungrant_exit: dev 8:33 t=
ype DUMMY1 t_ocnt 1 t_cnt 0 t_curr_res 2000 t_unit_res 2740 t_flags  reserv=
eq empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 45625060 gr=
ant_write_cycle 1 grant_write_bytes 45625060 curr_cycle 1 curr_block 89110 =
tail_cycle 1 tail_block 35956
   xfssyncd/sdc1-1409  [000]  2270.362886: xfs_trans_commit_lsn: dev 8:33 t=
rans 0xffff880101c46a40 commit_lsn 0x100015c16
   xfssyncd/sdc1-1409  [000]  2270.362889: xfs_buf_item_unlock: dev 8:33 bn=
o 0x0 len 0x200 hold 3 pincount 1 lock 0 flags |MAPPED|ASYNC|DONE|DELWRI|PA=
GES recur 0 refcount 2 bliflags |DIRTY lidesc 0x          (null) liflags=20
   xfssyncd/sdc1-1409  [000]  2270.362890: xfs_buf_delwri_queue: dev 8:33 b=
no 0x0 len 0x200 hold 4 pincount 1 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PA=
GES caller xfs_buf_unlock
   xfssyncd/sdc1-1409  [000]  2270.362897: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 4 pincount 1 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_item_unlock
   xfssyncd/sdc1-1409  [000]  2270.362898: xfs_buf_rele: dev 8:33 bno 0x0 l=
en 0x200 hold 4 pincount 1 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DELW=
RI_Q caller xfs_buf_item_unlock
   xfssyncd/sdc1-1409  [000]  2270.362902: xfs_buf_iorequest: dev 8:33 bno =
0x3a398c36 len 0x8000 hold 1 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DON=
E|ORDERED|PAGES|RUN_QUEUES|0x2000 caller xlog_bdstrat
   xfssyncd/sdc1-1409  [000]  2270.362903: xfs_buf_hold: dev 8:33 bno 0x3a3=
98c36 len 0x8000 hold 1 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|ORD=
ERED|PAGES|RUN_QUEUES|0x2000 caller xfs_buf_iorequest
   xfssyncd/sdc1-1409  [000]  2270.362939: xfs_buf_rele: dev 8:33 bno 0x3a3=
98c36 len 0x8000 hold 2 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|ORD=
ERED|PAGES|RUN_QUEUES|0x2000 caller xfs_buf_iorequest
          <idle>-0     [001]  2270.382694: xfs_buf_ioerror: dev 8:33 bno 0x=
3a398c36 len 0x8000 hold 1 pincount 0 lock 0 error 0 flags WRITE|MAPPED|ASY=
NC|DONE|ORDERED|PAGES|RUN_QUEUES|0x2000 caller xfs_buf_bio_end_io
          <idle>-0     [001]  2270.382699: xfs_buf_iodone: dev 8:33 bno 0x3=
a398c36 len 0x8000 hold 1 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|O=
RDERED|PAGES|RUN_QUEUES|0x2000 caller _xfs_buf_ioend
     kworker/1:2-1448  [001]  2270.382741: xfs_buf_item_committed: dev 8:33=
 bno 0x0 len 0x200 hold 3 pincount 1 lock 1 flags |MAPPED|ASYNC|DONE|DELWRI=
|PAGES|DELWRI_Q recur 0 refcount 1 bliflags |DIRTY lidesc 0x          (null=
) liflags=20
     kworker/1:2-1448  [001]  2270.382745: xfs_buf_item_unpin: dev 8:33 bno=
 0x0 len 0x200 hold 3 pincount 1 lock 1 flags |MAPPED|ASYNC|DONE|DELWRI|PAG=
ES|DELWRI_Q recur 0 refcount 1 bliflags |DIRTY lidesc 0x          (null) li=
flags IN_AIL
    xfsbufd/sdc1-1407  [000]  2271.565309: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2271.565314: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2272.763759: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2272.763763: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2273.962216: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2273.962220: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2275.160678: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2275.160683: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2276.359131: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2276.359135: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2277.557589: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2277.557594: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2278.756046: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2278.756051: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2279.954503: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2279.954508: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2281.152961: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2281.152965: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2282.351419: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2282.351423: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2283.549876: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2283.549880: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2284.748334: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  2284.748338: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split

--ReaqsoxgOBHFXBhH--

--H+4ONPRPur6+Ovig
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk04JWQACgkQixMPpwVd7zErxwCg3XQgjlV4YZ6t9yyqX6Su8XD2
de0AmgP9lb//O56e1Zyf3ydlsadfu9FA
=BURc
-----END PGP SIGNATURE-----

--H+4ONPRPur6+Ovig--


--===============8607833217688722652==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8607833217688722652==--
