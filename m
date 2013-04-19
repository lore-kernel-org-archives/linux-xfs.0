Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 844417CBF
	for <xfs@oss.sgi.com>; Fri, 19 Apr 2013 01:40:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6421D304067
	for <xfs@oss.sgi.com>; Thu, 18 Apr 2013 23:40:25 -0700 (PDT)
Received: from mail-ie0-f169.google.com (mail-ie0-f169.google.com
	[209.85.223.169]) by cuda.sgi.com with ESMTP id
	LdjjQ3fSmZhwBjlJ (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 18 Apr 2013 23:40:21 -0700 (PDT)
Received: by mail-ie0-f169.google.com with SMTP id ar20so4422725iec.0
	for <xfs@oss.sgi.com>; Thu, 18 Apr 2013 23:40:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51705EC4.4000306@redhat.com>
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
Date: Fri, 19 Apr 2013 14:40:21 +0800
Message-ID: <CADFMGu+hPV9RanG7298TAYY4p9gMiBOk0+mq5gf5rhQUWXf4TQ@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============0185865795562697769=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============0185865795562697769==
Content-Type: multipart/alternative; boundary=14dae9340b5f3ba92504dab0fe1f

--14dae9340b5f3ba92504dab0fe1f
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

Hi Brian and Eric,

I have applied your kernel path v2(add unlink trace) to
kernel-2.6.32-279.19.1.el6.x86_64.rpm<http://mirror.linux.duke.edu/pub/cent=
os/6.3/updates/x86_64/Packages/kernel-2.6.32-279.19.1.el6.x86_64.rpm>in
out test cluster and start testing again.
Any progress will let you known. Thank you.


2013/4/19 Brian Foster <bfoster@redhat.com>

> On 04/18/2013 11:23 AM, =B7=FB=D3=C0=CC=CE wrote:
> > Hi Brian and Eric,
> > The shutdown is not easy to produce but finally right now 2 of our
> > servers in our test cluster xfs was shutdown.
> >
>
> Understood. We've been trying very hard to reproduce ourselves to make
> it easier to debug, but haven't been able to reproduce at all so far.
> This process allows us to make _some_ progress on the issue, even if it
> is slower going than we'd like... ;)
>
> > the trace output as following
> >
> https://docs.google.com/file/d/0B7n2C4T5tfNCLXRYUWJ0b19JcWc/edit?usp=3Dsh=
aring
> >
>
> Thanks again for the data. The racing behavior Eric called out (nice
> catch!) in his last mail lit up some light bulbs internally with regard
> to some old locking issues triggered by XFS in the 6.3 kernel. The
> following bug serves as an example:
>
> https://bugzilla.redhat.com/show_bug.cgi?id=3D852847
>
> ... the fix for which went into the 2.6.32-279.19.1 6.3.z release. Could
> you move some or all of your servers to this kernel[1] and see how it
> goes? The best case is it resolves the problem, worst case we carry on
> debugging from there...
>
> Brian
>
> [1] -
>
> http://mirror.linux.duke.edu/pub/centos/6.3/updates/x86_64/Packages/kerne=
l-2.6.32-279.19.1.el6.x86_64.rpm
>
> > Sorry but the systemtap is interrupt and I didn't noticed that so I
> > didn't get systemtap logs.
> >
> > /var/log/message is same as before
> > Apr 18 22:43:14 10 kernel: XFS (sdb): xfs_iunlink_remove: xfs_inotobp()
> > returned error 22.
> > Apr 18 22:43:14 10 kernel: XFS (sdb): xfs_inactive: xfs_ifree returned
> > error 22
> > Apr 18 22:43:14 10 kernel: XFS (sdb): xfs_do_force_shutdown(0x1) called
> > from line 1184 of file fs/xfs/xfs_vnodeops.c.  Return address =3D
> > 0xffffffffa02d44aa
> > Apr 18 22:43:14 10 kernel: XFS (sdb): I/O Error Detected. Shutting down
> > filesystem
> > Apr 18 22:43:14 10 kernel: XFS (sdb): Please umount the filesystem and
> > rectify the problem(s)
> > Apr 18 22:43:20 10 kernel: XFS (sdb): xfs_log_force: error 5 returned.
> >
> > The metadump file is large I'll share it to you soon.
> >
> >
> > 2013/4/18 Brian Foster <bfoster@redhat.com <mailto:bfoster@redhat.com>>
> >
> >     On 04/18/2013 04:25 AM, =B7=FB=D3=C0=CC=CE wrote:
> >     > Hi Brian and Eric,
> >     > Can I change as following to bypass it?
> >
> >     This is probably not a wise thing to do. The problem we're seeing
> here
> >     is indicative of a potentially larger problem than this particular
> error
> >     path. An inode is being unlinked and inactivated, but we aren't
> finding
> >     on the list where we expect it to be. Killing the error return
> doesn't
> >     eliminate the larger problem.
> >
> >     So while changes could end up being made in this area as part of a
> fix,
> >     I would not suggest making any changes beyond those designed to hel=
p
> >     debug until we have a better idea of root cause.
> >
> >     Brian
> >
> >     > --- a/xfs_inode.c
> >     > +++ b/xfs_inode.c
> >     > @@ -1764,7 +1764,7 @@ xfs_iunlink_remove(
> >     >                  */
> >     >                 next_agino =3D
> >     be32_to_cpu(agi->agi_unlinked[bucket_index]);
> >     >                 last_ibp =3D NULL;
> >     > -               while (next_agino !=3D agino) {
> >     > +               while (next_agino !=3D agino && next_agino !=3D
> >     NULLAGINO) {
> >     >                         /*
> >     >                          * If the last inode wasn't the one
> >     pointing to
> >     >                          * us, then release its buffer since we'r=
e
> not
> >     > @@ -1786,6 +1786,14 @@ xfs_iunlink_remove(
> >     >                         ASSERT(next_agino !=3D NULLAGINO);
> >     >                         ASSERT(next_agino !=3D 0);
> >     >                 }
> >     > +               if (next_agino =3D=3D NULLAGINO) {
> >     > +                       /*
> >     > +                        *After search the list for the inode
> >     being free
> >     > +                        *we still can't find it.
> >     > +                        */
> >     > +                       xfs_err(mp, "%s ino %lld not found in
> unlinked
> >     > list.",
> >     > +                                    __func__, (unsigned long
> >     > long)ip->i_ino);
> >     > +               }
> >     >                 /*
> >     >                  * Now last_ibp points to the buffer previous to
> us on
> >     >                  * the unlinked list.  Pull us from the list.
> >     > @@ -1810,16 +1818,20 @@ xfs_iunlink_remove(
> >     >                 } else {
> >     >                         xfs_trans_brelse(tp, ibp);
> >     >                 }
> >     > -               /*
> >     > -                * Point the previous inode on the list to the
> >     next inode.
> >     > -                */
> >     > -               last_dip->di_next_unlinked =3D
> cpu_to_be32(next_agino);
> >     > -               ASSERT(next_agino !=3D 0);
> >     > -               offset =3D last_offset + offsetof(xfs_dinode_t,
> >     > di_next_unlinked);
> >     > -               xfs_trans_inode_buf(tp, last_ibp);
> >     > -               xfs_trans_log_buf(tp, last_ibp, offset,
> >     > -                                 (offset + sizeof(xfs_agino_t) -
> 1));
> >     > -               xfs_inobp_check(mp, last_ibp);
> >     > +               if (next_agino !=3D NULLAGINO) {
> >     > +                       /*
> >     > +                       * If only find the inode being free then
> >     we modify
> >     > +                       * the unlinked list.
> >     > +                       * Point the previous inode on the list to
> the
> >     > next inode.
> >     > +                       */
> >     > +                       last_dip->di_next_unlinked =3D
> >     > cpu_to_be32(next_agino);
> >     > +                       ASSERT(next_agino !=3D 0);
> >     > +                       offset =3D last_offset +
> offsetof(xfs_dinode_t,
> >     > di_next_unlinked);
> >     > +                       xfs_trans_inode_buf(tp, last_ibp);
> >     > +                       xfs_trans_log_buf(tp, last_ibp, offset,
> >     > +                                         (offset +
> >     sizeof(xfs_agino_t)
> >     > - 1));
> >     > +                       xfs_inobp_check(mp, last_ibp);
> >     > +               }
> >     >         }
> >     >         return 0;
> >     >  }
> >     >
> >     > Thank you.
> >     >
> >     >
> >     > 2013/4/18 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com <mailto:yongtao=
fu@gmail.com>
> >     <mailto:yongtaofu@gmail.com <mailto:yongtaofu@gmail.com>>>
> >     >
> >     >     Hi Brain and Eric,
> >     >     If the problem is the agno can't be found in the unlinked
> >     list. Can
> >     >     we just bypass it instead of passing ino=3D0xffffffff to
> >     xfs_inotobp?
> >     >     Thank you.
> >     >
> >     >
> >     >     2013/4/18 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com
> >     <mailto:yongtaofu@gmail.com> <mailto:yongtaofu@gmail.com
> >     <mailto:yongtaofu@gmail.com>>>
> >     >
> >     >         Hi Eric,
> >     >         The shutdown issue is still not reproduced yet. But I get
> the
> >     >         following error today during test.
> >     >
> >     >         Apr 18 07:42:51 10 kernel: Call Trace:
> >     >         Apr 18 07:42:51 10 kernel: [<ffffffffa02d91ef>] ?
> >     >         xfs_buf_cond_lock+0x2f/0xc0 [xfs]
> >     >         Apr 18 07:42:51 10 kernel: [<ffffffff814fe6a5>]
> >     >         schedule_timeout+0x215/0x2e0
> >     >         Apr 18 07:42:51 10 kernel: [<ffffffffa02d5f07>] ?
> >     >         kmem_zone_alloc+0x77/0xf0 [xfs]
> >     >         Apr 18 07:42:51 10 kernel: [<ffffffff814ff5c2>]
> >     __down+0x72/0xb0
> >     >         Apr 18 07:42:51 10 kernel: [<ffffffffa02da652>] ?
> >     >         _xfs_buf_find+0x102/0x280 [xfs]
> >     >         Apr 18 07:42:51 10 kernel: "echo 0 >
> >     >         /proc/sys/kernel/hung_task_timeout_secs" disables this
> >     message.
> >     >         Apr 18 07:42:51 10 kernel: glusterfsd    D ffffffff8160b3=
c0
> >     >         0 14522      1 0x00000083
> >     >         Apr 18 07:42:51 10 kernel: ffff882015a63a28
> 0000000000000082
> >     >         0000000000000000 0000000000000000
> >     >         Apr 18 07:42:51 10 kernel: ffff882015a639b8
> ffffffffa02d91ef
> >     >         ffff882015a639d8 0000000000000246
> >     >         Apr 18 07:42:51 10 kernel: ffff880e70491af8
> ffff882015a63fd8
> >     >         000000000000fb88 ffff880e70491af8
> >     >         Apr 18 07:42:51 10 kernel: Call Trace:
> >     >         Apr 18 07:42:51 10 kernel: [<ffffffffa02d91ef>] ?
> >     >         xfs_buf_cond_lock+0x2f/0xc0 [xfs]
> >     >         Apr 18 07:42:51 10 kernel: [<ffffffff814fe6a5>]
> >     >         schedule_timeout+0x215/0x2e0
> >     >         Apr 18 07:42:51 10 kernel: [<ffffffffa02d5f07>] ?
> >     >         kmem_zone_alloc+0x77/0xf0 [xfs]
> >     >         Apr 18 07:42:51 10 kernel: [<ffffffff814ff5c2>]
> >     __down+0x72/0xb0
> >     >         Apr 18 07:42:51 10 kernel: [<ffffffffa02da652>] ?
> >     >         _xfs_buf_find+0x102/0x280 [xfs]
> >     >         Apr 18 07:42:51 10 kernel: [<ffffffff81097ef1>]
> down+0x41/0x50
> >     >         Apr 18 07:42:51 10 kernel: [<ffffffffa02da493>]
> >     >         xfs_buf_lock+0x53/0x110 [xfs]
> >     >         Apr 18 07:42:51 10 kernel: [<ffffffffa02da652>]
> >     >         _xfs_buf_find+0x102/0x280 [xfs]
> >     >         Apr 18 07:42:51 10 kernel: [<ffffffffa02da83b>]
> >     >         xfs_buf_get+0x6b/0x1a0 [xfs]
> >     >         Apr 18 07:42:51 10 kernel: [<ffffffffa02daeac>]
> >     >         xfs_buf_read+0x2c/0x100 [xfs]
> >     >         Apr 18 07:42:51 10 kernel: [<ffffffffa02d0af8>]
> >     >         xfs_trans_read_buf+0x1f8/0x400 [xfs]
> >     >         Apr 18 07:42:51 10 kernel: [<ffffffffa02b3444>]
> >     >         xfs_read_agi+0x74/0x100 [xfs]
> >     >         Apr 18 07:42:51 10 kernel: [<ffffffffa02b967b>]
> >     >         xfs_iunlink+0x5b/0x180 [xfs]
> >     >         Apr 18 07:42:51 10 kernel: [<ffffffff810724c7>] ?
> >     >         current_fs_time+0x27/0x30
> >     >         Apr 18 07:42:51 10 kernel: [<ffffffffa02d12a7>] ?
> >     >         xfs_trans_ichgtime+0x27/0xa0 [xfs]
> >     >         Apr 18 07:42:51 10 kernel: [<ffffffffa02d15fb>]
> >     >         xfs_droplink+0x5b/0x70 [xfs]
> >     >         Apr 18 07:42:51 10 kernel: [<ffffffffa02d2f9e>]
> >     >         xfs_remove+0x27e/0x3a0 [xfs]
> >     >         Apr 18 07:42:51 10 kernel: [<ffffffff81186fd3>] ?
> >     >         generic_permission+0x23/0xb0
> >     >         Apr 18 07:42:51 10 kernel: [<ffffffffa02e0968>]
> >     >         xfs_vn_unlink+0x48/0x90 [xfs]
> >     >         Apr 18 07:42:51 10 kernel: [<ffffffff81188c0f>]
> >     vfs_unlink+0x9f/0xe0
> >     >         Apr 18 07:42:51 10 kernel: [<ffffffff8118795a>] ?
> >     >         lookup_hash+0x3a/0x50
> >     >         Apr 18 07:42:51 10 kernel: [<ffffffff8118b143>]
> >     >         do_unlinkat+0x183/0x1c0
> >     >         Apr 18 07:42:51 10 kernel: [<ffffffff81017938>] ?
> >     >         syscall_trace_enter+0x1d8/0x1e0
> >     >         Apr 18 07:42:51 10 kernel: [<ffffffff8118b196>]
> >     sys_unlink+0x16/0x20
> >     >         Apr 18 07:42:51 10 kernel: [<ffffffff8100b308>]
> >     tracesys+0xd9/0xde
> >     >
> >     >         Thank you.
> >     >
> >     >
> >     >         2013/4/17 Eric Sandeen <sandeen@sandeen.net
> >     <mailto:sandeen@sandeen.net>
> >     >         <mailto:sandeen@sandeen.net <mailto:sandeen@sandeen.net>>=
>
> >     >
> >     >             On Apr 16, 2013, at 8:48 PM, =B7=FB=D3=C0=CC=CE
> >     <yongtaofu@gmail.com <mailto:yongtaofu@gmail.com>
> >     >             <mailto:yongtaofu@gmail.com
> >     <mailto:yongtaofu@gmail.com>>> wrote:
> >     >
> >     >>             Hi Brain,
> >     >>             Can I change as following?
> >     >
> >     >             ASSERTS are no-ops in a non-debug kernel, so this won=
't
> >     >             change any behavior.  I hope we'll know more if we ge=
t
> new
> >     >             traces from your patched kernel....
> >     >
> >     >             Eric
> >     >
> >     >>             --- a/xfs_inode.c
> >     >>             +++ b/xfs_inode.c
> >     >>             @@ -1773,6 +1773,8 @@ xfs_iunlink_remove(
> >     >>                                     if (last_ibp !=3D NULL) {
> >     >>                                             xfs_trans_brelse(tp,
> >     >>             last_ibp);
> >     >>                                     }
> >     >>             +                        ASSERT(next_agino !=3D
> NULLAGINO);
> >     >>             +                        ASSERT(next_agino !=3D 0);
> >     >>                                     next_ino =3D
> XFS_AGINO_TO_INO(mp,
> >     >>             agno, next_agino);
> >     >>                                     error =3D xfs_inotobp(mp, tp=
,
> >     >>             next_ino, &last_dip,
> >     >>                                                         &last_ib=
p,
> >     >>             &last_offset, 0);
> >     >>             @@ -1783,8 +1785,6 @@ xfs_iunlink_remove(
> >     >>                                             return error;
> >     >>                                     }
> >     >>                                     next_agino =3D
> >     >>             be32_to_cpu(last_dip->di_next_unlinked);
> >     >>             -                       ASSERT(next_agino !=3D
> NULLAGINO);
> >     >>             -                       ASSERT(next_agino !=3D 0);
> >     >>                             }
> >     >>                             /*
> >     >>                              * Now last_ibp points to the buffer
> >     >>             previous to us on
> >     >>
> >     >>             Thank you.
> >     >>
> >     >>
> >     >>             2013/4/17 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com
> >     <mailto:yongtaofu@gmail.com>
> >     >>             <mailto:yongtaofu@gmail.com
> >     <mailto:yongtaofu@gmail.com>>>
> >     >>
> >     >>                 Hi Brain,
> >     >>                 If it is because NULLAGINO is passed in  to
> >     xfs_inotobp().
> >     >>                 Can I move the following two lines before
> >     xfs_inotobp?
> >     >>
> >     >>                 For example:
> >     >>
> >     >>                 1767                 while (next_agino !=3D agin=
o) {
> >     >>                 1768                         /*
> >     >>                 1769                          * If the last inod=
e
> >     >>                 wasn't the one pointing to
> >     >>                 1770                          * us, then release
> its
> >     >>                 buffer since we're not
> >     >>                 1771                          * going to do
> anything
> >     >>                 with it.
> >     >>                 1772                          */
> >     >>                 1773                         if (last_ibp !=3D
> NULL) {
> >     >>                 1774
> >     >>                 xfs_trans_brelse(tp, last_ibp);
> >     >>                 1775                         }
> >     >>                 1776                         next_ino =3D
> >     >>                 XFS_AGINO_TO_INO(mp, agno, next_agino);
> >     >>                 +                               ASSERT(next_agin=
o
> !=3D
> >     >>                 NULLAGINO);
> >     >>                 +                               ASSERT(next_agin=
o
> >     !=3D 0);
> >     >>                 1777                         error =3D
> xfs_inotobp(mp,
> >     >>                 tp, next_ino, &last_dip,
> >     >>                 1778
> >     >>                 &last_ibp, &last_offset, 0);
> >     >>                 1779                         if (error) {
> >     >>                 1780                                 xfs_warn(mp=
,
> >     >>                 1781                                         "%s=
:
> >     >>                 xfs_inotobp() returned error %d.",
> >     >>                 1782
> >     __func__,
> >     >>                 error);
> >     >>                 1783                                 return erro=
r;
> >     >>                 1784                         }
> >     >>                 1785                         next_agino =3D
> >     >>                 be32_to_cpu(last_dip->di_next_unlinked);
> >     >>                 -
> >     //ASSERT(next_agino !=3D
> >     >>                 NULLAGINO);
> >     >>                 -
> >     //ASSERT(next_agino !=3D 0);
> >     >>                 1788                 }
> >     >>                 I don't understand xfs well and correct me if I'=
m
> >     >>                 totally wrong.
> >     >>                 Thank you very much.
> >     >>
> >     >>
> >     >>                 2013/4/17 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.co=
m
> >     <mailto:yongtaofu@gmail.com>
> >     >>                 <mailto:yongtaofu@gmail.com
> >     <mailto:yongtaofu@gmail.com>>>
> >     >>
> >     >>                     Hi Brain,
> >     >>                     I want to ask a question, according to the
> >     >>                     shutdown trace. The ino in  xfs_iunlink_remo=
ve
> >     >>                     is 0x113, why xfs_imap got ino=3D0xffffffff =
?
> >     >>
> >     >>                     --- xfs_imap --
> >     >>
> >     module("xfs").function("xfs_imap@fs/xfs/xfs_ialloc.c:1257").return
> >     >>                     -- return=3D0x16
> >     >>                     vars: mp=3D0xffff882017a50800
> tp=3D0xffff881c81797c70
> >     >>                     ino=3D0xffffffff
> >     >>
> >     >>                     --- xfs_iunlink_remove --
> >     >>
> >     module("xfs").function("xfs_iunlink_remove@fs
> /xfs/xfs_inode.c:1680").return
> >     >>                     -- return=3D0x16
> >     >>                     vars: tp=3D0xffff881c81797c70
> ip=3D0xffff881003c13c00
> >     >>                     next_ino=3D? mp=3D? agi=3D? dip=3D?
> >     >>                     agibp=3D0xffff880109b47e20 ibp=3D? agno=3D? =
agino=3D?
> >     >>                     next_agino=3D? last_ibp=3D?
> >     >>                     last_dip=3D0xffff882000000000 bucket_index=
=3D?
> >     >>                     offset=3D? last_offset=3D0xffffffffffff8810
> error=3D?
> >     >>                     __func__=3D[...]
> >     >>                     ip: i_ino =3D 0x113, i_flags =3D 0x0
> >     >>
> >     >>                     Thank you.
> >     >>
> >     >>
> >     >>
> >     >>                     2013/4/17 =B7=FB=D3=C0=CC=CE <yongtaofu@gmai=
l.com
> >     <mailto:yongtaofu@gmail.com>
> >     >>                     <mailto:yongtaofu@gmail.com
> >     <mailto:yongtaofu@gmail.com>>>
> >     >>
> >     >>                         Hi Brain,
> >     >>                         Thank you for your update, and I have
> applied
> >     >>                         your last kernel patch. However it is no=
t
> >     easy
> >     >>                         to reproduce especially in out test
> >     >>                         environment. Till now is not happens
> again.
> >     >>                         I'll update the kernel patch now. BTW is
> >     there
> >     >>                         any findings in the logs of previous
> thread?
> >     >>
> >     http://oss.sgi.com/archives/xfs/2013-04/msg00327.html
> >     >>                         I guess it tend to happen during gluster=
fs
> >     >>                         rebalance because glusterfs moves a lot =
of
> >     >>                         file from one server to another and then
> >     >>                         unlink it.
> >     >>
> >     >>                         Thank you.
> >     >>
> >     >>
> >     >>                         2013/4/17 Brian Foster
> >     <bfoster@redhat.com <mailto:bfoster@redhat.com>
> >     >>                         <mailto:bfoster@redhat.com
> >     <mailto:bfoster@redhat.com>>>
> >     >>
> >     >>                             On 04/16/2013 12:24 PM, Dave Chinner
> >     wrote:
> >     >>                             > On Mon, Apr 15, 2013 at 07:14:39PM
> >     >>                             -0400, Brian Foster wrote:
> >     >>                             >> Hi,
> >     >>                             >>
> >     >>                             >> Thanks for the data in the
> >     previous thread:
> >     >>                             >>
> >     >>                             >>
> >     >>
> >     http://oss.sgi.com/archives/xfs/2013-04/msg00327.html
> >     >>                             >>
> >     >>                             ...
> >     >>                             >>
> >     >>                             >>      echo 1 >
> >     >>
> >     /sys/kernel/debug/tracing/events/xfs/xfs_iunlink/enable
> >     >>                             >>      echo 1 >
> >     >>
> >     /sys/kernel/debug/tracing/events/xfs/xfs_iunlink_remove/enable
> >     >>                             >>      ... reproduce ...
> >     >>                             >>      cat
> >     >>                             /sys/kernel/debug/tracing/trace >
> >     trace.output
> >     >>                             >
> >     >>                             > It's better to use trace-cmd for
> this.
> >     >>                             it will result in less
> >     >>                             > dropped events. i.e.:
> >     >>                             >
> >     >>                             >       $ trace-cmd record -e
> >     xfs_iunlink\*
> >     >>                             >       ... reproduce ...
> >     >>                             >       ^C
> >     >>                             >       $ trace-cmd report >
> trace.output
> >     >>                             >
> >     >>                             >> --- a/fs/xfs/linux-2.6/xfs_trace.=
h
> >     >>                             >> +++ b/fs/xfs/linux-2.6/xfs_trace.=
h
> >     >>                             >> @@ -581,6 +581,8 @@
> >     >>                             DEFINE_INODE_EVENT(xfs_file_fsync);
> >     >>                             ...
> >     >>                             >
> >     >>                             > I would suggest that the the traci=
ng
> >     >>                             shoul dbe at entry of the
> >     >>                             > function, otherwise we won't get a
> >     >>                             tracepoint for the operation that
> >     >>                             > triggers the shutdown. (That's the
> >     >>                             reason most tracepoints in XFS
> >     >>                             > are at function entry...)
> >     >>                             >
> >     >>
> >     >>                             Good points, thanks Dave. A v2 that
> pulls
> >     >>                             up the tracepoints towards
> >     >>                             function entry is appended.
> >     >>
> >     >>                             Brian
> >     >>
> >     >>                             From
> >     >>
> 280943e78ebe0b97a774cba51e7815c42f044b55
> >     >>                             Mon Sep 17 00:00:00 2001
> >     >>                             From: Brian Foster
> >     <bfoster@redhat.com <mailto:bfoster@redhat.com>
> >     >>                             <mailto:bfoster@redhat.com
> >     <mailto:bfoster@redhat.com>>>
> >     >>                             Date: Mon, 15 Apr 2013 18:16:24 -040=
0
> >     >>                             Subject: [PATCH v2] xfs: add
> tracepoints
> >     >>                             for xfs_iunlink and
> >     >>                             xfs_iunlink_remove
> >     >>
> >     >>                             ---
> >     >>                              fs/xfs/linux-2.6/xfs_trace.h |    2
> ++
> >     >>                              fs/xfs/xfs_inode.c           |    4
> ++++
> >     >>                              2 files changed, 6 insertions(+), 0
> >     >>                             deletions(-)
> >     >>
> >     >>                             diff --git
> a/fs/xfs/linux-2.6/xfs_trace.h
> >     >>                             b/fs/xfs/linux-2.6/xfs_trace.h
> >     >>                             index adc6ec4..338a0f9 100644
> >     >>                             --- a/fs/xfs/linux-2.6/xfs_trace.h
> >     >>                             +++ b/fs/xfs/linux-2.6/xfs_trace.h
> >     >>                             @@ -583,6 +583,8 @@
> >     >>                             DEFINE_INODE_EVENT(xfs_file_fsync);
> >     >>
>  DEFINE_INODE_EVENT(xfs_destroy_inode);
> >     >>                              DEFINE_INODE_EVENT(xfs_dirty_inode)=
;
> >     >>                              DEFINE_INODE_EVENT(xfs_clear_inode)=
;
> >     >>                             +DEFINE_INODE_EVENT(xfs_iunlink);
> >     >>
> +DEFINE_INODE_EVENT(xfs_iunlink_remove);
> >     >>
> >     >>
>  DEFINE_INODE_EVENT(xfs_dquot_dqalloc);
> >     >>
>  DEFINE_INODE_EVENT(xfs_dquot_dqdetach);
> >     >>                             diff --git a/fs/xfs/xfs_inode.c
> >     >>                             b/fs/xfs/xfs_inode.c
> >     >>                             index 19900f0..d705c77 100644
> >     >>                             --- a/fs/xfs/xfs_inode.c
> >     >>                             +++ b/fs/xfs/xfs_inode.c
> >     >>                             @@ -1615,6 +1615,8 @@ xfs_iunlink(
> >     >>
> >     >>                                     mp =3D tp->t_mountp;
> >     >>
> >     >>                             +       trace_xfs_iunlink(ip);
> >     >>                             +
> >     >>                                     /*
> >     >>                                      * Get the agi buffer first.
>  It
> >     >>                             ensures lock ordering
> >     >>                                      * on the list.
> >     >>                             @@ -1694,6 +1696,8 @@
> xfs_iunlink_remove(
> >     >>                                     mp =3D tp->t_mountp;
> >     >>                                     agno =3D XFS_INO_TO_AGNO(mp,
> >     ip->i_ino);
> >     >>
> >     >>                             +       trace_xfs_iunlink_remove(ip)=
;
> >     >>                             +
> >     >>                                     /*
> >     >>                                      * Get the agi buffer first.
>  It
> >     >>                             ensures lock ordering
> >     >>                                      * on the list.
> >     >>                             --
> >     >>                             1.7.7.6
> >     >>
> >     >>
> >     >>
> >     >>
> >     >>                         --
> >     >>                         =B7=FB=D3=C0=CC=CE
> >     >>
> >     >>
> >     >>
> >     >>
> >     >>                     --
> >     >>                     =B7=FB=D3=C0=CC=CE
> >     >>
> >     >>
> >     >>
> >     >>
> >     >>                 --
> >     >>                 =B7=FB=D3=C0=CC=CE
> >     >>
> >     >>
> >     >>
> >     >>
> >     >>             --
> >     >>             =B7=FB=D3=C0=CC=CE
> >     >>             _______________________________________________
> >     >>             xfs mailing list
> >     >>             xfs@oss.sgi.com <mailto:xfs@oss.sgi.com>
> >     <mailto:xfs@oss.sgi.com <mailto:xfs@oss.sgi.com>>
> >     >>             http://oss.sgi.com/mailman/listinfo/xfs
> >     >
> >     >
> >     >
> >     >
> >     >         --
> >     >         =B7=FB=D3=C0=CC=CE
> >     >
> >     >
> >     >
> >     >
> >     >     --
> >     >     =B7=FB=D3=C0=CC=CE
> >     >
> >     >
> >     >
> >     >
> >     > --
> >     > =B7=FB=D3=C0=CC=CE
> >
> >
> >
> >
> > --
> > =B7=FB=D3=C0=CC=CE
>
>


--=20
=B7=FB=D3=C0=CC=CE

--14dae9340b5f3ba92504dab0fe1f
Content-Type: text/html; charset=GB2312
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div>Hi Brian and Eric,<br><br></div>I have applied y=
our kernel path v2(add unlink trace) to <a href=3D"http://mirror.linux.duke=
.edu/pub/centos/6.3/updates/x86_64/Packages/kernel-2.6.32-279.19.1.el6.x86_=
64.rpm" target=3D"_blank">kernel-2.6.32-279.19.1.el6.x86_64.rpm</a> in out =
test cluster and start testing again.<br>
</div>Any progress will let you known. Thank you.<br></div><div class=3D"gm=
ail_extra"><br><br><div class=3D"gmail_quote">2013/4/19 Brian Foster <span =
dir=3D"ltr">&lt;<a href=3D"mailto:bfoster@redhat.com" target=3D"_blank">bfo=
ster@redhat.com</a>&gt;</span><br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"im">On 04/18/2013 11:23 AM, =
=B7=FB=D3=C0=CC=CE wrote:<br>
&gt; Hi Brian and Eric,<br>
</div><div class=3D"im">&gt; The shutdown is not easy to produce but finall=
y right now 2 of our<br>
&gt; servers in our test cluster xfs was shutdown.<br>
&gt;<br>
<br>
</div>Understood. We&#39;ve been trying very hard to reproduce ourselves to=
 make<br>
it easier to debug, but haven&#39;t been able to reproduce at all so far.<b=
r>
This process allows us to make _some_ progress on the issue, even if it<br>
is slower going than we&#39;d like... ;)<br>
<div class=3D"im"><br>
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

<div class=3D"im"><br>
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
>bfoster@redhat.com</a> &lt;mailto:<a href=3D"mailto:bfoster@redhat.com">bf=
oster@redhat.com</a>&gt;&gt;<br>
<div><div class=3D"h5">&gt;<br>
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
yongtaofu@gmail.com">yongtaofu@gmail.com</a> &lt;mailto:<a href=3D"mailto:y=
ongtaofu@gmail.com">yongtaofu@gmail.com</a>&gt;<br>
</div></div>&gt; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:yongtaofu@gmail=
.com">yongtaofu@gmail.com</a> &lt;mailto:<a href=3D"mailto:yongtaofu@gmail.=
com">yongtaofu@gmail.com</a>&gt;&gt;&gt;<br>
<div class=3D"im">&gt; &nbsp; &nbsp; &gt;<br>
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
ref=3D"mailto:yongtaofu@gmail.com">yongtaofu@gmail.com</a><br>
</div>&gt; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:yongtaofu@gmail.com">=
yongtaofu@gmail.com</a>&gt; &lt;mailto:<a href=3D"mailto:yongtaofu@gmail.co=
m">yongtaofu@gmail.com</a><br>
<div><div class=3D"h5">&gt; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:yong=
taofu@gmail.com">yongtaofu@gmail.com</a>&gt;&gt;&gt;<br>
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
&lt;<a href=3D"mailto:sandeen@sandeen.net">sandeen@sandeen.net</a><br>
&gt; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:sandeen@sandeen.net">sandee=
n@sandeen.net</a>&gt;<br>
</div></div>&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &lt;mailto:=
<a href=3D"mailto:sandeen@sandeen.net">sandeen@sandeen.net</a> &lt;mailto:<=
a href=3D"mailto:sandeen@sandeen.net">sandeen@sandeen.net</a>&gt;&gt;&gt;<b=
r>
<div class=3D"im">&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; On Apr 16=
, 2013, at 8:48 PM, =B7=FB=D3=C0=CC=CE<br>
&gt; &nbsp; &nbsp; &lt;<a href=3D"mailto:yongtaofu@gmail.com">yongtaofu@gma=
il.com</a> &lt;mailto:<a href=3D"mailto:yongtaofu@gmail.com">yongtaofu@gmai=
l.com</a>&gt;<br>
</div>&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &lt=
;mailto:<a href=3D"mailto:yongtaofu@gmail.com">yongtaofu@gmail.com</a><br>
<div><div class=3D"h5">&gt; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:yong=
taofu@gmail.com">yongtaofu@gmail.com</a>&gt;&gt;&gt; wrote:<br>
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
4/17 =B7=FB=D3=C0=CC=CE &lt;<a href=3D"mailto:yongtaofu@gmail.com">yongtaof=
u@gmail.com</a><br>
&gt; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:yongtaofu@gmail.com">yongta=
ofu@gmail.com</a>&gt;<br>
</div></div>&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &lt;mailto:<a href=3D"mailto:yongtaofu@gmail.com">yongtaofu@gmail.co=
m</a><br>
<div><div class=3D"h5">&gt; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:yong=
taofu@gmail.com">yongtaofu@gmail.com</a>&gt;&gt;&gt;<br>
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
.com">yongtaofu@gmail.com</a><br>
&gt; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:yongtaofu@gmail.com">yongta=
ofu@gmail.com</a>&gt;<br>
</div></div>&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:yongtaofu@gmail.com">yong=
taofu@gmail.com</a><br>
<div class=3D"im">&gt; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:yongtaofu=
@gmail.com">yongtaofu@gmail.com</a>&gt;&gt;&gt;<br>
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
ongtaofu@gmail.com">yongtaofu@gmail.com</a><br>
&gt; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:yongtaofu@gmail.com">yongta=
ofu@gmail.com</a>&gt;<br>
</div>&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:yongtaofu@gmail.c=
om">yongtaofu@gmail.com</a><br>
<div class=3D"im">&gt; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:yongtaofu=
@gmail.com">yongtaofu@gmail.com</a>&gt;&gt;&gt;<br>
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
&gt; &nbsp; &nbsp; &lt;<a href=3D"mailto:bfoster@redhat.com">bfoster@redhat=
.com</a> &lt;mailto:<a href=3D"mailto:bfoster@redhat.com">bfoster@redhat.co=
m</a>&gt;<br>
</div>&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:bfo=
ster@redhat.com">bfoster@redhat.com</a><br>
<div><div class=3D"h5">&gt; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:bfos=
ter@redhat.com">bfoster@redhat.com</a>&gt;&gt;&gt;<br>
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
&gt; &nbsp; &nbsp; &lt;<a href=3D"mailto:bfoster@redhat.com">bfoster@redhat=
.com</a> &lt;mailto:<a href=3D"mailto:bfoster@redhat.com">bfoster@redhat.co=
m</a>&gt;<br>
</div></div>&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &lt;mailto:<=
a href=3D"mailto:bfoster@redhat.com">bfoster@redhat.com</a><br>
<div><div class=3D"h5">&gt; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:bfos=
ter@redhat.com">bfoster@redhat.com</a>&gt;&gt;&gt;<br>
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
ef=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a> &lt;mailto:<a href=3D"mai=
lto:xfs@oss.sgi.com">xfs@oss.sgi.com</a>&gt;<br>
</div></div>&gt; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:xfs@oss.sgi.com=
">xfs@oss.sgi.com</a> &lt;mailto:<a href=3D"mailto:xfs@oss.sgi.com">xfs@oss=
.sgi.com</a>&gt;&gt;<br>
<div class=3D"HOEnZb"><div class=3D"h5">&gt; &nbsp; &nbsp; &gt;&gt; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <a href=3D"http://oss.sgi.com/mailman/li=
stinfo/xfs" target=3D"_blank">http://oss.sgi.com/mailman/listinfo/xfs</a><b=
r>
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
</div></div></blockquote></div><br><br clear=3D"all"><br>-- <br>=B7=FB=D3=
=C0=CC=CE
</div>

--14dae9340b5f3ba92504dab0fe1f--


--===============0185865795562697769==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0185865795562697769==--
