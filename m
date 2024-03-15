Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE6F10E4
	for <linux-xfs@vger.kernel.org>; Fri, 15 Mar 2024 01:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710465252; cv=none; b=ZgDMICE4l4BQdAGU/kviNQnd65vvtkpVLJ/CuiMZcxK1CF6+Zh0wW8HvT4mFT4xItOeq0YogDJ1Aj2/kVmPIgV/66X63Jr6LslQAvwZeKRnlz7v8qWC/d/RZoYq7F8XdlP9+0iBrH2kfnlQHYHQptwoI/F2WqAqvYLEcDf4B7bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710465252; c=relaxed/simple;
	bh=BVbPSnEH6oOAJmStElggC8arV9zPSVdaLXDCP+6/6Dw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AJtsnRzvQB7DGSK3wqXiB/+GGJjMkK/6yh73NJCGHKw9EohvsQzvRoDoPCkAEQyVXjwl0NEpLdQ3Z8EXVOQMKo4uICpY+vJoyWWbFgLXw4ZCygg/V4zKm3ObvzWGRm16Bl6TWnGYO2l8P7AIG7yeZSa5udnPKA3leg0kiDXxH5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=i8Nk0jst; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="i8Nk0jst"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-5d8b70b39efso1265744a12.0
        for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2024 18:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1710465250; x=1711070050; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Bnqn4vCasWpRVYbqUDvXzd8UpnATH6S3cp55HN3voNQ=;
        b=i8Nk0jstt39XMiwiHfU9NobhkRIkTzWz4YpaggHJvI3wej2+eTgt6iYN34fLUHP662
         qTRXRKzDMjp1BMlnUG70cUr9eMJDwVdR+we8cEG90w3tgf+1ehQ5mAZMnBxI4HPLAJlw
         QTf80NV7sU77Ho9ZSgTbVal9biZAI0QpWHUhgyO8th50Pi80XQc43DSmjsX/4H44T/OG
         jLBYty9lYkGmw7URZI1WH7QnMQlsm20XjnE+2IIG5UkhzxgDoWIiYPZJuOw2mTSOHXcl
         wqW8G2MEjd55OrZfI8S8SW0gISNKPCtGjZAH/1cB15DzEhRpzz2jIH6l6c0+phA13xou
         lLgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710465250; x=1711070050;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bnqn4vCasWpRVYbqUDvXzd8UpnATH6S3cp55HN3voNQ=;
        b=YuMcE9NRYUu64OPpLwB46xrB78481P5rPF6pUbtX390daGIiS0mY6d+QIwDuQ9lZG7
         b/kXE+XposyQyta5HZy65B01wQrYATvzmscpeRZ1MhaYh6URrmMm1EE/TitRGclNE//c
         Cww+jVe3frLVGJsklwuX4DxwWxQEIOQvi/liMvr5B+3rR7VKGhJdXj+IQDP+2zHiypQZ
         wulMHdfYp4IWFizEQnhoC4d95+ETD8Hy4i410P7HTlc9ObzUitpKkVI55UDPifqn0Yad
         Oly35kpqO0Sn8yt5wjK+WLAYBv1wm9N8BEFm1wdZiRD1p/Ybn1AaFpXb2FaVjzz8Og0h
         HOiw==
X-Gm-Message-State: AOJu0Yzj8drVZblsXzXB2mwG2Ph6Xf6tGT0zhsL5PfkrsSls1GsxhD/I
	7vQGy3EST762oSN/GY8ec1hMyv+HpzDmPVgwpYd8xPKGiz1NpR6GUDp9XRVcGoT2sq6rg9u4Clk
	K
X-Google-Smtp-Source: AGHT+IEiX9fNJ+01zFPKywmWQEaQG3HyzsDGc/o5wZMVeUc6npgP8duXiudOec2u9NGrFrYpRO6wrQ==
X-Received: by 2002:a05:6a20:7788:b0:1a1:51e0:8665 with SMTP id c8-20020a056a20778800b001a151e08665mr1663463pzg.55.1710465249762;
        Thu, 14 Mar 2024 18:14:09 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-185-123.pa.nsw.optusnet.com.au. [49.180.185.123])
        by smtp.gmail.com with ESMTPSA id q14-20020a17090311ce00b001dc71ead7e5sm2426235plh.165.2024.03.14.18.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Mar 2024 18:14:09 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rkw97-0022xU-1o;
	Fri, 15 Mar 2024 12:14:05 +1100
Date: Fri, 15 Mar 2024 12:14:05 +1100
From: Dave Chinner <david@fromorbit.com>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	Pankaj Raghav <p.raghav@samsung.com>,
	Daniel Gomez <da.gomez@samsung.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: Max theoretical XFS filesystem size in review
Message-ID: <ZfOg3dTO/R43FGiZ@dread.disaster.area>
References: <ZcQDrXwyKxfTYpfL@bombadil.infradead.org>
 <ZcQYIAmiGdEbJCxG@dread.disaster.area>
 <ZfOSZnYi-02SoBIJ@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfOSZnYi-02SoBIJ@bombadil.infradead.org>

On Thu, Mar 14, 2024 at 05:12:22PM -0700, Luis Chamberlain wrote:
> On Thu, Feb 08, 2024 at 10:54:08AM +1100, Dave Chinner wrote:
> > On Wed, Feb 07, 2024 at 02:26:53PM -0800, Luis Chamberlain wrote:
> > > I'd like to review the max theoretical XFS filesystem size and
> > > if block size used may affect this. At first I thought that the limit which
> > > seems to be documented on a few pages online of 16 EiB might reflect the
> > > current limitations [0], however I suspect its an artifact of both
> > > BLKGETSIZE64 limitation. There might be others so I welcome your feedback
> > > on other things as well.
> > 
> > The actual limit is 8EiB, not 16EiB. mkfs.xfs won't allow a
> > filesystem over 8EiB to be made.
> 
> A truncated 9 EB file seems to go through:

<sigh>

9EB  = 9000000000000000000
8EiB = 9223372036854775808

So, 9EB < 8EiB and yes, mkfs.xfs will accept anything smaller than
8EiB...

> truncate -s 9EB /mnt-pmem/sparse-9eb; losetup /dev/loop0 /mnt-pmem/sparse-9eb
> mkfs.xfs -K /dev/loop0
> meta-data=/dev/loop0             isize=512    agcount=8185453, agsize=268435455 blks

yup, agcount is clearly less than 8388608, so you've screwed up your
units there...

> Joining two 8 EB files with device-mapper seems allowed:
> 
> truncate -s 8EB /mnt-pmem/sparse-8eb.1; losetup /dev/loop1 /mnt-pmem/sparse-8eb.1
> truncate -s 8EB /mnt-pmem/sparse-8eb.2; losetup /dev/loop2 /mnt-pmem/sparse-8eb.2
> 
> cat /home/mcgrof/dm-join-multiple.sh 
> #!/bin/sh
> # Join multiple devices with the same size in a linear form
> # We assume the same size for simplicity
> set -e
> size=`blockdev --getsz $1`
> FILE=$(mktemp)
> for i in $(seq 1 $#) ; do
>         offset=$(( ($i -1)  * $size))
> 	echo "$offset $size linear $1 0" >> $FILE
> 	shift
> done
> cat $FILE | dmsetup create joined
> rm -f $FILE
> 
> /home/mcgrof/dm-join-multiple.sh /dev/loop1 /dev/loop2
> 
> And mkfs.xfs seems to go through on them, ie, its not rejected

Ah, I think mkfs.xfs has a limit of 8EiB on image files, maybe not
on block devices. What's the actual limit of block device size on
Linux?

> mkfs.xfs -f /dev/mapper/joined
> meta-data=/dev/mapper/joined     isize=512    agcount=14551916, agsize=268435455 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=1
>          =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
> data     =                       bsize=4096   blocks=3906250000000000, imaxpct=1
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=521728, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> Discarding blocks...
> 
> I didn't wait, should we be rejecting that?

Probably. mkfs.xfs uses uint64_t for the block counts and
arithmetic, so all the size and geometry calcs should work. The
problem is when we translate those sizes to byte counts, and then th
elinux kernel side has all sorts of problems because many things
described in bytes (like off_t and loff_t) are signed. Hence while
you might be able to make block devices larger than 8EiB, I'm pretty
sure you can't actually do things like pread()/pwrite() at offsets
above 8EiB on block devices....

> Using -K does hit some failures on the bno number though:
> 
> mkfs.xfs -K -f /dev/mapper/joined
> meta-data=/dev/mapper/joined     isize=512    agcount=14551916, agsize=268435455 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=1
>          =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
> data     =                       bsize=4096   blocks=3906250000000000, imaxpct=1
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=521728, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> mkfs.xfs: pwrite failed: Invalid argument
> libxfs_bwrite: write failed on (unknown) bno 0x6f05b59d3b1f00/0x100, err=22

daddr is 0x6f05b59d3b1f00. So lets convert that to a byte based
offset from a buffer daddr:

$ printf "0x%llx\n" $(( 0x6f05b59d3b1f00 << 9  ))
0xde0b6b3a763e0000
$

It's hard to see, but if I write it as 16 bit couplets:

	0xde0b 6b3a 763e 0000

You can see the high bit in the file offset is set, and so that's a
write beyond 8EiB that returned -EINVAL. That exactly what
rw_verify_area() returns when loff_t *pos < 0 when the file does not
assert FMODE_UNSIGNED_OFFSET. No block based filesystem nor do block
devices assert FMODE_UNSIGNED_OFFSET, so this write should always
fail with -EINVAL.

And where did it fail? You used "-f" which set force_overwrite,
which means we do a bit of zeroing of potential locations for old
XFS structures (secondary superblocks) and that silently swallows IO
failures, so it wasn't that. The next thing it does is whack
potential MD and GPT records at the end of the filesystem and that's
done in IO sizes of:

/*
 * amount (in bytes) we zero at the beginning and end of the device to
 * remove traces of other filesystems, raid superblocks, etc.
 */
#define WHACK_SIZE (128 * 1024)

128kB IOs. The above IO that failed with -EINVAL is a 128kB IO
(0x100 basic blocks). This will emit a warning message that the IO
failed (as per above), but it also swallows IO errors and lets mkfs
continue.

> mkfs.xfs: Releasing dirty buffer to free list!
> found dirty buffer (bulk) on free list!
> mkfs.xfs: pwrite failed: No space left on device
> libxfs_bwrite: write failed on (unknown) bno 0x0/0x100, err=28

Yup, that's the next write to zap the first blocks of the device to
get rid of primary superblocks and other signatures from other types
of filesytsems and partition tables. That failed with -ENOSPC, which
implies something went wrong in the dm/loop device IO/backing
file IO stage. Likely an 8EiB overflow problem somewhere.

> mkfs.xfs: Releasing dirty buffer to free list!
> found dirty buffer (bulk) on free list!
> mkfs.xfs: pwrite failed: No space left on device
> libxfs_bwrite: write failed on xfs_sb bno 0x0/0x1, err=28

And that's the initial write of the superblock (single 512 byte
sector write) that failed with ENOSPC. Same error as the previous
write, same likely cause.

> mkfs.xfs: Releasing dirty buffer to free list!
> mkfs.xfs: libxfs_device_zero seek to offset 8000000394407514112 failed: Invalid argument

And yeah, their's the smoking gun: mkfs.xfs is attempting to seek to
an offset beyond 8EiB on the block device and that is failing.

IOWs, max supported block device size on Linux is 8EiB. mkfs.xfs
should really capture some of these errors, but largely the problem
here is that dm is allowing an unsupported block device mapping
to be created...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
