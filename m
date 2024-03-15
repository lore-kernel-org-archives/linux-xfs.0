Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD49519F
	for <linux-xfs@vger.kernel.org>; Fri, 15 Mar 2024 00:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710461546; cv=none; b=s3sh3AgbOjT0D1nx+UerUr1WEQKC212ckznrmWGa5hfwPJW8C//6sEPrYv3oAMFASZ6fM+KD1ZF/bh2Eo6S2sDW8y5lQPFXx2jK1R+0UvT0/UomdGGAfzdRrMS53DVDxF0WB27u6PMT3dtYaPmxSpXeXN5u7LiFG55GVsnW8P+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710461546; c=relaxed/simple;
	bh=oIH/Y1aNxl4+9GuBKh7Ow7Kng0QDLy3G3R1EL3HAUT0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qxsIaltQPGyoF/UjkDRy7fBABnSWzjf26IruCXv1fuFA68eq96xatyrRoBQsa/C4OVzjWULOZtgc8vINx2JSeZoFWJouQBg8QAU0WjiIuSiGCazPE/Q8zVgfG2FPBwfMjJixP7to0lsWdFt2Vs94h9YNmgw5Mve8b5i4FtgL2Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ch+qft2T; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ch+qft2T"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=b451o6lMRGfuGcsZ4gB+MUyVxgc9K1k9HchMRT9fR9g=; b=Ch+qft2TgUHPZiVzFNQRIyhHJ4
	Gu4U7KdhhoYV/Mp/gau0gdmjih1sFqszddxJ4ELiXr4kzCDIqLlqQMHDwLZPBxb+FAt26H0Vp8FA5
	c9sLENLPsvpDXiImFvcVbygRs+gNGe2xIAbgS/Gr6h3E0vWQpysTBoaGvrd9bXh7FlG6irM8GszKB
	mrIwsmg4XsiXJ/tQrFfGFB3qypfTnTDMt4gCo8wmchjl1eWcIXEFg0GARE41YGDOpue7Rp/DgWj4e
	WSGlUyQQNF+To+snnBic/0RDtemxi4/6D5E1iZKCP26rvZilvGOsnM2N9BSjGj8ss8yWDD0iwnObd
	i484b+qQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkvBO-0000000G8wz-34v1;
	Fri, 15 Mar 2024 00:12:22 +0000
Date: Thu, 14 Mar 2024 17:12:22 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	Pankaj Raghav <p.raghav@samsung.com>,
	Daniel Gomez <da.gomez@samsung.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: Max theoretical XFS filesystem size in review
Message-ID: <ZfOSZnYi-02SoBIJ@bombadil.infradead.org>
References: <ZcQDrXwyKxfTYpfL@bombadil.infradead.org>
 <ZcQYIAmiGdEbJCxG@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZcQYIAmiGdEbJCxG@dread.disaster.area>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Thu, Feb 08, 2024 at 10:54:08AM +1100, Dave Chinner wrote:
> On Wed, Feb 07, 2024 at 02:26:53PM -0800, Luis Chamberlain wrote:
> > I'd like to review the max theoretical XFS filesystem size and
> > if block size used may affect this. At first I thought that the limit which
> > seems to be documented on a few pages online of 16 EiB might reflect the
> > current limitations [0], however I suspect its an artifact of both
> > BLKGETSIZE64 limitation. There might be others so I welcome your feedback
> > on other things as well.
> 
> The actual limit is 8EiB, not 16EiB. mkfs.xfs won't allow a
> filesystem over 8EiB to be made.

A truncated 9 EB file seems to go through:

truncate -s 9EB /mnt-pmem/sparse-9eb; losetup /dev/loop0 /mnt-pmem/sparse-9eb
mkfs.xfs -K /dev/loop0
meta-data=/dev/loop0             isize=512    agcount=8185453, agsize=268435455 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
data     =                       bsize=4096   blocks=2197265625000000, imaxpct=1
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=521728, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

Should we be rejecting that?

Joining two 8 EB files with device-mapper seems allowed:

truncate -s 8EB /mnt-pmem/sparse-8eb.1; losetup /dev/loop1 /mnt-pmem/sparse-8eb.1
truncate -s 8EB /mnt-pmem/sparse-8eb.2; losetup /dev/loop2 /mnt-pmem/sparse-8eb.2

cat /home/mcgrof/dm-join-multiple.sh 
#!/bin/sh
# Join multiple devices with the same size in a linear form
# We assume the same size for simplicity
set -e
size=`blockdev --getsz $1`
FILE=$(mktemp)
for i in $(seq 1 $#) ; do
        offset=$(( ($i -1)  * $size))
	echo "$offset $size linear $1 0" >> $FILE
	shift
done
cat $FILE | dmsetup create joined
rm -f $FILE

/home/mcgrof/dm-join-multiple.sh /dev/loop1 /dev/loop2

And mkfs.xfs seems to go through on them, ie, its not rejected

mkfs.xfs -f /dev/mapper/joined
meta-data=/dev/mapper/joined     isize=512    agcount=14551916, agsize=268435455 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
data     =                       bsize=4096   blocks=3906250000000000, imaxpct=1
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=521728, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
Discarding blocks...

I didn't wait, should we be rejecting that?

Using -K does hit some failures on the bno number though:

mkfs.xfs -K -f /dev/mapper/joined
meta-data=/dev/mapper/joined     isize=512    agcount=14551916, agsize=268435455 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
data     =                       bsize=4096   blocks=3906250000000000, imaxpct=1
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=521728, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
mkfs.xfs: pwrite failed: Invalid argument
libxfs_bwrite: write failed on (unknown) bno 0x6f05b59d3b1f00/0x100, err=22
mkfs.xfs: Releasing dirty buffer to free list!
found dirty buffer (bulk) on free list!
mkfs.xfs: pwrite failed: No space left on device
libxfs_bwrite: write failed on (unknown) bno 0x0/0x100, err=28
mkfs.xfs: Releasing dirty buffer to free list!
found dirty buffer (bulk) on free list!
mkfs.xfs: pwrite failed: No space left on device
libxfs_bwrite: write failed on xfs_sb bno 0x0/0x1, err=28
mkfs.xfs: Releasing dirty buffer to free list!
mkfs.xfs: libxfs_device_zero seek to offset 8000000394407514112 failed: Invalid argument

I still gotta chew through the rest of your reply, thanks for the
details!

  Luis
