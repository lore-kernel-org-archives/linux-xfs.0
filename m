Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8NLaMfR036863 for <xfs@oss.sgi.com>; Wed, 23 Sep 2009 16:36:23 -0500
Received: from x.digitalelves.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E3CDB2DB9
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2009 14:37:40 -0700 (PDT)
Received: from x.digitalelves.com (v-209-98-77-55.ip.visi.com [209.98.77.55])
	by cuda.sgi.com with ESMTP id CNfDZOpbGvSPdSDo for
	<xfs@oss.sgi.com>; Wed, 23 Sep 2009 14:37:40 -0700 (PDT)
Message-ID: <4ABA9523.60909@thebarn.com>
Date: Wed, 23 Sep 2009 16:37:39 -0500
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: problems with xfs_growfs after lvextend
References: <4ABA8D56.2040101@phy.duke.edu>
In-Reply-To: <4ABA8D56.2040101@phy.duke.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jimmy Dorff <jdorff@phy.duke.edu>
Cc: xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Jimmy Dorff wrote:
> Hello,
>
> I'm having a problem with a corrupt xfs filesystem after attempting
>  to grow the filesystem.
>
> The problem is very similar to this post:
> http://www.redhat.com/archives/linux-lvm/2005-November/msg00026.html
>  Except that xfs_repair never finds a secondary superblock.
>
> Details: CentOS Linux, kernel 2.6.18-128.1.16.el5.centos.plus
> x86_64 lvm2-2.02.40-6.el5 originally:
> xfsprogs-2.9.4-1.el5.centos.x86_64
>
> This sever has been up and running for a few months w/o problems.
> Today we added some disks to a 3ware controller. The disks were all
>  tested individually before installation.
>
> Used "tw_cli" to configure a new RAID volume, which appeared in
> Linux as normal (/dev/sdd).
>
> # pvcreate /dev/sdd # vgextend array_vg /dev/sdd # lvextend
> /dev/array_vg/data --size +12T
>
> This all worked w/o any errors. vgdisplay and lvdisplay all report
> the correct info and sizes.
>
> The 6TB xfs filesystem on /dev/array_vg/data was mounted as
> "/srv/data" # xfs_growfs /srv/data
>
> The size of the filesystem didn't change. I unmounted it and tried
> again, but no change. However, now I can't mount the filesystem at
> all.
>
> xfs_check causes xfs_db to use so much memory as to hang up the
> system. xfs_repair reports: Phase 1 - find and verify superblock...
>  superblock read failed, offset 19791209299968, size 2048, ag 96,
> rval 0
>
> fatal error -- Invalid argument
>
> Also, I've noticed this in syslog: kernel: attempt to access beyond
> end of device kernel: dm-1: rw=0, want=64424509440,
> limit=38654705664 kernel: I/O error in filesystem ("dm-1")
> meta-data dev dm-1 block 0xeffffffff       ("xfs_read_buf") error 5
> buf count 512 kernel: XFS: size check 2 failed
>
>
> I've trying using xfs_repair from xfsprogs 3.0.3, but it made no
> difference.
>
> Any suggestions ? Any help understanding why this didn't work ?
Sounds like you hit a known bug with xfs_growfs, actually it is a bug
with the kernel interface to growfs, the
size used to be a 32 bit number and thus would overflow if trying to
grow the filesystem by more than 2TB.

The good new is you can easily restore the the values of the primary
super block from one of the other superblocks
using the xfs_db cmd.

The bad news is that if you have run repair you may have messed things up.

basically pull up xfs_db
> sb 0 p
... output ..
> sb 1 p
... output ...

Send us the result of that and we can figure out which values need to
be restored.

- -Russell
>
>
> Thanks, Jimmy Dorff
>
> _______________________________________________ xfs mailing list
> xfs@oss.sgi.com http://oss.sgi.com/mailman/listinfo/xfs
>

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFKupUjNRmM+OaGhBgRAhH0AJ9Z98xpNsATGPeJAezQNwSB/sxGZACfRlwy
FFgr2iTYOYCHd0BkCsAOW6k=
=SAIq
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
