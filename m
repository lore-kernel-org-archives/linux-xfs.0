Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B748C7F5A
	for <xfs@oss.sgi.com>; Thu, 18 Apr 2013 11:41:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8FBD28F8050
	for <xfs@oss.sgi.com>; Thu, 18 Apr 2013 09:41:00 -0700 (PDT)
Received: from mail-vc0-f181.google.com (mail-vc0-f181.google.com
	[209.85.220.181]) by cuda.sgi.com with ESMTP id
	Oz7q5vdtUlzcy054 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 18 Apr 2013 09:40:57 -0700 (PDT)
Received: by mail-vc0-f181.google.com with SMTP id ia10so2784784vcb.12
	for <xfs@oss.sgi.com>; Thu, 18 Apr 2013 09:40:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADFMGuJ-An9MMmYtOKEjt5JdHmvu-cc0G+y361e_fioYf4j7HQ@mail.gmail.com>
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
Date: Fri, 19 Apr 2013 00:40:56 +0800
Message-ID: <CADFMGuL572G03thOTQdtkEF-F+YqLb=ebg9iZki4X+VAQN8q+w@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============1734490286251918894=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============1734490286251918894==
Content-Type: multipart/alternative; boundary=001a11c1ed324410cd04daa54432

--001a11c1ed324410cd04daa54432
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

Hi Brian and Eric,
Here's the  meta_dump file of one server xfs repair log. And again this
happens exactly when one of the glusterfs finished rebalance.
https://docs.google.com/file/d/0B7n2C4T5tfNCdDFwN24zdkVmdHM/edit?usp=3Dshar=
ing

https://docs.google.com/file/d/0B7n2C4T5tfNCOGdpOGhIaVFRV28/edit?usp=3Dshar=
ing

The server which finishes rebalance and trigger xfs shutdown has the
following log on glusterfs:

[2013-04-18 22:42:52.063196] E
[dht-rebalance.c:1194:gf_defrag_migrate_data] 0-test2-dht: migrate-data
failed for /fytest/8/58037
[2013-04-18 22:42:52.067867] I [dht-rebalance.c:639:dht_migrate_file]
0-test2-dht: /fytest/8/58040: attempting to move from test2-replicate-1 to
test2-replicate-3
[2013-04-18 22:42:52.070530] W [dht-rebalance.c:353:__dht_check_free_space]
0-test2-dht: data movement attempted from node (test2-replicate-1) with
higher disk space to a node (test2-replicate-3) with lesser disk space
(/fytest/8/58040)
[2013-04-18 22:42:52.070613] E
[dht-rebalance.c:1194:gf_defrag_migrate_data] 0-test2-dht: migrate-data
failed for /fytest/8/58040
[2013-04-18 22:43:11.679797] I [dht-common.c:2337:dht_setxattr]
0-test2-dht: fixing the layout of /fytest/2
[2013-04-18 22:43:11.682162] I
[dht-rebalance.c:1055:gf_defrag_migrate_data] 0-test2-dht: migrate data
called on /fytest/2
[2013-04-18 22:43:14.246209] I [dht-rebalance.c:1611:gf_defrag_status_get]
0-glusterfs: Rebalance is completed
[2013-04-18 22:43:14.246278] I [dht-rebalance.c:1614:gf_defrag_status_get]
0-glusterfs: Files migrated: 7203, size: 745897761616, lookups: 79881,
failures: 9002
[2013-04-18 22:43:14.247021] W [glusterfsd.c:831:cleanup_and_exit]
(-->/lib64/libc.so.6(clone+0x6d) [0x3ec22e767d]
(-->/lib64/libpthread.so.0() [0x3ec2607851]
(-->/usr/sbin/glusterfs(glusterfs_sigwaiter+0xdd) [0x405c9d]))) 0-:
received signum (15), shutting down
[2013-04-18 22:43:14.247202] E
[rpcsvc.c:1155:rpcsvc_program_unregister_portmap] 0-rpc-service: Could not
unregister with portmap

The shutdown happens at 2013-04-18 22:43:14.

Thank you.



2013/4/18 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com>

> Hi Brian and Eric,
> The shutdown is not easy to produce but finally right now 2 of our server=
s
> in our test cluster xfs was shutdown.
>
> the trace output as following
>
> https://docs.google.com/file/d/0B7n2C4T5tfNCLXRYUWJ0b19JcWc/edit?usp=3Dsh=
aring
>
> Sorry but the systemtap is interrupt and I didn't noticed that so I didn'=
t
> get systemtap logs.
>
> /var/log/message is same as before
> Apr 18 22:43:14 10 kernel: XFS (sdb): xfs_iunlink_remove: xfs_inotobp()
> returned error 22.
> Apr 18 22:43:14 10 kernel: XFS (sdb): xfs_inactive: xfs_ifree returned
> error 22
> Apr 18 22:43:14 10 kernel: XFS (sdb): xfs_do_force_shutdown(0x1) called
> from line 1184 of file fs/xfs/xfs_vnodeops.c.  Return address =3D
> 0xffffffffa02d44aa
> Apr 18 22:43:14 10 kernel: XFS (sdb): I/O Error Detected. Shutting down
> filesystem
> Apr 18 22:43:14 10 kernel: XFS (sdb): Please umount the filesystem and
> rectify the problem(s)
> Apr 18 22:43:20 10 kernel: XFS (sdb): xfs_log_force: error 5 returned.
>
> The metadump file is large I'll share it to you soon.
>
>
> 2013/4/18 Brian Foster <bfoster@redhat.com>
>
>> On 04/18/2013 04:25 AM, =B7=FB=D3=C0=CC=CE wrote:
>> > Hi Brian and Eric,
>> > Can I change as following to bypass it?
>>
>> This is probably not a wise thing to do. The problem we're seeing here
>> is indicative of a potentially larger problem than this particular error
>> path. An inode is being unlinked and inactivated, but we aren't finding
>> on the list where we expect it to be. Killing the error return doesn't
>> eliminate the larger problem.
>>
>> So while changes could end up being made in this area as part of a fix,
>> I would not suggest making any changes beyond those designed to help
>> debug until we have a better idea of root cause.
>>
>> Brian
>>
>> > --- a/xfs_inode.c
>> > +++ b/xfs_inode.c
>> > @@ -1764,7 +1764,7 @@ xfs_iunlink_remove(
>> >                  */
>> >                 next_agino =3D
>> be32_to_cpu(agi->agi_unlinked[bucket_index]);
>> >                 last_ibp =3D NULL;
>> > -               while (next_agino !=3D agino) {
>> > +               while (next_agino !=3D agino && next_agino !=3D NULLAG=
INO) {
>> >                         /*
>> >                          * If the last inode wasn't the one pointing t=
o
>> >                          * us, then release its buffer since we're not
>> > @@ -1786,6 +1786,14 @@ xfs_iunlink_remove(
>> >                         ASSERT(next_agino !=3D NULLAGINO);
>> >                         ASSERT(next_agino !=3D 0);
>> >                 }
>> > +               if (next_agino =3D=3D NULLAGINO) {
>> > +                       /*
>> > +                        *After search the list for the inode being fr=
ee
>> > +                        *we still can't find it.
>> > +                        */
>> > +                       xfs_err(mp, "%s ino %lld not found in unlinked
>> > list.",
>> > +                                    __func__, (unsigned long
>> > long)ip->i_ino);
>> > +               }
>> >                 /*
>> >                  * Now last_ibp points to the buffer previous to us on
>> >                  * the unlinked list.  Pull us from the list.
>> > @@ -1810,16 +1818,20 @@ xfs_iunlink_remove(
>> >                 } else {
>> >                         xfs_trans_brelse(tp, ibp);
>> >                 }
>> > -               /*
>> > -                * Point the previous inode on the list to the next
>> inode.
>> > -                */
>> > -               last_dip->di_next_unlinked =3D cpu_to_be32(next_agino)=
;
>> > -               ASSERT(next_agino !=3D 0);
>> > -               offset =3D last_offset + offsetof(xfs_dinode_t,
>> > di_next_unlinked);
>> > -               xfs_trans_inode_buf(tp, last_ibp);
>> > -               xfs_trans_log_buf(tp, last_ibp, offset,
>> > -                                 (offset + sizeof(xfs_agino_t) - 1));
>> > -               xfs_inobp_check(mp, last_ibp);
>> > +               if (next_agino !=3D NULLAGINO) {
>> > +                       /*
>> > +                       * If only find the inode being free then we
>> modify
>> > +                       * the unlinked list.
>> > +                       * Point the previous inode on the list to the
>> > next inode.
>> > +                       */
>> > +                       last_dip->di_next_unlinked =3D
>> > cpu_to_be32(next_agino);
>> > +                       ASSERT(next_agino !=3D 0);
>> > +                       offset =3D last_offset + offsetof(xfs_dinode_t=
,
>> > di_next_unlinked);
>> > +                       xfs_trans_inode_buf(tp, last_ibp);
>> > +                       xfs_trans_log_buf(tp, last_ibp, offset,
>> > +                                         (offset + sizeof(xfs_agino_t=
)
>> > - 1));
>> > +                       xfs_inobp_check(mp, last_ibp);
>> > +               }
>> >         }
>> >         return 0;
>> >  }
>> >
>> > Thank you.
>> >
>> >
>> > 2013/4/18 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com <mailto:yongtaofu@gm=
ail.com>>
>> >
>> >     Hi Brain and Eric,
>> >     If the problem is the agno can't be found in the unlinked list. Ca=
n
>> >     we just bypass it instead of passing ino=3D0xffffffff to xfs_inoto=
bp?
>> >     Thank you.
>> >
>> >
>> >     2013/4/18 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com <mailto:yongtaof=
u@gmail.com>>
>> >
>> >         Hi Eric,
>> >         The shutdown issue is still not reproduced yet. But I get the
>> >         following error today during test.
>> >
>> >         Apr 18 07:42:51 10 kernel: Call Trace:
>> >         Apr 18 07:42:51 10 kernel: [<ffffffffa02d91ef>] ?
>> >         xfs_buf_cond_lock+0x2f/0xc0 [xfs]
>> >         Apr 18 07:42:51 10 kernel: [<ffffffff814fe6a5>]
>> >         schedule_timeout+0x215/0x2e0
>> >         Apr 18 07:42:51 10 kernel: [<ffffffffa02d5f07>] ?
>> >         kmem_zone_alloc+0x77/0xf0 [xfs]
>> >         Apr 18 07:42:51 10 kernel: [<ffffffff814ff5c2>] __down+0x72/0x=
b0
>> >         Apr 18 07:42:51 10 kernel: [<ffffffffa02da652>] ?
>> >         _xfs_buf_find+0x102/0x280 [xfs]
>> >         Apr 18 07:42:51 10 kernel: "echo 0 >
>> >         /proc/sys/kernel/hung_task_timeout_secs" disables this message=
.
>> >         Apr 18 07:42:51 10 kernel: glusterfsd    D ffffffff8160b3c0
>> >         0 14522      1 0x00000083
>> >         Apr 18 07:42:51 10 kernel: ffff882015a63a28 0000000000000082
>> >         0000000000000000 0000000000000000
>> >         Apr 18 07:42:51 10 kernel: ffff882015a639b8 ffffffffa02d91ef
>> >         ffff882015a639d8 0000000000000246
>> >         Apr 18 07:42:51 10 kernel: ffff880e70491af8 ffff882015a63fd8
>> >         000000000000fb88 ffff880e70491af8
>> >         Apr 18 07:42:51 10 kernel: Call Trace:
>> >         Apr 18 07:42:51 10 kernel: [<ffffffffa02d91ef>] ?
>> >         xfs_buf_cond_lock+0x2f/0xc0 [xfs]
>> >         Apr 18 07:42:51 10 kernel: [<ffffffff814fe6a5>]
>> >         schedule_timeout+0x215/0x2e0
>> >         Apr 18 07:42:51 10 kernel: [<ffffffffa02d5f07>] ?
>> >         kmem_zone_alloc+0x77/0xf0 [xfs]
>> >         Apr 18 07:42:51 10 kernel: [<ffffffff814ff5c2>] __down+0x72/0x=
b0
>> >         Apr 18 07:42:51 10 kernel: [<ffffffffa02da652>] ?
>> >         _xfs_buf_find+0x102/0x280 [xfs]
>> >         Apr 18 07:42:51 10 kernel: [<ffffffff81097ef1>] down+0x41/0x50
>> >         Apr 18 07:42:51 10 kernel: [<ffffffffa02da493>]
>> >         xfs_buf_lock+0x53/0x110 [xfs]
>> >         Apr 18 07:42:51 10 kernel: [<ffffffffa02da652>]
>> >         _xfs_buf_find+0x102/0x280 [xfs]
>> >         Apr 18 07:42:51 10 kernel: [<ffffffffa02da83b>]
>> >         xfs_buf_get+0x6b/0x1a0 [xfs]
>> >         Apr 18 07:42:51 10 kernel: [<ffffffffa02daeac>]
>> >         xfs_buf_read+0x2c/0x100 [xfs]
>> >         Apr 18 07:42:51 10 kernel: [<ffffffffa02d0af8>]
>> >         xfs_trans_read_buf+0x1f8/0x400 [xfs]
>> >         Apr 18 07:42:51 10 kernel: [<ffffffffa02b3444>]
>> >         xfs_read_agi+0x74/0x100 [xfs]
>> >         Apr 18 07:42:51 10 kernel: [<ffffffffa02b967b>]
>> >         xfs_iunlink+0x5b/0x180 [xfs]
>> >         Apr 18 07:42:51 10 kernel: [<ffffffff810724c7>] ?
>> >         current_fs_time+0x27/0x30
>> >         Apr 18 07:42:51 10 kernel: [<ffffffffa02d12a7>] ?
>> >         xfs_trans_ichgtime+0x27/0xa0 [xfs]
>> >         Apr 18 07:42:51 10 kernel: [<ffffffffa02d15fb>]
>> >         xfs_droplink+0x5b/0x70 [xfs]
>> >         Apr 18 07:42:51 10 kernel: [<ffffffffa02d2f9e>]
>> >         xfs_remove+0x27e/0x3a0 [xfs]
>> >         Apr 18 07:42:51 10 kernel: [<ffffffff81186fd3>] ?
>> >         generic_permission+0x23/0xb0
>> >         Apr 18 07:42:51 10 kernel: [<ffffffffa02e0968>]
>> >         xfs_vn_unlink+0x48/0x90 [xfs]
>> >         Apr 18 07:42:51 10 kernel: [<ffffffff81188c0f>]
>> vfs_unlink+0x9f/0xe0
>> >         Apr 18 07:42:51 10 kernel: [<ffffffff8118795a>] ?
>> >         lookup_hash+0x3a/0x50
>> >         Apr 18 07:42:51 10 kernel: [<ffffffff8118b143>]
>> >         do_unlinkat+0x183/0x1c0
>> >         Apr 18 07:42:51 10 kernel: [<ffffffff81017938>] ?
>> >         syscall_trace_enter+0x1d8/0x1e0
>> >         Apr 18 07:42:51 10 kernel: [<ffffffff8118b196>]
>> sys_unlink+0x16/0x20
>> >         Apr 18 07:42:51 10 kernel: [<ffffffff8100b308>]
>> tracesys+0xd9/0xde
>> >
>> >         Thank you.
>> >
>> >
>> >         2013/4/17 Eric Sandeen <sandeen@sandeen.net
>> >         <mailto:sandeen@sandeen.net>>
>> >
>> >             On Apr 16, 2013, at 8:48 PM, =B7=FB=D3=C0=CC=CE <yongtaofu=
@gmail.com
>> >             <mailto:yongtaofu@gmail.com>> wrote:
>> >
>> >>             Hi Brain,
>> >>             Can I change as following?
>> >
>> >             ASSERTS are no-ops in a non-debug kernel, so this won't
>> >             change any behavior.  I hope we'll know more if we get new
>> >             traces from your patched kernel....
>> >
>> >             Eric
>> >
>> >>             --- a/xfs_inode.c
>> >>             +++ b/xfs_inode.c
>> >>             @@ -1773,6 +1773,8 @@ xfs_iunlink_remove(
>> >>                                     if (last_ibp !=3D NULL) {
>> >>                                             xfs_trans_brelse(tp,
>> >>             last_ibp);
>> >>                                     }
>> >>             +                        ASSERT(next_agino !=3D NULLAGINO=
);
>> >>             +                        ASSERT(next_agino !=3D 0);
>> >>                                     next_ino =3D XFS_AGINO_TO_INO(mp,
>> >>             agno, next_agino);
>> >>                                     error =3D xfs_inotobp(mp, tp,
>> >>             next_ino, &last_dip,
>> >>                                                         &last_ibp,
>> >>             &last_offset, 0);
>> >>             @@ -1783,8 +1785,6 @@ xfs_iunlink_remove(
>> >>                                             return error;
>> >>                                     }
>> >>                                     next_agino =3D
>> >>             be32_to_cpu(last_dip->di_next_unlinked);
>> >>             -                       ASSERT(next_agino !=3D NULLAGINO)=
;
>> >>             -                       ASSERT(next_agino !=3D 0);
>> >>                             }
>> >>                             /*
>> >>                              * Now last_ibp points to the buffer
>> >>             previous to us on
>> >>
>> >>             Thank you.
>> >>
>> >>
>> >>             2013/4/17 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com
>> >>             <mailto:yongtaofu@gmail.com>>
>> >>
>> >>                 Hi Brain,
>> >>                 If it is because NULLAGINO is passed in  to
>> xfs_inotobp().
>> >>                 Can I move the following two lines before xfs_inotobp=
?
>> >>
>> >>                 For example:
>> >>
>> >>                 1767                 while (next_agino !=3D agino) {
>> >>                 1768                         /*
>> >>                 1769                          * If the last inode
>> >>                 wasn't the one pointing to
>> >>                 1770                          * us, then release its
>> >>                 buffer since we're not
>> >>                 1771                          * going to do anything
>> >>                 with it.
>> >>                 1772                          */
>> >>                 1773                         if (last_ibp !=3D NULL) =
{
>> >>                 1774
>> >>                 xfs_trans_brelse(tp, last_ibp);
>> >>                 1775                         }
>> >>                 1776                         next_ino =3D
>> >>                 XFS_AGINO_TO_INO(mp, agno, next_agino);
>> >>                 +                               ASSERT(next_agino !=
=3D
>> >>                 NULLAGINO);
>> >>                 +                               ASSERT(next_agino !=
=3D
>> 0);
>> >>                 1777                         error =3D xfs_inotobp(mp=
,
>> >>                 tp, next_ino, &last_dip,
>> >>                 1778
>> >>                 &last_ibp, &last_offset, 0);
>> >>                 1779                         if (error) {
>> >>                 1780                                 xfs_warn(mp,
>> >>                 1781                                         "%s:
>> >>                 xfs_inotobp() returned error %d.",
>> >>                 1782                                         __func__=
,
>> >>                 error);
>> >>                 1783                                 return error;
>> >>                 1784                         }
>> >>                 1785                         next_agino =3D
>> >>                 be32_to_cpu(last_dip->di_next_unlinked);
>> >>                 -                               //ASSERT(next_agino !=
=3D
>> >>                 NULLAGINO);
>> >>                 -                               //ASSERT(next_agino !=
=3D
>> 0);
>> >>                 1788                 }
>> >>                 I don't understand xfs well and correct me if I'm
>> >>                 totally wrong.
>> >>                 Thank you very much.
>> >>
>> >>
>> >>                 2013/4/17 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com
>> >>                 <mailto:yongtaofu@gmail.com>>
>> >>
>> >>                     Hi Brain,
>> >>                     I want to ask a question, according to the
>> >>                     shutdown trace. The ino in  xfs_iunlink_remove
>> >>                     is 0x113, why xfs_imap got ino=3D0xffffffff ?
>> >>
>> >>                     --- xfs_imap --
>> >>                     module("xfs").function("xfs_imap@fs
>> /xfs/xfs_ialloc.c:1257").return
>> >>                     -- return=3D0x16
>> >>                     vars: mp=3D0xffff882017a50800 tp=3D0xffff881c8179=
7c70
>> >>                     ino=3D0xffffffff
>> >>
>> >>                     --- xfs_iunlink_remove --
>> >>                     module("xfs").function("xfs_iunlink_remove@fs
>> /xfs/xfs_inode.c:1680").return
>> >>                     -- return=3D0x16
>> >>                     vars: tp=3D0xffff881c81797c70 ip=3D0xffff881003c1=
3c00
>> >>                     next_ino=3D? mp=3D? agi=3D? dip=3D?
>> >>                     agibp=3D0xffff880109b47e20 ibp=3D? agno=3D? agino=
=3D?
>> >>                     next_agino=3D? last_ibp=3D?
>> >>                     last_dip=3D0xffff882000000000 bucket_index=3D?
>> >>                     offset=3D? last_offset=3D0xffffffffffff8810 error=
=3D?
>> >>                     __func__=3D[...]
>> >>                     ip: i_ino =3D 0x113, i_flags =3D 0x0
>> >>
>> >>                     Thank you.
>> >>
>> >>
>> >>
>> >>                     2013/4/17 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com
>> >>                     <mailto:yongtaofu@gmail.com>>
>> >>
>> >>                         Hi Brain,
>> >>                         Thank you for your update, and I have applied
>> >>                         your last kernel patch. However it is not eas=
y
>> >>                         to reproduce especially in out test
>> >>                         environment. Till now is not happens again.
>> >>                         I'll update the kernel patch now. BTW is ther=
e
>> >>                         any findings in the logs of previous thread?
>> >>
>> http://oss.sgi.com/archives/xfs/2013-04/msg00327.html
>> >>                         I guess it tend to happen during glusterfs
>> >>                         rebalance because glusterfs moves a lot of
>> >>                         file from one server to another and then
>> >>                         unlink it.
>> >>
>> >>                         Thank you.
>> >>
>> >>
>> >>                         2013/4/17 Brian Foster <bfoster@redhat.com
>> >>                         <mailto:bfoster@redhat.com>>
>> >>
>> >>                             On 04/16/2013 12:24 PM, Dave Chinner wrot=
e:
>> >>                             > On Mon, Apr 15, 2013 at 07:14:39PM
>> >>                             -0400, Brian Foster wrote:
>> >>                             >> Hi,
>> >>                             >>
>> >>                             >> Thanks for the data in the previous
>> thread:
>> >>                             >>
>> >>                             >>
>> >>
>> http://oss.sgi.com/archives/xfs/2013-04/msg00327.html
>> >>                             >>
>> >>                             ...
>> >>                             >>
>> >>                             >>      echo 1 >
>> >>
>> /sys/kernel/debug/tracing/events/xfs/xfs_iunlink/enable
>> >>                             >>      echo 1 >
>> >>
>> /sys/kernel/debug/tracing/events/xfs/xfs_iunlink_remove/enable
>> >>                             >>      ... reproduce ...
>> >>                             >>      cat
>> >>                             /sys/kernel/debug/tracing/trace >
>> trace.output
>> >>                             >
>> >>                             > It's better to use trace-cmd for this.
>> >>                             it will result in less
>> >>                             > dropped events. i.e.:
>> >>                             >
>> >>                             >       $ trace-cmd record -e xfs_iunlink=
\*
>> >>                             >       ... reproduce ...
>> >>                             >       ^C
>> >>                             >       $ trace-cmd report > trace.output
>> >>                             >
>> >>                             >> --- a/fs/xfs/linux-2.6/xfs_trace.h
>> >>                             >> +++ b/fs/xfs/linux-2.6/xfs_trace.h
>> >>                             >> @@ -581,6 +581,8 @@
>> >>                             DEFINE_INODE_EVENT(xfs_file_fsync);
>> >>                             ...
>> >>                             >
>> >>                             > I would suggest that the the tracing
>> >>                             shoul dbe at entry of the
>> >>                             > function, otherwise we won't get a
>> >>                             tracepoint for the operation that
>> >>                             > triggers the shutdown. (That's the
>> >>                             reason most tracepoints in XFS
>> >>                             > are at function entry...)
>> >>                             >
>> >>
>> >>                             Good points, thanks Dave. A v2 that pulls
>> >>                             up the tracepoints towards
>> >>                             function entry is appended.
>> >>
>> >>                             Brian
>> >>
>> >>                             From
>> >>                             280943e78ebe0b97a774cba51e7815c42f044b55
>> >>                             Mon Sep 17 00:00:00 2001
>> >>                             From: Brian Foster <bfoster@redhat.com
>> >>                             <mailto:bfoster@redhat.com>>
>> >>                             Date: Mon, 15 Apr 2013 18:16:24 -0400
>> >>                             Subject: [PATCH v2] xfs: add tracepoints
>> >>                             for xfs_iunlink and
>> >>                             xfs_iunlink_remove
>> >>
>> >>                             ---
>> >>                              fs/xfs/linux-2.6/xfs_trace.h |    2 ++
>> >>                              fs/xfs/xfs_inode.c           |    4 ++++
>> >>                              2 files changed, 6 insertions(+), 0
>> >>                             deletions(-)
>> >>
>> >>                             diff --git a/fs/xfs/linux-2.6/xfs_trace.h
>> >>                             b/fs/xfs/linux-2.6/xfs_trace.h
>> >>                             index adc6ec4..338a0f9 100644
>> >>                             --- a/fs/xfs/linux-2.6/xfs_trace.h
>> >>                             +++ b/fs/xfs/linux-2.6/xfs_trace.h
>> >>                             @@ -583,6 +583,8 @@
>> >>                             DEFINE_INODE_EVENT(xfs_file_fsync);
>> >>                              DEFINE_INODE_EVENT(xfs_destroy_inode);
>> >>                              DEFINE_INODE_EVENT(xfs_dirty_inode);
>> >>                              DEFINE_INODE_EVENT(xfs_clear_inode);
>> >>                             +DEFINE_INODE_EVENT(xfs_iunlink);
>> >>                             +DEFINE_INODE_EVENT(xfs_iunlink_remove);
>> >>
>> >>                              DEFINE_INODE_EVENT(xfs_dquot_dqalloc);
>> >>                              DEFINE_INODE_EVENT(xfs_dquot_dqdetach);
>> >>                             diff --git a/fs/xfs/xfs_inode.c
>> >>                             b/fs/xfs/xfs_inode.c
>> >>                             index 19900f0..d705c77 100644
>> >>                             --- a/fs/xfs/xfs_inode.c
>> >>                             +++ b/fs/xfs/xfs_inode.c
>> >>                             @@ -1615,6 +1615,8 @@ xfs_iunlink(
>> >>
>> >>                                     mp =3D tp->t_mountp;
>> >>
>> >>                             +       trace_xfs_iunlink(ip);
>> >>                             +
>> >>                                     /*
>> >>                                      * Get the agi buffer first.  It
>> >>                             ensures lock ordering
>> >>                                      * on the list.
>> >>                             @@ -1694,6 +1696,8 @@ xfs_iunlink_remove(
>> >>                                     mp =3D tp->t_mountp;
>> >>                                     agno =3D XFS_INO_TO_AGNO(mp,
>> ip->i_ino);
>> >>
>> >>                             +       trace_xfs_iunlink_remove(ip);
>> >>                             +
>> >>                                     /*
>> >>                                      * Get the agi buffer first.  It
>> >>                             ensures lock ordering
>> >>                                      * on the list.
>> >>                             --
>> >>                             1.7.7.6
>> >>
>> >>
>> >>
>> >>
>> >>                         --
>> >>                         =B7=FB=D3=C0=CC=CE
>> >>
>> >>
>> >>
>> >>
>> >>                     --
>> >>                     =B7=FB=D3=C0=CC=CE
>> >>
>> >>
>> >>
>> >>
>> >>                 --
>> >>                 =B7=FB=D3=C0=CC=CE
>> >>
>> >>
>> >>
>> >>
>> >>             --
>> >>             =B7=FB=D3=C0=CC=CE
>> >>             _______________________________________________
>> >>             xfs mailing list
>> >>             xfs@oss.sgi.com <mailto:xfs@oss.sgi.com>
>> >>             http://oss.sgi.com/mailman/listinfo/xfs
>> >
>> >
>> >
>> >
>> >         --
>> >         =B7=FB=D3=C0=CC=CE
>> >
>> >
>> >
>> >
>> >     --
>> >     =B7=FB=D3=C0=CC=CE
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

--001a11c1ed324410cd04daa54432
Content-Type: text/html; charset=GB2312
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div>Hi Brian and Eric,<br></div>Here&#39;s=
 the&nbsp; meta_dump file of one server xfs repair log. And again this happ=
ens exactly when one of the glusterfs finished rebalance.<br><a href=3D"htt=
ps://docs.google.com/file/d/0B7n2C4T5tfNCdDFwN24zdkVmdHM/edit?usp=3Dsharing=
">https://docs.google.com/file/d/0B7n2C4T5tfNCdDFwN24zdkVmdHM/edit?usp=3Dsh=
aring</a><br>
<br><a href=3D"https://docs.google.com/file/d/0B7n2C4T5tfNCOGdpOGhIaVFRV28/=
edit?usp=3Dsharing">https://docs.google.com/file/d/0B7n2C4T5tfNCOGdpOGhIaVF=
RV28/edit?usp=3Dsharing</a><br><br></div>The server which finishes rebalanc=
e and trigger xfs shutdown has the following log on glusterfs:<br>
<br>[2013-04-18 22:42:52.063196] E [dht-rebalance.c:1194:gf_defrag_migrate_=
data] 0-test2-dht: migrate-data failed for /fytest/8/58037<br>[2013-04-18 2=
2:42:52.067867] I [dht-rebalance.c:639:dht_migrate_file] 0-test2-dht: /fyte=
st/8/58040: attempting to move from test2-replicate-1 to test2-replicate-3<=
br>
[2013-04-18 22:42:52.070530] W [dht-rebalance.c:353:__dht_check_free_space]=
 0-test2-dht: data movement attempted from node (test2-replicate-1) with hi=
gher disk space to a node (test2-replicate-3) with lesser disk space (/fyte=
st/8/58040)<br>
[2013-04-18 22:42:52.070613] E [dht-rebalance.c:1194:gf_defrag_migrate_data=
] 0-test2-dht: migrate-data failed for /fytest/8/58040<br>[2013-04-18 22:43=
:11.679797] I [dht-common.c:2337:dht_setxattr] 0-test2-dht: fixing the layo=
ut of /fytest/2<br>
[2013-04-18 22:43:11.682162] I [dht-rebalance.c:1055:gf_defrag_migrate_data=
] 0-test2-dht: migrate data called on /fytest/2<br>[2013-04-18 22:43:14.246=
209] I [dht-rebalance.c:1611:gf_defrag_status_get] 0-glusterfs: Rebalance i=
s completed<br>
[2013-04-18 22:43:14.246278] I [dht-rebalance.c:1614:gf_defrag_status_get] =
0-glusterfs: Files migrated: 7203, size: 745897761616, lookups: 79881, fail=
ures: 9002<br>[2013-04-18 22:43:14.247021] W [glusterfsd.c:831:cleanup_and_=
exit] (--&gt;/lib64/libc.so.6(clone+0x6d) [0x3ec22e767d] (--&gt;/lib64/libp=
thread.so.0() [0x3ec2607851] (--&gt;/usr/sbin/glusterfs(glusterfs_sigwaiter=
+0xdd) [0x405c9d]))) 0-: received signum (15), shutting down<br>
[2013-04-18 22:43:14.247202] E [rpcsvc.c:1155:rpcsvc_program_unregister_por=
tmap] 0-rpc-service: Could not unregister with portmap<br><br></div>The shu=
tdown happens at 2013-04-18 22:43:14.<br><br></div>Thank you. <br><div>
<div><div><div><div>&nbsp;<br></div></div></div></div></div></div><div clas=
s=3D"gmail_extra"><br><br><div class=3D"gmail_quote">2013/4/18 =B7=FB=D3=C0=
=CC=CE <span dir=3D"ltr">&lt;<a href=3D"mailto:yongtaofu@gmail.com" target=
=3D"_blank">yongtaofu@gmail.com</a>&gt;</span><br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div dir=3D"ltr"><div><div><div><div><div>Hi=
 Brian and Eric,<br></div>The shutdown is not easy to produce but finally r=
ight now 2 of our servers in our test cluster xfs was shutdown.<br>
<br>the trace output as following<br><a href=3D"https://docs.google.com/fil=
e/d/0B7n2C4T5tfNCLXRYUWJ0b19JcWc/edit?usp=3Dsharing" target=3D"_blank">http=
s://docs.google.com/file/d/0B7n2C4T5tfNCLXRYUWJ0b19JcWc/edit?usp=3Dsharing<=
/a><br>

<br></div>Sorry but the systemtap is interrupt and I didn&#39;t noticed tha=
t so I didn&#39;t get systemtap logs.<br></div><br></div>/var/log/message i=
s same as before<br>Apr 18 22:43:14 10 kernel: XFS (sdb): xfs_iunlink_remov=
e: xfs_inotobp() returned error 22.<br>

Apr 18 22:43:14 10 kernel: XFS (sdb): xfs_inactive: xfs_ifree returned erro=
r 22<br>Apr 18 22:43:14 10 kernel: XFS (sdb): xfs_do_force_shutdown(0x1) ca=
lled from line 1184 of file fs/xfs/xfs_vnodeops.c.&nbsp; Return address =3D=
 0xffffffffa02d44aa<br>

Apr 18 22:43:14 10 kernel: XFS (sdb): I/O Error Detected. Shutting down fil=
esystem<br>Apr 18 22:43:14 10 kernel: XFS (sdb): Please umount the filesyst=
em and rectify the problem(s)<br>Apr 18 22:43:20 10 kernel: XFS (sdb): xfs_=
log_force: error 5 returned.<br>

<br></div>The metadump file is large I&#39;ll share it to you soon.<br></di=
v><div class=3D"gmail_extra"><div><div class=3D"h5"><br><br><div class=3D"g=
mail_quote">2013/4/18 Brian Foster <span dir=3D"ltr">&lt;<a href=3D"mailto:=
bfoster@redhat.com" target=3D"_blank">bfoster@redhat.com</a>&gt;</span><br>

<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div>On 04/18/2013 04:25 AM, =B7=FB=D3=C0=CC=
=CE wrote:<br>
&gt; Hi Brian and Eric,<br>
&gt; Can I change as following to bypass it?<br>
<br>
</div>This is probably not a wise thing to do. The problem we&#39;re seeing=
 here<br>
is indicative of a potentially larger problem than this particular error<br=
>
path. An inode is being unlinked and inactivated, but we aren&#39;t finding=
<br>
on the list where we expect it to be. Killing the error return doesn&#39;t<=
br>
eliminate the larger problem.<br>
<br>
So while changes could end up being made in this area as part of a fix,<br>
I would not suggest making any changes beyond those designed to help<br>
debug until we have a better idea of root cause.<br>
<br>
Brian<br>
<div><div><br>
&gt; --- a/xfs_inode.c<br>
&gt; +++ b/xfs_inode.c<br>
&gt; @@ -1764,7 +1764,7 @@ xfs_iunlink_remove(<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;*/<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; next_agino =3D=
 be32_to_cpu(agi-&gt;agi_unlinked[bucket_index]);<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; last_ibp =3D N=
ULL;<br>
&gt; - &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; while (next_agino !=
=3D agino) {<br>
&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; while (next_agino !=
=3D agino &amp;&amp; next_agino !=3D NULLAGINO) {<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; /*<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp;* If the last inode wasn&#39;t the one pointing to<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp;* us, then release its buffer since we&#39;re not<br>
&gt; @@ -1786,6 +1786,14 @@ xfs_iunlink_remove(<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; ASSERT(next_agino !=3D NULLAGINO);<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; ASSERT(next_agino !=3D 0);<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>
&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; if (next_agino =3D=
=3D NULLAGINO) {<br>
&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; /*<br>
&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp;*After search the list for the inode being free<br>
&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp;*we still can&#39;t find it.<br>
&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp;*/<br>
&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; xfs_err(mp, &quot;%s ino %lld not found in unlinked<br>
&gt; list.&quot;,<br>
&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;__func__, (unsigne=
d long<br>
&gt; long)ip-&gt;i_ino);<br>
&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; /*<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;* Now la=
st_ibp points to the buffer previous to us on<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;* the un=
linked list. &nbsp;Pull us from the list.<br>
&gt; @@ -1810,16 +1818,20 @@ xfs_iunlink_remove(<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; } else {<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; xfs_trans_brelse(tp, ibp);<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>
&gt; - &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; /*<br>
&gt; - &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;* Point the p=
revious inode on the list to the next inode.<br>
&gt; - &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;*/<br>
&gt; - &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; last_dip-&gt;di_nex=
t_unlinked =3D cpu_to_be32(next_agino);<br>
&gt; - &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ASSERT(next_agino !=
=3D 0);<br>
&gt; - &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; offset =3D last_off=
set + offsetof(xfs_dinode_t,<br>
&gt; di_next_unlinked);<br>
&gt; - &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; xfs_trans_inode_buf=
(tp, last_ibp);<br>
&gt; - &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; xfs_trans_log_buf(t=
p, last_ibp, offset,<br>
&gt; - &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; (offset + sizeof(xfs_agino_t) -=
 1));<br>
&gt; - &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; xfs_inobp_check(mp,=
 last_ibp);<br>
&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; if (next_agino !=3D=
 NULLAGINO) {<br>
&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; /*<br>
&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; * If only find the inode being free then we modify<br>
&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; * the unlinked list.<br>
&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; * Point the previous inode on the list to the<br>
&gt; next inode.<br>
&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; */<br>
&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; last_dip-&gt;di_next_unlinked =3D<br>
&gt; cpu_to_be32(next_agino);<br>
&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; ASSERT(next_agino !=3D 0);<br>
&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; offset =3D last_offset + offsetof(xfs_dinode_t,<br>
&gt; di_next_unlinked);<br>
&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; xfs_trans_inode_buf(tp, last_ibp);<br>
&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; xfs_trans_log_buf(tp, last_ibp, offset,<br>
&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; (of=
fset + sizeof(xfs_agino_t)<br>
&gt; - 1));<br>
&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; xfs_inobp_check(mp, last_ibp);<br>
&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; }<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; return 0;<br>
&gt; &nbsp;}<br>
&gt;<br>
&gt; Thank you.<br>
&gt;<br>
&gt;<br>
</div></div>&gt; 2013/4/18 =B7=FB=D3=C0=CC=CE &lt;<a href=3D"mailto:yongtao=
fu@gmail.com" target=3D"_blank">yongtaofu@gmail.com</a> &lt;mailto:<a href=
=3D"mailto:yongtaofu@gmail.com" target=3D"_blank">yongtaofu@gmail.com</a>&g=
t;&gt;<br>
<div>&gt;<br>
&gt; &nbsp; &nbsp; Hi Brain and Eric,<br>
&gt; &nbsp; &nbsp; If the problem is the agno can&#39;t be found in the unl=
inked list. Can<br>
&gt; &nbsp; &nbsp; we just bypass it instead of passing ino=3D0xffffffff to=
 xfs_inotobp?<br>
&gt; &nbsp; &nbsp; Thank you.<br>
&gt;<br>
&gt;<br>
</div>&gt; &nbsp; &nbsp; 2013/4/18 =B7=FB=D3=C0=CC=CE &lt;<a href=3D"mailto=
:yongtaofu@gmail.com" target=3D"_blank">yongtaofu@gmail.com</a> &lt;mailto:=
<a href=3D"mailto:yongtaofu@gmail.com" target=3D"_blank">yongtaofu@gmail.co=
m</a>&gt;&gt;<br>
<div><div>&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Hi Eric,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; The shutdown issue is still not reproduced=
 yet. But I get the<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; following error today during test.<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kernel: Call Trace:<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kernel: [&lt;ffffffffa0=
2d91ef&gt;] ?<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; xfs_buf_cond_lock+0x2f/0xc0 [xfs]<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kernel: [&lt;ffffffff81=
4fe6a5&gt;]<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; schedule_timeout+0x215/0x2e0<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kernel: [&lt;ffffffffa0=
2d5f07&gt;] ?<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kmem_zone_alloc+0x77/0xf0 [xfs]<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kernel: [&lt;ffffffff81=
4ff5c2&gt;] __down+0x72/0xb0<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kernel: [&lt;ffffffffa0=
2da652&gt;] ?<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; _xfs_buf_find+0x102/0x280 [xfs]<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kernel: &quot;echo 0 &g=
t;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; /proc/sys/kernel/hung_task_timeout_secs&qu=
ot; disables this message.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kernel: glusterfsd &nbs=
p; &nbsp;D ffffffff8160b3c0<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; 0 14522 &nbsp; &nbsp; &nbsp;1 0x00000083<b=
r>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kernel: ffff882015a63a2=
8 0000000000000082<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; 0000000000000000 0000000000000000<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kernel: ffff882015a639b=
8 ffffffffa02d91ef<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; ffff882015a639d8 0000000000000246<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kernel: ffff880e70491af=
8 ffff882015a63fd8<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; 000000000000fb88 ffff880e70491af8<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kernel: Call Trace:<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kernel: [&lt;ffffffffa0=
2d91ef&gt;] ?<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; xfs_buf_cond_lock+0x2f/0xc0 [xfs]<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kernel: [&lt;ffffffff81=
4fe6a5&gt;]<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; schedule_timeout+0x215/0x2e0<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kernel: [&lt;ffffffffa0=
2d5f07&gt;] ?<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kmem_zone_alloc+0x77/0xf0 [xfs]<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kernel: [&lt;ffffffff81=
4ff5c2&gt;] __down+0x72/0xb0<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kernel: [&lt;ffffffffa0=
2da652&gt;] ?<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; _xfs_buf_find+0x102/0x280 [xfs]<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kernel: [&lt;ffffffff81=
097ef1&gt;] down+0x41/0x50<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kernel: [&lt;ffffffffa0=
2da493&gt;]<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; xfs_buf_lock+0x53/0x110 [xfs]<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kernel: [&lt;ffffffffa0=
2da652&gt;]<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; _xfs_buf_find+0x102/0x280 [xfs]<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kernel: [&lt;ffffffffa0=
2da83b&gt;]<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; xfs_buf_get+0x6b/0x1a0 [xfs]<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kernel: [&lt;ffffffffa0=
2daeac&gt;]<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; xfs_buf_read+0x2c/0x100 [xfs]<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kernel: [&lt;ffffffffa0=
2d0af8&gt;]<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; xfs_trans_read_buf+0x1f8/0x400 [xfs]<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kernel: [&lt;ffffffffa0=
2b3444&gt;]<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; xfs_read_agi+0x74/0x100 [xfs]<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kernel: [&lt;ffffffffa0=
2b967b&gt;]<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; xfs_iunlink+0x5b/0x180 [xfs]<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kernel: [&lt;ffffffff81=
0724c7&gt;] ?<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; current_fs_time+0x27/0x30<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kernel: [&lt;ffffffffa0=
2d12a7&gt;] ?<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; xfs_trans_ichgtime+0x27/0xa0 [xfs]<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kernel: [&lt;ffffffffa0=
2d15fb&gt;]<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; xfs_droplink+0x5b/0x70 [xfs]<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kernel: [&lt;ffffffffa0=
2d2f9e&gt;]<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; xfs_remove+0x27e/0x3a0 [xfs]<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kernel: [&lt;ffffffff81=
186fd3&gt;] ?<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; generic_permission+0x23/0xb0<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kernel: [&lt;ffffffffa0=
2e0968&gt;]<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; xfs_vn_unlink+0x48/0x90 [xfs]<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kernel: [&lt;ffffffff81=
188c0f&gt;] vfs_unlink+0x9f/0xe0<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kernel: [&lt;ffffffff81=
18795a&gt;] ?<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; lookup_hash+0x3a/0x50<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kernel: [&lt;ffffffff81=
18b143&gt;]<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; do_unlinkat+0x183/0x1c0<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kernel: [&lt;ffffffff81=
017938&gt;] ?<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; syscall_trace_enter+0x1d8/0x1e0<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kernel: [&lt;ffffffff81=
18b196&gt;] sys_unlink+0x16/0x20<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Apr 18 07:42:51 10 kernel: [&lt;ffffffff81=
00b308&gt;] tracesys+0xd9/0xde<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Thank you.<br>
&gt;<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; 2013/4/17 Eric Sandeen &lt;<a href=3D"mail=
to:sandeen@sandeen.net" target=3D"_blank">sandeen@sandeen.net</a><br>
</div></div>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:s=
andeen@sandeen.net" target=3D"_blank">sandeen@sandeen.net</a>&gt;&gt;<br>
<div>&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; On Apr 16, 2013, at 8:48 PM,=
 =B7=FB=D3=C0=CC=CE &lt;<a href=3D"mailto:yongtaofu@gmail.com" target=3D"_b=
lank">yongtaofu@gmail.com</a><br>
</div><div><div>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &lt;mailto:<=
a href=3D"mailto:yongtaofu@gmail.com" target=3D"_blank">yongtaofu@gmail.com=
</a>&gt;&gt; wrote:<br>
&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Hi Brain,<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Can I change as followin=
g?<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ASSERTS are no-ops in a non-=
debug kernel, so this won&#39;t<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; change any behavior. &nbsp;I=
 hope we&#39;ll know more if we get new<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; traces from your patched ker=
nel....<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Eric<br>
&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; --- a/xfs_inode.c<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; +++ b/xfs_inode.c<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; @@ -1773,6 +1773,8 @@ xf=
s_iunlink_remove(<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; if (last_ibp !=
=3D NULL) {<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; xfs_trans_brelse(tp,<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; last_ibp);<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;ASSERT(next_ag=
ino !=3D NULLAGINO);<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;ASSERT(next_ag=
ino !=3D 0);<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; next_ino =3D XF=
S_AGINO_TO_INO(mp,<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; agno, next_agino);<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; error =3D xfs_i=
notobp(mp, tp,<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; next_ino, &amp;last_dip,=
<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &amp;last_ibp,<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &amp;last_offset, 0);<br=
>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; @@ -1783,8 +1785,6 @@ xf=
s_iunlink_remove(<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; return error;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; next_agino =3D<=
br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; be32_to_cpu(last_dip-&gt=
;di_next_unlinked);<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; - &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ASSERT(next_agino !=
=3D NULLAGINO);<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; - &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ASSERT(next_agino !=
=3D 0);<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; /*<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;* Now last_ibp points to the buffer<b=
r>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; previous to us on<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Thank you.<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 2013/4/17 =B7=FB=D3=C0=
=CC=CE &lt;<a href=3D"mailto:yongtaofu@gmail.com" target=3D"_blank">yongtao=
fu@gmail.com</a><br>
</div></div>&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &lt;mailto:<=
a href=3D"mailto:yongtaofu@gmail.com" target=3D"_blank">yongtaofu@gmail.com=
</a>&gt;&gt;<br>
<div><div>&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Hi Brain,<=
br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; If it is b=
ecause NULLAGINO is passed in &nbsp;to xfs_inotobp().<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Can I move=
 the following two lines before xfs_inotobp?<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; For exampl=
e:<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1767 &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; while (next_agino !=3D a=
gino) {<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1768 &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; /*<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1769 &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp;* If the last inode<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; wasn&#39;t=
 the one pointing to<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1770 &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp;* us, then release its<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; buffer sin=
ce we&#39;re not<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1771 &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp;* going to do anything<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; with it.<b=
r>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1772 &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp;*/<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1773 &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; if (last_ibp !=3D NULL) {<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1774<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; xfs_trans_=
brelse(tp, last_ibp);<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1775 &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; }<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1776 &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; next_ino =3D<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; XFS_AGINO_=
TO_INO(mp, agno, next_agino);<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; ASSERT(next_agino !=3D<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; NULLAGINO)=
;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; ASSERT(next_agino !=3D 0);<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1777 &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; error =3D xfs_inotobp(mp,<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; tp, next_i=
no, &amp;last_dip,<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1778<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &amp;last_=
ibp, &amp;last_offset, 0);<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1779 &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; if (error) {<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1780 &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; xfs_warn(mp,<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1781 &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &quot;%s:<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; xfs_inotob=
p() returned error %d.&quot;,<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1782 &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; __func__,<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; error);<br=
>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1783 &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; return error;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1784 &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; }<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1785 &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; next_agino =3D<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; be32_to_cp=
u(last_dip-&gt;di_next_unlinked);<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; - &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; //ASSERT(next_agino !=3D<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; NULLAGINO)=
;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; - &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; //ASSERT(next_agino !=3D 0);<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1788 &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; I don&#39;=
t understand xfs well and correct me if I&#39;m<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; totally wr=
ong.<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Thank you =
very much.<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 2013/4/17 =
=B7=FB=D3=C0=CC=CE &lt;<a href=3D"mailto:yongtaofu@gmail.com" target=3D"_bl=
ank">yongtaofu@gmail.com</a><br>
</div></div>&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &lt;mailto:<a href=3D"mailto:yongtaofu@gmail.com" target=3D"_blank">yongt=
aofu@gmail.com</a>&gt;&gt;<br>
<div>&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; Hi Brain,<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; I want to ask a question, according to the<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; shutdown trace. The ino in &nbsp;xfs_iunlink_remove<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; is 0x113, why xfs_imap got ino=3D0xffffffff ?<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; --- xfs_imap --<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; module(&quot;xfs&quot;).function(&quot;xfs_imap@fs/xfs/xfs_ialloc.c:125=
7&quot;).return<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; -- return=3D0x16<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; vars: mp=3D0xffff882017a50800 tp=3D0xffff881c81797c70<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; ino=3D0xffffffff<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; --- xfs_iunlink_remove --<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; module(&quot;xfs&quot;).function(&quot;xfs_iunlink_remove@fs/xfs/xfs_in=
ode.c:1680&quot;).return<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; -- return=3D0x16<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; vars: tp=3D0xffff881c81797c70 ip=3D0xffff881003c13c00<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; next_ino=3D? mp=3D? agi=3D? dip=3D?<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; agibp=3D0xffff880109b47e20 ibp=3D? agno=3D? agino=3D?<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; next_agino=3D? last_ibp=3D?<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; last_dip=3D0xffff882000000000 bucket_index=3D?<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; offset=3D? last_offset=3D0xffffffffffff8810 error=3D?<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; __func__=3D[...]<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; ip: i_ino =3D 0x113, i_flags =3D 0x0<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; Thank you.<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; 2013/4/17 =B7=FB=D3=C0=CC=CE &lt;<a href=3D"mailto:yongtaofu@gmail.com"=
 target=3D"_blank">yongtaofu@gmail.com</a><br>
</div>&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; &lt;mailto:<a href=3D"mailto:yongtaofu@gmail.com" target=3D"_blan=
k">yongtaofu@gmail.com</a>&gt;&gt;<br>
<div>&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; Hi Brain,<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; Thank you for your update, and I have applied<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; your last kernel patch. However it is not easy<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; to reproduce especially in out test<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; environment. Till now is not happens again.<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; I&#39;ll update the kernel patch now. BTW is there<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; any findings in the logs of previous thread?<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; <a href=3D"http://oss.sgi.com/archives/xfs/2013-04/msg003=
27.html" target=3D"_blank">http://oss.sgi.com/archives/xfs/2013-04/msg00327=
.html</a><br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; I guess it tend to happen during glusterfs<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; rebalance because glusterfs moves a lot of<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; file from one server to another and then<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; unlink it.<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; Thank you.<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; 2013/4/17 Brian Foster &lt;<a href=3D"mailto:bfoster@redh=
at.com" target=3D"_blank">bfoster@redhat.com</a><br>
</div>&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:bfoster@redhat.com" ta=
rget=3D"_blank">bfoster@redhat.com</a>&gt;&gt;<br>
<div><div>&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; On 04/16/2013 12:24 PM, Dave Chinner wrote:=
<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; On Mon, Apr 15, 2013 at 07:14:39PM<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; -0400, Brian Foster wrote:<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; Hi,<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; Thanks for the data in the previou=
s thread:<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; <a href=3D"http://oss.sgi.com/archives/xfs/=
2013-04/msg00327.html" target=3D"_blank">http://oss.sgi.com/archives/xfs/20=
13-04/msg00327.html</a><br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; ...<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp;echo 1 &gt;<br=
>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; /sys/kernel/debug/tracing/events/xfs/xfs_iu=
nlink/enable<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp;echo 1 &gt;<br=
>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; /sys/kernel/debug/tracing/events/xfs/xfs_iu=
nlink_remove/enable<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp;... reproduce =
...<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp;cat<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; /sys/kernel/debug/tracing/trace &gt; trace.=
output<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; It&#39;s better to use trace-cmd for t=
his.<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; it will result in less<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; dropped events. i.e.:<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; $ trace-cmd recor=
d -e xfs_iunlink\*<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; ... reproduce ...=
<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; ^C<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; $ trace-cmd repor=
t &gt; trace.output<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; --- a/fs/xfs/linux-2.6/xfs_trace.h=
<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; +++ b/fs/xfs/linux-2.6/xfs_trace.h=
<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; @@ -581,6 +581,8 @@<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; DEFINE_INODE_EVENT(xfs_file_fsync);<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; ...<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; I would suggest that the the tracing<b=
r>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; shoul dbe at entry of the<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; function, otherwise we won&#39;t get a=
<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; tracepoint for the operation that<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; triggers the shutdown. (That&#39;s the=
<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; reason most tracepoints in XFS<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; are at function entry...)<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; Good points, thanks Dave. A v2 that pulls<b=
r>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; up the tracepoints towards<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; function entry is appended.<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; Brian<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; From<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; 280943e78ebe0b97a774cba51e7815c42f044b55<br=
>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; Mon Sep 17 00:00:00 2001<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; From: Brian Foster &lt;<a href=3D"mailto:bf=
oster@redhat.com" target=3D"_blank">bfoster@redhat.com</a><br>
</div></div>&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:bf=
oster@redhat.com" target=3D"_blank">bfoster@redhat.com</a>&gt;&gt;<br>
<div><div>&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Date: Mon, 15 Apr 2013 18:16:24 -=
0400<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; Subject: [PATCH v2] xfs: add tracepoints<br=
>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; for xfs_iunlink and<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; xfs_iunlink_remove<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; ---<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;fs/xfs/linux-2.6/xfs_trace.h | &nbsp;=
 &nbsp;2 ++<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;fs/xfs/xfs_inode.c &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; | &nbsp; &nbsp;4 ++++<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;2 files changed, 6 insertions(+), 0<b=
r>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; deletions(-)<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; diff --git a/fs/xfs/linux-2.6/xfs_trace.h<b=
r>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; b/fs/xfs/linux-2.6/xfs_trace.h<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; index adc6ec4..338a0f9 100644<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; --- a/fs/xfs/linux-2.6/xfs_trace.h<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; +++ b/fs/xfs/linux-2.6/xfs_trace.h<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; @@ -583,6 +583,8 @@<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; DEFINE_INODE_EVENT(xfs_file_fsync);<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;DEFINE_INODE_EVENT(xfs_destroy_inode)=
;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;DEFINE_INODE_EVENT(xfs_dirty_inode);<=
br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;DEFINE_INODE_EVENT(xfs_clear_inode);<=
br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; +DEFINE_INODE_EVENT(xfs_iunlink);<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; +DEFINE_INODE_EVENT(xfs_iunlink_remove);<br=
>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;DEFINE_INODE_EVENT(xfs_dquot_dqalloc)=
;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;DEFINE_INODE_EVENT(xfs_dquot_dqdetach=
);<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; diff --git a/fs/xfs/xfs_inode.c<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; b/fs/xfs/xfs_inode.c<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; index 19900f0..d705c77 100644<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; --- a/fs/xfs/xfs_inode.c<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; +++ b/fs/xfs/xfs_inode.c<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; @@ -1615,6 +1615,8 @@ xfs_iunlink(<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; mp =3D tp-&gt;t=
_mountp;<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; trace_xfs_iunlink(ip=
);<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; +<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; /*<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;* Get the=
 agi buffer first. &nbsp;It<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; ensures lock ordering<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;* on the =
list.<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; @@ -1694,6 +1696,8 @@ xfs_iunlink_remove(<b=
r>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; mp =3D tp-&gt;t=
_mountp;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; agno =3D XFS_IN=
O_TO_AGNO(mp, ip-&gt;i_ino);<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; trace_xfs_iunlink_re=
move(ip);<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; +<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; /*<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;* Get the=
 agi buffer first. &nbsp;It<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; ensures lock ordering<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;* on the =
list.<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; --<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; 1.7.7.6<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; --<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; =B7=FB=D3=C0=CC=CE<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; --<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; =B7=FB=D3=C0=CC=CE<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; --<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =B7=FB=D3=
=C0=CC=CE<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; --<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =B7=FB=D3=C0=CC=CE<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ________________________=
_______________________<br>
&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; xfs mailing list<br>
</div></div>&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <a href=3D"m=
ailto:xfs@oss.sgi.com" target=3D"_blank">xfs@oss.sgi.com</a> &lt;mailto:<a =
href=3D"mailto:xfs@oss.sgi.com" target=3D"_blank">xfs@oss.sgi.com</a>&gt;<b=
r>
<div><div>&gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <a href=3D"htt=
p://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">http://oss.sgi.com/=
mailman/listinfo/xfs</a><br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; --<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; =B7=FB=D3=C0=CC=CE<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; &nbsp; &nbsp; --<br>
&gt; &nbsp; &nbsp; =B7=FB=D3=C0=CC=CE<br>
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

--001a11c1ed324410cd04daa54432--


--===============1734490286251918894==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1734490286251918894==--
