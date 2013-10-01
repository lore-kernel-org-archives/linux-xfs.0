Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3284129DFB
	for <xfs@oss.sgi.com>; Tue,  1 Oct 2013 16:12:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C3F43AC010
	for <xfs@oss.sgi.com>; Tue,  1 Oct 2013 14:12:18 -0700 (PDT)
Received: from mail-vb0-f44.google.com (mail-vb0-f44.google.com
	[209.85.212.44]) by cuda.sgi.com with ESMTP id UxEGv4uWofUgQnuU
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 01 Oct 2013 14:12:17 -0700 (PDT)
Received: by mail-vb0-f44.google.com with SMTP id e13so5385274vbg.3
	for <xfs@oss.sgi.com>; Tue, 01 Oct 2013 14:12:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131001201909.GR12541@dastard>
References: <CAGa4098ZKd2KQfWMgNXYgLr9LJF8r-MpFgQAn3G-W+ovDGHTAw@mail.gmail.com>
	<20131001201909.GR12541@dastard>
Date: Tue, 1 Oct 2013 14:12:16 -0700
Message-ID: <CAGa409_tDjbsdnf+wDiM7666FeQSjmMfOVdqG-SxOD_WUZMiZQ@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============4506879273873721696=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============4506879273873721696==
Content-Type: multipart/alternative; boundary=047d7b2ee40f4742a904e7b46844

--047d7b2ee40f4742a904e7b46844
Content-Type: text/plain; charset=ISO-8859-1

Hi again,
Here's the stack trace:

#0  __xfs_dir3_data_check (dp=<value optimized out>, bp=<value optimized
out>) at xfs_dir2_data.c:149
#1  0x0000000000451d32 in xfs_dir3_block_verify (bp=0x94369210) at
xfs_dir2_block.c:62
#2  0x0000000000451ed1 in xfs_dir3_block_read_verify (bp=0x94369210) at
xfs_dir2_block.c:73
#3  0x0000000000431e2a in libxfs_readbuf (btp=0x6aaca0, blkno=5292504,
len=8, flags=0, ops=0x478c60) at rdwr.c:718
#4  0x0000000000412295 in da_read_buf (mp=0x7fffffffe090, nex=1, bmp=<value
optimized out>, ops=<value optimized out>) at dir2.c:129
#5  0x0000000000415c26 in process_block_dir2 (mp=0x7fffffffe090,
ino=8639864, dip=0x95030000, ino_discovery=1, dino_dirty=<value optimized
out>, dirname=0x472201 "", parent=0x7fffffffdf28, blkmap=0x7ffff0342010) at
dir2.c:1594
#6  process_dir2 (mp=0x7fffffffe090, ino=8639864, dip=0x95030000,
ino_discovery=1, dino_dirty=<value optimized out>, dirname=0x472201 "",
parent=0x7fffffffdf28, blkmap=0x7ffff0342010) at dir2.c:1993
#7  0x0000000000411e6c in process_dinode_int (mp=0x7fffffffe090,
dino=0x95030000, agno=1, ino=0, was_free=0, dirty=0x7fffffffdf38,
used=0x7fffffffdf3c, verify_mode=0, uncertain=0, ino_discovery=1,
check_dups=0, extra_attr_check=1, isa_dir=0x7fffffffdf34,
    parent=0x7fffffffdf28) at dinode.c:2859
#8  0x000000000041213e in process_dinode (mp=<value optimized out>,
dino=<value optimized out>, agno=<value optimized out>, ino=<value
optimized out>, was_free=<value optimized out>, dirty=<value optimized
out>, used=0x7fffffffdf3c, ino_discovery=1, check_dups=0,
    extra_attr_check=1, isa_dir=0x7fffffffdf34, parent=0x7fffffffdf28) at
dinode.c:2967
#9  0x000000000040a870 in process_inode_chunk (mp=0x7fffffffe090, agno=0,
num_inos=<value optimized out>, first_irec=0x7fff5d63f320, ino_discovery=1,
check_dups=0, extra_attr_check=1, bogus=0x7fffffffdfcc) at dino_chunks.c:772
#10 0x000000000040ae97 in process_aginodes (mp=0x7fffffffe090, pf_args=0x0,
agno=0, ino_discovery=1, check_dups=0, extra_attr_check=1) at
dino_chunks.c:1014
#11 0x000000000041978d in process_ag_func (wq=0x695f40, agno=0, arg=0x0) at
phase3.c:77
#12 0x0000000000419bac in process_ags (mp=0x7fffffffe090) at phase3.c:116
#13 phase3 (mp=0x7fffffffe090) at phase3.c:155
#14 0x000000000042d200 in main (argc=<value optimized out>, argv=<value
optimized out>) at xfs_repair.c:749




On Tue, Oct 1, 2013 at 1:19 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Oct 01, 2013 at 12:57:42PM -0700, Viet Nguyen wrote:
> > Hi,
> >
> > I have a corrupted xfs partition that segfaults when I run xfs_repair, at
> > the same place every time.
> >
> > I'm using the latest version of xfs_repair that I am aware of: xfs_repair
> > version 3.2.0-alpha1
> >
> > I simply run it as so: xfs_repair -P /dev/sda1
> >
> > Here's a sample of the last few lines that are spit out:
> > correcting nextents for inode 8637985
> > correcting nblocks for inode 8637985, was 198 - counted 0
> > correcting nextents for inode 8637985, was 1 - counted 0
> > data fork in regular inode 8637987 claims used block 7847452695
> > correcting nextents for inode 8637987
> > correcting nblocks for inode 8637987, was 198 - counted 0
> > correcting nextents for inode 8637987, was 1 - counted 0
> > data fork in regular inode 8637999 claims used block 11068974204
> > correcting nextents for inode 8637999
> > correcting nblocks for inode 8637999, was 200 - counted 0
> > correcting nextents for inode 8637999, was 1 - counted 0
> > data fork in regular inode 8638002 claims used block 11873152787
> > correcting nextents for inode 8638002
> > correcting nblocks for inode 8638002, was 201 - counted 0
> > correcting nextents for inode 8638002, was 1 - counted 0
> > imap claims a free inode 8638005 is in use, correcting imap and clearing
> > inode
> > cleared inode 8638005
> > imap claims a free inode 8638011 is in use, correcting imap and clearing
> > inode
> > cleared inode 8638011
> > Segmentation fault (core dumped)
> >
> > It crashes after attempting to clear that same inode every time.
> >
> > Any advice you can give me on this?
>
> Can you run it under gdb and send the stack trace that tells us
> where it crashed?
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--047d7b2ee40f4742a904e7b46844
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi again,=A0</div><div>Here&#39;s the stack trace:</d=
iv><div><br></div><font face=3D"courier new, monospace">#0 =A0__xfs_dir3_da=
ta_check (dp=3D&lt;value optimized out&gt;, bp=3D&lt;value optimized out&gt=
;) at xfs_dir2_data.c:149<br>
#1 =A00x0000000000451d32 in xfs_dir3_block_verify (bp=3D0x94369210) at xfs_=
dir2_block.c:62<br>#2 =A00x0000000000451ed1 in xfs_dir3_block_read_verify (=
bp=3D0x94369210) at xfs_dir2_block.c:73<br>#3 =A00x0000000000431e2a in libx=
fs_readbuf (btp=3D0x6aaca0, blkno=3D5292504, len=3D8, flags=3D0, ops=3D0x47=
8c60) at rdwr.c:718<br>
#4 =A00x0000000000412295 in da_read_buf (mp=3D0x7fffffffe090, nex=3D1, bmp=
=3D&lt;value optimized out&gt;, ops=3D&lt;value optimized out&gt;) at dir2.=
c:129<br>#5 =A00x0000000000415c26 in process_block_dir2 (mp=3D0x7fffffffe09=
0, ino=3D8639864, dip=3D0x95030000, ino_discovery=3D1, dino_dirty=3D&lt;val=
ue optimized out&gt;, dirname=3D0x472201 &quot;&quot;, parent=3D0x7fffffffd=
f28, blkmap=3D0x7ffff0342010) at dir2.c:1594<br>
#6 =A0process_dir2 (mp=3D0x7fffffffe090, ino=3D8639864, dip=3D0x95030000, i=
no_discovery=3D1, dino_dirty=3D&lt;value optimized out&gt;, dirname=3D0x472=
201 &quot;&quot;, parent=3D0x7fffffffdf28, blkmap=3D0x7ffff0342010) at dir2=
.c:1993<br>#7 =A00x0000000000411e6c in process_dinode_int (mp=3D0x7fffffffe=
090, dino=3D0x95030000, agno=3D1, ino=3D0, was_free=3D0, dirty=3D0x7fffffff=
df38, used=3D0x7fffffffdf3c, verify_mode=3D0, uncertain=3D0, ino_discovery=
=3D1, check_dups=3D0, extra_attr_check=3D1, isa_dir=3D0x7fffffffdf34,<br>
=A0 =A0 parent=3D0x7fffffffdf28) at dinode.c:2859<br>#8 =A00x00000000004121=
3e in process_dinode (mp=3D&lt;value optimized out&gt;, dino=3D&lt;value op=
timized out&gt;, agno=3D&lt;value optimized out&gt;, ino=3D&lt;value optimi=
zed out&gt;, was_free=3D&lt;value optimized out&gt;, dirty=3D&lt;value opti=
mized out&gt;, used=3D0x7fffffffdf3c, ino_discovery=3D1, check_dups=3D0,<br=
>
=A0 =A0 extra_attr_check=3D1, isa_dir=3D0x7fffffffdf34, parent=3D0x7fffffff=
df28) at dinode.c:2967<br>#9 =A00x000000000040a870 in process_inode_chunk (=
mp=3D0x7fffffffe090, agno=3D0, num_inos=3D&lt;value optimized out&gt;, firs=
t_irec=3D0x7fff5d63f320, ino_discovery=3D1, check_dups=3D0, extra_attr_chec=
k=3D1, bogus=3D0x7fffffffdfcc) at dino_chunks.c:772<br>
#10 0x000000000040ae97 in process_aginodes (mp=3D0x7fffffffe090, pf_args=3D=
0x0, agno=3D0, ino_discovery=3D1, check_dups=3D0, extra_attr_check=3D1) at =
dino_chunks.c:1014<br>#11 0x000000000041978d in process_ag_func (wq=3D0x695=
f40, agno=3D0, arg=3D0x0) at phase3.c:77<br>
#12 0x0000000000419bac in process_ags (mp=3D0x7fffffffe090) at phase3.c:116=
<br>#13 phase3 (mp=3D0x7fffffffe090) at phase3.c:155<br>#14 0x000000000042d=
200 in main (argc=3D&lt;value optimized out&gt;, argv=3D&lt;value optimized=
 out&gt;) at xfs_repair.c:749</font><div>
<br></div><div><br></div><div class=3D"gmail_extra"><br><br><div class=3D"g=
mail_quote">On Tue, Oct 1, 2013 at 1:19 PM, Dave Chinner <span dir=3D"ltr">=
&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbi=
t.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;p=
adding-left:1ex"><div class=3D""><div class=3D"h5">On Tue, Oct 01, 2013 at =
12:57:42PM -0700, Viet Nguyen wrote:<br>

&gt; Hi,<br>
&gt;<br>
&gt; I have a corrupted xfs partition that segfaults when I run xfs_repair,=
 at<br>
&gt; the same place every time.<br>
&gt;<br>
&gt; I&#39;m using the latest version of xfs_repair that I am aware of: xfs=
_repair<br>
&gt; version 3.2.0-alpha1<br>
&gt;<br>
&gt; I simply run it as so: xfs_repair -P /dev/sda1<br>
&gt;<br>
&gt; Here&#39;s a sample of the last few lines that are spit out:<br>
&gt; correcting nextents for inode 8637985<br>
&gt; correcting nblocks for inode 8637985, was 198 - counted 0<br>
&gt; correcting nextents for inode 8637985, was 1 - counted 0<br>
&gt; data fork in regular inode 8637987 claims used block 7847452695<br>
&gt; correcting nextents for inode 8637987<br>
&gt; correcting nblocks for inode 8637987, was 198 - counted 0<br>
&gt; correcting nextents for inode 8637987, was 1 - counted 0<br>
&gt; data fork in regular inode 8637999 claims used block 11068974204<br>
&gt; correcting nextents for inode 8637999<br>
&gt; correcting nblocks for inode 8637999, was 200 - counted 0<br>
&gt; correcting nextents for inode 8637999, was 1 - counted 0<br>
&gt; data fork in regular inode 8638002 claims used block 11873152787<br>
&gt; correcting nextents for inode 8638002<br>
&gt; correcting nblocks for inode 8638002, was 201 - counted 0<br>
&gt; correcting nextents for inode 8638002, was 1 - counted 0<br>
&gt; imap claims a free inode 8638005 is in use, correcting imap and cleari=
ng<br>
&gt; inode<br>
&gt; cleared inode 8638005<br>
&gt; imap claims a free inode 8638011 is in use, correcting imap and cleari=
ng<br>
&gt; inode<br>
&gt; cleared inode 8638011<br>
&gt; Segmentation fault (core dumped)<br>
&gt;<br>
&gt; It crashes after attempting to clear that same inode every time.<br>
&gt;<br>
&gt; Any advice you can give me on this?<br>
<br>
</div></div>Can you run it under gdb and send the stack trace that tells us=
<br>
where it crashed?<br>
<br>
Cheers,<br>
<br>
Dave.<br>
<span class=3D""><font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</font></span></blockquote></div><br></div></div>

--047d7b2ee40f4742a904e7b46844--


--===============4506879273873721696==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4506879273873721696==--
