Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0K778To041889 for <xfs@oss.sgi.com>; Thu, 20 Jan 2011 01:07:09 -0600
Received: from mail-qw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 02A121BC3E8E
	for <xfs@oss.sgi.com>; Wed, 19 Jan 2011 23:09:27 -0800 (PST)
Received: from mail-qw0-f53.google.com (mail-qw0-f53.google.com
	[209.85.216.53]) by cuda.sgi.com with ESMTP id ors5fVOXuGh6PLQ3
	for <xfs@oss.sgi.com>; Wed, 19 Jan 2011 23:09:27 -0800 (PST)
Received: by qwe5 with SMTP id 5so280143qwe.26
	for <xfs@oss.sgi.com>; Wed, 19 Jan 2011 23:09:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110120064137.GS16267@dastard>
References: <AANLkTin22efc0cHSmM+2rNQpE2aJoobQCnMwbNUjw617@mail.gmail.com>
	<20110120051720.GR16267@dastard>
	<AANLkTik0KUQaRzLeBNR8M=u+ijO6gAZu601zyCp2zmDS@mail.gmail.com>
	<20110120064137.GS16267@dastard>
Date: Thu, 20 Jan 2011 12:39:26 +0530
Message-ID: <AANLkTimK2_bpMCYXjL1Vi+yP8Vt7_NckgwkLBoMYkwTw@mail.gmail.com>
Subject: Re: XFS - issues with writes using sync
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8815657980528637214=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============8815657980528637214==
Content-Type: multipart/alternative; boundary=0015175cf83c645603049a41d0ac

--0015175cf83c645603049a41d0ac
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Jan 20, 2011 at 12:11 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Thu, Jan 20, 2011 at 11:37:44AM +0530, Amit Sahrawat wrote:
> > Hi,
> >
> > I will try to find out the cause for this.
> > Meanwhile, just a small request/suggestion - in the past this type of
> > testcases have helped us in finding many problems in XFS.
> > Can something like this be added to xfstests? This might help.
>
> Definitely.  We're always looking for more people to add tests that
> expose problems to xfstests. :) We try to keep individual test
> runtime to as little as possible - under 5 minutes for the auto
> group, under 15s for the quick group, but by the looks of it the
> test you are running doesn't take that long to run.
>


> >> Yes, the test case we are using is not taking much time this time to
> cause issue - around 3-4 minutes.
>


> FWIW, there are already tests that cause worst case filesystem
> fragmentation as part of their test setup (e.g. test 042) but the
> coverage of such issues could definitely be improved. Also, the way
> we generate fragmented filesystems - by writing files and then
> removing a subset - could be greatly sped up by preallocation and
> hole punching. There's no need to write data when we could just use
> unwritten extents to do the same thing...
>
>


>  >> We basically fragment by doing following steps:
>
 Full the disk with same size files (in this case it is 16k)
Then, randomly remove files from the disk.
Doing so, allows us to create files as per our requirement - complete
control when we need - single extent, multiple extent files, Btree format
file, single leaf file, multiple leaf file - It allows us ease to use XFS.
I hope you are getting what I am trying to say.

But, in this case - it starts causing issue at the very first stage - just
copying 16k file to make disk full.

Thanks,
Amit Sahrawat

--0015175cf83c645603049a41d0ac
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><br>
<div class=3D"gmail_quote">On Thu, Jan 20, 2011 at 12:11 PM, Dave Chinner <=
span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com">david@fromorbit=
.com</a>&gt;</span> wrote:<br>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div class=3D"im">On Thu, Jan 20, 2011 at 11:37:44AM +0530, Amit Sahrawat w=
rote:<br>&gt; Hi,<br>&gt;<br></div>
<div class=3D"im">&gt; I will try to find out the cause for this.<br>&gt; M=
eanwhile, just a small request/suggestion - in the past this type of<br>&gt=
; testcases have helped us in finding many problems in XFS.<br>&gt; Can som=
ething like this be added to xfstests? This might help.<br>
<br></div>Definitely. =A0We&#39;re always looking for more people to add te=
sts that<br>expose problems to xfstests. :) We try to keep individual test<=
br>runtime to as little as possible - under 5 minutes for the auto<br>group=
, under 15s for the quick group, but by the looks of it the<br>
test you are running doesn&#39;t take that long to run.<br></blockquote>
<div>=A0</div>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">&gt;&gt; Yes, the test case we a=
re using is not taking much time this time to cause issue - around 3-4 minu=
tes.<br>
</blockquote>
<div>=A0</div>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">FWIW, there are already tests th=
at cause worst case filesystem<br>fragmentation as part of their test setup=
 (e.g. test 042) but the<br>
coverage of such issues could definitely be improved. Also, the way<br>we g=
enerate fragmented filesystems - by writing files and then<br>removing a su=
bset - could be greatly sped up by preallocation and<br>hole punching. Ther=
e&#39;s no need to write data when we could just use<br>
unwritten extents to do the same thing...<br>
<div>
<div></div>
<div class=3D"h5">=A0</div></div></blockquote>
<div>=A0</div>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div>
<div class=3D"h5">&gt;&gt; We basically fragment by doing following steps:<=
/div></div></blockquote>
<div>=A0Full the disk with same size files (in this case it is 16k)</div>
<div>Then, randomly remove files from the disk.</div>
<div>Doing so,=A0allows us to create files as per our requirement - complet=
e control when we need - single extent, multiple extent files, Btree format=
 file, single leaf file, multiple leaf file - It allows us ease to use XFS.=
</div>

<div>I hope you are getting what I am trying to say. </div>
<div>=A0</div>
<div>But, in this case - it starts causing issue at the very first stage - =
just copying 16k file to make disk full. </div>
<div>=A0</div>
<div>Thanks,</div>
<div>Amit Sahrawat</div>
<div>=A0</div></div>

--0015175cf83c645603049a41d0ac--


--===============8815657980528637214==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8815657980528637214==--
