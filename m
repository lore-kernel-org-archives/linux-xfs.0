Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 24BA57FBD
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 14:34:49 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C619FAC005
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 12:34:45 -0800 (PST)
Received: from mail-gw2.its.unimelb.edu.au (mail-gw2.its.unimelb.edu.au
	[128.250.5.151]) by cuda.sgi.com with ESMTP id 6nNx6ub91IAStIqT
	for <xfs@oss.sgi.com>; Tue, 06 Jan 2015 12:34:41 -0800 (PST)
Received: from mail-ig0-f182.google.com (mail-ig0-f182.google.com
	[209.85.213.182]) (Authenticated sender: draffelt)
	by mail-gw2.its.unimelb.edu.au (Postfix) with ESMTPSA id 9CBF5E20
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 07:34:39 +1100 (EST)
Received: by mail-ig0-f182.google.com with SMTP id hn15so220957igb.9
	for <xfs@oss.sgi.com>; Tue, 06 Jan 2015 12:34:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <44b127de199c445fa12c3b832a05f108@000s-ex-hub-qs1.unimelb.edu.au>
References: <CAOFq7B5PaPCJdAxyYa6feCXgGbkz+1Qs+Gfb2WG=5af=A+WOQg@mail.gmail.com>
	<44b127de199c445fa12c3b832a05f108@000s-ex-hub-qs1.unimelb.edu.au>
Date: Wed, 7 Jan 2015 07:34:37 +1100
Message-ID: <CAOFq7B5HnEZFtVvoRORRwOxPhx5Txf9xJW=BG6GFbLMNk+_CEw@mail.gmail.com>
Subject: Re: XFS corrupt after RAID failure and resync
From: David Raffelt <david.raffelt@florey.edu.au>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5323289261418760608=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>, stefanrin@gmail.com
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============5323289261418760608==
Content-Type: multipart/alternative; boundary=001a113ed274503dc7050c01bc67

--001a113ed274503dc7050c01bc67
Content-Type: text/plain; charset=UTF-8

Hi Brian and Stefan,
Thanks for your reply.  I checked the status of the array after the rebuild
(and before the reset).

md0 : active raid6 sdd1[8] sdc1[4] sda1[3] sdb1[7] sdi1[5] sde1[1]
      14650667520 blocks super 1.2 level 6, 512k chunk, algorithm 2 [7/6]
[UUUUUU_]

However given that I've never had any problems before with mdadm rebuilds I
did not think to check the data before rebooting.  Note that the array is
still in this state. Before the reboot I tried to run a smartctl check on
the failed drives and it could not read them. When I rebooted I did not
actually replace any drives, I just power cycled to see if I could
re-access the drives that were thrown out of the array. According to
smartctl they are completely fine.

I guess there is no way I can re-add the old drives and remove the newly
synced drive?  Even though I immediately kicked all users off the system
when I got the mdadm alert, it's possible a small amount of data was
written to the array during the resync.

It looks like the filesystem was not unmounted properly before reboot:
Jan 06 09:11:54 server systemd[1]: Failed unmounting /export/data.
Jan 06 09:11:54 server systemd[1]: Shutting down.

Here is the mount errors in the log after rebooting:
Jan 06 09:15:17 server kernel: XFS (md0): Mounting Filesystem
Jan 06 09:15:17 server kernel: XFS (md0): Corruption detected. Unmount and
run xfs_repair
Jan 06 09:15:17 server kernel: XFS (md0): Corruption detected. Unmount and
run xfs_repair
Jan 06 09:15:17 server kernel: XFS (md0): Corruption detected. Unmount and
run xfs_repair
Jan 06 09:15:17 server kernel: XFS (md0): metadata I/O error: block 0x400
("xfs_trans_read_buf_map") error 117 numblks 16
Jan 06 09:15:17 server kernel: XFS (md0): xfs_imap_to_bp:
xfs_trans_read_buf() returned error 117.
Jan 06 09:15:17 server kernel: XFS (md0): failed to read root inode

xfs_repair -n -L also complains about a bad magic number.

Unfortunately this 15TB RAID was part of a 45TB GlusterFS distributed
volume. It was only ever meant to be a scratch drive for intermediate
scientific results, however inevitably most users used it to store lots of
data. Oh well.

Thanks again,
Dave












On 6 January 2015 at 23:47, Brian Foster <bfoster@redhat.com> wrote:

> On Tue, Jan 06, 2015 at 05:12:14PM +1100, David Raffelt wrote:
> > Hi again,
> > Some more information.... the kernel log show the following errors were
> > occurring after the RAID recovery, but before I reset the server.
> >
>
> By after the raid recovery, you mean after the two drives had failed out
> and 1 hot spare was activated and resync completed? It certainly seems
> like something went wrong in this process. The output below looks like
> it's failing to read in some inodes. Is there any stack trace output
> that accompanies these error messages to confirm?
>
> I suppose I would try to verify that the array configuration looks sane,
> but after the hot spare resync and then one or two other drive
> replacements (was the hot spare ultimately replaced?), it's hard to say
> whether it might be recoverable.
>
> Brian
>
> > Jan 06 00:00:27 server kernel: XFS (md0): Corruption detected. Unmount
> and
> > run xfs_repair
> > Jan 06 00:00:27 server kernel: XFS (md0): Corruption detected. Unmount
> and
> > run xfs_repair
> > Jan 06 00:00:27 server kernel: XFS (md0): Corruption detected. Unmount
> and
> > run xfs_repair
> > Jan 06 00:00:27 server kernel: XFS (md0): metadata I/O error: block
> > 0x36b106c00 ("xfs_trans_read_buf_map") error 117 numblks 16
> > Jan 06 00:00:27 server kernel: XFS (md0): xfs_imap_to_bp:
> > xfs_trans_read_buf() returned error 117.
> >
> >
> > Thanks,
> > Dave
>
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
>
>


-- 
*David Raffelt (PhD)*
Postdoctoral Fellow

The Florey Institute of Neuroscience and Mental Health
Melbourne Brain Centre - Austin Campus
245 Burgundy Street
Heidelberg Vic 3084
Ph: +61 3 9035 7024
www.florey.edu.au

--001a113ed274503dc7050c01bc67
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Brian and Stefan,<div>Thanks for your reply.=C2=A0 I ch=
ecked the status of the array after the rebuild (and before the reset).=C2=
=A0</div><div><br></div><div><div>md0 : active raid6 sdd1[8] sdc1[4] sda1[3=
] sdb1[7] sdi1[5] sde1[1]</div><div>=C2=A0 =C2=A0 =C2=A0 14650667520 blocks=
 super 1.2 level 6, 512k chunk, algorithm 2 [7/6] [UUUUUU_]</div><div>=C2=
=A0 =C2=A0 =C2=A0=C2=A0</div><div>However given that I&#39;ve never had any=
 problems before with mdadm rebuilds I did not think to check the data befo=
re rebooting.=C2=A0 Note that the array is still in this state. Before the =
reboot I tried to run a smartctl check on the failed drives and it could no=
t read them. When I rebooted I did not actually replace any drives, I just =
power cycled to see if I could re-access the drives that were thrown out of=
 the array. According to smartctl they are completely fine.=C2=A0</div><div=
><br></div><div>I guess there is no way I can re-add the old drives and rem=
ove the newly synced drive?=C2=A0 Even though I immediately kicked all user=
s off the system when I got the mdadm alert, it&#39;s possible a small amou=
nt of data was written to the array during the resync.=C2=A0</div><div><br>=
</div><div>It looks like the filesystem was not unmounted properly before r=
eboot:<br></div></div><div>Jan 06 09:11:54=C2=A0server=C2=A0systemd[1]: Fai=
led unmounting /export/data.<br></div><div>Jan 06 09:11:54=C2=A0server=C2=
=A0systemd[1]: Shutting down.<br></div><div><br></div><div>Here is the moun=
t errors in the log after rebooting:</div><div>Jan 06 09:15:17 server kerne=
l: XFS (md0): Mounting Filesystem<br></div><div>Jan 06 09:15:17=C2=A0server=
=C2=A0kernel: XFS (md0): Corruption detected. Unmount and run xfs_repair<br=
></div><div>Jan 06 09:15:17=C2=A0server=C2=A0kernel: XFS (md0): Corruption =
detected. Unmount and run xfs_repair<br></div><div><div>Jan 06 09:15:17=C2=
=A0server=C2=A0kernel: XFS (md0): Corruption detected. Unmount and run xfs_=
repair</div></div><div>Jan 06 09:15:17=C2=A0server=C2=A0kernel: XFS (md0): =
metadata I/O error: block 0x400 (&quot;xfs_trans_read_buf_map&quot;) error =
117 numblks 16<br></div><div>Jan 06 09:15:17=C2=A0server=C2=A0kernel: XFS (=
md0): xfs_imap_to_bp: xfs_trans_read_buf() returned error 117.<br></div><di=
v><div>Jan 06 09:15:17=C2=A0server=C2=A0kernel: XFS (md0): failed to read r=
oot inode</div><div><br></div><div>xfs_repair -n -L also complains about a =
bad magic number.=C2=A0<br></div><div><br></div><div>Unfortunately this 15T=
B RAID was part of a 45TB GlusterFS distributed volume. It was only ever me=
ant to be a scratch drive for intermediate scientific results, however inev=
itably most users used it to store lots of data. Oh well.=C2=A0</div><div><=
br></div><div>Thanks again,</div><div>Dave</div><div><br></div><div><br></d=
iv></div><div><br></div><div><br></div><div><br></div><div><div><br></div><=
div><br></div></div><div><br></div><div><br></div><div><br></div><div><br><=
/div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On 6 J=
anuary 2015 at 23:47, Brian Foster <span dir=3D"ltr">&lt;<a href=3D"mailto:=
bfoster@redhat.com" target=3D"_blank">bfoster@redhat.com</a>&gt;</span> wro=
te:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-=
left:1px #ccc solid;padding-left:1ex"><span class=3D"">On Tue, Jan 06, 2015=
 at 05:12:14PM +1100, David Raffelt wrote:<br>
&gt; Hi again,<br>
&gt; Some more information.... the kernel log show the following errors wer=
e<br>
&gt; occurring after the RAID recovery, but before I reset the server.<br>
&gt;<br>
<br>
</span>By after the raid recovery, you mean after the two drives had failed=
 out<br>
and 1 hot spare was activated and resync completed? It certainly seems<br>
like something went wrong in this process. The output below looks like<br>
it&#39;s failing to read in some inodes. Is there any stack trace output<br=
>
that accompanies these error messages to confirm?<br>
<br>
I suppose I would try to verify that the array configuration looks sane,<br=
>
but after the hot spare resync and then one or two other drive<br>
replacements (was the hot spare ultimately replaced?), it&#39;s hard to say=
<br>
whether it might be recoverable.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
Brian<br>
</font></span><span class=3D"im HOEnZb"><br>
&gt; Jan 06 00:00:27 server kernel: XFS (md0): Corruption detected. Unmount=
 and<br>
&gt; run xfs_repair<br>
&gt; Jan 06 00:00:27 server kernel: XFS (md0): Corruption detected. Unmount=
 and<br>
&gt; run xfs_repair<br>
&gt; Jan 06 00:00:27 server kernel: XFS (md0): Corruption detected. Unmount=
 and<br>
&gt; run xfs_repair<br>
&gt; Jan 06 00:00:27 server kernel: XFS (md0): metadata I/O error: block<br=
>
&gt; 0x36b106c00 (&quot;xfs_trans_read_buf_map&quot;) error 117 numblks 16<=
br>
&gt; Jan 06 00:00:27 server kernel: XFS (md0): xfs_imap_to_bp:<br>
&gt; xfs_trans_read_buf() returned error 117.<br>
&gt;<br>
&gt;<br>
&gt; Thanks,<br>
&gt; Dave<br>
<br>
</span><div class=3D"HOEnZb"><div class=3D"h5">&gt; _______________________=
________________________<br>
&gt; xfs mailing list<br>
&gt; <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
&gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">=
http://oss.sgi.com/mailman/listinfo/xfs</a><br>
<br>
</div></div></blockquote></div><br><br clear=3D"all"><div><br></div>-- <br>=
<div class=3D"gmail_signature"><div dir=3D"ltr"><div><b><font color=3D"#ff6=
600">David Raffelt (PhD)</font></b></div><div><font color=3D"#ff6600">Postd=
octoral Fellow</font></div><div><br></div><div>The Florey Institute of Neur=
oscience and Mental Health</div><div>Melbourne Brain Centre - Austin Campus=
</div><div>245 Burgundy Street</div><div>Heidelberg Vic 3084<div>Ph:=C2=A0<=
a value=3D"+61390357024">+61 3 9035 7024</a></div></div><div><a value=3D"+6=
1390357024">www.florey.edu.au</a></div></div></div>
</div>

--001a113ed274503dc7050c01bc67--


--===============5323289261418760608==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5323289261418760608==--
