Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n186B1oT156480 for <xfs@oss.sgi.com>; Sun, 8 Feb 2009 00:11:02 -0600
Received: from mail-gx0-f21.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AB30E18E7AEC
	for <xfs@oss.sgi.com>; Sat,  7 Feb 2009 22:10:22 -0800 (PST)
Received: from mail-gx0-f21.google.com (mail-gx0-f21.google.com
	[209.85.217.21]) by cuda.sgi.com with ESMTP id xICnLHxAwUACVX0F
	for <xfs@oss.sgi.com>; Sat, 07 Feb 2009 22:10:22 -0800 (PST)
Received: by gxk14 with SMTP id 14so1378520gxk.20
	for <xfs@oss.sgi.com>; Sat, 07 Feb 2009 22:10:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <498DF8AD.3020903@sandeen.net>
References: <22271900.11234039561556.JavaMail.root@wombat.diezmil.com>
	<498DF8AD.3020903@sandeen.net>
Date: Sun, 8 Feb 2009 00:10:22 -0600
Message-ID: <68685c7a0902072210w5d96bfa2h81b89ee238a09d15@mail.gmail.com>
Subject: Re: Power loss causes bad magic number??
From: Kevin Dual <kevin.dual@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4543026148623283216=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

--===============4543026148623283216==
Content-Type: multipart/alternative; boundary=000e0cd487baf4fdad0462621b11

--000e0cd487baf4fdad0462621b11
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On Sat, Feb 7, 2009 at 3:10 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

> kevin.dual@gmail.com wrote:
> > I'm having a very similar problem... My 1TB RAID-5 array formatted with
> XFS assembles, but refuses to mount:
>
> ...
>
> > $ cat /proc/mdstat
> > Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> > md0 : active raid5 sdd1[2] sdc1[1] sdb1[0]
> >       976767872 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
> >
> > unused devices: <none>
>
> ...
>
>
> > --------------------------------------------------
> > $ sudo xfs_check /dev/md0
> > xfs_check: unexpected XFS SB magic number 0x110812af
> > cache_node_purge: refcount was 1, not zero (node=0x1300220)
> > xfs_check: cannot read root inode (22)
> > cache_node_purge: refcount was 1, not zero (node=0x1300440)
> > xfs_check: cannot read realtime bitmap inode (22)
> > Segmentation fault
>
> hm, ok...
>
> but below you don't expect each component drive to be a consistent xfs
> fs do you?  It's not a mirror :)



Actually, I did not expect each component drive to be a consistent xfs file
system, I was just trying to gather as much information as possible.  I'm
glad I did because it was running "sudo dd if=/dev/sd* bs=512 count=128
iflag=direct | hexdump -C | grep XFSB" on all my drives that showed which
drive had the xfs info on it and allowed you to suggest that I try creating
the array with that drive first:

$ sudo mdadm --create /dev/md0 --level=5 --raid-devices=3 --assume-clean
/dev/sdc1 /dev/sdd1 /dev/sdb1
mdadm: /dev/sdc1 appears to be part of a raid array:
    level=raid5 devices=3 ctime=Fri Feb  6 18:01:59 2009
mdadm: /dev/sdd1 appears to be part of a raid array:
    level=raid5 devices=3 ctime=Fri Feb  6 18:01:59 2009
mdadm: /dev/sdb1 appears to be part of a raid array:
    level=raid5 devices=3 ctime=Fri Feb  6 18:01:59 2009
Continue creating array? y
mdadm: array /dev/md0 started.

$ sudo mount -t xfs /dev/md0 test
$ cd test
/test$ ls
ALL MY DATA!

So it seems that creating a RAID-5 array in the wrong order and allowing it
to sync does not destroy the data, which is very to know  ;P

Thank you very much for your help!


>
> > $ sudo xfs_check /dev/sdb1
> > xfs_check: unexpected XFS SB magic number 0x110812af
> > cache_node_purge: refcount was 1, not zero (node=0x2213220)
> > xfs_check: cannot read root inode (22)
> > bad superblock magic number 110812af, giving up
> >
> > $ sudo xfs_check /dev/sdc1
> > cache_node_purge: refcount was 1, not zero (node=0x2377220)
> > xfs_check: cannot read root inode (22)
> > cache_node_purge: refcount was 1, not zero (node=0x2377440)
> > xfs_check: cannot read realtime bitmap inode (22)
> > Segmentation fault
> >
> > $ sudo xfs_check /dev/sdd1
> > xfs_check: unexpected XFS SB magic number 0x494e41ed
> > xfs_check: size check failed
> > xfs_check: read failed: Invalid argument
> > xfs_check: data size check failed
> > cache_node_purge: refcount was 1, not zero (node=0x24f1c20)
> > xfs_check: cannot read root inode (22)
> > cache_node_purge: refcount was 1, not zero (node=0x24f1d70)
> > xfs_check: cannot read realtime bitmap inode (22)
> > Segmentation fault
> >
>
> none of the above surprises me
>
> > --------------------------------------------------
> > $ sudo xfs_repair -n /dev/md0
> > Phase 1 - find and verify superblock...
> > bad primary superblock - bad magic number !!!
> >
> > attempting to find secondary superblock...
> > ...etc...etc...fail fail fail
>
> Ok so above is the real problem.
>
> again below is not expected to work!
>
> > $ sudo xfs_repair -n /dev/sdb1
> > Phase 1 - find and verify superblock...
> > bad primary superblock - bad magic number !!!
> >
> > attempting to find secondary superblock...
> > ...etc...etc...fail fail fail
> >
> > $ sudo xfs_repair -n /dev/sdc1
> > Phase 1 - find and verify superblock...
> > error reading superblock 17 -- seek to offset 531361234944 failed
> > couldn't verify primary superblock - bad magic number !!!
> >
> > attempting to find secondary superblock...
> > ...found candidate secondary superblock...
> > error reading superblock 17 -- seek to offset 531361234944 failed
> > unable to verify superblock, continuing...
> > ...etc...etc...fail fail fail
> >
> > you know the routine...
> >
> >
> > --------------------------------------------------
> > $ sudo dd if=/dev/md0 bs=512 count=128 iflag=direct | hexdump -C | grep
> XFSB
> > 128+0 records in
> > 128+0 records out
> > 65536 bytes (66 kB) copied, 0.0257556 s, 2.5 MB/s
> >
> > $ sudo dd if=/dev/sdb bs=512 count=128 iflag=direct | hexdump -C | grep
> XFSB
> > 128+0 records in
> > 128+0 records out
> > 65536 bytes (66 kB) copied, 0.0352348 s, 1.9 MB/s
> >
> > $ sudo dd if=/dev/sdc bs=512 count=128 iflag=direct | hexdump -C | grep
> XFSB
> > 00007e00  58 46 53 42 00 00 10 00  00 00 00 00 0e 8e 12 00
>  |XFSB............|
>
> ibase=16
> 7E00
> 32256, or 63x512
>
> and sdc was:
>
> > Model: ATA ST3500641AS (scsi)
> > Disk /dev/sdc: 500GB
> > Sector size (logical/physical): 512B/512B
> > Partition Table: msdos
> >
> > Number  Start   End    Size   Type     File system  Flags
> >  1      32.3kB  500GB  500GB  primary               raid
>
> IOW the normal msdos 63 sectors.
>
> > 128+0 records in
> > 128+0 records out
> > 65536 bytes (66 kB) copied, 0.0386271 s, 1.7 MB/s
> >
> > $ sudo dd if=/dev/sdd bs=512 count=128 iflag=direct | hexdump -C | grep
> XFSB
> > 128+0 records in
> > 128+0 records out
> > 65536 bytes (66 kB) copied, 0.0928554 s, 706 kB/s
> >
> > Looks like /dev/sdc is the only one with any recognizable superblock data
> on it.
> > --------------------------------------------------
> >
> > Now what should I do with all this information?  The array assembles
> fine, but the XFS volume seems to be screwed up somehow.  Is there any way
> the array could have put itself together wrong then re-synced and corrupted
> all my data?
>
> It seems like maybe it assembled out of order, as if sdc1 should be the
> first drive, since it has the magic at the right place.
>
> Dunno how much damage could have been done, or if you can just try to
> fix the assembly perhaps...?
>
> -Eric
>
>

--000e0cd487baf4fdad0462621b11
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote">On Sat, Feb 7, 2009 at 3:10 PM, Eric San=
deen <span dir=3D"ltr">&lt;<a href=3D"mailto:sandeen@sandeen.net">sandeen@s=
andeen.net</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=
=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; p=
adding-left: 1ex;">
<a href=3D"mailto:kevin.dual@gmail.com">kevin.dual@gmail.com</a> wrote:<br>
&gt; I&#39;m having a very similar problem... My 1TB RAID-5 array formatted=
 with XFS assembles, but refuses to mount:<br>
<br>
...<br>
<br>
&gt; $ cat /proc/mdstat<br>
&gt; Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [=
raid4] [raid10]<br>
&gt; md0 : active raid5 sdd1[2] sdc1[1] sdb1[0]<br>
&gt; &nbsp; &nbsp; &nbsp; 976767872 blocks level 5, 64k chunk, algorithm 2 =
[3/3] [UUU]<br>
&gt;<br>
&gt; unused devices: &lt;none&gt;<br>
<br>
...<br>
<br>
<br>
&gt; --------------------------------------------------<br>
&gt; $ sudo xfs_check /dev/md0<br>
&gt; xfs_check: unexpected XFS SB magic number 0x110812af<br>
&gt; cache_node_purge: refcount was 1, not zero (node=3D0x1300220)<br>
&gt; xfs_check: cannot read root inode (22)<br>
&gt; cache_node_purge: refcount was 1, not zero (node=3D0x1300440)<br>
&gt; xfs_check: cannot read realtime bitmap inode (22)<br>
&gt; Segmentation fault<br>
<br>
hm, ok...<br>
<br>
but below you don&#39;t expect each component drive to be a consistent xfs<=
br>
fs do you? &nbsp;It&#39;s not a mirror :)</blockquote><div><br><br>Actually=
, I did not expect each component drive to be a consistent xfs file system,=
 I was just trying to gather as much information as possible.&nbsp; I&#39;m=
 glad I did because it was running &quot;sudo dd if=3D/dev/sd* bs=3D512 cou=
nt=3D128 iflag=3Ddirect | hexdump -C | grep XFSB&quot; on all my drives tha=
t showed which drive had the xfs info on it and allowed you to suggest that=
 I try creating the array with that drive first:<br>
<br>$ sudo mdadm --create /dev/md0 --level=3D5 --raid-devices=3D3 --assume-=
clean /dev/sdc1 /dev/sdd1 /dev/sdb1<br>mdadm: /dev/sdc1 appears to be part =
of a raid array:<br>&nbsp;&nbsp;&nbsp; level=3Draid5 devices=3D3 ctime=3DFr=
i Feb&nbsp; 6 18:01:59 2009<br>
mdadm: /dev/sdd1 appears to be part of a raid array:<br>&nbsp;&nbsp;&nbsp; =
level=3Draid5 devices=3D3 ctime=3DFri Feb&nbsp; 6 18:01:59 2009<br>mdadm: /=
dev/sdb1 appears to be part of a raid array:<br>&nbsp;&nbsp;&nbsp; level=3D=
raid5 devices=3D3 ctime=3DFri Feb&nbsp; 6 18:01:59 2009<br>
Continue creating array? y<br>mdadm: array /dev/md0 started.<br><br>$ sudo =
mount -t xfs /dev/md0 test<br>$ cd test<br>/test$ ls<br>ALL MY DATA!<br><br=
>So it seems that creating a RAID-5 array in the wrong order
and allowing it to sync does not destroy the data, which is very to
know&nbsp; ;P<br><br>Thank you very much for your help!<br><br></div><block=
quote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, 204, 2=
04); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><br>
<br>
&gt; $ sudo xfs_check /dev/sdb1<br>
&gt; xfs_check: unexpected XFS SB magic number 0x110812af<br>
&gt; cache_node_purge: refcount was 1, not zero (node=3D0x2213220)<br>
&gt; xfs_check: cannot read root inode (22)<br>
&gt; bad superblock magic number 110812af, giving up<br>
&gt;<br>
&gt; $ sudo xfs_check /dev/sdc1<br>
&gt; cache_node_purge: refcount was 1, not zero (node=3D0x2377220)<br>
&gt; xfs_check: cannot read root inode (22)<br>
&gt; cache_node_purge: refcount was 1, not zero (node=3D0x2377440)<br>
&gt; xfs_check: cannot read realtime bitmap inode (22)<br>
&gt; Segmentation fault<br>
&gt;<br>
&gt; $ sudo xfs_check /dev/sdd1<br>
&gt; xfs_check: unexpected XFS SB magic number 0x494e41ed<br>
&gt; xfs_check: size check failed<br>
&gt; xfs_check: read failed: Invalid argument<br>
&gt; xfs_check: data size check failed<br>
&gt; cache_node_purge: refcount was 1, not zero (node=3D0x24f1c20)<br>
&gt; xfs_check: cannot read root inode (22)<br>
&gt; cache_node_purge: refcount was 1, not zero (node=3D0x24f1d70)<br>
&gt; xfs_check: cannot read realtime bitmap inode (22)<br>
&gt; Segmentation fault<br>
&gt;<br>
<br>
none of the above surprises me<br>
<br>
&gt; --------------------------------------------------<br>
&gt; $ sudo xfs_repair -n /dev/md0<br>
&gt; Phase 1 - find and verify superblock...<br>
&gt; bad primary superblock - bad magic number !!!<br>
&gt;<br>
&gt; attempting to find secondary superblock...<br>
&gt; ...etc...etc...fail fail fail<br>
<br>
Ok so above is the real problem.<br>
<br>
again below is not expected to work!<br>
<br>
&gt; $ sudo xfs_repair -n /dev/sdb1<br>
&gt; Phase 1 - find and verify superblock...<br>
&gt; bad primary superblock - bad magic number !!!<br>
&gt;<br>
&gt; attempting to find secondary superblock...<br>
&gt; ...etc...etc...fail fail fail<br>
&gt;<br>
&gt; $ sudo xfs_repair -n /dev/sdc1<br>
&gt; Phase 1 - find and verify superblock...<br>
&gt; error reading superblock 17 -- seek to offset 531361234944 failed<br>
&gt; couldn&#39;t verify primary superblock - bad magic number !!!<br>
&gt;<br>
&gt; attempting to find secondary superblock...<br>
&gt; ...found candidate secondary superblock...<br>
&gt; error reading superblock 17 -- seek to offset 531361234944 failed<br>
&gt; unable to verify superblock, continuing...<br>
&gt; ...etc...etc...fail fail fail<br>
&gt;<br>
&gt; you know the routine...<br>
&gt;<br>
&gt;<br>
&gt; --------------------------------------------------<br>
&gt; $ sudo dd if=3D/dev/md0 bs=3D512 count=3D128 iflag=3Ddirect | hexdump =
-C | grep XFSB<br>
&gt; 128+0 records in<br>
&gt; 128+0 records out<br>
&gt; 65536 bytes (66 kB) copied, 0.0257556 s, 2.5 MB/s<br>
&gt;<br>
&gt; $ sudo dd if=3D/dev/sdb bs=3D512 count=3D128 iflag=3Ddirect | hexdump =
-C | grep XFSB<br>
&gt; 128+0 records in<br>
&gt; 128+0 records out<br>
&gt; 65536 bytes (66 kB) copied, 0.0352348 s, 1.9 MB/s<br>
&gt;<br>
&gt; $ sudo dd if=3D/dev/sdc bs=3D512 count=3D128 iflag=3Ddirect | hexdump =
-C | grep XFSB<br>
&gt; 00007e00 &nbsp;58 46 53 42 00 00 10 00 &nbsp;00 00 00 00 0e 8e 12 00 &=
nbsp;|XFSB............|<br>
<br>
ibase=3D16<br>
7E00<br>
32256, or 63x512<br>
<br>
and sdc was:<br>
<br>
&gt; Model: ATA ST3500641AS (scsi)<br>
&gt; Disk /dev/sdc: 500GB<br>
&gt; Sector size (logical/physical): 512B/512B<br>
&gt; Partition Table: msdos<br>
&gt;<br>
&gt; Number &nbsp;Start &nbsp; End &nbsp; &nbsp;Size &nbsp; Type &nbsp; &nb=
sp; File system &nbsp;Flags<br>
&gt; &nbsp;1 &nbsp; &nbsp; &nbsp;32.3kB &nbsp;500GB &nbsp;500GB &nbsp;prima=
ry &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; raid<br>
<br>
IOW the normal msdos 63 sectors.<br>
<br>
&gt; 128+0 records in<br>
&gt; 128+0 records out<br>
&gt; 65536 bytes (66 kB) copied, 0.0386271 s, 1.7 MB/s<br>
&gt;<br>
&gt; $ sudo dd if=3D/dev/sdd bs=3D512 count=3D128 iflag=3Ddirect | hexdump =
-C | grep XFSB<br>
&gt; 128+0 records in<br>
&gt; 128+0 records out<br>
&gt; 65536 bytes (66 kB) copied, 0.0928554 s, 706 kB/s<br>
&gt;<br>
&gt; Looks like /dev/sdc is the only one with any recognizable superblock d=
ata on it.<br>
&gt; --------------------------------------------------<br>
&gt;<br>
&gt; Now what should I do with all this information? &nbsp;The array assemb=
les fine, but the XFS volume seems to be screwed up somehow. &nbsp;Is there=
 any way the array could have put itself together wrong then re-synced and =
corrupted all my data?<br>

<br>
It seems like maybe it assembled out of order, as if sdc1 should be the<br>
first drive, since it has the magic at the right place.<br>
<br>
Dunno how much damage could have been done, or if you can just try to<br>
fix the assembly perhaps...?<br>
<font color=3D"#888888"><br>
-Eric<br>
<br>
</font></blockquote></div><br>

--000e0cd487baf4fdad0462621b11--


--===============4543026148623283216==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4543026148623283216==--
