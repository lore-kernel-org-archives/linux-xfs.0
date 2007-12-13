Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 13 Dec 2007 14:48:18 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBDMlkAj032091
	for <xfs@oss.sgi.com>; Thu, 13 Dec 2007 14:47:48 -0800
Date: Fri, 14 Dec 2007 09:47:49 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: mount: Function not implemented
Message-ID: <20071213224749.GJ4396912@sgi.com>
References: <f0e429340712130746i9b24c15j8dd8f53a9da2c4c4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0e429340712130746i9b24c15j8dd8f53a9da2c4c4@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: KE Liew <ke.liew@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Dec 13, 2007 at 04:46:18PM +0100, KE Liew wrote:
> Hi all,
> 
> I was in #xfs with sandeen in discussing on the above issue. In the
> nutshell, I can't mount /dev/hdb due to the above error: mount -t xfs
> /dev/hdb /path/to

#define ENOSYS          38      /* Function not implemented */

Exactly what is mount being told there is not system call support?
What kernel are you running?

Can you strace the mount process and find out where the error is
coming from?

> It all started after I did a sequence of things to the new hdd I purchased.
> First, I created an msdos disklabel on a new xfs partition /dev/hdb1. It
> uses the full capacity of the hdd.

Did you then write out the partition table? Did the kernel warn you that it
couldn't reread the partition table and so you should reboot before doing
anything else? Did you make the xfs filesystem on /dev/hdb or hdb1?

> Then I transferred files from one hdd to
> another using mv -v /stuff-to-transfer /hdb-mount-point Upon completion, I
> umount both devices and rebooted. On boot, I was not able to mount neither
> /dev/hdb1 nor /dev/hdb. /dev/hdb1 returns mount: special device /dev/hdb1
> does not exist and /dev/hdb returns the above error message, no relevant
> messages are present in dmesg | tail
> 
> The hexdump:
> ===================
> # dd if=/dev/hdb bs=512 count=1 | hexdump -C
> 1+0 records in
> 1+0 records out
> 00000000  58 46 53 42 00 01 00 00  00 00 00 00 00 3a 38 b0
> |XFSB.........:8.|

This kind of indicates that you did a 'mkfs.xfs /dev/hdb' not
the partition you created. If that is the case, then rebooting
may have written who-knows-what to disk.

> The xfs_db:
> ===================
> # xfs_db -r -c "sb 0" -c p /dev/hdb
> cache_node_purge: refcount was 1, not zero (node=0x80ca410)
> xfs_db: cannot read root inode (22)

EINVAL.

> cache_node_purge: refcount was 1, not zero (node=0x80da608)
> xfs_db: cannot read realtime bitmap inode (22)
> Segmentation fault
> ===================

That tends to indicate that the filesystem superblock is ok but
the contents are not.

Without knowing exactly what you did and what errors came up, it's
going to be hard reconstructing what went wrong. Perhaps a metadump
of the filesysetm woul dbe useful in working out how it is broken....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
