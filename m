Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1837A29DFA
	for <xfs@oss.sgi.com>; Sat, 20 Apr 2013 18:52:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E8CF68F8035
	for <xfs@oss.sgi.com>; Sat, 20 Apr 2013 16:52:19 -0700 (PDT)
Received: from mail-ie0-f172.google.com (mail-ie0-f172.google.com
	[209.85.223.172]) by cuda.sgi.com with ESMTP id
	PXmwOOhmZ35mqsDK (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 20 Apr 2013 16:52:18 -0700 (PDT)
Received: by mail-ie0-f172.google.com with SMTP id c12so1976762ieb.31
	for <xfs@oss.sgi.com>; Sat, 20 Apr 2013 16:52:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5172B73C.6000900@sandeen.net>
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
	<5172B73C.6000900@sandeen.net>
Date: Sun, 21 Apr 2013 07:52:17 +0800
Message-ID: <CADFMGuKSoQkr-uXJg0BnRoi079+HoncAoGjZn_Z06pkuSxnzBQ@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============0019255568648101952=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Brian Foster <bfoster@redhat.com>, Dave Chinner <david@fromorbit.com>

--===============0019255568648101952==
Content-Type: multipart/alternative; boundary=047d7b10d1b79cdc5f04dad38617

--047d7b10d1b79cdc5f04dad38617
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

Dear Brian and Eric and xfs experts,
Thank you very much for helping to address the issue. With your help I am
now able to isolate this problem, I point the glusterfs volume indices
directory out of xfs filesystem(to a ext4 path) and the shutdown not
happens again. Since this directory is not where glusterfs store data it is
just index directory containing some kind of flag files it's ok to set it
to somewhere else. I'll run more test with this configuration.

Seems glusterfs aggressively call link/remove on the directory and files
under it leads to racing. When I move this directory to a ext4 path, after
rebalance the directory status is as following:

/data/testbug/.glusterfs:
total 12K
drwxr-xr-x 3 root root 4.0K Apr 20 22:00 .
drwxr-xr-x 3 root root 4.0K Apr 20 22:00 ..
drwxr-xr-x 3 root root 4.0K Apr 20 23:05 indices

/data/testbug/.glusterfs/indices:
total 12K
drwxr-xr-x 3 root root 4.0K Apr 20 23:05 .
drwxr-xr-x 3 root root 4.0K Apr 20 22:00 ..
drw------- 2 root root 4.0K Apr 20 23:44 xattrop

/data/testbug/.glusterfs/indices/xattrop:
total 8.0K
drw-------  2 root root 4.0K Apr 20 23:44 .
drwxr-xr-x  3 root root 4.0K Apr 20 23:05 ..
---------- 21 root root    0 Apr 20 23:05
2ea59fab-da86-4ccd-a6d3-20ca80d30e8c
---------- 21 root root    0 Apr 20 23:05
33e96373-7fe1-4c09-969e-f01c45ac445e
---------- 21 root root    0 Apr 20 23:05
35341482-c561-4fdd-b505-61c4e189f63c
---------- 21 root root    0 Apr 20 23:05
390e8676-b18a-4769-9e26-ebc47385d022
---------- 21 root root    0 Apr 20 23:05
4f153df5-0101-4375-bb3d-1c94a2ca5c69
---------- 21 root root    0 Apr 20 23:05
58867dfa-d4b1-47fb-9a54-f3cda0411297
---------- 21 root root    0 Apr 20 23:05
7608e535-6de4-40ba-bb63-aba986d77c6a
---------- 21 root root    0 Apr 20 23:05
7f71f1a0-4463-4fdd-b3b8-0ca73b282520
---------- 21 root root    0 Apr 20 23:05
82cfa2b8-0604-4f7c-bf18-5db47a4cc727
---------- 21 root root    0 Apr 20 23:05
8ea1dc4b-801a-49fb-bff2-7579826f5942
---------- 21 root root    0 Apr 20 23:05
9cc746a7-5b47-4b6a-990f-99f378b787bf
---------- 21 root root    0 Apr 20 23:05
aa1cbfb7-5661-4faf-a3e5-7607a2a2b884
---------- 21 root root    0 Apr 20 23:05
b23c5c1d-1076-43eb-a527-01970d5565ab
---------- 21 root root    0 Apr 20 23:05
b336fb93-82a5-45e8-bacc-66a270a12f3f
---------- 21 root root    0 Apr 20 23:05
bc0ada39-a479-4f29-949c-b8b110291699
---------- 21 root root    0 Apr 20 23:05
c7bd2930-3605-47bc-afc7-67254c8309b0
---------- 21 root root    0 Apr 20 23:05
ce517ec5-079a-41d6-b3f6-6b06cc88ace5
---------- 21 root root    0 Apr 20 23:05
d6d949e2-df27-4428-b4bf-5e589c224fec
---------- 21 root root    0 Apr 20 23:05
fc96f94f-4da0-4003-beca-91738e902c03
---------- 21 root root    0 Apr 20 23:05
fe7a2f27-a98a-4958-9024-85bf8671e612
---------- 21 root root    0 Apr 20 23:05
xattrop-bcb327ae-e265-4cd3-b6d4-9babff815ee7




2013/4/20 Eric Sandeen <sandeen@sandeen.net>

> On 4/20/13 3:10 AM, =B7=FB=D3=C0=CC=CE wrote:
> > Dear Eric,
> > I have applied your latest patch and collected the following log:
> >
>
> If you like, I think you could drop the below patch again; it didn't yiel=
d
> anything interesting and just makes for bigger trace logs.
>
> Every mode was 0100000 (S_ISREG / regular file) and flags were always 0.
>
> >         You could also add this patch to the xfs tracepoints to print
> more information about the inodes - the mode & flags.
> >
> >         -Eric
> >
> >
> >         diff --git a/fs/xfs/linux-2.6/xfs_trace.h
> b/fs/xfs/linux-2.6/xfs_trace.h
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

--047d7b10d1b79cdc5f04dad38617
Content-Type: text/html; charset=GB2312
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div>Dear Brian and Eric and xfs experts,<br></div>Th=
ank you very much for helping to address the issue. With your help I am now=
 able to isolate this problem, I point the glusterfs volume indices directo=
ry out of xfs filesystem(to a ext4 path) and the shutdown not happens again=
. Since this directory is not where glusterfs store data it is just index d=
irectory containing some kind of flag files it&#39;s ok to set it to somewh=
ere else. I&#39;ll run more test with this configuration.<br>
<br></div>Seems glusterfs aggressively call link/remove on the directory an=
d files under it leads to racing. When I move this directory to a ext4 path=
, after rebalance the directory status is as following:<br><br>/data/testbu=
g/.glusterfs:<br>
total 12K<br>drwxr-xr-x 3 root root 4.0K Apr 20 22:00 .<br>drwxr-xr-x 3 roo=
t root 4.0K Apr 20 22:00 ..<br>drwxr-xr-x 3 root root 4.0K Apr 20 23:05 ind=
ices<br><br>/data/testbug/.glusterfs/indices:<br>total 12K<br>drwxr-xr-x 3 =
root root 4.0K Apr 20 23:05 .<br>
drwxr-xr-x 3 root root 4.0K Apr 20 22:00 ..<br>drw------- 2 root root 4.0K =
Apr 20 23:44 xattrop<br><br>/data/testbug/.glusterfs/indices/xattrop:<br>to=
tal 8.0K<br>drw-------&nbsp; 2 root root 4.0K Apr 20 23:44 .<br>drwxr-xr-x&=
nbsp; 3 root root 4.0K Apr 20 23:05 ..<br>
---------- 21 root root&nbsp;&nbsp;&nbsp; 0 Apr 20 23:05 2ea59fab-da86-4ccd=
-a6d3-20ca80d30e8c<br>---------- 21 root root&nbsp;&nbsp;&nbsp; 0 Apr 20 23=
:05 33e96373-7fe1-4c09-969e-f01c45ac445e<br>---------- 21 root root&nbsp;&n=
bsp;&nbsp; 0 Apr 20 23:05 35341482-c561-4fdd-b505-61c4e189f63c<br>
---------- 21 root root&nbsp;&nbsp;&nbsp; 0 Apr 20 23:05 390e8676-b18a-4769=
-9e26-ebc47385d022<br>---------- 21 root root&nbsp;&nbsp;&nbsp; 0 Apr 20 23=
:05 4f153df5-0101-4375-bb3d-1c94a2ca5c69<br>---------- 21 root root&nbsp;&n=
bsp;&nbsp; 0 Apr 20 23:05 58867dfa-d4b1-47fb-9a54-f3cda0411297<br>
---------- 21 root root&nbsp;&nbsp;&nbsp; 0 Apr 20 23:05 7608e535-6de4-40ba=
-bb63-aba986d77c6a<br>---------- 21 root root&nbsp;&nbsp;&nbsp; 0 Apr 20 23=
:05 7f71f1a0-4463-4fdd-b3b8-0ca73b282520<br>---------- 21 root root&nbsp;&n=
bsp;&nbsp; 0 Apr 20 23:05 82cfa2b8-0604-4f7c-bf18-5db47a4cc727<br>
---------- 21 root root&nbsp;&nbsp;&nbsp; 0 Apr 20 23:05 8ea1dc4b-801a-49fb=
-bff2-7579826f5942<br>---------- 21 root root&nbsp;&nbsp;&nbsp; 0 Apr 20 23=
:05 9cc746a7-5b47-4b6a-990f-99f378b787bf<br>---------- 21 root root&nbsp;&n=
bsp;&nbsp; 0 Apr 20 23:05 aa1cbfb7-5661-4faf-a3e5-7607a2a2b884<br>
---------- 21 root root&nbsp;&nbsp;&nbsp; 0 Apr 20 23:05 b23c5c1d-1076-43eb=
-a527-01970d5565ab<br>---------- 21 root root&nbsp;&nbsp;&nbsp; 0 Apr 20 23=
:05 b336fb93-82a5-45e8-bacc-66a270a12f3f<br>---------- 21 root root&nbsp;&n=
bsp;&nbsp; 0 Apr 20 23:05 bc0ada39-a479-4f29-949c-b8b110291699<br>
---------- 21 root root&nbsp;&nbsp;&nbsp; 0 Apr 20 23:05 c7bd2930-3605-47bc=
-afc7-67254c8309b0<br>---------- 21 root root&nbsp;&nbsp;&nbsp; 0 Apr 20 23=
:05 ce517ec5-079a-41d6-b3f6-6b06cc88ace5<br>---------- 21 root root&nbsp;&n=
bsp;&nbsp; 0 Apr 20 23:05 d6d949e2-df27-4428-b4bf-5e589c224fec<br>
---------- 21 root root&nbsp;&nbsp;&nbsp; 0 Apr 20 23:05 fc96f94f-4da0-4003=
-beca-91738e902c03<br>---------- 21 root root&nbsp;&nbsp;&nbsp; 0 Apr 20 23=
:05 fe7a2f27-a98a-4958-9024-85bf8671e612<br>---------- 21 root root&nbsp;&n=
bsp;&nbsp; 0 Apr 20 23:05 xattrop-bcb327ae-e265-4cd3-b6d4-9babff815ee7<br>
<div><div><br><br></div></div></div><div class=3D"gmail_extra"><br><br><div=
 class=3D"gmail_quote">2013/4/20 Eric Sandeen <span dir=3D"ltr">&lt;<a href=
=3D"mailto:sandeen@sandeen.net" target=3D"_blank">sandeen@sandeen.net</a>&g=
t;</span><br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"im">On 4/20/13 3:10 AM, =B7=FB=
=D3=C0=CC=CE wrote:<br>
&gt; Dear Eric,<br>
&gt; I have applied your latest patch and collected the following log:<br>
&gt;<br>
<br>
</div>If you like, I think you could drop the below patch again; it didn&#3=
9;t yield anything interesting and just makes for bigger trace logs.<br>
<br>
Every mode was 0100000 (S_ISREG / regular file) and flags were always 0.<br=
>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; You could also add this patch to the xfs t=
racepoints to print more information about the inodes - the mode &amp; flag=
s.<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; -Eric<br>
&gt;<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; diff --git a/fs/xfs/linux-2.6/xfs_trace.h =
b/fs/xfs/linux-2.6/xfs_trace.h<br>
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

--047d7b10d1b79cdc5f04dad38617--


--===============0019255568648101952==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0019255568648101952==--
