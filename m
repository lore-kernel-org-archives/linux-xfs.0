Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q48FP8LI197570 for <xfs@oss.sgi.com>; Tue, 8 May 2012 10:25:08 -0500
Received: from mail-wi0-f173.google.com (mail-wi0-f173.google.com
	[209.85.212.173]) by cuda.sgi.com with ESMTP id
	dgoh2rqHUN1MprFi (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 08 May 2012 08:25:06 -0700 (PDT)
Received: by wibhn9 with SMTP id hn9so701157wib.14
	for <xfs@oss.sgi.com>; Tue, 08 May 2012 08:25:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120508054703.GG5091@dastard>
References: <CAF7KpS-r4zRXZxBU3U8ohxA85-rEvbAzCewYZDr44MNdP+YmFg@mail.gmail.com>
	<20120507235955.GE5091@dastard>
	<CAF7KpS_02NjAzY1wOQ9U0kwjKH+SzA0O_3VqSfjJgv0P6Hjk=g@mail.gmail.com>
	<20120508044039.GF5091@dastard>
	<CAF7KpS906EpxfAMjzW1zx8fSdGacoxkg+Fz=P0Sb3yONMhe7gw@mail.gmail.com>
	<20120508054703.GG5091@dastard>
Date: Tue, 8 May 2012 23:25:05 +0800
Message-ID: <CAF7KpS8oyteCDFM9tYWMp1K_vVeD0LTCY+10dSEiM_99KU9sJw@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============0563541285318154935=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============0563541285318154935==
Content-Type: multipart/alternative; boundary=0016e68fa33bc21b0404bf87fdd3

--0016e68fa33bc21b0404bf87fdd3
Content-Type: text/plain; charset=ISO-8859-1

On Tue, May 8, 2012 at 1:47 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Tue, May 08, 2012 at 01:10:55PM +0800, Zhu Han wrote:
> > On Tue, May 8, 2012 at 12:40 PM, Dave Chinner <david@fromorbit.com>
> wrote:
> > > On Tue, May 08, 2012 at 11:24:52AM +0800, Zhu Han wrote:
> > > > On Tue, May 8, 2012 at 7:59 AM, Dave Chinner <david@fromorbit.com>
> > > wrote:
> > > > > And so now you've triggered the speculative delayed allocation
> > > > > beyond EOF, which is normal behaviour. Hence there are currently
> > > > > unused blocks beyond EOF which will get removed either when the
> next
> > > > > close(fd) occurs on the file or the inode is removed from the
> cache.
> > > > >
> > > >
> > > > Close(fd) should be invoked before dd quits. But why the extra blocks
> > > > beyond EOF are not freed?
> > >
> > > The removal is conditional on how many times the fd has been closed
> > > with dirty data on the inode.
> > >
> > > > The only way I found to remove the extra blocks is truncate the file
> to
> > > its
> > > > real size.
> > >
> > > If the close() didn't remove them, they will be removed when the
> > > inode ages out of the cache. Why do you even care about them?
> >
> > Our distributed system depends on the real length of files to account the
> > space usage.
>
> That's ..... naive. It's never been valid to assume that the file
> size is an accurate reflection of space usage, especially as it will
> *always* be wrong for sparse files. In the same light, you also
> cannot assume that it is an accurate reflection for non-sparse files
> because we can do both explicit and speculative allocation beyond
> EOF which only du will show. Not to mention that metadata is not
> accounted in the file length, and that can consume a significant
> amount of space, too.
>
> > This behavior make the account inaccurate.
>
> The block usage reported by XFS is both accurate and correct. The
> file size reported by XFS is both accurate and correct. You're
> "account inaccuracy" is assuming that they are the same. Perhaps you
> should be using quotas for accurate space usage accounting?
>
> Anyway, if you really want to stop speculative delayed allocation
> beyond EOF, then use the allocsize mount option to control it.
>


Thanks for help.

I can control the size of pre-allocation, so no data are written beyond the
pre-allocated block range, so no speculative allocation is triggered.
Besides it, our system can sync the accurate space usage of mount point
periodically.

Can you give any hints about the most lightweight approach to get the
accurate block usage of whole file system?


>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--0016e68fa33bc21b0404bf87fdd3
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div class=3D"gmail_quote">On Tue, May 8, 2012 at 1:47 PM, Dave Chinner <sp=
an dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_blank"=
>david@fromorbit.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex=
">
<div class=3D"im">On Tue, May 08, 2012 at 01:10:55PM +0800, Zhu Han wrote:<=
br>
&gt; On Tue, May 8, 2012 at 12:40 PM, Dave Chinner &lt;<a href=3D"mailto:da=
vid@fromorbit.com">david@fromorbit.com</a>&gt; wrote:<br>
&gt; &gt; On Tue, May 08, 2012 at 11:24:52AM +0800, Zhu Han wrote:<br>
&gt; &gt; &gt; On Tue, May 8, 2012 at 7:59 AM, Dave Chinner &lt;<a href=3D"=
mailto:david@fromorbit.com">david@fromorbit.com</a>&gt;<br>
&gt; &gt; wrote:<br>
</div><div class=3D"im">&gt; &gt; &gt; &gt; And so now you&#39;ve triggered=
 the speculative delayed allocation<br>
&gt; &gt; &gt; &gt; beyond EOF, which is normal behaviour. Hence there are =
currently<br>
&gt; &gt; &gt; &gt; unused blocks beyond EOF which will get removed either =
when the next<br>
&gt; &gt; &gt; &gt; close(fd) occurs on the file or the inode is removed fr=
om the cache.<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Close(fd) should be invoked before dd quits. But why the ext=
ra blocks<br>
&gt; &gt; &gt; beyond EOF are not freed?<br>
&gt; &gt;<br>
&gt; &gt; The removal is conditional on how many times the fd has been clos=
ed<br>
&gt; &gt; with dirty data on the inode.<br>
&gt; &gt;<br>
&gt; &gt; &gt; The only way I found to remove the extra blocks is truncate =
the file to<br>
&gt; &gt; its<br>
&gt; &gt; &gt; real size.<br>
&gt; &gt;<br>
&gt; &gt; If the close() didn&#39;t remove them, they will be removed when =
the<br>
&gt; &gt; inode ages out of the cache. Why do you even care about them?<br>
&gt;<br>
&gt; Our distributed system depends on the real length of files to account =
the<br>
&gt; space usage.<br>
<br>
</div>That&#39;s ..... naive. It&#39;s never been valid to assume that the =
file<br>
size is an accurate reflection of space usage, especially as it will<br>
*always* be wrong for sparse files. In the same light, you also<br>
cannot assume that it is an accurate reflection for non-sparse files<br>
because we can do both explicit and speculative allocation beyond<br>
EOF which only du will show. Not to mention that metadata is not<br>
accounted in the file length, and that can consume a significant<br>
amount of space, too.<br>
<div class=3D"im"><br>
&gt; This behavior make the account inaccurate.<br>
<br>
</div>The block usage reported by XFS is both accurate and correct. The<br>
file size reported by XFS is both accurate and correct. You&#39;re<br>
&quot;account inaccuracy&quot; is assuming that they are the same. Perhaps =
you<br>
should be using quotas for accurate space usage accounting?<br>
<br>
Anyway, if you really want to stop speculative delayed allocation<br>
beyond EOF, then use the allocsize mount option to control it.<br></blockqu=
ote><div><br><br>Thanks for help. <br><br>I can control the size of pre-all=
ocation, so no data are written beyond the pre-allocated block range, so no=
 speculative allocation is triggered. Besides it, our system can sync the a=
ccurate space usage of mount point periodically.=A0 <br>
<br>Can you give any hints about the most lightweight approach to get the a=
ccurate block usage of whole file system?<br>=A0<br></div><blockquote class=
=3D"gmail_quote" style=3D"margin:0pt 0pt 0pt 0.8ex;border-left:1px solid rg=
b(204,204,204);padding-left:1ex">

<div class=3D"HOEnZb"><div class=3D"h5"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</div></div></blockquote></div><br>

--0016e68fa33bc21b0404bf87fdd3--


--===============0563541285318154935==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0563541285318154935==--
