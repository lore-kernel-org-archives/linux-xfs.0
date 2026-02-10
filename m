Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C16D2459E5
	for <linux-xfs@vger.kernel.org>; Tue, 10 Feb 2026 06:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770704279; cv=none; b=V8PBRs29h4SIRC2ZTkqqa0sqEXKb5pH/bRFC+QWTz+mCSHJ8di4bsjKLoqHSrOX6EtDfcBlDBjZpMAiB3ap/htAgeTvvlOjRK7UJ4rm1gggmlEw7IXTaadFy7yJVrkVy20w2b+5TDIrWZsdebNTyYTrC9wEG18KBxt1lyBIfd+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770704279; c=relaxed/simple;
	bh=2Tw8Kytd4KFtbX04xLY7dUtGDUlUodSOZVWMfYuYeT8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pBvuWgsu8TuWZwH4gl8Eznf6KpisRtKyzLCCES9DjaQNhfYcX/cDFTF7ES+Io1m7chaz8ke4MSIfn75neOI+3FwoZ3TK0Ag9RKBAEq9a130cC6Oq9fDm72y5br9Y+2h+7A2NWA6hd/vQTYOUtQmGpSDdPqGf+G2CGYa+1yyyxSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QlISovYL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QlISovYL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B52AC116C6;
	Tue, 10 Feb 2026 06:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770704279;
	bh=2Tw8Kytd4KFtbX04xLY7dUtGDUlUodSOZVWMfYuYeT8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QlISovYL4JKuMC8C8/qgMt0SVEBtoHJQ9vIHpIWjaeKbOFM0/DKejkZ1IEO6VaWhG
	 bgo0bEd719HsaXKTQFq1nXBc78Ts7jPdsEoG1wg3Nvs92y2UdXZC5ArsDNwzo0v2pM
	 vmiWHK+m8urRRI+TaJjfp3e2Fi8QQIcIhgL2uxDgX6xX+PDgFHm3J2CMq5CGvOV+EI
	 VcGVQFAnjCN+dZNrAfg8d3fiPEGeAtmiO9Ii3aQhTusrR1DaNLqkEQ76YxsYB939eq
	 Csjc7a4pc0/EpBhXQLq6AxUoDrFZ/QxISngytjg8YOMPoCUJhB1hPwfvC7CKY1lXEb
	 5zY5GVTRUhi2A==
Date: Mon, 9 Feb 2026 22:17:58 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: hch <hch@lst.de>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [bug report] xfs/802 failure due to mssing fstype report by lsblk
Message-ID: <20260210061758.GE7712@frogsfrogsfrogs>
References: <aYWobEmDn0jSPzqo@shinmob>
 <20260206173805.GY7712@frogsfrogsfrogs>
 <aYlHZ4bBQI3Vpb3N@shinmob>
 <20260209060716.GL1535390@frogsfrogsfrogs>
 <20260209062821.GA9021@lst.de>
 <aYmRhwnL286jv550@shinmob>
 <20260210020040.GC7712@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260210020040.GC7712@frogsfrogsfrogs>

On Mon, Feb 09, 2026 at 06:00:40PM -0800, Darrick J. Wong wrote:
> On Mon, Feb 09, 2026 at 07:54:38AM +0000, Shinichiro Kawasaki wrote:
> > On Feb 09, 2026 / 07:28, hch wrote:
> > > On Sun, Feb 08, 2026 at 10:07:16PM -0800, Darrick J. Wong wrote:
> > > > Waitaminute, how can you even format xfs on nullblk to run fstests?
> > > > Isn't that the bdev that silently discards everything written to it, and
> > > > returns zero on reads??
> > > 
> > > nullblk can be used with or without a backing store.  In the former
> > > case it will not always return zeroes on reads obviously.
> > 
> > Yes, null_blk has the "memory_backed" parameter. When 1 is set to this, data
> > written to the null_blk device is kept and read back. I create two 8GiB null_blk
> > devices enabling this memory_backed option, and use them as TEST_DEV and
> > SCRATCH_DEV for the regular xfs test runs.
> 
> Huh, ok.  Just out of curiosity, does blkid (in cache mode) /ever/ see
> the xfs filesystem?  I'm wondering if there's a race, a slow utility, or
> if whatever builds the blkid cache sees that it's nullblk and ignores
> it?

Ah, I see.  The problem isnt *blkid* failing to see the new xfs
filesystem, it's lsblk failing to see that it has an xfs filesystem:

# udevadm monitor &
[1] 5743
# monitor will print the received events for:
UDEV - the event which udev sends out after rule processing
KERNEL - the kernel uevent


# mkfs.xfs -f /dev/nullb0
meta-data=/dev/nullb0            isize=512    agcount=4, agsize=65536 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=1   metadir=0
data     =                       bsize=4096   blocks=262144, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
         =                       rgcount=0    rgsize=0 extents
         =                       zoned=0      start=0 reserved=0
Discarding blocks...Done.
#
<taps foot>
# mkfs.xfs -f /dev/sda
meta-data=/dev/sda               isize=512    agcount=4, agsize=314368 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=1   metadir=0
data     =                       bsize=4096   blocks=1257472, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
         =                       rgcount=0    rgsize=0 extents
         =                       zoned=0      start=0 reserved=0
Discarding blocks...Done.
# KERNEL[1500.715783] change   /devices/pci0000:00/0000:00:06.0/virtio2/host0/target0:0:0/0:0:0:0/block/sda (block)
UDEV  [1500.806556] change   /devices/pci0000:00/0000:00:06.0/virtio2/host0/target0:0:0/0:0:0:0/block/sda (block)

So for some reason nullb0 doesn't generate kernel uevents when mkfs.xfs
closes the block device, like it does for scsi disks.  I don't know why
that is, but I'll look at it when I get a chance; it's very late here
now.

--D
