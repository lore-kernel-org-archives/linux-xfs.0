Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FA226AC3;
	Mon, 13 Jan 2025 16:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736785144; cv=none; b=kWd2nA3tzgwmZxRXkvVkPtVzyFKM0rtFXlabGk0Rv+PYIQEZOaYDswSX2eGLIZYDHVhxCEH2utdZFdtVhqHppQM9LHiHw3gsdSvPllIino5SQO+xyW3w8kOv7/WVTxq0wV1tTj5BIrmMiNYwDoUXUxNTCiaGB1PRHKrnRVqI1eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736785144; c=relaxed/simple;
	bh=iPsFt5V16UP68mva+NGhl1aD0lARKLwqjTUgXBWWo+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=snjPbb/9nADDBfuw3v0YnTdnbiEHQSUm6k4LD6+2VakIe0UC+5e6rXd9HRwIvUui1zFDA6CrFRxsb7cqDRmOgKnKAcSYI8BxH31j8ENTf9Ce9ObCPT2voVIUCTnYZ2WL/bFFDJfS45bY0RJ/og0Lcw75/InWyx0NZAVnj6T/r08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a+rcyQnL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a+rcyQnL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 803EAC4CED6;
	Mon, 13 Jan 2025 16:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736785144;
	bh=iPsFt5V16UP68mva+NGhl1aD0lARKLwqjTUgXBWWo+0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a+rcyQnLTky2h9v3H+KKGw6r5hRwcLGrTh8W2xnp0iTSOxYMqRLcw091T0+AJh3/Y
	 gesurmT53uARtNy12mq+mJGQQfKv9nl0Svp4x3WEhuRRjQTWnM3yx5vWP8h+uviBo1
	 rHoIuR69Phpfn08KWj9W0bbm4n1SUzp1i4aM+N3s4+X2mb9M0c+pryxSdmlG7wgERb
	 AXOY1/FRICPTbzrKko3dXn36cP5RFSvY6AxYJjarnmDa0yIzVRp3ah0g/cP0iigoTg
	 2aj25woOwRduWpcMGeQ+BOCk7jqCZzqoRQzVKrD/4mSdKeparF/Jn3lO4UHkhrTbeK
	 9Av5dmRcWQ02A==
Date: Mon, 13 Jan 2025 08:19:04 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Chi Zhiling <chizhiling@163.com>, Amir Goldstein <amir73il@gmail.com>,
	Dave Chinner <david@fromorbit.com>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>,
	John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
Message-ID: <20250113161904.GC1306365@frogsfrogsfrogs>
References: <Z3B48799B604YiCF@dread.disaster.area>
 <24b1edfc-2b78-434d-825c-89708d9589b7@163.com>
 <CAOQ4uxgUZuMXpe3DX1dO58=RJ3LLOO1Y0XJivqzB_4A32tF9vA@mail.gmail.com>
 <953b0499-5832-49dc-8580-436cf625db8c@163.com>
 <20250108173547.GI1306365@frogsfrogsfrogs>
 <Z4BbmpgWn9lWUkp3@dread.disaster.area>
 <CAOQ4uxjTXjSmP6usT0Pd=NYz8b0piSB5RdKPm6+FAwmKcK4_1w@mail.gmail.com>
 <d99bb38f-8021-4851-a7ba-0480a61660e4@163.com>
 <20250113024401.GU1306365@frogsfrogsfrogs>
 <Z4UX4zyc8n8lGM16@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Z4UX4zyc8n8lGM16@bfoster>

On Mon, Jan 13, 2025 at 08:40:51AM -0500, Brian Foster wrote:
> On Sun, Jan 12, 2025 at 06:44:01PM -0800, Darrick J. Wong wrote:
> > On Sun, Jan 12, 2025 at 06:05:37PM +0800, Chi Zhiling wrote:
> > > On 2025/1/11 01:07, Amir Goldstein wrote:
> > > > On Fri, Jan 10, 2025 at 12:28 AM Dave Chinner <david@fromorbit.com> wrote:
> > > > > 
> > > > > On Wed, Jan 08, 2025 at 09:35:47AM -0800, Darrick J. Wong wrote:
> > > > > > On Wed, Jan 08, 2025 at 03:43:04PM +0800, Chi Zhiling wrote:
> > > > > > > On 2025/1/7 20:13, Amir Goldstein wrote:
> > > > > > > > Dave's answer to this question was that there are some legacy applications
> > > > > > > > (database applications IIRC) on production systems that do rely on the fact
> > > > > > > > that xfs provides this semantics and on the prerequisite that they run on xfs.
> > > > > > > > 
> > > > > > > > However, it was noted that:
> > > > > > > > 1. Those application do not require atomicity for any size of IO, they
> > > > > > > >       typically work in I/O size that is larger than block size (e.g. 16K or 64K)
> > > > > > > >       and they only require no torn writes for this I/O size
> > > > > > > > 2. Large folios and iomap can usually provide this semantics via folio lock,
> > > > > > > >       but application has currently no way of knowing if the semantics are
> > > > > > > >       provided or not
> > > > > > > 
> > > > > > > To be honest, it would be best if the folio lock could provide such
> > > > > > > semantics, as it would not cause any potential problems for the
> > > > > > > application, and we have hope to achieve concurrent writes.
> > > > > > > 
> > > > > > > However, I am not sure if this is easy to implement and will not cause
> > > > > > > other problems.
> > > > > > 
> > > > > > Assuming we're not abandoning POSIX "Thread Interactions with Regular
> > > > > > File Operations", you can't use the folio lock for coordination, for
> > > > > > several reasons:
> > > > > > 
> > > > > > a) Apps can't directly control the size of the folio in the page cache
> > > > > > 
> > > > > > b) The folio size can (theoretically) change underneath the program at
> > > > > > any time (reclaim can take your large folio and the next read gets a
> > > > > > smaller folio)
> > > > > > 
> > > > > > c) If your write crosses folios, you've just crossed a synchronization
> > > > > > boundary and all bets are off, though all the other filesystems behave
> > > > > > this way and there seem not to be complaints
> > > > > > 
> > > > > > d) If you try to "guarantee" folio granularity by messing with min/max
> > > > > > folio size, you run the risk of ENOMEM if the base pages get fragmented
> > > > > > 
> > > > > > I think that's why Dave suggested range locks as the correct solution to
> > > > > > this; though it is a pity that so far nobody has come up with a
> > > > > > performant implementation.
> > > > > 
> > > > > Yes, that's a fair summary of the situation.
> > > > > 
> > > > > That said, I just had a left-field idea for a quasi-range lock
> > > > > that may allow random writes to run concurrently and atomically
> > > > > with reads.
> > > > > 
> > > > > Essentially, we add an unsigned long to the inode, and use it as a
> > > > > lock bitmap. That gives up to 64 "lock segments" for the buffered
> > > > > write. We may also need a "segment size" variable....
> > > > > 
> > > > > The existing i_rwsem gets taken shared unless it is an extending
> > > > > write.
> > > > > 
> > > > > For a non-extending write, we then do an offset->segment translation
> > > > > and lock that bit in the bit mask. If it's already locked, we wait
> > > > > on the lock bit. i.e. shared IOLOCK, exclusive write bit lock.
> > > > > 
> > > > > The segments are evenly sized - say a minimum of 64kB each, but when
> > > > > EOF is extended or truncated (which is done with the i_rwsem held
> > > > > exclusive) the segment size is rescaled. As nothing can hold bit
> > > > > locks while the i_rwsem is held exclusive, this will not race with
> > > > > anything.
> > > > > 
> > > > > If we are doing an extending write, we take the i_rwsem shared
> > > > > first, then check if the extension will rescale the locks. If lock
> > > > > rescaling is needed, we have to take the i_rwsem exclusive to do the
> > > > > EOF extension. Otherwise, the bit lock that covers EOF will
> > > > > serialise file extensions so it can be done under a shared i_rwsem
> > > > > safely.
> > > > > 
> > > > > This will allow buffered writes to remain atomic w.r.t. each other,
> > > > > and potentially allow buffered reads to wait on writes to the same
> > > > > segment and so potentially provide buffered read vs buffered write
> > > > > atomicity as well.
> > > > > 
> > > > > If we need more concurrency than an unsigned long worth of bits for
> > > > > buffered writes, then maybe we can enlarge the bitmap further.
> > > > > 
> > > > > I suspect this can be extended to direct IO in a similar way to
> > > > > buffered reads, and that then opens up the possibility of truncate
> > > > > and fallocate() being able to use the bitmap for range exclusion,
> > > > > too.
> > > > > 
> > > > > The overhead is likely minimal - setting and clearing bits in a
> > > > > bitmap, as opposed to tracking ranges in a tree structure....
> > > > > 
> > > > > Thoughts?
> > > > 
> > > > I think that's a very neat idea, but it will not address the reference
> > > > benchmark.
> > > > The reference benchmark I started the original report with which is similar
> > > > to my understanding to the benchmark that Chi is running simulates the
> > > > workload of a database writing with buffered IO.
> > > > 
> > > > That means a very large file and small IO size ~64K.
> > > > Leaving the probability of intersecting writes in the same segment quite high.
> > > > 
> > > > Can we do this opportunistically based on available large folios?
> > > > If IO size is within an existing folio, use the folio lock and IOLOCK_SHARED
> > > > if it is not, use IOLOCK_EXCL?
> > > > 
> > > > for a benchmark that does all buffered IO 64K aligned, wouldn't large folios
> > > > naturally align to IO size and above?
> > > > 
> > > 
> > > Great, I think we're getting close to aligning our thoughts.
> > > 
> > > IMO, we shouldn't use a shared lock for write operations that are
> > > larger than page size.
> > > 
> > > I believe the current issue is that when acquiring the i_rwsem lock,
> > > we have no way of knowing the size of a large folio [1] (as Darrick
> > > mentioned earlier), so we can't determine if only one large folio will
> > > be written.
> > > 
> > > There's only one certainty: if the IO size fits within one page size,
> > > it will definitely fit within one large folio.
> > > 
> > > So for now, we can only use IOLOCK_SHARED if we verify that the IO fits
> > > within page size.
> > 
> > For filesystems that /do/ support large folios (xfs), I suppose you
> > could have it tell iomap that it only took i_rwsem in shared mode; and
> > then the iomap buffered write implementation could proceed if it got a
> > folio covering the entire write range, or return some magic code that
> > means "take i_rwsem in exclusive mode and try again".
> > 
> 
> Sorry if this is out of left field as I haven't followed the discussion
> closely, but I presumed one of the reasons Darrick and Christoph raised
> the idea of using the folio batch thing I'm playing around with on zero
> range for buffered writes would be to acquire and lock all targeted
> folios up front. If so, would that help with what you're trying to
> achieve here? (If not, nothing to see here, move along.. ;).

I think the folio batch thing would help here, since you then could just
lock all the folios you need for a write, which provides (in effect) a
range lock implementation.

--D

> Brian
> 
> > Though you're correct that we should always take IOLOCK_EXCL if the
> > write size is larger than whatever the max folio size is for that file.
> > 
> > --D
> > 
> > > [1]: Maybe we can find a way to obtain the size of a folio from the page
> > > cache, but it might come with some performance costs.
> > > 
> > > 
> > > Thanks,
> > > Chi Zhiling
> > > 
> > > 
> > 
> 
> 
