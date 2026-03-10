Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED7740DFD6;
	Tue, 10 Mar 2026 22:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773182701; cv=none; b=Uf4NtkMVWYuCH57dOyUSzzyX9a4BezQRVNAIe8CJU8yMWbmN0PbOe3Eu4xJZoxxiSD1ieagtANQNbXgBTE/OzOCxN1IoD/frOz7/3JCNhz/o8hj3m5DZinlb+nJ7SYRNKcZAs9I0+sYZ5BHQlaWXRUGLY6YevyIe2+ysxnUKC+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773182701; c=relaxed/simple;
	bh=Va7OsCs/r7OawHp556nvBaKFXunJGrNpZ4w+vmt6rD8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EZyq7TlmGKmipO4pLP38mDwS+onSuWLT/wvX+QLMA0IzcGXeCPHdHezwI9ztKWKDEI+Y+Kd0pCThEGUpMdeZOkV+440SjqH5jm97E0VaKkmjCf3GPQaZOaBosF798D95v5MwxiJNl5hMsWezPi7JtlGz5dKabfsNxaELZXWfQmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KCfGy3hC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KCfGy3hC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E47BC19423;
	Tue, 10 Mar 2026 22:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773182700;
	bh=Va7OsCs/r7OawHp556nvBaKFXunJGrNpZ4w+vmt6rD8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KCfGy3hC+Q/f2jiiG8j64jvAIR1fEGuY2Uyy547wm/2zNZ8DlfHf42QxKs28/wjqW
	 68560HelVLFHW1rJvgq8rAueu5jKmlNlBVefIj0F60h7QdT5OfsRi92fdhCpcJhqDQ
	 UxeQvwsg24uVpWsJtZvwQScUwwlpzwTIfbJ1NUrx1SXRE0WNHwK8R6GyDPuOq621we
	 HFXipPckwAPeElrhAdDJpOQiIsRXHFdkWisIAfSEe5XMGCM3efNbBn6C2UmuNCEjk7
	 rOeTTKmIqS21f7/r/Px9Gywh4N0tExTHyRqo6TYyq9S8NOzOjDGCfhWSkwPFChwU+i
	 8HVs3gt/VsDCg==
Date: Wed, 11 Mar 2026 09:44:54 +1100
From: Dave Chinner <dgc@kernel.org>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: brauner@kernel.org, hch@lst.de, djwong@kernel.org, jack@suse.cz,
	cem@kernel.org, kbusch@kernel.org, axboe@kernel.dk,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com
Subject: Re: [PATCH v2 4/5] xfs: steer allocation using write stream
Message-ID: <abCe5psWHgYIKkR0@dread>
References: <20260309052944.156054-1-joshi.k@samsung.com>
 <CGME20260309053434epcas5p308acff894c6735e382c0e5e1e737c9de@epcas5p3.samsung.com>
 <20260309052944.156054-5-joshi.k@samsung.com>
 <aa-whgDFL7h8-gIl@dread>
 <7a4f9902-d87d-4032-9df0-efa807c6aade@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a4f9902-d87d-4032-9df0-efa807c6aade@samsung.com>

On Wed, Mar 11, 2026 at 12:33:42AM +0530, Kanchan Joshi wrote:
> On 3/10/2026 11:17 AM, Dave Chinner wrote:
> >> When write stream is set on the file, override the default
> >> directory-locality heuristic with a new heuristic that maps
> >> available AGs into streams.
> >>
> >> Isolating distinct write streams into dedicated allocation groups helps
> >> in reducing the block interleaving of concurrent writers. Keeping these
> >> streams spatially separated reduces AGF lock contention and logical file
> >> fragmentation.
> > a.k.a. the XFS filestreams allocator.
> 
> Yes, but there is difference between what I am doing and what is 
> present. Let me write that in the end.
> > 
> > i.e. we already have an allocator that performs this exact locality
> > mapping. See xfs_inode_is_filestream() and the allocator code path
> > that goes this way:
> > 
> > xfs_bmap_btalloc()
> >    xfs_bmap_btalloc_filestreams()
> >      xfs_filestream_select_ag()
> > 
> > Please integrate this write stream mapping functionality into that
> > allocator rather than hacking a new, almost identical allocator
> > policy into XFS.
> > 
> > filestreams currently uses the parent inode number as the stream ID
> > and maps that to an AG. It should be relatively trivial to use the
> > ip->i_write_stream as the stream ID instead of the parent inode.
> 
> Yeah, should be possible. Will try that in V3.
> 
> >> If AGs are fewer than write streams, write streams are distributed into
> >> available AGs in round robin fashion.
> >> If not, available AGs are partitioned into write streams. Since each
> >> write stream maps to a partition of multiple contiguous AGs, the inode hash
> >> is used to choose the specific AG within the stream partition. This can
> >> help with intra-stream concurency when multiple files are being written in
> >> a single stream that has 2 or more AGs.
> >>
> >> Example: 8 Allocation Groups, 4 Streams
> >> Partition Size = 2 AGs per Stream
> >>
> >>     Stream 1 (ID: 1)         Stream 2 (ID: 2)         Streams 3 & 4
> >>   +---------+---------+    +---------+---------+    +-------------
> >>   |   AG0   |   AG1   |    |   AG2   |   AG3   |    |  AG4...AG7
> >>   +---------+---------+    +---------+---------+    +-------------
> >>        ^         ^              ^         ^
> >>        |         |              |         |
> >>        | File B (ino: 101)      | File D (ino: 201)
> >>        | 101 % 2 = 1 -> AG 1    | 201 % 2 = 1 -> AG 3
> >>        |                        |
> >>   File A (ino: 100)        File C (ino: 200)
> >>   100 % 2 = 0 -> AG 0      200 % 2 = 0 -> AG 2
> >>
> >> If AGs can not be evenly distributed among streams, the last stream will
> >> absorb the remaining AGs.
> > Yeah, this should all be hidden behind xfs_filestream_select_ag()
> > when ip->i_write_stream is set....
> 
> Added in the TBD list.
> 
> >> Note that there are no hard boundaries; this only provides explicit
> >> routing hint to xfs allocator so that it can group/isolate files in the way
> >> application has decided to group/isolate. We still try to preserve file
> >> contiguity, and the full space can be utilized even with a single stream.
> > Yes, that's pretty much exactly what the filestreams allocator was
> > designed to do. It's a whole lot more dynamic that what you are
> > trying to do above and is not limited fixed AGs for streams - as
> > soon as an AG is out of space, it will select the AG with the most
> > free space for the stream and keep that relationship until that AG
> > is out of space.
> > 
> > IOWs, filestreams does not limit a stream to a fixed number of AGs.
> > All it does is keep IO with the same stream ID in the same AG until
> > the AG is full and, as much as possible, prevents multiple streams
> > from using the same AG.
> 
> 
> filestream: 1 filestream == 1AG, at a time. And that can cause AGF lock 
> contention on high-concurrency NVMe workloads i.e., when multiple 
> threads writing to different files in same filestream.

Yes, I know. I understand what you are trying to do and why. What
I'm telling you - as an XFS allocator expert - how to implement it a
way that fits into the existing XFS allocator policy framework.

As I said, the existing filestreams allocator stream association is
not an exact match to what are trying to do. It is, however, trivial
to modify the filestreams stream-to-ag association behaviour to
match what you are trying to do.

> What I am doing here with new write stream has two aspects:
> 
> (a) inter stream concurrency: multiple threads writing to different 
> files in different streams are not going to run into AGF lock.


Yup, default behaviour of the allocator - it defines a "write
stream" to be all the files in a given directory. Hence worklaods
operating in different directories will target different AGs and not
contend unless unrelated directories land in the same AG.

Filestreams avoids that problem. It adds the constraint that a
workload in a directory will have a dynamic association with an AG,
instead of it being static based on the directory inode's number.
This allows the filesystem to dynamically separate worklaods in
different directories to different AGs.

All you are trying to do is define the related data set by
i_write_stream, and then separate them into different AGs.

The first step in this process is to add this association to the
filestreams allocator, and have it trigger when ip->i_write_streams
is set.


> (b) intra stream concurrency: multiple threads writing to different 
> files in single stream will also face 'reduced' contention if each 
> stream is a collection of AG and we are spreading the load (with inode 
> hash). Therefore, each stream is partitioned into a group of AGs.

This is not a write stream specific allocator improvement.

This issue exists no matter how we define a write stream because we
currently only have a single AG association with a write stream.

The allocator currently addresses this with trylock based AG
iteration. i.e. it already spreads a write stream over multiple AGs
when the AG is contended during allocation. Hence there is no real
need for the generic allocator to define more than a single AG to a
write stream to avoid allocator contention.

However, there is good reason to enable this sort of functionality
as a generic behaviour because it would help prevent allocation
interleaving across files in the same data set. We have ways of
mitigating that (delalloc-based specualtive prealloc, extent size
hints, etc), but having generic AG sets for each workload would help
address this.

Similarly, adding a generic AG set for a filestream association
(e.g. 2 or 4 consecutive AGs per assocation) would address this
issue for filestreams as well.

Then a common "AG set" definition and behaviour can be defined for
all the allocators (ie. consistent, predictable behaviour across the
filesystem). e.g. The AG within the set could be selected based on
the low bits of the inode number we are allocating for, hence
resulting in a file always trying to use the same AG, but files
within the data set are spread across all AGs in the target AG set.

Such behaviour would be encapsualted inside the target AG seclection
for the allocator policies. i.e.  xfs_filestreams_select_ag() for
the filestreams allocator, and xfs_bmap_btalloc_select_lengths() for
the normal allocator.

ANd then the rest of the allocation code remains unchanged.

> Also, with filestream we can't do cross-directory grouping, of 
> file-level granularity.

Which is why the filestream association for write streams needs to
be based on ip->i_write_stream, not the parent directory!

> Write stream is a more explicit model. 
> Application decides what files are to be spatially separated/grouped and 

No. The application cannot decide what is "spatially
separated/grouped". Even the filesystem cannot decide that because
it does not know how the underlying storage is physically managed.
LBA addresses do not define physical locations in storage anymore;
they are just a convenient abstraction for abstracting the physical
characteristics of the storage away from the OS.

IOWs, Write streams do not define "spatial" locality. All they define is
how the data in certain IOs is related to other IOs. Hence all that
write stream IDs can do is provide information about data
relationships.

As such, I don't think filesystems really need to care that much
about write stream IDs that are passed down to the hardware.
However, if there are some things we can do that help scalability
and performance for write stream realted IO, then I'm not opposed to
doing that. Especially if the filesystem already has all the
infrastructure in place to handle write stream associations in a
dynamic manner...

> what kind of concurrency buckets should be chosen for its N threads/files.

This is not something the application should be caring about.

If you have known IO concurrency requirements, then you should be
create your XFS filesystem with enough AGs to handle that
concurrency requirement in the first place. Then the filesystem
itself should be able to make sane decisions about how to spread the
concurrency load across AGs without the application having to be
micro managed by the application.

i.e. if you are trying to manage low level filesystem concurrency
workarounds in the application, you are doing it wrong...

-Dave.
-- 
Dave Chinner
dgc@kernel.org
