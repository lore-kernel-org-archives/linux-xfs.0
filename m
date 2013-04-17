Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9FFE87F37
	for <xfs@oss.sgi.com>; Tue, 16 Apr 2013 20:04:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8D11A8F8049
	for <xfs@oss.sgi.com>; Tue, 16 Apr 2013 18:04:32 -0700 (PDT)
Received: from mail-ie0-f174.google.com (mail-ie0-f174.google.com
	[209.85.223.174]) by cuda.sgi.com with ESMTP id
	aY26DMveaCZuFktw (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 16 Apr 2013 18:04:31 -0700 (PDT)
Received: by mail-ie0-f174.google.com with SMTP id 10so1335033ied.33
	for <xfs@oss.sgi.com>; Tue, 16 Apr 2013 18:04:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <516D87E3.2010605@redhat.com>
References: <516C89DF.4070904@redhat.com> <20130416162417.GC13938@destitution>
	<516D87E3.2010605@redhat.com>
Date: Wed, 17 Apr 2013 09:04:30 +0800
Message-ID: <CADFMGuLgU2++ym4U9axhevV_L2t-2CMVaDoT5cyQcew2YZMsBA@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============0902969442664869785=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============0902969442664869785==
Content-Type: multipart/alternative; boundary=14dae9340ee781023204da8411ba

--14dae9340ee781023204da8411ba
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

Hi Brain,
Thank you for your update, and I have applied your last kernel patch.
However it is not easy to reproduce especially in out test environment.
Till now is not happens again. I'll update the kernel patch now. BTW is
there any findings in the logs of previous thread?
http://oss.sgi.com/archives/xfs/2013-04/msg00327.html
I guess it tend to happen during glusterfs rebalance because glusterfs
moves a lot of file from one server to another and then unlink it.

Thank you.


2013/4/17 Brian Foster <bfoster@redhat.com>

> On 04/16/2013 12:24 PM, Dave Chinner wrote:
> > On Mon, Apr 15, 2013 at 07:14:39PM -0400, Brian Foster wrote:
> >> Hi,
> >>
> >> Thanks for the data in the previous thread:
> >>
> >> http://oss.sgi.com/archives/xfs/2013-04/msg00327.html
> >>
> ...
> >>
> >>      echo 1 > /sys/kernel/debug/tracing/events/xfs/xfs_iunlink/enable
> >>      echo 1 >
> /sys/kernel/debug/tracing/events/xfs/xfs_iunlink_remove/enable
> >>      ... reproduce ...
> >>      cat /sys/kernel/debug/tracing/trace > trace.output
> >
> > It's better to use trace-cmd for this. it will result in less
> > dropped events. i.e.:
> >
> >       $ trace-cmd record -e xfs_iunlink\*
> >       ... reproduce ...
> >       ^C
> >       $ trace-cmd report > trace.output
> >
> >> --- a/fs/xfs/linux-2.6/xfs_trace.h
> >> +++ b/fs/xfs/linux-2.6/xfs_trace.h
> >> @@ -581,6 +581,8 @@ DEFINE_INODE_EVENT(xfs_file_fsync);
> ...
> >
> > I would suggest that the the tracing shoul dbe at entry of the
> > function, otherwise we won't get a tracepoint for the operation that
> > triggers the shutdown. (That's the reason most tracepoints in XFS
> > are at function entry...)
> >
>
> Good points, thanks Dave. A v2 that pulls up the tracepoints towards
> function entry is appended.
>
> Brian
>
> From 280943e78ebe0b97a774cba51e7815c42f044b55 Mon Sep 17 00:00:00 2001
> From: Brian Foster <bfoster@redhat.com>
> Date: Mon, 15 Apr 2013 18:16:24 -0400
> Subject: [PATCH v2] xfs: add tracepoints for xfs_iunlink and
> xfs_iunlink_remove
>
> ---
>  fs/xfs/linux-2.6/xfs_trace.h |    2 ++
>  fs/xfs/xfs_inode.c           |    4 ++++
>  2 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
> index adc6ec4..338a0f9 100644
> --- a/fs/xfs/linux-2.6/xfs_trace.h
> +++ b/fs/xfs/linux-2.6/xfs_trace.h
> @@ -583,6 +583,8 @@ DEFINE_INODE_EVENT(xfs_file_fsync);
>  DEFINE_INODE_EVENT(xfs_destroy_inode);
>  DEFINE_INODE_EVENT(xfs_dirty_inode);
>  DEFINE_INODE_EVENT(xfs_clear_inode);
> +DEFINE_INODE_EVENT(xfs_iunlink);
> +DEFINE_INODE_EVENT(xfs_iunlink_remove);
>
>  DEFINE_INODE_EVENT(xfs_dquot_dqalloc);
>  DEFINE_INODE_EVENT(xfs_dquot_dqdetach);
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 19900f0..d705c77 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1615,6 +1615,8 @@ xfs_iunlink(
>
>         mp =3D tp->t_mountp;
>
> +       trace_xfs_iunlink(ip);
> +
>         /*
>          * Get the agi buffer first.  It ensures lock ordering
>          * on the list.
> @@ -1694,6 +1696,8 @@ xfs_iunlink_remove(
>         mp =3D tp->t_mountp;
>         agno =3D XFS_INO_TO_AGNO(mp, ip->i_ino);
>
> +       trace_xfs_iunlink_remove(ip);
> +
>         /*
>          * Get the agi buffer first.  It ensures lock ordering
>          * on the list.
> --
> 1.7.7.6
>
>


--=20
=B7=FB=D3=C0=CC=CE

--14dae9340ee781023204da8411ba
Content-Type: text/html; charset=GB2312
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div>Hi Brain,<br></div>Thank you for your update, an=
d I have applied your last kernel patch. However it is not easy to reproduc=
e especially in out test environment. Till now is not happens again. I&#39;=
ll update the kernel patch now. BTW is there any findings in the logs of pr=
evious thread?<br>
<a href=3D"http://oss.sgi.com/archives/xfs/2013-04/msg00327.html" target=3D=
"_blank">http://oss.sgi.com/archives/xfs/2013-04/msg00327.html</a><br>I gue=
ss it tend to happen during glusterfs rebalance because glusterfs moves a l=
ot of file from one server to another and then unlink it.<br>
<br></div>Thank you.<br></div><div class=3D"gmail_extra"><br><br><div class=
=3D"gmail_quote">2013/4/17 Brian Foster <span dir=3D"ltr">&lt;<a href=3D"ma=
ilto:bfoster@redhat.com" target=3D"_blank">bfoster@redhat.com</a>&gt;</span=
><br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-le=
ft:1px #ccc solid;padding-left:1ex">
<div class=3D"im">On 04/16/2013 12:24 PM, Dave Chinner wrote:<br>
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
<div class=3D"im">&gt;&gt;<br>
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
<div class=3D"im">&gt;<br>
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
From: Brian Foster &lt;<a href=3D"mailto:bfoster@redhat.com">bfoster@redhat=
.com</a>&gt;<br>
Date: Mon, 15 Apr 2013 18:16:24 -0400<br>
Subject: [PATCH v2] xfs: add tracepoints for xfs_iunlink and<br>
xfs_iunlink_remove<br>
<div class=3D"im"><br>
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
<div class=3D"im">&nbsp;DEFINE_INODE_EVENT(xfs_clear_inode);<br>
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
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
1.7.7.6<br>
<br>
</font></span></blockquote></div><br><br clear=3D"all"><br>-- <br>=B7=FB=D3=
=C0=CC=CE
</div>

--14dae9340ee781023204da8411ba--


--===============0902969442664869785==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0902969442664869785==--
