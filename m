Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D5A1C3BFC
	for <linux-xfs@vger.kernel.org>; Tue, 27 May 2025 21:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748380628; cv=none; b=MI+9X7AB+MkL7y5kqbicMsE4PTqJzhFgos4LC6HwJFfYvXIz2kz6eJcxbmZnJb+DDgFRlyK7X9ry5PeFOMMzWJOpQL2GVT5LL7CSPfkq/mxdWlJ7GB+Z1WXlRDcE24DPyxLMmiQJKr8HdZgrvzCoVEYmOWNRhloUsmU75sxQ2WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748380628; c=relaxed/simple;
	bh=VjkxiO3aChbkpfhZTqNPfUkqrpMiyG4sH8VOano4dko=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MATjETn9x5gfgrmmwzL7Y2mRCklMP6v7FCdspHEMUgqCtRJjlddUzkSCX+egsMp6q6gLioQPtwEde651D30w4F3cZE46rP8DtHa1zipGcKseYci/yv+6DZiLMZtRIRd5giIK6cViL1te+xb321o/Ki6f/5Vfw7zOfOI0XQWVLFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kN1afY4t; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kN1afY4t"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-85d9a87660fso373259139f.1
        for <linux-xfs@vger.kernel.org>; Tue, 27 May 2025 14:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748380624; x=1748985424; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yF+6FT9PNvPbo4sx/ufQ+V21d6An2oWzJEAGPygG0eM=;
        b=kN1afY4tJQISGcS5mMMuLB6HPt9z9KEP9NHz4rwrI/4k65LTqoAPk3/6jrfZDWS59p
         17rDzu6TejnsYnyiS3+wNkHfJ2T8O8L/Pl/QhQNb9fP5sfMiaimPfT9m4htlyKNj5XML
         eXBWJ6daV+/pDLPqyBA0wH/VF9m2gcynVjN/KBefJVfkWPsIxJCsq0gs8jMHkLqeQ9av
         6bHskmzCP9iZ7j3FTusv3m7TWLzYvo3M51xBJKYxkvx0BYBkXk2AcE75h1UG0G6W8d9r
         Y5jniAEZEIIK7gjhr9v77c6UIFDjgdo0GTG5BRrapdkiuyZ2CEBUOr7Ks/q08oemG7Fi
         A0sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748380624; x=1748985424;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yF+6FT9PNvPbo4sx/ufQ+V21d6An2oWzJEAGPygG0eM=;
        b=m6Tom2YXDNQm+Phog00A9drXaRTzJ1Z1Wyyal/yN/DobJtaWV5XhfwhJVKTcsSU8HA
         GUO80anGdwCFuZ4g5rKZbIQ3qaQmowkZNrOT07VwQ+d6h+2+AUijyHGjmqZdBPmvhvks
         Al/gzS1sgokAPHmporeooeF+qTJPXJAtL+CeiZCqTueX3S21OscA0IBS2jAvYB05nSb1
         LB7iGDw4uf5IywMeOFq39nrxYGWyWzxD0tzPSB9xe5KqGFsW9JXrgVjXGDhAXoje4ph+
         kT2nLwOZasADeLx5fmpTWHJFoEBvz0IVVNTw6e2ZRFJPIQHJdL/kViSnZKS7oLpQNd1f
         nTpA==
X-Forwarded-Encrypted: i=1; AJvYcCWA5+uMCG1V3XSk4Kuj0C4LkvfEQNkX+mMo31x6L513k8qK3tXLaNsKIbN2dvCoY+5AzFG5Cw8rSXI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxF3R2Emhk/eykX5BWAVoX1vlR9IydDmW39OR0QoG0jxND7CYb6
	d1iuRyYdEcfIatEXdaEI1uefXFQNx9puKAfM43duqKVvafa2aNUyqv/kbZjvFPqTpBn+/ApjbeG
	4pM9o
X-Gm-Gg: ASbGncs/pFfO76+m74oTgSaPUwpRz2JRJo1UlXbjv8qbC4IMf1kWU8Oozl5kEUbbL7l
	RNbn8eit5L3GadTubVN5ankvvhNJB1HJs3Gsf+xat0HzXFEUJTVshTlxTsscWGT5Ep4XMu7ex+S
	D0Faucs1BDleMarU57Mg8Ao3RXbLPRFPfcacRmQp+0ixMZXkIq2Lzbi/f66mYYiT8O2DGPdd3/y
	JDpjgn3afpIoxZbVY6fIXSOzlylEhuznS+++pEFeAabmx+B7Ch7ypKuWykLvIlEUwO6DLZPB8YA
	2cykJaeR70PjccZ9zwELOMbF7SEJBsA8INZMLPwoAD1FMAL3
X-Google-Smtp-Source: AGHT+IFew7Hqs1LLu+x1mBxRqtC/8hhBkw/kSvdUM5vHl7ttcMMDVV4boTbH7S8hCTa8ytg0PMh97w==
X-Received: by 2002:a5e:d516:0:b0:86c:bbea:a6ee with SMTP id ca18e2360f4ac-86cbbeaa74bmr1405053839f.6.1748380624064;
        Tue, 27 May 2025 14:17:04 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fdba5b635esm50247173.32.2025.05.27.14.17.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 May 2025 14:17:03 -0700 (PDT)
Message-ID: <555564a3-cc29-4fc1-a708-9ef395469d90@kernel.dk>
Date: Tue, 27 May 2025 15:17:02 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iomap: don't lose folio dropbehind state for overwrites
To: Dave Chinner <david@fromorbit.com>
Cc: Christian Brauner <brauner@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <a61432ad-fa05-4547-ab82-8d2f74d84038@kernel.dk>
 <aDYqtuXdLvcSl78t@dread.disaster.area>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aDYqtuXdLvcSl78t@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/27/25 3:12 PM, Dave Chinner wrote:
> On Tue, May 27, 2025 at 09:43:42AM -0600, Jens Axboe wrote:
>> DONTCACHE I/O must have the completion punted to a workqueue, just like
>> what is done for unwritten extents, as the completion needs task context
>> to perform the invalidation of the folio(s). However, if writeback is
>> started off filemap_fdatawrite_range() off generic_sync() and it's an
>> overwrite, then the DONTCACHE marking gets lost as iomap_add_to_ioend()
>> don't look at the folio being added and no further state is passed down
>> to help it know that this is a dropbehind/DONTCACHE write.
>>
>> Check if the folio being added is marked as dropbehind, and set
>> IOMAP_IOEND_DONTCACHE if that is the case. Then XFS can factor this into
>> the decision making of completion context in xfs_submit_ioend().
>> Additionally include this ioend flag in the NOMERGE flags, to avoid
>> mixing it with unrelated IO.
>>
>> This fixes extra page cache being instantiated when the write performed
>> is an overwrite, rather than newly instantiated blocks.
>>
>> Fixes: b2cd5ae693a3 ("iomap: make buffered writes work with RWF_DONTCACHE")
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
>>
>> Found this one while testing the unrelated issue of invalidation being a
>> bit broken before 6.15 release. We need this to ensure that overwrites
>> also prune correctly, just like unwritten extents currently do.
> 
> I wondered about the stack traces showing DONTCACHE writeback
> completion being handled from irq context[*] when I read the -fsdevel
> thread about broken DONTCACHE functionality yesterday.
> 
> [*] second trace in the failure reported in this comment:
>
> https://lore.kernel.org/linux-fsdevel/432302ad-aa95-44f4-8728-77e61cc1f20c@kernel.dk/

Indeed, though that could've been a "normal" write and not a DONTCACHE
one. But with the bug being fixed by this one, both would've gone that
path...

 
>> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
>> index 233abf598f65..3729391a18f3 100644
>> --- a/fs/iomap/buffered-io.c
>> +++ b/fs/iomap/buffered-io.c
>> @@ -1691,6 +1691,8 @@ static int iomap_add_to_ioend(struct iomap_writepage_ctx *wpc,
>>  		ioend_flags |= IOMAP_IOEND_UNWRITTEN;
>>  	if (wpc->iomap.flags & IOMAP_F_SHARED)
>>  		ioend_flags |= IOMAP_IOEND_SHARED;
>> +	if (folio_test_dropbehind(folio))
>> +		ioend_flags |= IOMAP_IOEND_DONTCACHE;
>>  	if (pos == wpc->iomap.offset && (wpc->iomap.flags & IOMAP_F_BOUNDARY))
>>  		ioend_flags |= IOMAP_IOEND_BOUNDARY;
>>  
>> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
>> index 26a04a783489..1b7a006402ea 100644
>> --- a/fs/xfs/xfs_aops.c
>> +++ b/fs/xfs/xfs_aops.c
>> @@ -436,6 +436,9 @@ xfs_map_blocks(
>>  	return 0;
>>  }
>>  
>> +#define IOEND_WQ_FLAGS	(IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_SHARED | \
>> +			 IOMAP_IOEND_DONTCACHE)
>> +
>>  static int
>>  xfs_submit_ioend(
>>  	struct iomap_writepage_ctx *wpc,
>> @@ -460,8 +463,7 @@ xfs_submit_ioend(
>>  	memalloc_nofs_restore(nofs_flag);
>>  
>>  	/* send ioends that might require a transaction to the completion wq */
>> -	if (xfs_ioend_is_append(ioend) ||
>> -	    (ioend->io_flags & (IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_SHARED)))
>> +	if (xfs_ioend_is_append(ioend) || ioend->io_flags & IOEND_WQ_FLAGS)
>>  		ioend->io_bio.bi_end_io = xfs_end_bio;
>>  
>>  	if (status)
> 
> IMO, this would be cleaner as a helper so that individual cases can
> be commented correctly, as page cache invalidation does not actually
> require a transaction...
> 
> Something like:
> 
> static bool
> xfs_ioend_needs_wq_completion(
> 	struct xfs_ioend	*ioend)
> {
> 	/* Changing inode size requires a transaction. */
> 	if (xfs_ioend_is_append(ioend))
> 		return true;
> 
> 	/* Extent manipulation requires a transaction. */
> 	if (ioend->io_flags & (IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_SHARED))
> 		return true;
> 
> 	/* Page cache invalidation cannot be done in irq context. */
> 	if (ioend->io_flags & IOMAP_IOEND_DONTCACHE)
> 		return true;
> 
> 	return false;
> }
> 
> Otherwise seems fine.

Yeah I like that, gets rid of the need to add the mask as well. I'll
spin a v2 and add the helper.

-- 
Jens Axboe
