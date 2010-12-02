Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB247aI5251339 for <xfs@oss.sgi.com>; Wed, 1 Dec 2010 22:07:36 -0600
Received: from mail-qy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BE4C21B9F2F
	for <xfs@oss.sgi.com>; Wed,  1 Dec 2010 20:09:19 -0800 (PST)
Received: from mail-qy0-f181.google.com (mail-qy0-f181.google.com
	[209.85.216.181]) by cuda.sgi.com with ESMTP id
	mntLUYW32B51YOtZ for <xfs@oss.sgi.com>;
	Wed, 01 Dec 2010 20:09:19 -0800 (PST)
Received: by qyk12 with SMTP id 12so8736908qyk.5
	for <xfs@oss.sgi.com>; Wed, 01 Dec 2010 20:09:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CF71907.60803@sandeen.net>
References: <AANLkTikzCpQ1j9uWGSTY9TEguVDvAB5AVYtbDtdePFci@mail.gmail.com>
	<4CF661C7.2020103@sandeen.net>
	<AANLkTimiST8VNVsV49mniKLBudSxFj+O883Mwwe7ucac@mail.gmail.com>
	<4CF71907.60803@sandeen.net>
Date: Thu, 2 Dec 2010 09:39:18 +0530
Message-ID: <AANLkTimczc9a1K0vDLqG=RzFVjD7HayfhfAtQqDUjG3o@mail.gmail.com>
Subject: Re: XFS file system corruption(Return Bad Transaction) kernel - 2.6.34
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0852547195605046885=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen-xfs@sandeen.net, xfs@oss.sgi.com

--===============0852547195605046885==
Content-Type: multipart/alternative; boundary=0015175caa80f7fa6804966595a2

--0015175caa80f7fa6804966595a2
Content-Type: text/plain; charset=ISO-8859-1

yes, thats the only approach at the moment which can help. I am doubting the
changes related with the disk commit, but I am not sure.

Thanks,
Amit Sahrawat

On Thu, Dec 2, 2010 at 9:26 AM, Eric Sandeen <sandeen@sandeen.net> wrote:

> On 12/1/10 9:40 PM, Amit Sahrawat wrote:
> > While the copy operation is in progress, simply unplug the usb device and
> then replug.
>
> that's not a simple copy operation either ;)
>
> > The issue can be seen from XFS (2.6.31) onwards, I am trying to figure
> out the changes between 2.6.30.9 and 2.6.31.
>
> If you have a regression, perhaps you can do:
>
> # git bisect start v2.6.31 v2.6.30 fs/xfs
>
> and methodically test the changes in between.
>
> -Eric
>
> > One thing I noticed is - there is difference in speed for 2 versions - in
> case of 2.6.30.9 if I remove the USB within '5' seconds - I can see the file
> being created at the destination and some data written, while in case of
> 2.6.31(onwards), it takes around 20 seconds to get some data to disk.
> > I am using MIPS at the moment with VIPT(fixes included)
> >
> > Please let me know if this information is useful.
> >
> > Thanks,
> > Amit Sahrawat
>  > On Wed, Dec 1, 2010 at 8:25 PM, Eric Sandeen <sandeen@sandeen.net<mailto:
> sandeen@sandeen.net>> wrote:
> >
> >     On 12/1/10 1:14 AM, Amit Sahrawat wrote:
> >     > Dear Member,
> >     >
> >     > I am getting following corruption on XFS formatted disk during a
> simple copy operation:
> >     > sd 9:0:0:0: Attached scsi removable disk sdc
> >     > sd 9:0:0:0: Attached scsi generic sg2 type 0
> >     > XFS mounting filesystem sdc2
> >     > Starting XFS recovery on filesystem: sdc2 (logdev: internal)
> >     > XFS: xlog_recover_process_data: bad transaction
> >     > XFS: log mount/recovery failed: error 5
> >     > XFS: log mount failed
> >
> >     hm, that's not a simple copy operation, that is a mount failing;
> >     your log appears to be corrupted.
> >
> >     offhand I'm going to blame it on having a write cache enabled
> >     on your drive, and having barriers either off, or not working
> >     properly.
> >
> >     -Eric
> >
> >
>
>

--0015175caa80f7fa6804966595a2
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>yes, thats the only approach at the moment which can help. I am doubti=
ng the changes related with the disk commit, but I=A0am not sure.</div>
<div>=A0</div>
<div>Thanks,</div>
<div>Amit Sahrawat<br><br></div>
<div class=3D"gmail_quote">On Thu, Dec 2, 2010 at 9:26 AM, Eric Sandeen <sp=
an dir=3D"ltr">&lt;<a href=3D"mailto:sandeen@sandeen.net">sandeen@sandeen.n=
et</a>&gt;</span> wrote:<br>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div class=3D"im">On 12/1/10 9:40 PM, Amit Sahrawat wrote:<br>&gt; While th=
e copy operation is in progress, simply unplug the usb device and then repl=
ug.<br><br></div>that&#39;s not a simple copy operation either ;)<br>
<div class=3D"im"><br>&gt; The issue can be seen from XFS (2.6.31) onwards,=
 I am trying to figure out the changes between 2.6.30.9 and 2.6.31.<br><br>=
</div>If you have a regression, perhaps you can do:<br><br># git bisect sta=
rt v2.6.31 v2.6.30 fs/xfs<br>
<br>and methodically test the changes in between.<br><font color=3D"#888888=
"><br>-Eric<br></font>
<div class=3D"im"><br>&gt; One thing I noticed is - there is difference in =
speed for 2 versions - in case of 2.6.30.9 if I remove the USB within &#39;=
5&#39; seconds - I can see the file being created at the destination and so=
me data written, while in case of 2.6.31(onwards), it takes around 20 secon=
ds to get some data to disk.<br>
&gt; I am using MIPS at the moment with VIPT(fixes included)<br>&gt;<br>&gt=
; Please let me know if this information is useful.<br>&gt;<br>&gt; Thanks,=
<br>&gt; Amit Sahrawat<br></div>
<div>
<div></div>
<div class=3D"h5">&gt; On Wed, Dec 1, 2010 at 8:25 PM, Eric Sandeen &lt;<a =
href=3D"mailto:sandeen@sandeen.net">sandeen@sandeen.net</a> &lt;mailto:<a h=
ref=3D"mailto:sandeen@sandeen.net">sandeen@sandeen.net</a>&gt;&gt; wrote:<b=
r>
&gt;<br>&gt; =A0 =A0 On 12/1/10 1:14 AM, Amit Sahrawat wrote:<br>&gt; =A0 =
=A0 &gt; Dear Member,<br>&gt; =A0 =A0 &gt;<br>&gt; =A0 =A0 &gt; I am gettin=
g following corruption on XFS formatted disk during a simple copy operation=
:<br>&gt; =A0 =A0 &gt; sd 9:0:0:0: Attached scsi removable disk sdc<br>
&gt; =A0 =A0 &gt; sd 9:0:0:0: Attached scsi generic sg2 type 0<br>&gt; =A0 =
=A0 &gt; XFS mounting filesystem sdc2<br>&gt; =A0 =A0 &gt; Starting XFS rec=
overy on filesystem: sdc2 (logdev: internal)<br>&gt; =A0 =A0 &gt; XFS: xlog=
_recover_process_data: bad transaction<br>
&gt; =A0 =A0 &gt; XFS: log mount/recovery failed: error 5<br>&gt; =A0 =A0 &=
gt; XFS: log mount failed<br>&gt;<br>&gt; =A0 =A0 hm, that&#39;s not a simp=
le copy operation, that is a mount failing;<br>&gt; =A0 =A0 your log appear=
s to be corrupted.<br>
&gt;<br>&gt; =A0 =A0 offhand I&#39;m going to blame it on having a write ca=
che enabled<br>&gt; =A0 =A0 on your drive, and having barriers either off, =
or not working<br>&gt; =A0 =A0 properly.<br>&gt;<br>&gt; =A0 =A0 -Eric<br>&=
gt;<br>&gt;<br>
<br></div></div></blockquote></div><br>

--0015175caa80f7fa6804966595a2--


--===============0852547195605046885==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0852547195605046885==--
