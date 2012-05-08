Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q483OtAu023288 for <xfs@oss.sgi.com>; Mon, 7 May 2012 22:24:55 -0500
Received: from mail-wi0-f169.google.com (mail-wi0-f169.google.com
	[209.85.212.169]) by cuda.sgi.com with ESMTP id
	jbvEfJanaN6gqTXC (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 07 May 2012 20:24:53 -0700 (PDT)
Received: by wibhn14 with SMTP id hn14so194837wib.2
	for <xfs@oss.sgi.com>; Mon, 07 May 2012 20:24:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120507235955.GE5091@dastard>
References: <CAF7KpS-r4zRXZxBU3U8ohxA85-rEvbAzCewYZDr44MNdP+YmFg@mail.gmail.com>
	<20120507235955.GE5091@dastard>
Date: Tue, 8 May 2012 11:24:52 +0800
Message-ID: <CAF7KpS_02NjAzY1wOQ9U0kwjKH+SzA0O_3VqSfjJgv0P6Hjk=g@mail.gmail.com>
Subject: Re: fallocate bug?
From: Zhu Han <schumi.han@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8320516844992165846=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============8320516844992165846==
Content-Type: multipart/alternative; boundary=0016e6de00410ede5b04bf7dee55

--0016e6de00410ede5b04bf7dee55
Content-Type: text/plain; charset=ISO-8859-1

On Tue, May 8, 2012 at 7:59 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Mon, May 07, 2012 at 08:44:17PM +0800, Zhu Han wrote:
> > Seems like xfs of CentOS 6.X occupies much more storage space than
> desired
> > if fallocate is used against the file. Here is the step to reproduce it:
>
> You test case is not doing what you think it is doing.
>

Thanks for pointing it out.



>
> > By the way, is it normal when the file is moved around after the
> > preallocated region is filled with data?
> >
> > $ uname -r
> > 2.6.32-220.7.1.el6.x86_64
> >
> > $fallocate -n --offset 0 -l 1G file    ---->Write a little more data than
> > the preallocated size
> >
> > $ xfs_bmap -p -vv file
> > file:
> >  EXT: FILE-OFFSET      BLOCK-RANGE            AG AG-OFFSET
> > TOTAL FLAGS
> >    0: [0..2097151]:    2593408088..2595505239 21 (29420144..31517295)
> > 2097152 10000
> >
> > $ dd if=/dev/zero of=/tmp/file bs=1M count=1026 conv=fsync
>
> That does a truncate first, removing all the preallocated space. Use
> conv=notrunc to avoid this. Hence the space allocated by this
> new write is different to the space allocated by the above
> preallocation. The file has not been moved, the filesystem just did
> what you asked it to do.
>
> >
> > $ xfs_bmap -p -vv file
> > file:
> >  EXT: FILE-OFFSET      BLOCK-RANGE            AG AG-OFFSET
> > TOTAL FLAGS
> >    0: [0..4194303]:    2709184016..2713378319 22 (23101408..27295711)
> > 4194304 00000
>
> And so now you've triggered the speculative delayed allocation
> beyond EOF, which is normal behaviour. Hence there are currently
> unused blocks beyond EOF which will get removed either when the next
> close(fd) occurs on the file or the inode is removed from the cache.
>

Close(fd) should be invoked before dd quits. But why the extra blocks
beyond EOF are not freed?

The only way I found to remove the extra blocks is truncate the file to its
real size.


>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--0016e6de00410ede5b04bf7dee55
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div class=3D"gmail_quote">On Tue, May 8, 2012 at 7:59 AM, Dave Chinner <sp=
an dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_blank"=
>david@fromorbit.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex=
">
<div class=3D"im">On Mon, May 07, 2012 at 08:44:17PM +0800, Zhu Han wrote:<=
br>
&gt; Seems like xfs of CentOS 6.X occupies much more storage space than des=
ired<br>
&gt; if fallocate is used against the file. Here is the step to reproduce i=
t:<br>
<br>
</div>You test case is not doing what you think it is doing.<br></blockquot=
e><div><br>Thanks for pointing it out. <br><br>=A0<br></div><blockquote cla=
ss=3D"gmail_quote" style=3D"margin:0pt 0pt 0pt 0.8ex;border-left:1px solid =
rgb(204,204,204);padding-left:1ex">

<div class=3D"im"><br>
&gt; By the way, is it normal when the file is moved around after the<br>
&gt; preallocated region is filled with data?<br>
&gt;<br>
&gt; $ uname -r<br>
&gt; 2.6.32-220.7.1.el6.x86_64<br>
&gt;<br>
&gt; $fallocate -n --offset 0 -l 1G file =A0 =A0----&gt;Write a little more=
 data than<br>
&gt; the preallocated size<br>
&gt;<br>
&gt; $ xfs_bmap -p -vv file<br>
&gt; file:<br>
&gt; =A0EXT: FILE-OFFSET =A0 =A0 =A0BLOCK-RANGE =A0 =A0 =A0 =A0 =A0 =A0AG A=
G-OFFSET<br>
&gt; TOTAL FLAGS<br>
&gt; =A0 =A00: [0..2097151]: =A0 =A02593408088..2595505239 21 (29420144..31=
517295)<br>
&gt; 2097152 10000<br>
&gt;<br>
&gt; $ dd if=3D/dev/zero of=3D/tmp/file bs=3D1M count=3D1026 conv=3Dfsync<b=
r>
<br>
</div>That does a truncate first, removing all the preallocated space. Use<=
br>
conv=3Dnotrunc to avoid this. Hence the space allocated by this<br>
new write is different to the space allocated by the above<br>
preallocation. The file has not been moved, the filesystem just did<br>
what you asked it to do.<br>
<div class=3D"im"><br>
&gt;<br>
&gt; $ xfs_bmap -p -vv file<br>
&gt; file:<br>
&gt; =A0EXT: FILE-OFFSET =A0 =A0 =A0BLOCK-RANGE =A0 =A0 =A0 =A0 =A0 =A0AG A=
G-OFFSET<br>
&gt; TOTAL FLAGS<br>
&gt; =A0 =A00: [0..4194303]: =A0 =A02709184016..2713378319 22 (23101408..27=
295711)<br>
&gt; 4194304 00000<br>
<br>
</div>And so now you&#39;ve triggered the speculative delayed allocation<br=
>
beyond EOF, which is normal behaviour. Hence there are currently<br>
unused blocks beyond EOF which will get removed either when the next<br>
close(fd) occurs on the file or the inode is removed from the cache.<br></b=
lockquote><div><br>Close(fd) should be invoked before dd quits. But why the=
 extra blocks beyond EOF are not freed?<br><br>The only way I found to remo=
ve the extra blocks is truncate the file to its real size. <br>
=A0<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0pt 0pt 0pt =
0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">
<br>
Cheers,<br>
<br>
Dave.<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</font></span></blockquote></div><br>

--0016e6de00410ede5b04bf7dee55--


--===============8320516844992165846==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8320516844992165846==--
