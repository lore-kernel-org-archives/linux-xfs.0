Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3207E7CA0
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 04:17:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E8E21304043
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 02:17:29 -0700 (PDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com
	[74.125.82.43]) by cuda.sgi.com with ESMTP id sAxStN7w3DfHYwj7
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 19 Jul 2016 02:17:27 -0700 (PDT)
Received: by mail-wm0-f43.google.com with SMTP id f65so132222443wmi.0
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 02:17:27 -0700 (PDT)
MIME-Version: 1.0
From: Kuo Hugo <tonytkdk@gmail.com>
Date: Tue, 19 Jul 2016 17:17:25 +0800
Message-ID: <CA++_uht+DQCXQ=oF0RWkje1dPxFTA9RNKH3rpGkL5gJBgFkDiQ@mail.gmail.com>
Subject: xfs_do_force_shutdown
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3732211883174705406=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3732211883174705406==
Content-Type: multipart/alternative; boundary=001a114241c2a284f20537f98d8f

--001a114241c2a284f20537f98d8f
Content-Type: text/plain; charset=UTF-8

Hi Folks,

I got a question regarding to xfs_do_force_shutdown. The smartctl doesn't
show any clue about disk bad. The device works properly again after
remount. The xfs_repair complete to repair the device very quick and
these's not too much suspecious.


* Is this a xfs level issue about dirty logs ?
* Is this HBA problem ?


```
Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.330404] blk_update_request:
I/O error, dev sdy, sector 3909224960
Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.330650] XFS (sdy): metadata
I/O error: block 0xe9020a00 ("xlog_iodone") error 5 numblks 64
Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.330939] XFS (sdy):
xfs_do_force_shutdown(0x2) called from line 1179 of file
/build/linux-lts-vivid-whAhIw/linux-lts-vivid-3.19.0/fs/xfs/xfs_log.c.
Return address = 0xffffffffc06a1d96
Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.330973] XFS (sdy):
xfs_log_force: error -5 returned.
Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.330999] XFS (sdy): Log I/O
Error Detected.  Shutting down filesystem
Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.331206] XFS (sdy): Please
umount the filesystem and rectify the problem(s)
Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.331443] Buffer I/O error on
dev sdy, logical block 18, lost async page write
Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.337098] Buffer I/O error on
dev sdy, logical block 30523594, lost async page write
Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.348492] Buffer I/O error on
dev sdy, logical block 19, lost async page write
Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.359941] Buffer I/O error on
dev sdy, logical block 30523599, lost async page write
Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.380649] XFS (sdy):
xfs_log_force: error -5 returned.
Jul 17 22:52:59 HBGTCOBSON02 kernel: [9291069.111432] XFS (sdy):
xfs_log_force: error -5 returned.
Jul 17 22:53:29 HBGTCOBSON02 kernel: [9291099.215252] XFS (sdy):
xfs_log_force: error -5 returned.
Jul 17 22:53:33 HBGTCOBSON02 kernel: [9291102.517951] XFS (sdy):
xfs_log_force: error -5 returned.
Jul 17 22:53:33 HBGTCOBSON02 kernel: [9291102.517981] XFS (sdy):
xfs_log_force: error -5 returned.
Jul 17 22:53:33 HBGTCOBSON02 kernel: [9291102.518006] XFS (sdy):
xfs_log_force: error -5 returned.
Jul 18 08:35:55 HBGTCOBSON02 kernel: [9326072.158898] XFS (sdy): Mounting
V4 Filesystem
Jul 18 08:35:55 HBGTCOBSON02 kernel: [9326072.279516] XFS (sdy): Starting
recovery (logdev: internal)
Jul 18 08:35:55 HBGTCOBSON02 kernel: [9326072.725549] XFS (sdy): Ending
recovery (logdev: internal)
```

thanks // Hugo

--001a114241c2a284f20537f98d8f
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi Folks,=C2=A0</div><div><br></div><div>I got a ques=
tion regarding to xfs_do_force_shutdown. The smartctl doesn&#39;t show any =
clue about disk bad. The device works properly again after remount. The xfs=
_repair complete to repair the device very quick and these&#39;s not too mu=
ch suspecious.=C2=A0</div><div><br></div><div><br></div><div>* Is this a xf=
s level issue about dirty logs ?=C2=A0</div><div>* Is this HBA problem ?</d=
iv><div><br></div><div><br></div><div>```<br></div><div><div>Jul 17 22:52:3=
1 HBGTCOBSON02 kernel: [9291040.330404] blk_update_request: I/O error, dev =
sdy, sector 3909224960</div><div>Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291=
040.330650] XFS (sdy): metadata I/O error: block 0xe9020a00 (&quot;xlog_iod=
one&quot;) error 5 numblks 64</div><div>Jul 17 22:52:31 HBGTCOBSON02 kernel=
: [9291040.330939] XFS (sdy): xfs_do_force_shutdown(0x2) called from line 1=
179 of file /build/linux-lts-vivid-whAhIw/linux-lts-vivid-3.19.0/fs/xfs/xfs=
_log.c.=C2=A0 Return address =3D 0xffffffffc06a1d96</div><div>Jul 17 22:52:=
31 HBGTCOBSON02 kernel: [9291040.330973] XFS (sdy): xfs_log_force: error -5=
 returned.</div><div>Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.330999] =
XFS (sdy): Log I/O Error Detected.=C2=A0 Shutting down filesystem</div><div=
>Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.331206] XFS (sdy): Please um=
ount the filesystem and rectify the problem(s)</div><div>Jul 17 22:52:31 HB=
GTCOBSON02 kernel: [9291040.331443] Buffer I/O error on dev sdy, logical bl=
ock 18, lost async page write</div><div>Jul 17 22:52:31 HBGTCOBSON02 kernel=
: [9291040.337098] Buffer I/O error on dev sdy, logical block 30523594, los=
t async page write</div><div>Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.=
348492] Buffer I/O error on dev sdy, logical block 19, lost async page writ=
e</div><div>Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.359941] Buffer I/=
O error on dev sdy, logical block 30523599, lost async page write</div><div=
>Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.380649] XFS (sdy): xfs_log_f=
orce: error -5 returned.</div><div>Jul 17 22:52:59 HBGTCOBSON02 kernel: [92=
91069.111432] XFS (sdy): xfs_log_force: error -5 returned.</div><div>Jul 17=
 22:53:29 HBGTCOBSON02 kernel: [9291099.215252] XFS (sdy): xfs_log_force: e=
rror -5 returned.</div><div>Jul 17 22:53:33 HBGTCOBSON02 kernel: [9291102.5=
17951] XFS (sdy): xfs_log_force: error -5 returned.</div><div>Jul 17 22:53:=
33 HBGTCOBSON02 kernel: [9291102.517981] XFS (sdy): xfs_log_force: error -5=
 returned.</div><div>Jul 17 22:53:33 HBGTCOBSON02 kernel: [9291102.518006] =
XFS (sdy): xfs_log_force: error -5 returned.</div><div>Jul 18 08:35:55 HBGT=
COBSON02 kernel: [9326072.158898] XFS (sdy): Mounting V4 Filesystem</div><d=
iv>Jul 18 08:35:55 HBGTCOBSON02 kernel: [9326072.279516] XFS (sdy): Startin=
g recovery (logdev: internal)</div><div>Jul 18 08:35:55 HBGTCOBSON02 kernel=
: [9326072.725549] XFS (sdy): Ending recovery (logdev: internal)</div></div=
><div>```</div><div><br></div><div>thanks // Hugo</div></div>

--001a114241c2a284f20537f98d8f--


--===============3732211883174705406==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3732211883174705406==--
