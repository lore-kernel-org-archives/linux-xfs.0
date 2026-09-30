Received: from mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE31310645
	for <linux-xfs@vger.kernel.org>; Wed, 30 Sep 2026 08:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790758146; cv=none; b=Zt/C2EvK3q450UbBMKY432+9ShsY15SVqCr9NgotJVR7iw5MScrWO4yekPI8qTOJbLJAPaYkY4NKLfKn/4iDz3ssrDFJq4BQa0rZEQXXXD7Ol90/f4+Y2m0VAqu4XHdgyIDzWTqsAvou5mlCQTqwhteSNMt5Gc108S8jhGR1SHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790758146; c=relaxed/simple;
	bh=Xep1o9gANQ4iQFQBRobJtQWntsKvFEOabUmZCGy2GVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MZtLGt2GFf5r4X0EyPEi35f5gpM8X6IRrYM7di58laouq92FhwQ89acB9zDiDSQWqxPOJ286sKURs0u4hL5AU6nlzRhDhJxQNRW4jZUka+i587nIknPa6Bd0CjNf8wHNjdMkYhUGMI9J0UBi2aZ00ydOuMu2tzP3x3E5OEYUxO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jRgzWQ8q; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jRgzWQ8q"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Xep1o9gANQ4iQFQBRobJtQWntsKvFEOabUmZCGy2GVo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790758142; v=1; x=1791362942;
 b=jRgzWQ8qK4TnxKgO8/SkB6UYUfCzkMu1gO7hEwaF8Tk6g+tbHHmRaPGJhSIRJM5Dl/+RRR91
 EuLuxxeSR5l6/jMmhRSnEa1T9eYS8/Z3CrVnaghpy2uq3hxzuyn7Pk+u2yfZVLMdSyuCfPsokc+
 J124Kck4nUvk6BPGfs341TQA=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id b7d4f57801047587;
	Wed, 30 Sep 2026 08:49:02 +0000
X-Mizu-Trace-ID: b7d4f57801047587
X-Migadu-Flow: FLOW_OUT
Date: Wed, 30 Sep 2026 08:48:56 +0000
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: "Darrick J. Wong" <djwong@kernel.org>, john.garry@linux.dev
Cc: Pankaj Raghav <p.raghav@samsung.com>, cem@kernel.org, 
	linux-xfs@vger.kernel.org, John Garry <john.g.garry@oracle.com>, gost.dev@samsung.com
Subject: Re: [PATCH] xfs: don't limit software atomic writes by the group
 alignment
Message-ID: <m72iphraf7d3hoziw55inrymk6ynsgl3zio7nyiysm4w2fkac4@jtcaqpvg7g4a>
References: <20260925103640.932735-1-p.raghav@samsung.com>
 <41749fa7-dcfa-46f0-af0f-ed3fa5f39f15@linux.dev>
 <ffd48d49-c4f6-4fc3-88a5-0adb11d0d6b9@linux.dev>
 <20260929164010.GS2705364@frogsfrogsfrogs>
 <20260929204228.GT2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929204228.GT2705364@frogsfrogsfrogs>

> > But I guess I'll play around with it for a while and see if I get
> > anywhere.  Assuming you're running a recent mkfs that knows about
> > the atomic write options and whatnot?
> 
> FWIW I tried this with scsi-debug and got the following:
> 
> # umount /dev/sdg
> # rmmod scsi-debug
> # modprobe scsi-debug dev_size_mb=1000 virtual_gb=4096 atomic_wr=1 atomic_wr_max_length=32
> # xfs_io -c 'statx -r -m all ' /dev/sdg | grep atomic
> stat.atomic_write_unit_min = 1024
> stat.atomic_write_unit_max = 16384
> stat.atomic_write_segments_max = 1
> stat.atomic_write_unit_max_opt = 0
> # mkfs.xfs -f /dev/sdg
> meta-data=/dev/sdg               isize=512    agcount=4, agsize=268435452 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=1
>          =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
>          =                       exchange=1   metadir=0
> data     =                       bsize=4096   blocks=1073741808, imaxpct=5
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=1
> log      =internal log           bsize=4096   blocks=521728, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
>          =                       rgcount=0    rgsize=0 extents
>          =                       zoned=0      start=0 reserved=0
> # mount /dev/sdg /mnt
> # touch /mnt/fubar
> # xfs_io -c 'statx -r -m all' /mnt/fubar | grep atomic
> stat.atomic_write_unit_min = 4096
> stat.atomic_write_unit_max = 16384
> stat.atomic_write_segments_max = 1
> stat.atomic_write_unit_max_opt = 16384
> 
> Note the agsize=268435452, which means that it rounded the AG size down
> to something congruent with the 16k hardware atomic write max.
> 
> (Are you sure you're using mkfs.xfs from xfsprogs 6.16 or newer?)

I noticed the issue when I was running a test on a bare metal server
with xfsprog 7.1.1. But I tried to recreate the issue in a VM where I
was running an old xfsprog. So the values I have posted here are wrong.
Sorry for that.

> # xfs_io -c 'statx -r -m all' /mnt/fubar | grep atomic
> stat.atomic_write_unit_min = 4096
> stat.atomic_write_unit_max = 16384
> stat.atomic_write_segments_max = 1
> stat.atomic_write_unit_max_opt = 16384

However, I still do not understand why do we have to restrict
atomic_write_unit_max (SW based atomics) to 16k here?

Let me take a step back and give a history on why I started to look into
this.

I am running 7.2-rc6 with 7.1.1 xfsprogs on a bare metal server with a
NVMe device that supports atomics.

I am formatting XFS with 16k blocksize.

panky@blixen:~$ df -h /dev/nvme1n1
Filesystem      Size  Used Avail Use% Mounted on
/dev/nvme1n1     14T  179G   14T   2% /mnt/atomssd

panky@blixen:~$ cat /sys/block/nvme1n1/queue/atomic_write_unit_max_bytes
16384

panky@blixen:~$ xfs_info /mnt/atomssd/
meta-data=/dev/nvme1n1           isize=512    agcount=14, agsize=67108863 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=1   metadir=0
data     =                       bsize=16384  blocks=937558016, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=16384  ascii-ci=0, ftype=1, parent=1
log      =internal log           bsize=16384  blocks=130432, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=16384  blocks=0, rtextents=0
         =                       rgcount=0    rgsize=0 extents
         =                       zoned=0      start=0 reserved=0

panky@blixen:~/tools$ sudo ./statx /mnt/atomssd/hello.txt
[sudo: authenticate] Password:
/mnt/atomssd/hello.txt:
  stx_atomic_write_unit_min:            16384
  stx_atomic_write_unit_max:            16384
  stx_atomic_write_unit_max_opt:        0
  stx_atomic_write_segments_max:        1

We expose max_opt to be 0, which means the application can assume
max_opt to be the same as atomic_write_unit_max. But why are we not
exposing bigger atomic_write_unit_max (SW atomics) here and make max_opt
to HW based atomics value (16k) in this case?

Could you format your scsi-debug device with 16k fsblock size and see
what values you are getting here?

-- 
Pankaj
