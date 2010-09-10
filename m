Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8AENV2S152270 for <xfs@oss.sgi.com>; Fri, 10 Sep 2010 09:23:32 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 85DB0DAF094
	for <xfs@oss.sgi.com>; Fri, 10 Sep 2010 07:35:40 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id B8C06OIhAco2GJDw for
	<xfs@oss.sgi.com>; Fri, 10 Sep 2010 07:35:40 -0700 (PDT)
Message-ID: <4C8A3F8F.4000704@sandeen.net>
Date: Fri, 10 Sep 2010 09:24:15 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS over LVM over md RAID
References: <4C89668E.6010800@sauce.co.nz> <20100910013026.GA24409@dastard>
	<4C899816.6030506@sauce.co.nz>
In-Reply-To: <4C899816.6030506@sauce.co.nz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Richard Scobie <richard@sauce.co.nz>
Cc: xfs@oss.sgi.com

Richard Scobie wrote:

> I did build 3.1.3. Is libblkid preferable?  I note it is defaulted off
> in configure and I used the default configuration.
> =

> l appear to have e2fsprogs and devel packages installed (Fedora 11), for
> libblkid, but when I enable and try to build, it fails:
> =

>     [CC]     xfs_mkfs.o
> xfs_mkfs.c: In function =91check_overwrite=92:
> xfs_mkfs.c:298: error: =91blkid_probe=92 undeclared (first use in this
> function)

yup F11 doesn't have all the nice blkid topology bits; F11 still has
libblkid in e2fsprogs, from before it was liberated to util-linux-ng.

(I wonder if we shouldn't just convert xfsprogs over to use the ioctls...)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
