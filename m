Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0OHxBfP060296 for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 11:59:12 -0600
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	P5LExPAC5Q9yj0JK (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Jan 2012 09:59:10 -0800 (PST)
Received: by iakl21 with SMTP id l21so4786108iak.26
	for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 09:59:09 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 24 Jan 2012 09:59:09 -0800
Message-ID: <CAO4DVWoqgswvcSWii9uy6zuFyczVGQXFJjbgPi4XiMx+5cw2cA@mail.gmail.com>
Subject: Partially corrupted raid array beneath xfs
From: Christopher Evans <christophere@luma-pictures.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2614147184527658741=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============2614147184527658741==
Content-Type: multipart/alternative; boundary=14dae9340c3d641ab804b749e703

--14dae9340c3d641ab804b749e703
Content-Type: text/plain; charset=ISO-8859-1

I made a mistake by recreating a raid 6 array, instead of taking the proper
steps to rebuild it. Is there a way I can get find out which directories,
files are/might be corrupted if 64k blocks of data offset every 21 times
for an unknown count. Unfortunetly I've already mounted the raid array and
have gotten xfs errors because of the corrupted data beneath it.

OS: Centos 5.5 64bit 2.6.18-194.el5
kmod-xfs: 0.4-2
xfsprogs: 2.9.4-1.el5.centos

I ran mdadm --create /dev/md0 --level=6 --raid-devices=23 /dev/sda /dev/sdb
/dev/sdc /dev/sdd /dev/sdf /dev/sdg /dev/sdh /dev/sdi /dev/sdj /dev/sdk
/dev/sdl /dev/sdm /dev/sdn /dev/sdo /dev/sdp /dev/sdq /dev/sdr /dev/sds
/dev/sdt /dev/sdu /dev/sdv /dev/sdw /dev/sdx, and then 5 minutes later set
the drive I replaces as faulty with mdadm --manage --set-faulty /dev/md0
/dev/sdm. This should result in 64k every 21 times being random data, for 5
minutes worth of raid rebuild ( which took ~20-30 hours to rebuild ).

In my testing with a vm with 4 drives in raid 6, I believe I only corrupted
the first 5 minutes of raid rebuild. After I create a raid 6 array, I would
dd if=/dev/zero of=/dev/md0. Then I would set a data drive to faultly, and
remove it. Running hexdump on it would result in all zeros. To give
different data I would dd if=/dev/urandom of=/dev/removed_drive. When I
recreate the array, it would recognize that three of the drives had been in
an array already and ask if I want to continue. Since I said yes it would
use the data that would be for the data drives it seems. If I then set the
drive with randomized data to faulty during the rebuild, it would seem to
continue the rebuild as if the drive was failed/missing. When I would add
the drive back, it would rebuild the array again. The beginning of the
corrupted drive would still show random data, but data further down the
disk would show zeros.

--14dae9340c3d641ab804b749e703
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I made a mistake by recreating a raid 6 array, instead of taking the proper=
 steps to rebuild it. Is there a way I can get find out which directories, =
files are/might be corrupted if 64k blocks of data offset every 21 times fo=
r an unknown count. Unfortunetly I&#39;ve already mounted the raid array an=
d have gotten xfs errors because of the corrupted data beneath it.<div>
<br></div><div>OS: Centos 5.5 64bit=A02.6.18-194.el5</div><div>kmod-xfs: 0.=
4-2</div><div>xfsprogs: 2.9.4-1.el5.centos<br><div><br></div><div>I ran=A0m=
dadm --create /dev/md0 --level=3D6 --raid-devices=3D23 /dev/sda /dev/sdb /d=
ev/sdc /dev/sdd /dev/sdf /dev/sdg /dev/sdh /dev/sdi /dev/sdj /dev/sdk /dev/=
sdl /dev/sdm /dev/sdn /dev/sdo /dev/sdp /dev/sdq /dev/sdr /dev/sds /dev/sdt=
 /dev/sdu /dev/sdv /dev/sdw /dev/sdx, and then 5 minutes later set the driv=
e I replaces as faulty with=A0mdadm --manage --set-faulty /dev/md0 /dev/sdm=
. This should result in 64k every 21 times being random data, for 5 minutes=
 worth of raid rebuild ( which took ~20-30 hours to rebuild ).</div>

<div><br></div><div>In my testing with a vm with 4 drives in raid 6, I beli=
eve I only corrupted the first 5 minutes of raid rebuild. After I create a =
raid 6 array, I would dd if=3D/dev/zero of=3D/dev/md0. Then I would set a d=
ata drive to faultly, and remove it. Running hexdump on it would result in =
all zeros. To give different data I would dd if=3D/dev/urandom of=3D/dev/re=
moved_drive. When I recreate the array, it would recognize that three of th=
e drives had been in an array already and ask if I want to continue. Since =
I said yes it would use the data that would be for the data drives it seems=
. If I then set the drive with randomized data to faulty during the rebuild=
, it would seem to continue the rebuild as if the drive was failed/missing.=
 When I would add the drive back, it would rebuild the array again. The beg=
inning of the corrupted drive would still show random data, but data furthe=
r down the disk would show zeros.</div>

</div>

--14dae9340c3d641ab804b749e703--


--===============2614147184527658741==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2614147184527658741==--
