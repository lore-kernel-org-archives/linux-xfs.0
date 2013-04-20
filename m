Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8A76029DFA
	for <xfs@oss.sgi.com>; Sat, 20 Apr 2013 06:52:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5169E8F8039
	for <xfs@oss.sgi.com>; Sat, 20 Apr 2013 04:52:21 -0700 (PDT)
Received: from mail-ie0-f177.google.com (mail-ie0-f177.google.com
	[209.85.223.177]) by cuda.sgi.com with ESMTP id
	wmpDK8xJIj63MHEN (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 20 Apr 2013 04:52:19 -0700 (PDT)
Received: by mail-ie0-f177.google.com with SMTP id 9so5436891iec.8
	for <xfs@oss.sgi.com>; Sat, 20 Apr 2013 04:52:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51727E32.8080306@redhat.com>
References: <516C89DF.4070904@redhat.com>
	<CADFMGuLjsNBeWE8wTDBgophhpixm3p+wY=9QWwk5u483zL0C4g@mail.gmail.com>
	<CADFMGuKuL8=B_NY=pKq5gj3aOK0kW0xuPWA=rSCDyziUgWGX6w@mail.gmail.com>
	<51716DCB.4060407@sandeen.net>
	<CADFMGuJH106wg7zVQrt604DxvDWB_bnor==NEGpJ1Xcr9b+C8A@mail.gmail.com>
	<CADFMGuLcve0a5uiOzZYoVze8tm1UXTPxhEqForMWYsvCyuh0sg@mail.gmail.com>
	<5171790C.70400@sandeen.net>
	<CADFMGuKfyw-mCsRn1Y5H5ek+z_nRMHDmW4bG-Ez9ANJm7_ec5A@mail.gmail.com>
	<CADFMGuL4+vSH9ZpWODXWbHVz9ndMcg2aZY9b0ccq74SJp3XzEw@mail.gmail.com>
	<CADFMGuK7FEbWibRrctK7B=XXAfAKtpjRej3NVB2k7JXhhYFLLg@mail.gmail.com>
	<CADFMGuJozkBQdp5o_BK7HbrPdv6iKUie=jHyz5LrtBBvHY1b4w@mail.gmail.com>
	<CADFMGuL05J+b=bv5jAneLT451eQFNNz2RNHQHccBOjqWsE68Kw@mail.gmail.com>
	<51720E49.9020001@sandeen.net>
	<CADFMGu+9SGHJEPtUzuR3eObNwfs6VE0TmJNhJh_vxQ3+KBwocA@mail.gmail.com>
	<51721798.1060501@sandeen.net>
	<CADFMGuJAXcA0CTYEoaRNvsTv7DhHeOBgk+j_HiMceT1neoEzRQ@mail.gmail.com>
	<CADFMGuLBat2fWbtpRd=Sb0bQpZiTOdF2p8NA97rak8A=+GhN1A@mail.gmail.com>
	<51727E32.8080306@redhat.com>
Date: Sat, 20 Apr 2013 19:52:18 +0800
Message-ID: <CADFMGuKE=1RCAfXW9iLMRW9MdjMk936F4jZw12adHpQ+wkNyWw@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============8238892557490710188=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============8238892557490710188==
Content-Type: multipart/alternative; boundary=14dae9340ee7bc327c04dac97797

--14dae9340ee7bc327c04dac97797
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

Hi Brain,
Here is the file:
find . -inum 539274
./crashtest/.glusterfs/indices/xattrop
[root@10.23.72.94 xfsd]# ls -lih ./crashtest/.glusterfs/indices/xattrop
total 0
539275 ---------- 2 root root 0 Apr 20 17:17
132ef294-71d1-4435-8daa-aa002e67cb6e
539275 ---------- 2 root root 0 Apr 20 17:17
xattrop-f3ad589a-b8dc-4416-ab84-fc9ad4033540
find . -inum 539275
./crashtest/.glusterfs/indices/xattrop/xattrop-f3ad589a-b8dc-4416-ab84-fc9a=
d4033540
./crashtest/.glusterfs/indices/xattrop/132ef294-71d1-4435-8daa-aa002e67cb6e
I'm not sure if it is normal or glusterfs fall in infinite loop. Is there a
change that the kernel fall into dead loop?
I'll study it.


2013/4/20 Brian Foster <bfoster@redhat.com>

> On 04/20/2013 06:10 AM, =B7=FB=D3=C0=CC=CE wrote:
> > Dear Eric,
> > I have applied your latest patch and collected the following log:
> >
> > /var/log/message
> > Apr 20 17:28:23 10 kernel: XFS (sdb): xfs_iunlink_remove: xfs_inotobp()
> > returned error 22 for inode 0x1b20b ag 0 agino 1b20b
> > Apr 20 17:28:23 10 kernel:
> > Apr 20 17:28:23 10 kernel: XFS (sdb): xfs_inactive: xfs_ifree returned
> > error 22
> > Apr 20 17:28:23 10 kernel: XFS (sdb): xfs_do_force_shutdown(0x1) called
> > from line 1184 of file fs/xfs/xfs_vnodeops.c.  Return address =3D
> > 0xffffffffa02d4d0a
> > Apr 20 17:28:23 10 kernel: XFS (sdb): I/O Error Detected. Shutting down
> > filesystem
> > Apr 20 17:28:23 10 kernel: XFS (sdb): Please umount the filesystem and
> > rectify the problem(s)
> > Apr 20 17:28:37 10 kernel: XFS (sdb): xfs_log_force: error 5 returned.
> > Apr 20 17:29:07 10 kernel: XFS (sdb): xfs_log_force: error 5 returned.
> > Apr 20 17:29:37 10 kernel: XFS (sdb): xfs_log_force: error 5 returned.
> > Apr 20 17:30:07 10 kernel: XFS (sdb): xfs_log_force: error 5 returned.
> >
> > debugfs trace:
> >
> https://docs.google.com/file/d/0B7n2C4T5tfNCTlZGUVpnZENrZ3M/edit?usp=3Dsh=
aring
> >
>
> FWIW...
>
> <...>-6908  [001]  8739.967623: xfs_iunlink: dev 8:16 ino 0x83a8b mode
> 0100000, flags 0x0
> <...>-6909  [001]  8739.970252: xfs_iunlink: dev 8:16 ino 0x83a8b mode
> 0100000, flags 0x0
>
> 0x83a8b and 0x1b20b both hash to unlinked list bucket 11.
>
> As to the rest of the trace, there appears to be a significant amount of
> link activity on (directory) inode 0x83a8a (the immediately prior inode
> to the inode involved in the race). The name data in the trace suggests
> activity somewhere under .glusterfs. A couple questions:
>
> 1.) Any idea what entries point to this inode right now (e.g., how many
> links on this inode) and where it resides in the fs (path)?
>
> 2.) Can you associate this kind of heavy remove/link pattern on a single
> inode to a higher level activity? For example, if you were to watch the
> trace data live, is this a normal pattern you observe? Does it only
> occur when a rebalance is in progress? Or when a rebalance finishes? Any
> detailed observations you can make in that regard could be helpful.
>
> Brian
>
> > Thank you.
> >
> >
> > 2013/4/20 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com <mailto:yongtaofu@gma=
il.com>>
> >
> >     Hi Eric,
> >     The xfs module is loaded from system kernel, it happens on our
> >     production server too (I did not touch that till now) and if the xf=
s
> >     module is mess up the systemstap may also not working but now it
> >     works. As you have mentioned, strange thing is xfs shutdown always
> >     happens when glusterfs rebalance completes.
> >
> >
> >     2013/4/20 Eric Sandeen <sandeen@sandeen.net
> >     <mailto:sandeen@sandeen.net>>
> >
> >         On 4/19/13 9:03 PM, =B7=FB=D3=C0=CC=CE wrote:
> >         > Hi Eric,
> >         > I will enable them and run test again. I can only reproduce i=
t
> >         with
> >         > glusterfs rebalance. Glusterfs uses a mechanism it called
> >         syncop to
> >         > unlink file. For rebalance it uses
> >         > syncop_unlink(glusterfs/libglusterfs/src/syncop.c). In the
> >         glusterfs
> >         > sync_task framework(glusterfs/libglusterfs/src/syncop.c) it
> uses
> >         > "makecontext/swapcontext"
> >         >
> >         <
> http://www.opengroup.org/onlinepubs/009695399/functions/makecontext.html>=
.
> >         > Does it leads to racing unlink from different CPU core?
> >
> >         Yep, I understand that it's rebalance.  It dies when rebalance
> >         finishes because an
> >         open but unlinked file trips over the corrupted list from
> >         earlier, it seems.
> >
> >         I don't know why makecontext would matter...
> >
> >         Just to be sure, you are definitely loading the xfs module from
> >         the kernel you built, right, and you don't have a "priority"
> >         module getting loaded from elsewhere?  Seems unlikely, but just
> >         to be sure.
> >
> >         > Thank you.
> >
> >         You could also add this patch to the xfs tracepoints to print
> >         more information about the inodes - the mode & flags.
> >
> >         -Eric
> >
> >
> >         diff --git a/fs/xfs/linux-2.6/xfs_trace.h
> >         b/fs/xfs/linux-2.6/xfs_trace.h
> >         index e8ce644..c314b87 100644
> >         --- a/fs/xfs/linux-2.6/xfs_trace.h
> >         +++ b/fs/xfs/linux-2.6/xfs_trace.h
> >         @@ -544,14 +544,18 @@ DECLARE_EVENT_CLASS(xfs_inode_class,
> >                 TP_STRUCT__entry(
> >                         __field(dev_t, dev)
> >                         __field(xfs_ino_t, ino)
> >         +               __field(__u16, mode)
> >         +               __field(unsigned long, flags)
> >                 ),
> >                 TP_fast_assign(
> >                         __entry->dev =3D VFS_I(ip)->i_sb->s_dev;
> >                         __entry->ino =3D ip->i_ino;
> >         +               __entry->mode =3D VFS_I(ip)->i_mode;
> >         +               __entry->flags =3D ip->i_flags;
> >                 ),
> >         -       TP_printk("dev %d:%d ino 0x%llx",
> >         +       TP_printk("dev %d:%d ino 0x%llx mode 0%o, flags 0x%lx",
> >                           MAJOR(__entry->dev), MINOR(__entry->dev),
> >         -                 __entry->ino)
> >         +                 __entry->ino, __entry->mode, __entry->flags)
> >          )
> >
> >          #define DEFINE_INODE_EVENT(name) \
> >
> >
> >
> >
> >
> >
> >     --
> >     =B7=FB=D3=C0=CC=CE
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

--14dae9340ee7bc327c04dac97797
Content-Type: text/html; charset=GB2312
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div>Hi Brain,<br></div>Here is the file:<br>fin=
d . -inum 539274<br>./crashtest/.glusterfs/indices/xattrop<br>[<a href=3D"m=
ailto:root@10.23.72.94">root@10.23.72.94</a> xfsd]# ls -lih ./crashtest/.gl=
usterfs/indices/xattrop<br>
total 0<br>539275 ---------- 2 root root 0 Apr 20 17:17 132ef294-71d1-4435-=
8daa-aa002e67cb6e<br>539275 ---------- 2 root root 0 Apr 20 17:17 xattrop-f=
3ad589a-b8dc-4416-ab84-fc9ad4033540<br>find . -inum 539275<br>./crashtest/.=
glusterfs/indices/xattrop/xattrop-f3ad589a-b8dc-4416-ab84-fc9ad4033540<br>
./crashtest/.glusterfs/indices/xattrop/132ef294-71d1-4435-8daa-aa002e67cb6e=
<br></div>I&#39;m not sure if it is normal or glusterfs fall in infinite lo=
op. Is there a change that the kernel fall into dead loop?<br></div><div>
I&#39;ll study it.<br></div></div><div class=3D"gmail_extra"><br><br><div c=
lass=3D"gmail_quote">2013/4/20 Brian Foster <span dir=3D"ltr">&lt;<a href=
=3D"mailto:bfoster@redhat.com" target=3D"_blank">bfoster@redhat.com</a>&gt;=
</span><br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"im">On 04/20/2013 06:10 AM, =
=B7=FB=D3=C0=CC=CE wrote:<br>
&gt; Dear Eric,<br>
&gt; I have applied your latest patch and collected the following log:<br>
&gt;<br>
&gt; /var/log/message<br>
&gt; Apr 20 17:28:23 10 kernel: XFS (sdb): xfs_iunlink_remove: xfs_inotobp(=
)<br>
&gt; returned error 22 for inode 0x1b20b ag 0 agino 1b20b<br>
&gt; Apr 20 17:28:23 10 kernel:<br>
&gt; Apr 20 17:28:23 10 kernel: XFS (sdb): xfs_inactive: xfs_ifree returned=
<br>
&gt; error 22<br>
&gt; Apr 20 17:28:23 10 kernel: XFS (sdb): xfs_do_force_shutdown(0x1) calle=
d<br>
&gt; from line 1184 of file fs/xfs/xfs_vnodeops.c. &nbsp;Return address =3D=
<br>
&gt; 0xffffffffa02d4d0a<br>
&gt; Apr 20 17:28:23 10 kernel: XFS (sdb): I/O Error Detected. Shutting dow=
n<br>
&gt; filesystem<br>
&gt; Apr 20 17:28:23 10 kernel: XFS (sdb): Please umount the filesystem and=
<br>
&gt; rectify the problem(s)<br>
&gt; Apr 20 17:28:37 10 kernel: XFS (sdb): xfs_log_force: error 5 returned.=
<br>
&gt; Apr 20 17:29:07 10 kernel: XFS (sdb): xfs_log_force: error 5 returned.=
<br>
&gt; Apr 20 17:29:37 10 kernel: XFS (sdb): xfs_log_force: error 5 returned.=
<br>
&gt; Apr 20 17:30:07 10 kernel: XFS (sdb): xfs_log_force: error 5 returned.=
<br>
&gt;<br>
&gt; debugfs trace:<br>
&gt; <a href=3D"https://docs.google.com/file/d/0B7n2C4T5tfNCTlZGUVpnZENrZ3M=
/edit?usp=3Dsharing" target=3D"_blank">https://docs.google.com/file/d/0B7n2=
C4T5tfNCTlZGUVpnZENrZ3M/edit?usp=3Dsharing</a><br>
&gt;<br>
<br>
</div>FWIW...<br>
<br>
&lt;...&gt;-6908 &nbsp;[001] &nbsp;8739.967623: xfs_iunlink: dev 8:16 ino 0=
x83a8b mode<br>
0100000, flags 0x0<br>
&lt;...&gt;-6909 &nbsp;[001] &nbsp;8739.970252: xfs_iunlink: dev 8:16 ino 0=
x83a8b mode<br>
0100000, flags 0x0<br>
<br>
0x83a8b and 0x1b20b both hash to unlinked list bucket 11.<br>
<br>
As to the rest of the trace, there appears to be a significant amount of<br=
>
link activity on (directory) inode 0x83a8a (the immediately prior inode<br>
to the inode involved in the race). The name data in the trace suggests<br>
activity somewhere under .glusterfs. A couple questions:<br>
<br>
1.) Any idea what entries point to this inode right now (e.g., how many<br>
links on this inode) and where it resides in the fs (path)?<br>
<br>
2.) Can you associate this kind of heavy remove/link pattern on a single<br=
>
inode to a higher level activity? For example, if you were to watch the<br>
trace data live, is this a normal pattern you observe? Does it only<br>
occur when a rebalance is in progress? Or when a rebalance finishes? Any<br=
>
detailed observations you can make in that regard could be helpful.<br>
<br>
Brian<br>
<br>
&gt; Thank you.<br>
&gt;<br>
&gt;<br>
&gt; 2013/4/20 =B7=FB=D3=C0=CC=CE &lt;<a href=3D"mailto:yongtaofu@gmail.com=
">yongtaofu@gmail.com</a> &lt;mailto:<a href=3D"mailto:yongtaofu@gmail.com"=
>yongtaofu@gmail.com</a>&gt;&gt;<br>
<div class=3D"im">&gt;<br>
&gt; &nbsp; &nbsp; Hi Eric,<br>
&gt; &nbsp; &nbsp; The xfs module is loaded from system kernel, it happens =
on our<br>
&gt; &nbsp; &nbsp; production server too (I did not touch that till now) an=
d if the xfs<br>
&gt; &nbsp; &nbsp; module is mess up the systemstap may also not working bu=
t now it<br>
&gt; &nbsp; &nbsp; works. As you have mentioned, strange thing is xfs shutd=
own always<br>
&gt; &nbsp; &nbsp; happens when glusterfs rebalance completes.<br>
&gt;<br>
&gt;<br>
&gt; &nbsp; &nbsp; 2013/4/20 Eric Sandeen &lt;<a href=3D"mailto:sandeen@san=
deen.net">sandeen@sandeen.net</a><br>
</div>&gt; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:sandeen@sandeen.net">=
sandeen@sandeen.net</a>&gt;&gt;<br>
<div class=3D"HOEnZb"><div class=3D"h5">&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; On 4/19/13 9:03 PM, =B7=FB=D3=C0=CC=CE wro=
te:<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; Hi Eric,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; I will enable them and run test again=
. I can only reproduce it<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; with<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; glusterfs rebalance. Glusterfs uses a=
 mechanism it called<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; syncop to<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; unlink file. For rebalance it uses<br=
>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; syncop_unlink(glusterfs/libglusterfs/=
src/syncop.c). In the<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; glusterfs<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; sync_task framework(glusterfs/libglus=
terfs/src/syncop.c) it uses<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &quot;makecontext/swapcontext&quot;<b=
r>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &lt;<a href=3D"http://www.opengroup.org/on=
linepubs/009695399/functions/makecontext.html" target=3D"_blank">http://www=
.opengroup.org/onlinepubs/009695399/functions/makecontext.html</a>&gt;.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; Does it leads to racing unlink from d=
ifferent CPU core?<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Yep, I understand that it&#39;s rebalance.=
 &nbsp;It dies when rebalance<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; finishes because an<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; open but unlinked file trips over the corr=
upted list from<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; earlier, it seems.<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; I don&#39;t know why makecontext would mat=
ter...<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Just to be sure, you are definitely loadin=
g the xfs module from<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; the kernel you built, right, and you don&#=
39;t have a &quot;priority&quot;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; module getting loaded from elsewhere? &nbs=
p;Seems unlikely, but just<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; to be sure.<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; Thank you.<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; You could also add this patch to the xfs t=
racepoints to print<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; more information about the inodes - the mo=
de &amp; flags.<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; -Eric<br>
&gt;<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; diff --git a/fs/xfs/linux-2.6/xfs_trace.h<=
br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; b/fs/xfs/linux-2.6/xfs_trace.h<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; index e8ce644..c314b87 100644<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; --- a/fs/xfs/linux-2.6/xfs_trace.h<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +++ b/fs/xfs/linux-2.6/xfs_trace.h<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; @@ -544,14 +544,18 @@ DECLARE_EVENT_CLASS(=
xfs_inode_class,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; TP_STRUCT__ent=
ry(<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; __field(dev_t, dev)<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; __field(xfs_ino_t, ino)<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; __field(__u16, mode)<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; __field(unsigned long, flags)<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ),<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; TP_fast_assign=
(<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; __entry-&gt;dev =3D VFS_I(ip)-&gt;i_sb-&gt;s_dev;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; __entry-&gt;ino =3D ip-&gt;i_ino;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; __entry-&gt;mode =3D VFS_I(ip)-&gt;i_mode;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; __entry-&gt;flags =3D ip-&gt;i_flags;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ),<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; - &nbsp; &nbsp; &nbsp; TP_printk(&quot;dev=
 %d:%d ino 0x%llx&quot;,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; TP_printk(&quot;dev=
 %d:%d ino 0x%llx mode 0%o, flags 0x%lx&quot;,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; MAJOR(__entry-&gt;dev), MINOR(__entry-&gt;dev),<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; - &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; __entry-&gt;ino)<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; __entry-&gt;ino, __entry-&gt;mode, __entry-&gt;flags)<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;)<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;#define DEFINE_INODE_EVENT(name) \<b=
r>
&gt;<br>
&gt;<br>
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
</div></div></blockquote></div><br><br clear=3D"all"><br>-- <br>=B7=FB=D3=
=C0=CC=CE
</div>

--14dae9340ee7bc327c04dac97797--


--===============8238892557490710188==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8238892557490710188==--
