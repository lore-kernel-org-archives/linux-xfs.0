Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A19B429DFA
	for <xfs@oss.sgi.com>; Fri, 19 Apr 2013 23:27:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8C81E304070
	for <xfs@oss.sgi.com>; Fri, 19 Apr 2013 21:27:41 -0700 (PDT)
Received: from mail-ia0-f176.google.com (mail-ia0-f176.google.com
	[209.85.210.176]) by cuda.sgi.com with ESMTP id
	ITGMDQQyRbaQEz7G (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Apr 2013 21:27:40 -0700 (PDT)
Received: by mail-ia0-f176.google.com with SMTP id i9so3926906iad.7
	for <xfs@oss.sgi.com>; Fri, 19 Apr 2013 21:27:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51721798.1060501@sandeen.net>
References: <516C89DF.4070904@redhat.com>
	<CADFMGu+hPV9RanG7298TAYY4p9gMiBOk0+mq5gf5rhQUWXf4TQ@mail.gmail.com>
	<CADFMGuJYDp-YrPDqsz2KKx6_2RCkP37ZNGPLzdTVOpEgKDMsjA@mail.gmail.com>
	<51715BD4.8080501@sandeen.net>
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
Date: Sat, 20 Apr 2013 12:27:39 +0800
Message-ID: <CADFMGuJAXcA0CTYEoaRNvsTv7DhHeOBgk+j_HiMceT1neoEzRQ@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============6139140392986126382=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Brian Foster <bfoster@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============6139140392986126382==
Content-Type: multipart/alternative; boundary=089e0111e0748da7bc04dac3414b

--089e0111e0748da7bc04dac3414b
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

Hi Eric,
The xfs module is loaded from system kernel, it happens on our production
server too (I did not touch that till now) and if the xfs module is mess up
the systemstap may also not working but now it works. As you have
mentioned, strange thing is xfs shutdown always happens when glusterfs
rebalance completes.


2013/4/20 Eric Sandeen <sandeen@sandeen.net>

> On 4/19/13 9:03 PM, =B7=FB=D3=C0=CC=CE wrote:
> > Hi Eric,
> > I will enable them and run test again. I can only reproduce it with
> > glusterfs rebalance. Glusterfs uses a mechanism it called syncop to
> > unlink file. For rebalance it uses
> > syncop_unlink(glusterfs/libglusterfs/src/syncop.c). In the glusterfs
> > sync_task framework(glusterfs/libglusterfs/src/syncop.c) it uses
> > "makecontext/swapcontext"
> > <
> http://www.opengroup.org/onlinepubs/009695399/functions/makecontext.html>=
.
> > Does it leads to racing unlink from different CPU core?
>
> Yep, I understand that it's rebalance.  It dies when rebalance finishes
> because an
> open but unlinked file trips over the corrupted list from earlier, it
> seems.
>
> I don't know why makecontext would matter...
>
> Just to be sure, you are definitely loading the xfs module from the kerne=
l
> you built, right, and you don't have a "priority" module getting loaded
> from elsewhere?  Seems unlikely, but just to be sure.
>
> > Thank you.
>
> You could also add this patch to the xfs tracepoints to print more
> information about the inodes - the mode & flags.
>
> -Eric
>
>
> diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
> index e8ce644..c314b87 100644
> --- a/fs/xfs/linux-2.6/xfs_trace.h
> +++ b/fs/xfs/linux-2.6/xfs_trace.h
> @@ -544,14 +544,18 @@ DECLARE_EVENT_CLASS(xfs_inode_class,
>         TP_STRUCT__entry(
>                 __field(dev_t, dev)
>                 __field(xfs_ino_t, ino)
> +               __field(__u16, mode)
> +               __field(unsigned long, flags)
>         ),
>         TP_fast_assign(
>                 __entry->dev =3D VFS_I(ip)->i_sb->s_dev;
>                 __entry->ino =3D ip->i_ino;
> +               __entry->mode =3D VFS_I(ip)->i_mode;
> +               __entry->flags =3D ip->i_flags;
>         ),
> -       TP_printk("dev %d:%d ino 0x%llx",
> +       TP_printk("dev %d:%d ino 0x%llx mode 0%o, flags 0x%lx",
>                   MAJOR(__entry->dev), MINOR(__entry->dev),
> -                 __entry->ino)
> +                 __entry->ino, __entry->mode, __entry->flags)
>  )
>
>  #define DEFINE_INODE_EVENT(name) \
>
>
>
>


--=20
=B7=FB=D3=C0=CC=CE

--089e0111e0748da7bc04dac3414b
Content-Type: text/html; charset=GB2312
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi Eric,<br></div>The xfs module is loaded from syste=
m kernel, it happens on our production server too (I did not touch that til=
l now) and if the xfs module is mess up the systemstap may also not working=
 but now it works. As you have mentioned, strange thing is xfs shutdown alw=
ays happens when glusterfs rebalance completes.<br>
</div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">2013/4/=
20 Eric Sandeen <span dir=3D"ltr">&lt;<a href=3D"mailto:sandeen@sandeen.net=
" target=3D"_blank">sandeen@sandeen.net</a>&gt;</span><br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">
<div class=3D"im">On 4/19/13 9:03 PM, =B7=FB=D3=C0=CC=CE wrote:<br>
&gt; Hi Eric,<br>
&gt; I will enable them and run test again. I can only reproduce it with<br=
>
&gt; glusterfs rebalance. Glusterfs uses a mechanism it called syncop to<br=
>
&gt; unlink file. For rebalance it uses<br>
&gt; syncop_unlink(glusterfs/libglusterfs/src/syncop.c). In the glusterfs<b=
r>
&gt; sync_task framework(glusterfs/libglusterfs/src/syncop.c) it uses<br>
&gt; &quot;makecontext/swapcontext&quot;<br>
</div>&gt; &lt;<a href=3D"http://www.opengroup.org/onlinepubs/009695399/fun=
ctions/makecontext.html" target=3D"_blank">http://www.opengroup.org/onlinep=
ubs/009695399/functions/makecontext.html</a>&gt;.<br>
<div class=3D"im">&gt; Does it leads to racing unlink from different CPU co=
re?<br>
<br>
</div>Yep, I understand that it&#39;s rebalance. &nbsp;It dies when rebalan=
ce finishes because an<br>
open but unlinked file trips over the corrupted list from earlier, it seems=
.<br>
<br>
I don&#39;t know why makecontext would matter...<br>
<br>
Just to be sure, you are definitely loading the xfs module from the kernel =
you built, right, and you don&#39;t have a &quot;priority&quot; module gett=
ing loaded from elsewhere? &nbsp;Seems unlikely, but just to be sure.<br>
<br>
&gt; Thank you.<br>
<br>
You could also add this patch to the xfs tracepoints to print more informat=
ion about the inodes - the mode &amp; flags.<br>
<br>
-Eric<br>
<br>
<br>
diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h<br=
>
index e8ce644..c314b87 100644<br>
--- a/fs/xfs/linux-2.6/xfs_trace.h<br>
+++ b/fs/xfs/linux-2.6/xfs_trace.h<br>
@@ -544,14 +544,18 @@ DECLARE_EVENT_CLASS(xfs_inode_class,<br>
&nbsp; &nbsp; &nbsp; &nbsp; TP_STRUCT__entry(<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; __field(dev_t, dev)=
<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; __field(xfs_ino_t, =
ino)<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; __field(__u16, mode)<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; __field(unsigned long, f=
lags)<br>
&nbsp; &nbsp; &nbsp; &nbsp; ),<br>
&nbsp; &nbsp; &nbsp; &nbsp; TP_fast_assign(<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; __entry-&gt;dev =3D=
 VFS_I(ip)-&gt;i_sb-&gt;s_dev;<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; __entry-&gt;ino =3D=
 ip-&gt;i_ino;<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; __entry-&gt;mode =3D VFS=
_I(ip)-&gt;i_mode;<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; __entry-&gt;flags =3D ip=
-&gt;i_flags;<br>
&nbsp; &nbsp; &nbsp; &nbsp; ),<br>
- &nbsp; &nbsp; &nbsp; TP_printk(&quot;dev %d:%d ino 0x%llx&quot;,<br>
+ &nbsp; &nbsp; &nbsp; TP_printk(&quot;dev %d:%d ino 0x%llx mode 0%o, flags=
 0x%lx&quot;,<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; MAJOR(__entr=
y-&gt;dev), MINOR(__entry-&gt;dev),<br>
- &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; __entry-&gt;ino)<=
br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; __entry-&gt;ino, =
__entry-&gt;mode, __entry-&gt;flags)<br>
&nbsp;)<br>
<br>
&nbsp;#define DEFINE_INODE_EVENT(name) \<br>
<br>
<br>
<br>
</blockquote></div><br><br clear=3D"all"><br>-- <br>=B7=FB=D3=C0=CC=CE
</div>

--089e0111e0748da7bc04dac3414b--


--===============6139140392986126382==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6139140392986126382==--
