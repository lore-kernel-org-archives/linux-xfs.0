Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q830iXoh102737 for <xfs@oss.sgi.com>; Sun, 2 Sep 2012 19:44:33 -0500
Received: from mail-pz0-f53.google.com (mail-pz0-f53.google.com
	[209.85.210.53]) by cuda.sgi.com with ESMTP id DjKdUbXdbaEJ9jFL
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 02 Sep 2012 17:45:27 -0700 (PDT)
Received: by dadg9 with SMTP id g9so4329446dad.26
	for <xfs@oss.sgi.com>; Sun, 02 Sep 2012 17:45:27 -0700 (PDT)
Date: Mon, 3 Sep 2012 06:15:21 +0530
From: Raghavendra D Prabhu <raghu.prabhu13@gmail.com>
Subject: Re: XFS regression: Oops in xfs_buf_do_callbacks on xfstest 137
Message-ID: <20120903004521.GA61118@Archie>
References: <501ABC84.6030708@sandeen.net>
	<20120817180254.GA15382@infradead.org>
	<502E8A4F.9050105@sandeen.net>
MIME-Version: 1.0
In-Reply-To: <502E8A4F.9050105@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3508588599207055699=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com


--===============3508588599207055699==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3uo+9/B/ebqu+fSQ"
Content-Disposition: inline


--3uo+9/B/ebqu+fSQ
Content-Type: multipart/mixed; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,


* On Fri, Aug 17, 2012 at 01:15:43PM -0500, Eric Sandeen <sandeen@sandeen.n=
et> wrote:
>On 8/17/12 1:02 PM, Christoph Hellwig wrote:
>>I'd be this is my new code added to xfs_buf_item_unpin, but I don't
>>quite understand why.  It's been a long time since I wrote that code,
>>but I had to add that code to make sure we clear all buffers during
>>a forced shutdown.  Can you test if things go away if you just remove it
>>(even if causes other hangs?)
>
>It does go away AFAIK, since the bisect found it.
>
>Sadly it's been on the back burner for me, under other deadline pressure.
>
>-Eric
>
>_______________________________________________
>xfs mailing list
>xfs@oss.sgi.com
>http://oss.sgi.com/mailman/listinfo/xfs

I hit the same bug on xfstest 137 while testing and it is indeed=20
POISON_FREE.

Here are the intermediate backtraces:  http://sprunge.us/HZeD=20

I am also attaching the full backtrace.


git head:

commit b686d1f79acb65c6a34473c15fcfa2ee54aed8e2
  Author: Jeff Liu <jeff.liu@oracle.com>
  Date:   Tue Aug 21 17:12:18 2012 +0800


Regards,
--=20
Raghavendra Prabhu
GPG Id : 0xD72BE977
Fingerprint: B93F EBCB 8E05 7039 CD3C A4B8 A616 DCA1 D72B E977
www: wnohang.net

--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="full.backtrace"
Content-Transfer-Encoding: quoted-printable

#0  xfs_buf_iodone_callbacks (bp=3D0xffff88007a9d2d00) at fs/xfs/xfs_buf_it=
em.c:1057
        lip =3D <optimized out>
        mp =3D <optimized out>
        lasttime =3D 0
        lasttarg =3D 0x0 <irq_stack_union>
        __func__ =3D "xfs_buf_iodone_callbacks"
#1  0xffffffff815824ee in xfs_buf_iodone_work (work=3Dwork@entry=3D0xffff88=
007a9d2e28) at fs/xfs/xfs_buf.c:1006
        bp =3D 0xffff88007a9d2d00
        __func__ =3D "xfs_buf_iodone_work"
#2  0xffffffff81582dec in xfs_buf_ioend (bp=3Dbp@entry=3D0xffff88007a9d2d00=
, schedule=3Dschedule@entry=3D0) at fs/xfs/xfs_buf.c:1027
        __func__ =3D "xfs_buf_ioend"
#3  0xffffffff8166e161 in xfs_buf_item_unpin (lip=3D0xffff88007a9c0d20, rem=
ove=3D1) at fs/xfs/xfs_buf_item.c:533
        bp =3D 0xffff88007a9d2d00
        ailp =3D 0xffff88007aad5240
        stale =3D 0
        __func__ =3D "xfs_buf_item_unpin"
#4  0xffffffff8165d104 in xfs_trans_committed_bulk (ailp=3D0xffff88007aad52=
40, log_vector=3D<optimized out>, commit_lsn=3D0, aborted=3Daborted@entry=
=3D2) at fs/xfs/xfs_trans.c:1305
        lip =3D 0xffff88007a9c0d20
        item_lsn =3D 0
        log_items =3D {0xffff88007f9d37c0, 0xffff880079fbbe80, 0xffff880072=
4d5ac8, 0xffffffff81dba277 <__schedule+3791>, 0xffff8800724d5b28, 0xffff880=
07ad99560, 0xffff88007ad99560, 0xffff88007aebef60, 0x2 <irq_stack_union+2>,=
 0xffff8800790df578, 0xffff8800724d5b98,=20
          0xffffffff8189d08e <trace_hardirqs_on_thunk+58>, 0xffff88007f8000=
00, 0x3 <irq_stack_union+3>, 0x1 <irq_stack_union+1>, 0xffff88007aaf2b28, 0=
xffff8800724d5fd8, 0xffff8800724d4000, 0x2 <irq_stack_union+2>, 0xffff88007=
24d5ad8, 0xffffffff810cd59a <irq_exit+410>,=20
          0xffffffff81dbeb74 <restore_args>, 0xffff8800724d59d0, 0xffffffff=
81e03e40 <save_stack_ops>, 0xffff880079151cb8, 0x2 <irq_stack_union+2>, 0xf=
fff8800724adfb0, 0x2 <irq_stack_union+2>, 0x0 <irq_stack_union>, 0xffff8800=
7affd520, 0xffff88007aad5240,=20
          0xffffffffffffff10}
        lv =3D 0xffff88007affd520
        cur =3D <incomplete type>
        i =3D <optimized out>
        __func__ =3D "xfs_trans_committed_bulk"
#5  0xffffffff81669107 in xlog_cil_committed (args=3Dargs@entry=3D0xffff880=
07ad99560, abort=3Dabort@entry=3D2) at fs/xfs/xfs_log_cil.c:337
        ctx =3D 0xffff88007ad99560
        mp =3D 0xffff88007aebef60
        __func__ =3D "xlog_cil_committed"
#6  0xffffffff8166a301 in xlog_cil_push (log=3Dlog@entry=3D0xffff8800724adf=
b0) at fs/xfs/xfs_log_cil.c:582
        cil =3D 0xffff8800790df480
        lv =3D <optimized out>
        ctx =3D 0xffff88007ad99560
        new_ctx =3D <optimized out>
        commit_iclog =3D 0xffffffff81170cb4 <__lock_release+100>
        tic =3D 0xffff880079151c00
        num_iovecs =3D <optimized out>
        error =3D <optimized out>
        thdr =3D {
          th_magic =3D 1414676814,=20
          th_type =3D 42,=20
          th_tid =3D -576842867,=20
          th_num_items =3D 3777
        }
        lhdr =3D {
          i_addr =3D 0xffff8800724d5be8,=20
          i_len =3D 16,=20
          i_type =3D 19
        }
        lvhdr =3D {
          lv_next =3D 0xffff88007affd520,=20
          lv_niovecs =3D 1,=20
          lv_iovecp =3D 0xffff8800724d5bd8,=20
          lv_item =3D 0x0 <irq_stack_union>,=20
          lv_buf =3D 0x0 <irq_stack_union>,=20
          lv_buf_len =3D 0
        }
        commit_lsn =3D <optimized out>
        push_seq =3D 1
        __func__ =3D "xlog_cil_push"
#7  0xffffffff8166a4a9 in xlog_cil_push_foreground (log=3Dlog@entry=3D0xfff=
f8800724adfb0, push_seq=3Dpush_seq@entry=3D1) at fs/xfs/xfs_log_cil.c:659
        cil =3D 0xffff8800790df480
        __func__ =3D "xlog_cil_push_foreground"
#8  0xffffffff8166a8f1 in xlog_cil_force_lsn (log=3Dlog@entry=3D0xffff88007=
24adfb0, sequence=3D1) at fs/xfs/xfs_log_cil.c:771
        cil =3D 0xffff8800790df480
        ctx =3D <optimized out>
        commit_lsn =3D -1
        __func__ =3D "xlog_cil_force_lsn"
#9  0xffffffff81665d5c in xlog_cil_force (log=3D0xffff8800724adfb0) at fs/x=
fs/xfs_log_priv.h:668
No locals.
#10 _xfs_log_force (mp=3Dmp@entry=3D0xffff88007aebef60, flags=3Dflags@entry=
=3D1, log_flushed=3Dlog_flushed@entry=3D0x0 <irq_stack_union>) at fs/xfs/xf=
s_log.c:2889
        log =3D 0xffff8800724adfb0
        iclog =3D <optimized out>
        lsn =3D <optimized out>
        __func__ =3D "_xfs_log_force"
#11 0xffffffff81666479 in xfs_log_force (mp=3Dmp@entry=3D0xffff88007aebef60=
, flags=3Dflags@entry=3D1) at fs/xfs/xfs_log.c:3004
        error =3D <optimized out>
        __func__ =3D "xfs_log_force"
#12 0xffffffff815ad9ec in xfs_quiesce_data (mp=3Dmp@entry=3D0xffff88007aebe=
f60) at fs/xfs/xfs_sync.c:310
        error =3D <optimized out>
        error2 =3D 0
        __func__ =3D "xfs_quiesce_data"
#13 0xffffffff815a78a0 in xfs_fs_sync_fs (sb=3D<optimized out>, wait=3D<opt=
imized out>) at fs/xfs/xfs_super.c:946
        mp =3D 0xffff88007aebef60
        error =3D <optimized out>
        __func__ =3D "xfs_fs_sync_fs"
#14 0xffffffff813b0389 in __sync_filesystem (sb=3Dsb@entry=3D0xffff88007a1a=
d668, wait=3Dwait@entry=3D1) at fs/sync.c:38
        __func__ =3D "__sync_filesystem"
#15 0xffffffff813b0477 in sync_filesystem (sb=3Dsb@entry=3D0xffff88007a1ad6=
68) at fs/sync.c:66
        ret =3D <optimized out>
        __func__ =3D "sync_filesystem"
#16 0xffffffff8134da7f in generic_shutdown_super (sb=3D0xffff88007a1ad668) =
at fs/super.c:439
        sop =3D 0xffffffff81e86360 <xfs_super_operations>
        __func__ =3D "generic_shutdown_super"
#17 0xffffffff8134dc62 in kill_block_super (sb=3D<optimized out>) at fs/sup=
er.c:1104
        bdev =3D 0xffff88007d0115c0
        mode =3D 131
        __func__ =3D "kill_block_super"
#18 0xffffffff8134ed14 in deactivate_locked_super (s=3Ds@entry=3D0xffff8800=
7a1ad668) at fs/super.c:306
        fs =3D 0xffffffff828057c0 <xfs_fs_type>
        __func__ =3D "deactivate_locked_super"
#19 0xffffffff813501c7 in deactivate_super (s=3Ds@entry=3D0xffff88007a1ad66=
8) at fs/super.c:337
        __func__ =3D "deactivate_super"
#20 0xffffffff813902f4 in mntfree (mnt=3D0xffff88007ababd40) at fs/namespac=
e.c:855
        m =3D 0xffff88007ababd60
        sb =3D 0xffff88007a1ad668
#21 mntput_no_expire (mnt=3Dmnt@entry=3D0xffff88007ababd40) at fs/namespace=
=2Ec:893
        __func__ =3D "mntput_no_expire"
#22 0xffffffff81392ce5 in sys_umount (name=3D<optimized out>, flags=3D0) at=
 fs/namespace.c:1276
        path =3D <incomplete type>
        mnt =3D 0xffff88007ababd40
        retval =3D 0
        lookup_flags =3D <optimized out>
        __func__ =3D "sys_umount"
#23 <signal handler called>
No locals.
#24 0x00007f66053c34f7 in ?? ()
No symbol table info available.
#25 0x000000050003123b in ?? ()
No symbol table info available.
#26 0x0000000000100000 in cpu_lock_stats ()
No symbol table info available.
Continuing.

Program received signal SIGINT, Interrupt.
0xffffffff810607bb in native_safe_halt () at /media/Vone/kernel/xfs-next/ar=
ch/x86/include/asm/irqflags.h:49
49		asm volatile("sti; hlt": : :"memory");
A debugging session is active.

	Inferior 1 [Remote target] will be killed.

Quit anyway? (y or n)=20
--BOKacYhQ+x31HxR3--

--3uo+9/B/ebqu+fSQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJQQ/2hAAoJEKYW3KHXK+l3L3AH/1EQQyel63dJNyLcERgPHgiZ
iVGSINpUaWu8r40+3CCr6S6tAVwFbRF+RjNCQa1IOOsn0Stiu4Xr92f1RcmJm8+B
ooNULuQ4tcv8cxJRzqLd1CWfLr32T0fY+Xb9M4M32FnaSCWmWmdRkAdeTk53X8Et
Als6B2oBr3iiHKQ2FqPg68+0IbkvCYPG6/QP/POiPmxJ3cs9x589wjDc+Pkzi6xK
ffegDYSHoilOZG4OQQgV07vTv8sITH0u+udmko9advYYuYR5OCEWZ5plBBWW1Uf7
w2MJRCQbQVCw4lQ27/yvAc5FiaRr+uFkgsz+3TrqGEMPpDo6XxkET2Az8To1oBA=
=j16h
-----END PGP SIGNATURE-----

--3uo+9/B/ebqu+fSQ--


--===============3508588599207055699==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3508588599207055699==--
