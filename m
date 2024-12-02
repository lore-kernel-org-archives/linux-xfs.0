Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A401DED5C
	for <linux-xfs@vger.kernel.org>; Mon,  2 Dec 2024 23:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733182819; cv=none; b=AQ0kErXj3/nEXHWivzxdjp8qglG7XxPl4vCwXzb1G5j2ZQqX0iaHcP2mKurg9jfRLxjlYD4+jp4EurxBCRAzY8avv7y0RW6XqijvNh1rIFMRtAIUr7FEfAccMOO77q8B/BzfyVq2zAMVbelVv4s+vpVPBnlN60p+hfonzX7SC6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733182819; c=relaxed/simple;
	bh=S2/pf4/Sny3dzQoB3HqB+kfuzkj5KCuCKY68A8Ka8x8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rwxrgtBJFSDrhm7KPtT3O1hweDbFQIWlLWM83ovmd6BAkmVovUWCE13JNBspOo6S6pCBPQ9HMa4Z3xqkCFsXzw6/Z4C0ZXo/mdUPObqNB/zRSmY0vAwt65hJMb/RirIDpxv1dWTCwt8G0F+1uFJzQaeJyKzkVCQzoOv1SBjDoNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Xvazv9kr; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Xvazv9kr"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2eeb2e749c5so1475548a91.0
        for <linux-xfs@vger.kernel.org>; Mon, 02 Dec 2024 15:40:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1733182816; x=1733787616; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Q9Nh9U8NyHSxgOJLhD4n44XfqPVcBqJSvejh+zARxr8=;
        b=Xvazv9krLI3A7a12fKl0ZYMybFqveDrZJDyMI+mEa7R1/gUQUJ6LeLRVFJlfUBW8la
         x/WoZhU2QvXbi9nCdGhywh/AYxuo5BwutoC9yqFpR+VEDWXJeSFiY+QYTuT4E1usKA1V
         7/AQriphlLwI2HTp0Wa3RX1ut/OMNs7B7WIWTWoNpPtgZPwKHTFRR6xu5NdYx7ks+qSi
         uJX/a0nUvY7nKLZJc+TraJtEcru6VTc8lqcjZFCOCvINBnFCh3h6vg/4mkMuZvyZLgdI
         bI9TM7ZAkN6AsdPRiGjDOomkD0Sk73K1Qj8m8tl1HsaSwLSELOMjxDEDBkYLtBFnel7Q
         yCTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733182816; x=1733787616;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q9Nh9U8NyHSxgOJLhD4n44XfqPVcBqJSvejh+zARxr8=;
        b=OmgAA5ZWkXu7zGjFA4mR5UILaNBkUQj7XIEdMvLYnntANja9JVZ0Aqszf91rhJQ56B
         RHCOEzLPmdgrORxZQaX9huS8nEtP0aCeGZxvk240wJ7kHB60CDMKXM1idBso9SzYm5h8
         4EEmoehAsJs0py3AovCqdiJZVGTqKOdKxWKELNc9aJ7Sv43f5J+Whup0+LDnculOLyXe
         KmqcOcqo/ps9gqFlijfyEkgz5boxTh4kB5dBKLjigxRezomnRofu5PmoiyU9coCXG+dm
         DbU6f2yc+rIt1ez3a2v1OlwTRMXeiOL3AAfHfjfzj9zuvRBMcwkQMyGMyP5kAOptyFN/
         ixSw==
X-Gm-Message-State: AOJu0Yy9xKD91lfGJrUh/zzAYGXDhqzLOmWNEPrN8wclvgDIohiolonS
	/heKI/22u9nupQpBJoh6Gf+HyA76VTufv7IbJ22k8KNaSU8/KY72ewZZnrfyrV8=
X-Gm-Gg: ASbGnctiA6gMw8ohTGlhHttdZJL+yZfuMy2Q1EOq1Lj/bptY9UtNOq28U3Ordd+lwyK
	ayzUfUuVg1PY+widHeoNGeNRKBqK/2LOWQ0xOZBPW4ZjEAvM/2d3Oq3eCLYHyTQpDgByXgdrTzS
	0beDHubX7/Qz2BAqeYkwhMpybiUSIc8TKmT2YSb5B+Fa5g2zPlxvxFGuiuj/zUvNRHYYMGi8vw/
	xx9A2sqNmnqObgESpn3by098cyVnrU3675hx1tE5HQhMcz7p+RSMipYG2O/O0j1yeaHd51oLH3P
	fBoyLWI2LOYTA0bFjgOcE8956Q==
X-Google-Smtp-Source: AGHT+IHglitgdJcSfLIlIMFRbTVmDlu/q4hFMfOCSusLUbi7HiiMqG2WaLaqNQky94Zo4yUAntNQ5A==
X-Received: by 2002:a17:90a:d450:b0:2ee:d96a:5831 with SMTP id 98e67ed59e1d1-2ef01259f11mr640368a91.30.1733182816577;
        Mon, 02 Dec 2024 15:40:16 -0800 (PST)
Received: from dread.disaster.area (pa49-180-121-96.pa.nsw.optusnet.com.au. [49.180.121.96])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ee69fa82ecsm6256511a91.44.2024.12.02.15.40.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2024 15:40:15 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tIG1U-00000005uzC-2e9k;
	Tue, 03 Dec 2024 10:40:12 +1100
Date: Tue, 3 Dec 2024 10:40:12 +1100
From: Dave Chinner <david@fromorbit.com>
To: Mitta Sai Chaithanya <mittas@microsoft.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: XFS: Approach to persist data & metadata changes on original
 file before IO acknowledgment when file is reflinked
Message-ID: <Z05FXA2ScHuEf2UW@dread.disaster.area>
References: <PUZP153MB07280F8AE7FA1BB00946E25CD7352@PUZP153MB0728.APCP153.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <PUZP153MB07280F8AE7FA1BB00946E25CD7352@PUZP153MB0728.APCP153.PROD.OUTLOOK.COM>

[please wrap your emails at 72 columns]

On Mon, Dec 02, 2024 at 10:41:02AM +0000, Mitta Sai Chaithanya wrote:
> Hi Team,

>       We are using XFS reflink feature to create snapshot of an
> origin file (a thick file, created through fallocate) and exposing
> origin file as a block device to the users.

So it's basically a loop block device?

All the questions you are asking are answered by studying how
drivers/block/loop.c translates block device integrity requests
to VFS operations on the backing file.

The block device API has a mechanism for triggering integrity
operations: REQ_PREFLUSH to flush volatile caches, and REQ_FUA to
ask for a specific IO to be persisted to stable storage.

The loop device translates REQ_PREFLUSH to vfs_fsync() on the
backing file, and REQ_FUA is emulated by write/vfs_fsync_range().
I have a patch to natively support REQ_FUA by converting it to
a RWF_DSYNC write call, which allows the underlying filesystem to
convert that data integrity write to a REQ_FUA write w/ O_DIRECT...


> XFS file was opened
> with O_DIRECT option to avoid buffers at lower layer while
> performing writes, even though a thick file is created, when user
> performs writes then there are metadata changes associated to
> writes (mostly xfs marks extents to know whether the data is
> written to physical blocks or not).

This is not specific to O_DIRECT - even buffered writes need to do
post data-IO unwritten extent conversion on the first write to any
file data.

> To avoid metadata changes
> during user writes we are explicitly zeroing entire file range
> post creation of file, so that there won't be any metadata changes
> in future for writes that happen on zeroed blocks.

Which makes fallocate() redundant. Simply writing zeroes to an empty
file will allocate and mark the extents as written.  Run fsync at
the end of the writes, and then there are no metadata updates other
than timestamps for future overwrites.

Until, of course ....

>       Now, if reflink copy of origin file is created then there
> will be metadata changes which need to be persisted if data is
> overwritten on the reflinked blocks of original file.

.... you share the data extents between multiple inodes.

Then every data write that needs to break extent sharing will
trigger a COW that allocates new extents, hence requiring metadata
modification both before the data IO is submitted and again after it
is completed.

> Even though
> the file is opened in O_DIRECT mode changes to metadata do not
> persist before write is acknowledged back to user,

O_DIRECT by itself does not imply -any- data integrity nor any
specific data/metadata ordering. Filesystems and block devices are
free to treat O_DIRECT writes in any way they want w.r.t. caching,
(lack of) crash resilience, etc.

> if system
> crashes when changes are in buffer then post recovery writes which
> were acknowledged are not available to read.

Well, yes.

You need to combine O_DIRECT with O_DSYNC/O_SYNC/f[data]sync for it
to have any meaning for the persistence of the data and metadata
needed to retrieve the data being written.

> Two options that we
> were aware to avoid consistency issue is:
> 
> 1. Adding O_SYNC flag while opening file which ensures each write
> gets persisted in persistent media, but this leads to poor
> performance.

"Poor performance" == "exact capability of the storage hardware to
persist data".

i.e. performance of O_DIRECT writes with data integrity requirement
is directly determined by the speed with which the storage device
can persist the data.

A filesystem like XFS will require two IOs to persist data written
to a newly allocated extent, and they are dependent writes. We have
no mechanism for telling block devices that they must order writes
to persistent storage in a specific manner, so our only tool for
ensuring that the block device orders the data and metadata IOs
correctly is to issue a REQ_PREFLUSH between the two IOs. We do this
with the journal IO, as it is the IO that requires all data writes
to be persistent before we persist the metadata in the journal....

If you can use AIO/io_uring, then the latency of these dependent
writes can be hidden as the process does not block waiting for two
IOs to complete. It can process more IO submissions whilst the data
integrity write is in flight. Then performance is not limited by
synchronous data integrity IO latency....

> 2. Performing sync operation along with writes/post writes will
> guarantees that metadata changes will be persisted.

Yes, but that will only result in faster IO if the fdatasync calls
are batched for multiple data IOs.

i.e. for O_DIRECT, fdatasync() is effectively REQ_PREFLUSH|REQ_FUA
journal write. If you are issuing one fdatasync per write, there
is no benefit over O_DSYNC.

And if you can batch O_DIRECT writes per fdatasync() call, then the
block device has a volatile cache, and then the upper block device
REQ_PREFLUSH and REQ_FUA operations need to be obeyed. IOWs, if
you can amortise fdatasync across multiple IOs, then you may as well
just advertise the device as having volatile caches and simply
rely on the upper filesystem (i.e. whatever is on the block device)
to issue data integrity flushes as appropriate....

i.e. this is the model the block loop device implements.

> Are there any other option available to avoid the above
> consistency issue (Without much degradation in performance)? 

There is little anyone can do to reduce the latency of individual IO
completion to stable storage - single threaded, synchronous data
integrity IO is always going to have a significant completion
latency penalty. To mitigate this the storage stack and/or
applications need to be architected to work in a way that isn't
directly IO latency sensitive.

As I said at the start, study the block loop device architecture and
pay attention to how it implements REQ_PREFLUSH and the AIO+DIO
backing file IO submission and completion signalling. 

-Dave.
-- 
Dave Chinner
david@fromorbit.com
