Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9V50eZ6108125 for <xfs@oss.sgi.com>; Wed, 31 Oct 2012 00:00:40 -0500
Received: from mail-vc0-f181.google.com (mail-vc0-f181.google.com
	[209.85.220.181]) by cuda.sgi.com with ESMTP id
	PYEiksnrKZlgfovS (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 30 Oct 2012 22:02:29 -0700 (PDT)
Received: by mail-vc0-f181.google.com with SMTP id n11so1298425vch.26
	for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 22:02:28 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 30 Oct 2012 22:02:28 -0700
Message-ID: <CABJyUz+h=pZ6+2rro1PjoB1ggTAoRw+bTzc_bU7Eaec0_AUKLA@mail.gmail.com>
Subject: XFS filesystem recovery from secondary superblocks
From: Aaron Goulding <aarongldng@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8850122215824148357=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8850122215824148357==
Content-Type: multipart/alternative; boundary=20cf307f3bcc2a001104cd53cf27

--20cf307f3bcc2a001104cd53cf27
Content-Type: text/plain; charset=ISO-8859-1

Hello! So I have an XFS filesystem that isn't mounting, and quite a long
story as to why and what I've tried.

And before you start, yes backups are the preferred method of restoration
at this point. Never trust your files to a single FS, etc.

So I have a 9 disk MD array (0.9 superblock format, total usable space
14TB) configured as an LVM PV, one VG, then one LV with not quite all the
space allocated. That LV is formatted XFS and mounted as /mnt/storage. This
was started on Ubuntu 10.04 which has been release-upgraded to 12.04. The
LV has been grown 3 times over the last two years. The system's boot, root
and swap partitions are on a separate drive.

So what happened? Well one drive died spectacularly. It had a full bearing
failure which caused a power drain and the system kicked out two more
drives instantly. This put the array into an offline state as expected. I
replaced the failed drive with a new one, and checked carefully the disk
order, before attempting to re-assemble the array. At the time, I didn't
know about mdadm --re-add. (Likely my first mistake)

mdadm --create --assume-clean --level=6 --raid-devices=9 /dev/md0 /dev/sdg1
missing /dev/sdh1 /dev/sdj1 /dev/sdd1 /dev/sdb1 /dev/sde1 /dev/sdf1
/dev/sdc1

The first problem with this is that the update to Ubuntu meant it created
the superblocks as 1.2 instead of 0.9. Not catching this, I then added in
the replacement /dev/sdi1. This started the array rebuilding incorrectly. I
quickly realized my mistake and stopped the array, then recreated again,
this time using superblock 0.9 format, but the damage had already been done
to roughly the first 100GB of the array, possibly more.

I attempted to restore the lvm superblock from the backup stored in
/etc/lvm/backup/

pvcreate -f -vv --uuid "hJrAn2-wTd8-vY11-steD-23Jh-AwKK-4VvnkH"
--restorefile /etc/lvm/backup/vg1 /dev/md0

When that failed, I decided to attach a second array so I could more safely
examine the problem. I built a second MD array with 7 3T disks in RAID6,
giving me a 15TB /mnt/restore volume to work with. I made a dd copy of
/dev/md0 to a test file I could manipulate safely.

Once I had the file created, I tried xfs_clean -f /mnt/restore/md0.dat to
no luck. I used a hex editor to add XFSB to be beginning, hoping the
recovery would just clean around the LVM data with similar results. The
result looks like the following:

Phase 1 - find and verify superblock...
bad primary superblock - bad or unsupported version !!!

attempting to find secondary superblock...
....................................................................................................
unable to verify superblock, continuing...
....................................................................................................
unable to verify superblock, continuing...
....................................................................................................
unable to verify superblock, continuing...
....................................................................................................
unable to verify superblock, continuing...
....................................................................................................
unable to verify superblock, continuing...
....................................................................................................
unable to verify superblock, continuing...
....................................................................................................
unable to verify superblock, continuing...
....................................................................................................
unable to verify superblock, continuing...
....................................................................................................
unable to verify superblock, continuing...
....................................................................................................
unable to verify superblock, continuing...
....................................................................................................
Exiting now.

running xfs_db /mnt/restore/md0.dat would appear to run out of memory.

So I realized I needed to pull the data out of LVM and re-assemble it
properly if I was going to make any progress. So I checked the backup
config again:

# Generated by LVM2 version 2.02.66(2) (2010-05-20): Sun Jul 29 13:40:58
2012

contents = "Text Format Volume Group"
version = 1

description = "Created *after* executing 'vgcfgbackup'"

creation_host = "jarvis"        # Linux jarvis 3.0.0-23-server #39-Ubuntu
SMP Thu Jul 19 19:37:41 UTC 2012 x86_64
creation_time = 1343594458      # Sun Jul 29 13:40:58 2012

vg1 {
        id = "hJrAn2-wTd8-vY11-steD-23Jh-AwKK-4VvnkH"
        seqno = 19
        status = ["RESIZEABLE", "READ", "WRITE"]
        flags = []
        extent_size = 8192              # 4 Megabytes
        max_lv = 0
        max_pv = 0

        physical_volumes {

                pv0 {
                        id = "VRHqH4-oIje-iQWV-iLUL-dLXX-eEf9-mLd9Z7"
                        device = "/dev/md0"     # Hint only

                        status = ["ALLOCATABLE"]
                        flags = []
                        dev_size = 27349166336  # 12.7354 Terabytes
                        pe_start = 768
                        pe_count = 3338521      # 12.7354 Terabytes
                }
        }

        logical_volumes {

                storage {
                        id = "H47IMn-ohEG-3W6l-NfCu-ePjJ-U255-FcIjdp"
                        status = ["READ", "WRITE", "VISIBLE"]
                        flags = []
                        segment_count = 4

                        segment1 {
                                start_extent = 0
                                extent_count = 2145769  # 8.18546 Terabytes

                                type = "striped"
                                stripe_count = 1        # linear

                                stripes = [
                                        "pv0", 25794
                                ]
                        }
                        segment2 {
                                start_extent = 2145769
                                extent_count = 626688   # 2.39062 Terabytes

                                type = "striped"
                                stripe_count = 1        # linear

                                stripes = [
                                        "pv0", 2174063
                                ]
                        }
                        segment3 {
                                start_extent = 2772457
                                extent_count = 384170   # 1.46549 Terabytes

                                type = "striped"
                                stripe_count = 1        # linear

                                stripes = [
                                        "pv0", 2954351
                                ]
                        }
                        segment4 {
                                start_extent = 3156627
                                extent_count = 140118   # 547.336 Gigabytes

                                type = "striped"
                                stripe_count = 1        # linear

                                stripes = [
                                        "pv0", 2800751
                                ]
                        }
                }
        }
}

So I noticed segment4 comes before segment3 (based off stripes = [
"pv0",2800751 ]) and standard extent size was 4MB, so I wrote the following:

echo "writing seg 1 .."
dd if=/dev/md0 of=/dev/md1 bs=4194304 seek=0 skip=25794 count=2145769

echo "writing seg 2 .."
dd if=/dev/md0 of=/dev/md1 bs=4194304 seek=2145769 skip=2174063 count=626688

echo "writing seg 3 .."
dd if=/dev/md0 of=/dev/md1 bs=4194304 seek=2772457 skip=2954351 count=384170

echo "writing seg 4 .."
dd if=/dev/md0 of=/dev/md1 bs=4194304 seek=3156627 skip=2800751 count=140118

then just to make sure things were clean, I zeroed out the remainder of
/dev/md1

I used the hex editor (shed) again to make sure the first four bytes on the
drive are XFSB.

Once done, I tried xfs_repair again, this time on /dev/md1 with the same
results as above.

Next I tried xfs_db /dev/md1 to see if anything would load. I get the
following:

root@jarvis:/mnt# xfs_db /dev/md1
Floating point exception

With the following in dmesg:

[1568395.691767] xfs_db[30966] trap divide error ip:41e4b5 sp:7fff5db8ab90
error:0 in xfs_db[400000+6a000]


So at this point I'm stumped. I'm hoping one of you clever folks out there
might have some next steps I can take. I'm okay with a partial recovery,
and I'm okay if the directory tree gets horked and I have to dig through
lost+found, but I'd really like to at least be able to recover something
from this. I'm happy to post any info needed on this.

Thanks!

-Aaron

--20cf307f3bcc2a001104cd53cf27
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello! So I have an XFS filesystem that isn&#39;t mounting, and quite a lon=
g story as to why and what I&#39;ve tried. <br><br>And before you start, ye=
s backups are the preferred method of restoration at this point. Never trus=
t your files to a single FS, etc.<br>
<br>So I have a 9 disk MD array (0.9 superblock format, total usable space =
14TB) configured as an LVM PV, one VG, then one LV with not quite all the s=
pace allocated. That LV is formatted XFS and mounted as /mnt/storage. This =
was started on Ubuntu 10.04 which has been release-upgraded to 12.04. The L=
V has been grown 3 times over the last two years. The system&#39;s boot, ro=
ot and swap partitions are on a separate drive. <br>
<br>So what happened? Well one drive died spectacularly. It had a full bear=
ing failure which caused a power drain and the system kicked out two more d=
rives instantly. This put the array into an offline state as expected. I re=
placed the failed drive with a new one, and checked carefully the disk orde=
r, before attempting to re-assemble the array. At the time, I didn&#39;t kn=
ow about mdadm --re-add. (Likely my first mistake)<br>
<br>mdadm --create --assume-clean --level=3D6 --raid-devices=3D9 /dev/md0 /=
dev/sdg1 missing /dev/sdh1 /dev/sdj1 /dev/sdd1 /dev/sdb1 /dev/sde1 /dev/sdf=
1 /dev/sdc1<br><br>The first problem with this is that the update to Ubuntu=
 meant it created the superblocks as 1.2 instead of 0.9. Not catching this,=
 I then added in the replacement /dev/sdi1. This started the array rebuildi=
ng incorrectly. I quickly realized my mistake and stopped the array, then r=
ecreated again, this time using superblock 0.9 format, but the damage had a=
lready been done to roughly the first 100GB of the array, possibly more. <b=
r>
<br>I attempted to restore the lvm superblock from the backup stored in /et=
c/lvm/backup/<br><br>pvcreate -f -vv --uuid &quot;hJrAn2-wTd8-vY11-steD-23J=
h-AwKK-4VvnkH&quot; --restorefile /etc/lvm/backup/vg1 /dev/md0<br><br>When =
that failed, I decided to attach a second array so I could more safely exam=
ine the problem. I built a second MD array with 7 3T disks in RAID6, giving=
 me a 15TB /mnt/restore volume to work with. I made a dd copy of /dev/md0 t=
o a test file I could manipulate safely.<br>
<br>Once I had the file created, I tried xfs_clean -f /mnt/restore/md0.dat =
to no luck. I used a hex editor to add XFSB to be beginning, hoping the rec=
overy would just clean around the LVM data with similar results. The result=
 looks like the following:<br>
<br>Phase 1 - find and verify superblock...<br>bad primary superblock - bad=
 or unsupported version !!!<br><br>attempting to find secondary superblock.=
..<br>.....................................................................=
...............................<br>
unable to verify superblock, continuing...<br>.............................=
.......................................................................<br>=
unable to verify superblock, continuing...<br>.............................=
.......................................................................<br>
unable to verify superblock, continuing...<br>.............................=
.......................................................................<br>=
unable to verify superblock, continuing...<br>.............................=
.......................................................................<br>
unable to verify superblock, continuing...<br>.............................=
.......................................................................<br>=
unable to verify superblock, continuing...<br>.............................=
.......................................................................<br>
unable to verify superblock, continuing...<br>.............................=
.......................................................................<br>=
unable to verify superblock, continuing...<br>.............................=
.......................................................................<br>
unable to verify superblock, continuing...<br>.............................=
.......................................................................<br>=
unable to verify superblock, continuing...<br>.............................=
.......................................................................<br>
Exiting now.<br><br>running xfs_db /mnt/restore/md0.dat would appear to run=
 out of memory.<br><br>So I realized I needed to pull the data out of LVM a=
nd re-assemble it properly if I was going to make any progress. So I checke=
d the backup config again:<br>
<br># Generated by LVM2 version 2.02.66(2) (2010-05-20): Sun Jul 29 13:40:5=
8 2012<br><br>contents =3D &quot;Text Format Volume Group&quot;<br>version =
=3D 1<br><br>description =3D &quot;Created *after* executing &#39;vgcfgback=
up&#39;&quot;<br>
<br>creation_host =3D &quot;jarvis&quot;=A0=A0=A0=A0=A0=A0=A0 # Linux jarvi=
s 3.0.0-23-server #39-Ubuntu SMP Thu Jul 19 19:37:41 UTC 2012 x86_64<br>cre=
ation_time =3D 1343594458=A0=A0=A0=A0=A0 # Sun Jul 29 13:40:58 2012<br><br>=
vg1 {<br>=A0=A0=A0=A0=A0=A0=A0 id =3D &quot;hJrAn2-wTd8-vY11-steD-23Jh-AwKK=
-4VvnkH&quot;<br>
=A0=A0=A0=A0=A0=A0=A0 seqno =3D 19<br>=A0=A0=A0=A0=A0=A0=A0 status =3D [&qu=
ot;RESIZEABLE&quot;, &quot;READ&quot;, &quot;WRITE&quot;]<br>=A0=A0=A0=A0=
=A0=A0=A0 flags =3D []<br>=A0=A0=A0=A0=A0=A0=A0 extent_size =3D 8192=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 # 4 Megabytes<br>=A0=A0=A0=A0=A0=A0=A0 ma=
x_lv =3D 0<br>=A0=A0=A0=A0=A0=A0=A0 max_pv =3D 0<br>
<br>=A0=A0=A0=A0=A0=A0=A0 physical_volumes {<br><br>=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 pv0 {<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 id =3D &quot;VRHqH4-oIje-iQWV-iLUL-dLXX-eEf9=
-mLd9Z7&quot;<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 device =3D &quot;/dev/md0&quot;=A0=A0=A0=A0 # Hint only<br><br=
>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 statu=
s =3D [&quot;ALLOCATABLE&quot;]<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 flags =3D []<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_size =3D 27349166336=A0 # 12=
.7354 Terabytes<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 pe_start =3D 768<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pe_count =3D 3338521=A0=A0=A0=A0=A0 # 12.735=
4 Terabytes<br>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }<br>=A0=A0=A0=A0=A0=A0=A0 }<=
br><br>=A0=A0=A0=A0=A0=A0=A0 logical_volumes {<br><br>=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 storage {<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 id =3D &quot;H47IMn-ohEG-3W6l-NfCu-ePjJ-U=
255-FcIjdp&quot;<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 status =3D [&quot;READ&quot;, &quot;WRITE&quot;, &quot;VISI=
BLE&quot;]<br>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 flags=
 =3D []<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 segment_count =3D 4<br><br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 segment1 {<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 start_exten=
t =3D 0<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 extent_count =3D 2145769=A0 # 8.18546 Teraby=
tes<br>
<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 type =3D &quot;striped&quot;<br>=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 stripe_count =3D 1=A0=A0=A0=A0=A0=A0=A0 # linear<br><br>=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 stripes =3D [<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 &quot;pv0&quot=
;, 25794<br>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 ]<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 }<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 segment2 {<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 start_extent =3D 214576=
9<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 extent_count =3D 626688=A0=A0 # 2.39062 Terabytes<=
br>
<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 type =3D &quot;striped&quot;<br>=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 stripe_count =3D 1=A0=A0=A0=A0=A0=A0=A0 # linear<br><br>=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 stripes =3D [<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 &quot;pv0&quot=
;, 2174063<br>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 ]<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 }<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 segment3 {<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 start_extent =3D 277245=
7<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 extent_count =3D 384170=A0=A0 # 1.46549 Terabytes<=
br>
<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 type =3D &quot;striped&quot;<br>=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 stripe_count =3D 1=A0=A0=A0=A0=A0=A0=A0 # linear<br><br>=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 stripes =3D [<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 &quot;pv0&quot=
;, 2954351<br>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 ]<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 }<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 segment4 {<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 start_extent =3D 315662=
7<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 extent_count =3D 140118=A0=A0 # 547.336 Gigabytes<=
br>
<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 type =3D &quot;striped&quot;<br>=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 stripe_count =3D 1=A0=A0=A0=A0=A0=A0=A0 # linear<br><br>=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 stripes =3D [<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 &quot;pv0&quot=
;, 2800751<br>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 ]<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 }<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }<br>=
=A0=A0=A0=A0=A0=A0=A0 }<br>}<br><br>So I noticed segment4 comes before segm=
ent3 (based off stripes =3D [ &quot;pv0&quot;,2800751 ]) and standard exten=
t size was 4MB, so I wrote the following:<br>
<br>echo &quot;writing seg 1 ..&quot;<br>dd if=3D/dev/md0 of=3D/dev/md1 bs=
=3D4194304 seek=3D0 skip=3D25794 count=3D2145769<br><br>echo &quot;writing =
seg 2 ..&quot;<br>dd if=3D/dev/md0 of=3D/dev/md1 bs=3D4194304 seek=3D214576=
9 skip=3D2174063 count=3D626688<br>
<br>echo &quot;writing seg 3 ..&quot;<br>dd if=3D/dev/md0 of=3D/dev/md1 bs=
=3D4194304 seek=3D2772457 skip=3D2954351 count=3D384170<br><br>echo &quot;w=
riting seg 4 ..&quot;<br>dd if=3D/dev/md0 of=3D/dev/md1 bs=3D4194304 seek=
=3D3156627 skip=3D2800751 count=3D140118<br>
<br>then just to make sure things were clean, I zeroed out the remainder of=
 /dev/md1<br><br>I used the hex editor (shed) again to make sure the first =
four bytes on the drive are XFSB.<br><br>Once done, I tried xfs_repair agai=
n, this time on /dev/md1 with the same results as above.<br>
<br>Next I tried xfs_db /dev/md1 to see if anything would load. I get the f=
ollowing:<br><br>root@jarvis:/mnt# xfs_db /dev/md1<br>Floating point except=
ion<br><br>With the following in dmesg:<br><br>[1568395.691767] xfs_db[3096=
6] trap divide error ip:41e4b5 sp:7fff5db8ab90 error:0 in xfs_db[400000+6a0=
00]<br>
<br><br>So at this point I&#39;m stumped. I&#39;m hoping one of you clever =
folks out there might have some next steps I can take. I&#39;m okay with a =
partial recovery, and I&#39;m okay if the directory tree gets horked and I =
have to dig through lost+found, but I&#39;d really like to at least be able=
 to recover something from this. I&#39;m happy to post any info needed on t=
his.<br>
<br>Thanks!<br><br>-Aaron<br>

--20cf307f3bcc2a001104cd53cf27--


--===============8850122215824148357==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8850122215824148357==--
