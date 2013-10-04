Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 46B077F4E
	for <xfs@oss.sgi.com>; Fri,  4 Oct 2013 12:51:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 296DD8F8040
	for <xfs@oss.sgi.com>; Fri,  4 Oct 2013 10:51:53 -0700 (PDT)
Received: from mail-we0-f181.google.com (mail-we0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id JOFCDBAWwfEPX9m4
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 04 Oct 2013 10:51:51 -0700 (PDT)
Received: by mail-we0-f181.google.com with SMTP id p61so5083187wes.12
	for <xfs@oss.sgi.com>; Fri, 04 Oct 2013 10:51:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131002104253.GT12541@dastard>
References: <CAGa4098ZKd2KQfWMgNXYgLr9LJF8r-MpFgQAn3G-W+ovDGHTAw@mail.gmail.com>
	<20131001201909.GR12541@dastard>
	<CAGa409_tDjbsdnf+wDiM7666FeQSjmMfOVdqG-SxOD_WUZMiZQ@mail.gmail.com>
	<20131002104253.GT12541@dastard>
Date: Fri, 4 Oct 2013 10:51:50 -0700
Message-ID: <CAGa409_wO74zGP1d85RGZ7WbfBPr7s_tKaW3u9k8=9Ps-D5FjQ@mail.gmail.com>
Subject: Re: xfs_repair segfault
From: Viet Nguyen <vietnguyen@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7486735256180452980=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============7486735256180452980==
Content-Type: multipart/alternative; boundary=047d7b5d9c6bfd2d4804e7edf4e8

--047d7b5d9c6bfd2d4804e7edf4e8
Content-Type: text/plain; charset=ISO-8859-1

Hi,

I was wondering if you got a chance to look at this and if one's available,
where can I get a patch?

Thanks!
Viet


On Wed, Oct 2, 2013 at 3:42 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Oct 01, 2013 at 02:12:16PM -0700, Viet Nguyen wrote:
> > Hi again,
> > Here's the stack trace:
> >
> > #0  __xfs_dir3_data_check (dp=<value optimized out>, bp=<value optimized
> > out>) at xfs_dir2_data.c:149
> > #1  0x0000000000451d32 in xfs_dir3_block_verify (bp=0x94369210) at
> > xfs_dir2_block.c:62
> > #2  0x0000000000451ed1 in xfs_dir3_block_read_verify (bp=0x94369210) at
> > xfs_dir2_block.c:73
> > #3  0x0000000000431e2a in libxfs_readbuf (btp=0x6aaca0, blkno=5292504,
> > len=8, flags=0, ops=0x478c60) at rdwr.c:718
> > #4  0x0000000000412295 in da_read_buf (mp=0x7fffffffe090, nex=1,
> bmp=<value
> > optimized out>, ops=<value optimized out>) at dir2.c:129
> > #5  0x0000000000415c26 in process_block_dir2 (mp=0x7fffffffe090,
> > ino=8639864, dip=0x95030000, ino_discovery=1, dino_dirty=<value optimized
> > out>, dirname=0x472201 "", parent=0x7fffffffdf28, blkmap=0x7ffff0342010)
> at
> > dir2.c:1594
> > #6  process_dir2 (mp=0x7fffffffe090, ino=8639864, dip=0x95030000,
> > ino_discovery=1, dino_dirty=<value optimized out>, dirname=0x472201 "",
> > parent=0x7fffffffdf28, blkmap=0x7ffff0342010) at dir2.c:1993
> > #7  0x0000000000411e6c in process_dinode_int (mp=0x7fffffffe090,
> > dino=0x95030000, agno=1, ino=0, was_free=0, dirty=0x7fffffffdf38,
> > used=0x7fffffffdf3c, verify_mode=0, uncertain=0, ino_discovery=1,
> > check_dups=0, extra_attr_check=1, isa_dir=0x7fffffffdf34,
> >     parent=0x7fffffffdf28) at dinode.c:2859
> > #8  0x000000000041213e in process_dinode (mp=<value optimized out>,
> > dino=<value optimized out>, agno=<value optimized out>, ino=<value
> > optimized out>, was_free=<value optimized out>, dirty=<value optimized
> > out>, used=0x7fffffffdf3c, ino_discovery=1, check_dups=0,
> >     extra_attr_check=1, isa_dir=0x7fffffffdf34, parent=0x7fffffffdf28) at
> > dinode.c:2967
> > #9  0x000000000040a870 in process_inode_chunk (mp=0x7fffffffe090, agno=0,
> > num_inos=<value optimized out>, first_irec=0x7fff5d63f320,
> ino_discovery=1,
> > check_dups=0, extra_attr_check=1, bogus=0x7fffffffdfcc) at
> dino_chunks.c:772
> > #10 0x000000000040ae97 in process_aginodes (mp=0x7fffffffe090,
> pf_args=0x0,
> > agno=0, ino_discovery=1, check_dups=0, extra_attr_check=1) at
> > dino_chunks.c:1014
> > #11 0x000000000041978d in process_ag_func (wq=0x695f40, agno=0, arg=0x0)
> at
> > phase3.c:77
> > #12 0x0000000000419bac in process_ags (mp=0x7fffffffe090) at phase3.c:116
> > #13 phase3 (mp=0x7fffffffe090) at phase3.c:155
> > #14 0x000000000042d200 in main (argc=<value optimized out>, argv=<value
> > optimized out>) at xfs_repair.c:749
>
> Looks like an out of range entry count. it's not checked for
> validity before it is used. I'll try to whip up a fix
> tomorrow.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--047d7b5d9c6bfd2d4804e7edf4e8
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div><br></div><div>I was wondering if you got a chance=
 to look at this and if one&#39;s available, where can I get a patch?</div>=
<div><br></div><div>Thanks!</div><div>Viet</div></div><div class=3D"gmail_e=
xtra">
<br><br><div class=3D"gmail_quote">On Wed, Oct 2, 2013 at 3:42 AM, Dave Chi=
nner <span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D=
"_blank">david@fromorbit.com</a>&gt;</span> wrote:<br><blockquote class=3D"=
gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-=
left:1ex">
<div class=3D"HOEnZb"><div class=3D"h5">On Tue, Oct 01, 2013 at 02:12:16PM =
-0700, Viet Nguyen wrote:<br>
&gt; Hi again,<br>
&gt; Here&#39;s the stack trace:<br>
&gt;<br>
&gt; #0 =A0__xfs_dir3_data_check (dp=3D&lt;value optimized out&gt;, bp=3D&l=
t;value optimized<br>
&gt; out&gt;) at xfs_dir2_data.c:149<br>
&gt; #1 =A00x0000000000451d32 in xfs_dir3_block_verify (bp=3D0x94369210) at=
<br>
&gt; xfs_dir2_block.c:62<br>
&gt; #2 =A00x0000000000451ed1 in xfs_dir3_block_read_verify (bp=3D0x9436921=
0) at<br>
&gt; xfs_dir2_block.c:73<br>
&gt; #3 =A00x0000000000431e2a in libxfs_readbuf (btp=3D0x6aaca0, blkno=3D52=
92504,<br>
&gt; len=3D8, flags=3D0, ops=3D0x478c60) at rdwr.c:718<br>
&gt; #4 =A00x0000000000412295 in da_read_buf (mp=3D0x7fffffffe090, nex=3D1,=
 bmp=3D&lt;value<br>
&gt; optimized out&gt;, ops=3D&lt;value optimized out&gt;) at dir2.c:129<br=
>
&gt; #5 =A00x0000000000415c26 in process_block_dir2 (mp=3D0x7fffffffe090,<b=
r>
&gt; ino=3D8639864, dip=3D0x95030000, ino_discovery=3D1, dino_dirty=3D&lt;v=
alue optimized<br>
&gt; out&gt;, dirname=3D0x472201 &quot;&quot;, parent=3D0x7fffffffdf28, blk=
map=3D0x7ffff0342010) at<br>
&gt; dir2.c:1594<br>
&gt; #6 =A0process_dir2 (mp=3D0x7fffffffe090, ino=3D8639864, dip=3D0x950300=
00,<br>
&gt; ino_discovery=3D1, dino_dirty=3D&lt;value optimized out&gt;, dirname=
=3D0x472201 &quot;&quot;,<br>
&gt; parent=3D0x7fffffffdf28, blkmap=3D0x7ffff0342010) at dir2.c:1993<br>
&gt; #7 =A00x0000000000411e6c in process_dinode_int (mp=3D0x7fffffffe090,<b=
r>
&gt; dino=3D0x95030000, agno=3D1, ino=3D0, was_free=3D0, dirty=3D0x7fffffff=
df38,<br>
&gt; used=3D0x7fffffffdf3c, verify_mode=3D0, uncertain=3D0, ino_discovery=
=3D1,<br>
&gt; check_dups=3D0, extra_attr_check=3D1, isa_dir=3D0x7fffffffdf34,<br>
&gt; =A0 =A0 parent=3D0x7fffffffdf28) at dinode.c:2859<br>
&gt; #8 =A00x000000000041213e in process_dinode (mp=3D&lt;value optimized o=
ut&gt;,<br>
&gt; dino=3D&lt;value optimized out&gt;, agno=3D&lt;value optimized out&gt;=
, ino=3D&lt;value<br>
&gt; optimized out&gt;, was_free=3D&lt;value optimized out&gt;, dirty=3D&lt=
;value optimized<br>
&gt; out&gt;, used=3D0x7fffffffdf3c, ino_discovery=3D1, check_dups=3D0,<br>
&gt; =A0 =A0 extra_attr_check=3D1, isa_dir=3D0x7fffffffdf34, parent=3D0x7ff=
fffffdf28) at<br>
&gt; dinode.c:2967<br>
&gt; #9 =A00x000000000040a870 in process_inode_chunk (mp=3D0x7fffffffe090, =
agno=3D0,<br>
&gt; num_inos=3D&lt;value optimized out&gt;, first_irec=3D0x7fff5d63f320, i=
no_discovery=3D1,<br>
&gt; check_dups=3D0, extra_attr_check=3D1, bogus=3D0x7fffffffdfcc) at dino_=
chunks.c:772<br>
&gt; #10 0x000000000040ae97 in process_aginodes (mp=3D0x7fffffffe090, pf_ar=
gs=3D0x0,<br>
&gt; agno=3D0, ino_discovery=3D1, check_dups=3D0, extra_attr_check=3D1) at<=
br>
&gt; dino_chunks.c:1014<br>
&gt; #11 0x000000000041978d in process_ag_func (wq=3D0x695f40, agno=3D0, ar=
g=3D0x0) at<br>
&gt; phase3.c:77<br>
&gt; #12 0x0000000000419bac in process_ags (mp=3D0x7fffffffe090) at phase3.=
c:116<br>
&gt; #13 phase3 (mp=3D0x7fffffffe090) at phase3.c:155<br>
&gt; #14 0x000000000042d200 in main (argc=3D&lt;value optimized out&gt;, ar=
gv=3D&lt;value<br>
&gt; optimized out&gt;) at xfs_repair.c:749<br>
<br>
</div></div>Looks like an out of range entry count. it&#39;s not checked fo=
r<br>
validity before it is used. I&#39;ll try to whip up a fix<br>
tomorrow.<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</div></div></blockquote></div><br></div>

--047d7b5d9c6bfd2d4804e7edf4e8--


--===============7486735256180452980==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7486735256180452980==--
