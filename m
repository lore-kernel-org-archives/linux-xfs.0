Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3DGYZix120022 for <xfs@oss.sgi.com>; Mon, 13 Apr 2009 11:34:45 -0500
Received: from mail-ew0-f158.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B1C4920DF81
	for <xfs@oss.sgi.com>; Mon, 13 Apr 2009 09:33:56 -0700 (PDT)
Received: from mail-ew0-f158.google.com (mail-ew0-f158.google.com
	[209.85.219.158]) by cuda.sgi.com with ESMTP id
	L4qav8Wf9f6CdMHo for <xfs@oss.sgi.com>;
	Mon, 13 Apr 2009 09:33:56 -0700 (PDT)
Received: by ewy2 with SMTP id 2so2596952ewy.20
	for <xfs@oss.sgi.com>; Mon, 13 Apr 2009 09:33:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <dbd747120904130913p45c2979eu5afd15f5a6ca7b7f@mail.gmail.com>
References: <dbd747120904130713t7388971axf75ee779b5b1e1f2@mail.gmail.com>
	<49E353FD.5060207@sandeen.net>
	<dbd747120904130913p45c2979eu5afd15f5a6ca7b7f@mail.gmail.com>
Date: Mon, 13 Apr 2009 18:33:55 +0200
Message-ID: <dbd747120904130933i6ae66aedt7912a47b7e561f76@mail.gmail.com>
Subject: Fwd: xfs - fixing wrong xfs size
From: Nebojsa Trpkovic <trx.lists@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3953404933895321822=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3953404933895321822==
Content-Type: multipart/alternative; boundary=0015174bde84d709a9046772475a

--0015174bde84d709a9046772475a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On Mon, Apr 13, 2009 at 5:02 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

> Nebojsa Trpkovic wrote:
> > hello.
> >
> > I had problem with raid5 on my system.
> > after recovering of the array, I can not mount XFS that resides on it.
> > I've run xfs_check and xfs_repair (which fixed some errors) and now I
> > can run them all day long without any errors.
> >
> > but, when I try to mount that partition, I get:
> >
> > mount: /dev/md0: can't read superblock
> >
> >
> > and there's
> >
> > Filesystem "md0": Disabling barriers, not supported by the underlying
> device
> >
> > attempt to access beyond end of device
> > md0: rw=0, want=123024384, limit=123023488
> > I/O error in filesystem ("md0") meta-data dev md0 block 0x75533f8
>
>       ("xfs_read_buf") error 5 buf count 4096
> >
> > XFS: size check 2 failed
>
> So, the superblock says that the fs is 896 1k-blocks longer than the
> device actually is.
>
> > in the dmesg.
> >
> >
> > is there any way to "fix" this wrong size of XFS ?
>
> hard to say, almost certainly sounds like an md problem; is there a
> chance that your raid recovery led to a device which is somehow smaller
> than it started?  You could change the superblock block-count value, but
> I'm guessing that something else has gone wrong.
>
> It might be useful to know what errors xfs_repair found.
>
> -Eric
>


thx for quick reply.

yes, I definitely had md problem - my raid5 made of 6 drives connected to
ICH9R and 2 drives connected to the masterpeace of hardware called JMicron
fell apart when later one just stopped working out of nowhere. after reboot,
JMicron worked well, but raid was out of sync with 2 members failed. I've
zeroed superblocks of raid partitions and created new one with
"assume-clear". partition tables stayed intact - I had no need to change
anything in them. that worked fine with /dev/md1 wich had reiserfs: after
long and slow reiserfs --rebuild-tree I'm able to access all files on that
partition. unforutuately, I have no way to mount xfs partition although
xfs_check and xfs_repair give no errors (I had to run xfs_repair -L /dev/md0
to get in this error-free situation).

how can I set superblock block-count value (now I have realy nothing to
loose - the only other option is to give up of that data) ?

--0015174bde84d709a9046772475a
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div class=3D"gmail_quote"><div><div></div><div class=3D"h5"><div class=3D"=
gmail_quote">On Mon, Apr 13, 2009 at 5:02 PM, Eric Sandeen <span dir=3D"ltr=
">&lt;<a href=3D"mailto:sandeen@sandeen.net" target=3D"_blank">sandeen@sand=
een.net</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div>Nebojsa Trpkovic wrote:<br>
&gt; hello.<br>
&gt;<br>
&gt; I had problem with raid5 on my system.<br>
&gt; after recovering of the array, I can not mount XFS that resides on it.=
<br>
&gt; I&#39;ve run xfs_check and xfs_repair (which fixed some errors) and no=
w I<br>
&gt; can run them all day long without any errors.<br>
&gt;<br>
&gt; but, when I try to mount that partition, I get:<br>
&gt;<br>
&gt; mount: /dev/md0: can&#39;t read superblock<br>
&gt;<br>
&gt;<br>
&gt; and there&#39;s<br>
&gt;<br>
&gt; Filesystem &quot;md0&quot;: Disabling barriers, not supported by the u=
nderlying device<br>
&gt;<br>
&gt; attempt to access beyond end of device<br>
&gt; md0: rw=3D0, want=3D123024384, limit=3D123023488<br>
&gt; I/O error in filesystem (&quot;md0&quot;) meta-data dev md0 block 0x75=
533f8<br>
<br>
 =A0 =A0 =A0 (&quot;xfs_read_buf&quot;) error 5 buf count 4096<br>
&gt;<br>
&gt; XFS: size check 2 failed<br>
<br>
</div>So, the superblock says that the fs is 896 1k-blocks longer than the<=
br>
device actually is.<br>
<div><br>
&gt; in the dmesg.<br>
&gt;<br>
&gt;<br>
&gt; is there any way to &quot;fix&quot; this wrong size of XFS ?<br>
<br>
</div>hard to say, almost certainly sounds like an md problem; is there a<b=
r>
chance that your raid recovery led to a device which is somehow smaller<br>
than it started? =A0You could change the superblock block-count value, but<=
br>
I&#39;m guessing that something else has gone wrong.<br>
<br>
It might be useful to know what errors xfs_repair found.<br>
<font color=3D"#888888"><br>
-Eric<br>
</font></blockquote></div><br><br></div></div>thx for quick reply.<br><br>y=
es, I definitely had md problem - my raid5 made of 6 drives connected to IC=
H9R and 2 drives connected to the masterpeace of hardware called JMicron fe=
ll apart when later one just stopped working out of nowhere. after reboot, =
JMicron worked well, but raid was out of sync with 2 members failed. I&#39;=
ve zeroed superblocks of raid partitions and created new one with &quot;ass=
ume-clear&quot;. partition tables stayed intact - I had no need to change a=
nything in them. that worked fine with /dev/md1 wich had reiserfs: after lo=
ng and slow reiserfs --rebuild-tree I&#39;m able to access all files on tha=
t partition. unforutuately, I have no way to mount xfs partition although x=
fs_check and xfs_repair give no errors (I had to run xfs_repair -L /dev/md0=
 to get in this error-free situation). <br>

<br>how can I set superblock block-count value (now I have realy nothing to=
 loose - the only other option is to give up of that data) ?<br><br><br>
</div><br>

--0015174bde84d709a9046772475a--


--===============3953404933895321822==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3953404933895321822==--
