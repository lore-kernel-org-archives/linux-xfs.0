Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3UKl1Y9137547 for <xfs@oss.sgi.com>; Sat, 30 Apr 2011 15:47:01 -0500
Received: from smtp1.linux-foundation.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6B3CE423171
	for <xfs@oss.sgi.com>; Sat, 30 Apr 2011 13:50:35 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org
	[140.211.169.13]) by cuda.sgi.com with ESMTP id
	roi2fQ3oZdoExLOA for <xfs@oss.sgi.com>;
	Sat, 30 Apr 2011 13:50:35 -0700 (PDT)
Received: from mail-ew0-f53.google.com (mail-ew0-f53.google.com
	[209.85.215.53]) (authenticated bits=0)
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with
	ESMTP id p3UKoQJK000530
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=FAIL)
	for <xfs@oss.sgi.com>; Sat, 30 Apr 2011 13:50:28 -0700
Received: by ewy8 with SMTP id 8so1544238ewy.26
	for <xfs@oss.sgi.com>; Sat, 30 Apr 2011 13:50:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Xp4OiTz83N.A.O0D.JVGvNB@chimera>
References: <Xp4OiTz83N.A.O0D.JVGvNB@chimera>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 30 Apr 2011 13:50:04 -0700
Message-ID: <BANLkTik2L0BQ0cwOnWrgjyvxV4KMHkgaFQ@mail.gmail.com>
Subject: Re: 2.6.39-rc5-git4: Reported regressions from 2.6.38
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Alex Elder <aelder@sgi.com>, xfs@oss.sgi.com
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Wireless List <linux-wireless@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, DRI <dri-devel@lists.freedesktop.org>, Florian Mickler <florian@mickler.org>, Andrew Morton <akpm@linux-foundation.org>, Kernel Testers List <kernel-testers@vger.kernel.org>, Linux PM List <linux-pm@lists.linux-foundation.org>, Maciej Rutecki <maciej.rutecki@gmail.com>

On Sat, Apr 30, 2011 at 12:42 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> Bug-Entry =A0 =A0 =A0 : http://bugzilla.kernel.org/show_bug.cgi?id=3D34012
> Subject =A0 =A0 =A0 =A0 : 2.6.39-rc4+: oom-killer busy killing tasks
> Submitter =A0 =A0 =A0 : Christian Kujau <lists@nerdbynature.de>
> Date =A0 =A0 =A0 =A0 =A0 =A0: 2011-04-22 1:57 (9 days old)
> Message-ID =A0 =A0 =A0: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.o=
rg>
> References =A0 =A0 =A0: http://marc.info/?l=3Dlinux-kernel&m=3D1303437446=
22331&w=3D2

Judging by the extended debug info in:

   http://nerdbynature.de/bits/2.6.39-rc4/oom/
   (The -9 files are the current ones)

that thing shows a _lot_ of xfs inodes:

  xfs_inode         479187 479187   1120   14    4 : tunables    0
0    0 : slabdata  34329  34329      0

even though there aren't that many dentries (each inode should have at
least one dentry associated with it under normal circumstances):

  dentry             97896  97900    160   25    1 : tunables    0
0    0 : slabdata   3916   3916      0

and then later when the system gets low on memory, the dentries shrink:

  dentry              1017   3525    160   25    1 : tunables    0
0    0 : slabdata    141    141      0

but the XFS inodes do not:

  xfs_inode         557579 557579   1120   14    4 : tunables    0
0    0 : slabdata  41492  41492      0

so I suspect it's some kind of XFS inode leak.

                      Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
