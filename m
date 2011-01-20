Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0KA1X0g064135 for <xfs@oss.sgi.com>; Thu, 20 Jan 2011 04:01:34 -0600
Received: from passage.avira.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D3089279C07
	for <xfs@oss.sgi.com>; Thu, 20 Jan 2011 02:03:50 -0800 (PST)
Received: from passage.avira.com (passage.avira.com [89.238.222.20]) by
	cuda.sgi.com with ESMTP id ornNNwNxjbzSOjDx for
	<xfs@oss.sgi.com>; Thu, 20 Jan 2011 02:03:50 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by passage.avira.com (Postfix/AVIRA) with ESMTP id B1835124939
	for <xfs@oss.sgi.com>; Thu, 20 Jan 2011 12:03:43 +0200 (EET)
Received: from naliboat.bu.avira.com (dasapass.avira.com [89.238.222.18])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "mail.bu.avira.com",
	Issuer "Avira Intermediate Certificate Authority 2010-2020" (not
	verified))
	by passage.avira.com (Postfix/AVIRA) with ESMTPS id 76BB2124939
	for <xfs@oss.sgi.com>; Thu, 20 Jan 2011 12:03:43 +0200 (EET)
Date: Thu, 20 Jan 2011 12:01:43 +0200
From: Petre Rodan <petre.rodan@simplex.ro>
Subject: Re: xfssyncd and disk spin down
Message-ID: <20110120100143.GA2007@peter.simplex.ro>
References: <20101223165532.GA23813@peter.simplex.ro>
	<20101227021904.GA24828@dastard>
	<20101227061629.GA2275@pandora.simplex.ro>
	<20101227140750.GB24828@dastard>
	<20101227171939.GA7759@pandora.simplex.ro>
	<20101231001323.GD15179@dastard>
MIME-Version: 1.0
In-Reply-To: <20101231001323.GD15179@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0210681820770678598=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


--===============0210681820770678598==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WhfpMioaduB5tiZL"
Content-Disposition: inline


--WhfpMioaduB5tiZL
Content-Type: multipart/mixed; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


hello Dave,

On Fri, Dec 31, 2010 at 11:13:23AM +1100, Dave Chinner wrote:
> On Mon, Dec 27, 2010 at 07:19:39PM +0200, Petre Rodan wrote:
> >=20
> > Hello Dave,
> >=20
> > On Tue, Dec 28, 2010 at 01:07:50AM +1100, Dave Chinner wrote:
> > > Turn on the XFS tracing so we can see what is being written every
> > > 36s.  When the problem shows up:
> > >=20
> > > # echo 1 > /sys/kernel/debug/tracing/events/xfs/enable
> > > # sleep 100
> > > # cat /sys/kernel/debug/tracing/trace > trace.out
> > > # echo 0 > /sys/kernel/debug/tracing/events/xfs/enable
> > >=20
> > > And post the trace.out file for us to look at.
> >=20
> > attached.
> >=20
> > you can disregard all the lvm partitions ('dev 254:.*') since they are =
on a different drive, probably only 8:17 is of interest.
>=20
> Ok, I can see the problem. The original patch I tested:
>=20
> http://oss.sgi.com/archives/xfs/2010-08/msg00026.html
>=20
> Made the log covering dummy transaction a synchronous transaction so
> that the log was written and the superblock unpinned immediately to
> allow the xfsbufd to write back the superblock and empty the AIL
> before the next log covering check.
>=20
> On review, the log covering dummy transaction got changed to an
> async transaction, so the superblock buffer is not unpinned
> immediately. This was the patch committed:
>=20
> http://oss.sgi.com/archives/xfs/2010-08/msg00197.html
>=20
> As a result, the success of log covering and idling is then
> dependent on whether the log gets written to disk to unpin the
> superblock buffer before the next xfssyncd run. It seems that there
> is a large chance that this log write does not happen, so the
> filesystem never idles correctly. I've reproduced it here, and only
> in one test out of ten did the filesystem enter an idle state
> correctly. I guess I was unlucky enough to hit that 1-in-10 case
> when I tested the modified patch.
>=20
> I'll cook up a patch to make the log covering behave like the
> original patch I sent...

I presume that the new fix should be provided by "xfs: ensure log covering =
transactions are synchronous", so I tested 2.6.37 patched with it and then =
2.6.38_rc1 that has it included.

instead of having xfssyncd write to the drive every 36s, we now have this:

  8,32   0      162   828.393976164  1413  A  WS 977599761 + 2 <- (8,33) 97=
7597713
  8,32   0      163   828.393977820  1413  Q  WS 977599761 + 2 [xfssyncd/sd=
c1]
  8,32   0      167   846.401286530  1407  A   W 2048 + 1 <- (8,33) 0
  8,32   0      168   846.401288007  1407  Q   W 2048 + 1 [xfsbufd/sdc1]
  8,32   0      174   864.412155132  1413  A  WS 977599763 + 2 <- (8,33) 97=
7597715
  8,32   0      175   864.412156637  1413  Q  WS 977599763 + 2 [xfssyncd/sd=
c1]
  8,32   1      240   882.467053566  1407  A   W 2048 + 1 <- (8,33) 0
  8,32   1      241   882.467055152  1407  Q   W 2048 + 1 [xfsbufd/sdc1]
  8,32   0      179   900.426084634  1413  A  WS 977599765 + 2 <- (8,33) 97=
7597717
  8,32   0      180   900.426086076  1413  Q  WS 977599765 + 2 [xfssyncd/sd=
c1]
  8,32   0      185   918.457066312  1407  A   W 2048 + 1 <- (8,33) 0
  8,32   0      186   918.457068003  1407  Q   W 2048 + 1 [xfsbufd/sdc1]
  8,32   1      252   936.448120095  1413  A  WS 977599767 + 2 <- (8,33) 97=
7597719
  8,32   1      253   936.448121740  1413  Q  WS 977599767 + 2 [xfssyncd/sd=
c1]
  8,32   0      192   954.447207652  1407  A   W 2048 + 1 <- (8,33) 0
  8,32   0      193   954.447209114  1407  Q   W 2048 + 1 [xfsbufd/sdc1]
  8,32   0      199   972.458423873  1413  A  WS 977599769 + 2 <- (8,33) 97=
7597721
  8,32   0      200   972.458425189  1413  Q  WS 977599769 + 2 [xfssyncd/sd=
c1]
  8,32   1      266   990.457562449  1407  A   W 2048 + 1 <- (8,33) 0
  8,32   1      267   990.457563909  1407  Q   W 2048 + 1 [xfsbufd/sdc1]
  8,32   0      204  1008.476781955  1413  A  WS 977599771 + 2 <- (8,33) 97=
7597723
  8,32   0      205  1008.476783410  1413  Q  WS 977599771 + 2 [xfssyncd/sd=
c1]
  8,32   1      278  1026.531988963  1407  A   W 2048 + 1 <- (8,33) 0
  8,32   1      279  1026.531990718  1407  Q   W 2048 + 1 [xfsbufd/sdc1]
  8,32   0      209  1044.491342417  1413  A  WS 977599773 + 2 <- (8,33) 97=
7597725
  8,32   0      210  1044.491344042  1413  Q  WS 977599773 + 2 [xfssyncd/sd=
c1]
  8,32   0      214  1062.502603664  1407  A   W 2048 + 1 <- (8,33) 0
  8,32   0      215  1062.502605117  1407  Q   W 2048 + 1 [xfsbufd/sdc1]
  8,32   0      216  1062.502611005  1407  G   W 2048 + 1 [xfsbufd/sdc1]

in other words xfsyncd and xfsbufd now alternate at 18s intervals keeping t=
he drive busy with nothing constructive hours after the last write to the d=
rive.

to add to the misfortune, 'mount -o remount ' is no longer able to bring th=
e drive to a quiet state since 2.6.37, so now the only way to achieve an id=
le drive is to fully umount and then remount the partition.

just for the record, this is a different drive then at the beginning of the=
 thread, and it has these parameters:

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
t=3D0
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0

attached you'll find the trace (with accesses to other drives filtered out).

cheers,
peter

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

--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=trace
Content-Transfer-Encoding: quoted-printable

# tracer: nop
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
    xfsbufd/sdc1-1407  [000]  3328.516937: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3328.516942: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3329.715360: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3329.715364: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3330.913851: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3330.913856: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3332.112309: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3332.112314: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3333.310767: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3333.310771: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3334.509225: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3334.509229: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3335.707682: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3335.707686: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3336.906140: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3336.906145: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3338.104598: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3338.104602: xfs_buf_delwri_split: dev 8:33 b=
no 0x0 len 0x200 hold 3 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|PAG=
ES caller xfsbufd
    xfsbufd/sdc1-1407  [000]  3338.104605: xfs_buf_iorequest: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|PAGES =
caller xfs_bdstrat_cb
    xfsbufd/sdc1-1407  [000]  3338.104606: xfs_buf_hold: dev 8:33 bno 0x0 l=
en 0x200 hold 3 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|PAGES calle=
r xfs_buf_iorequest
    xfsbufd/sdc1-1407  [000]  3338.104628: xfs_buf_rele: dev 8:33 bno 0x0 l=
en 0x200 hold 4 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|PAGES calle=
r xfs_buf_iorequest
          <idle>-0     [001]  3338.105096: xfs_buf_ioerror: dev 8:33 bno 0x=
0 len 0x200 hold 3 pincount 0 lock 0 error 0 flags WRITE|MAPPED|ASYNC|DONE|=
PAGES caller xfs_buf_bio_end_io
          <idle>-0     [001]  3338.105100: xfs_buf_iodone: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|PAGES cal=
ler _xfs_buf_ioend
     kworker/1:0-2942  [001]  3338.105137: xfs_buf_rele: dev 8:33 bno 0x0 l=
en 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|PAGES caller xfs_=
buf_iodone
     kworker/1:0-2942  [001]  3338.105139: xfs_buf_iodone: dev 8:33 bno 0x0=
 len 0x200 hold 2 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|PAGES caller xf=
s_buf_iodone_callbacks
     kworker/1:0-2942  [001]  3338.105141: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 2 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|PAGES caller xf=
s_buf_iodone_work
     kworker/1:0-2942  [001]  3338.105141: xfs_buf_rele: dev 8:33 bno 0x0 l=
en 0x200 hold 2 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|PAGES caller xfs_=
buf_iodone_work
   xfssyncd/sdc1-1413  [000]  3356.093456: xfs_log_reserve: dev 8:33 type D=
UMMY1 t_ocnt 1 t_cnt 1 t_curr_res 2740 t_unit_res 2740 t_flags XLOG_TIC_INI=
TED reserveq empty writeq empty grant_reserve_cycle 2 grant_reserve_bytes 4=
28523008 grant_write_cycle 2 grant_write_bytes 428523008 curr_cycle 2 curr_=
block 836959 tail_cycle 2 tail_block 810683
   xfssyncd/sdc1-1413  [000]  3356.093462: xfs_log_grant_enter: dev 8:33 ty=
pe DUMMY1 t_ocnt 1 t_cnt 1 t_curr_res 2740 t_unit_res 2740 t_flags XLOG_TIC=
_INITED reserveq empty writeq empty grant_reserve_cycle 2 grant_reserve_byt=
es 428523008 grant_write_cycle 2 grant_write_bytes 428523008 curr_cycle 2 c=
urr_block 836959 tail_cycle 2 tail_block 810683
   xfssyncd/sdc1-1413  [000]  3356.093463: xfs_log_grant_exit: dev 8:33 typ=
e DUMMY1 t_ocnt 1 t_cnt 1 t_curr_res 2740 t_unit_res 2740 t_flags XLOG_TIC_=
INITED reserveq empty writeq empty grant_reserve_cycle 2 grant_reserve_byte=
s 428525748 grant_write_cycle 2 grant_write_bytes 428525748 curr_cycle 2 cu=
rr_block 836959 tail_cycle 2 tail_block 810683
   xfssyncd/sdc1-1413  [000]  3356.093465: xfs_buf_lock: dev 8:33 bno 0x0 l=
en 0x200 hold 1 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|PAGES caller xfs_=
getsb
   xfssyncd/sdc1-1413  [000]  3356.093467: xfs_buf_lock_done: dev 8:33 bno =
0x0 len 0x200 hold 1 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|PAGES caller=
 xfs_getsb
   xfssyncd/sdc1-1413  [000]  3356.093468: xfs_buf_hold: dev 8:33 bno 0x0 l=
en 0x200 hold 1 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|PAGES caller xfs_=
getsb
   xfssyncd/sdc1-1413  [000]  3356.093470: xfs_buf_hold: dev 8:33 bno 0x0 l=
en 0x200 hold 2 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|PAGES caller xfs_=
buf_item_init
   xfssyncd/sdc1-1413  [000]  3356.093472: xfs_trans_getsb: dev 8:33 bno 0x=
0 len 0x200 hold 3 pincount 0 lock 0 flags |MAPPED|ASYNC|DONE|PAGES recur 0=
 refcount 1 bliflags  lidesc 0xffff8800dd23f8f0 liflags=20
   xfssyncd/sdc1-1413  [000]  3356.093474: xfs_trans_log_buf: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags |MAPPED|ASYNC|DONE|DELWRI|PAGE=
S recur 0 refcount 1 bliflags  lidesc 0xffff8800dd23f8f0 liflags=20
   xfssyncd/sdc1-1413  [000]  3356.093477: xfs_buf_item_size: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags |MAPPED|ASYNC|DONE|DELWRI|PAGE=
S recur 0 refcount 1 bliflags |DIRTY|LOGGED lidesc 0xffff8800dd23f8f0 lifla=
gs=20
   xfssyncd/sdc1-1413  [000]  3356.093479: xfs_buf_item_format: dev 8:33 bn=
o 0x0 len 0x200 hold 3 pincount 0 lock 0 flags |MAPPED|ASYNC|DONE|DELWRI|PA=
GES recur 0 refcount 1 bliflags |DIRTY|LOGGED lidesc 0xffff8800dd23f8f0 lif=
lags=20
   xfssyncd/sdc1-1413  [000]  3356.093480: xfs_buf_item_pin: dev 8:33 bno 0=
x0 len 0x200 hold 3 pincount 0 lock 0 flags |MAPPED|ASYNC|DONE|DELWRI|PAGES=
 recur 0 refcount 1 bliflags |DIRTY|LOGGED lidesc 0xffff8800dd23f8f0 liflag=
s=20
   xfssyncd/sdc1-1413  [000]  3356.093487: xfs_log_done_nonperm: dev 8:33 t=
ype DUMMY1 t_ocnt 1 t_cnt 1 t_curr_res 2000 t_unit_res 2740 t_flags  reserv=
eq empty writeq empty grant_reserve_cycle 2 grant_reserve_bytes 428525748 g=
rant_write_cycle 2 grant_write_bytes 428525748 curr_cycle 2 curr_block 8369=
59 tail_cycle 2 tail_block 810683
   xfssyncd/sdc1-1413  [000]  3356.093488: xfs_log_ungrant_enter: dev 8:33 =
type DUMMY1 t_ocnt 1 t_cnt 0 t_curr_res 2000 t_unit_res 2740 t_flags  reser=
veq empty writeq empty grant_reserve_cycle 2 grant_reserve_bytes 428525748 =
grant_write_cycle 2 grant_write_bytes 428525748 curr_cycle 2 curr_block 836=
959 tail_cycle 2 tail_block 810683
   xfssyncd/sdc1-1413  [000]  3356.093489: xfs_log_ungrant_sub: dev 8:33 ty=
pe DUMMY1 t_ocnt 1 t_cnt 0 t_curr_res 2000 t_unit_res 2740 t_flags  reserve=
q empty writeq empty grant_reserve_cycle 2 grant_reserve_bytes 428525748 gr=
ant_write_cycle 2 grant_write_bytes 428525748 curr_cycle 2 curr_block 83695=
9 tail_cycle 2 tail_block 810683
   xfssyncd/sdc1-1413  [000]  3356.093489: xfs_log_ungrant_exit: dev 8:33 t=
ype DUMMY1 t_ocnt 1 t_cnt 0 t_curr_res 2000 t_unit_res 2740 t_flags  reserv=
eq empty writeq empty grant_reserve_cycle 2 grant_reserve_bytes 428523748 g=
rant_write_cycle 2 grant_write_bytes 428523748 curr_cycle 2 curr_block 8369=
59 tail_cycle 2 tail_block 810683
   xfssyncd/sdc1-1413  [000]  3356.093492: xfs_trans_commit_lsn: dev 8:33 t=
rans 0xffff8800dd2b7ea0 commit_lsn 0x2000cc55f
   xfssyncd/sdc1-1413  [000]  3356.093495: xfs_buf_item_unlock: dev 8:33 bn=
o 0x0 len 0x200 hold 3 pincount 1 lock 0 flags |MAPPED|ASYNC|DONE|DELWRI|PA=
GES recur 0 refcount 2 bliflags |DIRTY lidesc 0x          (null) liflags=20
   xfssyncd/sdc1-1413  [000]  3356.093496: xfs_buf_delwri_queue: dev 8:33 b=
no 0x0 len 0x200 hold 4 pincount 1 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PA=
GES caller xfs_buf_unlock
   xfssyncd/sdc1-1413  [000]  3356.093501: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 4 pincount 1 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_item_unlock
   xfssyncd/sdc1-1413  [000]  3356.093502: xfs_buf_rele: dev 8:33 bno 0x0 l=
en 0x200 hold 4 pincount 1 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DELW=
RI_Q caller xfs_buf_item_unlock
   xfssyncd/sdc1-1413  [000]  3356.093506: xfs_buf_iorequest: dev 8:33 bno =
0x3a44f57f len 0x8000 hold 1 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DON=
E|ORDERED|PAGES|RUN_QUEUES|0x2000 caller xlog_bdstrat
   xfssyncd/sdc1-1413  [000]  3356.093507: xfs_buf_hold: dev 8:33 bno 0x3a4=
4f57f len 0x8000 hold 1 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|ORD=
ERED|PAGES|RUN_QUEUES|0x2000 caller xfs_buf_iorequest
   xfssyncd/sdc1-1413  [000]  3356.093541: xfs_buf_rele: dev 8:33 bno 0x3a4=
4f57f len 0x8000 hold 2 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|ORD=
ERED|PAGES|RUN_QUEUES|0x2000 caller xfs_buf_iorequest
          <idle>-0     [001]  3356.113311: xfs_buf_ioerror: dev 8:33 bno 0x=
3a44f57f len 0x8000 hold 1 pincount 0 lock 0 error 0 flags WRITE|MAPPED|ASY=
NC|DONE|ORDERED|PAGES|RUN_QUEUES|0x2000 caller xfs_buf_bio_end_io
          <idle>-0     [001]  3356.113316: xfs_buf_iodone: dev 8:33 bno 0x3=
a44f57f len 0x8000 hold 1 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|O=
RDERED|PAGES|RUN_QUEUES|0x2000 caller _xfs_buf_ioend
     kworker/1:0-2942  [001]  3356.113359: xfs_buf_item_committed: dev 8:33=
 bno 0x0 len 0x200 hold 3 pincount 1 lock 1 flags |MAPPED|ASYNC|DONE|DELWRI=
|PAGES|DELWRI_Q recur 0 refcount 1 bliflags |DIRTY lidesc 0x          (null=
) liflags=20
     kworker/1:0-2942  [001]  3356.113362: xfs_buf_item_unpin: dev 8:33 bno=
 0x0 len 0x200 hold 3 pincount 1 lock 1 flags |MAPPED|ASYNC|DONE|DELWRI|PAG=
ES|DELWRI_Q recur 0 refcount 1 bliflags |DIRTY lidesc 0x          (null) li=
flags IN_AIL
    xfsbufd/sdc1-1407  [001]  3357.291895: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  3357.291899: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  3358.490410: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  3358.490415: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  3359.688802: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  3359.688806: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  3360.887269: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  3360.887273: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  3362.085688: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  3362.085692: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  3363.284175: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  3363.284180: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  3364.482639: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  3364.482644: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  3365.681096: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  3365.681100: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3366.879566: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3366.879571: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3368.078025: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3368.078030: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3369.276482: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3369.276486: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3370.474939: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3370.474944: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3371.673391: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3371.673395: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3372.871848: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3372.871853: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3374.070306: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3374.070310: xfs_buf_delwri_split: dev 8:33 b=
no 0x0 len 0x200 hold 3 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|PAG=
ES caller xfsbufd
    xfsbufd/sdc1-1407  [000]  3374.070312: xfs_buf_iorequest: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|PAGES =
caller xfs_bdstrat_cb
    xfsbufd/sdc1-1407  [000]  3374.070314: xfs_buf_hold: dev 8:33 bno 0x0 l=
en 0x200 hold 3 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|PAGES calle=
r xfs_buf_iorequest
    xfsbufd/sdc1-1407  [000]  3374.070331: xfs_buf_rele: dev 8:33 bno 0x0 l=
en 0x200 hold 4 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|PAGES calle=
r xfs_buf_iorequest
          <idle>-0     [001]  3374.070797: xfs_buf_ioerror: dev 8:33 bno 0x=
0 len 0x200 hold 3 pincount 0 lock 0 error 0 flags WRITE|MAPPED|ASYNC|DONE|=
PAGES caller xfs_buf_bio_end_io
          <idle>-0     [001]  3374.070801: xfs_buf_iodone: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|PAGES cal=
ler _xfs_buf_ioend
     kworker/1:0-2942  [001]  3374.070839: xfs_buf_rele: dev 8:33 bno 0x0 l=
en 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|PAGES caller xfs_=
buf_iodone
     kworker/1:0-2942  [001]  3374.070841: xfs_buf_iodone: dev 8:33 bno 0x0=
 len 0x200 hold 2 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|PAGES caller xf=
s_buf_iodone_callbacks
     kworker/1:0-2942  [001]  3374.070843: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 2 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|PAGES caller xf=
s_buf_iodone_work
     kworker/1:0-2942  [001]  3374.070843: xfs_buf_rele: dev 8:33 bno 0x0 l=
en 0x200 hold 2 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|PAGES caller xfs_=
buf_iodone_work
   xfssyncd/sdc1-1413  [000]  3392.067122: xfs_log_reserve: dev 8:33 type D=
UMMY1 t_ocnt 1 t_cnt 1 t_curr_res 2740 t_unit_res 2740 t_flags XLOG_TIC_INI=
TED reserveq empty writeq empty grant_reserve_cycle 2 grant_reserve_bytes 4=
28524032 grant_write_cycle 2 grant_write_bytes 428524032 curr_cycle 2 curr_=
block 836961 tail_cycle 2 tail_block 810683
   xfssyncd/sdc1-1413  [000]  3392.067127: xfs_log_grant_enter: dev 8:33 ty=
pe DUMMY1 t_ocnt 1 t_cnt 1 t_curr_res 2740 t_unit_res 2740 t_flags XLOG_TIC=
_INITED reserveq empty writeq empty grant_reserve_cycle 2 grant_reserve_byt=
es 428524032 grant_write_cycle 2 grant_write_bytes 428524032 curr_cycle 2 c=
urr_block 836961 tail_cycle 2 tail_block 810683
   xfssyncd/sdc1-1413  [000]  3392.067129: xfs_log_grant_exit: dev 8:33 typ=
e DUMMY1 t_ocnt 1 t_cnt 1 t_curr_res 2740 t_unit_res 2740 t_flags XLOG_TIC_=
INITED reserveq empty writeq empty grant_reserve_cycle 2 grant_reserve_byte=
s 428526772 grant_write_cycle 2 grant_write_bytes 428526772 curr_cycle 2 cu=
rr_block 836961 tail_cycle 2 tail_block 810683
   xfssyncd/sdc1-1413  [000]  3392.067131: xfs_buf_lock: dev 8:33 bno 0x0 l=
en 0x200 hold 1 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|PAGES caller xfs_=
getsb
   xfssyncd/sdc1-1413  [000]  3392.067133: xfs_buf_lock_done: dev 8:33 bno =
0x0 len 0x200 hold 1 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|PAGES caller=
 xfs_getsb
   xfssyncd/sdc1-1413  [000]  3392.067134: xfs_buf_hold: dev 8:33 bno 0x0 l=
en 0x200 hold 1 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|PAGES caller xfs_=
getsb
   xfssyncd/sdc1-1413  [000]  3392.067138: xfs_buf_hold: dev 8:33 bno 0x0 l=
en 0x200 hold 2 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|PAGES caller xfs_=
buf_item_init
   xfssyncd/sdc1-1413  [000]  3392.067140: xfs_trans_getsb: dev 8:33 bno 0x=
0 len 0x200 hold 3 pincount 0 lock 0 flags |MAPPED|ASYNC|DONE|PAGES recur 0=
 refcount 1 bliflags  lidesc 0xffff8800dca401f0 liflags=20
   xfssyncd/sdc1-1413  [000]  3392.067142: xfs_trans_log_buf: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags |MAPPED|ASYNC|DONE|DELWRI|PAGE=
S recur 0 refcount 1 bliflags  lidesc 0xffff8800dca401f0 liflags=20
   xfssyncd/sdc1-1413  [000]  3392.067145: xfs_buf_item_size: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags |MAPPED|ASYNC|DONE|DELWRI|PAGE=
S recur 0 refcount 1 bliflags |DIRTY|LOGGED lidesc 0xffff8800dca401f0 lifla=
gs=20
   xfssyncd/sdc1-1413  [000]  3392.067147: xfs_buf_item_format: dev 8:33 bn=
o 0x0 len 0x200 hold 3 pincount 0 lock 0 flags |MAPPED|ASYNC|DONE|DELWRI|PA=
GES recur 0 refcount 1 bliflags |DIRTY|LOGGED lidesc 0xffff8800dca401f0 lif=
lags=20
   xfssyncd/sdc1-1413  [000]  3392.067148: xfs_buf_item_pin: dev 8:33 bno 0=
x0 len 0x200 hold 3 pincount 0 lock 0 flags |MAPPED|ASYNC|DONE|DELWRI|PAGES=
 recur 0 refcount 1 bliflags |DIRTY|LOGGED lidesc 0xffff8800dca401f0 liflag=
s=20
   xfssyncd/sdc1-1413  [000]  3392.067154: xfs_log_done_nonperm: dev 8:33 t=
ype DUMMY1 t_ocnt 1 t_cnt 1 t_curr_res 2000 t_unit_res 2740 t_flags  reserv=
eq empty writeq empty grant_reserve_cycle 2 grant_reserve_bytes 428526772 g=
rant_write_cycle 2 grant_write_bytes 428526772 curr_cycle 2 curr_block 8369=
61 tail_cycle 2 tail_block 810683
   xfssyncd/sdc1-1413  [000]  3392.067155: xfs_log_ungrant_enter: dev 8:33 =
type DUMMY1 t_ocnt 1 t_cnt 0 t_curr_res 2000 t_unit_res 2740 t_flags  reser=
veq empty writeq empty grant_reserve_cycle 2 grant_reserve_bytes 428526772 =
grant_write_cycle 2 grant_write_bytes 428526772 curr_cycle 2 curr_block 836=
961 tail_cycle 2 tail_block 810683
   xfssyncd/sdc1-1413  [000]  3392.067156: xfs_log_ungrant_sub: dev 8:33 ty=
pe DUMMY1 t_ocnt 1 t_cnt 0 t_curr_res 2000 t_unit_res 2740 t_flags  reserve=
q empty writeq empty grant_reserve_cycle 2 grant_reserve_bytes 428526772 gr=
ant_write_cycle 2 grant_write_bytes 428526772 curr_cycle 2 curr_block 83696=
1 tail_cycle 2 tail_block 810683
   xfssyncd/sdc1-1413  [000]  3392.067156: xfs_log_ungrant_exit: dev 8:33 t=
ype DUMMY1 t_ocnt 1 t_cnt 0 t_curr_res 2000 t_unit_res 2740 t_flags  reserv=
eq empty writeq empty grant_reserve_cycle 2 grant_reserve_bytes 428524772 g=
rant_write_cycle 2 grant_write_bytes 428524772 curr_cycle 2 curr_block 8369=
61 tail_cycle 2 tail_block 810683
   xfssyncd/sdc1-1413  [000]  3392.067159: xfs_trans_commit_lsn: dev 8:33 t=
rans 0xffff8800dca3a4c8 commit_lsn 0x2000cc561
   xfssyncd/sdc1-1413  [000]  3392.067161: xfs_buf_item_unlock: dev 8:33 bn=
o 0x0 len 0x200 hold 3 pincount 1 lock 0 flags |MAPPED|ASYNC|DONE|DELWRI|PA=
GES recur 0 refcount 2 bliflags |DIRTY lidesc 0x          (null) liflags=20
   xfssyncd/sdc1-1413  [000]  3392.067163: xfs_buf_delwri_queue: dev 8:33 b=
no 0x0 len 0x200 hold 4 pincount 1 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PA=
GES caller xfs_buf_unlock
   xfssyncd/sdc1-1413  [000]  3392.067168: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 4 pincount 1 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_item_unlock
   xfssyncd/sdc1-1413  [000]  3392.067169: xfs_buf_rele: dev 8:33 bno 0x0 l=
en 0x200 hold 4 pincount 1 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DELW=
RI_Q caller xfs_buf_item_unlock
   xfssyncd/sdc1-1413  [000]  3392.067173: xfs_buf_iorequest: dev 8:33 bno =
0x3a44f581 len 0x8000 hold 1 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DON=
E|ORDERED|PAGES|RUN_QUEUES|0x2000 caller xlog_bdstrat
   xfssyncd/sdc1-1413  [000]  3392.067174: xfs_buf_hold: dev 8:33 bno 0x3a4=
4f581 len 0x8000 hold 1 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|ORD=
ERED|PAGES|RUN_QUEUES|0x2000 caller xfs_buf_iorequest
   xfssyncd/sdc1-1413  [000]  3392.067211: xfs_buf_rele: dev 8:33 bno 0x3a4=
4f581 len 0x8000 hold 2 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|ORD=
ERED|PAGES|RUN_QUEUES|0x2000 caller xfs_buf_iorequest
          <idle>-0     [001]  3392.084946: xfs_buf_ioerror: dev 8:33 bno 0x=
3a44f581 len 0x8000 hold 1 pincount 0 lock 0 error 0 flags WRITE|MAPPED|ASY=
NC|DONE|ORDERED|PAGES|RUN_QUEUES|0x2000 caller xfs_buf_bio_end_io
          <idle>-0     [001]  3392.084951: xfs_buf_iodone: dev 8:33 bno 0x3=
a44f581 len 0x8000 hold 1 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|O=
RDERED|PAGES|RUN_QUEUES|0x2000 caller _xfs_buf_ioend
     kworker/1:0-2942  [001]  3392.084986: xfs_buf_item_committed: dev 8:33=
 bno 0x0 len 0x200 hold 3 pincount 1 lock 1 flags |MAPPED|ASYNC|DONE|DELWRI=
|PAGES|DELWRI_Q recur 0 refcount 1 bliflags |DIRTY lidesc 0x          (null=
) liflags=20
     kworker/1:0-2942  [001]  3392.084989: xfs_buf_item_unpin: dev 8:33 bno=
 0x0 len 0x200 hold 3 pincount 1 lock 1 flags |MAPPED|ASYNC|DONE|DELWRI|PAG=
ES|DELWRI_Q recur 0 refcount 1 bliflags |DIRTY lidesc 0x          (null) li=
flags IN_AIL
    xfsbufd/sdc1-1407  [001]  3393.269554: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  3393.269558: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  3394.472001: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  3394.472006: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  3395.674456: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  3395.674460: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  3396.872917: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [001]  3396.872921: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3398.071397: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3398.071401: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3399.269841: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3399.269845: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3400.468299: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3400.468304: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3401.666718: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3401.666722: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3402.865235: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3402.865239: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3404.063706: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3404.063710: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3405.262163: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3405.262167: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3406.460622: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3406.460626: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3407.659078: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3407.659083: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3408.857536: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3408.857540: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|DELWRI|PAGES|DE=
LWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3410.055988: xfs_buf_cond_lock: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|DELWRI|PAGES=
|DELWRI_Q caller xfs_buf_delwri_split
    xfsbufd/sdc1-1407  [000]  3410.055992: xfs_buf_delwri_split: dev 8:33 b=
no 0x0 len 0x200 hold 3 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|PAG=
ES caller xfsbufd
    xfsbufd/sdc1-1407  [000]  3410.055995: xfs_buf_iorequest: dev 8:33 bno =
0x0 len 0x200 hold 3 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|PAGES =
caller xfs_bdstrat_cb
    xfsbufd/sdc1-1407  [000]  3410.055996: xfs_buf_hold: dev 8:33 bno 0x0 l=
en 0x200 hold 3 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|PAGES calle=
r xfs_buf_iorequest
    xfsbufd/sdc1-1407  [000]  3410.056014: xfs_buf_rele: dev 8:33 bno 0x0 l=
en 0x200 hold 4 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|PAGES calle=
r xfs_buf_iorequest
          <idle>-0     [001]  3410.056482: xfs_buf_ioerror: dev 8:33 bno 0x=
0 len 0x200 hold 3 pincount 0 lock 0 error 0 flags WRITE|MAPPED|ASYNC|DONE|=
PAGES caller xfs_buf_bio_end_io
          <idle>-0     [001]  3410.056486: xfs_buf_iodone: dev 8:33 bno 0x0=
 len 0x200 hold 3 pincount 0 lock 0 flags WRITE|MAPPED|ASYNC|DONE|PAGES cal=
ler _xfs_buf_ioend
     kworker/1:0-2942  [001]  3410.056524: xfs_buf_rele: dev 8:33 bno 0x0 l=
en 0x200 hold 3 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|PAGES caller xfs_=
buf_iodone
     kworker/1:0-2942  [001]  3410.056526: xfs_buf_iodone: dev 8:33 bno 0x0=
 len 0x200 hold 2 pincount 0 lock 0 flags MAPPED|ASYNC|DONE|PAGES caller xf=
s_buf_iodone_callbacks
     kworker/1:0-2942  [001]  3410.056527: xfs_buf_unlock: dev 8:33 bno 0x0=
 len 0x200 hold 2 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|PAGES caller xf=
s_buf_iodone_work
     kworker/1:0-2942  [001]  3410.056528: xfs_buf_rele: dev 8:33 bno 0x0 l=
en 0x200 hold 2 pincount 0 lock 1 flags MAPPED|ASYNC|DONE|PAGES caller xfs_=
buf_iodone_work

--gBBFr7Ir9EOA20Yy--

--WhfpMioaduB5tiZL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk04CAYACgkQixMPpwVd7zFwSQCcDRp4TfrpMFdolXRT5luOc28J
kZEAnjagr8yaRMG1cH7qEPQWrdf+6Qpq
=7DpV
-----END PGP SIGNATURE-----

--WhfpMioaduB5tiZL--


--===============0210681820770678598==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0210681820770678598==--
