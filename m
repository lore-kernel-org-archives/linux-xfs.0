Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F050029DFA
	for <xfs@oss.sgi.com>; Thu, 18 Apr 2013 03:25:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A24328F8037
	for <xfs@oss.sgi.com>; Thu, 18 Apr 2013 01:25:41 -0700 (PDT)
Received: from mail-ia0-f169.google.com (mail-ia0-f169.google.com
	[209.85.210.169]) by cuda.sgi.com with ESMTP id
	ig3GvPdzSOluRsuo (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 18 Apr 2013 01:25:38 -0700 (PDT)
Received: by mail-ia0-f169.google.com with SMTP id l29so1001025iag.0
	for <xfs@oss.sgi.com>; Thu, 18 Apr 2013 01:25:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADFMGuLDwde8te0Cs4-T9fdVmq2v22fmSTgkYbULHS3voHzw6A@mail.gmail.com>
References: <516C89DF.4070904@redhat.com> <20130416162417.GC13938@destitution>
	<516D87E3.2010605@redhat.com>
	<CADFMGuLgU2++ym4U9axhevV_L2t-2CMVaDoT5cyQcew2YZMsBA@mail.gmail.com>
	<CADFMGuK3cPSmqZoMdFSSqOnUz3GLv+c01xXHDhzv9_dfUNUPPA@mail.gmail.com>
	<CADFMGu+XD=-NJm3CAsnKpiMWykPj67t2LHgtxkPpyTpVmG3LDA@mail.gmail.com>
	<CADFMGu+z32O5mVBfO6gb8F03y9mrwB5=nf+7LMbky4ttk2mbFw@mail.gmail.com>
	<BA50C18A-BE51-4658-B05E-3EDB0F11BE36@sandeen.net>
	<CADFMGuKfXwY=Z9dg6+wyX7mKzppu1hQhsqxcr9Fd=DjP4hii9w@mail.gmail.com>
	<CADFMGuLDwde8te0Cs4-T9fdVmq2v22fmSTgkYbULHS3voHzw6A@mail.gmail.com>
Date: Thu, 18 Apr 2013 16:25:38 +0800
Message-ID: <CADFMGuKmmJCz+FxsFL9KegqzNhhHsG2ZbVjrwCDyNCh1R_Zgpw@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============2560478724826884747=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Brian Foster <bfoster@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============2560478724826884747==
Content-Type: multipart/alternative; boundary=089e0111e074e88d6304da9e5836

--089e0111e074e88d6304da9e5836
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

Hi Brian and Eric,
Can I change as following to bypass it?
--- a/xfs_inode.c
+++ b/xfs_inode.c
@@ -1764,7 +1764,7 @@ xfs_iunlink_remove(
                 */
                next_agino =3D be32_to_cpu(agi->agi_unlinked[bucket_index])=
;
                last_ibp =3D NULL;
-               while (next_agino !=3D agino) {
+               while (next_agino !=3D agino && next_agino !=3D NULLAGINO) =
{
                        /*
                         * If the last inode wasn't the one pointing to
                         * us, then release its buffer since we're not
@@ -1786,6 +1786,14 @@ xfs_iunlink_remove(
                        ASSERT(next_agino !=3D NULLAGINO);
                        ASSERT(next_agino !=3D 0);
                }
+               if (next_agino =3D=3D NULLAGINO) {
+                       /*
+                        *After search the list for the inode being free
+                        *we still can't find it.
+                        */
+                       xfs_err(mp, "%s ino %lld not found in unlinked
list.",
+                                    __func__, (unsigned long
long)ip->i_ino);
+               }
                /*
                 * Now last_ibp points to the buffer previous to us on
                 * the unlinked list.  Pull us from the list.
@@ -1810,16 +1818,20 @@ xfs_iunlink_remove(
                } else {
                        xfs_trans_brelse(tp, ibp);
                }
-               /*
-                * Point the previous inode on the list to the next inode.
-                */
-               last_dip->di_next_unlinked =3D cpu_to_be32(next_agino);
-               ASSERT(next_agino !=3D 0);
-               offset =3D last_offset + offsetof(xfs_dinode_t,
di_next_unlinked);
-               xfs_trans_inode_buf(tp, last_ibp);
-               xfs_trans_log_buf(tp, last_ibp, offset,
-                                 (offset + sizeof(xfs_agino_t) - 1));
-               xfs_inobp_check(mp, last_ibp);
+               if (next_agino !=3D NULLAGINO) {
+                       /*
+                       * If only find the inode being free then we modify
+                       * the unlinked list.
+                       * Point the previous inode on the list to the next
inode.
+                       */
+                       last_dip->di_next_unlinked =3D
cpu_to_be32(next_agino);
+                       ASSERT(next_agino !=3D 0);
+                       offset =3D last_offset + offsetof(xfs_dinode_t,
di_next_unlinked);
+                       xfs_trans_inode_buf(tp, last_ibp);
+                       xfs_trans_log_buf(tp, last_ibp, offset,
+                                         (offset + sizeof(xfs_agino_t) -
1));
+                       xfs_inobp_check(mp, last_ibp);
+               }
        }
        return 0;
 }

Thank you.


2013/4/18 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com>

> Hi Brain and Eric,
> If the problem is the agno can't be found in the unlinked list. Can we
> just bypass it instead of passing ino=3D0xffffffff to xfs_inotobp?
> Thank you.
>
>
> 2013/4/18 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com>
>
>> Hi Eric,
>> The shutdown issue is still not reproduced yet. But I get the following
>> error today during test.
>>
>> Apr 18 07:42:51 10 kernel: Call Trace:
>> Apr 18 07:42:51 10 kernel: [<ffffffffa02d91ef>] ?
>> xfs_buf_cond_lock+0x2f/0xc0 [xfs]
>> Apr 18 07:42:51 10 kernel: [<ffffffff814fe6a5>]
>> schedule_timeout+0x215/0x2e0
>> Apr 18 07:42:51 10 kernel: [<ffffffffa02d5f07>] ?
>> kmem_zone_alloc+0x77/0xf0 [xfs]
>> Apr 18 07:42:51 10 kernel: [<ffffffff814ff5c2>] __down+0x72/0xb0
>> Apr 18 07:42:51 10 kernel: [<ffffffffa02da652>] ?
>> _xfs_buf_find+0x102/0x280 [xfs]
>> Apr 18 07:42:51 10 kernel: "echo 0 >
>> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> Apr 18 07:42:51 10 kernel: glusterfsd    D ffffffff8160b3c0     0
>> 14522      1 0x00000083
>> Apr 18 07:42:51 10 kernel: ffff882015a63a28 0000000000000082
>> 0000000000000000 0000000000000000
>> Apr 18 07:42:51 10 kernel: ffff882015a639b8 ffffffffa02d91ef
>> ffff882015a639d8 0000000000000246
>> Apr 18 07:42:51 10 kernel: ffff880e70491af8 ffff882015a63fd8
>> 000000000000fb88 ffff880e70491af8
>> Apr 18 07:42:51 10 kernel: Call Trace:
>> Apr 18 07:42:51 10 kernel: [<ffffffffa02d91ef>] ?
>> xfs_buf_cond_lock+0x2f/0xc0 [xfs]
>> Apr 18 07:42:51 10 kernel: [<ffffffff814fe6a5>]
>> schedule_timeout+0x215/0x2e0
>> Apr 18 07:42:51 10 kernel: [<ffffffffa02d5f07>] ?
>> kmem_zone_alloc+0x77/0xf0 [xfs]
>> Apr 18 07:42:51 10 kernel: [<ffffffff814ff5c2>] __down+0x72/0xb0
>> Apr 18 07:42:51 10 kernel: [<ffffffffa02da652>] ?
>> _xfs_buf_find+0x102/0x280 [xfs]
>> Apr 18 07:42:51 10 kernel: [<ffffffff81097ef1>] down+0x41/0x50
>> Apr 18 07:42:51 10 kernel: [<ffffffffa02da493>] xfs_buf_lock+0x53/0x110
>> [xfs]
>> Apr 18 07:42:51 10 kernel: [<ffffffffa02da652>] _xfs_buf_find+0x102/0x28=
0
>> [xfs]
>> Apr 18 07:42:51 10 kernel: [<ffffffffa02da83b>] xfs_buf_get+0x6b/0x1a0
>> [xfs]
>> Apr 18 07:42:51 10 kernel: [<ffffffffa02daeac>] xfs_buf_read+0x2c/0x100
>> [xfs]
>> Apr 18 07:42:51 10 kernel: [<ffffffffa02d0af8>]
>> xfs_trans_read_buf+0x1f8/0x400 [xfs]
>> Apr 18 07:42:51 10 kernel: [<ffffffffa02b3444>] xfs_read_agi+0x74/0x100
>> [xfs]
>> Apr 18 07:42:51 10 kernel: [<ffffffffa02b967b>] xfs_iunlink+0x5b/0x180
>> [xfs]
>> Apr 18 07:42:51 10 kernel: [<ffffffff810724c7>] ?
>> current_fs_time+0x27/0x30
>> Apr 18 07:42:51 10 kernel: [<ffffffffa02d12a7>] ?
>> xfs_trans_ichgtime+0x27/0xa0 [xfs]
>> Apr 18 07:42:51 10 kernel: [<ffffffffa02d15fb>] xfs_droplink+0x5b/0x70
>> [xfs]
>> Apr 18 07:42:51 10 kernel: [<ffffffffa02d2f9e>] xfs_remove+0x27e/0x3a0
>> [xfs]
>> Apr 18 07:42:51 10 kernel: [<ffffffff81186fd3>] ?
>> generic_permission+0x23/0xb0
>> Apr 18 07:42:51 10 kernel: [<ffffffffa02e0968>] xfs_vn_unlink+0x48/0x90
>> [xfs]
>> Apr 18 07:42:51 10 kernel: [<ffffffff81188c0f>] vfs_unlink+0x9f/0xe0
>> Apr 18 07:42:51 10 kernel: [<ffffffff8118795a>] ? lookup_hash+0x3a/0x50
>> Apr 18 07:42:51 10 kernel: [<ffffffff8118b143>] do_unlinkat+0x183/0x1c0
>> Apr 18 07:42:51 10 kernel: [<ffffffff81017938>] ?
>> syscall_trace_enter+0x1d8/0x1e0
>> Apr 18 07:42:51 10 kernel: [<ffffffff8118b196>] sys_unlink+0x16/0x20
>> Apr 18 07:42:51 10 kernel: [<ffffffff8100b308>] tracesys+0xd9/0xde
>>
>> Thank you.
>>
>>
>> 2013/4/17 Eric Sandeen <sandeen@sandeen.net>
>>
>>> On Apr 16, 2013, at 8:48 PM, =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com> w=
rote:
>>>
>>> Hi Brain,
>>> Can I change as following?
>>>
>>>
>>> ASSERTS are no-ops in a non-debug kernel, so this won't change any
>>> behavior.  I hope we'll know more if we get new traces from your patche=
d
>>> kernel....
>>>
>>> Eric
>>>
>>> --- a/xfs_inode.c
>>> +++ b/xfs_inode.c
>>> @@ -1773,6 +1773,8 @@ xfs_iunlink_remove(
>>>                         if (last_ibp !=3D NULL) {
>>>                                 xfs_trans_brelse(tp, last_ibp);
>>>                         }
>>> +                        ASSERT(next_agino !=3D NULLAGINO);
>>> +                        ASSERT(next_agino !=3D 0);
>>>                         next_ino =3D XFS_AGINO_TO_INO(mp, agno,
>>> next_agino);
>>>                         error =3D xfs_inotobp(mp, tp, next_ino, &last_d=
ip,
>>>                                             &last_ibp, &last_offset, 0)=
;
>>> @@ -1783,8 +1785,6 @@ xfs_iunlink_remove(
>>>                                 return error;
>>>                         }
>>>                         next_agino =3D
>>> be32_to_cpu(last_dip->di_next_unlinked);
>>> -                       ASSERT(next_agino !=3D NULLAGINO);
>>> -                       ASSERT(next_agino !=3D 0);
>>>                 }
>>>                 /*
>>>                  * Now last_ibp points to the buffer previous to us on
>>>
>>> Thank you.
>>>
>>>
>>> 2013/4/17 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com>
>>>
>>>> Hi Brain,
>>>> If it is because NULLAGINO is passed in  to xfs_inotobp().
>>>> Can I move the following two lines before xfs_inotobp?
>>>>
>>>> For example:
>>>>
>>>> 1767                 while (next_agino !=3D agino) {
>>>> 1768                         /*
>>>> 1769                          * If the last inode wasn't the one
>>>> pointing to
>>>> 1770                          * us, then release its buffer since we'r=
e
>>>> not
>>>> 1771                          * going to do anything with it.
>>>> 1772                          */
>>>> 1773                         if (last_ibp !=3D NULL) {
>>>> 1774                                 xfs_trans_brelse(tp, last_ibp);
>>>> 1775                         }
>>>> 1776                         next_ino =3D XFS_AGINO_TO_INO(mp, agno,
>>>> next_agino);
>>>> +                               ASSERT(next_agino !=3D NULLAGINO);
>>>> +                               ASSERT(next_agino !=3D 0);
>>>> 1777                         error =3D xfs_inotobp(mp, tp, next_ino,
>>>> &last_dip,
>>>> 1778                                             &last_ibp,
>>>> &last_offset, 0);
>>>> 1779                         if (error) {
>>>> 1780                                 xfs_warn(mp,
>>>> 1781                                         "%s: xfs_inotobp()
>>>> returned error %d.",
>>>> 1782                                         __func__, error);
>>>> 1783                                 return error;
>>>> 1784                         }
>>>> 1785                         next_agino =3D
>>>> be32_to_cpu(last_dip->di_next_unlinked);
>>>> -                               //ASSERT(next_agino !=3D NULLAGINO);
>>>> -                               //ASSERT(next_agino !=3D 0);
>>>> 1788                 }
>>>> I don't understand xfs well and correct me if I'm totally wrong.
>>>> Thank you very much.
>>>>
>>>>
>>>> 2013/4/17 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com>
>>>>
>>>>> Hi Brain,
>>>>> I want to ask a question, according to the shutdown trace. The ino in
>>>>>  xfs_iunlink_remove is 0x113, why xfs_imap got ino=3D0xffffffff ?
>>>>>
>>>>> --- xfs_imap -- module("xfs").function("xfs_imap@fs
>>>>> /xfs/xfs_ialloc.c:1257").return -- return=3D0x16
>>>>> vars: mp=3D0xffff882017a50800 tp=3D0xffff881c81797c70 ino=3D0xfffffff=
f
>>>>>
>>>>> --- xfs_iunlink_remove -- module("xfs").function("xfs_
>>>>> iunlink_remove@fs/xfs/xfs_inode.c:1680").return -- return=3D0x16
>>>>> vars: tp=3D0xffff881c81797c70 ip=3D0xffff881003c13c00 next_ino=3D? mp=
=3D?
>>>>> agi=3D? dip=3D? agibp=3D0xffff880109b47e20 ibp=3D? agno=3D? agino=3D?=
 next_agino=3D?
>>>>> last_ibp=3D? last_dip=3D0xffff882000000000 bucket_index=3D? offset=3D=
?
>>>>> last_offset=3D0xffffffffffff8810 error=3D? __func__=3D[...]
>>>>> ip: i_ino =3D 0x113, i_flags =3D 0x0
>>>>>
>>>>> Thank you.
>>>>>
>>>>>
>>>>>
>>>>> 2013/4/17 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com>
>>>>>
>>>>>> Hi Brain,
>>>>>> Thank you for your update, and I have applied your last kernel patch=
.
>>>>>> However it is not easy to reproduce especially in out test environme=
nt.
>>>>>> Till now is not happens again. I'll update the kernel patch now. BTW=
 is
>>>>>> there any findings in the logs of previous thread?
>>>>>> http://oss.sgi.com/archives/xfs/2013-04/msg00327.html
>>>>>> I guess it tend to happen during glusterfs rebalance because
>>>>>> glusterfs moves a lot of file from one server to another and then un=
link it.
>>>>>>
>>>>>> Thank you.
>>>>>>
>>>>>>
>>>>>> 2013/4/17 Brian Foster <bfoster@redhat.com>
>>>>>>
>>>>>>> On 04/16/2013 12:24 PM, Dave Chinner wrote:
>>>>>>> > On Mon, Apr 15, 2013 at 07:14:39PM -0400, Brian Foster wrote:
>>>>>>> >> Hi,
>>>>>>> >>
>>>>>>> >> Thanks for the data in the previous thread:
>>>>>>> >>
>>>>>>> >> http://oss.sgi.com/archives/xfs/2013-04/msg00327.html
>>>>>>> >>
>>>>>>> ...
>>>>>>> >>
>>>>>>> >>      echo 1 >
>>>>>>> /sys/kernel/debug/tracing/events/xfs/xfs_iunlink/enable
>>>>>>> >>      echo 1 >
>>>>>>> /sys/kernel/debug/tracing/events/xfs/xfs_iunlink_remove/enable
>>>>>>> >>      ... reproduce ...
>>>>>>> >>      cat /sys/kernel/debug/tracing/trace > trace.output
>>>>>>> >
>>>>>>> > It's better to use trace-cmd for this. it will result in less
>>>>>>> > dropped events. i.e.:
>>>>>>> >
>>>>>>> >       $ trace-cmd record -e xfs_iunlink\*
>>>>>>> >       ... reproduce ...
>>>>>>> >       ^C
>>>>>>> >       $ trace-cmd report > trace.output
>>>>>>> >
>>>>>>> >> --- a/fs/xfs/linux-2.6/xfs_trace.h
>>>>>>> >> +++ b/fs/xfs/linux-2.6/xfs_trace.h
>>>>>>> >> @@ -581,6 +581,8 @@ DEFINE_INODE_EVENT(xfs_file_fsync);
>>>>>>> ...
>>>>>>> >
>>>>>>> > I would suggest that the the tracing shoul dbe at entry of the
>>>>>>> > function, otherwise we won't get a tracepoint for the operation
>>>>>>> that
>>>>>>> > triggers the shutdown. (That's the reason most tracepoints in XFS
>>>>>>> > are at function entry...)
>>>>>>> >
>>>>>>>
>>>>>>> Good points, thanks Dave. A v2 that pulls up the tracepoints toward=
s
>>>>>>> function entry is appended.
>>>>>>>
>>>>>>> Brian
>>>>>>>
>>>>>>> From 280943e78ebe0b97a774cba51e7815c42f044b55 Mon Sep 17 00:00:00
>>>>>>> 2001
>>>>>>> From: Brian Foster <bfoster@redhat.com>
>>>>>>> Date: Mon, 15 Apr 2013 18:16:24 -0400
>>>>>>> Subject: [PATCH v2] xfs: add tracepoints for xfs_iunlink and
>>>>>>> xfs_iunlink_remove
>>>>>>>
>>>>>>> ---
>>>>>>>  fs/xfs/linux-2.6/xfs_trace.h |    2 ++
>>>>>>>  fs/xfs/xfs_inode.c           |    4 ++++
>>>>>>>  2 files changed, 6 insertions(+), 0 deletions(-)
>>>>>>>
>>>>>>> diff --git a/fs/xfs/linux-2.6/xfs_trace.h
>>>>>>> b/fs/xfs/linux-2.6/xfs_trace.h
>>>>>>> index adc6ec4..338a0f9 100644
>>>>>>> --- a/fs/xfs/linux-2.6/xfs_trace.h
>>>>>>> +++ b/fs/xfs/linux-2.6/xfs_trace.h
>>>>>>> @@ -583,6 +583,8 @@ DEFINE_INODE_EVENT(xfs_file_fsync);
>>>>>>>  DEFINE_INODE_EVENT(xfs_destroy_inode);
>>>>>>>  DEFINE_INODE_EVENT(xfs_dirty_inode);
>>>>>>>  DEFINE_INODE_EVENT(xfs_clear_inode);
>>>>>>> +DEFINE_INODE_EVENT(xfs_iunlink);
>>>>>>> +DEFINE_INODE_EVENT(xfs_iunlink_remove);
>>>>>>>
>>>>>>>  DEFINE_INODE_EVENT(xfs_dquot_dqalloc);
>>>>>>>  DEFINE_INODE_EVENT(xfs_dquot_dqdetach);
>>>>>>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>>>>>>> index 19900f0..d705c77 100644
>>>>>>> --- a/fs/xfs/xfs_inode.c
>>>>>>> +++ b/fs/xfs/xfs_inode.c
>>>>>>> @@ -1615,6 +1615,8 @@ xfs_iunlink(
>>>>>>>
>>>>>>>         mp =3D tp->t_mountp;
>>>>>>>
>>>>>>> +       trace_xfs_iunlink(ip);
>>>>>>> +
>>>>>>>         /*
>>>>>>>          * Get the agi buffer first.  It ensures lock ordering
>>>>>>>          * on the list.
>>>>>>> @@ -1694,6 +1696,8 @@ xfs_iunlink_remove(
>>>>>>>         mp =3D tp->t_mountp;
>>>>>>>         agno =3D XFS_INO_TO_AGNO(mp, ip->i_ino);
>>>>>>>
>>>>>>> +       trace_xfs_iunlink_remove(ip);
>>>>>>> +
>>>>>>>         /*
>>>>>>>          * Get the agi buffer first.  It ensures lock ordering
>>>>>>>          * on the list.
>>>>>>> --
>>>>>>> 1.7.7.6
>>>>>>>
>>>>>>>
>>>>>>
>>>>>>
>>>>>> --
>>>>>> =B7=FB=D3=C0=CC=CE
>>>>>>
>>>>>
>>>>>
>>>>>
>>>>> --
>>>>> =B7=FB=D3=C0=CC=CE
>>>>>
>>>>
>>>>
>>>>
>>>> --
>>>> =B7=FB=D3=C0=CC=CE
>>>>
>>>
>>>
>>>
>>> --
>>> =B7=FB=D3=C0=CC=CE
>>>
>>> _______________________________________________
>>> xfs mailing list
>>> xfs@oss.sgi.com
>>> http://oss.sgi.com/mailman/listinfo/xfs
>>>
>>>
>>
>>
>> --
>> =B7=FB=D3=C0=CC=CE
>>
>
>
>
> --
> =B7=FB=D3=C0=CC=CE
>



--=20
=B7=FB=D3=C0=CC=CE

--089e0111e074e88d6304da9e5836
Content-Type: text/html; charset=GB2312
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div>Hi Brian and Eric,<br></div>Can I change as foll=
owing to bypass it?<br>--- a/xfs_inode.c<br>+++ b/xfs_inode.c<br>@@ -1764,7=
 +1764,7 @@ xfs_iunlink_remove(<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; */<br>&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; next_agino =3D be32_to_cpu(agi-&gt;agi_unlinked[bucket_index]);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; last_ibp =3D NULL;<br>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; while (next_agino !=3D agi=
no) {<br>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; while (next_agino !=3D agino &amp;&amp; next_agino !=3D=
 NULLAGINO) {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; /*<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp; * If the last inode wasn&#39;t the one pointing to<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * us,=
 then release its buffer since we&#39;re not<br>@@ -1786,6 +1786,14 @@ xfs_=
iunlink_remove(<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; ASSERT(next_agino !=3D NULLAGINO);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ASSERT(next_agino !=3D 0);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; }<br>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (next_agino =3D=3D NULLAGINO) {<br>+&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*<br>+&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *After search the list fo=
r the inode being free<br>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; *we still can&#39;t find it.<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; */<br>+&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; xfs_err(mp, &quot;%s=
 ino %lld not found in unlinked list.&quot;, <br>+&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; __func__, (unsigned long long)ip-&gt;i_=
ino);<br>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; }<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; /*<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Now last_ibp points to the bu=
ffer previous to us on<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * the unlinked list.&nbsp; =
Pull us from the list.<br>@@ -1810,16 +1818,20 @@ xfs_iunlink_remove(<br>&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; } else {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; xfs_trans_b=
relse(tp, ibp);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*<br>-&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *=
 Point the previous inode on the list to the next inode.<br>-&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; */<br>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; last_dip-&gt;di_next_unlinked =3D cpu_to_be32(next_agino=
);<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; ASSERT(next_agino !=3D 0);<br>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; offset =3D last_offset =
+ offsetof(xfs_dinode_t, di_next_unlinked);<br>-&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; xfs_trans_inode_b=
uf(tp, last_ibp);<br>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; xfs_trans_log_buf(tp, last_ibp, offset,<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (offset + sizeof(xfs_agino_t) -=
 1));<br>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; xfs_inobp_check(mp, last_ibp);<br>+&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (next_a=
gino !=3D NULLAGINO) {<br>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp; /*<br>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
* If only find the inode being free then we modify<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * the unlinked l=
ist.<br>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Point =
the previous inode on the list to the next inode.<br>+&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; */<br>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp; last_dip-&gt;di_next_unlinked =3D cpu_to_be32(ne=
xt_agino);<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ASSERT(next_agin=
o !=3D 0);<br>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; of=
fset =3D last_offset + offsetof(xfs_dinode_t, di_next_unlinked);<br>+&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; xfs_trans_inode_buf(tp,=
 last_ibp);<br>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; x=
fs_trans_log_buf(tp, last_ibp, offset,<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp; (offset + sizeof(xfs_agino_t) - 1));<br>+&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; xfs_inobp_check(mp, last_ibp);<br>=
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; }<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br>&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0;<br>&nbsp;}<br><br></div>Thank you=
.<br>
</div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">2013/4/=
18 =B7=FB=D3=C0=CC=CE <span dir=3D"ltr">&lt;<a href=3D"mailto:yongtaofu@gma=
il.com" target=3D"_blank">yongtaofu@gmail.com</a>&gt;</span><br><blockquote=
 class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc soli=
d;padding-left:1ex">
<div dir=3D"ltr"><div><div>Hi Brain and Eric,<br></div>If the problem is th=
e agno can&#39;t be found in the unlinked list. Can we just bypass it inste=
ad of passing ino=3D0xffffffff to xfs_inotobp?<br></div>Thank you.<br></div=
>

<div class=3D"gmail_extra"><div><div class=3D"h5"><br><br><div class=3D"gma=
il_quote">2013/4/18 =B7=FB=D3=C0=CC=CE <span dir=3D"ltr">&lt;<a href=3D"mai=
lto:yongtaofu@gmail.com" target=3D"_blank">yongtaofu@gmail.com</a>&gt;</spa=
n><br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-l=
eft:1px #ccc solid;padding-left:1ex">

<div dir=3D"ltr"><div><div>Hi Eric,<br></div>The shutdown issue is still no=
t reproduced yet. But I get the following error today during test.<br><br>A=
pr 18 07:42:51 10 kernel: Call Trace:<br>Apr 18 07:42:51 10 kernel: [&lt;ff=
ffffffa02d91ef&gt;] ? xfs_buf_cond_lock+0x2f/0xc0 [xfs]<br>


Apr 18 07:42:51 10 kernel: [&lt;ffffffff814fe6a5&gt;] schedule_timeout+0x21=
5/0x2e0<br>Apr 18 07:42:51 10 kernel: [&lt;ffffffffa02d5f07&gt;] ? kmem_zon=
e_alloc+0x77/0xf0 [xfs]<br>Apr 18 07:42:51 10 kernel: [&lt;ffffffff814ff5c2=
&gt;] __down+0x72/0xb0<br>


Apr 18 07:42:51 10 kernel: [&lt;ffffffffa02da652&gt;] ? _xfs_buf_find+0x102=
/0x280 [xfs]<br>Apr 18 07:42:51 10 kernel: &quot;echo 0 &gt; /proc/sys/kern=
el/hung_task_timeout_secs&quot; disables this message.<br>Apr 18 07:42:51 1=
0 kernel: glusterfsd&nbsp;&nbsp;&nbsp; D ffffffff8160b3c0&nbsp;&nbsp;&nbsp;=
&nbsp; 0 14522&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 0x00000083<br>


Apr 18 07:42:51 10 kernel: ffff882015a63a28 0000000000000082 00000000000000=
00 0000000000000000<br>Apr 18 07:42:51 10 kernel: ffff882015a639b8 ffffffff=
a02d91ef ffff882015a639d8 0000000000000246<br>Apr 18 07:42:51 10 kernel: ff=
ff880e70491af8 ffff882015a63fd8 000000000000fb88 ffff880e70491af8<br>


Apr 18 07:42:51 10 kernel: Call Trace:<br>Apr 18 07:42:51 10 kernel: [&lt;f=
fffffffa02d91ef&gt;] ? xfs_buf_cond_lock+0x2f/0xc0 [xfs]<br>Apr 18 07:42:51=
 10 kernel: [&lt;ffffffff814fe6a5&gt;] schedule_timeout+0x215/0x2e0<br>


Apr 18 07:42:51 10 kernel: [&lt;ffffffffa02d5f07&gt;] ? kmem_zone_alloc+0x7=
7/0xf0 [xfs]<br>Apr 18 07:42:51 10 kernel: [&lt;ffffffff814ff5c2&gt;] __dow=
n+0x72/0xb0<br>Apr 18 07:42:51 10 kernel: [&lt;ffffffffa02da652&gt;] ? _xfs=
_buf_find+0x102/0x280 [xfs]<br>


Apr 18 07:42:51 10 kernel: [&lt;ffffffff81097ef1&gt;] down+0x41/0x50<br>Apr=
 18 07:42:51 10 kernel: [&lt;ffffffffa02da493&gt;] xfs_buf_lock+0x53/0x110 =
[xfs]<br>Apr 18 07:42:51 10 kernel: [&lt;ffffffffa02da652&gt;] _xfs_buf_fin=
d+0x102/0x280 [xfs]<br>


Apr 18 07:42:51 10 kernel: [&lt;ffffffffa02da83b&gt;] xfs_buf_get+0x6b/0x1a=
0 [xfs]<br>Apr 18 07:42:51 10 kernel: [&lt;ffffffffa02daeac&gt;] xfs_buf_re=
ad+0x2c/0x100 [xfs]<br>Apr 18 07:42:51 10 kernel: [&lt;ffffffffa02d0af8&gt;=
] xfs_trans_read_buf+0x1f8/0x400 [xfs]<br>


Apr 18 07:42:51 10 kernel: [&lt;ffffffffa02b3444&gt;] xfs_read_agi+0x74/0x1=
00 [xfs]<br>Apr 18 07:42:51 10 kernel: [&lt;ffffffffa02b967b&gt;] xfs_iunli=
nk+0x5b/0x180 [xfs]<br>Apr 18 07:42:51 10 kernel: [&lt;ffffffff810724c7&gt;=
] ? current_fs_time+0x27/0x30<br>


Apr 18 07:42:51 10 kernel: [&lt;ffffffffa02d12a7&gt;] ? xfs_trans_ichgtime+=
0x27/0xa0 [xfs]<br>Apr 18 07:42:51 10 kernel: [&lt;ffffffffa02d15fb&gt;] xf=
s_droplink+0x5b/0x70 [xfs]<br>Apr 18 07:42:51 10 kernel: [&lt;ffffffffa02d2=
f9e&gt;] xfs_remove+0x27e/0x3a0 [xfs]<br>


Apr 18 07:42:51 10 kernel: [&lt;ffffffff81186fd3&gt;] ? generic_permission+=
0x23/0xb0<br>Apr 18 07:42:51 10 kernel: [&lt;ffffffffa02e0968&gt;] xfs_vn_u=
nlink+0x48/0x90 [xfs]<br>Apr 18 07:42:51 10 kernel: [&lt;ffffffff81188c0f&g=
t;] vfs_unlink+0x9f/0xe0<br>


Apr 18 07:42:51 10 kernel: [&lt;ffffffff8118795a&gt;] ? lookup_hash+0x3a/0x=
50<br>Apr 18 07:42:51 10 kernel: [&lt;ffffffff8118b143&gt;] do_unlinkat+0x1=
83/0x1c0<br>Apr 18 07:42:51 10 kernel: [&lt;ffffffff81017938&gt;] ? syscall=
_trace_enter+0x1d8/0x1e0<br>


Apr 18 07:42:51 10 kernel: [&lt;ffffffff8118b196&gt;] sys_unlink+0x16/0x20<=
br>Apr 18 07:42:51 10 kernel: [&lt;ffffffff8100b308&gt;] tracesys+0xd9/0xde=
<br><br></div>Thank you.<br></div><div class=3D"gmail_extra"><div><div>
<br><br><div class=3D"gmail_quote">
2013/4/17 Eric Sandeen <span dir=3D"ltr">&lt;<a href=3D"mailto:sandeen@sand=
een.net" target=3D"_blank">sandeen@sandeen.net</a>&gt;</span><br><blockquot=
e class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc sol=
id;padding-left:1ex">


<div dir=3D"auto"><div><div>On Apr 16, 2013, at 8:48 PM, =B7=FB=D3=C0=CC=CE=
 &lt;<a href=3D"mailto:yongtaofu@gmail.com" target=3D"_blank">yongtaofu@gma=
il.com</a>&gt; wrote:<br><br></div><blockquote type=3D"cite"><div><div dir=
=3D"ltr"><div>
<div>Hi Brain,<br></div>Can I change as following?<br></div></div></div></b=
lockquote><div><br></div></div>ASSERTS are no-ops in a non-debug kernel, so=
 this won&#39;t change any behavior. &nbsp;I hope we&#39;ll know more if we=
 get new traces from your patched kernel....<div>


<br></div><div>Eric</div><div><div><div><br><blockquote type=3D"cite"><div>=
<div dir=3D"ltr"><div>--- a/xfs_inode.c<br>+++ b/xfs_inode.c<br>@@ -1773,6 =
+1773,8 @@ xfs_iunlink_remove(<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp; if (last_ibp !=3D NULL) {<br>


&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; xfs_trans_brelse(tp, last_ibp);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br>+&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ASSERT(next_agin=
o !=3D NULLAGINO);<br>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; ASSERT(next_agino !=3D 0);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; next_ino =3D XFS_AGINO_TO_INO(mp, agno, next=
_agino);<br>



&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; error =3D x=
fs_inotobp(mp, tp, next_ino, &amp;last_dip,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; &amp;last_ibp, &amp;last_offset, 0);<br>@@ -1783,8 +1785,6 @@ xfs_iun=
link_remove(<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return error;<br>



&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br>&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; next_agino =3D be=
32_to_cpu(last_dip-&gt;di_next_unlinked);<br>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp; ASSERT(next_agino !=3D NULLAGINO);<br>-&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ASSERT(next_agino !=3D 0=
);<br>



&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; }<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Now last=
_ibp points to the buffer previous to us on<br><br></div>Thank you.<br></di=
v><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">2013/4/17 =
=B7=FB=D3=C0=CC=CE <span dir=3D"ltr">&lt;<a href=3D"mailto:yongtaofu@gmail.=
com" target=3D"_blank">yongtaofu@gmail.com</a>&gt;</span><br>



<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div dir=3D"ltr"><div><div><div>Hi Brain,<br=
></div>If it is because NULLAGINO is passed in&nbsp; to xfs_inotobp().<br><=
/div>Can I move the following two lines before xfs_inotobp?<br>



<br>For example:<br><br>1767&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; while (next_agino !=3D ag=
ino) {<br>
1768&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /=
*<br>1769&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp; * If the last inode wasn&#39;t the one pointing to<br>1770&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * us, =
then release its buffer since we&#39;re not<br>1771&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * going to do anything =
with it.<br>




1772&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; */<br>1773&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp; if (last_ibp !=3D NULL) {<br>1774&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; xfs_trans_brelse(tp, last_ibp);<br>1775&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br>1776&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; next_ino =3D XFS_AGINO_TO_=
INO(mp, agno, next_agino);<br>




+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nb=
sp; &nbsp;&nbsp; ASSERT(next_agino !=3D NULLAGINO);<br>+&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ASSERT(next_a=
gino !=3D 0);<br>1777&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; error =3D xfs_inotobp(mp, tp, next_ino, &amp;last_dip,<br>1=
778&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &amp;last_ibp, &amp;last_offset,=
 0);<br>




1779&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; i=
f (error) {<br>1780&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; xfs_warn(mp,<=
br>1781&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp; &quot;%s: xfs_inotobp() returned error %d.&quot;,<br=
>1782&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; __func__, error);<br>




1783&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return error;<br>1784&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br>1785&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; next_agi=
no =3D be32_to_cpu(last_dip-&gt;di_next_unlinked);<br>-&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; //ASSERT(=
next_agino !=3D NULLAGINO);<br>




-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //ASSERT(next_agino !=3D 0);<br>1788&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; }<br></div>I don&#39;t understand xfs well and correct me if=
 I&#39;m totally wrong.<br><div><div><div>Thank you very much.<br></div></d=
iv>




</div></div><div class=3D"gmail_extra"><div><div><br><br><div class=3D"gmai=
l_quote">2013/4/17 =B7=FB=D3=C0=CC=CE <span dir=3D"ltr">&lt;<a href=3D"mail=
to:yongtaofu@gmail.com" target=3D"_blank">yongtaofu@gmail.com</a>&gt;</span=
><br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-le=
ft:1px #ccc solid;padding-left:1ex">




<div dir=3D"ltr">Hi Brain,<div>I want to ask a question, according to the s=
hutdown trace. The ino in<font face=3D"arial, sans-serif"><span style=3D"fo=
nt-size:14px">&nbsp;</span></font><span style=3D"font-family:arial,sans-ser=
if;font-size:14px">&nbsp;</span><span style=3D"font-family:arial,sans-serif=
;font-size:14px">xfs_iunlink_remove is&nbsp;</span><span style=3D"font-fami=
ly:arial,sans-serif;font-size:14px">0x113, why&nbsp;</span><span style=3D"f=
ont-family:arial,sans-serif;font-size:14px">xfs_imap got&nbsp;</span><span =
style=3D"font-family:arial,sans-serif;font-size:14px">ino=3D0xffffffff</spa=
n><span style=3D"font-family:arial,sans-serif;font-size:14px">&nbsp;?&nbsp;=
</span></div>





<div><span style=3D"font-family:arial,sans-serif;font-size:14px"><br></span=
></div><div><span style=3D"font-family:arial,sans-serif;font-size:14px">---=
 xfs_imap -- module(&quot;xfs&quot;).function(&quot;xfs_</span><span style=
=3D"font-family:arial,sans-serif;font-size:14px">imap@fs/xfs/xfs_ialloc.c:1=
257&quot;</span><span style=3D"font-family:arial,sans-serif;font-size:14px"=
>).return -- return=3D0x16</span><br style=3D"font-family:arial,sans-serif;=
font-size:14px">





<span style=3D"font-family:arial,sans-serif;font-size:14px">vars: mp=3D0xff=
ff882017a50800 tp=3D0xffff881c81797c70 ino=3D0xffffffff</span><span style=
=3D"font-family:arial,sans-serif;font-size:14px"><br></span></div><div><spa=
n style=3D"font-family:arial,sans-serif;font-size:14px"><br>





</span></div><div><span style=3D"font-family:arial,sans-serif;font-size:14p=
x">--- xfs_iunlink_remove -- module(&quot;xfs&quot;).function(&quot;xfs_</s=
pan><span style=3D"font-family:arial,sans-serif;font-size:14px">iunlink_rem=
ove@fs/xfs/xfs_</span><span style=3D"font-family:arial,sans-serif;font-size=
:14px">inode.c:1680&quot;).return -- return=3D0x16</span><br style=3D"font-=
family:arial,sans-serif;font-size:14px">





<span style=3D"font-family:arial,sans-serif;font-size:14px">vars: tp=3D0xff=
ff881c81797c70 ip=3D0xffff881003c13c00 next_ino=3D? mp=3D? agi=3D? dip=3D? =
agibp=3D0xffff880109b47e20 ibp=3D? agno=3D? agino=3D? next_agino=3D? last_i=
bp=3D? last_dip=3D0xffff882000000000 bucket_index=3D? offset=3D? last_offse=
t=3D0xffffffffffff8810 error=3D? __func__=3D[...]</span><br style=3D"font-f=
amily:arial,sans-serif;font-size:14px">





<span style=3D"font-family:arial,sans-serif;font-size:14px">ip: i_ino =3D 0=
x113, i_flags =3D 0x0</span><span style=3D"font-family:arial,sans-serif;fon=
t-size:14px"><br></span></div><div><span style=3D"font-family:arial,sans-se=
rif;font-size:14px"><br>





</span></div><div><span style=3D"font-family:arial,sans-serif;font-size:14p=
x">Thank you.</span></div><div><span style=3D"font-family:arial,sans-serif;=
font-size:14px"><br></span></div></div><div class=3D"gmail_extra"><div><div=
>





<br><br><div class=3D"gmail_quote">2013/4/17 =B7=FB=D3=C0=CC=CE <span dir=
=3D"ltr">&lt;<a href=3D"mailto:yongtaofu@gmail.com" target=3D"_blank">yongt=
aofu@gmail.com</a>&gt;</span><br><blockquote class=3D"gmail_quote" style=3D=
"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">





<div dir=3D"ltr"><div><div>Hi Brain,<br></div>Thank you for your update, an=
d I have applied your last kernel patch. However it is not easy to reproduc=
e especially in out test environment. Till now is not happens again. I&#39;=
ll update the kernel patch now. BTW is there any findings in the logs of pr=
evious thread?<br>






<a href=3D"http://oss.sgi.com/archives/xfs/2013-04/msg00327.html" target=3D=
"_blank">http://oss.sgi.com/archives/xfs/2013-04/msg00327.html</a><br>I gue=
ss it tend to happen during glusterfs rebalance because glusterfs moves a l=
ot of file from one server to another and then unlink it.<br>






<br></div>Thank you.<br></div><div class=3D"gmail_extra"><div><div><br><br>=
<div class=3D"gmail_quote">2013/4/17 Brian Foster <span dir=3D"ltr">&lt;<a =
href=3D"mailto:bfoster@redhat.com" target=3D"_blank">bfoster@redhat.com</a>=
&gt;</span><br>





<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
<div>On 04/16/2013 12:24 PM, Dave Chinner wrote:<br>
&gt; On Mon, Apr 15, 2013 at 07:14:39PM -0400, Brian Foster wrote:<br>
&gt;&gt; Hi,<br>
&gt;&gt;<br>
&gt;&gt; Thanks for the data in the previous thread:<br>
&gt;&gt;<br>
&gt;&gt; <a href=3D"http://oss.sgi.com/archives/xfs/2013-04/msg00327.html" =
target=3D"_blank">http://oss.sgi.com/archives/xfs/2013-04/msg00327.html</a>=
<br>
&gt;&gt;<br>
</div>...<br>
<div>&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp;echo 1 &gt; /sys/kernel/debug/tracing/events/x=
fs/xfs_iunlink/enable<br>
&gt;&gt; &nbsp; &nbsp; &nbsp;echo 1 &gt; /sys/kernel/debug/tracing/events/x=
fs/xfs_iunlink_remove/enable<br>
&gt;&gt; &nbsp; &nbsp; &nbsp;... reproduce ...<br>
&gt;&gt; &nbsp; &nbsp; &nbsp;cat /sys/kernel/debug/tracing/trace &gt; trace=
.output<br>
&gt;<br>
&gt; It&#39;s better to use trace-cmd for this. it will result in less<br>
&gt; dropped events. i.e.:<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; $ trace-cmd record -e xfs_iunlink\*<br>
&gt; &nbsp; &nbsp; &nbsp; ... reproduce ...<br>
&gt; &nbsp; &nbsp; &nbsp; ^C<br>
&gt; &nbsp; &nbsp; &nbsp; $ trace-cmd report &gt; trace.output<br>
&gt;<br>
&gt;&gt; --- a/fs/xfs/linux-2.6/xfs_trace.h<br>
&gt;&gt; +++ b/fs/xfs/linux-2.6/xfs_trace.h<br>
&gt;&gt; @@ -581,6 +581,8 @@ DEFINE_INODE_EVENT(xfs_file_fsync);<br>
</div>...<br>
<div>&gt;<br>
&gt; I would suggest that the the tracing shoul dbe at entry of the<br>
&gt; function, otherwise we won&#39;t get a tracepoint for the operation th=
at<br>
&gt; triggers the shutdown. (That&#39;s the reason most tracepoints in XFS<=
br>
&gt; are at function entry...)<br>
&gt;<br>
<br>
</div>Good points, thanks Dave. A v2 that pulls up the tracepoints towards<=
br>
function entry is appended.<br>
<br>
Brian<br>
<br>
>From 280943e78ebe0b97a774cba51e7815c42f044b55 Mon Sep 17 00:00:00 2001<br>
From: Brian Foster &lt;<a href=3D"mailto:bfoster@redhat.com" target=3D"_bla=
nk">bfoster@redhat.com</a>&gt;<br>
Date: Mon, 15 Apr 2013 18:16:24 -0400<br>
Subject: [PATCH v2] xfs: add tracepoints for xfs_iunlink and<br>
xfs_iunlink_remove<br>
<div><br>
---<br>
&nbsp;fs/xfs/linux-2.6/xfs_trace.h | &nbsp; &nbsp;2 ++<br>
&nbsp;fs/xfs/xfs_inode.c &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; | &nbsp; &nbsp;=
4 ++++<br>
&nbsp;2 files changed, 6 insertions(+), 0 deletions(-)<br>
<br>
diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h<br=
>
</div>index adc6ec4..338a0f9 100644<br>
--- a/fs/xfs/linux-2.6/xfs_trace.h<br>
+++ b/fs/xfs/linux-2.6/xfs_trace.h<br>
@@ -583,6 +583,8 @@ DEFINE_INODE_EVENT(xfs_file_fsync);<br>
&nbsp;DEFINE_INODE_EVENT(xfs_destroy_inode);<br>
&nbsp;DEFINE_INODE_EVENT(xfs_dirty_inode);<br>
<div>&nbsp;DEFINE_INODE_EVENT(xfs_clear_inode);<br>
+DEFINE_INODE_EVENT(xfs_iunlink);<br>
+DEFINE_INODE_EVENT(xfs_iunlink_remove);<br>
<br>
&nbsp;DEFINE_INODE_EVENT(xfs_dquot_dqalloc);<br>
&nbsp;DEFINE_INODE_EVENT(xfs_dquot_dqdetach);<br>
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c<br>
</div>index 19900f0..d705c77 100644<br>
--- a/fs/xfs/xfs_inode.c<br>
+++ b/fs/xfs/xfs_inode.c<br>
@@ -1615,6 +1615,8 @@ xfs_iunlink(<br>
<br>
&nbsp; &nbsp; &nbsp; &nbsp; mp =3D tp-&gt;t_mountp;<br>
<br>
+ &nbsp; &nbsp; &nbsp; trace_xfs_iunlink(ip);<br>
+<br>
&nbsp; &nbsp; &nbsp; &nbsp; /*<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;* Get the agi buffer first. &nbsp;It ensu=
res lock ordering<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;* on the list.<br>
@@ -1694,6 +1696,8 @@ xfs_iunlink_remove(<br>
&nbsp; &nbsp; &nbsp; &nbsp; mp =3D tp-&gt;t_mountp;<br>
&nbsp; &nbsp; &nbsp; &nbsp; agno =3D XFS_INO_TO_AGNO(mp, ip-&gt;i_ino);<br>
<br>
+ &nbsp; &nbsp; &nbsp; trace_xfs_iunlink_remove(ip);<br>
+<br>
&nbsp; &nbsp; &nbsp; &nbsp; /*<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;* Get the agi buffer first. &nbsp;It ensu=
res lock ordering<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;* on the list.<br>
<span><font color=3D"#888888">--<br>
1.7.7.6<br>
<br>
</font></span></blockquote></div><br><br clear=3D"all"><br></div></div><spa=
n><font color=3D"#888888">-- <br>=B7=FB=D3=C0=CC=CE
</font></span></div>
</blockquote></div><br><br clear=3D"all"><div><br></div></div></div><span><=
font color=3D"#888888">-- <br>=B7=FB=D3=C0=CC=CE
</font></span></div>
</blockquote></div><br><br clear=3D"all"><br></div></div><span><font color=
=3D"#888888">-- <br>=B7=FB=D3=C0=CC=CE
</font></span></div>
</blockquote></div><br><br clear=3D"all"><br>-- <br>=B7=FB=D3=C0=CC=CE
</div>
</div></blockquote></div></div><blockquote type=3D"cite"><div><span>_______=
________________________________________</span><br><span>xfs mailing list</=
span><br><span><a href=3D"mailto:xfs@oss.sgi.com" target=3D"_blank">xfs@oss=
.sgi.com</a></span><br>


<span><a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank"=
>http://oss.sgi.com/mailman/listinfo/xfs</a></span><br></div></blockquote><=
/div></div></blockquote></div><br><br clear=3D"all"><br></div></div><span><=
font color=3D"#888888">-- <br>

=B7=FB=D3=C0=CC=CE
</font></span></div>
</blockquote></div><br><br clear=3D"all"><br></div></div><span class=3D"HOE=
nZb"><font color=3D"#888888">-- <br>=B7=FB=D3=C0=CC=CE
</font></span></div>
</blockquote></div><br><br clear=3D"all"><br>-- <br>=B7=FB=D3=C0=CC=CE
</div>

--089e0111e074e88d6304da9e5836--


--===============2560478724826884747==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2560478724826884747==--
