Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A91BC7F53
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 19:47:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 385F1AC002
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 17:47:25 -0700 (PDT)
Received: from mail-qa0-f54.google.com (mail-qa0-f54.google.com
	[209.85.216.54]) by cuda.sgi.com with ESMTP id L5HjfDzy8gUrd6UY
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 02 May 2014 17:47:23 -0700 (PDT)
Received: by mail-qa0-f54.google.com with SMTP id s7so5051241qap.27
	for <xfs@oss.sgi.com>; Fri, 02 May 2014 17:47:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140503000512.GH26353@dastard>
References: <CALjwKZDsGBxTDLvy7-W76FRpHRuki_ZjOXLWZ70fut4hmDkTSQ@mail.gmail.com>
	<20140428234558.GD18672@dastard>
	<CALjwKZCZrpHNnqCWyotiYvLNa8yJMRoBgNp4NShSj0j2hLJ9DQ@mail.gmail.com>
	<20140429010121.GE18672@dastard>
	<CALjwKZBj0f_y7MPp-PLqhLDOnfmf2OWsvv_vbnX08ubevqM+Bg@mail.gmail.com>
	<20140430032209.GA22353@dastard>
	<CALjwKZDeTcOSJDtRcNa3KtLraPKvWUB0jvQrwSANxB0RHds0Rg@mail.gmail.com>
	<20140503000512.GH26353@dastard>
Date: Fri, 2 May 2014 18:47:21 -0600
Message-ID: <CALjwKZC+VMrd4qUmObC=T56ZAqYj-s9XEvwBdXZcNyAC5-ZYeA@mail.gmail.com>
Subject: Re: xfs umount hang in xfs_ail_push_all_sync on i/o error
From: Bob Mastors <bob.mastors@solidfire.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3618801214531413474=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============3618801214531413474==
Content-Type: multipart/alternative; boundary=001a113a9c10b0837604f8743ddd

--001a113a9c10b0837604f8743ddd
Content-Type: text/plain; charset=UTF-8

On Fri, May 2, 2014 at 6:05 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Fri, May 02, 2014 at 11:32:19AM -0600, Bob Mastors wrote:
> > On Tue, Apr 29, 2014 at 9:22 PM, Dave Chinner <david@fromorbit.com>
> wrote:
> > > Well, I guess I should been more specific. ftrace is pretty much
> > > useless here - we need the information taht is recorded by the
> > > events, not the timing of the events.
> > >
> > Heh, I have been trying to bluff my way through this.
> > I have hacked on file systems but am new to linux and xfs.
>
> I wouldn't have guessed that. Most of the time the response is
> "trace events? what are they?". :)
>
> > Output file attached but it all looks like this:
> >
> >      xfsaild/sdb-3613 [001] 445.757616: xfs_ail_flushing:     dev 8:16
> > lip 0x0xffff88001d3017b8 lsn 32/3573 type XFS_LI_INODE flags IN_AIL
> >      xfsaild/sdb-3613  [001]   445.757617: xfs_ail_flushing:     dev 8:16
> > lip 0x0xffff88001d301850 lsn 32/3573 type XFS_LI_INODE flags IN_AIL
> >      xfsaild/sdb-3613  [001]   445.757618: xfs_ail_flushing:     dev 8:16
> > lip 0x0xffff88001de63ed8 lsn 32/3573 type XFS_LI_INODE flags IN_AIL
> >      xfsaild/sdb-3613  [001]   445.757618: xfs_ail_flushing:     dev 8:16
> > lip 0x0xffff88001cd24720 lsn 32/3573 type XFS_LI_INODE flags IN_AIL
> >      xfsaild/sdb-3613  [001]   445.757618: xfs_ail_flushing:     dev 8:16
> > lip 0x0xffff88001cd248e8 lsn 32/3573 type XFS_LI_INODE flags IN_AIL
> >      xfsaild/sdb-3613  [001]   445.757619: xfs_ail_flushing:     dev 8:16
> > lip 0x0xffff88002c435ab0 lsn 32/3573 type XFS_LI_INODE flags IN_AIL
>
> That's very enlightening - a bunch of inodes returning
> XFS_ITEM_FLUSHING from attempts to push them.
>
> > The addresses repeat.
> > I started the record as soon as I noticed the umount hanging, probably
> > within 20 seconds or so.
> > Also attached is the console output.
> >
> > This was done with your patch applied.
> >
> > Seems like xfsaild_push is missing a check that the file system is
> > XFS_FORCED_SHUTDOWN.
>
> It might look that way, but what is supposed to happen is that
> everything else is supposed to handle shutdown situations and empty
> the AIL. i.e. the act of issuing IO by the AIL is supposed to
> trigger shutdown processing on the objects, and so having the AIL
> shut down itself won't help.
>
> So, what's the problem? Well, the inodes have been flushed,
> triggering the inode buffer to be written. However, then inode
> buffer has had an IO error (i.e. the async write error), is retried,
> and then we stop retrying the IO. The idea is that the AIL will push
> it again soon and the IO will be retried.
>
> What is happening is that the inodes in the buffer are already
> marked as "being flushed" and hence the AIL does not push the inode
> buffer again, and hence the IO completion callbacks on the buffer
> that will remove the inodes from the AIL are never called. Not sure
> how to fix this one yet....
>
Thanks for the explanation.
It clears up some questions I had.


>
> > Let me know if there is any other info I can capture that would be
> > interesting.
>
> I know what the problem is now, so testing a fix will be the next
> step. But I need to think about how to fix this, and that can wait
> till Monday. ;)
>
Just an fyi next week is busy for me with some other stuff so I
won't be able to try out a fix until the following week.


>
> Thanks for following up with the trace information, Bob!
>
Not a problem.

Thanks,
Bob


>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--001a113a9c10b0837604f8743ddd
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote">On F=
ri, May 2, 2014 at 6:05 PM, Dave Chinner <span dir=3D"ltr">&lt;<a href=3D"m=
ailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>&gt;</s=
pan> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"">On Fri, May 02, 2014 at 11:3=
2:19AM -0600, Bob Mastors wrote:<br>
&gt; On Tue, Apr 29, 2014 at 9:22 PM, Dave Chinner &lt;<a href=3D"mailto:da=
vid@fromorbit.com">david@fromorbit.com</a>&gt; wrote:<br>
</div><div class=3D"">&gt; &gt; Well, I guess I should been more specific. =
ftrace is pretty much<br>
&gt; &gt; useless here - we need the information taht is recorded by the<br=
>
&gt; &gt; events, not the timing of the events.<br>
&gt; &gt;<br>
&gt; Heh, I have been trying to bluff my way through this.<br>
&gt; I have hacked on file systems but am new to linux and xfs.<br>
<br>
</div>I wouldn&#39;t have guessed that. Most of the time the response is<br=
>
&quot;trace events? what are they?&quot;. :)<br>
<div class=3D""><br>
&gt; Output file attached but it all looks like this:<br>
&gt;<br>
&gt; =C2=A0 =C2=A0 =C2=A0xfsaild/sdb-<a href=3D"tel:3613%20%20%5B001%5D%20%=
20%20445" value=3D"+13613001445">3613  [001]   445</a>.757616: xfs_ail_flus=
hing: =C2=A0 =C2=A0 dev 8:16<br>
&gt; lip 0x0xffff88001d3017b8 lsn 32/3573 type XFS_LI_INODE flags IN_AIL<br=
>
&gt; =C2=A0 =C2=A0 =C2=A0xfsaild/sdb-3613 =C2=A0[001] =C2=A0 445.757617: xf=
s_ail_flushing: =C2=A0 =C2=A0 dev 8:16<br>
&gt; lip 0x0xffff88001d301850 lsn 32/3573 type XFS_LI_INODE flags IN_AIL<br=
>
&gt; =C2=A0 =C2=A0 =C2=A0xfsaild/sdb-3613 =C2=A0[001] =C2=A0 445.757618: xf=
s_ail_flushing: =C2=A0 =C2=A0 dev 8:16<br>
&gt; lip 0x0xffff88001de63ed8 lsn 32/3573 type XFS_LI_INODE flags IN_AIL<br=
>
&gt; =C2=A0 =C2=A0 =C2=A0xfsaild/sdb-3613 =C2=A0[001] =C2=A0 445.757618: xf=
s_ail_flushing: =C2=A0 =C2=A0 dev 8:16<br>
&gt; lip 0x0xffff88001cd24720 lsn 32/3573 type XFS_LI_INODE flags IN_AIL<br=
>
&gt; =C2=A0 =C2=A0 =C2=A0xfsaild/sdb-3613 =C2=A0[001] =C2=A0 445.757618: xf=
s_ail_flushing: =C2=A0 =C2=A0 dev 8:16<br>
&gt; lip 0x0xffff88001cd248e8 lsn 32/3573 type XFS_LI_INODE flags IN_AIL<br=
>
&gt; =C2=A0 =C2=A0 =C2=A0xfsaild/sdb-3613 =C2=A0[001] =C2=A0 445.757619: xf=
s_ail_flushing: =C2=A0 =C2=A0 dev 8:16<br>
&gt; lip 0x0xffff88002c435ab0 lsn 32/3573 type XFS_LI_INODE flags IN_AIL<br=
>
<br>
</div>That&#39;s very enlightening - a bunch of inodes returning<br>
XFS_ITEM_FLUSHING from attempts to push them.<br>
<div class=3D""><br>
&gt; The addresses repeat.<br>
&gt; I started the record as soon as I noticed the umount hanging, probably=
<br>
&gt; within 20 seconds or so.<br>
&gt; Also attached is the console output.<br>
&gt;<br>
&gt; This was done with your patch applied.<br>
&gt;<br>
&gt; Seems like xfsaild_push is missing a check that the file system is<br>
&gt; XFS_FORCED_SHUTDOWN.<br>
<br>
</div>It might look that way, but what is supposed to happen is that<br>
everything else is supposed to handle shutdown situations and empty<br>
the AIL. i.e. the act of issuing IO by the AIL is supposed to<br>
trigger shutdown processing on the objects, and so having the AIL<br>
shut down itself won&#39;t help.<br>
<br>
So, what&#39;s the problem? Well, the inodes have been flushed,<br>
triggering the inode buffer to be written. However, then inode<br>
buffer has had an IO error (i.e. the async write error), is retried,<br>
and then we stop retrying the IO. The idea is that the AIL will push<br>
it again soon and the IO will be retried.<br>
<br>
What is happening is that the inodes in the buffer are already<br>
marked as &quot;being flushed&quot; and hence the AIL does not push the ino=
de<br>
buffer again, and hence the IO completion callbacks on the buffer<br>
that will remove the inodes from the AIL are never called. Not sure<br>
how to fix this one yet....<br></blockquote><div>Thanks for the explanation=
.</div><div>It clears up some questions I had.</div><div>=C2=A0</div><block=
quote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc=
 solid;padding-left:1ex">

<div class=3D""><br>
&gt; Let me know if there is any other info I can capture that would be<br>
&gt; interesting.<br>
<br>
</div>I know what the problem is now, so testing a fix will be the next<br>
step. But I need to think about how to fix this, and that can wait<br>
till Monday. ;)<br></blockquote><div>Just an fyi next week is busy for me w=
ith some other stuff so I</div><div>won&#39;t be able to try out a fix unti=
l the following week.</div><div>=C2=A0</div><blockquote class=3D"gmail_quot=
e" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">

<br>
Thanks for following up with the trace information, Bob!<br></blockquote><d=
iv>Not a problem.</div><div><br></div><div>Thanks,</div><div>Bob</div><div>=
=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;bo=
rder-left:1px #ccc solid;padding-left:1ex">

<div class=3D"HOEnZb"><div class=3D"h5"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</div></div></blockquote></div><br></div></div>

--001a113a9c10b0837604f8743ddd--


--===============3618801214531413474==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3618801214531413474==--
