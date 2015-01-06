Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4E1117FCC
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 17:47:26 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2CABA304032
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 15:47:26 -0800 (PST)
Received: from mail-gw1.its.unimelb.edu.au (mail-gw1.its.unimelb.edu.au
	[128.250.5.150]) by cuda.sgi.com with ESMTP id OK1KCSlVfQBgkJ6z
	for <xfs@oss.sgi.com>; Tue, 06 Jan 2015 15:47:04 -0800 (PST)
Received: from mail-ie0-f181.google.com (mail-ie0-f181.google.com
	[209.85.223.181]) (Authenticated sender: draffelt)
	by mail-gw1.its.unimelb.edu.au (Postfix) with ESMTPSA id C93832E54
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 10:47:02 +1100 (EST)
Received: by mail-ie0-f181.google.com with SMTP id rl12so815691iec.12
	for <xfs@oss.sgi.com>; Tue, 06 Jan 2015 15:47:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <8cc9a649ec2240faa4e38fd742437546@000S-EX-HUB-NP2.unimelb.edu.au>
References: <CAOFq7B5PaPCJdAxyYa6feCXgGbkz+1Qs+Gfb2WG=5af=A+WOQg@mail.gmail.com>
	<44b127de199c445fa12c3b832a05f108@000s-ex-hub-qs1.unimelb.edu.au>
	<CAOFq7B5HnEZFtVvoRORRwOxPhx5Txf9xJW=BG6GFbLMNk+_CEw@mail.gmail.com>
	<8cc9a649ec2240faa4e38fd742437546@000S-EX-HUB-NP2.unimelb.edu.au>
Date: Wed, 7 Jan 2015 10:47:00 +1100
Message-ID: <CAOFq7B6t8jrBBu81CuT2tqTyPEYROqkCJ4ChnxCtCvMGiGb7wg@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============0620809904886658332=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: "stefanrin@gmail.com" <stefanrin@gmail.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============0620809904886658332==
Content-Type: multipart/alternative; boundary=001a113ed2745d341c050c046cd2

--001a113ed2745d341c050c046cd2
Content-Type: text/plain; charset=UTF-8

Hi Brain,
Below is the root inode data. I'm currently running xfs_metadump and will
send you a link to the file.
Cheers!
David




xfs_db> sb
xfs_db> p rootino
rootino = 1024
xfs_db> inode 1024
xfs_db> p
core.magic = 0
core.mode = 0
core.version = 0
core.format = 0 (dev)
core.uid = 0
core.gid = 0
core.flushiter = 0
core.atime.sec = Thu Jan  1 10:00:00 1970
core.atime.nsec = 000000000
core.mtime.sec = Thu Jan  1 10:00:00 1970
core.mtime.nsec = 000000000
core.ctime.sec = Thu Jan  1 10:00:00 1970
core.ctime.nsec = 000000000
core.size = 0
core.nblocks = 0
core.extsize = 0
core.nextents = 0
core.naextents = 0
core.forkoff = 0
core.aformat = 0 (dev)
core.dmevmask = 0
core.dmstate = 0
core.newrtbm = 0
core.prealloc = 0
core.realtime = 0
core.immutable = 0
core.append = 0
core.sync = 0
core.noatime = 0
core.nodump = 0
core.rtinherit = 0
core.projinherit = 0
core.nosymlinks = 0
core.extsz = 0
core.extszinherit = 0
core.nodefrag = 0
core.filestream = 0
core.gen = 0
next_unlinked = 0
u.dev = 0


On 7 January 2015 at 10:16, Brian Foster <bfoster@redhat.com> wrote:

> On Wed, Jan 07, 2015 at 07:34:37AM +1100, David Raffelt wrote:
> > Hi Brian and Stefan,
> > Thanks for your reply.  I checked the status of the array after the
> rebuild
> > (and before the reset).
> >
> > md0 : active raid6 sdd1[8] sdc1[4] sda1[3] sdb1[7] sdi1[5] sde1[1]
> >       14650667520 blocks super 1.2 level 6, 512k chunk, algorithm 2 [7/6]
> > [UUUUUU_]
> >
> > However given that I've never had any problems before with mdadm
> rebuilds I
> > did not think to check the data before rebooting.  Note that the array is
> > still in this state. Before the reboot I tried to run a smartctl check on
> > the failed drives and it could not read them. When I rebooted I did not
> > actually replace any drives, I just power cycled to see if I could
> > re-access the drives that were thrown out of the array. According to
> > smartctl they are completely fine.
> >
> > I guess there is no way I can re-add the old drives and remove the newly
> > synced drive?  Even though I immediately kicked all users off the system
> > when I got the mdadm alert, it's possible a small amount of data was
> > written to the array during the resync.
> >
> > It looks like the filesystem was not unmounted properly before reboot:
> > Jan 06 09:11:54 server systemd[1]: Failed unmounting /export/data.
> > Jan 06 09:11:54 server systemd[1]: Shutting down.
> >
> > Here is the mount errors in the log after rebooting:
> > Jan 06 09:15:17 server kernel: XFS (md0): Mounting Filesystem
> > Jan 06 09:15:17 server kernel: XFS (md0): Corruption detected. Unmount
> and
> > run xfs_repair
> > Jan 06 09:15:17 server kernel: XFS (md0): Corruption detected. Unmount
> and
> > run xfs_repair
> > Jan 06 09:15:17 server kernel: XFS (md0): Corruption detected. Unmount
> and
> > run xfs_repair
> > Jan 06 09:15:17 server kernel: XFS (md0): metadata I/O error: block 0x400
> > ("xfs_trans_read_buf_map") error 117 numblks 16
> > Jan 06 09:15:17 server kernel: XFS (md0): xfs_imap_to_bp:
> > xfs_trans_read_buf() returned error 117.
> > Jan 06 09:15:17 server kernel: XFS (md0): failed to read root inode
> >
>
> So it fails to read the root inode. You could also try to read said
> inode via xfs_db (e.g., 'sb,' 'p rootino,' 'inode <ino#>,' 'p') and see
> what it shows.
>
> Are you able to run xfs_metadump against the fs? If so and you're
> willing/able to make the dump available somewhere (compressed), I'd be
> interested to take a look to see what might be causing the difference in
> behavior between repair and xfs_db.
>
> Brian
>
> > xfs_repair -n -L also complains about a bad magic number.
> >
> > Unfortunately this 15TB RAID was part of a 45TB GlusterFS distributed
> > volume. It was only ever meant to be a scratch drive for intermediate
> > scientific results, however inevitably most users used it to store lots
> of
> > data. Oh well.
> >
> > Thanks again,
> > Dave
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> > On 6 January 2015 at 23:47, Brian Foster <bfoster@redhat.com> wrote:
> >
> > > On Tue, Jan 06, 2015 at 05:12:14PM +1100, David Raffelt wrote:
> > > > Hi again,
> > > > Some more information.... the kernel log show the following errors
> were
> > > > occurring after the RAID recovery, but before I reset the server.
> > > >
> > >
> > > By after the raid recovery, you mean after the two drives had failed
> out
> > > and 1 hot spare was activated and resync completed? It certainly seems
> > > like something went wrong in this process. The output below looks like
> > > it's failing to read in some inodes. Is there any stack trace output
> > > that accompanies these error messages to confirm?
> > >
> > > I suppose I would try to verify that the array configuration looks
> sane,
> > > but after the hot spare resync and then one or two other drive
> > > replacements (was the hot spare ultimately replaced?), it's hard to say
> > > whether it might be recoverable.
> > >
> > > Brian
> > >
> > > > Jan 06 00:00:27 server kernel: XFS (md0): Corruption detected.
> Unmount
> > > and
> > > > run xfs_repair
> > > > Jan 06 00:00:27 server kernel: XFS (md0): Corruption detected.
> Unmount
> > > and
> > > > run xfs_repair
> > > > Jan 06 00:00:27 server kernel: XFS (md0): Corruption detected.
> Unmount
> > > and
> > > > run xfs_repair
> > > > Jan 06 00:00:27 server kernel: XFS (md0): metadata I/O error: block
> > > > 0x36b106c00 ("xfs_trans_read_buf_map") error 117 numblks 16
> > > > Jan 06 00:00:27 server kernel: XFS (md0): xfs_imap_to_bp:
> > > > xfs_trans_read_buf() returned error 117.
> > > >
> > > >
> > > > Thanks,
> > > > Dave
> > >
> > > > _______________________________________________
> > > > xfs mailing list
> > > > xfs@oss.sgi.com
> > > > http://oss.sgi.com/mailman/listinfo/xfs
> > >
> > >
> >
> >
> > --
> > *David Raffelt (PhD)*
> > Postdoctoral Fellow
> >
> > The Florey Institute of Neuroscience and Mental Health
> > Melbourne Brain Centre - Austin Campus
> > 245 Burgundy Street
> > Heidelberg Vic 3084
> > Ph: +61 3 9035 7024
> > www.florey.edu.au
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

--001a113ed2745d341c050c046cd2
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Brain,<div>Below is the root inode data. I&#39;m curren=
tly running xfs_metadump and will send you a link to the file.=C2=A0</div><=
div>Cheers!</div><div>David</div><div><br></div><div><br></div><div><br></d=
iv><div><br></div><div><div><div>xfs_db&gt; sb</div><div>xfs_db&gt; p rooti=
no</div><div>rootino =3D 1024</div><div>xfs_db&gt; inode 1024</div><div>xfs=
_db&gt; p</div><div>core.magic =3D 0</div><div>core.mode =3D 0</div><div>co=
re.version =3D 0</div><div>core.format =3D 0 (dev)</div><div>core.uid =3D 0=
</div><div>core.gid =3D 0</div><div>core.flushiter =3D 0</div><div>core.ati=
me.sec =3D Thu Jan =C2=A01 10:00:00 1970</div><div>core.atime.nsec =3D 0000=
00000</div><div>core.mtime.sec =3D Thu Jan =C2=A01 10:00:00 1970</div><div>=
core.mtime.nsec =3D 000000000</div><div>core.ctime.sec =3D Thu Jan =C2=A01 =
10:00:00 1970</div><div>core.ctime.nsec =3D 000000000</div><div>core.size =
=3D 0</div><div>core.nblocks =3D 0</div><div>core.extsize =3D 0</div><div>c=
ore.nextents =3D 0</div><div>core.naextents =3D 0</div><div>core.forkoff =
=3D 0</div><div>core.aformat =3D 0 (dev)</div><div>core.dmevmask =3D 0</div=
><div>core.dmstate =3D 0</div><div>core.newrtbm =3D 0</div><div>core.preall=
oc =3D 0</div><div>core.realtime =3D 0</div><div>core.immutable =3D 0</div>=
<div>core.append =3D 0</div><div>core.sync =3D 0</div><div>core.noatime =3D=
 0</div><div>core.nodump =3D 0</div><div>core.rtinherit =3D 0</div><div>cor=
e.projinherit =3D 0</div><div>core.nosymlinks =3D 0</div><div>core.extsz =
=3D 0</div><div>core.extszinherit =3D 0</div><div>core.nodefrag =3D 0</div>=
<div>core.filestream =3D 0</div><div>core.gen =3D 0</div><div>next_unlinked=
 =3D 0</div><div>u.dev =3D 0</div></div></div><div><br></div></div><div cla=
ss=3D"gmail_extra"><br><div class=3D"gmail_quote">On 7 January 2015 at 10:1=
6, Brian Foster <span dir=3D"ltr">&lt;<a href=3D"mailto:bfoster@redhat.com"=
 target=3D"_blank">bfoster@redhat.com</a>&gt;</span> wrote:<br><blockquote =
class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid=
;padding-left:1ex"><div class=3D"HOEnZb"><div class=3D"h5">On Wed, Jan 07, =
2015 at 07:34:37AM +1100, David Raffelt wrote:<br>
&gt; Hi Brian and Stefan,<br>
&gt; Thanks for your reply.=C2=A0 I checked the status of the array after t=
he rebuild<br>
&gt; (and before the reset).<br>
&gt;<br>
&gt; md0 : active raid6 sdd1[8] sdc1[4] sda1[3] sdb1[7] sdi1[5] sde1[1]<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A014650667520 blocks super 1.2 level 6, 512k c=
hunk, algorithm 2 [7/6]<br>
&gt; [UUUUUU_]<br>
&gt;<br>
&gt; However given that I&#39;ve never had any problems before with mdadm r=
ebuilds I<br>
&gt; did not think to check the data before rebooting.=C2=A0 Note that the =
array is<br>
&gt; still in this state. Before the reboot I tried to run a smartctl check=
 on<br>
&gt; the failed drives and it could not read them. When I rebooted I did no=
t<br>
&gt; actually replace any drives, I just power cycled to see if I could<br>
&gt; re-access the drives that were thrown out of the array. According to<b=
r>
&gt; smartctl they are completely fine.<br>
&gt;<br>
&gt; I guess there is no way I can re-add the old drives and remove the new=
ly<br>
&gt; synced drive?=C2=A0 Even though I immediately kicked all users off the=
 system<br>
&gt; when I got the mdadm alert, it&#39;s possible a small amount of data w=
as<br>
&gt; written to the array during the resync.<br>
&gt;<br>
&gt; It looks like the filesystem was not unmounted properly before reboot:=
<br>
&gt; Jan 06 09:11:54 server systemd[1]: Failed unmounting /export/data.<br>
&gt; Jan 06 09:11:54 server systemd[1]: Shutting down.<br>
&gt;<br>
&gt; Here is the mount errors in the log after rebooting:<br>
&gt; Jan 06 09:15:17 server kernel: XFS (md0): Mounting Filesystem<br>
&gt; Jan 06 09:15:17 server kernel: XFS (md0): Corruption detected. Unmount=
 and<br>
&gt; run xfs_repair<br>
&gt; Jan 06 09:15:17 server kernel: XFS (md0): Corruption detected. Unmount=
 and<br>
&gt; run xfs_repair<br>
&gt; Jan 06 09:15:17 server kernel: XFS (md0): Corruption detected. Unmount=
 and<br>
&gt; run xfs_repair<br>
&gt; Jan 06 09:15:17 server kernel: XFS (md0): metadata I/O error: block 0x=
400<br>
&gt; (&quot;xfs_trans_read_buf_map&quot;) error 117 numblks 16<br>
&gt; Jan 06 09:15:17 server kernel: XFS (md0): xfs_imap_to_bp:<br>
&gt; xfs_trans_read_buf() returned error 117.<br>
&gt; Jan 06 09:15:17 server kernel: XFS (md0): failed to read root inode<br=
>
&gt;<br>
<br>
</div></div>So it fails to read the root inode. You could also try to read =
said<br>
inode via xfs_db (e.g., &#39;sb,&#39; &#39;p rootino,&#39; &#39;inode &lt;i=
no#&gt;,&#39; &#39;p&#39;) and see<br>
what it shows.<br>
<br>
Are you able to run xfs_metadump against the fs? If so and you&#39;re<br>
willing/able to make the dump available somewhere (compressed), I&#39;d be<=
br>
interested to take a look to see what might be causing the difference in<br=
>
behavior between repair and xfs_db.<br>
<br>
Brian<br>
<div><div class=3D"h5"><br>
&gt; xfs_repair -n -L also complains about a bad magic number.<br>
&gt;<br>
&gt; Unfortunately this 15TB RAID was part of a 45TB GlusterFS distributed<=
br>
&gt; volume. It was only ever meant to be a scratch drive for intermediate<=
br>
&gt; scientific results, however inevitably most users used it to store lot=
s of<br>
&gt; data. Oh well.<br>
&gt;<br>
&gt; Thanks again,<br>
&gt; Dave<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; On 6 January 2015 at 23:47, Brian Foster &lt;<a href=3D"mailto:bfoster=
@redhat.com">bfoster@redhat.com</a>&gt; wrote:<br>
&gt;<br>
&gt; &gt; On Tue, Jan 06, 2015 at 05:12:14PM +1100, David Raffelt wrote:<br=
>
&gt; &gt; &gt; Hi again,<br>
&gt; &gt; &gt; Some more information.... the kernel log show the following =
errors were<br>
&gt; &gt; &gt; occurring after the RAID recovery, but before I reset the se=
rver.<br>
&gt; &gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; By after the raid recovery, you mean after the two drives had fai=
led out<br>
&gt; &gt; and 1 hot spare was activated and resync completed? It certainly =
seems<br>
&gt; &gt; like something went wrong in this process. The output below looks=
 like<br>
&gt; &gt; it&#39;s failing to read in some inodes. Is there any stack trace=
 output<br>
&gt; &gt; that accompanies these error messages to confirm?<br>
&gt; &gt;<br>
&gt; &gt; I suppose I would try to verify that the array configuration look=
s sane,<br>
&gt; &gt; but after the hot spare resync and then one or two other drive<br=
>
&gt; &gt; replacements (was the hot spare ultimately replaced?), it&#39;s h=
ard to say<br>
&gt; &gt; whether it might be recoverable.<br>
&gt; &gt;<br>
&gt; &gt; Brian<br>
&gt; &gt;<br>
&gt; &gt; &gt; Jan 06 00:00:27 server kernel: XFS (md0): Corruption detecte=
d. Unmount<br>
&gt; &gt; and<br>
&gt; &gt; &gt; run xfs_repair<br>
&gt; &gt; &gt; Jan 06 00:00:27 server kernel: XFS (md0): Corruption detecte=
d. Unmount<br>
&gt; &gt; and<br>
&gt; &gt; &gt; run xfs_repair<br>
&gt; &gt; &gt; Jan 06 00:00:27 server kernel: XFS (md0): Corruption detecte=
d. Unmount<br>
&gt; &gt; and<br>
&gt; &gt; &gt; run xfs_repair<br>
&gt; &gt; &gt; Jan 06 00:00:27 server kernel: XFS (md0): metadata I/O error=
: block<br>
&gt; &gt; &gt; 0x36b106c00 (&quot;xfs_trans_read_buf_map&quot;) error 117 n=
umblks 16<br>
&gt; &gt; &gt; Jan 06 00:00:27 server kernel: XFS (md0): xfs_imap_to_bp:<br=
>
&gt; &gt; &gt; xfs_trans_read_buf() returned error 117.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Thanks,<br>
&gt; &gt; &gt; Dave<br>
&gt; &gt;<br>
&gt; &gt; &gt; _______________________________________________<br>
&gt; &gt; &gt; xfs mailing list<br>
&gt; &gt; &gt; <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
&gt; &gt; &gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=
=3D"_blank">http://oss.sgi.com/mailman/listinfo/xfs</a><br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt;<br>
&gt;<br>
&gt; --<br>
</div></div>&gt; *David Raffelt (PhD)*<br>
<span class=3D"im HOEnZb">&gt; Postdoctoral Fellow<br>
&gt;<br>
&gt; The Florey Institute of Neuroscience and Mental Health<br>
&gt; Melbourne Brain Centre - Austin Campus<br>
&gt; 245 Burgundy Street<br>
&gt; Heidelberg Vic 3084<br>
&gt; Ph: <a href=3D"tel:%2B61%203%209035%207024" value=3D"+61390357024">+61=
 3 9035 7024</a><br>
&gt; <a href=3D"http://www.florey.edu.au" target=3D"_blank">www.florey.edu.=
au</a><br>
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

--001a113ed2745d341c050c046cd2--


--===============0620809904886658332==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0620809904886658332==--
