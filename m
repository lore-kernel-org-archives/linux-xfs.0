Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66564140E3C
	for <linux-xfs@vger.kernel.org>; Mon, 15 Jul 2024 23:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721084628; cv=none; b=mCznhKRJChJnoSxb4EdjRDlehs40YJvfAW8J4fjy3xA7ZFEBksA2VhSrE+Rl7IGSDk+2DY0P69dcABkOHdFv5QV7+GKCQjKJTMHSpw5ojCIxa70N3I+e5xEpvIeGIxtiVamj2GwYtlhbPI2jcwJbk+r2LIBeWAlPZl09ws3CGns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721084628; c=relaxed/simple;
	bh=uQUzVama8nZoHgZeOzpE7baJSxzpE2fDQ70BPJkhV/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GAayRhvO44xIQT3XQBjnTO3/OpkWzN978cz3Wax2gKAsFhDOwMMpjmvktKT3LitW7n187sFCu3Wt9MFdPeb5HwXV+UDdwQwP2P1229UhXxFBl0Bv6GFJQIxaDgbkPVNWL40/xIEXPjd92gnGCpHy+Q4FGjPV+c5QA7hFpClmqJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=EklNDPLC; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="EklNDPLC"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-70b4267ccfcso3622209b3a.3
        for <linux-xfs@vger.kernel.org>; Mon, 15 Jul 2024 16:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1721084626; x=1721689426; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sWqF3SKJO8sKFI31j17Cd7mFz7KOpaObqvnESaoqaaY=;
        b=EklNDPLCoecK0TcePO0kHqvrioxAbOEWfhRNEnNjP1WyOc+pRG++1LR3LavkTEwyZf
         v7Yqg00mK1E8phcIgGI2NFOsfMZhOu3w5HnP/ih0HHELYpcgWhdxFl/7eaXXwL9Nc0T5
         gVQmxzNocwS3iwawloDXji2mGF5CGp5rgLDgzjqWjhFfnwAAt+87zYkpSYKKPBWN++lr
         t2z7W1V9a3BqStDQ1mcV9Nj/O9+bxXGe16EbuAptzCYzu1CBsI0IURvF5WXvU7QyAb+C
         sKoq1XM6MqDvqZt3kVChnil8Odo/efqIPKVoZUVCUdtNYlqZei524htZ29tRvg72EAAY
         CfkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721084626; x=1721689426;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sWqF3SKJO8sKFI31j17Cd7mFz7KOpaObqvnESaoqaaY=;
        b=NpR4d/uL8hL/BUiy+ECyy8e2b6umMWt/RDzOfcHWartlgYqYU9WMU/78HKQ9X4Z55F
         EnDZDgR6T1ph5Vp/y9PK7GhLLnJxXXkBv1j9KVoBhaMdHmkWwbl2aoiSphUdAG9SzxOO
         iSKRaqGOI7KWa5RIc8K9Ar67UuY5ABqHfem5JX9issJg7Xevo+EqUJ4la5Q6vGOvaEQW
         /NmKZyitNrHD5YkHnMwhNmTYVsRLrEWkZjcuhTQWsEXn4oLC0IEIASvcP53ehnGx9tmi
         wMULLe+AH8Qo3TuC+nOXId1TULWyEafbDxO89OywoMU3ukJsGDlOhwoysYTbIm06HVvn
         00PA==
X-Gm-Message-State: AOJu0YwVDCVvE8WRKz5TwZOL8bKUTvdF0r3uQpxsCJukiUwybnrqgOfF
	SAeUWF37ujy8jtkR2h/MtRUMt6eppAGWSYETwSOVierkmr0S4e0Ekx9QKo4cDGdVcorYP3BJyeM
	O
X-Google-Smtp-Source: AGHT+IHpy90QA2YeEPWHlyRSpVfZ6zI2y6tjVyYP5IA75EaQ/IKIAKOrZLmLu5r58L7lIwpzgo4FRg==
X-Received: by 2002:a05:6a00:2443:b0:70b:30ce:dfdb with SMTP id d2e1a72fcca58-70c2e988180mr656794b3a.24.1721084625124;
        Mon, 15 Jul 2024 16:03:45 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b7ebd0e9asm4965440b3a.89.2024.07.15.16.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jul 2024 16:03:44 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sTUjO-00HEak-0G;
	Tue, 16 Jul 2024 09:03:42 +1000
Date: Tue, 16 Jul 2024 09:03:42 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/9] introduce defrag to xfs_spaceman
Message-ID: <ZpWqzsiU01mNKHC9@dread.disaster.area>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240709191028.2329-1-wen.gang.wang@oracle.com>

[ Please keep documentation text to 80 columns. ] 

[ Please run documentation through a spell checker - there are too
many typos in this document to point them all out... ]

On Tue, Jul 09, 2024 at 12:10:19PM -0700, Wengang Wang wrote:
> This patch set introduces defrag to xfs_spaceman command. It has the functionality and
> features below (also subject to be added to man page, so please review):

What's the use case for this?

>        defrag [-f free_space] [-i idle_time] [-s segment_size] [-n] [-a]
>               defrag defragments the specified XFS file online non-exclusively. The target XFS

What's "non-exclusively" mean? How is this different to what xfs_fsr
does?

>               doesn't have to (and must not) be unmunted.  When defragmentation is in progress, file
>               IOs are served 'in parallel'.  reflink feature must be enabled in the XFS.

xfs_fsr allows IO to occur in parallel to defrag.

>               Defragmentation and file IOs
> 
>               The target file is virtually devided into many small segments. Segments are the
>               smallest units for defragmentation. Each segment is defragmented one by one in a
>               lock->defragment->unlock->idle manner.

Userspace can't easily lock the file to prevent concurrent access.
So I'mnot sure what you are refering to here.

>               File IOs are blocked when the target file is locked and are served during the
>               defragmentation idle time (file is unlocked).

What file IOs are being served in parallel? The defragmentation IO?
something else?

>               Though
>               the file IOs can't really go in parallel, they are not blocked long. The locking time
>               basically depends on the segment size. Smaller segments usually take less locking time
>               and thus IOs are blocked shorterly, bigger segments usually need more locking time and
>               IOs are blocked longer. Check -s and -i options to balance the defragmentation and IO
>               service.

How is a user supposed to know what the correct values are for their
storage, files, and workload? Algorithms should auto tune, not
require users and administrators to use trial and error to find the
best numbers to feed a given operation.

>               Temporary file
> 
>               A temporary file is used for the defragmentation. The temporary file is created in the
>               same directory as the target file is and is named ".xfsdefrag_<pid>". It is a sparse
>               file and contains a defragmentation segment at a time. The temporary file is removed
>               automatically when defragmentation is done or is cancelled by ctrl-c. It remains in
>               case kernel crashes when defragmentation is going on. In that case, the temporary file
>               has to be removed manaully.

O_TMPFILE, as Darrick has already requested.

> 
>               Free blocks consumption
> 
>               Defragmenation works by (trying) allocating new (contiguous) blocks, copying data and
>               then freeing old (non-contig) blocks. Usually the number of old blocks to free equals
>               to the number the newly allocated blocks. As a finally result, defragmentation doesn't
>               consume free blocks.  Well, that is true if the target file is not sharing blocks with
>               other files.

This is really hard to read. Defragmentation will -always- consume
free space while it is progress. It will always release the
temporary space it consumes when it completes.

>               In case the target file contains shared blocks, those shared blocks won't
>               be freed back to filesystem as they are still owned by other files. So defragmenation
>               allocates more blocks than it frees.

So this is doing an unshare operation as well as defrag? That seems
... suboptimal. The whole point of sharing blocks is to minimise
disk usage for duplicated data.

>               For existing XFS, free blocks might be over-
>               committed when reflink snapshots were created. To avoid causing the XFS running into
>               low free blocks state, this defragmentation excludes (partially) shared segments when
>               the file system free blocks reaches a shreshold. Check the -f option.

Again, how is the user supposed to know when they need to do this?
If the answer is "they should always avoid defrag on low free
space", then why is this an option?

>               Safty and consistency
> 
>               The defragmentation file is guanrantted safe and data consistent for ctrl-c and kernel
>               crash.

Which file is the "defragmentation file"? The source or the temp
file?

>               First extent share
> 
>               Current kernel has routine for each segment defragmentation detecting if the file is
>               sharing blocks.

I have no idea what this means, or what interface this refers to.

>               It takes long in case the target file contains huge number of extents
>               and the shared ones, if there is, are at the end. The First extent share feature works
>               around above issue by making the first serveral blocks shared. Seeing the first blocks
>               are shared, the kernel routine ends quickly. The side effect is that the "share" flag
>               would remain traget file. This feature is enabled by default and can be disabled by -n
>               option.

And from this description, I have no idea what this is doing, what
problem it is trying to work around, or why we'd want to share
blocks out of a file to speed up detection of whether there are
shared blocks in the file. This description doesn't make any sense
to me because I don't know what interface you are actually having
performance issues with. Please reference the kernel code that is
problematic, and explain why the existing kernel code is problematic
and cannot be fixed.

>               extsize and cowextsize
> 
>               According to kernel implementation, extsize and cowextsize could have following impacts
>               to defragmentation: 1) non-zero extsize causes separated block allocations for each
>               extent in the segment and those blocks are not contiguous.

Extent size hints do no such thing. The simply provide extent
alignment guidelines and do not affect things like contiguous or
multi-block allocation lengths.

>               The segment remains same
>               number of extents after defragmention (no effect).  2) When extsize and/or cowextsize
>               are too big, a lot of pre-allocated blocks remain in memory for a while. When new IO
>               comes to whose pre-allocated blocks  Copy on Write happens and causes the file
>               fragmented.

extsize based unwritten extents won't cause COW or cause
fragmentation because they aren't shared and they are contiguous.
I suspect that your definition of "fragmented" isn't taking into
account that unwritten-written-unwritten over a contiguous range
is *not* fragmentation. It's just a contiguous extent in different
states, and this should really not be touched/changed by
defragmentation.

check out xfs_fsr: it ensures that the pattern of unwritten/written
blocks in the defragmented file is identical to the source. i.e. it
preserves preallocation because the application/fs config wants it
to be there....

>               Readahead
> 
>               Readahead tries to fetch the data blocks for next segment with less locking in
>               backgroud during idle time. This feature is disabled by default, use -a to enable it.

What are you reading ahead into? Kernel page cache or user buffers?
Either way, it's hardly what I'd call "idle time" if the defrag
process is using it to issue lots of read IO...


>               The command takes the following options:
>                  -f free_space
>                      The shreshold of XFS free blocks in MiB. When free blocks are less than this
>                      number, (partially) shared segments are excluded from defragmentation. Default
>                      number is 1024

When you are down to 4MB of free space in the filesystem, you
shouldn't even be trying to run defrag because all the free space
that will be left in the filesystem is single blocks. I would have
expected this sort of number to be in a percentage of capacity,
defaulting to something like 5% (which is where we start running low
space algorithms in the kernel).

>                  -i idle_time
>                      The time in milliseconds, defragmentation enters idle state for this long after
>                      defragmenting a segment and before handing the next. Default number is TOBEDONE.

Yeah, I don't think this is something anyonce whould be expected to
use or tune. If an idle time is needed, the defrag application
should be selecting this itself.
> 
>                  -s segment_size
>                      The size limitation in bytes of segments. Minimium number is 4MiB, default
>                      number is 16MiB.

Why were these numbers chosen? What happens if the file has ~32MB
sized extents and the user wants the file to be returned to a single
large contiguous extent it possible? i.e. how is the user supposed
to know how to set this for any given file without first having
examined the exact pattern of fragmentations in the file?

>                  -n  Disable the First extent share feature. Enabled by default.

So confusing.  Is the "feature disable flag" enabled by default, or
is the feature enabled by default?

>                  -a  Enable readahead feature, disabled by default.

Same confusion, but opposite logic.

I would highly recommend that you get a native english speaker to
review, spell and grammar check the documentation before the next
time you post it.

> We tested with real customer metadump with some different 'idle_time's and found 250ms is good pratice
> sleep time. Here comes some number of the test:
> 
> Test: running of defrag on the image file which is used for the back end of a block device in a
>       virtual machine. At the same time, fio is running at the same time inside virtual machine
>       on that block device.
> block device type:   NVME
> File size:           200GiB
> paramters to defrag: free_space: 1024 idle_time: 250 First_extent_share: enabled readahead: disabled
> Defrag run time:     223 minutes
> Number of extents:   6745489(before) -> 203571(after)

So and average extent size of ~32kB before, 100MB after? How much of
these are shared extents?

Runtime is 13380secs, so if we copied 200GiB in that time, the
defrag ran at 16MB/s. That's not very fast.

What's the CPU utilisation of the defrag task and kernel side
processing? What is the difference between "first_extent_share"
enabled and disabled (both performance numbers and CPU usage)?

> Fio read latency:    15.72ms(without defrag) -> 14.53ms(during defrag)
> Fio write latency:   32.21ms(without defrag) -> 20.03ms(during defrag)

So the IO latency is *lower* when defrag is running? That doesn't
make any sense, unless the fio throughput is massively reduced while
defrag is running.  What's the throughput change in the fio
workload? What's the change in worst case latency for the fio
workload? i.e. post the actual fio results so we can see the whole
picture of the behaviour, not just a single cherry-picked number.

Really, though, I have to ask: why is this an xfs_spaceman command
and not something built into the existing online defrag program
we have (xfs_fsr)?

I'm sure I'll hav emore questions as I go through the code - I'll
start at the userspace IO engine part of the patchset so I have some
idea of what the defrag algorithm actually is...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
