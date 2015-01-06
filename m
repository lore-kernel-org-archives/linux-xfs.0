Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DCB717F60
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 00:12:23 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BBF20304051
	for <xfs@oss.sgi.com>; Mon,  5 Jan 2015 22:12:20 -0800 (PST)
Received: from mail-gw2.its.unimelb.edu.au (mail-gw2.its.unimelb.edu.au
	[128.250.5.151]) by cuda.sgi.com with ESMTP id 1oYvC2DAwGhHBtSv
	for <xfs@oss.sgi.com>; Mon, 05 Jan 2015 22:12:18 -0800 (PST)
Received: from mail-ie0-f176.google.com (mail-ie0-f176.google.com
	[209.85.223.176]) (Authenticated sender: draffelt)
	by mail-gw2.its.unimelb.edu.au (Postfix) with ESMTPSA id 2EA2819B2
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 17:12:17 +1100 (EST)
Received: by mail-ie0-f176.google.com with SMTP id tr6so1194367ieb.7
	for <xfs@oss.sgi.com>; Mon, 05 Jan 2015 22:12:15 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 6 Jan 2015 17:12:14 +1100
Message-ID: <CAOFq7B5PaPCJdAxyYa6feCXgGbkz+1Qs+Gfb2WG=5af=A+WOQg@mail.gmail.com>
Subject: XFS corrupt after RAID failure and resync
From: David Raffelt <david.raffelt@florey.edu.au>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8693915912607194685=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8693915912607194685==
Content-Type: multipart/alternative; boundary=20cf302076e43c8513050bf5b09d

--20cf302076e43c8513050bf5b09d
Content-Type: text/plain; charset=UTF-8

Hi again,
Some more information.... the kernel log show the following errors were
occurring after the RAID recovery, but before I reset the server.

Jan 06 00:00:27 server kernel: XFS (md0): Corruption detected. Unmount and
run xfs_repair
Jan 06 00:00:27 server kernel: XFS (md0): Corruption detected. Unmount and
run xfs_repair
Jan 06 00:00:27 server kernel: XFS (md0): Corruption detected. Unmount and
run xfs_repair
Jan 06 00:00:27 server kernel: XFS (md0): metadata I/O error: block
0x36b106c00 ("xfs_trans_read_buf_map") error 117 numblks 16
Jan 06 00:00:27 server kernel: XFS (md0): xfs_imap_to_bp:
xfs_trans_read_buf() returned error 117.


Thanks,
Dave

--20cf302076e43c8513050bf5b09d
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi again,</div>Some more information.... the kernel l=
og show the following errors were occurring after the RAID recovery, but be=
fore I reset the server.<div><br></div><div>
<div>Jan 06 00:00:27 server kernel: XFS (md0): Corruption detected. Unmount=
 and run xfs_repair<br></div><div><div>Jan 06 00:00:27=C2=A0server=C2=A0ker=
nel: XFS (md0): Corruption detected. Unmount and run xfs_repair</div><div>J=
an 06 00:00:27=C2=A0server=C2=A0kernel: XFS (md0): Corruption detected. Unm=
ount and run xfs_repair</div><div>Jan 06 00:00:27=C2=A0server=C2=A0kernel: =
XFS (md0): metadata I/O error: block 0x36b106c00=C2=A0(&quot;xfs_trans_read=
_buf_map&quot;) error 117 numblks 16</div><div>Jan 06 00:00:27=C2=A0server=
=C2=A0kernel: XFS (md0): xfs_imap_to_bp: xfs_trans_read_buf() returned erro=
r 117.</div></div></div><div><br></div><div><br></div><div>Thanks,</div><di=
v>Dave</div></div>

--20cf302076e43c8513050bf5b09d--


--===============8693915912607194685==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8693915912607194685==--
