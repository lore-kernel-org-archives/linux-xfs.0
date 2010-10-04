Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o94Ml2PO114912 for <xfs@oss.sgi.com>; Mon, 4 Oct 2010 17:47:02 -0500
Received: from mail-ww0-f51.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6A005EBB3E5
	for <xfs@oss.sgi.com>; Mon,  4 Oct 2010 16:01:39 -0700 (PDT)
Received: from mail-ww0-f51.google.com (mail-ww0-f51.google.com
	[74.125.82.51]) by cuda.sgi.com with ESMTP id gsElGothZf1mcL63
	for <xfs@oss.sgi.com>; Mon, 04 Oct 2010 16:01:39 -0700 (PDT)
Received: by wwb28 with SMTP id 28so6147839wwb.32
	for <xfs@oss.sgi.com>; Mon, 04 Oct 2010 15:48:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CA9DBAF.4080101@sandeen.net>
References: <AANLkTinH93VekNiAEbJbp43xnG2QPgnr+70nvC771ifG@mail.gmail.com>
	<20101004071613.GG4681@dastard> <4CA9DBAF.4080101@sandeen.net>
Date: Mon, 4 Oct 2010 22:48:03 +0000
Message-ID: <AANLkTinP-rjyny-9ww8gOh+_=oey-9xMU=z=rduBACjA@mail.gmail.com>
Subject: Re: xfs_repair never finishes on lvm partition
From: Knowledge Seeker <knoseeker@googlemail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4717462050923022826=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

--===============4717462050923022826==
Content-Type: multipart/alternative; boundary=0016e649c868411e3a0491d25642

--0016e649c868411e3a0491d25642
Content-Type: text/plain; charset=UTF-8

Thanks for the help.

The good news is running -P option works and the FS is ok.
The Bad news is that names of files were lost, all the files were moved to
lost+find.
Is there any easy way to recover it, or the solution is the hard way?

Sorry about the xfs_metadump, I ran the xfs_repair, before read all
messages.
If it happens again (I hope it doesnt), the first thing I'll do is send it.

Thank you again.






On Mon, Oct 4, 2010 at 1:50 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

> Dave Chinner wrote:
> > On Mon, Oct 04, 2010 at 02:57:42AM +0000, Knowledge Seeker wrote:
> >> Extra information:
> >> The versions:
> >> # xfs_repair -V
> >> xfs_repair version 2.9.8
> >
> > upgrade to a more recent version - that is positively ancient ;)
> >
> > Then if it still freezes in pahse 6, run with the -P option to turn
> > off prefetching (slower, but should prevent the hang).
>
> And before that, if you'd like to preserve something for us to
> look at, run
>
> # xfs_metadump /dev/blah imagefile
>
> to capture the state of the fs which was causing problems.
>
> -Eric
>
> > Cheers,
> >
> > Dave.
>
>


-- 
Knoseeker

--0016e649c868411e3a0491d25642
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Thanks for the help.<br><br>The good news is running -P option works and th=
e FS is ok.<br>The Bad news is that names of files were lost, all the files=
 were moved to lost+find.<br>Is there any easy way to recover it, or the so=
lution is the hard way?<br>
<br>Sorry about the xfs_metadump, I ran the xfs_repair, before read all mes=
sages.<br>If it happens again (I hope it doesnt), the first thing I&#39;ll =
do is send it.<br><br>Thank you again.<br><br><br><br><br><br><br><div clas=
s=3D"gmail_quote">
On Mon, Oct 4, 2010 at 1:50 PM, Eric Sandeen <span dir=3D"ltr">&lt;<a href=
=3D"mailto:sandeen@sandeen.net">sandeen@sandeen.net</a>&gt;</span> wrote:<b=
r><blockquote class=3D"gmail_quote" style=3D"margin: 0pt 0pt 0pt 0.8ex; bor=
der-left: 1px solid rgb(204, 204, 204); padding-left: 1ex;">
<div class=3D"im">Dave Chinner wrote:<br>
&gt; On Mon, Oct 04, 2010 at 02:57:42AM +0000, Knowledge Seeker wrote:<br>
&gt;&gt; Extra information:<br>
&gt;&gt; The versions:<br>
&gt;&gt; # xfs_repair -V<br>
&gt;&gt; xfs_repair version 2.9.8<br>
&gt;<br>
&gt; upgrade to a more recent version - that is positively ancient ;)<br>
&gt;<br>
&gt; Then if it still freezes in pahse 6, run with the -P option to turn<br=
>
&gt; off prefetching (slower, but should prevent the hang).<br>
<br>
</div>And before that, if you&#39;d like to preserve something for us to<br=
>
look at, run<br>
<br>
# xfs_metadump /dev/blah imagefile<br>
<br>
to capture the state of the fs which was causing problems.<br>
<br>
-Eric<br>
<br>
&gt; Cheers,<br>
&gt;<br>
&gt; Dave.<br>
<br>
</blockquote></div><br><br clear=3D"all"><br>-- <br>Knoseeker<br>

--0016e649c868411e3a0491d25642--


--===============4717462050923022826==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4717462050923022826==--
