Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89394343D77
	for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 17:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771436489; cv=none; b=rAwEXB4ERvZ7RHnDFHXBADh86KFfB97spKUOiXXSr7nnW+FYtrIXp7xXvk51a1bWcB5gvAWIEwN4R2dzgNNdCYjJZ+A7xLDHV4n7DTuhBn3ihaoxVFj1Zp3kP86qVOvMMAVnZTxTfoEYPzQlrTNvZTp/RORpoeJhbENvHdbLzKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771436489; c=relaxed/simple;
	bh=W1C2rZ9ZD7+WtKUhLg4WYgmJYcFHW7ES1DldMTnFN9Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OFnbw5kdUoxMCrUuUwfC/QwkrOdujutNVTmRIcDZKp1XUdyHLdF78KCNVruCw9eA/ocoWBsBLmAFR0zC2+bjBn/BslVK+OsmFn7Gr6lc89C9pPrD0VDm/Xgu/5o5LPycoNEQaGyEZbQvgmCx01+vxBU9QiP0sAYzbQSllb8Q+QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wx/lUdpV; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wx/lUdpV"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2a95de4b5cbso246375ad.1
        for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 09:41:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771436488; x=1772041288; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ipH6XqeHh3W8Ei0yJdhpX+9znKSpvZOuW7bCYHXq97o=;
        b=Wx/lUdpVaIIYAa1SuIm6pyOzT88S6KxB5BXVJknnaxtldfNnI7G76ulbU2OmMABEvD
         JeovOc43M599YF3vG22V4gC13CM06KcOhVMtKLTc48m4G0txb9HcT0n8bVc03ExYeTHw
         FLMRdlDI2K2wYIwnhvlsX0A6NQKTvFaSDhENlH0WTEYY+f+/dSwrLzoX39c4iVFeWdLE
         FckKKpVUFITGJivI9a9Aeps2dd4Lo6zkSO+vqYiONvE3Yi9V80PpjuitHqEPdiRg0+Ow
         F0rXRGDtmsCbqkdnihtJ6hxmOW9BKNWUPlJ9vDUKX2Qo+lXOR+ihlZSRhhYz+K4YwCyh
         UAbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771436488; x=1772041288;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ipH6XqeHh3W8Ei0yJdhpX+9znKSpvZOuW7bCYHXq97o=;
        b=Rit+Jnad5VUnxa3QGeQEK5z/XKIfSw11u8Zhs/rfY13vfSNmpLlbBNKoB8u9kNPVKv
         da3usPAm/pOXdUYJGITiukAuY2vf4ugOyuJ71UW1ig/vSeyzR6UisMPmtyH85pyb9pFj
         LPJ5PFe8klhc6oIu74+jOJA9REXAfhd1kgvYy76rhBmyTXH7cZLgfTggsfMXh5Z74bP7
         OJrMWTCebsW/vt8YNGtObC8uSmshCnfHBhEmlEolDBKx92XPoGElE9WlZihlZaKnPDEq
         juN/3yWpKcx7UQiel5Ukj6aGiz0apKVtQro8sfgryb2nJylyb7o7rfAuBiQUJCNduWBP
         2Hdg==
X-Forwarded-Encrypted: i=1; AJvYcCXyucctdmnWkB02kilnvXaaM5+QVLRWOIYxgn6QqaUPDf7WhsUTPK2KO1isjMN5H/Z3uJ00nsmoFdY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQTiPYV3/h1QqJYfqpY6cuIRHB59T4frOkbl16p5ctq3oT2nfT
	MhdiZyX1kvQZSkGqNocCSVxSrMJ4qoq+yVmKMZ3IEk3NA3H0qVoY+UVx
X-Gm-Gg: AZuq6aK3ENxxoPXSDICZEj3FITnWmtsJrBy2C28iKX2Zxr2RliSihv3+0n3YXWmx6ip
	DVQ1bsvAFGrRiAIbk2CjDXtDWxMkEsU9j9j5Y6H6gElo02TcKieMzetfEHZts2CoBXe4H2SzFp9
	Nj5UJWRMJeJDx8BzakWktxQ257QjanBG4E7x/A45luvvUUMCCFUL6qBEmNid5b2P2+h2Uarjt2y
	VRiUXk+y4nUUNTt5/0rJ4JA9fykpsX2SAFck6Q0llhhXwrrpAObiB8AWHb8NZS3UTPrde95bhPO
	PMoCfkj+WV53q9+gf4nkMVP2xlBJQxEN4fO5VNswH3WY1SU3S7XgCR869dJ8l70FMcccfkxIbUE
	tlett17IxbXa33dte4XA/1x+mYIVHGpDJLsAL2bHNNFNd6SHnVQuv8MYYh+FnRA+mrJ9MVcRxW7
	nmHz3lZMVL/reDnuUbUCUfCbptAXpqr+RF3Tf9ng==
X-Received: by 2002:a17:903:2f85:b0:2ab:333:22e8 with SMTP id d9443c01a7336-2ab4cfbc6b7mr173584125ad.24.1771436487697;
        Wed, 18 Feb 2026 09:41:27 -0800 (PST)
Received: from [192.168.0.120] ([49.207.232.214])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1aadd47csm135969115ad.65.2026.02.18.09.41.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Feb 2026 09:41:27 -0800 (PST)
Message-ID: <81721558-d5b7-4120-8881-cf63f3a96fd6@gmail.com>
Date: Wed, 18 Feb 2026 23:11:23 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] iomap, xfs: lift zero range hole mapping flush
 into xfs
Content-Language: en-US
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Brian Foster <bfoster@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-xfs@vger.kernel.org
References: <20260129155028.141110-1-bfoster@redhat.com>
 <20260129155028.141110-2-bfoster@redhat.com>
 <af7b989f430a8b464f48a8404b4f60a5fb4a189f.camel@gmail.com>
 <20260213162457.GG7712@frogsfrogsfrogs>
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <20260213162457.GG7712@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 2/13/26 21:54, Darrick J. Wong wrote:
> On Fri, Feb 13, 2026 at 03:50:07PM +0530, Nirjhar Roy (IBM) wrote:
>> On Thu, 2026-01-29 at 10:50 -0500, Brian Foster wrote:
>>> iomap zero range has a wart in that it also flushes dirty pagecache
>>> over hole mappings (rather than only unwritten mappings). This was
>>> included to accommodate a quirk in XFS where COW fork preallocation
>>> can exist over a hole in the data fork, and the associated range is
>>> reported as a hole. This is because the range actually is a hole,
>>> but XFS also has an optimization where if COW fork blocks exist for
>>> a range being written to, those blocks are used regardless of
>>> whether the data fork blocks are shared or not. For zeroing, COW
>>> fork blocks over a data fork hole are only relevant if the range is
>>> dirty in pagecache, otherwise the range is already considered
>>> zeroed.
>>>
>>> The easiest way to deal with this corner case is to flush the
>>> pagecache to trigger COW remapping into the data fork, and then
>>> operate on the updated on-disk state. The problem is that ext4
>>> cannot accommodate a flush from this context due to being a
>>> transaction deadlock vector.
>>>
>>> Outside of the hole quirk, ext4 can avoid the flush for zero range
>>> by using the recently introduced folio batch lookup mechanism for
>>> unwritten mappings. Therefore, take the next logical step and lift
>>> the hole handling logic into the XFS iomap_begin handler. iomap will
>>> still flush on unwritten mappings without a folio batch, and XFS
>>> will flush and retry mapping lookups in the case where it would
>>> otherwise report a hole with dirty pagecache during a zero range.
>>>
>>> Note that this is intended to be a fairly straightforward lift and
>>> otherwise not change behavior. Now that the flush exists within XFS,
>>> follow on patches can further optimize it.
>>>
>>> Signed-off-by: Brian Foster <bfoster@redhat.com>
>>> ---
>>>   fs/iomap/buffered-io.c |  2 +-
>>>   fs/xfs/xfs_iomap.c     | 25 ++++++++++++++++++++++---
>>>   2 files changed, 23 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
>>> index 6beb876658c0..807384d72311 100644
>>> --- a/fs/iomap/buffered-io.c
>>> +++ b/fs/iomap/buffered-io.c
>>> @@ -1620,7 +1620,7 @@ iomap_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
>>>   		     srcmap->type == IOMAP_UNWRITTEN)) {
>>>   			s64 status;
>>>   
>>> -			if (range_dirty) {
>>> +			if (range_dirty && srcmap->type == IOMAP_UNWRITTEN) {
>>>   				range_dirty = false;
>>>   				status = iomap_zero_iter_flush_and_stale(&iter);
>>>   			} else {
>>> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
>>> index 37a1b33e9045..896d0dd07613 100644
>>> --- a/fs/xfs/xfs_iomap.c
>>> +++ b/fs/xfs/xfs_iomap.c
>>> @@ -1790,6 +1790,7 @@ xfs_buffered_write_iomap_begin(
>>>   	if (error)
>>>   		return error;
>>>   
>>> +restart:
>>>   	error = xfs_ilock_for_iomap(ip, flags, &lockmode);
>>>   	if (error)
>>>   		return error;
>>> @@ -1817,9 +1818,27 @@ xfs_buffered_write_iomap_begin(
>>>   	if (eof)
>>>   		imap.br_startoff = end_fsb; /* fake hole until the end */
>>>   
>>> -	/* We never need to allocate blocks for zeroing or unsharing a hole. */
>>> -	if ((flags & (IOMAP_UNSHARE | IOMAP_ZERO)) &&
>>> -	    imap.br_startoff > offset_fsb) {
>>> +	/* We never need to allocate blocks for unsharing a hole. */
>>> +	if ((flags & IOMAP_UNSHARE) && imap.br_startoff > offset_fsb) {
>>> +		xfs_hole_to_iomap(ip, iomap, offset_fsb, imap.br_startoff);
>>> +		goto out_unlock;
>>> +	}
>>> +
>>> +	/*
>>> +	 * We may need to zero over a hole in the data fork if it's fronted by
>>> +	 * COW blocks and dirty pagecache. To make sure zeroing occurs, force
>>> +	 * writeback to remap pending blocks and restart the lookup.
>>> +	 */
>>> +	if ((flags & IOMAP_ZERO) && imap.br_startoff > offset_fsb) {
>>> +		if (filemap_range_needs_writeback(inode->i_mapping, offset,
>>> +						  offset + count - 1)) {
>>> +			xfs_iunlock(ip, lockmode);
>> I am a bit new to this section of the code - so a naive question:
>> Why do we need to unlock the inode here? Shouldn't the mappings be thread safe while the write/flush
>> is going on?
> Writeback takes XFS_ILOCK, which we currently hold here (possibly in
> exclusive mode) so we must drop it to write(back) and wait.

Okay, got it. Thank you.

--NR

>
> --D
>
>> --NR
>>> +			error = filemap_write_and_wait_range(inode->i_mapping,
>>> +						offset, offset + count - 1);
>>> +			if (error)
>>> +				return error;
>>> +			goto restart;
>>> +		}
>>>   		xfs_hole_to_iomap(ip, iomap, offset_fsb, imap.br_startoff);
>>>   		goto out_unlock;
>>>   	}
>>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

