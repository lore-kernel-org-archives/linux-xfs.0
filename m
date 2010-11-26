Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAQ7rvEF133829 for <xfs@oss.sgi.com>; Fri, 26 Nov 2010 01:53:58 -0600
Received: from mail-qy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BFD541A83BF
	for <xfs@oss.sgi.com>; Thu, 25 Nov 2010 23:55:37 -0800 (PST)
Received: from mail-qy0-f181.google.com (mail-qy0-f181.google.com
	[209.85.216.181]) by cuda.sgi.com with ESMTP id
	eolzmX0gGcEthx3n for <xfs@oss.sgi.com>;
	Thu, 25 Nov 2010 23:55:37 -0800 (PST)
Received: by qyk12 with SMTP id 12so1946046qyk.5
	for <xfs@oss.sgi.com>; Thu, 25 Nov 2010 23:55:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101125095751.GC12187@dastard>
References: <AANLkTi=3BNqaUJGLuCOipQX_eP07QXa6dCBB-nUqmqG0@mail.gmail.com>
	<20101125095751.GC12187@dastard>
Date: Fri, 26 Nov 2010 13:25:36 +0530
Message-ID: <AANLkTimU=mGWwq-Hb0go7ObmN1snjmaoTUC9NSzOZjJ5@mail.gmail.com>
Subject: Re: XFS Direct IO, unaligned block zeroing at 128K boundery
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6380323445135325880=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============6380323445135325880==
Content-Type: multipart/alternative; boundary=0015175cd0fc3e1dd90495f00c6d

--0015175cd0fc3e1dd90495f00c6d
Content-Type: text/plain; charset=ISO-8859-1

Hello,
Its my fault,
Our kernel 2.6.30.9, however we migrated XFS to higher version 2.6.34

We undo the XFS changes from commit 5fe878ae7f82fbf0830dbfaee4c5ca18f3aee442
because our fs/direct_io.c belong to version 2.6.30.9, and we do not want to
change it.


On Thu, Nov 25, 2010 at 3:27 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Thu, Nov 25, 2010 at 12:23:11PM +0530, Ajeet Yadav wrote:
> > Dear all
> > I made a simple script that creates a 2MB file using directio write
> > operation,
> > The objective was to test with different buffer sizes from 4K-5K-6K..8K,
> the
> > buffer was filled with 5,
> > Than take hexdump of file to check data integrity.
>
> what kernel? Can you reproduce it on a mainline kernel? If so,
> can you apply the three patches in this thread:
>
> http://marc.info/?l=linux-fsdevel&m=128920213904443&w=2
>
> and see if that fixes the problem?
>
> Also, if you are writing new test scripts that demonstrate problems,
> it's handy to attach them to your bug reports, or better yet, send
> patches to add them to the xfstests suite....
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--0015175cd0fc3e1dd90495f00c6d
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Hello,</div>
<div>Its my fault,</div>
<div>Our kernel 2.6.30.9, however we migrated XFS to higher version 2.6.34<=
/div>
<div>=A0</div>
<div>We undo the XFS changes from commit 5fe878ae7f82fbf0830dbfaee4c5ca18f3=
aee442</div>
<div>because our fs/direct_io.c belong to version 2.6.30.9, and we do not w=
ant to change it.</div>
<div><br>=A0</div>
<div class=3D"gmail_quote">On Thu, Nov 25, 2010 at 3:27 PM, Dave Chinner <s=
pan dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com">david@fromorbit.=
com</a>&gt;</span> wrote:<br>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div class=3D"im">On Thu, Nov 25, 2010 at 12:23:11PM +0530, Ajeet Yadav wro=
te:<br>&gt; Dear all<br>&gt; I made a simple script that creates a 2MB file=
 using directio write<br>&gt; operation,<br>&gt; The objective was to test =
with different buffer sizes from 4K-5K-6K..8K, the<br>
&gt; buffer was filled with 5,<br>&gt; Than take hexdump of file to check d=
ata integrity.<br><br></div>what kernel? Can you reproduce it on a mainline=
 kernel? If so,<br>can you apply the three patches in this thread:<br><br>
<a href=3D"http://marc.info/?l=3Dlinux-fsdevel&amp;m=3D128920213904443&amp;=
w=3D2" target=3D"_blank">http://marc.info/?l=3Dlinux-fsdevel&amp;m=3D128920=
213904443&amp;w=3D2</a><br><br>and see if that fixes the problem?<br><br>Al=
so, if you are writing new test scripts that demonstrate problems,<br>
it&#39;s handy to attach them to your bug reports, or better yet, send<br>p=
atches to add them to the xfstests suite....<br><br>Cheers,<br><br>Dave.<br=
><font color=3D"#888888">--<br>Dave Chinner<br><a href=3D"mailto:david@from=
orbit.com">david@fromorbit.com</a><br>
</font></blockquote></div><br>

--0015175cd0fc3e1dd90495f00c6d--


--===============6380323445135325880==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6380323445135325880==--
