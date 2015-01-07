Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5E3967F5F
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 01:05:25 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4B2508F8035
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 23:05:24 -0800 (PST)
Received: from mail-gw1.its.unimelb.edu.au (mail-gw1.its.unimelb.edu.au
	[128.250.5.150]) by cuda.sgi.com with ESMTP id ihhChbMDZPVarc9M
	for <xfs@oss.sgi.com>; Tue, 06 Jan 2015 23:05:17 -0800 (PST)
Received: from mail-ig0-f169.google.com (mail-ig0-f169.google.com
	[209.85.213.169]) (Authenticated sender: draffelt)
	by mail-gw1.its.unimelb.edu.au (Postfix) with ESMTPSA id 3DE5B744
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 18:05:16 +1100 (EST)
Received: by mail-ig0-f169.google.com with SMTP id z20so5955732igj.2
	for <xfs@oss.sgi.com>; Tue, 06 Jan 2015 23:05:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <9cb00ded133a452e9fed635bd0094885@000S-EX-HUB-NP2.unimelb.edu.au>
References: <9cb00ded133a452e9fed635bd0094885@000S-EX-HUB-NP2.unimelb.edu.au>
Date: Wed, 7 Jan 2015 18:05:14 +1100
Message-ID: <CAOFq7B7eRjS2j_KSf7uPpiN16qGDi+jLdqZW_T24rMuPccEOyQ@mail.gmail.com>
Subject: Re: xfs Digest, Vol 79, Issue 19
From: David Raffelt <david.raffelt@florey.edu.au>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8993004292451171045=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, lists@colorremedies.com

--===============8993004292451171045==
Content-Type: multipart/alternative; boundary=047d7b2e127f8fb2c1050c0a8b58

--047d7b2e127f8fb2c1050c0a8b58
Content-Type: text/plain; charset=UTF-8

Hi Chris,
Thanks for your time. I have responded to your suggestions below.


> Date: Tue, 6 Jan 2015 19:35:34 -0700
> From: Chris Murphy <lists@colorremedies.com>
> To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>
> Subject: Re: XFS corrupt after RAID failure and resync
> Message-ID:
>         <
> CAJCQCtS1p080M9dvuAJWBoafCcoOo2SaVLEhdVQV6QA8RC54cA@mail.gmail.com>
> Content-Type: text/plain; charset=UTF-8
>
> On Tue, Jan 6, 2015 at 1:34 PM, David Raffelt
> <david.raffelt@florey.edu.au> wrote:
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
> re-access
> > the drives that were thrown out of the array. According to smartctl they
> are
> > completely fine.
> >
> > I guess there is no way I can re-add the old drives and remove the newly
> > synced drive?  Even though I immediately kicked all users off the system
> > when I got the mdadm alert, it's possible a small amount of data was
> written
> > to the array during the resync.
>
> Well it sounds like there's more than one possibility here. If I
> follow correctly, you definitely had a working degraded 5/7 drive
> array, correct? In which case at least it should be possible to get
> that back, but I don't know what was happening at the time the system
> hung up on poweroff.
>
>
Yes, after the 2 disks were dropped I definitely had a working degraded
drive with 5/7 . I only see XFS errors in the kernel log soon AFTER the hot
spare finished syncing. Here are the errors.

Jan 06 00:00:27 server kernel: XFS (md0): Corruption detected. Unmount and
run xfs_repair
Jan 06 00:00:27 server kernel: XFS (md0): metadata I/O error: block
0x36b106c00 ("xfs_trans_read_buf_map") error 117 numblks 16
Jan 06 00:00:27 server kernel: XFS (md0): xfs_imap_to_bp:
xfs_trans_read_buf() returned error 117.

If it helps, about 1 min before the drives were dropped from the array I
got many of the below errors in the log. Here is a link to the complete log
if needed. https://dl.dropboxusercontent.com/u/1156508/journalctl_dump.txt

Jan 05 11:40:45 server kernel: ata11.00: status: { DRDY }
Jan 05 11:40:45 server kernel: ata11.00: cmd
60/10:00:70:60:0c/00:00:71:00:00/40 tag 0 ncq 8192 in res
40/00:00:00:4f:c2/00:00:00:00:00/40 Emask 0x4 (timeout)
Jan 05 11:40:45 server kernel: ata11.00: failed command: READ FPDMA QUEUED
Jan 05 11:40:45 server kernel: ata11.00: exception Emask 0x0 SAct
0x7fffffff SErr 0x0 action 0x6 frozen
...
Jan 05 11:41:15 server kernel: ata12: limiting SATA link speed to 3.0 Gbps
Jan 05 11:41:15 server kernel: ata12: hard resetting link
Jan 05 11:41:16 server kernel: ata12: SATA link up 6.0 Gbps (SStatus 133
SControl 320)
Jan 05 11:41:38 server kernel: ata11.00: qc timeout (cmd 0xec)
Jan 05 11:41:38 server kernel: ata11.00: failed to IDENTIFY (I/O error,
err_mask=0x4)
Jan 05 11:41:38 server kernel: ata11.00: revalidation failed (errno=-5)
Jan 05 11:41:38 server kernel: ata11.00: disabled
Jan 05 11:41:38 server kernel: ata11.00: device reported invalid CHS sector
0
....
Jan 05 11:41:40 server kernel: sd 11:0:0:0: [sdf] Unhandled error code
Jan 05 11:41:40 server kernel: sd 11:0:0:0: [sdf]
Jan 05 11:41:40 server kernel: Result: hostbyte=0x04 driverbyte=0x00
Jan 05 11:41:40 server kernel: sd 11:0:0:0: [sdf] CDB:
Jan 05 11:41:40 server kernel: cdb[0]=0x88: 88 00 00 00 00 00 71 0c 60 40
00 00 00 10 00 00
Jan 05 11:41:40 server kernel: end_request: I/O error, dev sdf, sector
1896636480
...
Jan 05 11:41:40 server kernel: sd 11:0:0:0: [sdf] Unhandled error code
Jan 05 11:41:40 server kernel: sd 11:0:0:0: [sdf]
Jan 05 11:41:40 server kernel: Result: hostbyte=0x04 driverbyte=0x00
Jan 05 11:41:40 server kernel: sd 11:0:0:0: [sdf] CDB:
Jan 05 11:41:40 server kernel: cdb[0]=0x88: 88 00 00 00 00 00 7f 00 0b 00
00 00 00 08 00 00
Jan 05 11:41:40 server kernel: md: super_written gets error=-5, uptodate=0
Jan 05 11:41:40 server kernel: md/raid:md0: Disk failure on sdf1, disabling
device.
                                                  md/raid:md0: Operation
continuing on 6 devices.




> It's not rare for smart to not test for certain failure vectors so it
> might say the drive is fine when it isn't. But what you should do next
> is
>
> mdadm -Evv /dev/sd[abcdefg]1   ##use actual drive letters
>
> Are you able to get information on all seven drives? Or do you
> definitely have at least one drive failed?
>

 I get all the information from all 8 drives (7 + the hot spare). The 6
drives currently in the array all have the same event number (80664).
However the 2 drives that were dropped have the event number 80327.


>
> If the event counter from the above examine is the same for at least 5
> drives, you should be able to assemble the array with this command:
>
> mdadm --assemble --verbose /dev/mdX /dev/sd[bcdef]1
>
> You have to feed the drive letter designation with the right letters
> for drives with the same event counter. If that's 5 drives, use that.
> If it's 6 drives, use that. If the event counters are all off, then
> it's a matter of what they are so you may just post the event counters
> so we can see this. This isn't going to write anything to the array,
> the fs isn't mounted. So if it fails, nothing is worse off. If it
> works, then you can run xfs_repair -n and see if you get a sane
> result. If that works you can mount it in this degraded state and
> maybe extract some of the more important data before proceeding to the
> next step.
>

Not sure if I'm missing something, but the array is already assembled with
6/7 drives all having the same event number. In any case I have stopped the
array, and assembled again with no luck.


>
> In the meantime I'm also curious about:
>
> smarctl -l scterc /dev/sdX
>

I'm ashamed to say that this command only works on 1 of the 8 drives since
this is the only enterprise class drive (we are funded by small science
grants). We have been gradually replacing the desktop class drives as they
fail.

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)


>
> This has to be issued per drive, no shortcut available by specifying
> all letters at once in brackets. And then lastly this one:
>
> cat /sys/block/sd[abcdefg]/device/timeout
>
> Again plug in the correct letters.
>

All devices are set to 30 seconds.


>
>
>
> > Unfortunately this 15TB RAID was part of a 45TB GlusterFS distributed
> > volume. It was only ever meant to be a scratch drive for intermediate
> > scientific results, however inevitably most users used it to store lots
> of
> > data. Oh well.
>
> Right well it's not fore sure toast yet. Also, one of the things
> gluster is intended to mitigate is the loss of an entire brick, which
> is what happened, but you need another 15TB of space to do
> distributed-replicated on your scratch space. If you can tolerate
> upwards of 48 hour single disk rebuild times, there are now 8TB HGST
> Helium drives :-P
>

Just to confirm, we have 3x15TB bricks in a 45TB volume. Don't we need
complete duplication in a distributed-replicated Gluster volume, or can we
get away with only 1 more brick?

Those HGST 8GB drives do look very tempting!
Thanks again,
Dave


>
> --
> Chris Murphy
>
>
>
>
>

--047d7b2e127f8fb2c1050c0a8b58
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote"><div=
>Hi Chris,</div><div>Thanks for your time. I have responded to your suggest=
ions below.</div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=
=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(20=
4,204,204);border-left-style:solid;padding-left:1ex">
Date: Tue, 6 Jan 2015 19:35:34 -0700<br>
From: Chris Murphy &lt;<a href=3D"mailto:lists@colorremedies.com">lists@col=
orremedies.com</a>&gt;<br>
To: &quot;<a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a>&quot; &lt;=
<a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a>&gt;<br>
Subject: Re: XFS corrupt after RAID failure and resync<br>
Message-ID:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 &lt;<a href=3D"mailto:CAJCQCtS1p080M9dvuAJWBoaf=
CcoOo2SaVLEhdVQV6QA8RC54cA@mail.gmail.com">CAJCQCtS1p080M9dvuAJWBoafCcoOo2S=
aVLEhdVQV6QA8RC54cA@mail.gmail.com</a>&gt;<br>
Content-Type: text/plain; charset=3DUTF-8<br>
<br>
On Tue, Jan 6, 2015 at 1:34 PM, David Raffelt<br>
&lt;<a href=3D"mailto:david.raffelt@florey.edu.au">david.raffelt@florey.edu=
.au</a>&gt; wrote:<br>
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
&gt; actually replace any drives, I just power cycled to see if I could re-=
access<br>
&gt; the drives that were thrown out of the array. According to smartctl th=
ey are<br>
&gt; completely fine.<br>
&gt;<br>
&gt; I guess there is no way I can re-add the old drives and remove the new=
ly<br>
&gt; synced drive?=C2=A0 Even though I immediately kicked all users off the=
 system<br>
&gt; when I got the mdadm alert, it&#39;s possible a small amount of data w=
as written<br>
&gt; to the array during the resync.<br>
<br>
Well it sounds like there&#39;s more than one possibility here. If I<br>
follow correctly, you definitely had a working degraded 5/7 drive<br>
array, correct? In which case at least it should be possible to get<br>
that back, but I don&#39;t know what was happening at the time the system<b=
r>
hung up on poweroff.<br>
<br></blockquote><div><br></div><div>Yes, after the 2 disks were dropped I =
definitely had a working degraded drive with 5/7 . I only see XFS errors in=
 the kernel log soon AFTER the hot spare finished syncing. Here are the err=
ors.=C2=A0</div><div><br></div><div style=3D"font-size:13px">Jan 06 00:00:2=
7 server kernel: XFS (md0): Corruption detected. Unmount and run xfs_repair=
</div><div style=3D"font-size:13px">Jan 06 00:00:27 server kernel: XFS (md0=
): metadata I/O error: block 0x36b106c00 (&quot;xfs_trans_read_buf_map&quot=
;) error 117 numblks 16</div><div style=3D"font-size:13px">Jan 06 00:00:27 =
server kernel: XFS (md0): xfs_imap_to_bp: xfs_trans_read_buf() returned err=
or 117.</div><div><br></div><div>If it helps, about 1 min before the drives=
 were dropped from the array I got many of the below errors in the log. Her=
e is a link to the complete log if needed.=C2=A0<a href=3D"https://dl.dropb=
oxusercontent.com/u/1156508/journalctl_dump.txt">https://dl.dropboxusercont=
ent.com/u/1156508/journalctl_dump.txt</a></div><div><br></div><div><div sty=
le=3D"font-size:13px">Jan 05 11:40:45 server kernel: ata11.00: status: { DR=
DY }</div><div style=3D"font-size:13px">Jan 05 11:40:45 server kernel: ata1=
1.00: cmd 60/10:00:70:60:0c/00:00:71:00:00/40 tag 0 ncq 8192 in res 40/00:0=
0:00:4f:c2/00:00:00:00:00/40 Emask 0x4 (timeout)</div><div style=3D"font-si=
ze:13px">Jan 05 11:40:45 server kernel: ata11.00: failed command: READ FPDM=
A QUEUED</div><div style=3D"font-size:13px">Jan 05 11:40:45 server kernel: =
ata11.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 action 0x6 frozen</d=
iv><div style=3D"font-size:13px">...</div><div style=3D"font-size:13px">Jan=
 05 11:41:15 server kernel: ata12: limiting SATA link speed to 3.0 Gbps</di=
v><div style=3D"font-size:13px">Jan 05 11:41:15 server kernel: ata12: hard =
resetting link</div><div style=3D"font-size:13px">Jan 05 11:41:16 server ke=
rnel: ata12: SATA link up 6.0 Gbps (SStatus 133 SControl 320)</div><div sty=
le=3D"font-size:13px">Jan 05 11:41:38 server kernel: ata11.00: qc timeout (=
cmd 0xec)</div><div style=3D"font-size:13px">Jan 05 11:41:38 server kernel:=
 ata11.00: failed to IDENTIFY (I/O error, err_mask=3D0x4)</div><div style=
=3D"font-size:13px">Jan 05 11:41:38 server kernel: ata11.00: revalidation f=
ailed (errno=3D-5)</div><div style=3D"font-size:13px">Jan 05 11:41:38 serve=
r kernel: ata11.00: disabled</div><div style=3D"font-size:13px">Jan 05 11:4=
1:38 server kernel: ata11.00: device reported invalid CHS sector 0</div><di=
v style=3D"font-size:13px">....</div><div style=3D"font-size:13px">Jan 05 1=
1:41:40 server kernel: sd 11:0:0:0: [sdf] Unhandled error code</div><div st=
yle=3D"font-size:13px">Jan 05 11:41:40 server kernel: sd 11:0:0:0: [sdf] =
=C2=A0</div><div style=3D"font-size:13px">Jan 05 11:41:40 server kernel: Re=
sult: hostbyte=3D0x04 driverbyte=3D0x00</div><div style=3D"font-size:13px">=
Jan 05 11:41:40 server kernel: sd 11:0:0:0: [sdf] CDB:=C2=A0</div><div styl=
e=3D"font-size:13px">Jan 05 11:41:40 server kernel: cdb[0]=3D0x88: 88 00 00=
 00 00 00 71 0c 60 40 00 00 00 10 00 00</div><div style=3D"font-size:13px">=
Jan 05 11:41:40 server kernel: end_request: I/O error, dev sdf, sector 1896=
636480</div><div style=3D"font-size:13px">...</div><div style=3D"font-size:=
13px">Jan 05 11:41:40 server kernel: sd 11:0:0:0: [sdf] Unhandled error cod=
e</div><div style=3D"font-size:13px">Jan 05 11:41:40 server kernel: sd 11:0=
:0:0: [sdf] =C2=A0</div><div style=3D"font-size:13px">Jan 05 11:41:40 serve=
r kernel: Result: hostbyte=3D0x04 driverbyte=3D0x00</div><div style=3D"font=
-size:13px">Jan 05 11:41:40 server kernel: sd 11:0:0:0: [sdf] CDB:=C2=A0</d=
iv><div style=3D"font-size:13px">Jan 05 11:41:40 server kernel: cdb[0]=3D0x=
88: 88 00 00 00 00 00 7f 00 0b 00 00 00 00 08 00 00</div><div style=3D"font=
-size:13px">Jan 05 11:41:40 server kernel: md: super_written gets error=3D-=
5, uptodate=3D0</div><div style=3D"font-size:13px">Jan 05 11:41:40 server k=
ernel: md/raid:md0: Disk failure on sdf1, disabling device.</div><div style=
=3D"font-size:13px">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 md/raid:md0: Operation contin=
uing on 6 devices.</div></div><div style=3D"font-size:13px"><br></div><div =
style=3D"font-size:13px"><br></div><div>=C2=A0</div><blockquote class=3D"gm=
ail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-l=
eft-color:rgb(204,204,204);border-left-style:solid;padding-left:1ex">
It&#39;s not rare for smart to not test for certain failure vectors so it<b=
r>
might say the drive is fine when it isn&#39;t. But what you should do next<=
br>
is<br>
<br>
mdadm -Evv /dev/sd[abcdefg]1=C2=A0 =C2=A0##use actual drive letters<br>
<br>
Are you able to get information on all seven drives? Or do you<br>
definitely have at least one drive failed?<br></blockquote><div><br></div><=
div>=C2=A0I get all the information from all 8 drives (7 + the hot spare). =
The 6 drives currently in the array all have the same event number (80664).=
 However the 2 drives that were dropped have the event number=C2=A080327.=
=C2=A0</div><div>=C2=A0<br></div><blockquote class=3D"gmail_quote" style=3D=
"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,2=
04,204);border-left-style:solid;padding-left:1ex">
<br>
If the event counter from the above examine is the same for at least 5<br>
drives, you should be able to assemble the array with this command:<br>
<br>
mdadm --assemble --verbose /dev/mdX /dev/sd[bcdef]1<br>
<br>
You have to feed the drive letter designation with the right letters<br>
for drives with the same event counter. If that&#39;s 5 drives, use that.<b=
r>
If it&#39;s 6 drives, use that. If the event counters are all off, then<br>
it&#39;s a matter of what they are so you may just post the event counters<=
br>
so we can see this. This isn&#39;t going to write anything to the array,<br=
>
the fs isn&#39;t mounted. So if it fails, nothing is worse off. If it<br>
works, then you can run xfs_repair -n and see if you get a sane<br>
result. If that works you can mount it in this degraded state and<br>
maybe extract some of the more important data before proceeding to the<br>
next step.<br></blockquote><div><br></div><div>Not sure if I&#39;m missing =
something, but the array is already assembled with 6/7 drives all having th=
e same event number. In any case I have stopped the array, and assembled ag=
ain with no luck.</div><div>=C2=A0</div><blockquote class=3D"gmail_quote" s=
tyle=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rg=
b(204,204,204);border-left-style:solid;padding-left:1ex">
<br>
In the meantime I&#39;m also curious about:<br>
<br>
smarctl -l scterc /dev/sdX<br></blockquote><div><br></div><div>I&#39;m asha=
med to say that this command only works on 1 of the 8 drives since this is =
the only enterprise class drive (we are funded by small science grants). We=
 have been gradually replacing the desktop class drives as they fail.=C2=A0=
</div><div><div><br></div><div>SCT Error Recovery Control:</div><div>=C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Read: =C2=A0 =C2=A0 70 (7.0 seconds)</di=
v><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Write: =C2=A0 =C2=A0 70 (7.0 seco=
nds)</div><div>=C2=A0<br></div></div><blockquote class=3D"gmail_quote" styl=
e=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(2=
04,204,204);border-left-style:solid;padding-left:1ex">
<br>
This has to be issued per drive, no shortcut available by specifying<br>
all letters at once in brackets. And then lastly this one:<br>
<br>
cat /sys/block/sd[abcdefg]/device/timeout<br>
<br>
Again plug in the correct letters.<br></blockquote><div><br></div><div>All =
devices are set to 30 seconds.=C2=A0</div><div>=C2=A0<br></div><blockquote =
class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1=
px;border-left-color:rgb(204,204,204);border-left-style:solid;padding-left:=
1ex">
<br>
<br>
<br>
&gt; Unfortunately this 15TB RAID was part of a 45TB GlusterFS distributed<=
br>
&gt; volume. It was only ever meant to be a scratch drive for intermediate<=
br>
&gt; scientific results, however inevitably most users used it to store lot=
s of<br>
&gt; data. Oh well.<br>
<br>
Right well it&#39;s not fore sure toast yet. Also, one of the things<br>
gluster is intended to mitigate is the loss of an entire brick, which<br>
is what happened, but you need another 15TB of space to do<br>
distributed-replicated on your scratch space. If you can tolerate<br>
upwards of 48 hour single disk rebuild times, there are now 8TB HGST<br>
Helium drives :-P<br></blockquote><div><br></div><div>Just to confirm, we h=
ave 3x15TB bricks in a 45TB volume. Don&#39;t we need complete duplication =
in a distributed-replicated Gluster volume, or can we get away with only 1 =
more brick?=C2=A0</div><div><br></div><div>Those HGST 8GB drives do look ve=
ry tempting!</div><div>Thanks again,</div><div>Dave</div><div><br></div><bl=
ockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-lef=
t-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;padd=
ing-left:1ex">
<br>
<br>
--<br>
Chris Murphy<br>
<br>
<br>
<br><br></blockquote></div>
</div></div>

--047d7b2e127f8fb2c1050c0a8b58--


--===============8993004292451171045==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8993004292451171045==--
