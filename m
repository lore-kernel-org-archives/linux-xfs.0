Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0R1O74f005892 for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 19:24:08 -0600
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BC09E18642BC
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 17:23:24 -0800 (PST)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.156])
	by cuda.sgi.com with ESMTP id o6b9cuCNSRtUkYx0 for
	<xfs@oss.sgi.com>; Mon, 26 Jan 2009 17:23:24 -0800 (PST)
Received: by fg-out-1718.google.com with SMTP id 19so3901883fgg.8
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 17:23:23 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 26 Jan 2009 23:23:23 -0200
Message-ID: <b211fe280901261723h6dd1db69t9d24c8d6774b18bc@mail.gmail.com>
Subject: Disable journaling
From: Iuri Diniz <iuridiniz@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3195702115497830209=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3195702115497830209==
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-length: 1191

BACKGOUND:
I'm looking for a filesystem for linux with these features:

* Fast Sequential Read (FSR)
* Optional: copy on write support (COW)

I think that Ext4 and XFS are the best options. (ZFS too, but current ZFS
implementation is not GPL, maybe brtfs when ready).

why do I want this? because I have a SSD.FSQ will reduce the boot time and
COW will reduce writes on the same sector while allowing snapshots

I've found that XFS has a FSQ support (good job)[1], so I it will be very
fast on SSD (random read =3D=3D sequential read).

FAIK xfs doesn't support COW, it's ok because ext4 doesn't too.

MY PROBLEM:

I know that my SSD drive supports wearing level on hardware, but anyway I
want to reduce unnecessary writes on my device, so I want to disable
journaling on my filesytem.

Maybe, the ext4 (like ext3 does) will support it by doing this:

tune2fs -O ^has_journal /dev/sda1

Is possible to disable journaling on XFS too?

Thanks in advance

[1] http://www.phoronix.com/scan.php?page=3Darticle&item=3Dext4_benchmarks&=
num=3D4

--=20
Iuri Diniz
http://iuridiniz.com [Sou um agitador, n=E3o um advogado]
http://blog.igdium.com [Linux on Limbo]


[[HTML alternate version deleted]]


--===============3195702115497830209==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3195702115497830209==--
