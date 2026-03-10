Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A458F4FA;
	Tue, 10 Mar 2026 05:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773121676; cv=none; b=sckeCPxcB/1O4+7F7ZSiIJNdBBdmmL5A4dDzM8UXZf989XJczjJhppIkxp9hE/h12QOeNJdVjNjq6kdCwswOZxgA+eQgEHAhptE2jVHFXD/39USveiPc6rz/jwQQgQ4E5ujpm1oFaGfjf8gwSH2nyioYE3NcpvJNsoK7gs+QHvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773121676; c=relaxed/simple;
	bh=BDHI3iOK37fgXlwcqrKkQw6QER82llhEJ3Ysjw8rpJg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O9+jRxiFaMTkMvMEdqrCVkD+hJmd1Qra2WZ7eYmv/brvcOtF2p976Nn2LjgsvfvuDYZymSVZtOh9Z4odb7bw5GOQt/Wgbz6YeuIt58+8ZsC0VPkH1wYI4qMJjSMje0oqOP+Ok82c1Cs8kPuyRjUSMmM+wx2X1qBvAe19TAhhTJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eZX/vRr/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eZX/vRr/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F311BC19423;
	Tue, 10 Mar 2026 05:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773121676;
	bh=BDHI3iOK37fgXlwcqrKkQw6QER82llhEJ3Ysjw8rpJg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eZX/vRr/Z0WD7ihlYW9nPNKm7r0t3ug7YhlhBsDs0sLcvO4Ak202rjXJizrM7/VWu
	 c7xWf56jTBpgJ+qn2IXoqzuD680HtDGilyNcEVFyltlrTytL8riGoIEhy0vtMc9y4T
	 MICbnvDHV10cWgqa9F1jzsnxYTIXrLkG0K7llmHDCelQdxqQnHfaiWFc8jPuRi1bQa
	 Khqhta0sDQcfuZV+Le3GhrcS9EgsGtIzy25iF7vZ2P/TMAjkChiETm4Pi3y8cUQeRk
	 j2gEqtlrlEYFtnD1qdwPZs/KdR8CwZ/EtItcGl9lYhjPqMgES194uWOYUmr7JNWPeT
	 TI8uvB90Gr3Gg==
Date: Tue, 10 Mar 2026 16:47:50 +1100
From: Dave Chinner <dgc@kernel.org>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: brauner@kernel.org, hch@lst.de, djwong@kernel.org, jack@suse.cz,
	cem@kernel.org, kbusch@kernel.org, axboe@kernel.dk,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com
Subject: Re: [PATCH v2 4/5] xfs: steer allocation using write stream
Message-ID: <aa-whgDFL7h8-gIl@dread>
References: <20260309052944.156054-1-joshi.k@samsung.com>
 <CGME20260309053434epcas5p308acff894c6735e382c0e5e1e737c9de@epcas5p3.samsung.com>
 <20260309052944.156054-5-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309052944.156054-5-joshi.k@samsung.com>

On Mon, Mar 09, 2026 at 10:59:43AM +0530, Kanchan Joshi wrote:
> When write stream is set on the file, override the default
> directory-locality heuristic with a new heuristic that maps
> available AGs into streams.
>
> Isolating distinct write streams into dedicated allocation groups helps
> in reducing the block interleaving of concurrent writers. Keeping these
> streams spatially separated reduces AGF lock contention and logical file
> fragmentation.

a.k.a. the XFS filestreams allocator.

i.e. we already have an allocator that performs this exact locality
mapping. See xfs_inode_is_filestream() and the allocator code path
that goes this way:

xfs_bmap_btalloc()
  xfs_bmap_btalloc_filestreams()
    xfs_filestream_select_ag()

Please integrate this write stream mapping functionality into that
allocator rather than hacking a new, almost identical allocator
policy into XFS.

filestreams currently uses the parent inode number as the stream ID
and maps that to an AG. It should be relatively trivial to use the
ip->i_write_stream as the stream ID instead of the parent inode.

> If AGs are fewer than write streams, write streams are distributed into
> available AGs in round robin fashion.
> If not, available AGs are partitioned into write streams. Since each
> write stream maps to a partition of multiple contiguous AGs, the inode hash
> is used to choose the specific AG within the stream partition. This can
> help with intra-stream concurency when multiple files are being written in
> a single stream that has 2 or more AGs.
> 
> Example: 8 Allocation Groups, 4 Streams
> Partition Size = 2 AGs per Stream
> 
>    Stream 1 (ID: 1)         Stream 2 (ID: 2)         Streams 3 & 4
>  +---------+---------+    +---------+---------+    +-------------
>  |   AG0   |   AG1   |    |   AG2   |   AG3   |    |  AG4...AG7
>  +---------+---------+    +---------+---------+    +-------------
>       ^         ^              ^         ^
>       |         |              |         |
>       | File B (ino: 101)      | File D (ino: 201)
>       | 101 % 2 = 1 -> AG 1    | 201 % 2 = 1 -> AG 3
>       |                        |
>  File A (ino: 100)        File C (ino: 200)
>  100 % 2 = 0 -> AG 0      200 % 2 = 0 -> AG 2
> 
> If AGs can not be evenly distributed among streams, the last stream will
> absorb the remaining AGs.

Yeah, this should all be hidden behind xfs_filestream_select_ag()
when ip->i_write_stream is set....

> Note that there are no hard boundaries; this only provides explicit
> routing hint to xfs allocator so that it can group/isolate files in the way
> application has decided to group/isolate. We still try to preserve file
> contiguity, and the full space can be utilized even with a single stream.

Yes, that's pretty much exactly what the filestreams allocator was
designed to do. It's a whole lot more dynamic that what you are
trying to do above and is not limited fixed AGs for streams - as
soon as an AG is out of space, it will select the AG with the most
free space for the stream and keep that relationship until that AG
is out of space.

IOWs, filestreams does not limit a stream to a fixed number of AGs.
All it does is keep IO with the same stream ID in the same AG until
the AG is full and, as much as possible, prevents multiple streams
from using the same AG.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
