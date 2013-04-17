Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5D4677F37
	for <xfs@oss.sgi.com>; Tue, 16 Apr 2013 23:28:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B31F4AC004
	for <xfs@oss.sgi.com>; Tue, 16 Apr 2013 21:28:21 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id AsUFof9WWCafeqbs for <xfs@oss.sgi.com>;
	Tue, 16 Apr 2013 21:28:19 -0700 (PDT)
References: <516C89DF.4070904@redhat.com> <20130416162417.GC13938@destitution>
	<516D87E3.2010605@redhat.com>
	<CADFMGuLgU2++ym4U9axhevV_L2t-2CMVaDoT5cyQcew2YZMsBA@mail.gmail.com>
	<CADFMGuK3cPSmqZoMdFSSqOnUz3GLv+c01xXHDhzv9_dfUNUPPA@mail.gmail.com>
	<CADFMGu+XD=-NJm3CAsnKpiMWykPj67t2LHgtxkPpyTpVmG3LDA@mail.gmail.com>
	<CADFMGu+z32O5mVBfO6gb8F03y9mrwB5=nf+7LMbky4ttk2mbFw@mail.gmail.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <CADFMGu+z32O5mVBfO6gb8F03y9mrwB5=nf+7LMbky4ttk2mbFw@mail.gmail.com>
Message-Id: <BA50C18A-BE51-4658-B05E-3EDB0F11BE36@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: xfs_iunlink_remove: xfs_inotobp() returned error 22 -- debugging
Date: Tue, 16 Apr 2013 21:28:12 -0700
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5155864142524365826=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: =?utf-8?B?56ym5rC45rab?= <yongtaofu@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>


--===============5155864142524365826==
Content-Type: multipart/alternative;
	boundary=Apple-Mail-62731709-7EC0-4766-B0C5-9A69AD6915EE
Content-Transfer-Encoding: 7bit


--Apple-Mail-62731709-7EC0-4766-B0C5-9A69AD6915EE
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Apr 16, 2013, at 8:48 PM, =E7=AC=A6=E6=B0=B8=E6=B6=9B <yongtaofu@gmail.co=
m> wrote:

> Hi Brain,
> Can I change as following?

ASSERTS are no-ops in a non-debug kernel, so this won't change any behavior.=
  I hope we'll know more if we get new traces from your patched kernel....

Eric

> --- a/xfs_inode.c
> +++ b/xfs_inode.c
> @@ -1773,6 +1773,8 @@ xfs_iunlink_remove(
>                         if (last_ibp !=3D NULL) {
>                                 xfs_trans_brelse(tp, last_ibp);
>                         }
> +                        ASSERT(next_agino !=3D NULLAGINO);
> +                        ASSERT(next_agino !=3D 0);
>                         next_ino =3D XFS_AGINO_TO_INO(mp, agno, next_agino=
);
>                         error =3D xfs_inotobp(mp, tp, next_ino, &last_dip,=

>                                             &last_ibp, &last_offset, 0);
> @@ -1783,8 +1785,6 @@ xfs_iunlink_remove(
>                                 return error;
>                         }
>                         next_agino =3D be32_to_cpu(last_dip->di_next_unlin=
ked);
> -                       ASSERT(next_agino !=3D NULLAGINO);
> -                       ASSERT(next_agino !=3D 0);
>                 }
>                 /*
>                  * Now last_ibp points to the buffer previous to us on
>=20
> Thank you.
>=20
>=20
> 2013/4/17 =E7=AC=A6=E6=B0=B8=E6=B6=9B <yongtaofu@gmail.com>
>> Hi Brain,
>> If it is because NULLAGINO is passed in  to xfs_inotobp().
>> Can I move the following two lines before xfs_inotobp?
>>=20
>> For example:
>>=20
>> 1767                 while (next_agino !=3D agino) {
>> 1768                         /*
>> 1769                          * If the last inode wasn't the one pointing=
 to
>> 1770                          * us, then release its buffer since we're n=
ot
>> 1771                          * going to do anything with it.
>> 1772                          */
>> 1773                         if (last_ibp !=3D NULL) {
>> 1774                                 xfs_trans_brelse(tp, last_ibp);
>> 1775                         }
>> 1776                         next_ino =3D XFS_AGINO_TO_INO(mp, agno, next=
_agino);
>> +                               ASSERT(next_agino !=3D NULLAGINO);
>> +                               ASSERT(next_agino !=3D 0);
>> 1777                         error =3D xfs_inotobp(mp, tp, next_ino, &las=
t_dip,
>> 1778                                             &last_ibp, &last_offset,=
 0);
>> 1779                         if (error) {
>> 1780                                 xfs_warn(mp,
>> 1781                                         "%s: xfs_inotobp() returned e=
rror %d.",
>> 1782                                         __func__, error);
>> 1783                                 return error;
>> 1784                         }
>> 1785                         next_agino =3D be32_to_cpu(last_dip->di_next=
_unlinked);
>> -                               //ASSERT(next_agino !=3D NULLAGINO);
>> -                               //ASSERT(next_agino !=3D 0);
>> 1788                 }
>> I don't understand xfs well and correct me if I'm totally wrong.
>> Thank you very much.
>>=20
>>=20
>> 2013/4/17 =E7=AC=A6=E6=B0=B8=E6=B6=9B <yongtaofu@gmail.com>
>>> Hi Brain,
>>> I want to ask a question, according to the shutdown trace. The ino in  x=
fs_iunlink_remove is 0x113, why xfs_imap got ino=3D0xffffffff ?=20
>>>=20
>>> --- xfs_imap -- module("xfs").function("xfs_imap@fs/xfs/xfs_ialloc.c:125=
7").return -- return=3D0x16
>>> vars: mp=3D0xffff882017a50800 tp=3D0xffff881c81797c70 ino=3D0xffffffff
>>>=20
>>> --- xfs_iunlink_remove -- module("xfs").function("xfs_iunlink_remove@fs/=
xfs/xfs_inode.c:1680").return -- return=3D0x16
>>> vars: tp=3D0xffff881c81797c70 ip=3D0xffff881003c13c00 next_ino=3D? mp=3D=
? agi=3D? dip=3D? agibp=3D0xffff880109b47e20 ibp=3D? agno=3D? agino=3D? next=
_agino=3D? last_ibp=3D? last_dip=3D0xffff882000000000 bucket_index=3D? offse=
t=3D? last_offset=3D0xffffffffffff8810 error=3D? __func__=3D[...]
>>> ip: i_ino =3D 0x113, i_flags =3D 0x0
>>>=20
>>> Thank you.
>>>=20
>>>=20
>>>=20
>>> 2013/4/17 =E7=AC=A6=E6=B0=B8=E6=B6=9B <yongtaofu@gmail.com>
>>>> Hi Brain,
>>>> Thank you for your update, and I have applied your last kernel patch. H=
owever it is not easy to reproduce especially in out test environment. Till n=
ow is not happens again. I'll update the kernel patch now. BTW is there any f=
indings in the logs of previous thread?
>>>> http://oss.sgi.com/archives/xfs/2013-04/msg00327.html
>>>> I guess it tend to happen during glusterfs rebalance because glusterfs m=
oves a lot of file from one server to another and then unlink it.
>>>>=20
>>>> Thank you.
>>>>=20
>>>>=20
>>>> 2013/4/17 Brian Foster <bfoster@redhat.com>
>>>>> On 04/16/2013 12:24 PM, Dave Chinner wrote:
>>>>> > On Mon, Apr 15, 2013 at 07:14:39PM -0400, Brian Foster wrote:
>>>>> >> Hi,
>>>>> >>
>>>>> >> Thanks for the data in the previous thread:
>>>>> >>
>>>>> >> http://oss.sgi.com/archives/xfs/2013-04/msg00327.html
>>>>> >>
>>>>> ...
>>>>> >>
>>>>> >>      echo 1 > /sys/kernel/debug/tracing/events/xfs/xfs_iunlink/enab=
le
>>>>> >>      echo 1 > /sys/kernel/debug/tracing/events/xfs/xfs_iunlink_remo=
ve/enable
>>>>> >>      ... reproduce ...
>>>>> >>      cat /sys/kernel/debug/tracing/trace > trace.output
>>>>> >
>>>>> > It's better to use trace-cmd for this. it will result in less
>>>>> > dropped events. i.e.:
>>>>> >
>>>>> >       $ trace-cmd record -e xfs_iunlink\*
>>>>> >       ... reproduce ...
>>>>> >       ^C
>>>>> >       $ trace-cmd report > trace.output
>>>>> >
>>>>> >> --- a/fs/xfs/linux-2.6/xfs_trace.h
>>>>> >> +++ b/fs/xfs/linux-2.6/xfs_trace.h
>>>>> >> @@ -581,6 +581,8 @@ DEFINE_INODE_EVENT(xfs_file_fsync);
>>>>> ...
>>>>> >
>>>>> > I would suggest that the the tracing shoul dbe at entry of the
>>>>> > function, otherwise we won't get a tracepoint for the operation that=

>>>>> > triggers the shutdown. (That's the reason most tracepoints in XFS
>>>>> > are at function entry...)
>>>>> >
>>>>>=20
>>>>> Good points, thanks Dave. A v2 that pulls up the tracepoints towards
>>>>> function entry is appended.
>>>>>=20
>>>>> Brian
>>>>>=20
>>>>> =46rom 280943e78ebe0b97a774cba51e7815c42f044b55 Mon Sep 17 00:00:00 20=
01
>>>>> From: Brian Foster <bfoster@redhat.com>
>>>>> Date: Mon, 15 Apr 2013 18:16:24 -0400
>>>>> Subject: [PATCH v2] xfs: add tracepoints for xfs_iunlink and
>>>>> xfs_iunlink_remove
>>>>>=20
>>>>> ---
>>>>>  fs/xfs/linux-2.6/xfs_trace.h |    2 ++
>>>>>  fs/xfs/xfs_inode.c           |    4 ++++
>>>>>  2 files changed, 6 insertions(+), 0 deletions(-)
>>>>>=20
>>>>> diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace=
.h
>>>>> index adc6ec4..338a0f9 100644
>>>>> --- a/fs/xfs/linux-2.6/xfs_trace.h
>>>>> +++ b/fs/xfs/linux-2.6/xfs_trace.h
>>>>> @@ -583,6 +583,8 @@ DEFINE_INODE_EVENT(xfs_file_fsync);
>>>>>  DEFINE_INODE_EVENT(xfs_destroy_inode);
>>>>>  DEFINE_INODE_EVENT(xfs_dirty_inode);
>>>>>  DEFINE_INODE_EVENT(xfs_clear_inode);
>>>>> +DEFINE_INODE_EVENT(xfs_iunlink);
>>>>> +DEFINE_INODE_EVENT(xfs_iunlink_remove);
>>>>>=20
>>>>>  DEFINE_INODE_EVENT(xfs_dquot_dqalloc);
>>>>>  DEFINE_INODE_EVENT(xfs_dquot_dqdetach);
>>>>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>>>>> index 19900f0..d705c77 100644
>>>>> --- a/fs/xfs/xfs_inode.c
>>>>> +++ b/fs/xfs/xfs_inode.c
>>>>> @@ -1615,6 +1615,8 @@ xfs_iunlink(
>>>>>=20
>>>>>         mp =3D tp->t_mountp;
>>>>>=20
>>>>> +       trace_xfs_iunlink(ip);
>>>>> +
>>>>>         /*
>>>>>          * Get the agi buffer first.  It ensures lock ordering
>>>>>          * on the list.
>>>>> @@ -1694,6 +1696,8 @@ xfs_iunlink_remove(
>>>>>         mp =3D tp->t_mountp;
>>>>>         agno =3D XFS_INO_TO_AGNO(mp, ip->i_ino);
>>>>>=20
>>>>> +       trace_xfs_iunlink_remove(ip);
>>>>> +
>>>>>         /*
>>>>>          * Get the agi buffer first.  It ensures lock ordering
>>>>>          * on the list.
>>>>> --
>>>>> 1.7.7.6
>>>>=20
>>>>=20
>>>>=20
>>>> --=20
>>>> =E7=AC=A6=E6=B0=B8=E6=B6=9B
>>>=20
>>>=20
>>>=20
>>> --=20
>>> =E7=AC=A6=E6=B0=B8=E6=B6=9B
>>=20
>>=20
>>=20
>> --=20
>> =E7=AC=A6=E6=B0=B8=E6=B6=9B
>=20
>=20
>=20
> --=20
> =E7=AC=A6=E6=B0=B8=E6=B6=9B
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

--Apple-Mail-62731709-7EC0-4766-B0C5-9A69AD6915EE
Content-Type: text/html;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html><head><meta http-equiv=3D"content-type" content=3D"text/html; charset=3D=
utf-8"></head><body dir=3D"auto"><div>On Apr 16, 2013, at 8:48 PM, =E7=AC=A6=
=E6=B0=B8=E6=B6=9B &lt;<a href=3D"mailto:yongtaofu@gmail.com">yongtaofu@gmai=
l.com</a>&gt; wrote:<br><br></div><blockquote type=3D"cite"><div><div dir=3D=
"ltr"><div><div>Hi Brain,<br></div>Can I change as following?<br></div></div=
></div></blockquote><div><br></div>ASSERTS are no-ops in a non-debug kernel,=
 so this won't change any behavior. &nbsp;I hope we'll know more if we get n=
ew traces from your patched kernel....<div><br></div><div>Eric</div><div><br=
><blockquote type=3D"cite"><div><div dir=3D"ltr"><div>--- a/xfs_inode.c<br>+=
++ b/xfs_inode.c<br>@@ -1773,6 +1773,8 @@ xfs_iunlink_remove(<br>&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (last_ibp !=3D NULL) {=
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; xfs_trans_brelse(tp, last_ibp);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br>+&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ASSERT(next_agino !=3D=
 NULLAGINO);<br>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; ASSERT(next_agino !=3D 0);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; next_ino =3D XFS_AGINO_TO_INO(mp, agno, next_agino);<br=
>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; error =3D xfs=
_inotobp(mp, tp, next_ino, &amp;last_dip,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &=
amp;last_ibp, &amp;last_offset, 0);<br>@@ -1783,8 +1785,6 @@ xfs_iunlink_rem=
ove(<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return error;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br>&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; next_agino =3D be32_t=
o_cpu(last_dip-&gt;di_next_unlinked);<br>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp; ASSERT(next_agino !=3D NULLAGINO);<br>-&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ASSERT(next_agino !=3D 0);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; }<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Now last_ibp=
 points to the buffer previous to us on<br><br></div>Thank you.<br></div><di=
v class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">2013/4/17 =E7=AC=A6=
=E6=B0=B8=E6=B6=9B <span dir=3D"ltr">&lt;<a href=3D"mailto:yongtaofu@gmail.c=
om" target=3D"_blank">yongtaofu@gmail.com</a>&gt;</span><br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px=
 #ccc solid;padding-left:1ex"><div dir=3D"ltr"><div><div><div>Hi Brain,<br><=
/div>If it is because NULLAGINO is passed in&nbsp; to xfs_inotobp().<br></di=
v>Can I move the following two lines before xfs_inotobp?<br>
<br>For example:<br><br>1767&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; while (next_agino !=3D agin=
o) {<br>
1768&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*<=
br>1769&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; * If the last inode wasn't the one pointing to<br>1770&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * us, then releas=
e its buffer since we're not<br>1771&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * going to do anything with it.<br>

1772&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; */<br>1773&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; if (last_ibp !=3D NULL) {<br>1774&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; xfs_trans_brelse(tp, last_ibp);<br>1775&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br>1776&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; next_ino =3D XFS_AGINO_TO_INO(mp, agno=
, next_agino);<br>

+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp=
; &nbsp;&nbsp; ASSERT(next_agino !=3D NULLAGINO);<br>+&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ASSERT(next_agino !=
=3D 0);<br>1777&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; error =3D xfs_inotobp(mp, tp, next_ino, &amp;last_dip,<br>1778&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &amp;last_ibp, &amp;last_offset, 0);<br>

1779&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (=
error) {<br>1780&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; xfs_warn(mp,<br>178=
1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; "%s: xfs_inotobp() returned error %d.",<br>1782&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; __=
func__, error);<br>

1783&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return error;<br>1784&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br>1785&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; next_agino =3D b=
e32_to_cpu(last_dip-&gt;di_next_unlinked);<br>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; //ASSERT(next_agino !=
=3D NULLAGINO);<br>

-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //ASSERT(next_agino !=3D 0);<br>1788&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; }<br></div>I don't understand xfs well and correct me if I'm tota=
lly wrong.<br><div><div><div>Thank you very much.<br></div></div>

</div></div><div class=3D"gmail_extra"><div><div class=3D"h5"><br><br><div c=
lass=3D"gmail_quote">2013/4/17 =E7=AC=A6=E6=B0=B8=E6=B6=9B <span dir=3D"ltr"=
>&lt;<a href=3D"mailto:yongtaofu@gmail.com" target=3D"_blank">yongtaofu@gmai=
l.com</a>&gt;</span><br><blockquote class=3D"gmail_quote" style=3D"margin:0 0=
 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">

<div dir=3D"ltr">Hi Brain,<div>I want to ask a question, according to the sh=
utdown trace. The ino in<font face=3D"arial, sans-serif"><span style=3D"font=
-size:14px">&nbsp;</span></font><span style=3D"font-family:arial,sans-serif;=
font-size:14px">&nbsp;</span><span style=3D"font-family:arial,sans-serif;fon=
t-size:14px">xfs_iunlink_remove is&nbsp;</span><span style=3D"font-family:ar=
ial,sans-serif;font-size:14px">0x113, why&nbsp;</span><span style=3D"font-fa=
mily:arial,sans-serif;font-size:14px">xfs_imap got&nbsp;</span><span style=3D=
"font-family:arial,sans-serif;font-size:14px">ino=3D0xffffffff</span><span s=
tyle=3D"font-family:arial,sans-serif;font-size:14px">&nbsp;?&nbsp;</span></d=
iv>


<div><span style=3D"font-family:arial,sans-serif;font-size:14px"><br></span>=
</div><div><span style=3D"font-family:arial,sans-serif;font-size:14px">--- x=
fs_imap -- module("xfs").function("xfs_</span><span style=3D"font-family:ari=
al,sans-serif;font-size:14px">imap@fs/xfs/xfs_ialloc.c:1257"</span><span sty=
le=3D"font-family:arial,sans-serif;font-size:14px">).return -- return=3D0x16=
</span><br style=3D"font-family:arial,sans-serif;font-size:14px">


<span style=3D"font-family:arial,sans-serif;font-size:14px">vars: mp=3D0xfff=
f882017a50800 tp=3D0xffff881c81797c70 ino=3D0xffffffff</span><span style=3D"=
font-family:arial,sans-serif;font-size:14px"><br></span></div><div><span sty=
le=3D"font-family:arial,sans-serif;font-size:14px"><br>


</span></div><div><span style=3D"font-family:arial,sans-serif;font-size:14px=
">--- xfs_iunlink_remove -- module("xfs").function("xfs_</span><span style=3D=
"font-family:arial,sans-serif;font-size:14px">iunlink_remove@fs/xfs/xfs_</sp=
an><span style=3D"font-family:arial,sans-serif;font-size:14px">inode.c:1680"=
).return -- return=3D0x16</span><br style=3D"font-family:arial,sans-serif;fo=
nt-size:14px">


<span style=3D"font-family:arial,sans-serif;font-size:14px">vars: tp=3D0xfff=
f881c81797c70 ip=3D0xffff881003c13c00 next_ino=3D? mp=3D? agi=3D? dip=3D? ag=
ibp=3D0xffff880109b47e20 ibp=3D? agno=3D? agino=3D? next_agino=3D? last_ibp=3D=
? last_dip=3D0xffff882000000000 bucket_index=3D? offset=3D? last_offset=3D0x=
ffffffffffff8810 error=3D? __func__=3D[...]</span><br style=3D"font-family:a=
rial,sans-serif;font-size:14px">


<span style=3D"font-family:arial,sans-serif;font-size:14px">ip: i_ino =3D 0x=
113, i_flags =3D 0x0</span><span style=3D"font-family:arial,sans-serif;font-=
size:14px"><br></span></div><div><span style=3D"font-family:arial,sans-serif=
;font-size:14px"><br>


</span></div><div><span style=3D"font-family:arial,sans-serif;font-size:14px=
">Thank you.</span></div><div><span style=3D"font-family:arial,sans-serif;fo=
nt-size:14px"><br></span></div></div><div class=3D"gmail_extra"><div><div>


<br><br><div class=3D"gmail_quote">2013/4/17 =E7=AC=A6=E6=B0=B8=E6=B6=9B <sp=
an dir=3D"ltr">&lt;<a href=3D"mailto:yongtaofu@gmail.com" target=3D"_blank">=
yongtaofu@gmail.com</a>&gt;</span><br><blockquote class=3D"gmail_quote" styl=
e=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">


<div dir=3D"ltr"><div><div>Hi Brain,<br></div>Thank you for your update, and=
 I have applied your last kernel patch. However it is not easy to reproduce e=
specially in out test environment. Till now is not happens again. I'll updat=
e the kernel patch now. BTW is there any findings in the logs of previous th=
read?<br>



<a href=3D"http://oss.sgi.com/archives/xfs/2013-04/msg00327.html" target=3D"=
_blank">http://oss.sgi.com/archives/xfs/2013-04/msg00327.html</a><br>I guess=
 it tend to happen during glusterfs rebalance because glusterfs moves a lot o=
f file from one server to another and then unlink it.<br>



<br></div>Thank you.<br></div><div class=3D"gmail_extra"><div><div><br><br><=
div class=3D"gmail_quote">2013/4/17 Brian Foster <span dir=3D"ltr">&lt;<a hr=
ef=3D"mailto:bfoster@redhat.com" target=3D"_blank">bfoster@redhat.com</a>&gt=
;</span><br>


<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px=
 #ccc solid;padding-left:1ex">
<div>On 04/16/2013 12:24 PM, Dave Chinner wrote:<br>
&gt; On Mon, Apr 15, 2013 at 07:14:39PM -0400, Brian Foster wrote:<br>
&gt;&gt; Hi,<br>
&gt;&gt;<br>
&gt;&gt; Thanks for the data in the previous thread:<br>
&gt;&gt;<br>
&gt;&gt; <a href=3D"http://oss.sgi.com/archives/xfs/2013-04/msg00327.html" t=
arget=3D"_blank">http://oss.sgi.com/archives/xfs/2013-04/msg00327.html</a><b=
r>
&gt;&gt;<br>
</div>...<br>
<div>&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; &nbsp;echo 1 &gt; /sys/kernel/debug/tracing/events/xf=
s/xfs_iunlink/enable<br>
&gt;&gt; &nbsp; &nbsp; &nbsp;echo 1 &gt; /sys/kernel/debug/tracing/events/xf=
s/xfs_iunlink_remove/enable<br>
&gt;&gt; &nbsp; &nbsp; &nbsp;... reproduce ...<br>
&gt;&gt; &nbsp; &nbsp; &nbsp;cat /sys/kernel/debug/tracing/trace &gt; trace.=
output<br>
&gt;<br>
&gt; It's better to use trace-cmd for this. it will result in less<br>
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
&gt; function, otherwise we won't get a tracepoint for the operation that<br=
>
&gt; triggers the shutdown. (That's the reason most tracepoints in XFS<br>
&gt; are at function entry...)<br>
&gt;<br>
<br>
</div>Good points, thanks Dave. A v2 that pulls up the tracepoints towards<b=
r>
function entry is appended.<br>
<br>
Brian<br>
<br>
=46rom 280943e78ebe0b97a774cba51e7815c42f044b55 Mon Sep 17 00:00:00 2001<br>=

From: Brian Foster &lt;<a href=3D"mailto:bfoster@redhat.com" target=3D"_blan=
k">bfoster@redhat.com</a>&gt;<br>
Date: Mon, 15 Apr 2013 18:16:24 -0400<br>
Subject: [PATCH v2] xfs: add tracepoints for xfs_iunlink and<br>
xfs_iunlink_remove<br>
<div><br>
---<br>
&nbsp;fs/xfs/linux-2.6/xfs_trace.h | &nbsp; &nbsp;2 ++<br>
&nbsp;fs/xfs/xfs_inode.c &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; | &nbsp; &nbsp;4=
 ++++<br>
&nbsp;2 files changed, 6 insertions(+), 0 deletions(-)<br>
<br>
diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h<br>=

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
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;* Get the agi buffer first. &nbsp;It ensur=
es lock ordering<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;* on the list.<br>
@@ -1694,6 +1696,8 @@ xfs_iunlink_remove(<br>
&nbsp; &nbsp; &nbsp; &nbsp; mp =3D tp-&gt;t_mountp;<br>
&nbsp; &nbsp; &nbsp; &nbsp; agno =3D XFS_INO_TO_AGNO(mp, ip-&gt;i_ino);<br>
<br>
+ &nbsp; &nbsp; &nbsp; trace_xfs_iunlink_remove(ip);<br>
+<br>
&nbsp; &nbsp; &nbsp; &nbsp; /*<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;* Get the agi buffer first. &nbsp;It ensur=
es lock ordering<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;* on the list.<br>
<span><font color=3D"#888888">--<br>
1.7.7.6<br>
<br>
</font></span></blockquote></div><br><br clear=3D"all"><br></div></div><span=
><font color=3D"#888888">-- <br>=E7=AC=A6=E6=B0=B8=E6=B6=9B
</font></span></div>
</blockquote></div><br><br clear=3D"all"><div><br></div></div></div><span><f=
ont color=3D"#888888">-- <br>=E7=AC=A6=E6=B0=B8=E6=B6=9B
</font></span></div>
</blockquote></div><br><br clear=3D"all"><br></div></div><span class=3D"HOEn=
Zb"><font color=3D"#888888">-- <br>=E7=AC=A6=E6=B0=B8=E6=B6=9B
</font></span></div>
</blockquote></div><br><br clear=3D"all"><br>-- <br>=E7=AC=A6=E6=B0=B8=E6=B6=
=9B
</div>
</div></blockquote><blockquote type=3D"cite"><div><span>____________________=
___________________________</span><br><span>xfs mailing list</span><br><span=
><a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a></span><br><span><a h=
ref=3D"http://oss.sgi.com/mailman/listinfo/xfs">http://oss.sgi.com/mailman/l=
istinfo/xfs</a></span><br></div></blockquote></div></body></html>=

--Apple-Mail-62731709-7EC0-4766-B0C5-9A69AD6915EE--


--===============5155864142524365826==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5155864142524365826==--
