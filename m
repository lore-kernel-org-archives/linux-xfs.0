Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 13 Dec 2007 21:28:42 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBE5SU4r032593
	for <xfs@oss.sgi.com>; Thu, 13 Dec 2007 21:28:37 -0800
Date: Fri, 14 Dec 2007 16:28:33 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: mount: Function not implemented
Message-ID: <20071214052833.GM4396912@sgi.com>
References: <f0e429340712130746i9b24c15j8dd8f53a9da2c4c4@mail.gmail.com> <20071213224749.GJ4396912@sgi.com> <47620148.2060401@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47620148.2060401@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: David Chinner <dgc@sgi.com>, KE Liew <ke.liew@gmail.com>, xfs@oss.sgi.com

On Thu, Dec 13, 2007 at 10:06:32PM -0600, Eric Sandeen wrote:
> David Chinner wrote:
> > On Thu, Dec 13, 2007 at 04:46:18PM +0100, KE Liew wrote:
> 
> >> The hexdump:
> >> ===================
> >> # dd if=/dev/hdb bs=512 count=1 | hexdump -C
> >> 1+0 records in
> >> 1+0 records out
> >> 00000000  58 46 53 42 00 01 00 00  00 00 00 00 00 3a 38 b0
> >> |XFSB.........:8.|
> > 
> > This kind of indicates that you did a 'mkfs.xfs /dev/hdb' not
> > the partition you created. If that is the case, then rebooting
> > may have written who-knows-what to disk.
> 
> although if it was a) new and b) he made a whole-disk partition, it was
> probably not a busy disk and I wouldn't expect a reboot was necessary.

Agreed. But something went wrong so best to ask....

> >> The xfs_db:
> >> ===================
> >> # xfs_db -r -c "sb 0" -c p /dev/hdb
> >> cache_node_purge: refcount was 1, not zero (node=0x80ca410)
> >> xfs_db: cannot read root inode (22)
> > 
> > EINVAL.
> 
> Hm, that should probably use perror or something, silly me read that as
> the inode *number* and then thought "hmm I bet something stuck EINVAL
> into the inode number, oops!"  :)

Yeah, it probably should perror then tell you the root inode number
it failed to read....

Looking at it a bit deeper, libxfs_iget() returned EINVAL and that
is most likely from:

        ip->i_ino = ino;
        ip->i_mount = mp;
        if ((error = xfs_itobp(mp, tp, ip, &dip, &bp, bno)))
                return error;
        if (INT_GET(dip->di_core.di_magic, ARCH_CONVERT) != XFS_DINODE_MAGIC) {
                xfs_trans_brelse(tp, bp);
>>>>>>          return EINVAL;
        }

The inode number being toast.

Looking back at superblock dump, the root inode number is 0x900,
which is extremely strange. Normal root inode number is 0x80 which
indicates a block number of 0x40 (512 byte blocks), whereas
0x900 indicates a block number of 0x480 (1152) which is a long
way away from where it should be.

00000000  58 46 53 42 00 01 00 00  00 00 00 00 00 3a 38 b0
|XFSB.........:8.|

Hmmmm. Filesystem block size = 0x10000 = 64k and data blocks = 0x3a38b0
which gives a filesystem size of 232GB.

<ktwilight> Disk /dev/hdb: 250.0 GB, 250059350016 bytes

Still the root inode is in the wrong place. They should
be at 0x800 for 64k block size. (yes, I just checked this out by
making a 64k block size filesystem).

So, key questions:

	1. What platform is this?
	2. What page size is being used?
	3. what kernel is being run?
	4. What was the mkfs command used to make the filesystem?
	5. how did you mount this filesystem in the first place?

> > Without knowing exactly what you did and what errors came up, it's
> > going to be hard reconstructing what went wrong. Perhaps a metadump
> > of the filesysetm woul dbe useful in working out how it is broken....
> 
> Metadump failed with the same errors as xfs_db

Oh, I didn't notice that. But seeing as the above error is in libxfs
it's not surprising that they both fail there....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
