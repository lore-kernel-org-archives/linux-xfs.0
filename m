Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pALFhEmY007255
	for <linux-xfs@oss.sgi.com>; Mon, 21 Nov 2011 09:43:14 -0600
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 04B4F57071B
	for <linux-xfs@oss.sgi.com>; Mon, 21 Nov 2011 07:43:12 -0800 (PST)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id 9Rye16pvbtE4Droa for
	<linux-xfs@oss.sgi.com>; Mon, 21 Nov 2011 07:43:12 -0800 (PST)
Date: Mon, 21 Nov 2011 16:43:09 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: stale NFS file handle problem on XFS inode64
Message-ID: <20111121164309.4b18a6ca@harpe.intellique.com>
In-Reply-To: <CAJNJY8QciPX_MPsgPo3SfSuheFHGSZVsiL=ibNf1S3spyKFAig@mail.gmail.com>
References: <CAJNJY8Q--O2Z3K6KFxVKOivwaABk+oRtC1y0eQ0nS1WdPNMwsQ@mail.gmail.com>
	<20111121150158.5f8b2512@harpe.intellique.com>
	<CAJNJY8SoNvqQB0WNJq5SVUhkLSJROoMkVEkOHrESVR0iMB4JDA@mail.gmail.com>
	<20111121162155.0bfa0342@harpe.intellique.com>
	<CAJNJY8QciPX_MPsgPo3SfSuheFHGSZVsiL=ibNf1S3spyKFAig@mail.gmail.com>
Mime-Version: 1.0
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
To: hank peng <pengxihan@gmail.com>
Cc: linux-xfs@oss.sgi.com

Le Mon, 21 Nov 2011 23:28:23 +0800
hank peng <pengxihan@gmail.com> =E9crivait:

> I noticed that there is a kernel parameter :
> nfs.enable_ino64=3D
> 			[NFS] enable 64-bit inode numbers.
> 			If zero, the NFS client will fake up a 32-bit
> inode number for the readdir() and stat() syscalls instead
> 			of returning the full 64-bit number.
> 			The default is to return 64-bit inode numbers.
> =

> can I set it to zero, so NFS client can get converted 32bit inode ?

Well you must try it and hope for the best!

-- =

------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
