Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADA53783CC
	for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2026 17:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791395012; cv=none; b=qGKUo/9NHmyTyPH7L7CG3mt4Dj7XgFBBNdf54QT1es+zPlXMhEig4LUlAa0vov8umwjpCTjXzkUUIHCnAtjFoRuPedwz5+kMtObVyU1mLN8GKC+f1c9dzkoUUZOdwhPzFad8xkzozae+fh2cW6f8MKcBNNgnbyfHAXbX5vzGy98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791395012; c=relaxed/simple;
	bh=TimQYC97NWsUqjJB/l6Z8ZiaaAbdTs/a/hu7T8f/Ckk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TwFRat3Z7uYZU5XLpjMPUJMCAKp8RaYXVZ77CB48wSnHlahTvZjNabGDbPbP1FpqFrPvEFjZ/fMJM3VTvuEsB8M2WHoYCAG2uks2nSz21P3gXo0Ii0oINQ+V/52nLoIaFDuY9dSZEhWMfrBRd4kMIubJ4EsG2rbyVHMTn7bLJE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hz4a/f3L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hz4a/f3L"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id ECB681F000FF;
	Wed,  7 Oct 2026 17:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791395011;
	bh=etzqpuKTD65fI2kXayPxE5KILMKT3Xocnu6Ej/qgvLU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Hz4a/f3LrfXXQAAOAEPo+sC31kcLKmdW+4lVrnY9ddG4xRjBx16hMiRgCpT8UUPn8
	 0DHBTgbuoPWDJILOCL0cermyT0A4KAnA2O5L7CjxoGQJxd6tVdufY95NIJfWpG7QxJ
	 w8yRkwKQEqclpAoz+S8znTOPa21JPH7myG2dVuWIVEDRT9gJ0hTn5Cvn8IuF2IHT3l
	 dJagOc2SxDFqdlboHVZOzSJt16MUF+0PFj4oKVPMC4V6+EcQENYylyi5Br+LQt0rGb
	 1Q8c9McnFSKyrTNgAo8LVLJjyzb4eWx6ynkCc9vPADy5IP8x4vL/B9AudNf2N0RbeZ
	 /H9fPsuwALV8w==
Date: Wed, 7 Oct 2026 10:43:30 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
Cc: john.garry@linux.dev, Pankaj Raghav <p.raghav@samsung.com>,
	cem@kernel.org, linux-xfs@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>, gost.dev@samsung.com
Subject: Re: [PATCH] xfs: don't limit software atomic writes by the group
 alignment
Message-ID: <20261007174330.GK2705364@frogsfrogsfrogs>
References: <20260925103640.932735-1-p.raghav@samsung.com>
 <41749fa7-dcfa-46f0-af0f-ed3fa5f39f15@linux.dev>
 <ffd48d49-c4f6-4fc3-88a5-0adb11d0d6b9@linux.dev>
 <20260929164010.GS2705364@frogsfrogsfrogs>
 <20260929204228.GT2705364@frogsfrogsfrogs>
 <m72iphraf7d3hoziw55inrymk6ynsgl3zio7nyiysm4w2fkac4@jtcaqpvg7g4a>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m72iphraf7d3hoziw55inrymk6ynsgl3zio7nyiysm4w2fkac4@jtcaqpvg7g4a>

On Wed, Sep 30, 2026 at 08:48:56AM +0000, Pankaj Raghav (Samsung) wrote:
> > > But I guess I'll play around with it for a while and see if I get
> > > anywhere.  Assuming you're running a recent mkfs that knows about
> > > the atomic write options and whatnot?
> > 
> > FWIW I tried this with scsi-debug and got the following:
> > 
> > # umount /dev/sdg
> > # rmmod scsi-debug
> > # modprobe scsi-debug dev_size_mb=1000 virtual_gb=4096 atomic_wr=1 atomic_wr_max_length=32
> > # xfs_io -c 'statx -r -m all ' /dev/sdg | grep atomic
> > stat.atomic_write_unit_min = 1024
> > stat.atomic_write_unit_max = 16384
> > stat.atomic_write_segments_max = 1
> > stat.atomic_write_unit_max_opt = 0
> > # mkfs.xfs -f /dev/sdg
> > meta-data=/dev/sdg               isize=512    agcount=4, agsize=268435452 blks
> >          =                       sectsz=512   attr=2, projid32bit=1
> >          =                       crc=1        finobt=1, sparse=1, rmapbt=1
> >          =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
> >          =                       exchange=1   metadir=0
> > data     =                       bsize=4096   blocks=1073741808, imaxpct=5
> >          =                       sunit=0      swidth=0 blks
> > naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=1
> > log      =internal log           bsize=4096   blocks=521728, version=2
> >          =                       sectsz=512   sunit=0 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> >          =                       rgcount=0    rgsize=0 extents
> >          =                       zoned=0      start=0 reserved=0
> > # mount /dev/sdg /mnt
> > # touch /mnt/fubar
> > # xfs_io -c 'statx -r -m all' /mnt/fubar | grep atomic
> > stat.atomic_write_unit_min = 4096
> > stat.atomic_write_unit_max = 16384
> > stat.atomic_write_segments_max = 1
> > stat.atomic_write_unit_max_opt = 16384
> > 
> > Note the agsize=268435452, which means that it rounded the AG size down
> > to something congruent with the 16k hardware atomic write max.
> > 
> > (Are you sure you're using mkfs.xfs from xfsprogs 6.16 or newer?)
> 
> I noticed the issue when I was running a test on a bare metal server
> with xfsprog 7.1.1. But I tried to recreate the issue in a VM where I
> was running an old xfsprog. So the values I have posted here are wrong.
> Sorry for that.
> 
> > # xfs_io -c 'statx -r -m all' /mnt/fubar | grep atomic
> > stat.atomic_write_unit_min = 4096
> > stat.atomic_write_unit_max = 16384
> > stat.atomic_write_segments_max = 1
> > stat.atomic_write_unit_max_opt = 16384
> 
> However, I still do not understand why do we have to restrict
> atomic_write_unit_max (SW based atomics) to 16k here?
> 
> Let me take a step back and give a history on why I started to look into
> this.
> 
> I am running 7.2-rc6 with 7.1.1 xfsprogs on a bare metal server with a
> NVMe device that supports atomics.
> 
> I am formatting XFS with 16k blocksize.
> 
> panky@blixen:~$ df -h /dev/nvme1n1
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/nvme1n1     14T  179G   14T   2% /mnt/atomssd
> 
> panky@blixen:~$ cat /sys/block/nvme1n1/queue/atomic_write_unit_max_bytes
> 16384
> 
> panky@blixen:~$ xfs_info /mnt/atomssd/
> meta-data=/dev/nvme1n1           isize=512    agcount=14, agsize=67108863 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=1
>          =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
>          =                       exchange=1   metadir=0
> data     =                       bsize=16384  blocks=937558016, imaxpct=5
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=16384  ascii-ci=0, ftype=1, parent=1
> log      =internal log           bsize=16384  blocks=130432, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=16384  blocks=0, rtextents=0
>          =                       rgcount=0    rgsize=0 extents
>          =                       zoned=0      start=0 reserved=0
> 
> panky@blixen:~/tools$ sudo ./statx /mnt/atomssd/hello.txt
> [sudo: authenticate] Password:
> /mnt/atomssd/hello.txt:
>   stx_atomic_write_unit_min:            16384
>   stx_atomic_write_unit_max:            16384
>   stx_atomic_write_unit_max_opt:        0
>   stx_atomic_write_segments_max:        1
> 
> We expose max_opt to be 0, which means the application can assume
> max_opt to be the same as atomic_write_unit_max. But why are we not
> exposing bigger atomic_write_unit_max (SW atomics) here and make max_opt
> to HW based atomics value (16k) in this case?
> 
> Could you format your scsi-debug device with 16k fsblock size and see
> what values you are getting here?

(Apologies, this one slipped into the cracks)

I can't get the scsi-debug device to format with 16k lbas for whatever
reason, but I can simulate the xfs parts with my dumb script:

#!/bin/bash -x

# fiddle with scsi-debug and xfs atomics

dev="$(lsscsi | grep scsi_debug | awk '{print $6}')"
mnt="${1:-/mnt/s}"
hw_awu="${2:-16834}"
sectsz="${3:-512}"
align="$4"

umount "${mnt}" ${dev}
rmmod scsi-debug

scsi_debug_args=(dev_size_mb=1000 virtual_gb=4096)
if [ "${hw_awu}" -ge 512 ]; then
	scsi_debug_args+=(atomic_wr=1 atomic_wr_max_length=$((hw_awu / 512)))
fi
modprobe scsi-debug "${scsi_debug_args[@]}"
dev="$(lsscsi | grep scsi_debug | awk '{print $6}')"
xfs_io -c 'statx -r -m all' $dev | grep atomic

if [ "${sectsz}" -le 4096 ]; then
	blksz=4096
else
	blksz="${sectsz}"
fi

mkfs_args=(-f "${dev}" -s size="${sectsz}" -b size="${blksz}")
if [ -n "${align}" ]; then
	max_agsize=$((1 << 40))		# bytes
	agsize=$(((max_agsize / blksz) - 1))	# blocks
	align=$((align / blksz))	# convert to blocks

	mkfs_args+=(-d agsize="$(( agsize & ~(align - 1) ))b")
fi
mkfs.xfs "${mkfs_args[@]}"
mount "${dev}" "${mnt}"

touch "${mnt}/fubar"
xfs_io -c 'statx -r -m all' "${mnt}/fubar" | grep atomic

So, with an XFS sector size of 16k and an atomic write max of 32k, we
get:

# /code/t/atomicswap/align.sh '' 32768 16384
umount: /dev/sdg: not mounted.
stat.atomic_write_unit_min = 1024
stat.atomic_write_unit_max = 32768
stat.atomic_write_segments_max = 1
stat.atomic_write_unit_max_opt = 0
meta-data=/dev/sdg               isize=512    agcount=4, agsize=67108862 blks
         =                       sectsz=16384 attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=1   metadir=1
data     =                       bsize=16384  blocks=268435448, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=16384  ascii-ci=0, ftype=1, parent=1
log      =internal log           bsize=16384  blocks=130432, version=2
         =                       sectsz=16384 sunit=1 blks, lazy-count=1
realtime =none                   extsz=16384  blocks=0, rtextents=0
         =                       rgcount=0    rgsize=67108864 extents
         =                       zoned=0      start=0 reserved=0
stat.atomic_write_unit_min = 16384
stat.atomic_write_unit_max = 32768
stat.atomic_write_segments_max = 1
stat.atomic_write_unit_max_opt = 32768

Note that the AG size is aligned to the hardware max (32k) and both the
hardware and software awu are set to 32k.  Now let's try it again but
forcing the AG size to be aligned to a megabyte:

# /code/t/atomicswap/align.sh '' 32768 16384 1048576
umount: /dev/sdg: not mounted.
stat.atomic_write_unit_min = 1024
stat.atomic_write_unit_max = 32768
stat.atomic_write_segments_max = 1
stat.atomic_write_unit_max_opt = 0
meta-data=/dev/sdg               isize=512    agcount=4, agsize=67108800 blks
         =                       sectsz=16384 attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=1   metadir=1
data     =                       bsize=16384  blocks=268435200, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=16384  ascii-ci=0, ftype=1, parent=1
log      =internal log           bsize=16384  blocks=130432, version=2
         =                       sectsz=16384 sunit=1 blks, lazy-count=1
realtime =none                   extsz=16384  blocks=0, rtextents=0
         =                       rgcount=0    rgsize=67108864 extents
         =                       zoned=0      start=0 reserved=0
stat.atomic_write_unit_min = 16384
stat.atomic_write_unit_max = 1048576
stat.atomic_write_segments_max = 1
stat.atomic_write_unit_max_opt = 32768

Now the software atomic write max jumps to 1MB.

So I think I finally (re)understand what's going on here.  In the first
case, mkfs detects the 32k hw awu_max and automatically aligns the AGs
to 32k.  This is done so that when we feed "align=32k" into the per-AG
allocator, it will (maybe) give us new space that's aligned to 32k
within the AG, which when combined with the AG alignment of 32k means
that the allocation is aligned to 32k on the device.  Excellent!

But what you're saying is that you want the *software* awu_max to be
whatever the log will support:

# /code/t/atomicswap/align.sh '' 0 16384
umount: /dev/sdg: not mounted.
stat.atomic_write_unit_min = 0
stat.atomic_write_unit_max = 0
stat.atomic_write_segments_max = 0
stat.atomic_write_unit_max_opt = 0
meta-data=/dev/sdg               isize=512    agcount=4, agsize=67108863 blks
         =                       sectsz=16384 attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=1   metadir=1
data     =                       bsize=16384  blocks=268435452, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=16384  ascii-ci=0, ftype=1, parent=1
log      =internal log           bsize=16384  blocks=130432, version=2
         =                       sectsz=16384 sunit=1 blks, lazy-count=1
realtime =none                   extsz=16384  blocks=0, rtextents=0
         =                       rgcount=0    rgsize=67108864 extents
         =                       zoned=0      start=0 reserved=0
stat.atomic_write_unit_min = 16384
stat.atomic_write_unit_max = 67108864
stat.atomic_write_segments_max = 1
stat.atomic_write_unit_max_opt = 0

Which is 64MB.  The software fallback doesn't care about allocation
alignment, and advertising the smaller atomic_write_unit_max is a quirk
from the days when we didn't have atomic_write_unit_max_opt, so
constraining it was the only way to prohibit programs from sending
atomic writes that most likely wouldn't turn into hardware atomic
writes.

Ok now that I grasp what you're getting at, I'll go read your v2 patch.

--D
