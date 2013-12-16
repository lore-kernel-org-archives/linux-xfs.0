Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C8D887F3F
	for <xfs@oss.sgi.com>; Sun, 15 Dec 2013 18:34:45 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B11E08F804B
	for <xfs@oss.sgi.com>; Sun, 15 Dec 2013 16:34:45 -0800 (PST)
Received: from mail-vb0-f47.google.com (mail-vb0-f47.google.com
	[209.85.212.47]) by cuda.sgi.com with ESMTP id rssgEoTWRjH9HhdX
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 15 Dec 2013 16:34:44 -0800 (PST)
Received: by mail-vb0-f47.google.com with SMTP id q12so2708940vbe.34
	for <xfs@oss.sgi.com>; Sun, 15 Dec 2013 16:34:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131216000141.GU31386@dastard>
References: <CAG97raf61XGnTakrYjcfv9cjM6CTVdEEB3wQK+wOBvpowWO3Cw@mail.gmail.com>
	<20131216000141.GU31386@dastard>
Date: Sun, 15 Dec 2013 22:34:43 -0200
Message-ID: <CAG97radg3xd8-G2qChh2BOfH8R6N4kWH3qn3ivukxrkFVrt=rA@mail.gmail.com>
Subject: Re: XFS_REPAIR on LVM partition
From: Rafael Weingartner <rafaelweingartner@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2683456300053906741=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============2683456300053906741==
Content-Type: multipart/alternative; boundary=001a11333c2264e93c04ed9bfa51

--001a11333c2264e93c04ed9bfa51
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

So, sadly I went for the big hammer option, I thought that there were no
other options ;).

I'm guessing it can't find or validate the primary superblock, so
> it's looking for a secondary superblock. Please post the output of
> the running repair so we can see exactly what it is doing.


That is exactly what it seems that it is happening.

*dmesg erros:*

>  81.927888] Pid: 878, comm: mount Not tainted 3.5.0-44-generic
> #67~precise1-Ubuntu
> [   81.927891] Call Trace:
> [   81.927941]  [<ffffffffa01d460f>] xfs_error_report+0x3f/0x50 [xfs]
> [   81.927972]  [<ffffffffa01ecd66>] ? xfs_free_extent+0xe6/0x130 [xfs]
> [   81.927990]  [<ffffffffa01ea318>] xfs_free_ag_extent+0x528/0x730 [xfs]
> [   81.928007]  [<ffffffffa01e8e07>] ? kmem_zone_alloc+0x67/0xe0 [xfs]
> [   81.928033]  [<ffffffffa01ecd66>] xfs_free_extent+0xe6/0x130 [xfs]
> [   81.928055]  [<ffffffffa021bb10>] xlog_recover_process_efi+0x170/0x1b0
> [xfs]
> [   81.928075]  [<ffffffffa021cd56>]
> xlog_recover_process_efis.isra.8+0x76/0xd0 [xfs]
> [   81.928097]  [<ffffffffa0220a17>] xlog_recover_finish+0x27/0xd0 [xfs]
> [   81.928119]  [<ffffffffa022812c>] xfs_log_mount_finish+0x2c/0x30 [xfs]
> [   81.928140]  [<ffffffffa0223620>] xfs_mountfs+0x420/0x6b0 [xfs]
> [   81.928156]  [<ffffffffa01e2ffd>] xfs_fs_fill_super+0x21d/0x2b0 [xfs]
> [   81.928163]  [<ffffffff8118b716>] mount_bdev+0x1c6/0x210
> [   81.928179]  [<ffffffffa01e2de0>] ? xfs_parseargs+0xb80/0xb80 [xfs]
> [   81.928194]  [<ffffffffa01e10a5>] xfs_fs_mount+0x15/0x20 [xfs]
> [   81.928198]  [<ffffffff8118c563>] mount_fs+0x43/0x1b0
> [   81.928202]  [<ffffffff811a5ee3>] ? find_filesystem+0x63/0x80
> [   81.928206]  [<ffffffff811a7246>] vfs_kern_mount+0x76/0x120
> [   81.928209]  [<ffffffff811a7c34>] do_kern_mount+0x54/0x110
> [   81.928212]  [<ffffffff811a9934>] do_mount+0x1a4/0x260
> [   81.928215]  [<ffffffff811a9e10>] sys_mount+0x90/0xe0
> [   81.928220]  [<ffffffff816a7729>] system_call_fastpath+0x16/0x1b
> [   81.928229] XFS (dm-0): Failed to recover EFIs
> [   81.928232] XFS (dm-0): log mount finish failed
> [   81.972741] XFS (dm-1): Mounting Filesystem
> [   82.195661] XFS (dm-1): Ending clean mount
> [   82.203627] XFS (dm-2): Mounting Filesystem
> [   82.479044] XFS (dm-2): Ending clean mount



Actually, the problem was a little bit more complicated. This LVM2
partition, was using a physical device (PV) that is exported by a RAID NAS
controller. This volume exported by the controller was created using a RAID
5, there was a hardware failure in one of the HDs of the array and the
volume got unavailable, till we replaced the bad driver with a new one and
the array rebuild finished.

That's an old version of xfsprogs - you might want to start by
> upgrading it to 3.11...
>
So, a good try should be upgrading to xfsprogs 3.11 and running xfs_repair
again.


2013/12/15 Dave Chinner <david@fromorbit.com>

> On Sun, Dec 15, 2013 at 08:47:30PM -0200, Rafael Weingartner wrote:
> > Hi folks,
> > I am having some troubles with a XFS over one LVM partition. After an
> > unexpected reboot, I am getting the following message when I try to mou=
nt
> > it:
> > *mount: Structure needs cleaning*
>
> And the error in dmesg is?
>
> > I tried "sudo xfs_check /dev/mapper/volume". Sadly, I got the message:
> > xfs_check: cannot init perag data (117)
>
> xfs_check is deprecated, please use "xfs_repair -n" instead.
>
> > *ERROR: The filesystem has valuable metadata changes in a log which nee=
ds
> > to*
> > *be replayed.  Mount the filesystem to replay the log, and unmount it
> > before*
> > *re-running xfs_check.  If you are unable to mount the filesystem, then
> use*
> > *the xfs_repair -L option to destroy the log and attempt a repair.*
> > *Note that destroying the log may cause corruption -- please attempt a
> > mount*
> > *of the filesystem before doing this*
> >
> > So, I tried:
> > xfs_repair -L
>
> Ok, so you went immediately for the big hammer. There's the
> possibility that might not be able to recover your filesystem from
> whatever went wrong now that the log has been zeroed.
>
> > The command is running for over 3 hours and still just dots on my
> screen, I
> > have no idea of what is happening. Any ideas how I can get it to work
> > again? Or at least some work around that would enable me to extract the
> > data that it contains.
>
> I'm guessing it can't find or validate the primary superblock, so
> it's looking for a secondary superblock. Please post the output of
> the running repair so we can see exactly what it is doing.
>
> Also we need more information about your problem - why did the
> machine reboot? what's your storage configuration? You hardware,
> etc.
>
>
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_whe=
n_reporting_a_problem.3F
>
> > The server is a Ubuntu server 12.04.
> > The XFS version is: xfs_info version 3.1.7
> > If you need I can provide you with more info.
>
> That's an old version of xfsprogs - you might want to start by
> upgrading it to 3.11...
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>



--=20
Rafael Weing=E4rtner

--001a11333c2264e93c04ed9bfa51
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>So, sadly I went for the big hammer option, I thought=
 that there were no other options ;).=A0</div><div><br></div><blockquote cl=
ass=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px=
;border-left-color:rgb(204,204,204);border-left-style:solid;padding-left:1e=
x">
<span style=3D"color:rgb(0,0,0);font-family:arial,sans-serif;font-size:13px=
">I&#39;m guessing it can&#39;t find or validate the primary superblock, so=
</span><br style=3D"color:rgb(0,0,0);font-family:arial,sans-serif;font-size=
:13px">
<span style=3D"color:rgb(0,0,0);font-family:arial,sans-serif;font-size:13px=
">it&#39;s looking for a secondary superblock. Please post the output of</s=
pan><br style=3D"color:rgb(0,0,0);font-family:arial,sans-serif;font-size:13=
px">
<span style=3D"color:rgb(0,0,0);font-family:arial,sans-serif;font-size:13px=
">the running repair so we can see exactly what it is doing.</span></blockq=
uote><div><br></div><div>That is exactly what it seems that it is happening=
.</div>
<div>=A0</div><b>dmesg erros:</b><div><blockquote class=3D"gmail_quote" sty=
le=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(=
204,204,204);border-left-style:solid;padding-left:1ex">=A081.927888] Pid: 8=
78, comm: mount Not tainted 3.5.0-44-generic #67~precise1-Ubuntu<br>
[ =A0 81.927891] Call Trace:<br>[ =A0 81.927941] =A0[&lt;ffffffffa01d460f&g=
t;] xfs_error_report+0x3f/0x50 [xfs]<br>[ =A0 81.927972] =A0[&lt;ffffffffa0=
1ecd66&gt;] ? xfs_free_extent+0xe6/0x130 [xfs]<br>[ =A0 81.927990] =A0[&lt;=
ffffffffa01ea318&gt;] xfs_free_ag_extent+0x528/0x730 [xfs]<br>
[ =A0 81.928007] =A0[&lt;ffffffffa01e8e07&gt;] ? kmem_zone_alloc+0x67/0xe0 =
[xfs]<br>[ =A0 81.928033] =A0[&lt;ffffffffa01ecd66&gt;] xfs_free_extent+0xe=
6/0x130 [xfs]<br>[ =A0 81.928055] =A0[&lt;ffffffffa021bb10&gt;] xlog_recove=
r_process_efi+0x170/0x1b0 [xfs]<br>
[ =A0 81.928075] =A0[&lt;ffffffffa021cd56&gt;] xlog_recover_process_efis.is=
ra.8+0x76/0xd0 [xfs]<br>[ =A0 81.928097] =A0[&lt;ffffffffa0220a17&gt;] xlog=
_recover_finish+0x27/0xd0 [xfs]<br>[ =A0 81.928119] =A0[&lt;ffffffffa022812=
c&gt;] xfs_log_mount_finish+0x2c/0x30 [xfs]<br>
[ =A0 81.928140] =A0[&lt;ffffffffa0223620&gt;] xfs_mountfs+0x420/0x6b0 [xfs=
]<br>[ =A0 81.928156] =A0[&lt;ffffffffa01e2ffd&gt;] xfs_fs_fill_super+0x21d=
/0x2b0 [xfs]<br>[ =A0 81.928163] =A0[&lt;ffffffff8118b716&gt;] mount_bdev+0=
x1c6/0x210<br>
[ =A0 81.928179] =A0[&lt;ffffffffa01e2de0&gt;] ? xfs_parseargs+0xb80/0xb80 =
[xfs]<br>[ =A0 81.928194] =A0[&lt;ffffffffa01e10a5&gt;] xfs_fs_mount+0x15/0=
x20 [xfs]<br>[ =A0 81.928198] =A0[&lt;ffffffff8118c563&gt;] mount_fs+0x43/0=
x1b0<br>
[ =A0 81.928202] =A0[&lt;ffffffff811a5ee3&gt;] ? find_filesystem+0x63/0x80<=
br>[ =A0 81.928206] =A0[&lt;ffffffff811a7246&gt;] vfs_kern_mount+0x76/0x120=
<br>[ =A0 81.928209] =A0[&lt;ffffffff811a7c34&gt;] do_kern_mount+0x54/0x110=
<br>[ =A0 81.928212] =A0[&lt;ffffffff811a9934&gt;] do_mount+0x1a4/0x260<br>
[ =A0 81.928215] =A0[&lt;ffffffff811a9e10&gt;] sys_mount+0x90/0xe0<br>[ =A0=
 81.928220] =A0[&lt;ffffffff816a7729&gt;] system_call_fastpath+0x16/0x1b<br=
>[ =A0 81.928229] XFS (dm-0): Failed to recover EFIs<br>[ =A0 81.928232] XF=
S (dm-0): log mount finish failed<br>
[ =A0 81.972741] XFS (dm-1): Mounting Filesystem<br>[ =A0 82.195661] XFS (d=
m-1): Ending clean mount<br>[ =A0 82.203627] XFS (dm-2): Mounting Filesyste=
m<br>[ =A0 82.479044] XFS (dm-2): Ending clean mount</blockquote></div><div=
><br>
</div><div><br></div><div><span style=3D"color:rgb(0,0,0);font-family:Verda=
na,Arial,Helvetica,sans-serif;font-size:14px;line-height:20.15625px">Actual=
ly, the problem was a little bit more complicated. This LVM2 partition, was=
 using a physical device (PV) that is exported by a RAID NAS controller. Th=
is volume exported by the controller was created using a RAID 5, there was =
a hardware failure in one of the HDs of the array and the volume got unavai=
lable, till</span><span style=3D"color:rgb(0,0,0);font-family:Verdana,Arial=
,Helvetica,sans-serif;font-size:14px;line-height:20.15625px">=A0we replaced=
 the bad driver with a new one and the array rebuild finished.</span><br>
</div><div><span style=3D"color:rgb(0,0,0);font-family:Verdana,Arial,Helvet=
ica,sans-serif;font-size:14px;line-height:20.15625px"><br></span></div><blo=
ckquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left=
-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;paddi=
ng-left:1ex">
<span style=3D"color:rgb(0,0,0);font-family:arial,sans-serif;font-size:13px=
">That&#39;s an old version of xfsprogs - you might want to start by</span>=
<br style=3D"color:rgb(0,0,0);font-family:arial,sans-serif;font-size:13px">
<span style=3D"color:rgb(0,0,0);font-family:arial,sans-serif;font-size:13px=
">upgrading it to 3.11...</span><span style=3D"color:rgb(0,0,0);font-family=
:Verdana,Arial,Helvetica,sans-serif;font-size:14px;line-height:20.15625px">=
<br>
</span></blockquote><div><span style=3D"color:rgb(0,0,0);font-family:Verdan=
a,Arial,Helvetica,sans-serif;font-size:14px;line-height:20.15625px">So, a g=
ood try should be upgrading to xfsprogs 3.11 and running xfs_repair again.<=
/span></div>
</div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">2013/12=
/15 Dave Chinner <span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.co=
m" target=3D"_blank">david@fromorbit.com</a>&gt;</span><br><blockquote clas=
s=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;pad=
ding-left:1ex">
<div class=3D"im">On Sun, Dec 15, 2013 at 08:47:30PM -0200, Rafael Weingart=
ner wrote:<br>
&gt; Hi folks,<br>
&gt; I am having some troubles with a XFS over one LVM partition. After an<=
br>
&gt; unexpected reboot, I am getting the following message when I try to mo=
unt<br>
&gt; it:<br>
</div>&gt; *mount: Structure needs cleaning*<br>
<br>
And the error in dmesg is?<br>
<div class=3D"im"><br>
&gt; I tried &quot;sudo xfs_check /dev/mapper/volume&quot;. Sadly, I got th=
e message:<br>
&gt; xfs_check: cannot init perag data (117)<br>
<br>
</div>xfs_check is deprecated, please use &quot;xfs_repair -n&quot; instead=
.<br>
<br>
&gt; *ERROR: The filesystem has valuable metadata changes in a log which ne=
eds<br>
&gt; to*<br>
&gt; *be replayed. =A0Mount the filesystem to replay the log, and unmount i=
t<br>
&gt; before*<br>
&gt; *re-running xfs_check. =A0If you are unable to mount the filesystem, t=
hen use*<br>
&gt; *the xfs_repair -L option to destroy the log and attempt a repair.*<br=
>
&gt; *Note that destroying the log may cause corruption -- please attempt a=
<br>
&gt; mount*<br>
&gt; *of the filesystem before doing this*<br>
<div class=3D"im">&gt;<br>
&gt; So, I tried:<br>
&gt; xfs_repair -L<br>
<br>
</div>Ok, so you went immediately for the big hammer. There&#39;s the<br>
possibility that might not be able to recover your filesystem from<br>
whatever went wrong now that the log has been zeroed.<br>
<div class=3D"im"><br>
&gt; The command is running for over 3 hours and still just dots on my scre=
en, I<br>
&gt; have no idea of what is happening. Any ideas how I can get it to work<=
br>
&gt; again? Or at least some work around that would enable me to extract th=
e<br>
&gt; data that it contains.<br>
<br>
</div>I&#39;m guessing it can&#39;t find or validate the primary superblock=
, so<br>
it&#39;s looking for a secondary superblock. Please post the output of<br>
the running repair so we can see exactly what it is doing.<br>
<br>
Also we need more information about your problem - why did the<br>
machine reboot? what&#39;s your storage configuration? You hardware,<br>
etc.<br>
<br>
<a href=3D"http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_in=
clude_when_reporting_a_problem.3F" target=3D"_blank">http://xfs.org/index.p=
hp/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F=
</a><br>

<div class=3D"im"><br>
&gt; The server is a Ubuntu server 12.04.<br>
&gt; The XFS version is: xfs_info version 3.1.7<br>
&gt; If you need I can provide you with more info.<br>
<br>
</div>That&#39;s an old version of xfsprogs - you might want to start by<br=
>
upgrading it to 3.11...<br>
<br>
Cheers,<br>
<br>
Dave.<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</font></span></blockquote></div><br><br clear=3D"all"><div><br></div>-- <b=
r><div dir=3D"ltr">Rafael Weing=E4rtner</div>
</div>

--001a11333c2264e93c04ed9bfa51--


--===============2683456300053906741==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2683456300053906741==--
