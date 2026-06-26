Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCDD37BE7D
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jun 2026 16:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782489886; cv=none; b=QsdmJkIllQDOWi49O6aY2Lz/o9piJV4WBYmnBu+mGhsRr08tUGsK8pmctRIszzbuBSknWD6tjZPc+pOs8SzQjFVnDQl/tIg62V43+mFZG76gWLcT9RtSsCNPR06xk4Py2Kfc0k09tXexwJJT281rE7uGR018tBtgJ5zbg0JyKoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782489886; c=relaxed/simple;
	bh=0FLDF0nFlvNb0yVncwCapTGIi4jmG4wc76oSOQcTqps=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P/bc3Cx5HT3cz+D+qOxRKrrAofgVGuRkSpPV4MSj/rNZOVsEf16kUOUf3GvEHICg5+PCzFQaxwtwmJDX7VGuwlEAxPwLdrU1cGB4Rz5F6p3AC/fXhBpVEUsc26PBdDKl9DJbCoYzWlqG3v9J3zCahVFp/RQnjmqfcUsnMCV/RJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OKYbWA4a; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OKYbWA4a"
Message-ID: <f7c2276c-b36c-4a69-a913-c5abfc403d01@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782489882;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9MlApQH510+P57WYtBaVc6CVkq4ptIvj9UM/uZ++es4=;
	b=OKYbWA4aA27fRwuLADHTDVlZi2YK3KuGDecdWJfWmT+gmqk9cuK2MhsEwGwE/ZDSy3meRD
	JQyrPXak9fJhhUCAJ25bwQ2lEISjedEy5glZ+ldHHUJfylIxVSYgI1B02J6eVdta6N3aMl
	f2+Bgny2eczCoK7wxeK+iHg5gyLlRis=
Date: Fri, 26 Jun 2026 18:04:35 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v8 2/2] xfs: add support for FALLOC_FL_WRITE_ZEROES
To: "Darrick J. Wong" <djwong@kernel.org>,
 Pankaj Raghav <p.raghav@samsung.com>
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, lukas@herbolt.com,
 dgc@kernel.org, gost.dev@samsung.com, Zhang Yi <yi.zhang@huaweicloud.com>,
 andres@anarazel.de, kundan.kumar@samsung.com, hch@lst.de, cem@kernel.org,
 hch@infradead.org
References: <20260625114550.4109104-1-p.raghav@samsung.com>
 <20260625114550.4109104-3-p.raghav@samsung.com>
 <20260625172006.GC6078@frogsfrogsfrogs>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <20260625172006.GC6078@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

>> +	error = xfs_falloc_newsize(file, mode, offset, len, &new_size);
>> +	if (error)
>> +		return error;
>> +
>> +	/*
>> +	 *
>> +	 *    |----------|----------|----------|----------|----------|
>> +	 *    ^     ^    ^                     ^     ^    ^
>> +	 *    |     |    |                     |     |    |
>> +	 *    |   offset |                     |    end   |
>> +	 *    |          |                     |          |
>> +	 * offset_rd   offset_ru              end_rd    end_ru
> 
> Do "_rd" and "_ru" mean "round down" and "round up"?  And is that to the
> fsblock size, or the allocation unit size?
> 
Hmm, until now, I was thinking of fs block size, but looking at the function again,
we change it if it is a realtime file.

	startoffset_fsb = XFS_B_TO_FSB(mp, offset);
	endoffset_fsb = XFS_B_TO_FSBT(mp, offset + len);

	/* We can only free complete realtime extents. */
	if (xfs_inode_has_bigrtalloc(ip)) {
		startoffset_fsb = xfs_fileoff_roundup_rtx(mp, startoffset_fsb);
		endoffset_fsb = xfs_fileoff_rounddown_rtx(mp, endoffset_fsb);
	}

>> +	 *
>> +	 * xfs_free_file_space() punches the aligned interior offset_ru -> end_rd
>> +	 * to holes and byte-zeroes the in-range parts of the partial edge blocks,
> 
> xfs_free_file_space rounds inward to allocation unit granularity and
> punches out that range; and then it writes zeroes to non-hole space
> that doesn't get unmapped.
> 
>> +	 * offset -> offset_ru and end_rd -> end.  xfs_zero_range() only touches
>> +	 * already-written blocks here; it skips holes and unwritten extents, so
>> +	 * unallocated/unwritten edge blocks are left for the allocation below.
>> +	 */
>> +	error = xfs_free_file_space(ip, offset, len, ac);
>> +	if (error)
>> +		return error;
>> +
>> +	/*
>> +	 * Publish the new size while the punched range is still a hole, then
>> +	 * fill it with written zeroes.  Like the other fallocate modes we use
>> +	 * xfs_falloc_setsize(), but it must run *before* we convert the range
>> +	 * to written extents: xfs_setattr_size() zeroes [old EOF, new size) via
>> +	 * xfs_zero_range(), which skips holes, so there is nothing to re-zero.
>> +	 * It will also writeback partial EOF block before the on-disk size is
>> +	 * logged.
>> +	 * Note: extending the size before allocating means a failure below
>> +	 * leaves the file larger with unallocated holes in the new range.
>> +	 * That is safe as holes within i_size read back as zeroes and expose
>> +	 * no stale data while the error is propagated to the caller.
>> +	 */
>> +	error = xfs_falloc_setsize(file, new_size);
>> +	if (error)
>> +		return error;
> 
> Hrm ok so now that we've punched out some blocks and zeroed the rest,
> now we adjust the file size, which should only entail committing the new
> file size to disk...
> 
>> +
>> +	/*
>> +	 * Allocate written, zeroed extents across the range.  xfs_alloc_file_space()
>> +	 * rounds outward to block granularity:
>> +	 *  - holes (the punched interior and any unallocated edge block) are
>> +	 *    allocated and zeroed;
>> +	 *  - unwritten extents (including unwritten edge blocks) are converted to
>> +	 *    written and zeroed;
>> +	 *  - Already written edge blocks are skipped. The out-of-range bytes of
>> +	 *    a written edge block keep their data (offset_rd -> offset and
>> +	 *    end -> end_rd); their in-range bytes (offset -> offset_ru and
>> +	 *    end_ru -> end were already zeroed by xfs_free_file_space().
>> +	 */
>> +	return xfs_alloc_file_space(ip, offset, len,
>> +			XFS_ALLOC_FILE_SPACE_WRITE_ZEROES);
> 
> ...and now we can just do an accelerated "write zeroes to disk" which is
> conveniently always within EOF now.  I /think/ this looks ok to me now,
> though I'm curious how extensively the new fallocate mode has been
> tested with fsx and unaligned file ranges?  And rt volumes with rt
> extent size > 1 fsblock.
> 

I tested it extensively with fsblock with fsx and I added some tests locally (which I will
send it upstream soon) for unaligned edges. Some of the corner cases I figured because of some
fsx test (generic/363). But I didn't do it for all the profiles. I will also test it for `-r
extsize=8k -b size=4k`.

Thanks for the review Darrick.

--
Pankaj

