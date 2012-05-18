Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4IKtYTB251301 for <xfs@oss.sgi.com>; Fri, 18 May 2012 15:55:34 -0500
Received: from mail.linuxsystems.it (mail.linuxsystems.it [2.119.245.41]) by
	cuda.sgi.com with ESMTP id X41BUhWcjr4dp93M for
	<xfs@oss.sgi.com>; Fri, 18 May 2012 13:55:32 -0700 (PDT)
Received: from [192.168.2.4] (unknown [192.168.2.4])
	by mail.linuxsystems.it (Postfix) with ESMTPSA id 98E8B7776
	for <xfs@oss.sgi.com>; Fri, 18 May 2012 22:55:30 +0200 (CEST)
Message-ID: <4FB6B7AB.8030405@linuxsystems.it>
Date: Fri, 18 May 2012 22:57:15 +0200
From: =?ISO-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
MIME-Version: 1.0
Subject: Re: How to recover data from an xfs partition
References: <4FAE9DBF.1090505@linuxsystems.it> <20120518143143.GN16099@sgi.com>
	<4FB66430.9040202@linuxsystems.it> <4FB68AF6.1090303@sandeen.net>
In-Reply-To: <4FB68AF6.1090303@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Il 18/05/2012 19:46, Eric Sandeen ha scritto:
> the file backing it - what was that stored on?

It was a raw image created with dd and stored on an SSD (ext4).
Some of the virtual machines were on traditional hard disks instead (ext4).

Only the running virtual machines got damaged, the main filesystems are =

perfect.

> What it was that did the scribbling

Rebooting. A simple, stupid reboot after upgrading Xen. While rebooting =

the system I got some kind of kernel panic and I had to use magic sysrq =

keys (remount read-only, sync, reboot).

Niccol=F2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
