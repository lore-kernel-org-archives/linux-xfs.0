Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q485Aw6S056199 for <xfs@oss.sgi.com>; Tue, 8 May 2012 00:10:59 -0500
Received: from mail-wg0-f51.google.com (mail-wg0-f51.google.com
	[74.125.82.51]) by cuda.sgi.com with ESMTP id w6xm0eUA1Z9EhWtj
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 07 May 2012 22:10:56 -0700 (PDT)
Received: by wgbed3 with SMTP id ed3so549390wgb.32
	for <xfs@oss.sgi.com>; Mon, 07 May 2012 22:10:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120508044039.GF5091@dastard>
References: <CAF7KpS-r4zRXZxBU3U8ohxA85-rEvbAzCewYZDr44MNdP+YmFg@mail.gmail.com>
	<20120507235955.GE5091@dastard>
	<CAF7KpS_02NjAzY1wOQ9U0kwjKH+SzA0O_3VqSfjJgv0P6Hjk=g@mail.gmail.com>
	<20120508044039.GF5091@dastard>
Date: Tue, 8 May 2012 13:10:55 +0800
Message-ID: <CAF7KpS906EpxfAMjzW1zx8fSdGacoxkg+Fz=P0Sb3yONMhe7gw@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============3975929015565105301=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============3975929015565105301==
Content-Type: multipart/alternative; boundary=e89a8f234ce55320d004bf7f696c

--e89a8f234ce55320d004bf7f696c
Content-Type: text/plain; charset=ISO-8859-1

On Tue, May 8, 2012 at 12:40 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Tue, May 08, 2012 at 11:24:52AM +0800, Zhu Han wrote:
> > On Tue, May 8, 2012 at 7:59 AM, Dave Chinner <david@fromorbit.com>
> wrote:
> >
> > > On Mon, May 07, 2012 at 08:44:17PM +0800, Zhu Han wrote:
> > > > Seems like xfs of CentOS 6.X occupies much more storage space than
> > > desired
> > > > if fallocate is used against the file. Here is the step to reproduce
> it:
> > >
> > > You test case is not doing what you think it is doing.
> >
> > Thanks for pointing it out.
> >
> > > > By the way, is it normal when the file is moved around after the
> > > > preallocated region is filled with data?
> > > >
> > > > $ uname -r
> > > > 2.6.32-220.7.1.el6.x86_64
> > > >
> > > > $fallocate -n --offset 0 -l 1G file    ---->Write a little more data
> than
> > > > the preallocated size
> > > >
> > > > $ xfs_bmap -p -vv file
> > > > file:
> > > >  EXT: FILE-OFFSET      BLOCK-RANGE            AG AG-OFFSET
> > > > TOTAL FLAGS
> > > >    0: [0..2097151]:    2593408088..2595505239 21 (29420144..31517295)
> > > > 2097152 10000
> > > >
> > > > $ dd if=/dev/zero of=/tmp/file bs=1M count=1026 conv=fsync
> > >
> > > That does a truncate first, removing all the preallocated space. Use
> > > conv=notrunc to avoid this. Hence the space allocated by this
> > > new write is different to the space allocated by the above
> > > preallocation. The file has not been moved, the filesystem just did
> > > what you asked it to do.
> > >
> > > >
> > > > $ xfs_bmap -p -vv file
> > > > file:
> > > >  EXT: FILE-OFFSET      BLOCK-RANGE            AG AG-OFFSET
> > > > TOTAL FLAGS
> > > >    0: [0..4194303]:    2709184016..2713378319 22 (23101408..27295711)
> > > > 4194304 00000
> > >
> > > And so now you've triggered the speculative delayed allocation
> > > beyond EOF, which is normal behaviour. Hence there are currently
> > > unused blocks beyond EOF which will get removed either when the next
> > > close(fd) occurs on the file or the inode is removed from the cache.
> > >
> >
> > Close(fd) should be invoked before dd quits. But why the extra blocks
> > beyond EOF are not freed?
>
> The removal is conditional on how many times the fd has been closed
> with dirty data on the inode.
>
> > The only way I found to remove the extra blocks is truncate the file to
> its
> > real size.
>
> If the close() didn't remove them, they will be removed when the
> inode ages out of the cache. Why do you even care about them?
>

Our distributed system depends on the real length of files to account the
space usage. This behavior make the account inaccurate.


>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--e89a8f234ce55320d004bf7f696c
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><div class=3D"gmail_quote">On Tue, May 8, 2012 at 12:40 PM, Dave Chinne=
r <span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_b=
lank">david@fromorbit.com</a>&gt;</span> wrote:<br><blockquote class=3D"gma=
il_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-lef=
t:1ex">
<div class=3D"HOEnZb"><div class=3D"h5">On Tue, May 08, 2012 at 11:24:52AM =
+0800, Zhu Han wrote:<br>
&gt; On Tue, May 8, 2012 at 7:59 AM, Dave Chinner &lt;<a href=3D"mailto:dav=
id@fromorbit.com">david@fromorbit.com</a>&gt; wrote:<br>
&gt;<br>
&gt; &gt; On Mon, May 07, 2012 at 08:44:17PM +0800, Zhu Han wrote:<br>
&gt; &gt; &gt; Seems like xfs of CentOS 6.X occupies much more storage spac=
e than<br>
&gt; &gt; desired<br>
&gt; &gt; &gt; if fallocate is used against the file. Here is the step to r=
eproduce it:<br>
&gt; &gt;<br>
&gt; &gt; You test case is not doing what you think it is doing.<br>
&gt;<br>
&gt; Thanks for pointing it out.<br>
&gt;<br>
&gt; &gt; &gt; By the way, is it normal when the file is moved around after=
 the<br>
&gt; &gt; &gt; preallocated region is filled with data?<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; $ uname -r<br>
&gt; &gt; &gt; 2.6.32-220.7.1.el6.x86_64<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; $fallocate -n --offset 0 -l 1G file =A0 =A0----&gt;Write a l=
ittle more data than<br>
&gt; &gt; &gt; the preallocated size<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; $ xfs_bmap -p -vv file<br>
&gt; &gt; &gt; file:<br>
&gt; &gt; &gt; =A0EXT: FILE-OFFSET =A0 =A0 =A0BLOCK-RANGE =A0 =A0 =A0 =A0 =
=A0 =A0AG AG-OFFSET<br>
&gt; &gt; &gt; TOTAL FLAGS<br>
&gt; &gt; &gt; =A0 =A00: [0..2097151]: =A0 =A02593408088..2595505239 21 (29=
420144..31517295)<br>
&gt; &gt; &gt; 2097152 10000<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; $ dd if=3D/dev/zero of=3D/tmp/file bs=3D1M count=3D1026 conv=
=3Dfsync<br>
&gt; &gt;<br>
&gt; &gt; That does a truncate first, removing all the preallocated space. =
Use<br>
&gt; &gt; conv=3Dnotrunc to avoid this. Hence the space allocated by this<b=
r>
&gt; &gt; new write is different to the space allocated by the above<br>
&gt; &gt; preallocation. The file has not been moved, the filesystem just d=
id<br>
&gt; &gt; what you asked it to do.<br>
&gt; &gt;<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; $ xfs_bmap -p -vv file<br>
&gt; &gt; &gt; file:<br>
&gt; &gt; &gt; =A0EXT: FILE-OFFSET =A0 =A0 =A0BLOCK-RANGE =A0 =A0 =A0 =A0 =
=A0 =A0AG AG-OFFSET<br>
&gt; &gt; &gt; TOTAL FLAGS<br>
&gt; &gt; &gt; =A0 =A00: [0..4194303]: =A0 =A02709184016..2713378319 22 (23=
101408..27295711)<br>
&gt; &gt; &gt; 4194304 00000<br>
&gt; &gt;<br>
&gt; &gt; And so now you&#39;ve triggered the speculative delayed allocatio=
n<br>
&gt; &gt; beyond EOF, which is normal behaviour. Hence there are currently<=
br>
&gt; &gt; unused blocks beyond EOF which will get removed either when the n=
ext<br>
&gt; &gt; close(fd) occurs on the file or the inode is removed from the cac=
he.<br>
&gt; &gt;<br>
&gt;<br>
&gt; Close(fd) should be invoked before dd quits. But why the extra blocks<=
br>
&gt; beyond EOF are not freed?<br>
<br>
</div></div>The removal is conditional on how many times the fd has been cl=
osed<br>
with dirty data on the inode.<br>
<div class=3D"im"><br>
&gt; The only way I found to remove the extra blocks is truncate the file t=
o its<br>
&gt; real size.<br>
<br>
</div>If the close() didn&#39;t remove them, they will be removed when the<=
br>
inode ages out of the cache. Why do you even care about them?<br></blockquo=
te><div><br>Our distributed system depends on the real length of files to a=
ccount the space usage. This behavior make the account inaccurate. <br>
=A0<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0pt 0pt 0pt =
0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">
<div class=3D"HOEnZb"><div class=3D"h5"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</div></div></blockquote></div><br>

--e89a8f234ce55320d004bf7f696c--


--===============3975929015565105301==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3975929015565105301==--
