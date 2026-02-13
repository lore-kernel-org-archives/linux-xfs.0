Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA4E15A86D
	for <linux-xfs@vger.kernel.org>; Fri, 13 Feb 2026 22:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771020845; cv=none; b=cFI+JFr1BZzClj77kIojahHBi0mP1a/HsbqaU1RLEDBFIIiFTbzf7EHdRtXKsuP4Any7WKkjcv9RpqVyEL/Q9Or92kvPDsEGTLejLvGBWWD9r13CmRANoc+JFlUwOl8kbDjJLknZ4xZx/XX96BU50/jUK1hexCRBmPHCpYjCMtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771020845; c=relaxed/simple;
	bh=8MrgrlZn3xqRUYUaETYAP/lLjKPaLChIKD+VbCyByfU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SKt2tYzp6qLD8aEf/YAm+n9dAEQZPmPhwkxOUfBqmJt7+9cpWbtiGQQ1qD1/jMkPUKaPmEPhXw/4dbFe2nuhHcadBQoQ8wRaPAtqqRukHNw9g1kn940U4LzVP24VJIAeB2j2LH8bzjifKI5Dn7J+aqoMzzGgQCuWbbXQPq3L6Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k3jzcXWd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k3jzcXWd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6E9C116C6;
	Fri, 13 Feb 2026 22:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771020844;
	bh=8MrgrlZn3xqRUYUaETYAP/lLjKPaLChIKD+VbCyByfU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k3jzcXWd1Sh6rm+ZFTP/piwqCJZ0r6vmNM41txN0HjoPxO1xeNdyeIBjRelACms4n
	 q3QK5WXjxKypjp1p0oCgY47lZF18BCbYxV2zAtUJ+hOSqsbU2Exm1IT+2mWPg2hOWo
	 3vYXn2JJOknHaQjDrKkZM+6/gBhZYvT7D7BXCVqz7EtBqxz1cGLA/zDUPreBuid7AY
	 cBn4u/cHrEcbKAsIgLU1Ez4JDdkyp7EfpjyouFWAOzQDRoxkHTXW+HFwxKr1j94jT7
	 Btwyax+s3iCbv373pneXo62GOv1nJgGWBN1UYLo4GFb211z0APRz4ph4XAsXJbd7Ea
	 +iPZ3nhoS1xfg==
Date: Fri, 13 Feb 2026 14:14:04 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: hch <hch@lst.de>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [bug report] xfs/802 failure due to mssing fstype report by lsblk
Message-ID: <20260213221404.GH7712@frogsfrogsfrogs>
References: <aYWobEmDn0jSPzqo@shinmob>
 <20260206173805.GY7712@frogsfrogsfrogs>
 <aYlHZ4bBQI3Vpb3N@shinmob>
 <20260209060716.GL1535390@frogsfrogsfrogs>
 <20260209062821.GA9021@lst.de>
 <aYmRhwnL286jv550@shinmob>
 <20260210020040.GC7712@frogsfrogsfrogs>
 <aYrKf6ukceZrSRhJ@shinmob>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYrKf6ukceZrSRhJ@shinmob>

On Tue, Feb 10, 2026 at 06:19:21AM +0000, Shinichiro Kawasaki wrote:
> On Feb 09, 2026 / 18:00, Darrick J. Wong wrote:
> > On Mon, Feb 09, 2026 at 07:54:38AM +0000, Shinichiro Kawasaki wrote:
> > > On Feb 09, 2026 / 07:28, hch wrote:
> > > > On Sun, Feb 08, 2026 at 10:07:16PM -0800, Darrick J. Wong wrote:
> > > > > Waitaminute, how can you even format xfs on nullblk to run fstests?
> > > > > Isn't that the bdev that silently discards everything written to it, and
> > > > > returns zero on reads??
> > > > 
> > > > nullblk can be used with or without a backing store.  In the former
> > > > case it will not always return zeroes on reads obviously.
> > > 
> > > Yes, null_blk has the "memory_backed" parameter. When 1 is set to this, data
> > > written to the null_blk device is kept and read back. I create two 8GiB null_blk
> > > devices enabling this memory_backed option, and use them as TEST_DEV and
> > > SCRATCH_DEV for the regular xfs test runs.
> > 
> > Huh, ok.  Just out of curiosity, does blkid (in cache mode) /ever/ see
> > the xfs filesystem?  I'm wondering if there's a race, a slow utility, or
> > if whatever builds the blkid cache sees that it's nullblk and ignores
> > it?
> 
> I tried the experement below, using /dev/nullb1 formatted as xfs:
> 
> # Clear blkid cache
> $ sudo rm /run/blkid/blkid.tab
> 
> # Call blkid, but normal user can not parse superblock, then can not get fstype.
> $ blkid --match-tag=TYPE /dev/nullb1
> 
> # Call blkid with superuser privilege. It can get fstype, but does not cache it,
> # since --probe option is specified.
> $ sudo blkid --probe --match-tag=TYPE /dev/nullb1
> /dev/nullb1: TYPE="xfs"
> 
> # Still normal user can not get fstype since fstype is not cached.
> $ blkid --match-tag=TYPE /dev/nullb1
> 
> # Call blkid as superuser without --probe option. It caches the fstype.
> $sudo blkid --match-tag=TYPE /dev/nullb1
> /dev/nullb1: TYPE="xfs"
> 
> # Now normal user can get fstype referring to the cache
> $ blkid --match-tag=TYPE /dev/nullb1
> /dev/nullb1: TYPE="xfs"
> 
> 
> Based on this result, my understanding is that blkid caches its superblock
> parse results when --probe, or -p option, is not specified. As far as I git
> grep util-linux, this behavior does not change for null_blk.

<sigh> I just spent two hours digging further into why your nullblk
device doesn't show up in the lsblk output.

Let's start with creating an nullblk device and formatting it:

# modprobe null_blk gb=1 memory_backed=1
# mkfs.ext2 -F /dev/nullb0
# mkfs.ext2 -F /dev/sda
# mount /dev/nullb0 /mnt

Now let's query lsblk:

# lsblk -o NAME,KNAME,TYPE,FSTYPE,MOUNTPOINT,UUID
NAME   KNAME  TYPE FSTYPE MOUNTPOINT UUID
sda    sda    disk ext2              cca89aa9-2dfd-4609-9f62-8a3c88c2054a
nullb0 nullb0 disk        /mnt

For nullb0, lsblk finds the mountpoint, but it can't identify it as an
ext2 filesystem.  stracing the output, I see that it opens
/run/udev/data/b${major}:${minor} to find out the filesystem type.

# cat /run/udev/data/b252\:0
I:991780315
G:systemd
Q:systemd
V:1
# cat /run/udev/data/b8\:0
S:disk/by-uuid/cca89aa9-2dfd-4609-9f62-8a3c88c2054a
S:disk/by-path/pci-0000:00:06.0-scsi-0:0:0:0
S:disk/by-diskseq/1
S:disk/by-id/scsi-0QEMU_RAMDISK_drive-scsi0-0-0-0
I:592459
E:ID_FS_UUID=cca89aa9-2dfd-4609-9f62-8a3c88c2054a
E:ID_FS_UUID_ENC=cca89aa9-2dfd-4609-9f62-8a3c88c2054a
E:ID_FS_VERSION=1.0
E:ID_FS_BLOCKSIZE=4096
E:ID_FS_LASTBLOCK=2579968
E:ID_FS_SIZE=10567548928
E:ID_FS_TYPE=ext2
E:ID_FS_USAGE=filesystem
E:ID_SCSI=1
E:ID_VENDOR=QEMU
E:ID_VENDOR_ENC=QEMU\x20\x20\x20\x20
E:ID_MODEL=RAMDISK
E:ID_MODEL_ENC=RAMDISK\x20\x20\x20\x20\x20\x20\x20\x20\x20
E:ID_REVISION=2.5+
E:ID_TYPE=disk
E:ID_SERIAL=0QEMU_RAMDISK_drive-scsi0-0-0-0
E:ID_SERIAL_SHORT=drive-scsi0-0-0-0
E:ID_BUS=scsi
E:ID_PATH=pci-0000:00:06.0-scsi-0:0:0:0
E:ID_PATH_TAG=pci-0000_00_06_0-scsi-0_0_0_0
E:UDISKS_AUTO=0
G:systemd
Q:systemd
V:1

As you can see, the udev device database saw that sda has an ext2
filesystem, but records almost nothing for nullb0.  That's why lsblk
doesn't detect fstype for nullb0.  Why doesn't udev record anything for
nullb0?  I suspect it has something to do with this hunk of
60-block.rules:

ACTION!="remove", SUBSYSTEM=="block", \
  KERNEL=="loop*|mmcblk*[0-9]|msblk*[0-9]|mspblk*[0-9]|nvme*|sd*|vd*|xvd*|bcache*|cciss*|dasd*|ubd*|ubi*|scm*|pmem*|nbd*|zd*|rbd*|zram*|ublkb*", \
  OPTIONS+="watch"

This causes udev to establish an inotify watch on block devices.  When a
bdev is opened for write and closed, udev receives the inotify event and
synthesizes a change uevent.  Annoyingly, creating a new rule file with:

ACTION!="remove", SUBSYSTEM=="block", \
  KERNEL=="nullb*", \
  OPTIONS+="watch"

doesn't fix the problem, and I'm not familiar enough with the set of
udev rule files on a Debian 13 system to make any further diagnoses.  If
you're really interested in using nullblk as a ramdisk for this purpose
then I think you should file a bug against systemd to make lsblk work
properly for nullblk.

Note: blkid without the -p looks at /run/blkid/blkid.tab and does not
pay attention to the /run/udev files.  I don't know why the two
utilities look at different files.

> Anyway, I think blkid with --probe option is good for fstests usage, since it
> directly checks the superblock of the target block devices.

That's not an attractive option for fixing xfs/802.  The test fails
because xfs_scrub is never run against the scratch fs on the nullblk.
The scratch fs is not seen by xfs_scrub_all because lsblk doesn't see a
fstype for nullb0.  lsblk doesn't see that because (apparently) udev
doesn't touch nullb0.

The lsblk call is internal to xfs_scrub_all; it needs lsblk's json
output to find all mounted XFS filesystems on the system.  blkid doesn't
reveal anything about mount points.

Yes, we could change xfs_scrub_all to call blkid -p on every block
device for which lsblk doesn't find a fstype but does find a mountpoint,
but at that point I say xfs shouldn't be working around bugs in udev
that concern an ephemeral block device.

--D
