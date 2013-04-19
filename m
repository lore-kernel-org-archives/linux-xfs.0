Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D743F7CBF
	for <xfs@oss.sgi.com>; Fri, 19 Apr 2013 06:41:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C2E0F304075
	for <xfs@oss.sgi.com>; Fri, 19 Apr 2013 04:41:45 -0700 (PDT)
Received: from mail-ie0-f169.google.com (mail-ie0-f169.google.com
	[209.85.223.169]) by cuda.sgi.com with ESMTP id
	ishqo3AGQx7EHCwb (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Apr 2013 04:41:41 -0700 (PDT)
Received: by mail-ie0-f169.google.com with SMTP id ar20so4629426iec.28
	for <xfs@oss.sgi.com>; Fri, 19 Apr 2013 04:41:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADFMGu+hPV9RanG7298TAYY4p9gMiBOk0+mq5gf5rhQUWXf4TQ@mail.gmail.com>
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
Date: Fri, 19 Apr 2013 19:41:40 +0800
Message-ID: <CADFMGuJYDp-YrPDqsz2KKx6_2RCkP37ZNGPLzdTVOpEgKDMsjA@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============2555477095096314217=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============2555477095096314217==
Content-Type: multipart/alternative; boundary=047d7bd75decdcf3dc04dab533c0

--047d7bd75decdcf3dc04dab533c0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

Dear Brian and Eric,

kernel kernel-2.6.32-279.19.1.el6.x86_64.rpm<http://mirror.linux.duke.edu/p=
ub/centos/6.3/updates/x86_64/Packages/kernel-2.6.32-279.19.1.el6.x86_64.rpm=
>still
have this problem
I build the kernel from this srpm
https://oss.oracle.com/ol6/SRPMS-updates/kernel-2.6.32-279.19.1.el6.src.rpm

today the shutdown happens again during test.
Seelogs bellow:

/var/log/message
Apr 19 16:40:05 10 kernel: XFS (sdb): xfs_iunlink_remove: xfs_inotobp()
returned error 22.
Apr 19 16:40:05 10 kernel: XFS (sdb): xfs_inactive: xfs_ifree returned
error 22
Apr 19 16:40:05 10 kernel: XFS (sdb): xfs_do_force_shutdown(0x1) called
from line 1184 of file fs/xfs/xfs_vnodeops.c.  Return address =3D
0xffffffffa02d4bda
Apr 19 16:40:05 10 kernel: XFS (sdb): I/O Error Detected. Shutting down
filesystem
Apr 19 16:40:05 10 kernel: XFS (sdb): Please umount the filesystem and
rectify the problem(s)
Apr 19 16:40:07 10 kernel: XFS (sdb): xfs_log_force: error 5 returned.
Apr 19 16:40:37 10 kernel: XFS (sdb): xfs_log_force: error 5 returned.

systemtap script output:
--- xfs_imap --
module("xfs").function("xfs_imap@fs/xfs/xfs_ialloc.c:1257").return
-- return=3D0x16
vars: mp=3D0xffff88101801e800 tp=3D0xffff880ff143ac70 ino=3D0xffffffff
imap=3D0xffff88100e93bc08 flags=3D0x0 agbno=3D? agino=3D? agno=3D? blks_per=
_cluster=3D?
chunk_agbno=3D? cluster_agbno=3D? error=3D? offset=3D? offset_agbno=3D? __f=
unc__=3D[...]
mp: m_agno_log =3D 0x5, m_agino_log =3D 0x20
mp->m_sb: sb_agcount =3D 0x1c, sb_agblocks =3D 0xffffff0, sb_inopblog =3D 0=
x4,
sb_agblklog =3D 0x1c, sb_dblocks =3D 0x1b4900000
imap: im_blkno =3D 0x0, im_len =3D 0xe778, im_boffset =3D 0xd997
kernel backtrace:
Returning from:  0xffffffffa02b4260 : xfs_imap+0x0/0x280 [xfs]
Returning to  :  0xffffffffa02b9d59 : xfs_inotobp+0x49/0xc0 [xfs]
 0xffffffffa02b9ec1 : xfs_iunlink_remove+0xf1/0x360 [xfs]
 0xffffffff814ede89
 0x0 (inexact)
user backtrace:
 0x3ec260e5ad [/lib64/libpthread-2.12.so+0xe5ad/0x219000]

--- xfs_iunlink_remove --
module("xfs").function("xfs_iunlink_remove@fs/xfs/xfs_inode.c:1681").return
-- return=3D0x16
vars: tp=3D0xffff880ff143ac70 ip=3D0xffff8811ed111000 next_ino=3D? mp=3D? a=
gi=3D?
dip=3D? agibp=3D? ibp=3D? agno=3D? agino=3D? next_agino=3D? last_ibp=3D?
last_dip=3D0xffff881000000001 bucket_index=3D? offset=3D?
last_offset=3D0xffffffffffff8811 error=3D? __func__=3D[...]
ip: i_ino =3D 0x1bd33, i_flags =3D 0x0
ip->i_d: di_nlink =3D 0x0, di_gen =3D 0x53068791

debugfs events trace:
https://docs.google.com/file/d/0B7n2C4T5tfNCREZtdC1yamc0RnM/edit?usp=3Dshar=
ing

xfs_metadump:
https://docs.google.com/file/d/0B7n2C4T5tfNCc2tiMjdhMTVfOWM/edit?usp=3Dshar=
ing

again this happens exactly when glusterfs rebalance finishes on one of the
brick(this time it is current host)
glusterfs log:
[2013-04-19 16:40:03.835675] I [dht-common.c:2337:dht_setxattr]
0-testbug-dht: fixing the layout of /lib/kbd/consoletrans
[2013-04-19 16:40:03.842024] I [dht-common.c:2337:dht_setxattr]
0-testbug-dht: fixing the layout of /lib/kbd/consoletrans
[2013-04-19 16:40:03.844120] I
[dht-rebalance.c:1055:gf_defrag_migrate_data] 0-testbug-dht: migrate data
called on /lib/kbd/consoletrans
[2013-04-19 16:40:03.852926] I
[dht-rebalance.c:1055:gf_defrag_migrate_data] 0-testbug-dht: migrate data
called on /lib/kbd/consoletrans
[2013-04-19 16:40:03.856602] I [dht-common.c:2337:dht_setxattr]
0-testbug-dht: fixing the layout of /lib/kbd/consoletrans
[2013-04-19 16:40:03.860231] I
[dht-rebalance.c:1055:gf_defrag_migrate_data] 0-testbug-dht: migrate data
called on /lib/kbd/consoletrans
[2013-04-19 16:40:03.892069] I [dht-common.c:2337:dht_setxattr]
0-testbug-dht: fixing the layout of /lib/alsa
[2013-04-19 16:40:03.897155] I
[dht-rebalance.c:1055:gf_defrag_migrate_data] 0-testbug-dht: migrate data
called on /lib/alsa
[2013-04-19 16:40:03.897582] I [dht-common.c:2337:dht_setxattr]
0-testbug-dht: fixing the layout of /lib/alsa
[2013-04-19 16:40:03.901076] I
[dht-rebalance.c:1055:gf_defrag_migrate_data] 0-testbug-dht: migrate data
called on /lib/alsa
[2013-04-19 16:40:03.903689] I [dht-common.c:2337:dht_setxattr]
0-testbug-dht: fixing the layout of /lib/alsa
[2013-04-19 16:40:03.906643] I
[dht-rebalance.c:1055:gf_defrag_migrate_data] 0-testbug-dht: migrate data
called on /lib/alsa
[2013-04-19 16:40:03.910744] I [dht-common.c:2337:dht_setxattr]
0-testbug-dht: fixing the layout of /lib/alsa/init
[2013-04-19 16:40:03.913475] I
[dht-rebalance.c:1055:gf_defrag_migrate_data] 0-testbug-dht: migrate data
called on /lib/alsa/init
[2013-04-19 16:40:03.915424] I [dht-common.c:2337:dht_setxattr]
0-testbug-dht: fixing the layout of /lib/alsa/init
[2013-04-19 16:40:03.918699] I
[dht-rebalance.c:1055:gf_defrag_migrate_data] 0-testbug-dht: migrate data
called on /lib/alsa/init
[2013-04-19 16:40:03.920459] I [dht-common.c:2337:dht_setxattr]
0-testbug-dht: fixing the layout of /lib/alsa/init
[2013-04-19 16:40:03.922857] I
[dht-rebalance.c:1055:gf_defrag_migrate_data] 0-testbug-dht: migrate data
called on /lib/alsa/init
[2013-04-19 16:40:05.107663] I [dht-rebalance.c:1611:gf_defrag_status_get]
0-glusterfs: Rebalance is completed
[2013-04-19 16:40:05.107770] I [dht-rebalance.c:1614:gf_defrag_status_get]
0-glusterfs: Files migrated: 993, size: 16161958687, lookups: 190891,
failures: 8957
[2013-04-19 16:40:05.108628] W [glusterfsd.c:831:cleanup_and_exit]
(-->/lib64/libc.so.6(clone+0x6d) [0x3ec22e767d]
(-->/lib64/libpthread.so.0() [0x3ec2607851]
(-->/usr/sbin/glusterfs(glusterfs_sigwaiter+0xdd) [0x405c9d]))) 0-:
received signum (15), shutting down
[2013-04-19 16:40:05.109007] E
[rpcsvc.c:1155:rpcsvc_program_unregister_portmap] 0-rpc-service: Could not
unregister with portmap



2013/4/19 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com>

> Hi Brian and Eric,
>
> I have applied your kernel path v2(add unlink trace) to
> kernel-2.6.32-279.19.1.el6.x86_64.rpm<http://mirror.linux.duke.edu/pub/ce=
ntos/6.3/updates/x86_64/Packages/kernel-2.6.32-279.19.1.el6.x86_64.rpm>in o=
ut test cluster and start testing again.
> Any progress will let you known. Thank you.
>
>
> 2013/4/19 Brian Foster <bfoster@redhat.com>
>
>> On 04/18/2013 11:23 AM, =B7=FB=D3=C0=CC=CE wrote:
>> > Hi Brian and Eric,
>> > The shutdown is not easy to produce but finally right now 2 of our
>> > servers in our test cluster xfs was shutdown.
>> >
>>
>> Understood. We've been trying very hard to reproduce ourselves to make
>> it easier to debug, but haven't been able to reproduce at all so far.
>> This process allows us to make _some_ progress on the issue, even if it
>> is slower going than we'd like... ;)
>>
>> > the trace output as following
>> >
>> https://docs.google.com/file/d/0B7n2C4T5tfNCLXRYUWJ0b19JcWc/edit?usp=3Ds=
haring
>> >
>>
>> Thanks again for the data. The racing behavior Eric called out (nice
>> catch!) in his last mail lit up some light bulbs internally with regard
>> to some old locking issues triggered by XFS in the 6.3 kernel. The
>> following bug serves as an example:
>>
>> https://bugzilla.redhat.com/show_bug.cgi?id=3D852847
>>
>> ... the fix for which went into the 2.6.32-279.19.1 6.3.z release. Could
>> you move some or all of your servers to this kernel[1] and see how it
>> goes? The best case is it resolves the problem, worst case we carry on
>> debugging from there...
>>
>> Brian
>>
>> [1] -
>>
>> http://mirror.linux.duke.edu/pub/centos/6.3/updates/x86_64/Packages/kern=
el-2.6.32-279.19.1.el6.x86_64.rpm
>>
>> > Sorry but the systemtap is interrupt and I didn't noticed that so I
>> > didn't get systemtap logs.
>> >
>> > /var/log/message is same as before
>> > Apr 18 22:43:14 10 kernel: XFS (sdb): xfs_iunlink_remove: xfs_inotobp(=
)
>> > returned error 22.
>> > Apr 18 22:43:14 10 kernel: XFS (sdb): xfs_inactive: xfs_ifree returned
>> > error 22
>> > Apr 18 22:43:14 10 kernel: XFS (sdb): xfs_do_force_shutdown(0x1) calle=
d
>> > from line 1184 of file fs/xfs/xfs_vnodeops.c.  Return address =3D
>> > 0xffffffffa02d44aa
>> > Apr 18 22:43:14 10 kernel: XFS (sdb): I/O Error Detected. Shutting dow=
n
>> > filesystem
>> > Apr 18 22:43:14 10 kernel: XFS (sdb): Please umount the filesystem and
>> > rectify the problem(s)
>> > Apr 18 22:43:20 10 kernel: XFS (sdb): xfs_log_force: error 5 returned.
>> >
>> > The metadump file is large I'll share it to you soon.
>> >
>> >
>> > 2013/4/18 Brian Foster <bfoster@redhat.com <mailto:bfoster@redhat.com>=
>
>> >
>> >     On 04/18/2013 04:25 AM, =B7=FB=D3=C0=CC=CE wrote:
>> >     > Hi Brian and Eric,
>> >     > Can I change as following to bypass it?
>> >
>> >     This is probably not a wise thing to do. The problem we're seeing
>> here
>> >     is indicative of a potentially larger problem than this particular
>> error
>> >     path. An inode is being unlinked and inactivated, but we aren't
>> finding
>> >     on the list where we expect it to be. Killing the error return
>> doesn't
>> >     eliminate the larger problem.
>> >
>> >     So while changes could end up being made in this area as part of a
>> fix,
>> >     I would not suggest making any changes beyond those designed to he=
lp
>> >     debug until we have a better idea of root cause.
>> >
>> >     Brian
>> >
>> >     > --- a/xfs_inode.c
>> >     > +++ b/xfs_inode.c
>> >     > @@ -1764,7 +1764,7 @@ xfs_iunlink_remove(
>> >     >                  */
>> >     >                 next_agino =3D
>> >     be32_to_cpu(agi->agi_unlinked[bucket_index]);
>> >     >                 last_ibp =3D NULL;
>> >     > -               while (next_agino !=3D agino) {
>> >     > +               while (next_agino !=3D agino && next_agino !=3D
>> >     NULLAGINO) {
>> >     >                         /*
>> >     >                          * If the last inode wasn't the one
>> >     pointing to
>> >     >                          * us, then release its buffer since
>> we're not
>> >     > @@ -1786,6 +1786,14 @@ xfs_iunlink_remove(
>> >     >                         ASSERT(next_agino !=3D NULLAGINO);
>> >     >                         ASSERT(next_agino !=3D 0);
>> >     >                 }
>> >     > +               if (next_agino =3D=3D NULLAGINO) {
>> >     > +                       /*
>> >     > +                        *After search the list for the inode
>> >     being free
>> >     > +                        *we still can't find it.
>> >     > +                        */
>> >     > +                       xfs_err(mp, "%s ino %lld not found in
>> unlinked
>> >     > list.",
>> >     > +                                    __func__, (unsigned long
>> >     > long)ip->i_ino);
>> >     > +               }
>> >     >                 /*
>> >     >                  * Now last_ibp points to the buffer previous to
>> us on
>> >     >                  * the unlinked list.  Pull us from the list.
>> >     > @@ -1810,16 +1818,20 @@ xfs_iunlink_remove(
>> >     >                 } else {
>> >     >                         xfs_trans_brelse(tp, ibp);
>> >     >                 }
>> >     > -               /*
>> >     > -                * Point the previous inode on the list to the
>> >     next inode.
>> >     > -                */
>> >     > -               last_dip->di_next_unlinked =3D
>> cpu_to_be32(next_agino);
>> >     > -               ASSERT(next_agino !=3D 0);
>> >     > -               offset =3D last_offset + offsetof(xfs_dinode_t,
>> >     > di_next_unlinked);
>> >     > -               xfs_trans_inode_buf(tp, last_ibp);
>> >     > -               xfs_trans_log_buf(tp, last_ibp, offset,
>> >     > -                                 (offset + sizeof(xfs_agino_t) =
-
>> 1));
>> >     > -               xfs_inobp_check(mp, last_ibp);
>> >     > +               if (next_agino !=3D NULLAGINO) {
>> >     > +                       /*
>> >     > +                       * If only find the inode being free then
>> >     we modify
>> >     > +                       * the unlinked list.
>> >     > +                       * Point the previous inode on the list t=
o
>> the
>> >     > next inode.
>> >     > +                       */
>> >     > +                       last_dip->di_next_unlinked =3D
>> >     > cpu_to_be32(next_agino);
>> >     > +                       ASSERT(next_agino !=3D 0);
>> >     > +                       offset =3D last_offset +
>> offsetof(xfs_dinode_t,
>> >     > di_next_unlinked);
>> >     > +                       xfs_trans_inode_buf(tp, last_ibp);
>> >     > +                       xfs_trans_log_buf(tp, last_ibp, offset,
>> >     > +                                         (offset +
>> >     sizeof(xfs_agino_t)
>> >     > - 1));
>> >     > +                       xfs_inobp_check(mp, last_ibp);
>> >     > +               }
>> >     >         }
>> >     >         return 0;
>> >     >  }
>> >     >
>> >     > Thank you.
>> >     >
>> >     >
>> >     > 2013/4/18 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com <mailto:yongta=
ofu@gmail.com>
>> >     <mailto:yongtaofu@gmail.com <mailto:yongtaofu@gmail.com>>>
>> >     >
>> >     >     Hi Brain and Eric,
>> >     >     If the problem is the agno can't be found in the unlinked
>> >     list. Can
>> >     >     we just bypass it instead of passing ino=3D0xffffffff to
>> >     xfs_inotobp?
>> >     >     Thank you.
>> >     >
>> >     >
>> >     >     2013/4/18 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com
>> >     <mailto:yongtaofu@gmail.com> <mailto:yongtaofu@gmail.com
>> >     <mailto:yongtaofu@gmail.com>>>
>> >     >
>> >     >         Hi Eric,
>> >     >         The shutdown issue is still not reproduced yet. But I ge=
t
>> the
>> >     >         following error today during test.
>> >     >
>> >     >         Apr 18 07:42:51 10 kernel: Call Trace:
>> >     >         Apr 18 07:42:51 10 kernel: [<ffffffffa02d91ef>] ?
>> >     >         xfs_buf_cond_lock+0x2f/0xc0 [xfs]
>> >     >         Apr 18 07:42:51 10 kernel: [<ffffffff814fe6a5>]
>> >     >         schedule_timeout+0x215/0x2e0
>> >     >         Apr 18 07:42:51 10 kernel: [<ffffffffa02d5f07>] ?
>> >     >         kmem_zone_alloc+0x77/0xf0 [xfs]
>> >     >         Apr 18 07:42:51 10 kernel: [<ffffffff814ff5c2>]
>> >     __down+0x72/0xb0
>> >     >         Apr 18 07:42:51 10 kernel: [<ffffffffa02da652>] ?
>> >     >         _xfs_buf_find+0x102/0x280 [xfs]
>> >     >         Apr 18 07:42:51 10 kernel: "echo 0 >
>> >     >         /proc/sys/kernel/hung_task_timeout_secs" disables this
>> >     message.
>> >     >         Apr 18 07:42:51 10 kernel: glusterfsd    D
>> ffffffff8160b3c0
>> >     >         0 14522      1 0x00000083
>> >     >         Apr 18 07:42:51 10 kernel: ffff882015a63a28
>> 0000000000000082
>> >     >         0000000000000000 0000000000000000
>> >     >         Apr 18 07:42:51 10 kernel: ffff882015a639b8
>> ffffffffa02d91ef
>> >     >         ffff882015a639d8 0000000000000246
>> >     >         Apr 18 07:42:51 10 kernel: ffff880e70491af8
>> ffff882015a63fd8
>> >     >         000000000000fb88 ffff880e70491af8
>> >     >         Apr 18 07:42:51 10 kernel: Call Trace:
>> >     >         Apr 18 07:42:51 10 kernel: [<ffffffffa02d91ef>] ?
>> >     >         xfs_buf_cond_lock+0x2f/0xc0 [xfs]
>> >     >         Apr 18 07:42:51 10 kernel: [<ffffffff814fe6a5>]
>> >     >         schedule_timeout+0x215/0x2e0
>> >     >         Apr 18 07:42:51 10 kernel: [<ffffffffa02d5f07>] ?
>> >     >         kmem_zone_alloc+0x77/0xf0 [xfs]
>> >     >         Apr 18 07:42:51 10 kernel: [<ffffffff814ff5c2>]
>> >     __down+0x72/0xb0
>> >     >         Apr 18 07:42:51 10 kernel: [<ffffffffa02da652>] ?
>> >     >         _xfs_buf_find+0x102/0x280 [xfs]
>> >     >         Apr 18 07:42:51 10 kernel: [<ffffffff81097ef1>]
>> down+0x41/0x50
>> >     >         Apr 18 07:42:51 10 kernel: [<ffffffffa02da493>]
>> >     >         xfs_buf_lock+0x53/0x110 [xfs]
>> >     >         Apr 18 07:42:51 10 kernel: [<ffffffffa02da652>]
>> >     >         _xfs_buf_find+0x102/0x280 [xfs]
>> >     >         Apr 18 07:42:51 10 kernel: [<ffffffffa02da83b>]
>> >     >         xfs_buf_get+0x6b/0x1a0 [xfs]
>> >     >         Apr 18 07:42:51 10 kernel: [<ffffffffa02daeac>]
>> >     >         xfs_buf_read+0x2c/0x100 [xfs]
>> >     >         Apr 18 07:42:51 10 kernel: [<ffffffffa02d0af8>]
>> >     >         xfs_trans_read_buf+0x1f8/0x400 [xfs]
>> >     >         Apr 18 07:42:51 10 kernel: [<ffffffffa02b3444>]
>> >     >         xfs_read_agi+0x74/0x100 [xfs]
>> >     >         Apr 18 07:42:51 10 kernel: [<ffffffffa02b967b>]
>> >     >         xfs_iunlink+0x5b/0x180 [xfs]
>> >     >         Apr 18 07:42:51 10 kernel: [<ffffffff810724c7>] ?
>> >     >         current_fs_time+0x27/0x30
>> >     >         Apr 18 07:42:51 10 kernel: [<ffffffffa02d12a7>] ?
>> >     >         xfs_trans_ichgtime+0x27/0xa0 [xfs]
>> >     >         Apr 18 07:42:51 10 kernel: [<ffffffffa02d15fb>]
>> >     >         xfs_droplink+0x5b/0x70 [xfs]
>> >     >         Apr 18 07:42:51 10 kernel: [<ffffffffa02d2f9e>]
>> >     >         xfs_remove+0x27e/0x3a0 [xfs]
>> >     >         Apr 18 07:42:51 10 kernel: [<ffffffff81186fd3>] ?
>> >     >         generic_permission+0x23/0xb0
>> >     >         Apr 18 07:42:51 10 kernel: [<ffffffffa02e0968>]
>> >     >         xfs_vn_unlink+0x48/0x90 [xfs]
>> >     >         Apr 18 07:42:51 10 kernel: [<ffffffff81188c0f>]
>> >     vfs_unlink+0x9f/0xe0
>> >     >         Apr 18 07:42:51 10 kernel: [<ffffffff8118795a>] ?
>> >     >         lookup_hash+0x3a/0x50
>> >     >         Apr 18 07:42:51 10 kernel: [<ffffffff8118b143>]
>> >     >         do_unlinkat+0x183/0x1c0
>> >     >         Apr 18 07:42:51 10 kernel: [<ffffffff81017938>] ?
>> >     >         syscall_trace_enter+0x1d8/0x1e0
>> >     >         Apr 18 07:42:51 10 kernel: [<ffffffff8118b196>]
>> >     sys_unlink+0x16/0x20
>> >     >         Apr 18 07:42:51 10 kernel: [<ffffffff8100b308>]
>> >     tracesys+0xd9/0xde
>> >     >
>> >     >         Thank you.
>> >     >
>> >     >
>> >     >         2013/4/17 Eric Sandeen <sandeen@sandeen.net
>> >     <mailto:sandeen@sandeen.net>
>> >     >         <mailto:sandeen@sandeen.net <mailto:sandeen@sandeen.net
>> >>>
>> >     >
>> >     >             On Apr 16, 2013, at 8:48 PM, =B7=FB=D3=C0=CC=CE
>> >     <yongtaofu@gmail.com <mailto:yongtaofu@gmail.com>
>> >     >             <mailto:yongtaofu@gmail.com
>> >     <mailto:yongtaofu@gmail.com>>> wrote:
>> >     >
>> >     >>             Hi Brain,
>> >     >>             Can I change as following?
>> >     >
>> >     >             ASSERTS are no-ops in a non-debug kernel, so this
>> won't
>> >     >             change any behavior.  I hope we'll know more if we
>> get new
>> >     >             traces from your patched kernel....
>> >     >
>> >     >             Eric
>> >     >
>> >     >>             --- a/xfs_inode.c
>> >     >>             +++ b/xfs_inode.c
>> >     >>             @@ -1773,6 +1773,8 @@ xfs_iunlink_remove(
>> >     >>                                     if (last_ibp !=3D NULL) {
>> >     >>                                             xfs_trans_brelse(tp=
,
>> >     >>             last_ibp);
>> >     >>                                     }
>> >     >>             +                        ASSERT(next_agino !=3D
>> NULLAGINO);
>> >     >>             +                        ASSERT(next_agino !=3D 0);
>> >     >>                                     next_ino =3D
>> XFS_AGINO_TO_INO(mp,
>> >     >>             agno, next_agino);
>> >     >>                                     error =3D xfs_inotobp(mp, t=
p,
>> >     >>             next_ino, &last_dip,
>> >     >>
>> &last_ibp,
>> >     >>             &last_offset, 0);
>> >     >>             @@ -1783,8 +1785,6 @@ xfs_iunlink_remove(
>> >     >>                                             return error;
>> >     >>                                     }
>> >     >>                                     next_agino =3D
>> >     >>             be32_to_cpu(last_dip->di_next_unlinked);
>> >     >>             -                       ASSERT(next_agino !=3D
>> NULLAGINO);
>> >     >>             -                       ASSERT(next_agino !=3D 0);
>> >     >>                             }
>> >     >>                             /*
>> >     >>                              * Now last_ibp points to the buffe=
r
>> >     >>             previous to us on
>> >     >>
>> >     >>             Thank you.
>> >     >>
>> >     >>
>> >     >>             2013/4/17 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com
>> >     <mailto:yongtaofu@gmail.com>
>> >     >>             <mailto:yongtaofu@gmail.com
>> >     <mailto:yongtaofu@gmail.com>>>
>> >     >>
>> >     >>                 Hi Brain,
>> >     >>                 If it is because NULLAGINO is passed in  to
>> >     xfs_inotobp().
>> >     >>                 Can I move the following two lines before
>> >     xfs_inotobp?
>> >     >>
>> >     >>                 For example:
>> >     >>
>> >     >>                 1767                 while (next_agino !=3D agi=
no)
>> {
>> >     >>                 1768                         /*
>> >     >>                 1769                          * If the last ino=
de
>> >     >>                 wasn't the one pointing to
>> >     >>                 1770                          * us, then releas=
e
>> its
>> >     >>                 buffer since we're not
>> >     >>                 1771                          * going to do
>> anything
>> >     >>                 with it.
>> >     >>                 1772                          */
>> >     >>                 1773                         if (last_ibp !=3D
>> NULL) {
>> >     >>                 1774
>> >     >>                 xfs_trans_brelse(tp, last_ibp);
>> >     >>                 1775                         }
>> >     >>                 1776                         next_ino =3D
>> >     >>                 XFS_AGINO_TO_INO(mp, agno, next_agino);
>> >     >>                 +
>> ASSERT(next_agino !=3D
>> >     >>                 NULLAGINO);
>> >     >>                 +                               ASSERT(next_agi=
no
>> >     !=3D 0);
>> >     >>                 1777                         error =3D
>> xfs_inotobp(mp,
>> >     >>                 tp, next_ino, &last_dip,
>> >     >>                 1778
>> >     >>                 &last_ibp, &last_offset, 0);
>> >     >>                 1779                         if (error) {
>> >     >>                 1780                                 xfs_warn(m=
p,
>> >     >>                 1781                                         "%=
s:
>> >     >>                 xfs_inotobp() returned error %d.",
>> >     >>                 1782
>> >     __func__,
>> >     >>                 error);
>> >     >>                 1783                                 return
>> error;
>> >     >>                 1784                         }
>> >     >>                 1785                         next_agino =3D
>> >     >>                 be32_to_cpu(last_dip->di_next_unlinked);
>> >     >>                 -
>> >     //ASSERT(next_agino !=3D
>> >     >>                 NULLAGINO);
>> >     >>                 -
>> >     //ASSERT(next_agino !=3D 0);
>> >     >>                 1788                 }
>> >     >>                 I don't understand xfs well and correct me if I=
'm
>> >     >>                 totally wrong.
>> >     >>                 Thank you very much.
>> >     >>
>> >     >>
>> >     >>                 2013/4/17 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.c=
om
>> >     <mailto:yongtaofu@gmail.com>
>> >     >>                 <mailto:yongtaofu@gmail.com
>> >     <mailto:yongtaofu@gmail.com>>>
>> >     >>
>> >     >>                     Hi Brain,
>> >     >>                     I want to ask a question, according to the
>> >     >>                     shutdown trace. The ino in
>>  xfs_iunlink_remove
>> >     >>                     is 0x113, why xfs_imap got ino=3D0xffffffff=
 ?
>> >     >>
>> >     >>                     --- xfs_imap --
>> >     >>
>> >     module("xfs").function("xfs_imap@fs/xfs/xfs_ialloc.c:1257").return
>> >     >>                     -- return=3D0x16
>> >     >>                     vars: mp=3D0xffff882017a50800
>> tp=3D0xffff881c81797c70
>> >     >>                     ino=3D0xffffffff
>> >     >>
>> >     >>                     --- xfs_iunlink_remove --
>> >     >>
>> >     module("xfs").function("xfs_iunlink_remove@fs
>> /xfs/xfs_inode.c:1680").return
>> >     >>                     -- return=3D0x16
>> >     >>                     vars: tp=3D0xffff881c81797c70
>> ip=3D0xffff881003c13c00
>> >     >>                     next_ino=3D? mp=3D? agi=3D? dip=3D?
>> >     >>                     agibp=3D0xffff880109b47e20 ibp=3D? agno=3D?=
 agino=3D?
>> >     >>                     next_agino=3D? last_ibp=3D?
>> >     >>                     last_dip=3D0xffff882000000000 bucket_index=
=3D?
>> >     >>                     offset=3D? last_offset=3D0xffffffffffff8810
>> error=3D?
>> >     >>                     __func__=3D[...]
>> >     >>                     ip: i_ino =3D 0x113, i_flags =3D 0x0
>> >     >>
>> >     >>                     Thank you.
>> >     >>
>> >     >>
>> >     >>
>> >     >>                     2013/4/17 =B7=FB=D3=C0=CC=CE <yongtaofu@gma=
il.com
>> >     <mailto:yongtaofu@gmail.com>
>> >     >>                     <mailto:yongtaofu@gmail.com
>> >     <mailto:yongtaofu@gmail.com>>>
>> >     >>
>> >     >>                         Hi Brain,
>> >     >>                         Thank you for your update, and I have
>> applied
>> >     >>                         your last kernel patch. However it is n=
ot
>> >     easy
>> >     >>                         to reproduce especially in out test
>> >     >>                         environment. Till now is not happens
>> again.
>> >     >>                         I'll update the kernel patch now. BTW i=
s
>> >     there
>> >     >>                         any findings in the logs of previous
>> thread?
>> >     >>
>> >     http://oss.sgi.com/archives/xfs/2013-04/msg00327.html
>> >     >>                         I guess it tend to happen during
>> glusterfs
>> >     >>                         rebalance because glusterfs moves a lot
>> of
>> >     >>                         file from one server to another and the=
n
>> >     >>                         unlink it.
>> >     >>
>> >     >>                         Thank you.
>> >     >>
>> >     >>
>> >     >>                         2013/4/17 Brian Foster
>> >     <bfoster@redhat.com <mailto:bfoster@redhat.com>
>> >     >>                         <mailto:bfoster@redhat.com
>> >     <mailto:bfoster@redhat.com>>>
>> >     >>
>> >     >>                             On 04/16/2013 12:24 PM, Dave Chinne=
r
>> >     wrote:
>> >     >>                             > On Mon, Apr 15, 2013 at 07:14:39P=
M
>> >     >>                             -0400, Brian Foster wrote:
>> >     >>                             >> Hi,
>> >     >>                             >>
>> >     >>                             >> Thanks for the data in the
>> >     previous thread:
>> >     >>                             >>
>> >     >>                             >>
>> >     >>
>> >     http://oss.sgi.com/archives/xfs/2013-04/msg00327.html
>> >     >>                             >>
>> >     >>                             ...
>> >     >>                             >>
>> >     >>                             >>      echo 1 >
>> >     >>
>> >     /sys/kernel/debug/tracing/events/xfs/xfs_iunlink/enable
>> >     >>                             >>      echo 1 >
>> >     >>
>> >     /sys/kernel/debug/tracing/events/xfs/xfs_iunlink_remove/enable
>> >     >>                             >>      ... reproduce ...
>> >     >>                             >>      cat
>> >     >>                             /sys/kernel/debug/tracing/trace >
>> >     trace.output
>> >     >>                             >
>> >     >>                             > It's better to use trace-cmd for
>> this.
>> >     >>                             it will result in less
>> >     >>                             > dropped events. i.e.:
>> >     >>                             >
>> >     >>                             >       $ trace-cmd record -e
>> >     xfs_iunlink\*
>> >     >>                             >       ... reproduce ...
>> >     >>                             >       ^C
>> >     >>                             >       $ trace-cmd report >
>> trace.output
>> >     >>                             >
>> >     >>                             >> --- a/fs/xfs/linux-2.6/xfs_trace=
.h
>> >     >>                             >> +++ b/fs/xfs/linux-2.6/xfs_trace=
.h
>> >     >>                             >> @@ -581,6 +581,8 @@
>> >     >>                             DEFINE_INODE_EVENT(xfs_file_fsync);
>> >     >>                             ...
>> >     >>                             >
>> >     >>                             > I would suggest that the the
>> tracing
>> >     >>                             shoul dbe at entry of the
>> >     >>                             > function, otherwise we won't get =
a
>> >     >>                             tracepoint for the operation that
>> >     >>                             > triggers the shutdown. (That's th=
e
>> >     >>                             reason most tracepoints in XFS
>> >     >>                             > are at function entry...)
>> >     >>                             >
>> >     >>
>> >     >>                             Good points, thanks Dave. A v2 that
>> pulls
>> >     >>                             up the tracepoints towards
>> >     >>                             function entry is appended.
>> >     >>
>> >     >>                             Brian
>> >     >>
>> >     >>                             From
>> >     >>
>> 280943e78ebe0b97a774cba51e7815c42f044b55
>> >     >>                             Mon Sep 17 00:00:00 2001
>> >     >>                             From: Brian Foster
>> >     <bfoster@redhat.com <mailto:bfoster@redhat.com>
>> >     >>                             <mailto:bfoster@redhat.com
>> >     <mailto:bfoster@redhat.com>>>
>> >     >>                             Date: Mon, 15 Apr 2013 18:16:24 -04=
00
>> >     >>                             Subject: [PATCH v2] xfs: add
>> tracepoints
>> >     >>                             for xfs_iunlink and
>> >     >>                             xfs_iunlink_remove
>> >     >>
>> >     >>                             ---
>> >     >>                              fs/xfs/linux-2.6/xfs_trace.h |    =
2
>> ++
>> >     >>                              fs/xfs/xfs_inode.c           |    =
4
>> ++++
>> >     >>                              2 files changed, 6 insertions(+), =
0
>> >     >>                             deletions(-)
>> >     >>
>> >     >>                             diff --git
>> a/fs/xfs/linux-2.6/xfs_trace.h
>> >     >>                             b/fs/xfs/linux-2.6/xfs_trace.h
>> >     >>                             index adc6ec4..338a0f9 100644
>> >     >>                             --- a/fs/xfs/linux-2.6/xfs_trace.h
>> >     >>                             +++ b/fs/xfs/linux-2.6/xfs_trace.h
>> >     >>                             @@ -583,6 +583,8 @@
>> >     >>                             DEFINE_INODE_EVENT(xfs_file_fsync);
>> >     >>
>>  DEFINE_INODE_EVENT(xfs_destroy_inode);
>> >     >>                              DEFINE_INODE_EVENT(xfs_dirty_inode=
);
>> >     >>                              DEFINE_INODE_EVENT(xfs_clear_inode=
);
>> >     >>                             +DEFINE_INODE_EVENT(xfs_iunlink);
>> >     >>
>> +DEFINE_INODE_EVENT(xfs_iunlink_remove);
>> >     >>
>> >     >>
>>  DEFINE_INODE_EVENT(xfs_dquot_dqalloc);
>> >     >>
>>  DEFINE_INODE_EVENT(xfs_dquot_dqdetach);
>> >     >>                             diff --git a/fs/xfs/xfs_inode.c
>> >     >>                             b/fs/xfs/xfs_inode.c
>> >     >>                             index 19900f0..d705c77 100644
>> >     >>                             --- a/fs/xfs/xfs_inode.c
>> >     >>                             +++ b/fs/xfs/xfs_inode.c
>> >     >>                             @@ -1615,6 +1615,8 @@ xfs_iunlink(
>> >     >>
>> >     >>                                     mp =3D tp->t_mountp;
>> >     >>
>> >     >>                             +       trace_xfs_iunlink(ip);
>> >     >>                             +
>> >     >>                                     /*
>> >     >>                                      * Get the agi buffer first=
.
>>  It
>> >     >>                             ensures lock ordering
>> >     >>                                      * on the list.
>> >     >>                             @@ -1694,6 +1696,8 @@
>> xfs_iunlink_remove(
>> >     >>                                     mp =3D tp->t_mountp;
>> >     >>                                     agno =3D XFS_INO_TO_AGNO(mp=
,
>> >     ip->i_ino);
>> >     >>
>> >     >>                             +       trace_xfs_iunlink_remove(ip=
);
>> >     >>                             +
>> >     >>                                     /*
>> >     >>                                      * Get the agi buffer first=
.
>>  It
>> >     >>                             ensures lock ordering
>> >     >>                                      * on the list.
>> >     >>                             --
>> >     >>                             1.7.7.6
>> >     >>
>> >     >>
>> >     >>
>> >     >>
>> >     >>                         --
>> >     >>                         =B7=FB=D3=C0=CC=CE
>> >     >>
>> >     >>
>> >     >>
>> >     >>
>> >     >>                     --
>> >     >>                     =B7=FB=D3=C0=CC=CE
>> >     >>
>> >     >>
>> >     >>
>> >     >>
>> >     >>                 --
>> >     >>                 =B7=FB=D3=C0=CC=CE
>> >     >>
>> >     >>
>> >     >>
>> >     >>
>> >     >>             --
>> >     >>             =B7=FB=D3=C0=CC=CE
>> >     >>             _______________________________________________
>> >     >>             xfs mailing list
>> >     >>             xfs@oss.sgi.com <mailto:xfs@oss.sgi.com>
>> >     <mailto:xfs@oss.sgi.com <mailto:xfs@oss.sgi.com>>
>> >     >>             http://oss.sgi.com/mailman/listinfo/xfs
>> >     >
>> >     >
>> >     >
>> >     >
>> >     >         --
>> >     >         =B7=FB=D3=C0=CC=CE
>> >     >
>> >     >
>> >     >
>> >     >
>> >     >     --
>> >     >     =B7=FB=D3=C0=CC=CE
>> >     >
>> >     >
>> >     >
>> >     >
>> >     > --
>> >     > =B7=FB=D3=C0=CC=CE
>> >
>> >
>> >
>> >
>> > --
>> > =B7=FB=D3=C0=CC=CE
>>
>>
>
>
> --
> =B7=FB=D3=C0=CC=CE
>



--=20
=B7=FB=D3=C0=CC=CE

--047d7bd75decdcf3dc04dab533c0
Content-Type: text/html; charset=GB2312
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div>Dear Brian and Eric,<br></div><br>kernel <a href=
=3D"http://mirror.linux.duke.edu/pub/centos/6.3/updates/x86_64/Packages/ker=
nel-2.6.32-279.19.1.el6.x86_64.rpm" target=3D"_blank">kernel-2.6.32-279.19.=
1.el6.x86_64.rpm</a> still have this problem<br>
</div><div>I build the kernel from this srpm <br></div><div><a href=3D"http=
s://oss.oracle.com/ol6/SRPMS-updates/kernel-2.6.32-279.19.1.el6.src.rpm">ht=
tps://oss.oracle.com/ol6/SRPMS-updates/kernel-2.6.32-279.19.1.el6.src.rpm</=
a><br>
<br></div><div>today the shutdown happens again during test. <br>Seelogs be=
llow:<br></div><br>/var/log/message<br><div><div>Apr 19 16:40:05 10 kernel:=
 XFS (sdb): xfs_iunlink_remove: xfs_inotobp() returned error 22.<br>Apr 19 =
16:40:05 10 kernel: XFS (sdb): xfs_inactive: xfs_ifree returned error 22<br=
>
Apr 19 16:40:05 10 kernel: XFS (sdb): xfs_do_force_shutdown(0x1) called fro=
m line 1184 of file fs/xfs/xfs_vnodeops.c.&nbsp; Return address =3D 0xfffff=
fffa02d4bda<br>Apr 19 16:40:05 10 kernel: XFS (sdb): I/O Error Detected. Sh=
utting down filesystem<br>
Apr 19 16:40:05 10 kernel: XFS (sdb): Please umount the filesystem and rect=
ify the problem(s)<br>Apr 19 16:40:07 10 kernel: XFS (sdb): xfs_log_force: =
error 5 returned.<br>Apr 19 16:40:37 10 kernel: XFS (sdb): xfs_log_force: e=
rror 5 returned.<br>
<br></div><div>systemtap script output:<br>--- xfs_imap -- module(&quot;xfs=
&quot;).function(&quot;xfs_imap@fs/xfs/xfs_ialloc.c:1257&quot;).return -- r=
eturn=3D0x16<br>vars: mp=3D0xffff88101801e800 tp=3D0xffff880ff143ac70 ino=
=3D0xffffffff imap=3D0xffff88100e93bc08 flags=3D0x0 agbno=3D? agino=3D? agn=
o=3D? blks_per_cluster=3D? chunk_agbno=3D? cluster_agbno=3D? error=3D? offs=
et=3D? offset_agbno=3D? __func__=3D[...]<br>
mp: m_agno_log =3D 0x5, m_agino_log =3D 0x20<br>mp-&gt;m_sb: sb_agcount =3D=
 0x1c, sb_agblocks =3D 0xffffff0, sb_inopblog =3D 0x4, sb_agblklog =3D 0x1c=
, sb_dblocks =3D 0x1b4900000<br>imap: im_blkno =3D 0x0, im_len =3D 0xe778, =
im_boffset =3D 0xd997<br>
kernel backtrace:<br>Returning from:&nbsp; 0xffffffffa02b4260 : xfs_imap+0x=
0/0x280 [xfs]<br>Returning to&nbsp; :&nbsp; 0xffffffffa02b9d59 : xfs_inotob=
p+0x49/0xc0 [xfs]<br>&nbsp;0xffffffffa02b9ec1 : xfs_iunlink_remove+0xf1/0x3=
60 [xfs]<br>&nbsp;0xffffffff814ede89<br>
&nbsp;0x0 (inexact)<br>user backtrace:<br>&nbsp;0x3ec260e5ad [/lib64/<a hre=
f=3D"http://libpthread-2.12.so">libpthread-2.12.so</a>+0xe5ad/0x219000]<br>=
<br>--- xfs_iunlink_remove -- module(&quot;xfs&quot;).function(&quot;xfs_iu=
nlink_remove@fs/xfs/xfs_inode.c:1681&quot;).return -- return=3D0x16<br>
vars: tp=3D0xffff880ff143ac70 ip=3D0xffff8811ed111000 next_ino=3D? mp=3D? a=
gi=3D? dip=3D? agibp=3D? ibp=3D? agno=3D? agino=3D? next_agino=3D? last_ibp=
=3D? last_dip=3D0xffff881000000001 bucket_index=3D? offset=3D? last_offset=
=3D0xffffffffffff8811 error=3D? __func__=3D[...]<br>
ip: i_ino =3D 0x1bd33, i_flags =3D 0x0<br>ip-&gt;i_d: di_nlink =3D 0x0, di_=
gen =3D 0x53068791<br><br></div><div>debugfs events trace:<br><a href=3D"ht=
tps://docs.google.com/file/d/0B7n2C4T5tfNCREZtdC1yamc0RnM/edit?usp=3Dsharin=
g">https://docs.google.com/file/d/0B7n2C4T5tfNCREZtdC1yamc0RnM/edit?usp=3Ds=
haring</a><br>
<br></div><div>xfs_metadump:<br><a href=3D"https://docs.google.com/file/d/0=
B7n2C4T5tfNCc2tiMjdhMTVfOWM/edit?usp=3Dsharing">https://docs.google.com/fil=
e/d/0B7n2C4T5tfNCc2tiMjdhMTVfOWM/edit?usp=3Dsharing</a><br></div><div><br><=
/div>
<div>again this happens exactly when glusterfs rebalance finishes on one of=
 the brick(this time it is current host)<br></div><div>glusterfs log:<br>[2=
013-04-19 16:40:03.835675] I [dht-common.c:2337:dht_setxattr] 0-testbug-dht=
: fixing the layout of /lib/kbd/consoletrans<br>
[2013-04-19 16:40:03.842024] I [dht-common.c:2337:dht_setxattr] 0-testbug-d=
ht: fixing the layout of /lib/kbd/consoletrans<br>[2013-04-19 16:40:03.8441=
20] I [dht-rebalance.c:1055:gf_defrag_migrate_data] 0-testbug-dht: migrate =
data called on /lib/kbd/consoletrans<br>
[2013-04-19 16:40:03.852926] I [dht-rebalance.c:1055:gf_defrag_migrate_data=
] 0-testbug-dht: migrate data called on /lib/kbd/consoletrans<br>[2013-04-1=
9 16:40:03.856602] I [dht-common.c:2337:dht_setxattr] 0-testbug-dht: fixing=
 the layout of /lib/kbd/consoletrans<br>
[2013-04-19 16:40:03.860231] I [dht-rebalance.c:1055:gf_defrag_migrate_data=
] 0-testbug-dht: migrate data called on /lib/kbd/consoletrans<br>[2013-04-1=
9 16:40:03.892069] I [dht-common.c:2337:dht_setxattr] 0-testbug-dht: fixing=
 the layout of /lib/alsa<br>
[2013-04-19 16:40:03.897155] I [dht-rebalance.c:1055:gf_defrag_migrate_data=
] 0-testbug-dht: migrate data called on /lib/alsa<br>[2013-04-19 16:40:03.8=
97582] I [dht-common.c:2337:dht_setxattr] 0-testbug-dht: fixing the layout =
of /lib/alsa<br>
[2013-04-19 16:40:03.901076] I [dht-rebalance.c:1055:gf_defrag_migrate_data=
] 0-testbug-dht: migrate data called on /lib/alsa<br>[2013-04-19 16:40:03.9=
03689] I [dht-common.c:2337:dht_setxattr] 0-testbug-dht: fixing the layout =
of /lib/alsa<br>
[2013-04-19 16:40:03.906643] I [dht-rebalance.c:1055:gf_defrag_migrate_data=
] 0-testbug-dht: migrate data called on /lib/alsa<br>[2013-04-19 16:40:03.9=
10744] I [dht-common.c:2337:dht_setxattr] 0-testbug-dht: fixing the layout =
of /lib/alsa/init<br>
[2013-04-19 16:40:03.913475] I [dht-rebalance.c:1055:gf_defrag_migrate_data=
] 0-testbug-dht: migrate data called on /lib/alsa/init<br>[2013-04-19 16:40=
:03.915424] I [dht-common.c:2337:dht_setxattr] 0-testbug-dht: fixing the la=
yout of /lib/alsa/init<br>
[2013-04-19 16:40:03.918699] I [dht-rebalance.c:1055:gf_defrag_migrate_data=
] 0-testbug-dht: migrate data called on /lib/alsa/init<br>[2013-04-19 16:40=
:03.920459] I [dht-common.c:2337:dht_setxattr] 0-testbug-dht: fixing the la=
yout of /lib/alsa/init<br>
[2013-04-19 16:40:03.922857] I [dht-rebalance.c:1055:gf_defrag_migrate_data=
] 0-testbug-dht: migrate data called on /lib/alsa/init<br>[2013-04-19 16:40=
:05.107663] I [dht-rebalance.c:1611:gf_defrag_status_get] 0-glusterfs: Reba=
lance is completed<br>
[2013-04-19 16:40:05.107770] I [dht-rebalance.c:1614:gf_defrag_status_get] =
0-glusterfs: Files migrated: 993, size: 16161958687, lookups: 190891, failu=
res: 8957<br>[2013-04-19 16:40:05.108628] W [glusterfsd.c:831:cleanup_and_e=
xit] (--&gt;/lib64/libc.so.6(clone+0x6d) [0x3ec22e767d] (--&gt;/lib64/libpt=
hread.so.0() [0x3ec2607851] (--&gt;/usr/sbin/glusterfs(glusterfs_sigwaiter+=
0xdd) [0x405c9d]))) 0-: received signum (15), shutting down<br>
[2013-04-19 16:40:05.109007] E [rpcsvc.c:1155:rpcsvc_program_unregister_por=
tmap] 0-rpc-service: Could not unregister with portmap<br><br></div></div><=
/div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">2013/4/1=
9 =B7=FB=D3=C0=CC=CE <span dir=3D"ltr">&lt;<a href=3D"mailto:yongtaofu@gmai=
l.com" target=3D"_blank">yongtaofu@gmail.com</a>&gt;</span><br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div dir=3D"ltr"><div><div>Hi Brian and Eric=
,<br><br></div>I have applied your kernel path v2(add unlink trace) to <a h=
ref=3D"http://mirror.linux.duke.edu/pub/centos/6.3/updates/x86_64/Packages/=
kernel-2.6.32-279.19.1.el6.x86_64.rpm" target=3D"_blank">kernel-2.6.32-279.=
19.1.el6.x86_64.rpm</a> in out test cluster and start testing again.<br>

</div>Any progress will let you known. Thank you.<br></div><div class=3D"gm=
ail_extra"><div><div class=3D"h5"><br><br><div class=3D"gmail_quote">2013/4=
/19 Brian Foster <span dir=3D"ltr">&lt;<a href=3D"mailto:bfoster@redhat.com=
" target=3D"_blank">bfoster@redhat.com</a>&gt;</span><br>

<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div>On 04/18/2013 11:23 AM, =B7=FB=D3=C0=CC=
=CE wrote:<br>
&gt; Hi Brian and Eric,<br>
</div><div>&gt; The shutdown is not easy to produce but finally right now 2=
 of our<br>
&gt; servers in our test cluster xfs was shutdown.<br>
&gt;<br>
<br>
</div>Understood. We&#39;ve been trying very hard to reproduce ourselves to=
 make<br>
it easier to debug, but haven&#39;t been able to reproduce at all so far.<b=
r>
This process allows us to make _some_ progress on the issue, even if it<br>
is slower going than we&#39;d like... ;)<br>
<div><br>
&gt; the trace output as following<br>
&gt; <a href=3D"https://docs.google.com/file/d/0B7n2C4T5tfNCLXRYUWJ0b19JcWc=
/edit?usp=3Dsharing" target=3D"_blank">https://docs.google.com/file/d/0B7n2=
C4T5tfNCLXRYUWJ0b19JcWc/edit?usp=3Dsharing</a><br>
&gt;<br>
<br>
</div>Thanks again for the data. The racing behavior Eric called out (nice<=
br>
catch!) in his last mail lit up some light bulbs internally with regard<br>
to some old locking issues triggered by XFS in the 6.3 kernel. The<br>
following bug serves as an example:<br>
<br>
<a href=3D"https://bugzilla.redhat.com/show_bug.cgi?id=3D852847" target=3D"=
_blank">https://bugzilla.redhat.com/show_bug.cgi?id=3D852847</a><br>
<br>
... the fix for which went into the 2.6.32-279.19.1 6.3.z release. Could<br=
>
you move some or all of your servers to this kernel[1] and see how it<br>
goes? The best case is it resolves the problem, worst case we carry on<br>
debugging from there...<br>
<br>
Brian<br>
<br>
[1] -<br>
<a href=3D"http://mirror.linux.duke.edu/pub/centos/6.3/updates/x86_64/Packa=
ges/kernel-2.6.32-279.19.1.el6.x86_64.rpm" target=3D"_blank">http://mirror.=
linux.duke.edu/pub/centos/6.3/updates/x86_64/Packages/kernel-2.6.32-279.19.=
1.el6.x86_64.rpm</a><br>


<div><br>
&gt; Sorry but the systemtap is interrupt and I didn&#39;t noticed that so =
I<br>
&gt; didn&#39;t get systemtap logs.<br>
&gt;<br>
&gt; /var/log/message is same as before<br>
&gt; Apr 18 22:43:14 10 kernel: XFS (sdb): xfs_iunlink_remove: xfs_inotobp(=
)<br>
&gt; returned error 22.<br>
&gt; Apr 18 22:43:14 10 kernel: XFS (sdb): xfs_inactive: xfs_ifree returned=
<br>
&gt; error 22<br>
&gt; Apr 18 22:43:14 10 kernel: XFS (sdb): xfs_do_force_shutdown(0x1) calle=
d<br>
&gt; from line 1184 of file fs/xfs/xfs_vnodeops.c. &nbsp;Return address =3D=
<br>
&gt; 0xffffffffa02d44aa<br>
&gt; Apr 18 22:43:14 10 kernel: XFS (sdb): I/O Error Detected. Shutting dow=
n<br>
&gt; filesystem<br>
&gt; Apr 18 22:43:14 10 kernel: XFS (sdb): Please umount the filesystem and=
<br>
&gt; rectify the problem(s)<br>
&gt; Apr 18 22:43:20 10 kernel: XFS (sdb): xfs_log_force: error 5 returned.=
<br>
&gt;<br>
&gt; The metadump file is large I&#39;ll share it to you soon.<br>
&gt;<br>
&gt;<br>
</div>&gt; 2013/4/18 Brian Foster &lt;<a href=3D"mailto:bfoster@redhat.com"=
 target=3D"_blank">bfoster@redhat.com</a> &lt;mailto:<a href=3D"mailto:bfos=
ter@redhat.com" target=3D"_blank">bfoster@redhat.com</a>&gt;&gt;<br>
<div><div>&gt;<br>
&gt; &nbsp; &nbsp; On 04/18/2013 04:25 AM, =B7=FB=D3=C0=CC=CE wrote:<br>
&gt; &nbsp; &nbsp; &gt; Hi Brian and Eric,<br>
&gt; &nbsp; &nbsp; &gt; Can I change as following to bypass it?<br>
&gt;<br>
&gt; &nbsp; &nbsp; This is probably not a wise thing to do. The problem we&=
#39;re seeing here<br>
&gt; &nbsp; &nbsp; is indicative of a potentially larger problem than this =
particular error<br>
&gt; &nbsp; &nbsp; path. An inode is being unlinked and inactivated, but we=
 aren&#39;t finding<br>
&gt; &nbsp; &nbsp; on the list where we expect it to be. Killing the error =
return doesn&#39;t<br>
&gt; &nbsp; &nbsp; eliminate the larger problem.<br>
&gt;<br>
&gt; &nbsp; &nbsp; So while changes could end up being made in this area as=
 part of a fix,<br>
&gt; &nbsp; &nbsp; I would not suggest making any changes beyond those desi=
gned to help<br>
&gt; &nbsp; &nbsp; debug until we have a better idea of root cause.<br>
&gt;<br>
&gt; &nbsp; &nbsp; Brian<br>
&gt;<br>
&gt; &nbsp; &nbsp; &gt; --- a/xfs_inode.c<br>
&gt; &nbsp; &nbsp; &gt; +++ b/xfs_inode.c<br>
&gt; &nbsp; &nbsp; &gt; @@ -1764,7 +1764,7 @@ xfs_iunlink_remove(<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp;*/<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; next_agino =3D<br>
&gt; &nbsp; &nbsp; be32_to_cpu(agi-&gt;agi_unlinked[bucket_index]);<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; last_ibp =3D NULL;<br>
&gt; &nbsp; &nbsp; &gt; - &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
while (next_agino !=3D agino) {<br>
&gt; &nbsp; &nbsp; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
while (next_agino !=3D agino &amp;&amp; next_agino !=3D<br>
&gt; &nbsp; &nbsp; NULLAGINO) {<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; /*<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;* If the last inode wasn&#39;t the o=
ne<br>
&gt; &nbsp; &nbsp; pointing to<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;* us, then release its buffer since =
we&#39;re not<br>
&gt; &nbsp; &nbsp; &gt; @@ -1786,6 +1786,14 @@ xfs_iunlink_remove(<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; ASSERT(next_agino !=3D NULLAGINO);<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; ASSERT(next_agino !=3D 0);<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; }<br>
&gt; &nbsp; &nbsp; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
if (next_agino =3D=3D NULLAGINO) {<br>
&gt; &nbsp; &nbsp; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; /*<br>
&gt; &nbsp; &nbsp; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;*After search the list for the inode<br>
&gt; &nbsp; &nbsp; being free<br>
&gt; &nbsp; &nbsp; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;*we still can&#39;t find it.<br>
&gt; &nbsp; &nbsp; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;*/<br>
&gt; &nbsp; &nbsp; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; xfs_err(mp, &quot;%s ino %lld not found in unli=
nked<br>
&gt; &nbsp; &nbsp; &gt; list.&quot;,<br>
&gt; &nbsp; &nbsp; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
;__func__, (unsigned long<br>
&gt; &nbsp; &nbsp; &gt; long)ip-&gt;i_ino);<br>
&gt; &nbsp; &nbsp; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
}<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; /*<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp;* Now last_ibp points to the buffer previous to us on<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp;* the unlinked list. &nbsp;Pull us from the list.<br>
&gt; &nbsp; &nbsp; &gt; @@ -1810,16 +1818,20 @@ xfs_iunlink_remove(<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; } else {<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; xfs_trans_brelse(tp, ibp);<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; }<br>
&gt; &nbsp; &nbsp; &gt; - &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
/*<br>
&gt; &nbsp; &nbsp; &gt; - &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp;* Point the previous inode on the list to the<br>
&gt; &nbsp; &nbsp; next inode.<br>
&gt; &nbsp; &nbsp; &gt; - &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp;*/<br>
&gt; &nbsp; &nbsp; &gt; - &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
last_dip-&gt;di_next_unlinked =3D cpu_to_be32(next_agino);<br>
&gt; &nbsp; &nbsp; &gt; - &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
ASSERT(next_agino !=3D 0);<br>
&gt; &nbsp; &nbsp; &gt; - &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
offset =3D last_offset + offsetof(xfs_dinode_t,<br>
&gt; &nbsp; &nbsp; &gt; di_next_unlinked);<br>
&gt; &nbsp; &nbsp; &gt; - &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
xfs_trans_inode_buf(tp, last_ibp);<br>
&gt; &nbsp; &nbsp; &gt; - &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
xfs_trans_log_buf(tp, last_ibp, offset,<br>
&gt; &nbsp; &nbsp; &gt; - &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; (offset + si=
zeof(xfs_agino_t) - 1));<br>
&gt; &nbsp; &nbsp; &gt; - &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
xfs_inobp_check(mp, last_ibp);<br>
&gt; &nbsp; &nbsp; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
if (next_agino !=3D NULLAGINO) {<br>
&gt; &nbsp; &nbsp; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; /*<br>
&gt; &nbsp; &nbsp; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; * If only find the inode being free then<br>
&gt; &nbsp; &nbsp; we modify<br>
&gt; &nbsp; &nbsp; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; * the unlinked list.<br>
&gt; &nbsp; &nbsp; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; * Point the previous inode on the list to the<b=
r>
&gt; &nbsp; &nbsp; &gt; next inode.<br>
&gt; &nbsp; &nbsp; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; */<br>
&gt; &nbsp; &nbsp; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; last_dip-&gt;di_next_unlinked =3D<br>
&gt; &nbsp; &nbsp; &gt; cpu_to_be32(next_agino);<br>
&gt; &nbsp; &nbsp; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; ASSERT(next_agino !=3D 0);<br>
&gt; &nbsp; &nbsp; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; offset =3D last_offset + offsetof(xfs_dinode_t,=
<br>
&gt; &nbsp; &nbsp; &gt; di_next_unlinked);<br>
&gt; &nbsp; &nbsp; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; xfs_trans_inode_buf(tp, last_ibp);<br>
&gt; &nbsp; &nbsp; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; xfs_trans_log_buf(tp, last_ibp, offset,<br>
&gt; &nbsp; &nbsp; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; (offset +<br>
&gt; &nbsp; &nbsp; sizeof(xfs_agino_t)<br>
&gt; &nbsp; &nbsp; &gt; - 1));<br>
&gt; &nbsp; &nbsp; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; xfs_inobp_check(mp, last_ibp);<br>
&gt; &nbsp; &nbsp; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
}<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; }<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; return 0;<br>
&gt; &nbsp; &nbsp; &gt; &nbsp;}<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt; Thank you.<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt; 2013/4/18 =B7=FB=D3=C0=CC=CE &lt;<a href=3D"mailto:=
yongtaofu@gmail.com" target=3D"_blank">yongtaofu@gmail.com</a> &lt;mailto:<=
a href=3D"mailto:yongtaofu@gmail.com" target=3D"_blank">yongtaofu@gmail.com=
</a>&gt;<br>
</div></div>&gt; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:yongtaofu@gmail=
.com" target=3D"_blank">yongtaofu@gmail.com</a> &lt;mailto:<a href=3D"mailt=
o:yongtaofu@gmail.com" target=3D"_blank">yongtaofu@gmail.com</a>&gt;&gt;&gt=
;<br>
<div>&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; Hi Brain and Eric,<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; If the problem is the agno can&#39;t =
be found in the unlinked<br>
&gt; &nbsp; &nbsp; list. Can<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; we just bypass it instead of passing =
ino=3D0xffffffff to<br>
&gt; &nbsp; &nbsp; xfs_inotobp?<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; Thank you.<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; 2013/4/18 =B7=FB=D3=C0=CC=CE &lt;<a h=
ref=3D"mailto:yongtaofu@gmail.com" target=3D"_blank">yongtaofu@gmail.com</a=
><br>
</div>&gt; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:yongtaofu@gmail.com" =
target=3D"_blank">yongtaofu@gmail.com</a>&gt; &lt;mailto:<a href=3D"mailto:=
yongtaofu@gmail.com" target=3D"_blank">yongtaofu@gmail.com</a><br>
<div><div>&gt; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:yongtaofu@gmail.c=
om" target=3D"_blank">yongtaofu@gmail.com</a>&gt;&gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Hi Eric,<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; The shutdown issue is s=
till not reproduced yet. But I get the<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; following error today d=
uring test.<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kern=
el: Call Trace:<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kern=
el: [&lt;ffffffffa02d91ef&gt;] ?<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; xfs_buf_cond_lock+0x2f/=
0xc0 [xfs]<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kern=
el: [&lt;ffffffff814fe6a5&gt;]<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; schedule_timeout+0x215/=
0x2e0<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kern=
el: [&lt;ffffffffa02d5f07&gt;] ?<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; kmem_zone_alloc+0x77/0x=
f0 [xfs]<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kern=
el: [&lt;ffffffff814ff5c2&gt;]<br>
&gt; &nbsp; &nbsp; __down+0x72/0xb0<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kern=
el: [&lt;ffffffffa02da652&gt;] ?<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; _xfs_buf_find+0x102/0x2=
80 [xfs]<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kern=
el: &quot;echo 0 &gt;<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; /proc/sys/kernel/hung_t=
ask_timeout_secs&quot; disables this<br>
&gt; &nbsp; &nbsp; message.<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kern=
el: glusterfsd &nbsp; &nbsp;D ffffffff8160b3c0<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; 0 14522 &nbsp; &nbsp; &=
nbsp;1 0x00000083<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kern=
el: ffff882015a63a28 0000000000000082<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; 0000000000000000 000000=
0000000000<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kern=
el: ffff882015a639b8 ffffffffa02d91ef<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; ffff882015a639d8 000000=
0000000246<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kern=
el: ffff880e70491af8 ffff882015a63fd8<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; 000000000000fb88 ffff88=
0e70491af8<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kern=
el: Call Trace:<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kern=
el: [&lt;ffffffffa02d91ef&gt;] ?<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; xfs_buf_cond_lock+0x2f/=
0xc0 [xfs]<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kern=
el: [&lt;ffffffff814fe6a5&gt;]<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; schedule_timeout+0x215/=
0x2e0<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kern=
el: [&lt;ffffffffa02d5f07&gt;] ?<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; kmem_zone_alloc+0x77/0x=
f0 [xfs]<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kern=
el: [&lt;ffffffff814ff5c2&gt;]<br>
&gt; &nbsp; &nbsp; __down+0x72/0xb0<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kern=
el: [&lt;ffffffffa02da652&gt;] ?<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; _xfs_buf_find+0x102/0x2=
80 [xfs]<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kern=
el: [&lt;ffffffff81097ef1&gt;] down+0x41/0x50<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kern=
el: [&lt;ffffffffa02da493&gt;]<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; xfs_buf_lock+0x53/0x110=
 [xfs]<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kern=
el: [&lt;ffffffffa02da652&gt;]<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; _xfs_buf_find+0x102/0x2=
80 [xfs]<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kern=
el: [&lt;ffffffffa02da83b&gt;]<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; xfs_buf_get+0x6b/0x1a0 =
[xfs]<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kern=
el: [&lt;ffffffffa02daeac&gt;]<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; xfs_buf_read+0x2c/0x100=
 [xfs]<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kern=
el: [&lt;ffffffffa02d0af8&gt;]<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; xfs_trans_read_buf+0x1f=
8/0x400 [xfs]<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kern=
el: [&lt;ffffffffa02b3444&gt;]<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; xfs_read_agi+0x74/0x100=
 [xfs]<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kern=
el: [&lt;ffffffffa02b967b&gt;]<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; xfs_iunlink+0x5b/0x180 =
[xfs]<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kern=
el: [&lt;ffffffff810724c7&gt;] ?<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; current_fs_time+0x27/0x=
30<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kern=
el: [&lt;ffffffffa02d12a7&gt;] ?<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; xfs_trans_ichgtime+0x27=
/0xa0 [xfs]<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kern=
el: [&lt;ffffffffa02d15fb&gt;]<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; xfs_droplink+0x5b/0x70 =
[xfs]<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kern=
el: [&lt;ffffffffa02d2f9e&gt;]<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; xfs_remove+0x27e/0x3a0 =
[xfs]<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kern=
el: [&lt;ffffffff81186fd3&gt;] ?<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; generic_permission+0x23=
/0xb0<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kern=
el: [&lt;ffffffffa02e0968&gt;]<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; xfs_vn_unlink+0x48/0x90=
 [xfs]<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kern=
el: [&lt;ffffffff81188c0f&gt;]<br>
&gt; &nbsp; &nbsp; vfs_unlink+0x9f/0xe0<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kern=
el: [&lt;ffffffff8118795a&gt;] ?<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; lookup_hash+0x3a/0x50<b=
r>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kern=
el: [&lt;ffffffff8118b143&gt;]<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; do_unlinkat+0x183/0x1c0=
<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kern=
el: [&lt;ffffffff81017938&gt;] ?<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; syscall_trace_enter+0x1=
d8/0x1e0<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kern=
el: [&lt;ffffffff8118b196&gt;]<br>
&gt; &nbsp; &nbsp; sys_unlink+0x16/0x20<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kern=
el: [&lt;ffffffff8100b308&gt;]<br>
&gt; &nbsp; &nbsp; tracesys+0xd9/0xde<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Thank you.<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; 2013/4/17 Eric Sandeen =
&lt;<a href=3D"mailto:sandeen@sandeen.net" target=3D"_blank">sandeen@sandee=
n.net</a><br>
&gt; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:sandeen@sandeen.net" target=
=3D"_blank">sandeen@sandeen.net</a>&gt;<br>
</div></div>&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &lt;mailto:=
<a href=3D"mailto:sandeen@sandeen.net" target=3D"_blank">sandeen@sandeen.ne=
t</a> &lt;mailto:<a href=3D"mailto:sandeen@sandeen.net" target=3D"_blank">s=
andeen@sandeen.net</a>&gt;&gt;&gt;<br>

<div>&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; On Apr 16=
, 2013, at 8:48 PM, =B7=FB=D3=C0=CC=CE<br>
&gt; &nbsp; &nbsp; &lt;<a href=3D"mailto:yongtaofu@gmail.com" target=3D"_bl=
ank">yongtaofu@gmail.com</a> &lt;mailto:<a href=3D"mailto:yongtaofu@gmail.c=
om" target=3D"_blank">yongtaofu@gmail.com</a>&gt;<br>
</div>&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &lt=
;mailto:<a href=3D"mailto:yongtaofu@gmail.com" target=3D"_blank">yongtaofu@=
gmail.com</a><br>
<div><div>&gt; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:yongtaofu@gmail.c=
om" target=3D"_blank">yongtaofu@gmail.com</a>&gt;&gt;&gt; wrote:<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Hi Br=
ain,<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Can I=
 change as following?<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ASSERTS a=
re no-ops in a non-debug kernel, so this won&#39;t<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; change an=
y behavior. &nbsp;I hope we&#39;ll know more if we get new<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; traces fr=
om your patched kernel....<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Eric<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; --- a=
/xfs_inode.c<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; +++ b=
/xfs_inode.c<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; @@ -1=
773,6 +1773,8 @@ xfs_iunlink_remove(<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; if (last_ibp !=3D NULL) {<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; xfs_trans_brelse(tp,<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; last_=
ibp);<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; }<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; + &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp;ASSERT(next_agino !=3D NULLAGINO);<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; + &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp;ASSERT(next_agino !=3D 0);<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; next_ino =3D XFS_AGINO_TO_INO(mp,<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; agno,=
 next_agino);<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; error =3D xfs_inotobp(mp, tp,<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; next_=
ino, &amp;last_dip,<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
amp;last_ibp,<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &amp;=
last_offset, 0);<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; @@ -1=
783,8 +1785,6 @@ xfs_iunlink_remove(<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; return error;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; }<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; next_agino =3D<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; be32_=
to_cpu(last_dip-&gt;di_next_unlinked);<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; - &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; A=
SSERT(next_agino !=3D NULLAGINO);<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; - &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; A=
SSERT(next_agino !=3D 0);<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; /*<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;* Now last_ibp poi=
nts to the buffer<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; previ=
ous to us on<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Thank=
 you.<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 2013/=
4/17 =B7=FB=D3=C0=CC=CE &lt;<a href=3D"mailto:yongtaofu@gmail.com" target=
=3D"_blank">yongtaofu@gmail.com</a><br>
&gt; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:yongtaofu@gmail.com" target=
=3D"_blank">yongtaofu@gmail.com</a>&gt;<br>
</div></div>&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &lt;mailto:<a href=3D"mailto:yongtaofu@gmail.com" target=3D"_blank">=
yongtaofu@gmail.com</a><br>
<div><div>&gt; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:yongtaofu@gmail.c=
om" target=3D"_blank">yongtaofu@gmail.com</a>&gt;&gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; Hi Brain,<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; If it is because NULLAGINO is passed in &nbsp;to<br>
&gt; &nbsp; &nbsp; xfs_inotobp().<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; Can I move the following two lines before<br>
&gt; &nbsp; &nbsp; xfs_inotobp?<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; For example:<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; 1767 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; while=
 (next_agino !=3D agino) {<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; 1768 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; /*<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; 1769 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp;* If the last inode<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; wasn&#39;t the one pointing to<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; 1770 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp;* us, then release its<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; buffer since we&#39;re not<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; 1771 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp;* going to do anything<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; with it.<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; 1772 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp;*/<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; 1773 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; if (last_ibp !=3D NULL) {<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; 1774<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; xfs_trans_brelse(tp, last_ibp);<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; 1775 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; }<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; 1776 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; next_ino =3D<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; XFS_AGINO_TO_INO(mp, agno, next_agino);<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ASSERT(next_agino !=3D<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; NULLAGINO);<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ASSERT(next_agino<br>
&gt; &nbsp; &nbsp; !=3D 0);<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; 1777 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; error =3D xfs_inotobp(mp,<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; tp, next_ino, &amp;last_dip,<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; 1778<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &amp;last_ibp, &amp;last_offset, 0);<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; 1779 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; if (error) {<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; 1780 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; xfs_warn(mp,<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; 1781 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &quot;%s:<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; xfs_inotobp() returned error %d.&quot;,<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; 1782<br>
&gt; &nbsp; &nbsp; __func__,<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; error);<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; 1783 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; return error;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; 1784 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; }<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; 1785 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; next_agino =3D<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; be32_to_cpu(last_dip-&gt;di_next_unlinked);<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; -<br>
&gt; &nbsp; &nbsp; //ASSERT(next_agino !=3D<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; NULLAGINO);<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; -<br>
&gt; &nbsp; &nbsp; //ASSERT(next_agino !=3D 0);<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; 1788 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; I don&#39;t understand xfs well and correct me if I&#39;m<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; totally wrong.<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; Thank you very much.<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; 2013/4/17 =B7=FB=D3=C0=CC=CE &lt;<a href=3D"mailto:yongtaofu@gmail=
.com" target=3D"_blank">yongtaofu@gmail.com</a><br>
&gt; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:yongtaofu@gmail.com" target=
=3D"_blank">yongtaofu@gmail.com</a>&gt;<br>
</div></div>&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:yongtaofu@gmail.com" targ=
et=3D"_blank">yongtaofu@gmail.com</a><br>
<div>&gt; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:yongtaofu@gmail.com" t=
arget=3D"_blank">yongtaofu@gmail.com</a>&gt;&gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; Hi Brain,<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; I want to ask a question, according to the<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; shutdown trace. The ino in &nbsp;xfs_iunlink_remove<=
br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; is 0x113, why xfs_imap got ino=3D0xffffffff ?<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; --- xfs_imap --<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; module(&quot;xfs&quot;).function(&quot;xfs_imap@fs/xfs/x=
fs_ialloc.c:1257&quot;).return<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; -- return=3D0x16<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; vars: mp=3D0xffff882017a50800 tp=3D0xffff881c81797c7=
0<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; ino=3D0xffffffff<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; --- xfs_iunlink_remove --<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; module(&quot;xfs&quot;).function(&quot;xfs_iunlink_remov=
e@fs/xfs/xfs_inode.c:1680&quot;).return<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; -- return=3D0x16<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; vars: tp=3D0xffff881c81797c70 ip=3D0xffff881003c13c0=
0<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; next_ino=3D? mp=3D? agi=3D? dip=3D?<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; agibp=3D0xffff880109b47e20 ibp=3D? agno=3D? agino=3D=
?<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; next_agino=3D? last_ibp=3D?<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; last_dip=3D0xffff882000000000 bucket_index=3D?<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; offset=3D? last_offset=3D0xffffffffffff8810 error=3D=
?<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; __func__=3D[...]<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; ip: i_ino =3D 0x113, i_flags =3D 0x0<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; Thank you.<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; 2013/4/17 =B7=FB=D3=C0=CC=CE &lt;<a href=3D"mailto:y=
ongtaofu@gmail.com" target=3D"_blank">yongtaofu@gmail.com</a><br>
&gt; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:yongtaofu@gmail.com" target=
=3D"_blank">yongtaofu@gmail.com</a>&gt;<br>
</div>&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:yongtaofu@gmail.c=
om" target=3D"_blank">yongtaofu@gmail.com</a><br>
<div>&gt; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:yongtaofu@gmail.com" t=
arget=3D"_blank">yongtaofu@gmail.com</a>&gt;&gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Hi Brain,<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Thank you for your update, and I have =
applied<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; your last kernel patch. However it is =
not<br>
&gt; &nbsp; &nbsp; easy<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; to reproduce especially in out test<br=
>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; environment. Till now is not happens a=
gain.<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; I&#39;ll update the kernel patch now. =
BTW is<br>
&gt; &nbsp; &nbsp; there<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; any findings in the logs of previous t=
hread?<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; <a href=3D"http://oss.sgi.com/archives/xfs/2013-04/msg00=
327.html" target=3D"_blank">http://oss.sgi.com/archives/xfs/2013-04/msg0032=
7.html</a><br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; I guess it tend to happen during glust=
erfs<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; rebalance because glusterfs moves a lo=
t of<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; file from one server to another and th=
en<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; unlink it.<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Thank you.<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 2013/4/17 Brian Foster<br>
&gt; &nbsp; &nbsp; &lt;<a href=3D"mailto:bfoster@redhat.com" target=3D"_bla=
nk">bfoster@redhat.com</a> &lt;mailto:<a href=3D"mailto:bfoster@redhat.com"=
 target=3D"_blank">bfoster@redhat.com</a>&gt;<br>
</div>&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:bfo=
ster@redhat.com" target=3D"_blank">bfoster@redhat.com</a><br>
<div><div>&gt; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:bfoster@redhat.co=
m" target=3D"_blank">bfoster@redhat.com</a>&gt;&gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; On 04/16/2013 12:24 PM, =
Dave Chinner<br>
&gt; &nbsp; &nbsp; wrote:<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; On Mon, Apr 15, 201=
3 at 07:14:39PM<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; -0400, Brian Foster wrot=
e:<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; Hi,<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; Thanks for the =
data in the<br>
&gt; &nbsp; &nbsp; previous thread:<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; <a href=3D"http://oss.sgi.com/archives/xfs/2013-04/msg00=
327.html" target=3D"_blank">http://oss.sgi.com/archives/xfs/2013-04/msg0032=
7.html</a><br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ...<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &=
nbsp;echo 1 &gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; /sys/kernel/debug/tracing/events/xfs/xfs_iunlink/enable<=
br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &=
nbsp;echo 1 &gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; /sys/kernel/debug/tracing/events/xfs/xfs_iunlink_remove/=
enable<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &=
nbsp;... reproduce ...<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &=
nbsp;cat<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; /sys/kernel/debug/tracin=
g/trace &gt;<br>
&gt; &nbsp; &nbsp; trace.output<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; It&#39;s better to =
use trace-cmd for this.<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; it will result in less<b=
r>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; dropped events. i.e=
.:<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp=
; $ trace-cmd record -e<br>
&gt; &nbsp; &nbsp; xfs_iunlink\*<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp=
; ... reproduce ...<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp=
; ^C<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp=
; $ trace-cmd report &gt; trace.output<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; --- a/fs/xfs/li=
nux-2.6/xfs_trace.h<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; +++ b/fs/xfs/li=
nux-2.6/xfs_trace.h<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; @@ -581,6 +581,=
8 @@<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; DEFINE_INODE_EVENT(xfs_f=
ile_fsync);<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ...<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; I would suggest tha=
t the the tracing<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; shoul dbe at entry of th=
e<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; function, otherwise=
 we won&#39;t get a<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; tracepoint for the opera=
tion that<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; triggers the shutdo=
wn. (That&#39;s the<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; reason most tracepoints =
in XFS<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; are at function ent=
ry...)<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Good points, thanks Dave=
. A v2 that pulls<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; up the tracepoints towar=
ds<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; function entry is append=
ed.<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Brian<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; From<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 280943e78ebe0b97a774cba5=
1e7815c42f044b55<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Mon Sep 17 00:00:00 2001=
<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; From: Brian Foster<br>
&gt; &nbsp; &nbsp; &lt;<a href=3D"mailto:bfoster@redhat.com" target=3D"_bla=
nk">bfoster@redhat.com</a> &lt;mailto:<a href=3D"mailto:bfoster@redhat.com"=
 target=3D"_blank">bfoster@redhat.com</a>&gt;<br>
</div></div>&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &lt;mailto:<=
a href=3D"mailto:bfoster@redhat.com" target=3D"_blank">bfoster@redhat.com</=
a><br>
<div><div>&gt; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:bfoster@redhat.co=
m" target=3D"_blank">bfoster@redhat.com</a>&gt;&gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Date: Mon, 15 Apr 2013 1=
8:16:24 -0400<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Subject: [PATCH v2] xfs:=
 add tracepoints<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; for xfs_iunlink and<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; xfs_iunlink_remove<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ---<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;fs/xfs/linux-2.6/x=
fs_trace.h | &nbsp; &nbsp;2 ++<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;fs/xfs/xfs_inode.c=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; | &nbsp; &nbsp;4 ++++<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;2 files changed, 6=
 insertions(+), 0<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; deletions(-)<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; diff --git a/fs/xfs/linu=
x-2.6/xfs_trace.h<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; b/fs/xfs/linux-2.6/xfs_t=
race.h<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; index adc6ec4..338a0f9 1=
00644<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; --- a/fs/xfs/linux-2.6/x=
fs_trace.h<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; +++ b/fs/xfs/linux-2.6/x=
fs_trace.h<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; @@ -583,6 +583,8 @@<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; DEFINE_INODE_EVENT(xfs_f=
ile_fsync);<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;DEFINE_INODE_EVENT=
(xfs_destroy_inode);<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;DEFINE_INODE_EVENT=
(xfs_dirty_inode);<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;DEFINE_INODE_EVENT=
(xfs_clear_inode);<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; +DEFINE_INODE_EVENT(xfs_=
iunlink);<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; +DEFINE_INODE_EVENT(xfs_=
iunlink_remove);<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;DEFINE_INODE_EVENT=
(xfs_dquot_dqalloc);<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;DEFINE_INODE_EVENT=
(xfs_dquot_dqdetach);<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; diff --git a/fs/xfs/xfs_=
inode.c<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; b/fs/xfs/xfs_inode.c<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; index 19900f0..d705c77 1=
00644<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; --- a/fs/xfs/xfs_inode.c=
<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; +++ b/fs/xfs/xfs_inode.c=
<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; @@ -1615,6 +1615,8 @@ xf=
s_iunlink(<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; mp =3D tp-&gt;t_mountp;<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; t=
race_xfs_iunlink(ip);<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; +<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; /*<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp;* Get the agi buffer first. &nbsp;It<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ensures lock ordering<br=
>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp;* on the list.<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; @@ -1694,6 +1696,8 @@ xf=
s_iunlink_remove(<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; mp =3D tp-&gt;t_mountp;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; agno =3D XFS_INO_TO_AGNO(mp,<br>
&gt; &nbsp; &nbsp; ip-&gt;i_ino);<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; t=
race_xfs_iunlink_remove(ip);<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; +<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; /*<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp;* Get the agi buffer first. &nbsp;It<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ensures lock ordering<br=
>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp;* on the list.<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; --<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1.7.7.6<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; --<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =B7=FB=D3=C0=CC=CE<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; --<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; =B7=FB=D3=C0=CC=CE<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; --<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; =B7=FB=D3=C0=CC=CE<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; --<br=
>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =B7=
=FB=D3=C0=CC=CE<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; _____=
__________________________________________<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; xfs m=
ailing list<br>
&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <a hr=
ef=3D"mailto:xfs@oss.sgi.com" target=3D"_blank">xfs@oss.sgi.com</a> &lt;mai=
lto:<a href=3D"mailto:xfs@oss.sgi.com" target=3D"_blank">xfs@oss.sgi.com</a=
>&gt;<br>
</div></div>&gt; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:xfs@oss.sgi.com=
" target=3D"_blank">xfs@oss.sgi.com</a> &lt;mailto:<a href=3D"mailto:xfs@os=
s.sgi.com" target=3D"_blank">xfs@oss.sgi.com</a>&gt;&gt;<br>
<div><div>&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">=
http://oss.sgi.com/mailman/listinfo/xfs</a><br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; --<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; =B7=FB=D3=C0=CC=CE<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; --<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; =B7=FB=D3=C0=CC=CE<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt; --<br>
&gt; &nbsp; &nbsp; &gt; =B7=FB=D3=C0=CC=CE<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; --<br>
&gt; =B7=FB=D3=C0=CC=CE<br>
<br>
</div></div></blockquote></div><br><br clear=3D"all"><br></div></div><span =
class=3D"HOEnZb"><font color=3D"#888888">-- <br>=B7=FB=D3=C0=CC=CE
</font></span></div>
</blockquote></div><br><br clear=3D"all"><br>-- <br>=B7=FB=D3=C0=CC=CE
</div>

--047d7bd75decdcf3dc04dab533c0--


--===============2555477095096314217==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2555477095096314217==--
