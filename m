Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C42A67F3F
	for <xfs@oss.sgi.com>; Mon, 16 Dec 2013 02:52:32 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A2E36304066
	for <xfs@oss.sgi.com>; Mon, 16 Dec 2013 00:52:29 -0800 (PST)
Received: from mail-vb0-f51.google.com (mail-vb0-f51.google.com
	[209.85.212.51]) by cuda.sgi.com with ESMTP id Qr7G0KMPbY9bZxAW
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 16 Dec 2013 00:52:23 -0800 (PST)
Received: by mail-vb0-f51.google.com with SMTP id 11so2935160vbe.38
	for <xfs@oss.sgi.com>; Mon, 16 Dec 2013 00:52:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131216030537.GX31386@dastard>
References: <CAG97raf61XGnTakrYjcfv9cjM6CTVdEEB3wQK+wOBvpowWO3Cw@mail.gmail.com>
	<20131216000141.GU31386@dastard>
	<CAG97radg3xd8-G2qChh2BOfH8R6N4kWH3qn3ivukxrkFVrt=rA@mail.gmail.com>
	<20131216030537.GX31386@dastard>
Date: Mon, 16 Dec 2013 06:52:23 -0200
Message-ID: <CAG97racd-UhUqhVLcsbjqZt51iTEaHKaQNMkvQFnznH8X8wOUQ@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============0395365831097598020=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============0395365831097598020==
Content-Type: multipart/alternative; boundary=047d7bdc192c2f215104eda2ee7d

--047d7bdc192c2f215104eda2ee7d
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

What's a "RAID NAS controller"? Details, please, or we can't help
> you.


Maybe I am not expressing my self clearly. That is what I meant:
http://www.starline.de/produkte/raid-systeme/infortrend-raid-systeme/eonsto=
r/es-a08u-g2421/

It is a piece of hardware that we use to apply RAIDx (normally 1 or 5) over
physical disks instead of plugging them on the storage server and applying
RAID via software or something else. It exports the volumes using an SCSI
channel.  The devices are seen on the server as normal sd*, as if they were
normal physical devices.

So, hardware RAID5, lost a drive, rebuild on replace, filesystem in
> a bad way after rebuild?


That is exactly what happened, the RAID5 array lost a drive, and after we
replaced and rebuild it, the filesystem was not mounting anymore.
Teorically, this should not affect the filesystem since the RAID5 would
have recovered any lost information.



2013/12/16 Dave Chinner <david@fromorbit.com>

> On Sun, Dec 15, 2013 at 10:34:43PM -0200, Rafael Weingartner wrote:
> > So, sadly I went for the big hammer option, I thought that there were n=
o
> > other options ;).
> >
> > I'm guessing it can't find or validate the primary superblock, so
> > > it's looking for a secondary superblock. Please post the output of
> > > the running repair so we can see exactly what it is doing.
> >
> > That is exactly what it seems that it is happening.
> >
> > *dmesg erros:*
> >
> > >  81.927888] Pid: 878, comm: mount Not tainted 3.5.0-44-generic
> > > #67~precise1-Ubuntu
> > > [   81.927891] Call Trace:
> > > [   81.927941]  [<ffffffffa01d460f>] xfs_error_report+0x3f/0x50 [xfs]
> > > [   81.927972]  [<ffffffffa01ecd66>] ? xfs_free_extent+0xe6/0x130 [xf=
s]
> > > [   81.927990]  [<ffffffffa01ea318>] xfs_free_ag_extent+0x528/0x730
> [xfs]
> > > [   81.928007]  [<ffffffffa01e8e07>] ? kmem_zone_alloc+0x67/0xe0 [xfs=
]
> > > [   81.928033]  [<ffffffffa01ecd66>] xfs_free_extent+0xe6/0x130 [xfs]
> > > [   81.928055]  [<ffffffffa021bb10>]
> xlog_recover_process_efi+0x170/0x1b0
> > > [xfs]
> > > [   81.928075]  [<ffffffffa021cd56>]
> > > xlog_recover_process_efis.isra.8+0x76/0xd0 [xfs]
> > > [   81.928097]  [<ffffffffa0220a17>] xlog_recover_finish+0x27/0xd0
> [xfs]
> > > [   81.928119]  [<ffffffffa022812c>] xfs_log_mount_finish+0x2c/0x30
> [xfs]
> > > [   81.928140]  [<ffffffffa0223620>] xfs_mountfs+0x420/0x6b0 [xfs]
> > > [   81.928156]  [<ffffffffa01e2ffd>] xfs_fs_fill_super+0x21d/0x2b0
> [xfs]
> > > [   81.928163]  [<ffffffff8118b716>] mount_bdev+0x1c6/0x210
> > > [   81.928179]  [<ffffffffa01e2de0>] ? xfs_parseargs+0xb80/0xb80 [xfs=
]
> > > [   81.928194]  [<ffffffffa01e10a5>] xfs_fs_mount+0x15/0x20 [xfs]
> > > [   81.928198]  [<ffffffff8118c563>] mount_fs+0x43/0x1b0
> > > [   81.928202]  [<ffffffff811a5ee3>] ? find_filesystem+0x63/0x80
> > > [   81.928206]  [<ffffffff811a7246>] vfs_kern_mount+0x76/0x120
> > > [   81.928209]  [<ffffffff811a7c34>] do_kern_mount+0x54/0x110
> > > [   81.928212]  [<ffffffff811a9934>] do_mount+0x1a4/0x260
> > > [   81.928215]  [<ffffffff811a9e10>] sys_mount+0x90/0xe0
> > > [   81.928220]  [<ffffffff816a7729>] system_call_fastpath+0x16/0x1b
> > > [   81.928229] XFS (dm-0): Failed to recover EFIs
> > > [   81.928232] XFS (dm-0): log mount finish failed
> > > [   81.972741] XFS (dm-1): Mounting Filesystem
> > > [   82.195661] XFS (dm-1): Ending clean mount
> > > [   82.203627] XFS (dm-2): Mounting Filesystem
> > > [   82.479044] XFS (dm-2): Ending clean mount
> >
> > Actually, the problem was a little bit more complicated. This LVM2
> > partition, was using a physical device (PV) that is exported by a RAID
> NAS
> > controller.
>
> What's a "RAID NAS controller"? Details, please, or we can't help
> you.
>
> > This volume exported by the controller was created using a RAID
> > 5, there was a hardware failure in one of the HDs of the array and the
> > volume got unavailable, till we replaced the bad driver with a new one
> and
> > the array rebuild finished.
>
> So, hardware RAID5, lost a drive, rebuild on replace, filesystem in
> a bad way after rebuild?
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

--047d7bdc192c2f215104eda2ee7d
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><blockquote><blockquote class=3D"gmail_quote" style=3D"mar=
gin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,2=
04);border-left-style:solid;padding-left:1ex"></blockquote></blockquote><bl=
ockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-lef=
t-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;padd=
ing-left:1ex">

<span style=3D"font-size:13px;font-family:arial,sans-serif">What&#39;s a &q=
uot;RAID NAS controller&quot;? Details, please, or we can&#39;t help<br></s=
pan><span style=3D"font-size:13px;font-family:arial,sans-serif">you.</span>=
</blockquote>

<div><br></div><div>Maybe I am not expressing my self clearly. That is what=
 I meant: <br><a href=3D"http://www.starline.de/produkte/raid-systeme/infor=
trend-raid-systeme/eonstor/es-a08u-g2421/" target=3D"_blank">http://www.sta=
rline.de/produkte/raid-systeme/infortrend-raid-systeme/eonstor/es-a08u-g242=
1/</a><br>

<br><span style=3D"color:rgb(0,0,0);font-family:Verdana,Arial,Helvetica,san=
s-serif;font-size:14px;line-height:20.15625px">It is a piece of hardware th=
at we use to apply RAIDx (normally 1 or=A0</span><span style=3D"color:rgb(0=
,0,0);font-family:Verdana,Arial,Helvetica,sans-serif;font-size:14px;line-he=
ight:20.15625px">5) over physical disks instead of plugging=A0them on the s=
torage server and applying RAID via software or something else. It exports =
the volumes using=A0an SCSI channel. =A0The devices are seen on the server =
as normal sd*, as if they were normal physical devices.</span><br>
</div>
<div><br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0p=
x 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border-lef=
t-style:solid;padding-left:1ex"><span style=3D"color:rgb(0,0,0);font-family=
:arial,sans-serif;font-size:13px">So, hardware RAID5, lost a drive, rebuild=
 on replace, filesystem in</span><br style=3D"color:rgb(0,0,0);font-family:=
arial,sans-serif;font-size:13px">
<span style=3D"color:rgb(0,0,0);font-family:arial,sans-serif;font-size:13px=
">a bad way after rebuild?</span></blockquote><div>=A0</div><div><span styl=
e=3D"color:rgb(0,0,0);font-family:Verdana,Arial,Helvetica,sans-serif;font-s=
ize:14px;line-height:20.15625px">That is exactly what happened, the RAID5 a=
rray=A0lost a drive, and after we replaced and rebuild it, the filesystem w=
as not mounting anymore. Teorically, this should not affect the filesystem =
since the RAID5 would have recovered any lost information.=A0</span><br>
</div><div><br></div></div><div class=3D"gmail_extra"><br><br><div class=3D=
"gmail_quote">2013/12/16 Dave Chinner <span dir=3D"ltr">&lt;<a href=3D"mail=
to:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>&gt;</span=
><br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-le=
ft:1px #ccc solid;padding-left:1ex">
<div class=3D"im">On Sun, Dec 15, 2013 at 10:34:43PM -0200, Rafael Weingart=
ner wrote:<br>
&gt; So, sadly I went for the big hammer option, I thought that there were =
no<br>
&gt; other options ;).<br>
&gt;<br>
&gt; I&#39;m guessing it can&#39;t find or validate the primary superblock,=
 so<br>
&gt; &gt; it&#39;s looking for a secondary superblock. Please post the outp=
ut of<br>
&gt; &gt; the running repair so we can see exactly what it is doing.<br>
&gt;<br>
&gt; That is exactly what it seems that it is happening.<br>
&gt;<br>
</div>&gt; *dmesg erros:*<br>
<div><div class=3D"h5">&gt;<br>
&gt; &gt; =A081.927888] Pid: 878, comm: mount Not tainted 3.5.0-44-generic<=
br>
&gt; &gt; #67~precise1-Ubuntu<br>
&gt; &gt; [ =A0 81.927891] Call Trace:<br>
&gt; &gt; [ =A0 81.927941] =A0[&lt;ffffffffa01d460f&gt;] xfs_error_report+0=
x3f/0x50 [xfs]<br>
&gt; &gt; [ =A0 81.927972] =A0[&lt;ffffffffa01ecd66&gt;] ? xfs_free_extent+=
0xe6/0x130 [xfs]<br>
&gt; &gt; [ =A0 81.927990] =A0[&lt;ffffffffa01ea318&gt;] xfs_free_ag_extent=
+0x528/0x730 [xfs]<br>
&gt; &gt; [ =A0 81.928007] =A0[&lt;ffffffffa01e8e07&gt;] ? kmem_zone_alloc+=
0x67/0xe0 [xfs]<br>
&gt; &gt; [ =A0 81.928033] =A0[&lt;ffffffffa01ecd66&gt;] xfs_free_extent+0x=
e6/0x130 [xfs]<br>
&gt; &gt; [ =A0 81.928055] =A0[&lt;ffffffffa021bb10&gt;] xlog_recover_proce=
ss_efi+0x170/0x1b0<br>
&gt; &gt; [xfs]<br>
&gt; &gt; [ =A0 81.928075] =A0[&lt;ffffffffa021cd56&gt;]<br>
&gt; &gt; xlog_recover_process_efis.isra.8+0x76/0xd0 [xfs]<br>
&gt; &gt; [ =A0 81.928097] =A0[&lt;ffffffffa0220a17&gt;] xlog_recover_finis=
h+0x27/0xd0 [xfs]<br>
&gt; &gt; [ =A0 81.928119] =A0[&lt;ffffffffa022812c&gt;] xfs_log_mount_fini=
sh+0x2c/0x30 [xfs]<br>
&gt; &gt; [ =A0 81.928140] =A0[&lt;ffffffffa0223620&gt;] xfs_mountfs+0x420/=
0x6b0 [xfs]<br>
&gt; &gt; [ =A0 81.928156] =A0[&lt;ffffffffa01e2ffd&gt;] xfs_fs_fill_super+=
0x21d/0x2b0 [xfs]<br>
&gt; &gt; [ =A0 81.928163] =A0[&lt;ffffffff8118b716&gt;] mount_bdev+0x1c6/0=
x210<br>
&gt; &gt; [ =A0 81.928179] =A0[&lt;ffffffffa01e2de0&gt;] ? xfs_parseargs+0x=
b80/0xb80 [xfs]<br>
&gt; &gt; [ =A0 81.928194] =A0[&lt;ffffffffa01e10a5&gt;] xfs_fs_mount+0x15/=
0x20 [xfs]<br>
&gt; &gt; [ =A0 81.928198] =A0[&lt;ffffffff8118c563&gt;] mount_fs+0x43/0x1b=
0<br>
&gt; &gt; [ =A0 81.928202] =A0[&lt;ffffffff811a5ee3&gt;] ? find_filesystem+=
0x63/0x80<br>
&gt; &gt; [ =A0 81.928206] =A0[&lt;ffffffff811a7246&gt;] vfs_kern_mount+0x7=
6/0x120<br>
&gt; &gt; [ =A0 81.928209] =A0[&lt;ffffffff811a7c34&gt;] do_kern_mount+0x54=
/0x110<br>
&gt; &gt; [ =A0 81.928212] =A0[&lt;ffffffff811a9934&gt;] do_mount+0x1a4/0x2=
60<br>
&gt; &gt; [ =A0 81.928215] =A0[&lt;ffffffff811a9e10&gt;] sys_mount+0x90/0xe=
0<br>
&gt; &gt; [ =A0 81.928220] =A0[&lt;ffffffff816a7729&gt;] system_call_fastpa=
th+0x16/0x1b<br>
&gt; &gt; [ =A0 81.928229] XFS (dm-0): Failed to recover EFIs<br>
&gt; &gt; [ =A0 81.928232] XFS (dm-0): log mount finish failed<br>
&gt; &gt; [ =A0 81.972741] XFS (dm-1): Mounting Filesystem<br>
&gt; &gt; [ =A0 82.195661] XFS (dm-1): Ending clean mount<br>
&gt; &gt; [ =A0 82.203627] XFS (dm-2): Mounting Filesystem<br>
&gt; &gt; [ =A0 82.479044] XFS (dm-2): Ending clean mount<br>
&gt;<br>
&gt; Actually, the problem was a little bit more complicated. This LVM2<br>
&gt; partition, was using a physical device (PV) that is exported by a RAID=
 NAS<br>
&gt; controller.<br>
<br>
</div></div>What&#39;s a &quot;RAID NAS controller&quot;? Details, please, =
or we can&#39;t help<br>
you.<br>
<div class=3D"im"><br>
&gt; This volume exported by the controller was created using a RAID<br>
&gt; 5, there was a hardware failure in one of the HDs of the array and the=
<br>
&gt; volume got unavailable, till we replaced the bad driver with a new one=
 and<br>
&gt; the array rebuild finished.<br>
<br>
</div>So, hardware RAID5, lost a drive, rebuild on replace, filesystem in<b=
r>
a bad way after rebuild?<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</div></div></blockquote></div><br><br clear=3D"all"><div><br></div>-- <br>=
<div dir=3D"ltr">Rafael Weing=E4rtner</div>
</div>

--047d7bdc192c2f215104eda2ee7d--


--===============0395365831097598020==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0395365831097598020==--
