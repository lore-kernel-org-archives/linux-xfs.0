Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4865D29DFA
	for <xfs@oss.sgi.com>; Wed, 24 Apr 2013 19:48:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D0ED5AC002
	for <xfs@oss.sgi.com>; Wed, 24 Apr 2013 17:48:28 -0700 (PDT)
Received: from mail-ie0-f178.google.com (mail-ie0-f178.google.com
	[209.85.223.178]) by cuda.sgi.com with ESMTP id
	FAUyQTPDxKlzS86w (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 24 Apr 2013 17:48:27 -0700 (PDT)
Received: by mail-ie0-f178.google.com with SMTP id aq17so2891440iec.37
	for <xfs@oss.sgi.com>; Wed, 24 Apr 2013 17:48:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADFMGuKbUWhRc32yjVqJ9eJoUXSutqprG5VpRHGSxBxB=z_5nA@mail.gmail.com>
References: <516C89DF.4070904@redhat.com> <517596BA.3060408@sandeen.net>
	<20130423000835.GL30622@dastard> <5175DB63.6030501@sandeen.net>
	<20130424090213.GT10481@dastard>
	<CADFMGuKbUWhRc32yjVqJ9eJoUXSutqprG5VpRHGSxBxB=z_5nA@mail.gmail.com>
Date: Thu, 25 Apr 2013 08:48:26 +0800
Message-ID: <CADFMGuJ9cgWuOm4NyO=d8iG403-NUWQcRuiFbvQEzpkp+=yuHg@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============0830825689449908992=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============0830825689449908992==
Content-Type: multipart/alternative; boundary=90e6ba3fcee3be4aa904db24c6e8

--90e6ba3fcee3be4aa904db24c6e8
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

Sorry I make it wrong, I'll change it a little bit and test again, thank
you.


2013/4/24 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com>

> Dear Eric and Dave,
> The xfs shutdown seems go away however one of our server report the
> following error it make glusterfsd hang again. Is this just related to hi=
gh
> load? Or the same issue with different behavior after change the vfs.
> Apr 24 12:35:07 10 kernel: [<ffffffff8100b072>]
> system_call_fastpath+0x16/0x1b
> Apr 24 12:37:07 10 kernel: INFO: task glusterfsd:5835 blocked for more
> than 120 seconds.
> Apr 24 12:37:07 10 kernel: "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Apr 24 12:37:07 10 kernel: glusterfsd    D 0000000000000003     0
> 5835      1 0x00000080
> Apr 24 12:37:07 10 kernel: ffff88100ed77a28 0000000000000082
> 0000000000000000 ffff8818e843cdd8
> Apr 24 12:37:07 10 kernel: ffff8810177c1bc0 ffff8818e8422ea0
> 0000000000004004 ffff882019453000
> Apr 24 12:37:07 10 kernel: ffff88101609b098 ffff88100ed77fd8
> 000000000000fb88 ffff88101609b098
> Apr 24 12:37:07 10 kernel: Call Trace:
> Apr 24 12:37:07 10 kernel: [<ffffffff814eaad5>]
> schedule_timeout+0x215/0x2e0
> Apr 24 12:37:07 10 kernel: [<ffffffffa02a4978>] ?
> xfs_da_do_buf+0x618/0x770 [xfs]
> Apr 24 12:37:07 10 kernel: [<ffffffff814eb9f2>] __down+0x72/0xb0
> Apr 24 12:37:07 10 kernel: [<ffffffffa02daae2>] ?
> _xfs_buf_find+0x102/0x280 [xfs]
> Apr 24 12:37:07 10 kernel: [<ffffffff810967f1>] down+0x41/0x50
> Apr 24 12:37:07 10 kernel: [<ffffffffa02da923>] xfs_buf_lock+0x53/0x110
> [xfs]
> Apr 24 12:37:07 10 kernel: [<ffffffffa02daae2>] _xfs_buf_find+0x102/0x280
> [xfs]
> Apr 24 12:37:07 10 kernel: [<ffffffffa02daccb>] xfs_buf_get+0x6b/0x1a0
> [xfs]
> Apr 24 12:37:07 10 kernel: [<ffffffffa02db33c>] xfs_buf_read+0x2c/0x100
> [xfs]
> Apr 24 12:37:07 10 kernel: [<ffffffffa02d0f88>]
> xfs_trans_read_buf+0x1f8/0x400 [xfs]
> Apr 24 12:37:07 10 kernel: [<ffffffffa02b3774>] xfs_read_agi+0x74/0x100
> [xfs]
> Apr 24 12:37:07 10 kernel: [<ffffffffa02b999b>] xfs_iunlink+0x4b/0x170
> [xfs]
> Apr 24 12:37:07 10 kernel: [<ffffffff81070f97>] ? current_fs_time+0x27/0x=
30
> Apr 24 12:37:07 10 kernel: [<ffffffffa02d1737>] ?
> xfs_trans_ichgtime+0x27/0xa0 [xfs]
> Apr 24 12:37:07 10 kernel: [<ffffffffa02d1a8b>] xfs_droplink+0x5b/0x70
> [xfs]
> Apr 24 12:37:07 10 kernel: [<ffffffffa02d342e>] xfs_remove+0x27e/0x3a0
> [xfs]
> Apr 24 12:37:07 10 kernel: [<ffffffff8118215c>] ?
> generic_permission+0x5c/0xb0
> Apr 24 12:37:07 10 kernel: [<ffffffffa02e0da8>] xfs_vn_unlink+0x48/0x90
> [xfs]
> Apr 24 12:37:07 10 kernel: [<ffffffff81183d6f>] vfs_unlink+0x9f/0xe0
> Apr 24 12:37:07 10 kernel: [<ffffffff81182aaa>] ? lookup_hash+0x3a/0x50
> Apr 24 12:37:07 10 kernel: [<ffffffff811862a3>] do_unlinkat+0x183/0x1c0
> Apr 24 12:37:07 10 kernel: [<ffffffff8117b876>] ? sys_newstat+0x36/0x50
> Apr 24 12:37:07 10 kernel: [<ffffffff811862f6>] sys_unlink+0x16/0x20
> Apr 24 12:37:07 10 kernel: [<ffffffff8100b072>]
> system_call_fastpath+0x16/0x1b
> .
>
> BTW:
> I use kernel 279.19.1
> 2675         mutex_lock(&inode->i_mutex);
> 2676         /* Make sure we don't allow creating hardlink to an unlinked
> file */
> 2677         if (inode->i_nlink =3D=3D 0)
> 2678                 error =3D  -ENOENT;
> 2679         else
> 2680                 vfs_dq_init(dir);
> 2681                 error =3D dir->i_op->link(old_dentry, dir, new_dentr=
y);
> 2682         mutex_unlock(&inode->i_mutex);
>
> Thank you.
>
>
> 2013/4/24 Dave Chinner <david@fromorbit.com>
>
>> On Mon, Apr 22, 2013 at 07:52:51PM -0500, Eric Sandeen wrote:
>> > On 4/22/13 7:08 PM, Dave Chinner wrote:
>> > > On Mon, Apr 22, 2013 at 02:59:54PM -0500, Eric Sandeen wrote:
>> > >> On 4/15/13 6:14 PM, Brian Foster wrote:
>> > >>> Hi,
>> > >>>
>> > >>> Thanks for the data in the previous thread:
>> > >>>
>> > >>> http://oss.sgi.com/archives/xfs/2013-04/msg00327.html
>> > >>>
>> > >>> I'm spinning off a new thread specifically for this because the
>> original
>> > >>> thread is already too large and scattered to track. As Eric stated=
,
>> > >>> please try to keep data contained in as few messages as possible.
>> > >>>
>> > >>
>> > >> Well, it's always simple in the end.  It just took a lot of debuggi=
ng
>> > >> to figure out what was happening - we do appreciate your help with
>> that!
>> > >>
>> > >> We were able to create a local reproducer, and it looks like
>> > >> this patch fixes things:
>> > >>
>> > >> commit aae8a97d3ec30788790d1720b71d76fd8eb44b73
>> > >> Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>> > >> Date:   Sat Jan 29 18:43:27 2011 +0530
>> > >>
>> > >>     fs: Don't allow to create hardlink for deleted file
>> > >
>> > > Good find Eric - great work on the reproducer script.
>> > >
>> > > FWIW, can you confirm that a debug kernel assert fails
>> > > with a non-zero link count in xfs_bumplink() with your test case?
>> > >
>> > > int
>> > > xfs_bumplink(
>> > >         xfs_trans_t *tp,
>> > >         xfs_inode_t *ip)
>> > > {
>> > >         xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
>> > >
>> > >>>>>>   ASSERT(ip->i_d.di_nlink > 0);
>> >
>> > Yep, it does, I put a printk in there when I was testing
>> > and it fired.
>> >
>> > Guess we should have tested a debug xfs right off the bat ;)
>>
>> Perhaps, but that may have changed the timing sufficiently to make
>> the race go away. What we really needed was a way to just turn the
>> assert into a WARN_ON() without all the other debug code like we've
>> previously talked about. So, rather than talk about it again, I
>> posted patches to do this....
>>
>> > >         ip->i_d.di_nlink++;
>> > >         inc_nlink(VFS_I(ip));
>> > >
>> > > If it does, we should consider this a in-memory corruption case and
>> > > return and trigger a shutdown here....
>> >
>> > I suppose that makes sense, it'd be a much less cryptic failure for
>> > something that will fail soon anyway.
>>
>> Exactly.
>>
>> Cheers,
>>
>> Dave.
>> --
>> Dave Chinner
>> david@fromorbit.com
>>
>
>
>
> --
> =B7=FB=D3=C0=CC=CE
>



--=20
=B7=FB=D3=C0=CC=CE

--90e6ba3fcee3be4aa904db24c6e8
Content-Type: text/html; charset=GB2312
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Sorry I make it wrong, I&#39;ll change it a&nbsp;little bi=
t and test again, thank you.&nbsp;</div><div class=3D"gmail_extra"><br><br>=
<div class=3D"gmail_quote">2013/4/24 =B7=FB=D3=C0=CC=CE <span dir=3D"ltr">&=
lt;<a href=3D"mailto:yongtaofu@gmail.com" target=3D"_blank">yongtaofu@gmail=
.com</a>&gt;</span><br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div dir=3D"ltr"><div><div><div><div>Dear Er=
ic and Dave,<br></div>The xfs shutdown seems go away however one of our ser=
ver report the following error it make glusterfsd hang again. Is this just =
related to high load? Or the same issue with different behavior after chang=
e the vfs.<br>

Apr 24 12:35:07 10 kernel: [&lt;ffffffff8100b072&gt;] system_call_fastpath+=
0x16/0x1b<br>Apr 24 12:37:07 10 kernel: INFO: task glusterfsd:5835 blocked =
for more than 120 seconds.<br>Apr 24 12:37:07 10 kernel: &quot;echo 0 &gt; =
/proc/sys/kernel/hung_task_timeout_secs&quot; disables this message.<br>

Apr 24 12:37:07 10 kernel: glusterfsd&nbsp;&nbsp;&nbsp; D 0000000000000003&=
nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp; 5835&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 0x0000=
0080<br>Apr 24 12:37:07 10 kernel: ffff88100ed77a28 0000000000000082 000000=
0000000000 ffff8818e843cdd8<br>Apr 24 12:37:07 10 kernel: ffff8810177c1bc0 =
ffff8818e8422ea0 0000000000004004 ffff882019453000<br>

Apr 24 12:37:07 10 kernel: ffff88101609b098 ffff88100ed77fd8 000000000000fb=
88 ffff88101609b098<br>Apr 24 12:37:07 10 kernel: Call Trace:<br>Apr 24 12:=
37:07 10 kernel: [&lt;ffffffff814eaad5&gt;] schedule_timeout+0x215/0x2e0<br=
>

Apr 24 12:37:07 10 kernel: [&lt;ffffffffa02a4978&gt;] ? xfs_da_do_buf+0x618=
/0x770 [xfs]<br>Apr 24 12:37:07 10 kernel: [&lt;ffffffff814eb9f2&gt;] __dow=
n+0x72/0xb0<br>Apr 24 12:37:07 10 kernel: [&lt;ffffffffa02daae2&gt;] ? _xfs=
_buf_find+0x102/0x280 [xfs]<br>

Apr 24 12:37:07 10 kernel: [&lt;ffffffff810967f1&gt;] down+0x41/0x50<br>Apr=
 24 12:37:07 10 kernel: [&lt;ffffffffa02da923&gt;] xfs_buf_lock+0x53/0x110 =
[xfs]<br>Apr 24 12:37:07 10 kernel: [&lt;ffffffffa02daae2&gt;] _xfs_buf_fin=
d+0x102/0x280 [xfs]<br>

Apr 24 12:37:07 10 kernel: [&lt;ffffffffa02daccb&gt;] xfs_buf_get+0x6b/0x1a=
0 [xfs]<br>Apr 24 12:37:07 10 kernel: [&lt;ffffffffa02db33c&gt;] xfs_buf_re=
ad+0x2c/0x100 [xfs]<br>Apr 24 12:37:07 10 kernel: [&lt;ffffffffa02d0f88&gt;=
] xfs_trans_read_buf+0x1f8/0x400 [xfs]<br>

Apr 24 12:37:07 10 kernel: [&lt;ffffffffa02b3774&gt;] xfs_read_agi+0x74/0x1=
00 [xfs]<br>Apr 24 12:37:07 10 kernel: [&lt;ffffffffa02b999b&gt;] xfs_iunli=
nk+0x4b/0x170 [xfs]<br>Apr 24 12:37:07 10 kernel: [&lt;ffffffff81070f97&gt;=
] ? current_fs_time+0x27/0x30<br>

Apr 24 12:37:07 10 kernel: [&lt;ffffffffa02d1737&gt;] ? xfs_trans_ichgtime+=
0x27/0xa0 [xfs]<br>Apr 24 12:37:07 10 kernel: [&lt;ffffffffa02d1a8b&gt;] xf=
s_droplink+0x5b/0x70 [xfs]<br>Apr 24 12:37:07 10 kernel: [&lt;ffffffffa02d3=
42e&gt;] xfs_remove+0x27e/0x3a0 [xfs]<br>

Apr 24 12:37:07 10 kernel: [&lt;ffffffff8118215c&gt;] ? generic_permission+=
0x5c/0xb0<br>Apr 24 12:37:07 10 kernel: [&lt;ffffffffa02e0da8&gt;] xfs_vn_u=
nlink+0x48/0x90 [xfs]<br>Apr 24 12:37:07 10 kernel: [&lt;ffffffff81183d6f&g=
t;] vfs_unlink+0x9f/0xe0<br>

Apr 24 12:37:07 10 kernel: [&lt;ffffffff81182aaa&gt;] ? lookup_hash+0x3a/0x=
50<br>Apr 24 12:37:07 10 kernel: [&lt;ffffffff811862a3&gt;] do_unlinkat+0x1=
83/0x1c0<br>Apr 24 12:37:07 10 kernel: [&lt;ffffffff8117b876&gt;] ? sys_new=
stat+0x36/0x50<br>

Apr 24 12:37:07 10 kernel: [&lt;ffffffff811862f6&gt;] sys_unlink+0x16/0x20<=
br>Apr 24 12:37:07 10 kernel: [&lt;ffffffff8100b072&gt;] system_call_fastpa=
th+0x16/0x1b<br>.<br><br></div>BTW:<br></div>I use kernel 279.19.1<br>
2675&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mutex_lock(&amp;inode-=
&gt;i_mutex);<br>
2676&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Make sure we don&#3=
9;t allow creating hardlink to an unlinked file */<br>2677&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (inode-&gt;i_nlink =3D=3D 0)<br>2678&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp; error =3D&nbsp; -ENOENT;<br>2679&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp; else<br>2680&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; vfs_dq_init(dir);=
<br>

2681&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; error =3D dir-&gt;i_op-&gt;link(old_dentry, dir, =
new_dentry);<br>2682&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mutex_=
unlock(&amp;inode-&gt;i_mutex);<br><br></div>Thank you.<br></div><div class=
=3D"gmail_extra"><div><div class=3D"h5"><br><br>
<div class=3D"gmail_quote">
2013/4/24 Dave Chinner <span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromor=
bit.com" target=3D"_blank">david@fromorbit.com</a>&gt;</span><br><blockquot=
e class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc sol=
id;padding-left:1ex">

<div><div>On Mon, Apr 22, 2013 at 07:52:51PM -0500, Eric Sandeen wrote:<br>
&gt; On 4/22/13 7:08 PM, Dave Chinner wrote:<br>
&gt; &gt; On Mon, Apr 22, 2013 at 02:59:54PM -0500, Eric Sandeen wrote:<br>
&gt; &gt;&gt; On 4/15/13 6:14 PM, Brian Foster wrote:<br>
&gt; &gt;&gt;&gt; Hi,<br>
&gt; &gt;&gt;&gt;<br>
&gt; &gt;&gt;&gt; Thanks for the data in the previous thread:<br>
&gt; &gt;&gt;&gt;<br>
&gt; &gt;&gt;&gt; <a href=3D"http://oss.sgi.com/archives/xfs/2013-04/msg003=
27.html" target=3D"_blank">http://oss.sgi.com/archives/xfs/2013-04/msg00327=
.html</a><br>
&gt; &gt;&gt;&gt;<br>
&gt; &gt;&gt;&gt; I&#39;m spinning off a new thread specifically for this b=
ecause the original<br>
&gt; &gt;&gt;&gt; thread is already too large and scattered to track. As Er=
ic stated,<br>
&gt; &gt;&gt;&gt; please try to keep data contained in as few messages as p=
ossible.<br>
&gt; &gt;&gt;&gt;<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; Well, it&#39;s always simple in the end. &nbsp;It just took a=
 lot of debugging<br>
&gt; &gt;&gt; to figure out what was happening - we do appreciate your help=
 with that!<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; We were able to create a local reproducer, and it looks like<=
br>
&gt; &gt;&gt; this patch fixes things:<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; commit aae8a97d3ec30788790d1720b71d76fd8eb44b73<br>
&gt; &gt;&gt; Author: Aneesh Kumar K.V &lt;<a href=3D"mailto:aneesh.kumar@l=
inux.vnet.ibm.com" target=3D"_blank">aneesh.kumar@linux.vnet.ibm.com</a>&gt=
;<br>
&gt; &gt;&gt; Date: &nbsp; Sat Jan 29 18:43:27 2011 +0530<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; &nbsp; &nbsp; fs: Don&#39;t allow to create hardlink for dele=
ted file<br>
&gt; &gt;<br>
&gt; &gt; Good find Eric - great work on the reproducer script.<br>
&gt; &gt;<br>
&gt; &gt; FWIW, can you confirm that a debug kernel assert fails<br>
&gt; &gt; with a non-zero link count in xfs_bumplink() with your test case?=
<br>
&gt; &gt;<br>
&gt; &gt; int<br>
&gt; &gt; xfs_bumplink(<br>
&gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp; xfs_trans_t *tp,<br>
&gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp; xfs_inode_t *ip)<br>
&gt; &gt; {<br>
&gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp; xfs_trans_ichgtime(tp, ip, XFS_ICHGTI=
ME_CHG);<br>
&gt; &gt;<br>
&gt; &gt;&gt;&gt;&gt;&gt;&gt; &nbsp; ASSERT(ip-&gt;i_d.di_nlink &gt; 0);<br=
>
&gt;<br>
&gt; Yep, it does, I put a printk in there when I was testing<br>
&gt; and it fired.<br>
&gt;<br>
&gt; Guess we should have tested a debug xfs right off the bat ;)<br>
<br>
</div></div>Perhaps, but that may have changed the timing sufficiently to m=
ake<br>
the race go away. What we really needed was a way to just turn the<br>
assert into a WARN_ON() without all the other debug code like we&#39;ve<br>
previously talked about. So, rather than talk about it again, I<br>
posted patches to do this....<br>
<div><br>
&gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp; ip-&gt;i_d.di_nlink++;<br>
&gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp; inc_nlink(VFS_I(ip));<br>
&gt; &gt;<br>
&gt; &gt; If it does, we should consider this a in-memory corruption case a=
nd<br>
&gt; &gt; return and trigger a shutdown here....<br>
&gt;<br>
&gt; I suppose that makes sense, it&#39;d be a much less cryptic failure fo=
r<br>
&gt; something that will fail soon anyway.<br>
<br>
</div>Exactly.<br>
<div><div><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.co=
m</a><br>
</div></div></blockquote></div><br><br clear=3D"all"><br></div></div><span =
class=3D"HOEnZb"><font color=3D"#888888">-- <br>=B7=FB=D3=C0=CC=CE
</font></span></div>
</blockquote></div><br><br clear=3D"all"><div><br></div>-- <br>=B7=FB=D3=C0=
=CC=CE
</div>

--90e6ba3fcee3be4aa904db24c6e8--


--===============0830825689449908992==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0830825689449908992==--
