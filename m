Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5B6F87F6D
	for <xfs@oss.sgi.com>; Tue,  7 Apr 2015 10:34:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DDDD6AC003
	for <xfs@oss.sgi.com>; Tue,  7 Apr 2015 08:34:07 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Zaw40kRNNwZxGuQU for <xfs@oss.sgi.com>;
	Tue, 07 Apr 2015 08:34:06 -0700 (PDT)
Message-ID: <5523F8ED.1060105@sandeen.net>
Date: Tue, 07 Apr 2015 10:34:05 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: finest and rhel/centos 7.1
References: <014A8EAA-D469-49D9-9A80-5C4CC455C74E@gmail.com>
In-Reply-To: <014A8EAA-D469-49D9-9A80-5C4CC455C74E@gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Charles Weber <chaweber@gmail.com>, xfs@oss.sgi.com

On 4/7/15 10:30 AM, Charles Weber wrote:
> Hi everyone, I am building a large storage server and noticed to my
> delight that mkfs.xfs in 7.1 now supports finobts=3D1. But I get mount
> errors saying below. Since the FS in question mount fine so long as I
> don=92t specify finobts=3D1 while formatting, should I assume the rest of
> 7.1 is not yet ready for it? Or is there some option I missed?

That was a bit of an oversight.

finobt will be available kernelside eventually, but userspace
jumped the gun.

-Eric
 =

> thanks, Chuck *xfs*progs-3.2.1-6.el7.x86_64 =

> kernel-3.10.0-229.1.2.el7.x86_64 [75881.037768] SELinux: initialized
> (dev dm-7, type xfs), uses xattr [75908.498994] XFS (dm-7):
> Superblock has unknown read-only compatible features (0x1) enabled. =

> [75908.499035] XFS (dm-7): Attempted to mount read-only compatible
> filesystem read-write. Filesystem can only be safely mounted read
> only. [75908.499058] XFS (dm-7): SB validate failed with error 22.
> =

> =

> [root@NIAIRPGL1 share]# modinfo xfs filename:
> /lib/modules/3.10.0-229.1.2.el7.x86_64/kernel/fs/xfs/xfs.ko license:
> GPL description:    SGI XFS with ACLs, security attributes, large
> block/inode numbers, no debug enabled author:         Silicon
> Graphics, Inc. alias:          fs-xfs rhelversion:    7.1 srcversion:
> 3E3940432E169BEE955EDE9 depends:        libcrc32c intree:         Y =

> vermagic:       3.10.0-229.1.2.el7.x86_64 SMP mod_unload modversions
>  signer:         CentOS Linux kernel signing key sig_key:
> 34:B5:BC:A2:B7:06:D8:2E:72:A5:BE:3E:E4:09:BE:C7:19:5E:A5:08 =

> sig_hashalgo:   sha256
> =

> =

> =

> _______________________________________________ xfs mailing list =

> xfs@oss.sgi.com http://oss.sgi.com/mailman/listinfo/xfs
> =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
