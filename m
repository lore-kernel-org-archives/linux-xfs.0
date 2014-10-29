Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 34DCB7F37
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 23:06:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2123430404E
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 21:06:15 -0700 (PDT)
Received: from mail-ob0-f175.google.com (mail-ob0-f175.google.com
	[209.85.214.175]) by cuda.sgi.com with ESMTP id
	uw5C2ozGqd0ckHG2 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 28 Oct 2014 21:06:11 -0700 (PDT)
Received: by mail-ob0-f175.google.com with SMTP id wm4so1757269obc.20
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 21:06:10 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 29 Oct 2014 12:06:10 +0800
Message-ID: <CAGdb-8cnmCs=L0RPvE8+5jn3nmZoviiZtQBbo9S-BThA+3cBKg@mail.gmail.com>
Subject: xfsrestore report SUCCESS but not restore all files in kernel 3.17
From: Tommy Wu <wu.tommy@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6129324070919442669=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs <xfs@oss.sgi.com>

--===============6129324070919442669==
Content-Type: multipart/alternative; boundary=001a113d37664ee00c050687e241

--001a113d37664ee00c050687e241
Content-Type: text/plain; charset=UTF-8

kernel 3.17.0 (same command in kernel 3.16.x work fine)
xfsdump 3.1.4
xfsprogs 3.2.1

test case:
1. create a new filesystem in LVM

lvcreate -L 5G -n test vg
mkfs.xfs -f /dev/vg/test
mount /dev/vg/test /mnt/x

2. extract linux-3.17.tar.xz to the new filesystem

cd /mnt/x
tar Jxvf /usr/src/linux-3.17.tar.xz

3. backup the filesystem

xfsdump -l 0 -o -p 300 -J -F -M test -L test - /mnt/x | /bin/gzip -qv >
/vol/test.xfsdump.gz

4. test the dump file, it show a lots of NOTE, and it said restore status
is SUCCESS.

cat /vol/test.xfsdump.gz | gzip -dqv | xfsrestore -p 300 -J -t - | grep
"^/sbin/xfsrestore:"
/sbin/xfsrestore: using file dump (drive_simple) strategy
/sbin/xfsrestore: version 3.1.4 (dump format 3.0)
/sbin/xfsrestore: searching media for dump
/sbin/xfsrestore: examining media file 0
/sbin/xfsrestore: dump description:
/sbin/xfsrestore: hostname: mail.teatime.com.tw
/sbin/xfsrestore: mount point: /mnt/x
/sbin/xfsrestore: volume: /dev/mapper/vg-test
/sbin/xfsrestore: session time: Wed Oct 29 11:45:54 2014
/sbin/xfsrestore: level: 0
/sbin/xfsrestore: session label: "test"
/sbin/xfsrestore: media label: "test"
/sbin/xfsrestore: file system id: d757277d-5167-4cdb-975d-c64b2f94a47e
/sbin/xfsrestore: session id: 6f114712-6fb6-4f35-a2f3-30ca1a0af5bb
/sbin/xfsrestore: media id: 2eb2ff54-1838-47b2-a8d5-5f520deaf5f5
/sbin/xfsrestore: searching media for directory dump
/sbin/xfsrestore: reading directories
/sbin/xfsrestore: 2035 directories and 33045 entries processed
/sbin/xfsrestore: directory post-processing
/sbin/xfsrestore: reading non-directory files
/sbin/xfsrestore: NOTE: ino 144 salvaging file, placing in
orphanage/143.0/Makefile
/sbin/xfsrestore: NOTE: ino 145 salvaging file, placing in
orphanage/143.0/bayer.png.b64
/sbin/xfsrestore: NOTE: ino 146 salvaging file, placing in
orphanage/143.0/constraints.png.b64
/sbin/xfsrestore: NOTE: ino 147 salvaging file, placing in
orphanage/143.0/crop.gif.b64
/sbin/xfsrestore: NOTE: ino 148 salvaging file, placing in
orphanage/143.0/dvbstb.png.b64
/sbin/xfsrestore: NOTE: ino 149 salvaging file, placing in
orphanage/143.0/fieldseq_bt.gif.b64
/sbin/xfsrestore: NOTE: ino 150 salvaging file, placing in
orphanage/143.0/fieldseq_tb.gif.b64
.... skip it....
/sbin/xfsrestore: NOTE: ino 50363235 gen 1622742662 not referenced: placing
in orphanage
/sbin/xfsrestore: table of contents display complete: 3 seconds elapsed
/sbin/xfsrestore: Restore Status: SUCCESS

5. restore it, show a lots of NOTE, and resotre status is SUCCESS, but...
compare them, it's different.

cat test.xfsdump.gz | gzip -dqv | xfsrestore -p 300 -J - /vol/x/
/sbin/xfsrestore: using file dump (drive_simple) strategy
/sbin/xfsrestore: version 3.1.4 (dump format 3.0)
/sbin/xfsrestore: searching media for dump
/sbin/xfsrestore: examining media file 0
/sbin/xfsrestore: dump description:
/sbin/xfsrestore: hostname: mail.teatime.com.tw
/sbin/xfsrestore: mount point: /mnt/x
/sbin/xfsrestore: volume: /dev/mapper/vg-test
/sbin/xfsrestore: session time: Wed Oct 29 11:45:54 2014
/sbin/xfsrestore: level: 0
/sbin/xfsrestore: session label: "test"
/sbin/xfsrestore: media label: "test"
/sbin/xfsrestore: file system id: d757277d-5167-4cdb-975d-c64b2f94a47e
/sbin/xfsrestore: session id: 6f114712-6fb6-4f35-a2f3-30ca1a0af5bb
/sbin/xfsrestore: media id: 2eb2ff54-1838-47b2-a8d5-5f520deaf5f5
/sbin/xfsrestore: searching media for directory dump
/sbin/xfsrestore: reading directories
/sbin/xfsrestore: 2035 directories and 33045 entries processed
/sbin/xfsrestore: directory post-processing
/sbin/xfsrestore: restoring non-directory files
/sbin/xfsrestore: NOTE: ino 144 salvaging file, placing in
orphanage/143.0/Makefile
/sbin/xfsrestore: NOTE: ino 145 salvaging file, placing in
orphanage/143.0/bayer.png.b64
/sbin/xfsrestore: NOTE: ino 146 salvaging file, placing in
orphanage/143.0/constraints.png.b64
.... skip it....
/sbin/xfsrestore: NOTE: ino 50363235 gen 1622742662 not referenced: placing
in orphanage
/sbin/xfsrestore: WARNING: unable to rmdir /vol/x//orphanage: Directory not
empty
/sbin/xfsrestore: restore complete: 3 seconds elapsed
/sbin/xfsrestore: Restore Status: SUCCESS


-- 

Tommy Wu

--001a113d37664ee00c050687e241
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br>kernel 3.17.0 (same command in kernel 3.16.x work fine=
)<br>xfsdump 3.1.4<br>xfsprogs 3.2.1<br><br>test case:<br>1. create a new f=
ilesystem in LVM<br><br>lvcreate -L 5G -n test vg<br>mkfs.xfs -f /dev/vg/te=
st<br>mount /dev/vg/test /mnt/x<br><br>2. extract linux-3.17.tar.xz to the =
new filesystem<br><br>cd /mnt/x<br>tar Jxvf /usr/src/linux-3.17.tar.xz<br><=
br>3. backup the filesystem<br><br>xfsdump -l 0 -o -p 300 -J -F -M test -L =
test - /mnt/x | /bin/gzip -qv &gt; /vol/test.xfsdump.gz<br><br>4. test the =
dump file, it show a lots of NOTE, and it said restore status is SUCCESS.<b=
r><br>cat /vol/test.xfsdump.gz | gzip -dqv | xfsrestore -p 300 -J -t - | gr=
ep &quot;^/sbin/xfsrestore:&quot;<br>/sbin/xfsrestore: using file dump (dri=
ve_simple) strategy<br>/sbin/xfsrestore: version 3.1.4 (dump format 3.0)<br=
>/sbin/xfsrestore: searching media for dump<br>/sbin/xfsrestore: examining =
media file 0<br>/sbin/xfsrestore: dump description:<br>/sbin/xfsrestore: ho=
stname: <a href=3D"http://mail.teatime.com.tw">mail.teatime.com.tw</a><br>/=
sbin/xfsrestore: mount point: /mnt/x<br>/sbin/xfsrestore: volume: /dev/mapp=
er/vg-test<br>/sbin/xfsrestore: session time: Wed Oct 29 11:45:54 2014<br>/=
sbin/xfsrestore: level: 0<br>/sbin/xfsrestore: session label: &quot;test&qu=
ot;<br>/sbin/xfsrestore: media label: &quot;test&quot;<br>/sbin/xfsrestore:=
 file system id: d757277d-5167-4cdb-975d-c64b2f94a47e<br>/sbin/xfsrestore: =
session id: 6f114712-6fb6-4f35-a2f3-30ca1a0af5bb<br>/sbin/xfsrestore: media=
 id: 2eb2ff54-1838-47b2-a8d5-5f520deaf5f5<br>/sbin/xfsrestore: searching me=
dia for directory dump<br>/sbin/xfsrestore: reading directories<br>/sbin/xf=
srestore: 2035 directories and 33045 entries processed<br>/sbin/xfsrestore:=
 directory post-processing<br>/sbin/xfsrestore: reading non-directory files=
<br>/sbin/xfsrestore: NOTE: ino 144 salvaging file, placing in orphanage/14=
3.0/Makefile<br>/sbin/xfsrestore: NOTE: ino 145 salvaging file, placing in =
orphanage/143.0/bayer.png.b64<br>/sbin/xfsrestore: NOTE: ino 146 salvaging =
file, placing in orphanage/143.0/constraints.png.b64<br>/sbin/xfsrestore: N=
OTE: ino 147 salvaging file, placing in orphanage/143.0/crop.gif.b64<br>/sb=
in/xfsrestore: NOTE: ino 148 salvaging file, placing in orphanage/143.0/dvb=
stb.png.b64<br>/sbin/xfsrestore: NOTE: ino 149 salvaging file, placing in o=
rphanage/143.0/fieldseq_bt.gif.b64<br>/sbin/xfsrestore: NOTE: ino 150 salva=
ging file, placing in orphanage/143.0/fieldseq_tb.gif.b64<br>.... skip it..=
..<br>/sbin/xfsrestore: NOTE: ino 50363235 gen 1622742662 not referenced: p=
lacing in orphanage<br>/sbin/xfsrestore: table of contents display complete=
: 3 seconds elapsed<br>/sbin/xfsrestore: Restore Status: SUCCESS<br><br>5. =
restore it, show a lots of NOTE, and resotre status is SUCCESS, but... comp=
are them, it&#39;s different.<br><br>cat test.xfsdump.gz | gzip -dqv | xfsr=
estore -p 300 -J - /vol/x/<br>/sbin/xfsrestore: using file dump (drive_simp=
le) strategy<br>/sbin/xfsrestore: version 3.1.4 (dump format 3.0)<br>/sbin/=
xfsrestore: searching media for dump<br>/sbin/xfsrestore: examining media f=
ile 0<br>/sbin/xfsrestore: dump description:<br>/sbin/xfsrestore: hostname:=
 <a href=3D"http://mail.teatime.com.tw">mail.teatime.com.tw</a><br>/sbin/xf=
srestore: mount point: /mnt/x<br>/sbin/xfsrestore: volume: /dev/mapper/vg-t=
est<br>/sbin/xfsrestore: session time: Wed Oct 29 11:45:54 2014<br>/sbin/xf=
srestore: level: 0<br>/sbin/xfsrestore: session label: &quot;test&quot;<br>=
/sbin/xfsrestore: media label: &quot;test&quot;<br>/sbin/xfsrestore: file s=
ystem id: d757277d-5167-4cdb-975d-c64b2f94a47e<br>/sbin/xfsrestore: session=
 id: 6f114712-6fb6-4f35-a2f3-30ca1a0af5bb<br>/sbin/xfsrestore: media id: 2e=
b2ff54-1838-47b2-a8d5-5f520deaf5f5<br>/sbin/xfsrestore: searching media for=
 directory dump<br>/sbin/xfsrestore: reading directories<br>/sbin/xfsrestor=
e: 2035 directories and 33045 entries processed<br>/sbin/xfsrestore: direct=
ory post-processing<br>/sbin/xfsrestore: restoring non-directory files<br>/=
sbin/xfsrestore: NOTE: ino 144 salvaging file, placing in orphanage/143.0/M=
akefile<br>/sbin/xfsrestore: NOTE: ino 145 salvaging file, placing in orpha=
nage/143.0/bayer.png.b64<br>/sbin/xfsrestore: NOTE: ino 146 salvaging file,=
 placing in orphanage/143.0/constraints.png.b64<br>.... skip it....<br>/sbi=
n/xfsrestore: NOTE: ino 50363235 gen 1622742662 not referenced: placing in =
orphanage<br>/sbin/xfsrestore: WARNING: unable to rmdir /vol/x//orphanage: =
Directory not empty<br>/sbin/xfsrestore: restore complete: 3 seconds elapse=
d<br>/sbin/xfsrestore: Restore Status: SUCCESS<br><br clear=3D"all"><br>-- =
<br><div class=3D"gmail_signature"><br>Tommy Wu</div>
</div>

--001a113d37664ee00c050687e241--


--===============6129324070919442669==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6129324070919442669==--
