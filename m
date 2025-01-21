Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA17014B945
	for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2025 04:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737434243; cv=none; b=SxRKpvFXilW82C/4u7jgGjSLlChM1tk/yrD5ib0+7xJ0BEAaveODpIxbaR75qc/7K4veaTcE6V/3qDPtYYoD9behxVZd5Toa5x0Q8bkdZRpY3gmviVGpfND9WfiEwU0yD+P+VnN4bmD3NQblZxuxgEHUFQUUcfIQtnYSqBU3YiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737434243; c=relaxed/simple;
	bh=lmrEYvcnXNDrc5z0lcB4aVXFx1V6FuacUpWd6Jq9B5E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MkXCoqBc1JhjQhbmzahh7VXUchJ+KAZhCqbWc4FG91bO7hkg5tdVCyiyPbDI+rFeYpnAwMI3GHrrqXeRXR5DC1K79rCt2BbwKryRFcWkYXFT2gFIN9ZwaoKMN/dZPvtL3EBLvBCWbmhZeIkc3IAVpM2+J03tbcNvVsjND32OEyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=sJ4Y6AHM; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="sJ4Y6AHM"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2f441791e40so6686814a91.3
        for <linux-xfs@vger.kernel.org>; Mon, 20 Jan 2025 20:37:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1737434240; x=1738039040; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mwYJWpSVjfV80PDTAtmAfxMabJ93HYW8usRB8k0r750=;
        b=sJ4Y6AHM6RzEY7is8JhWVbEXX4sqcf6EooGfo5a2u4mMFIu3oACQo4t7LHTN0APnX9
         Xb3WXpIbIa/Bv0zwLq/kGMYKPt3VAZBWwTqDBZtJcq14Xfk0N7gHunn/MunctelKCAaL
         /YiKDv5vdNiUPFgNq3yk/Qirm5a0LENDimbuCxoRkkbxJSg7l4zEFozCk6aUFlKSQ3ju
         S7EtevDCXG5oKuxjFbSaEk7FiGHQFwcytbgHq7hDmYdheP6Zz+pLAUN8LeRC4Xtc+MnG
         6FFoVJmKC7vW0SWcPQ3ih+Wyq4ww/tHAa25G2QKmYYvdNoFLrpHhJAaVM1rZLgpRim9I
         ROQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737434240; x=1738039040;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mwYJWpSVjfV80PDTAtmAfxMabJ93HYW8usRB8k0r750=;
        b=or5gt4Dk5N8LCLLdJh5hAKvRJEYiKXT2QzICU5BVJHJlq95MMRhM5Py69mfbT2wr9b
         NnGjeo3txEusC5GygDYHJlo37xcna5LAUh+GjXSyCkdBAlKjYESkta5RltOWF7mrNugQ
         3uzQmiVHuNXimpjtvgzOjuNhEmF4Mm61gqVLdGBOvfDL8SbvoCwI6cDHGrPUa2vlh+fe
         AwM5appp22ZlviWv/YXNEgJeh0lfCwckV+ZNRruWLNWe1HWekouQh2FEkOfKGPXy9zIZ
         9qO/MN/SGA6fpeHmI3RODUvvSrh1u4lMLbe6ZVzYiJCBoe5iU4vm1Gx3QYwS0d7T2xR6
         IMCA==
X-Forwarded-Encrypted: i=1; AJvYcCVLAVacpGez5malWIyj87vfQQ8zoLzAYkcQOvz/yvyxUEe34rpU8aXoq2BotBSdQxF0ooWmQYqJFbM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzF+PlltH3akgUyeNuQ4BbfYXXVQn49/bR5xm85Bu1BvKIiLq8s
	YWg6yc1Q9jIFnEGrIgslMJa7cWNXEacDVMQgkbbiD9T42+ApCH0XBPqGZ/64Dgow9+tC2+AqL+9
	v
X-Gm-Gg: ASbGncsLeWHETcdmCYFXcwkkToVAhaf9FNhadmwxb9eHeMvt5vFTwtRnANTTrHB0Iwq
	odBy301m3V88FgLNp2IJ3VknMBkiLo1iyfN2AMuXdW3+id1pGeWnedk487dOTZVtaN7foc7YC0S
	zNMRS6XtTNRTQBNZFXNwJ3TBsiltNTAL3+YVYErxkypBgysqK/mwIHQf3hai09TzVw6TqXhVXso
	Zk9jfRyO4BKZesdqoRPzctRfDcmyJ6pqCq+eSIPO4tbRoxr+JeQNm8sBdn0tNHZM9oD2wQacqPP
	wrCGr9ek4nRJJTYJzDVWqdwIhqS6YdbMEIToqU4D3gT7Lg==
X-Google-Smtp-Source: AGHT+IGEFLNaE3nphpOTmY39cPmXRDrsR9aRwGSHT/LY4/55DiyuaKbgqEvON6IQH+NvLZ9VImrJWw==
X-Received: by 2002:a05:6a00:84f:b0:725:df1a:288 with SMTP id d2e1a72fcca58-72dafaf8ab3mr27252632b3a.24.1737434240001;
        Mon, 20 Jan 2025 20:37:20 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72dab816412sm8146299b3a.66.2025.01.20.20.37.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2025 20:37:19 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1ta60r-00000008Wmt-07Ow;
	Tue, 21 Jan 2025 15:37:17 +1100
Date: Tue, 21 Jan 2025 15:37:17 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/23] common/xfs: find loop devices for non-blockdevs
 passed to _prepare_for_eio_shutdown
Message-ID: <Z48kffpLwUr1xMmT@dread.disaster.area>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
 <173706974243.1927324.9105721327110864014.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173706974243.1927324.9105721327110864014.stgit@frogsfrogsfrogs>

On Thu, Jan 16, 2025 at 03:28:02PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> xfs/336 does this somewhat sketchy thing where it mdrestores into a
> regular file, and then does this to validate the restored metadata:
> 
> SCRATCH_DEV=$TEST_DIR/image _scratch_mount

That's a canonical example of what is called "stepping on a
landmine".

We validate that the SCRATCH_DEV is a block device at the start of
check and each section it reads and runs (via common/config), and
then make the assumption in all the infrastructure that SCRATCH_DEV
always points to a valid block device.

Now we have one new test that overwrites SCRATCH_DEV temporarily
with a file and so we have to add checks all through the
infrastructure to handle this one whacky test?

> Unfortunately, commit 1a49022fab9b4d causes the following regression:
> 
>  --- /tmp/fstests/tests/xfs/336.out      2024-11-12 16:17:36.733447713 -0800
>  +++ /var/tmp/fstests/xfs/336.out.bad    2025-01-04 19:10:39.861871114 -0800
>  @@ -5,4 +5,5 @@ Create big file
>   Explode the rtrmapbt
>   Create metadump file
>   Restore metadump
>  -Check restored fs
>  +Usage: _set_fs_sysfs_attr <mounted_device> <attr> <content>
>  +(see /var/tmp/fstests/xfs/336.full for details)
> 
> This is due to the fact that SCRATCH_DEV is temporarily reassigned to
> the regular file.  That path is passed straight through _scratch_mount
> to _xfs_prepare_for_eio_shutdown, but that helper _fails because the
> "dev" argument isn't actually a path to a block device.

_scratch_mount assumes that SCRATCH_DEV points to a valid block
device. xfs/336 is the problem here, not the code that assumes
SCRATCH_DEV points to a block device....

Why are these hacks needed? Why can't _xfs_verify_metadumps()
loopdev usage be extended to handle the new rt rmap code that this
test is supposed to be exercising? 

> Fix this by detecting non-bdevs and finding (we hope) the loop device
> that was created to handle the mount. 

What loop device? xfs/336 doesn't use loop devices at all.

Oh, this is assuming that mount will silently do a loopback mount
when passed a file rather than a block device. IOWs, it's relying on
some third party to do the loop device creation and hence allow it
to be mounted.

IOWs, this change is addressing a landmine by adding another
landmine.

I really think that xfs/336 needs to be fixed - one off test hacks
like this, while they may work, only make modifying and maintaining
the fstests infrastructure that much harder....

> While we're at it, have the
> helper return the exit code from mount, not _prepare_for_eio_shutdown.

That should be a separate patch.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
