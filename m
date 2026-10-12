Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F4438C406
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 20:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791838047; cv=none; b=Hj29XqB9971ZhZTDP+lXOZe6lr04UGjNJ0c53wbxAvd8pYbP3JTm6kG25DfrdrAev4Aq3H3pgyZkBuMSU7V0nc/DFek60c0cRdhZVtdIyzj6FL+iXXTKZ0dT90eY8WlqIPZGOR7Tu+4uHF5kRIB6p/E93PB8nqButeh9LhIsWR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791838047; c=relaxed/simple;
	bh=pFwq90/WzNmkO03lCmC3YTkzgzoPdvQ7XXxbtKiNLew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZrUQUunYthuN3DencxXZVi0nNdz9+duIZHK0OJJS3kUBHZEl+ilUUDwFvWg3/PKwQt1t1kATglVHftINjR9zEEI0lCsstnZeXwUjjgRDMcw0wOg01r7JhSs7/N+q0yYpdwZLsetwEbQdkRXOvL/XwxzQhWPB5lNDOKI/v6miWsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b2I2fFgU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b2I2fFgU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 247291F0089B;
	Mon, 12 Oct 2026 20:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791838045;
	bh=dvzyy9I6+UrWKITKM6pz8x3jWC86vmAEqd5CF/oAjnU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=b2I2fFgUHBfBgdV2dLvOVXnj03jbCJV56hoCmb96+jnH3h90W8uLkKO+zVV9yEG5/
	 z6DigAveEC+ZeOx6VUBibL4pt8fm/9vz+rY50DBlBkYGxJ5N7iFrzwbGvaCqzA2VUS
	 BMAZGpdVRF1YghsxHc6RtpkV+GTwEMcgA25zgV6FPwrGOIxjPFfZAP1yehervMbZrb
	 ORjllnDTqYjxz0PbsZ/xlwdjjaxMWIAV8zf/ptK6Amk5Ujn0J68zK1mB+PGX410rh3
	 cmdVjkP6RAx4u7bHvM4QacrQUnGhSP12PovmmjL+gnUS6DyVdWrR36MpJp3kPC/2T5
	 UDdjqP040XXTQ==
Date: Tue, 13 Oct 2026 07:47:17 +1100
From: Dave Chinner <dgc@kernel.org>
To: Vitali Lovich <vlovich@gmail.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Really bad I/O lock contention between non-overlapping reader
 and writer
Message-ID: <as1HVVUXdMlpXQGT@dread>
References: <CAF8PYMjkpEkoop-Wbk=2oBMdqer-pWh1osPvhSv90D2fwLSv0w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF8PYMjkpEkoop-Wbk=2oBMdqer-pWh1osPvhSv90D2fwLSv0w@mail.gmail.com>

On Mon, Oct 12, 2026 at 10:47:56AM -0700, Vitali Lovich wrote:
> I think I encountered suboptimal locking behavior with concurrent
> readers and writers on a file, which resulted in huge latency spikes
> for the reader even though the writers and readers are touching
> unrelated ranges within the file. The writer/hole puncher hold an
> exclusive lock on the inode while forcing a flush of outstanding
> writes to disk which creates huge latency spikes for reads.
> 
> I've observed read's taking >> 500ms even though none of the writes
> could be overlapping and traces seem to indicate it's the shared inode
> lock contending with the exclusive inode lock that writes / hole
> punching is holding. In my real-world test case traces indicated that
> the cause might be inode_dio_wait while holding the exclusive inode
> lock.
> 
> I've observed this behavior on XFS, EXT4 and BTRFS so it seems like a
> general VFS challenge. Generally, Btrfs seems to have less read
> latencies created than Ext4 (~2.5x more at the 0-1ms read than EXT4),
> which in turn has smaller and fewer tail latencies than XFS  (~2x more
> at 0-1ms and extreme is smaller) although all filesystems exhibit the
> issue. Starting with the XFS list in case I'm way off base that this
> is a problem.
> 
> Attaching a simplified reproduction of what I'm doing with one writer
> appending data to the file,

The repro is using DIO writes. Speaking for XFS, these need needs
exclusive locking to serialise extending the file without causing
data corruption or stale data exposure. Once extended, the locking
demotes to shared, so the IO itself runs concurrently with reads.

Appending DIO writes are basically a fast combined 'truncate up,
write' operation, and so has the same initial serialisation
constraints as 'truncate up' (i.e. exclusive locking).

> a separate writer punching holes in
> unrelated ranges,

fallocate() is like truncate - it also needs exclusive locking and
no IO in flight to avoid a UAF of the data extent being punched out.

> and an O_DIRECT reader that's reading data.

Shared locking only.

> Reads
> are doing random 4kib I/O in [0, 64MiB), hole punching is punching
> 4kib holes in [64MiB, 576Mib] and writing is always appending after
> 577MiB of the file.

Educate me: what application workload has this IO pattern? Is this a
real world problem. i.e. why should we care about this contrived
scenario?

Also, have you tried to implement highly concurrent range locks that
don't have far worse contention on the range lock tracking
structures themselves than a simple rwsem? Some of us here have
actually tried to do this, and the fact that we still use rwsems
should tell you a lot...

-Dave.
-- 
Dave Chinner
dgc@kernel.org
