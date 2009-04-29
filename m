Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3T3eL8Q142895 for <xfs@oss.sgi.com>; Tue, 28 Apr 2009 22:40:22 -0500
Received: from qw-out-1920.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D15AF1459DCC
	for <xfs@oss.sgi.com>; Tue, 28 Apr 2009 20:43:42 -0700 (PDT)
Received: from qw-out-1920.google.com (qw-out-1920.google.com [74.125.92.144])
	by cuda.sgi.com with ESMTP id 1w5uQYwb8yTqHk8V for
	<xfs@oss.sgi.com>; Tue, 28 Apr 2009 20:43:42 -0700 (PDT)
Received: by qw-out-1920.google.com with SMTP id 4so808928qwk.32
	for <xfs@oss.sgi.com>; Tue, 28 Apr 2009 20:40:19 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 28 Apr 2009 23:40:19 -0400
Message-ID: <ff2243530904282040i1bb2cf12v3a329b045edf2f50@mail.gmail.com>
Subject: xfs_repair Input/output error
From: Cory Coager <ccoager@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9176173275803336237=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============9176173275803336237==
Content-Type: multipart/alternative; boundary=00163646d0bea7ebfa0468a95651

--00163646d0bea7ebfa0468a95651
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

I had a power failure while I was running a defrag on an xfs partition. Now
I am unable to mount, xfs_check or xfs_repair the partition. The partition
is lvm and all other partitions seem to be fine except this one. When
attempting to mount the partition the drive makes some funny noises and
these messages spit out on the console:

hda: dma_intr: status=0x51 { DriveReady SeekComplete Error }
hda: dma_intr: error=0x40 { UncorrectableError }, LBAsect=268552872,
high=16, low=117416, sector=268552868
ide: failed opcode was: unknown
end_request: I/O error, dev hda, sector 268552868

I believe the drive is fine because check_ide_smart reports:

Id=  1, Status=11 {PreFailure , OnLine }, Value=100, Threshold= 60, Passed
Id=  2, Status= 5 {PreFailure , OffLine}, Value=100, Threshold= 50, Passed
Id=  3, Status= 7 {PreFailure , OnLine }, Value=151, Threshold= 24, Passed
Id=  4, Status=18 {Advisory    , OnLine }, Value=100, Threshold=  0, Passed
Id=  5, Status=51 {PreFailure , OnLine }, Value=100, Threshold=  5, Passed
Id=  7, Status=11 {PreFailure , OnLine }, Value=100, Threshold= 67, Passed
Id=  8, Status= 5 {PreFailure , OffLine}, Value=100, Threshold= 20, Passed
Id=  9, Status=18 {Advisory    , OnLine }, Value= 96, Threshold=  0, Passed
Id= 10, Status=19 {PreFailure , OnLine }, Value=100, Threshold= 60, Passed
Id= 12, Status=50 {Advisory    , OnLine }, Value=100, Threshold=  0, Passed
Id=192, Status=50 {Advisory    , OnLine }, Value= 99, Threshold= 50, Passed
Id=193, Status=18 {Advisory    , OnLine }, Value= 99, Threshold= 50, Passed
Id=194, Status= 2 {Advisory    , OnLine }, Value=137, Threshold=  0, Passed
Id=196, Status=50 {Advisory    , OnLine }, Value=100, Threshold=  0, Passed
Id=197, Status=34 {Advisory    , OnLine }, Value=100, Threshold=  0, Passed
Id=198, Status= 8 {Advisory    , OffLine}, Value=100, Threshold=  0, Passed
Id=199, Status=10 {Advisory    , OnLine }, Value=200, Threshold=  0, Passed
OffLineStatus=0 {NeverStarted}, AutoOffLine=No, OffLineTimeout=92 minutes
OffLineCapability=27 {Immediate Auto SuspendOnCmd}
SmartRevision=16, CheckSum=151, SmartCapability=3 {SaveOnStandBy AutoSave}

I can xxd and dd this partition without getting any console errors. I can
also mount the partition with -o ro,norecovery.  How do I repair this and
recover my data?

--00163646d0bea7ebfa0468a95651
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<span class=3D"postbody">I had a power failure while I was running a
defrag on an xfs partition. Now I am unable to mount, xfs_check or
xfs_repair the partition. The partition is lvm and all other partitions
seem to be fine except this one. When attempting to mount the partition
the drive makes some funny noises and these messages spit out on the
console:
<br><br></span>hda: dma_intr: status=3D0x51 { DriveReady SeekComplete Error=
 }
<br>
hda: dma_intr: error=3D0x40 { UncorrectableError }, LBAsect=3D268552872, hi=
gh=3D16, low=3D117416, sector=3D268552868
<br>
ide: failed opcode was: unknown
<br>
end_request: I/O error, dev hda, sector 268552868<br><span class=3D"postbod=
y">

</span><span class=3D"postbody"><br>
I believe the drive is fine because check_ide_smart reports:
<br><br></span>Id=3D=A0 1, Status=3D11 {PreFailure , OnLine }, Value=3D100,=
 Threshold=3D 60, Passed
<br>
Id=3D=A0 2, Status=3D 5 {PreFailure , OffLine}, Value=3D100, Threshold=3D 5=
0, Passed
<br>
Id=3D=A0 3, Status=3D 7 {PreFailure , OnLine }, Value=3D151, Threshold=3D 2=
4, Passed
<br>
Id=3D=A0 4, Status=3D18 {Advisory=A0 =A0 , OnLine }, Value=3D100, Threshold=
=3D=A0 0, Passed
<br>
Id=3D=A0 5, Status=3D51 {PreFailure , OnLine }, Value=3D100, Threshold=3D=
=A0 5, Passed
<br>
Id=3D=A0 7, Status=3D11 {PreFailure , OnLine }, Value=3D100, Threshold=3D 6=
7, Passed
<br>
Id=3D=A0 8, Status=3D 5 {PreFailure , OffLine}, Value=3D100, Threshold=3D 2=
0, Passed
<br>
Id=3D=A0 9, Status=3D18 {Advisory=A0 =A0 , OnLine }, Value=3D 96, Threshold=
=3D=A0 0, Passed
<br>
Id=3D 10, Status=3D19 {PreFailure , OnLine }, Value=3D100, Threshold=3D 60,=
 Passed
<br>
Id=3D 12, Status=3D50 {Advisory=A0 =A0 , OnLine }, Value=3D100, Threshold=
=3D=A0 0, Passed
<br>
Id=3D192, Status=3D50 {Advisory=A0 =A0 , OnLine }, Value=3D 99, Threshold=
=3D 50, Passed
<br>
Id=3D193, Status=3D18 {Advisory=A0 =A0 , OnLine }, Value=3D 99, Threshold=
=3D 50, Passed
<br>
Id=3D194, Status=3D 2 {Advisory=A0 =A0 , OnLine }, Value=3D137, Threshold=
=3D=A0 0, Passed
<br>
Id=3D196, Status=3D50 {Advisory=A0 =A0 , OnLine }, Value=3D100, Threshold=
=3D=A0 0, Passed
<br>
Id=3D197, Status=3D34 {Advisory=A0 =A0 , OnLine }, Value=3D100, Threshold=
=3D=A0 0, Passed
<br>
Id=3D198, Status=3D 8 {Advisory=A0 =A0 , OffLine}, Value=3D100, Threshold=
=3D=A0 0, Passed
<br>
Id=3D199, Status=3D10 {Advisory=A0 =A0 , OnLine }, Value=3D200, Threshold=
=3D=A0 0, Passed
<br>
OffLineStatus=3D0 {NeverStarted}, AutoOffLine=3DNo, OffLineTimeout=3D92 min=
utes
<br>
OffLineCapability=3D27 {Immediate Auto SuspendOnCmd}
<br>
SmartRevision=3D16, CheckSum=3D151, SmartCapability=3D3 {SaveOnStandBy Auto=
Save}<span class=3D"postbody"><br><br>I can xxd and dd this partition witho=
ut getting any console errors.
I can also mount the partition with -o ro,norecovery.=A0=20
How do I repair this and recover my data?</span>

--00163646d0bea7ebfa0468a95651--


--===============9176173275803336237==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9176173275803336237==--
