Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA2K2A6E088661 for <xfs@oss.sgi.com>; Mon, 2 Nov 2009 14:02:11 -0600
Received: from mail-ew0-f221.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7072C14D0413
	for <xfs@oss.sgi.com>; Mon,  2 Nov 2009 12:02:22 -0800 (PST)
Received: from mail-ew0-f221.google.com (mail-ew0-f221.google.com
	[209.85.219.221]) by cuda.sgi.com with ESMTP id
	l2h0A7v1kGtcyPVm for <xfs@oss.sgi.com>;
	Mon, 02 Nov 2009 12:02:22 -0800 (PST)
Received: by ewy21 with SMTP id 21so5057057ewy.8
	for <xfs@oss.sgi.com>; Mon, 02 Nov 2009 12:02:21 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 2 Nov 2009 20:02:20 +0000
Message-ID: <7a12b48b0911021202l126e10a1pbc281f6922380f48@mail.gmail.com>
Subject: 3ware hardware raid with battery backup and the impact on barrier and
	no write cache options.
From: William Lewis <william@netproteus.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6493844947820155349=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============6493844947820155349==
Content-Type: multipart/alternative; boundary=0016e6da7de3fb2da1047768daae

--0016e6da7de3fb2da1047768daae
Content-Type: text/plain; charset=ISO-8859-1

Hi,

I am in the process of setting up an XFS file system on underlying hardware
consisting of a 3ware 9550SXU (+ battery backup module) and 4 x Seagate
ST31500341AS 1.5TB hard drives in Raid 5 configuration.

Reading your FAQ at http://xfs.org/index.php/XFS_FAQ I understand that it is
advisable to mount the file system with nobarrier to improve performance.
However going on to read about recommended settings for write cache, the
advice for 3ware hardware doesn't seem to account for the fact that there
are 2 levels of write cache in play, that in the 3ware card itself protected
by the battery and the write cache of the disks themselves, which as far as
I can understand is also protected by the battery backup (in the correct
storage modes - balanced/protection) because the 3ware card uses write
journaling to keep track of pending write operations in the disks' cache.
Therefore unless I am misunderstanding something the most benefit is to be
gained by mounting with nobarrier and having the write cache turned on?

One thing I am not clear about is if nobarrier interacts with the page cache
at all and if the lack of barrier leaves you with a situation in which
pending writes can be lost from main memory on power failure?

Thanks in advance for any clarification you can provide.

Regards

Will Lewis

--0016e6da7de3fb2da1047768daae
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,<br><br>I am in the process of setting up an XFS file system on underlyi=
ng hardware consisting of a 3ware 9550SXU (+ battery backup module) and 4 x=
 Seagate ST31500341AS 1.5TB hard drives in Raid 5 configuration.<br><br>
Reading your FAQ at <a href=3D"http://xfs.org/index.php/XFS_FAQ">http://xfs=
.org/index.php/XFS_FAQ</a> I understand that it is advisable to mount the f=
ile system with nobarrier to improve performance. However going on to read =
about recommended settings for write cache, the advice for 3ware hardware d=
oesn&#39;t seem to account for the fact that there are 2 levels of write ca=
che in play, that in the 3ware card itself protected by the battery and the=
 write cache of the disks themselves, which as far as I can understand is a=
lso protected by the battery backup (in the correct storage modes - balance=
d/protection) because the 3ware card uses write journaling to keep track of=
 pending write operations in the disks&#39; cache. Therefore unless I am mi=
sunderstanding something the most benefit is to be gained by mounting with =
nobarrier and having the write cache turned on?<br>
<br>One thing I am not clear about is if nobarrier interacts with the page =
cache at all and if the lack of barrier leaves you with a situation in whic=
h pending writes can be lost from main memory on power failure?<br><br>
Thanks in advance for any clarification you can provide.<br><br>Regards<br>=
<br>Will Lewis<br>

--0016e6da7de3fb2da1047768daae--


--===============6493844947820155349==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6493844947820155349==--
