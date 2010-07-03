Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o63HNW0v037060 for <xfs@oss.sgi.com>; Sat, 3 Jul 2010 12:23:33 -0500
Received: from smtp-server.rit.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A91C8B6EF83
	for <xfs@oss.sgi.com>; Sat,  3 Jul 2010 10:31:32 -0700 (PDT)
Received: from smtp-server.rit.edu (sc3app27.rit.edu [129.21.35.56]) by
	cuda.sgi.com with ESMTP id Lr8gbBxnGl6Pj9ss for
	<xfs@oss.sgi.com>; Sat, 03 Jul 2010 10:31:32 -0700 (PDT)
Received: from conversion-daemon.smtp-server.rit.edu by smtp-server.rit.edu
	(PMDF V6.3-x14 #31420) id <0L4Z00601SFWAK@smtp-server.rit.edu> for
	xfs@oss.sgi.com; Sat, 03 Jul 2010 13:26:20 -0400 (EDT)
Received: from mail-ww0-f54.google.com (mail-ww0-f54.google.com [74.125.82.54])
	by smtp-server.rit.edu (PMDF V6.3-x14 #31420)
	with ESMTP id <0L4Z00AWZSFVDX@smtp-server.rit.edu> for xfs@oss.sgi.com;
	Sat, 03 Jul 2010 13:26:19 -0400 (EDT)
Received: by wwb17 with SMTP id 17so1144170wwb.11 for <xfs@oss.sgi.com>; Sat,
	03 Jul 2010 10:26:19 -0700 (PDT)
Date: Sat, 03 Jul 2010 13:26:18 -0400
From: Andrew Ragone <ajr9166@rit.edu>
Subject: Volume Group and XFS Partition Recovery
Message-id: <AANLkTilPPMnasFD5b4_kgsF9uUZsjCtTMKaGmO4L7a3j@mail.gmail.com>
MIME-version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2669146757540353284=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============2669146757540353284==
Content-type: multipart/alternative;
 boundary="Boundary_(ID_Dge7vRomXSs48sggVdiknw)"


--Boundary_(ID_Dge7vRomXSs48sggVdiknw)
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT

Hey everyone:

I hope everyone's summers have been exciting so far. The other day mine had
a little hiccup thrown in there that I was hoping some of the bright members
of this group could shed some light on. Rundown of the problem is as
follows:

Alright so I have an XFS partition inside of a volume group on my server.
It's been configured as such for awhile and is functional. Regardless, I
recently added some drives and expanded the raid on my 3ware card
successfully from 14 TB to 20TB. Of course the next step is to expand the
partition and then the file system. (The partition lives in a Volume Group
in a Logical Volume). I have done this entire process once before
successfully without data loss when expanding from 10TB to 14TB but for some
reason it all blew up in my face this time. Commands used were similar to
this:

umount -a (unmount all partitions)

      vgchange -an (disable all volume groups)
      partprobe (reread partition tables on all disks)
      parted /dev/sda resize 1 0.017 267466 (resize the partition)
      partprobe (reread partition tables on all disks)
      pvresize /dev/<disk_partition> (resize the physical volume << seems to
be about the point this went awry)
      vgchange -ay (enable all volume groups)
      mount -a (remount all disk partitions)

Basically I've got things in this strange state where the partition
/dev/sda1 (being based off the logical block device for the raid) looks like
it has successfully expanded from End Cylinder 1945212 (previous config) to
267466 (using all 20 TB) but can't be mounted. It actually seems to have
initially disappeared from the volume group listing (correct me if this
terminology is wrong): initially the block device was mapped to
/dev/oasis/puddle yet /dev/oasis is now empty. So to "recapture" the
partition I tried to all a new v
  olume group now called vol0x that should house the /dev/sda1 physical
volume. Of course in /dev/oasis I show only /dev/oasis/vol0x and not
/dev/oasis/puddle

On this, my question is* can I reconfigure volume groups and logical volumes
on the fly in order to "recapture" the actual partition without affecting
the data?* If I am correct, the data is only a simple mapping in the GPT
table on the first sector of the drive.

Further, the actual volume group that houses the XFS file system now exists
as "lvm2pv" which I'm fairly certain needs to be "xfs". Should this be the
case?

I've shut down the machine so no data is accessed, attempted to be accessed,
etc. until I can get some ideas on recovery approach.

   - Basically, can anyone provide some insight on what order LVs, PVs, and
   VGs need to be configured to work properly?
   - What are some approaches to attempt to grab this data back?
      - Is anyone familiar with what xfs_repair does and how I might be able
      to apply it here?
      - Worse case scenario: having software such as TestDisk remap the file
      info, though I've read XFS is a huge pain in filesystem world to
do this on.

Somehow the mapping of the file system to the physical volume blew up and at
this point I think I just need to play with the pointers in the Logical
Volumes, Volume Groups, and file system types in the partition. But I have
had limited experience with this advanced of a problem and having to adapt 3
objects with the same parameters to work in unison and give me my data back
gets complicated very quickly and just wanted to see if there are a few
minds to bounce ideas off of and help out.

Thanks,
Andrew

--Boundary_(ID_Dge7vRomXSs48sggVdiknw)
Content-type: text/html; charset=ISO-8859-1
Content-transfer-encoding: quoted-printable

<span class=3D"Apple-style-span" style=3D"font-family: arial, sans-serif; f=
ont-size: 13px; border-collapse: collapse; ">Hey everyone:<div><br></div><d=
iv>I hope everyone&#39;s summers have been exciting so far. The other day m=
ine had a little hiccup thrown in there that I was hoping some of the brigh=
t members of this group could shed some light on. Rundown of the problem is=
 as follows:</div>
<div><br></div><div><span style=3D"font-family: &#39;lucida grande&#39;, ta=
homa, verdana, arial, sans-serif; color: rgb(51, 51, 51); "><div style=3D"d=
isplay: inline; ">Alright so I have an XFS partition inside of a volume gro=
up on my server. It&#39;s been configured as such for awhile and is functio=
nal. Regardless, I recently added some drives and expanded the raid on my 3=
ware card successfully from 14 TB to 20TB. Of course the next step is to ex=
pand the partition and then the file system. (The partition lives in a Volu=
me Group in a Logical Volume). I have done this entire process once before =
successfully without data loss when expanding from 10TB to 14TB but for som=
e reason it all blew up in my face this time. Commands used were similar to=
 this:</div>
</span></div><div><span style=3D"font-family: &#39;lucida grande&#39;, taho=
ma, verdana, arial, sans-serif; color: rgb(51, 51, 51); "><div style=3D"dis=
play: inline; "><br></div></span></div><blockquote style=3D"margin-top: 0px=
; margin-right: 0px; margin-bottom: 0px; margin-left: 40px; border-top-styl=
e: none; border-right-style: none; border-bottom-style: none; border-left-s=
tyle: none; border-width: initial; border-color: initial; padding-top: 0px;=
 padding-right: 0px; padding-bottom: 0px; padding-left: 0px; ">
<div><span style=3D"font-family: &#39;lucida grande&#39;, tahoma, verdana, =
arial, sans-serif; color: rgb(51, 51, 51); "><div style=3D"display: inline;=
 "><span style=3D"color: rgb(0, 0, 0); font-family: monospace; font-size: 1=
2px; line-height: 19px; ">umount -a (unmount all partitions)</span></div>
</span></div></blockquote><div><span style=3D"font-family: &#39;lucida gran=
de&#39;, tahoma, verdana, arial, sans-serif; color: rgb(51, 51, 51); "><div=
 style=3D"display: inline; "><span style=3D"color: rgb(0, 0, 0); font-famil=
y: monospace; font-size: 12px; line-height: 19px; ">=A0=A0 =A0 =A0vgchange =
-an (disable all volume groups)<br>
=A0=A0 =A0 =A0partprobe (reread partition tables on all disks)<br>=A0=A0 =
=A0 =A0parted /dev/sda resize 1 0.017 267466 (resize the partition)<br>=A0=
=A0 =A0 =A0partprobe (reread partition tables on all disks)<br>=A0=A0 =A0 =
=A0pvresize /dev/&lt;disk_partition&gt; (resize the physical volume &lt;&lt=
; seems to be about the point this went awry)<br>
=A0=A0 =A0 =A0vgchange -ay (enable all volume groups)<br>=A0=A0 =A0 =A0moun=
t -a (remount all disk partitions)</span></div></span></div><div><span styl=
e=3D"font-family: &#39;lucida grande&#39;, tahoma, verdana, arial, sans-ser=
if; color: rgb(51, 51, 51); "><div style=3D"display: inline; ">
<br>Basically I&#39;ve got things in this strange state where the=A0<span s=
tyle=3D"display: inline; ">partition /dev/sda1 (being based off the logical=
 block device for the raid) looks like it has successfully expanded from En=
d Cylinder 1945212 (previous config) to 267466 (using all 20 TB) but can&#3=
9;t be mounted. It actually seems to have initially disappeared from the vo=
lume group listing (correct me if this terminology is wrong): initially the=
 block device was mapped to /dev/oasis/puddle yet /dev/oasis is now empty. =
So to &quot;recapture&quot; the partition I tried to all a new v</span></di=
v>
=A0=A0</span><span style=3D"font-family: &#39;lucida grande&#39;, tahoma, v=
erdana, arial, sans-serif; color: rgb(51, 51, 51); ">olume group now called=
 vol0x that should house the /dev/sda1 physical volume. Of course in /dev/o=
asis I show only /dev/oasis/vol0x and not /dev/oasis/puddle</span></div>
<div><span style=3D"font-family: &#39;lucida grande&#39;, tahoma, verdana, =
arial, sans-serif; color: rgb(51, 51, 51); "><div style=3D"display: inline;=
 "><span style=3D"display: inline; "><br></span></div></span></div><blockqu=
ote style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin=
-left: 40px; border-top-style: none; border-right-style: none; border-botto=
m-style: none; border-left-style: none; border-width: initial; border-color=
: initial; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; paddi=
ng-left: 0px; ">
<div><span style=3D"font-family: &#39;lucida grande&#39;, tahoma, verdana, =
arial, sans-serif; color: rgb(51, 51, 51); "><div style=3D"display: inline;=
 "><span style=3D"display: inline; ">On this, my question is<b>=A0can I rec=
onfigure volume groups and logical volumes on the fly in order to &quot;rec=
apture&quot; the actual partition without affecting the data?</b>=A0If I am=
 correct, the data is only a simple mapping in the GPT table on the first s=
ector of the drive.=A0<br>
<br></span></div></span></div></blockquote><div><span style=3D"font-family:=
 &#39;lucida grande&#39;, tahoma, verdana, arial, sans-serif; color: rgb(51=
, 51, 51); "><div style=3D"display: inline; "><span style=3D"display: inlin=
e; ">Further, the actual volume group that houses the XFS file system now e=
xists as &quot;lvm2pv&quot; which I&#39;m fairly certain needs to be &quot;=
xfs&quot;. Should this be the case?<br>
<br></span></div></span></div><div><span style=3D"font-family: &#39;lucida =
grande&#39;, tahoma, verdana, arial, sans-serif; color: rgb(51, 51, 51); ">=
<div style=3D"display: inline; "><span style=3D"display: inline; ">I&#39;ve=
 shut down the machine so no data is accessed, attempted to be accessed, et=
c. until I can get some ideas on recovery approach.=A0<br>
<ul><li style=3D"margin-left: 15px; ">Basically, can anyone provide some in=
sight on what order LVs, PVs, and VGs need to be configured to work properl=
y?=A0</li><li style=3D"margin-left: 15px; ">What are some approaches to att=
empt to grab this data back?</li>
<ul><li style=3D"margin-left: 15px; ">Is anyone familiar with what xfs_repa=
ir does and how I might be able to apply it here?</li><li style=3D"margin-l=
eft: 15px; ">Worse case scenario: having software such as TestDisk remap th=
e file info, though I&#39;ve read XFS is a huge pain in filesystem world to=
 do this on.</li>
</ul></ul></span></div></span></div><div><span style=3D"font-family: &#39;l=
ucida grande&#39;, tahoma, verdana, arial, sans-serif; color: rgb(51, 51, 5=
1); ">Somehow the mapping of the file system to the physical volume blew up=
 and at this point I think I just need to play with the pointers in the Log=
ical Volumes, Volume Groups, and file system types in the partition. But I =
have had limited experience with this advanced of a problem and having to a=
dapt 3 objects with the same parameters to work in unison and give me my da=
ta back gets complicated very quickly and just wanted to see if there are a=
 few minds to bounce ideas off of and help out.=A0</span></div>
<div><span style=3D"font-family: &#39;lucida grande&#39;, tahoma, verdana, =
arial, sans-serif; color: rgb(51, 51, 51); "><br></span></div><div><span st=
yle=3D"font-family: &#39;lucida grande&#39;, tahoma, verdana, arial, sans-s=
erif; color: rgb(51, 51, 51); ">Thanks,</span></div>
<div><span style=3D"font-family: &#39;lucida grande&#39;, tahoma, verdana, =
arial, sans-serif; color: rgb(51, 51, 51); ">Andrew</span></div></span>

--Boundary_(ID_Dge7vRomXSs48sggVdiknw)--


--===============2669146757540353284==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2669146757540353284==--
