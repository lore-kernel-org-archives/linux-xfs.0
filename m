Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 675407F54
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 13:32:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0935CAC001
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 11:32:20 -0700 (PDT)
Received: from mail-qa0-f52.google.com (mail-qa0-f52.google.com
	[209.85.216.52]) by cuda.sgi.com with ESMTP id XypfC9Eqijj6Grrj
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 02 Jun 2014 11:32:18 -0700 (PDT)
Received: by mail-qa0-f52.google.com with SMTP id cm18so3255288qab.25
	for <xfs@oss.sgi.com>; Mon, 02 Jun 2014 11:32:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140601224825.GP14410@dastard>
References: <CAA43vkVzWRTqNQh2VSi5yvFLtstmVOKRJUnYw_ZSkYJGsex8Uw@mail.gmail.com>
	<20140531000117.GM6677@dastard>
	<CAA43vkUBF3q-F6XYTPTVx43KXg_3_COgaK8wtHxRynshOT9smg@mail.gmail.com>
	<20140601224825.GP14410@dastard>
Date: Mon, 2 Jun 2014 14:32:17 -0400
Message-ID: <CAA43vkVpkd+9O+oAi33iX+CJeBOxc9z7J0owVeqFnYouhK7C2w@mail.gmail.com>
Subject: Re: What to do when... xfs_repair hangs?
From: Sean Caron <scaron@umich.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6445945233515242499=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, Sean Caron <scaron@umich.edu>
Cc: xfs@oss.sgi.com

--===============6445945233515242499==
Content-Type: multipart/alternative; boundary=001a11395d847047cc04fade9dd6

--001a11395d847047cc04fade9dd6
Content-Type: text/plain; charset=UTF-8

I tried re-running the version that came with Ubuntu 12.04 LTS and it very
consistently segfaults at that point... so I went and pulled a copy of the
most recent source from Git and I'm trying xfs_repair 3.2.0 now. I'll see
how that goes (it'll probably take a day or two to run; 450 TB volume) and
report back. Thanks everyone for the suggestions and feedback so far.

Best,

Sean


On Sun, Jun 1, 2014 at 6:48 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Sun, Jun 01, 2014 at 12:21:55PM -0400, Sean Caron wrote:
> > Sorry, all, I was a little out-of-it on Friday afternoon, of course I had
> > kicked off xfs_repair actually in the background with all output sent to
> a
> > file, and I was just doing 'tail -f' on that file.
> >
> > So I kill the 'tail -f' and jump back to the command line, it appears
> that
> > xfs_repair segfaulted and died.
> >
> > That line of text:
> >
> > disconnected inode 1109099673,
> >
> > was indeed the last thing that it printed before it crashed.
> >
> > If I look in dmesg, I just see -
> >
> > xfs_repair[6770]: segfault at 28 ip 000000000042307b sp 00007fffef61bad0
> > error 4 in xfs_repair[400000+72000]
> >
> > and that's it.
> >
> > I checked with 'df' and there's plenty of space everywhere; I don't see
> why
> > it would have faulted out trying to connect something to lost+found.
> >
> > Underlying storage should be good; this is basically a RAID 60 built on
> top
> > of a bunch of JBODs with LSI SAS9200 cards. MD sees all strings as
> started
> > and running OK; no problems getting the array assembled at all.
> >
> > Since Dave is saying it's OK to try re-running xfs_repair; it'll just
> pick
> > up where it left off; let me give it another pass and see if it manages
> to
> > complete, or if it segfaults out again. I guess it it poops out a second
> > time, maybe we'll just want to consider rebuilding the filesystem and
> > restoring from our copies?
>
> You should update to the latest version of xfs_repair first (3.2.0).
> If that still crashes, running xfs-repair under gdb to get a stack
> trace would be a good start, or sending me a metadump image so I can
> reproduce the crash myself would be even better...
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--001a11395d847047cc04fade9dd6
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I tried re-running the version that came with Ubuntu 12.04=
 LTS and it very consistently segfaults at that point... so I went and pull=
ed a copy of the most recent source from Git and I&#39;m trying xfs_repair =
3.2.0 now. I&#39;ll see how that goes (it&#39;ll probably take a day or two=
 to run; 450 TB volume) and report back. Thanks everyone for the suggestion=
s and feedback so far.<div>
<br></div><div>Best,</div><div><br></div><div>Sean</div></div><div class=3D=
"gmail_extra"><br><br><div class=3D"gmail_quote">On Sun, Jun 1, 2014 at 6:4=
8 PM, Dave Chinner <span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.=
com" target=3D"_blank">david@fromorbit.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"">On Sun, Jun 01, 2014 at 12:2=
1:55PM -0400, Sean Caron wrote:<br>
&gt; Sorry, all, I was a little out-of-it on Friday afternoon, of course I =
had<br>
&gt; kicked off xfs_repair actually in the background with all output sent =
to a<br>
&gt; file, and I was just doing &#39;tail -f&#39; on that file.<br>
&gt;<br>
&gt; So I kill the &#39;tail -f&#39; and jump back to the command line, it =
appears that<br>
&gt; xfs_repair segfaulted and died.<br>
&gt;<br>
&gt; That line of text:<br>
&gt;<br>
&gt; disconnected inode 1109099673,<br>
&gt;<br>
&gt; was indeed the last thing that it printed before it crashed.<br>
&gt;<br>
&gt; If I look in dmesg, I just see -<br>
&gt;<br>
&gt; xfs_repair[6770]: segfault at 28 ip 000000000042307b sp 00007fffef61ba=
d0<br>
&gt; error 4 in xfs_repair[400000+72000]<br>
&gt;<br>
&gt; and that&#39;s it.<br>
&gt;<br>
&gt; I checked with &#39;df&#39; and there&#39;s plenty of space everywhere=
; I don&#39;t see why<br>
&gt; it would have faulted out trying to connect something to lost+found.<b=
r>
&gt;<br>
&gt; Underlying storage should be good; this is basically a RAID 60 built o=
n top<br>
&gt; of a bunch of JBODs with LSI SAS9200 cards. MD sees all strings as sta=
rted<br>
&gt; and running OK; no problems getting the array assembled at all.<br>
&gt;<br>
&gt; Since Dave is saying it&#39;s OK to try re-running xfs_repair; it&#39;=
ll just pick<br>
&gt; up where it left off; let me give it another pass and see if it manage=
s to<br>
&gt; complete, or if it segfaults out again. I guess it it poops out a seco=
nd<br>
&gt; time, maybe we&#39;ll just want to consider rebuilding the filesystem =
and<br>
&gt; restoring from our copies?<br>
<br>
</div>You should update to the latest version of xfs_repair first (3.2.0).<=
br>
If that still crashes, running xfs-repair under gdb to get a stack<br>
trace would be a good start, or sending me a metadump image so I can<br>
reproduce the crash myself would be even better...<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</div></div></blockquote></div><br></div>

--001a11395d847047cc04fade9dd6--


--===============6445945233515242499==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6445945233515242499==--
