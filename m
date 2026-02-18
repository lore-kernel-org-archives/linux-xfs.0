Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87836343D77
	for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 17:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771436455; cv=none; b=aWYQzfp/id5kIcVybgUy7GvNeKiHGAnmC89BE3TJIxK1H/utAPpg/h5SMKNFB3C0sGVY73O6lRffv9y1aNKjM2UUtLulcS8AteZOMaYhaEw0UsQSS28IlZgKGqpucP8qFv3WsE7RJcCdwx9HcvxVXQvGzOhAIBmDzYWnvTkRS+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771436455; c=relaxed/simple;
	bh=oEGcWJ6uNixtn8g3bDM1JkvL6u4cUqsA7HGuS/QGEPM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B1RiOIAkQ0xYFjqNGEJpTt5fgV5J+K03IQKqoJca7AbnY14D2eQBi9ki8o/4ZQX1rm9b1zdTi/9Sdj/x+efeci26UB6lgu8GAKXoN2jdMeYT/V2pZCs4BdvwCDKnh0hJarGZ3zq4jzhnubM/4tX/JS92qaWmODCWbCUxCsgjZhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WyGvQ/1M; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WyGvQ/1M"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8249aca0affso10481b3a.3
        for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 09:40:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771436454; x=1772041254; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KWd8+ZQmkBQp+3rgZfgHdPB83evQicf7+tB0l6lsKxM=;
        b=WyGvQ/1MwiYNpiysZZbH5D/q5kUPL22LdLyaskDH8DBs+g5+gHRCKQhxXqh1EbT1aW
         asLPIThQjszRzzinr5IIrMgJNH43W7vBWo2S7UYyP9xcF5wsOicLy1lTyu0O7/jhK3tZ
         jA6dpmrM/zVNR74ne+dK7L064VmKYIuWcEOHpNptBDWFHDPlN2z1k0ppDy0Vvim/FmwS
         YWzyHN7eJqK7iZitmBevvvJ7d603Nkwn6RzVPJC7IPcetdyggr/84Ox38psVbCjWeDfc
         5naFs/uIQs+N0VMJf95m+N5N4ZFwCsd6cj2XHH7iNOL54DCbZmW2EE0nfBZQm83SgNxS
         ezDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771436454; x=1772041254;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KWd8+ZQmkBQp+3rgZfgHdPB83evQicf7+tB0l6lsKxM=;
        b=S00ck1vAggcUO/uzSW9a5xk8mdA8n08+qpJfESMssLbYQUOXu1YqLPBHDdbanYpxxU
         C3wp/6EcimdEgevxsuSxx/YhigdnVkTZFJjWga+nE1lIKFKZwODBAIAY0TlqByjsdGjy
         t3Q4CH0rOzu7VsJsbYHoajxsmgfa9WLJqyCV8Lcc7J8S4n0I6Qm5/+P/WESvsbuzIK+N
         Iou1jO0+Yu39l9qO5PSLYs73IfJs5C+0Pon/aHFcQMnG0t4EharABLozo4rRxzh+huH6
         iWLZ9XLfTfYWC+eOpIoaVL0uRQsFevJ5h7nS5zdyuNYOjTcEsVyMPM/ItCtV2oTkNzBB
         9EWA==
X-Forwarded-Encrypted: i=1; AJvYcCXEFBrGM3obZfobT2SWjN0kUKMbVgz0aZA4V0LR+3aWoPsAxTdsb0TAfDl5OWmbsZxCVPU0KzPLKaU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmvOsOX5g3KqbneJEDotQcAgGMG6rpaeTdi+lr8h6GrzrwxN94
	DeukojAnktFEgEyQSk9kSNxhzj8FA6Zjp4CoAOlGVXp2yfVWDnqs3VrR
X-Gm-Gg: AZuq6aLMLNYkjT4A9AVFgk08VSC20GYAlIpoGCvmwgZ38a0UETL49ipUa7x9SUFreb4
	9g0lQVX3saPgE09iz3Fwg4qq6WS31ul7xwMir2jfPYM2nvFuCEFdm6hA4vyDo6sMDasJJxKU2Ec
	BKcj0SwOR2c0eS4wO8roG514vbXuE7IUhYbmEafo0PBeCFxZ28ppf5C/zRqWgLN8jczIcOO0fqd
	aHkLKBl4KQrfx7fZH2Eaak/AohyOqb4xVM9C/TMHipefoS68qqiMOo+A5fnbrzKgJ4KkGjab+2v
	0UmLIyzWR9VSr4NU5I6fhkkAySxKex2AY3GR81kvfwzD7yi9Ph6yM+6e8CmtfuIT376Oj1MFpy4
	G9v+1jqsRZj/gxq24ErdXxcUqeuIsYAPat5E3PdJNV0m/SS/42GWNcudmM9wLnA3p3mis5gXrF9
	SvB7ISL3mP4/Pb5Raq9c+yoDBCNXEQHUqE0LweBg==
X-Received: by 2002:a05:6a00:3cc9:b0:824:b181:f492 with SMTP id d2e1a72fcca58-824d95f4ccamr14808764b3a.45.1771436453736;
        Wed, 18 Feb 2026 09:40:53 -0800 (PST)
Received: from [192.168.0.120] ([49.207.232.214])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824c6b94009sm17494261b3a.52.2026.02.18.09.40.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Feb 2026 09:40:53 -0800 (PST)
Message-ID: <1994c53d-4c4d-4b86-b66c-f8cb84ff7cf5@gmail.com>
Date: Wed, 18 Feb 2026 23:10:49 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] xfs: only flush when COW fork blocks overlap data
 fork holes
Content-Language: en-US
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20260129155028.141110-1-bfoster@redhat.com>
 <20260129155028.141110-5-bfoster@redhat.com>
 <37206076c486da01efe90b95f5dc61049cb2d141.camel@gmail.com>
 <aZXc0vyT2zVcRXCp@bfoster>
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <aZXc0vyT2zVcRXCp@bfoster>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 2/18/26 21:07, Brian Foster wrote:
> On Tue, Feb 17, 2026 at 08:36:50PM +0530, Nirjhar Roy (IBM) wrote:
>> On Thu, 2026-01-29 at 10:50 -0500, Brian Foster wrote:
>>> The zero range hole mapping flush case has been lifted from iomap
>>> into XFS. Now that we have more mapping context available from the
>>> ->iomap_begin() handler, we can isolate the flush further to when we
>>> know a hole is fronted by COW blocks.
>>>
>>> Rather than purely rely on pagecache dirty state, explicitly check
>>> for the case where a range is a hole in both forks. Otherwise trim
>>> to the range where there does happen to be overlap and use that for
>>> the pagecache writeback check. This might prevent some spurious
>>> zeroing, but more importantly makes it easier to remove the flush
>>> entirely.
>>>
>>> Signed-off-by: Brian Foster <bfoster@redhat.com>
>>> ---
>>>   fs/xfs/xfs_iomap.c | 36 ++++++++++++++++++++++++++++++------
>>>   1 file changed, 30 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
>>> index 0edab7af4a10..0e82b4ec8264 100644
>>> --- a/fs/xfs/xfs_iomap.c
>>> +++ b/fs/xfs/xfs_iomap.c
>>> @@ -1760,10 +1760,12 @@ xfs_buffered_write_iomap_begin(
>>>   {
>>>   	struct iomap_iter	*iter = container_of(iomap, struct iomap_iter,
>>>   						     iomap);
>>> +	struct address_space	*mapping = inode->i_mapping;
>>>   	struct xfs_inode	*ip = XFS_I(inode);
>>>   	struct xfs_mount	*mp = ip->i_mount;
>>>   	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
>>>   	xfs_fileoff_t		end_fsb = xfs_iomap_end_fsb(mp, offset, count);
>>> +	xfs_fileoff_t		cow_fsb = NULLFILEOFF;
>>>   	struct xfs_bmbt_irec	imap, cmap;
>>>   	struct xfs_iext_cursor	icur, ccur;
>>>   	xfs_fsblock_t		prealloc_blocks = 0;
>>> @@ -1831,6 +1833,8 @@ xfs_buffered_write_iomap_begin(
>>>   		}
>>>   		cow_eof = !xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb,
>>>   				&ccur, &cmap);
>>> +		if (!cow_eof)
>>> +			cow_fsb = cmap.br_startoff;
>>>   	}
>>>   
>>>   	/* We never need to allocate blocks for unsharing a hole. */
>>> @@ -1845,17 +1849,37 @@ xfs_buffered_write_iomap_begin(
>>>   	 * writeback to remap pending blocks and restart the lookup.
>>>   	 */
>>>   	if ((flags & IOMAP_ZERO) && imap.br_startoff > offset_fsb) {
>>> -		if (filemap_range_needs_writeback(inode->i_mapping, offset,
>>> -						  offset + count - 1)) {
>>> +		loff_t start, end;
>> Nit: Tab between data type and identifier?
>>
> Sure.
>
>>> +
>>> +		imap.br_blockcount = imap.br_startoff - offset_fsb;
>>> +		imap.br_startoff = offset_fsb;
>>> +		imap.br_startblock = HOLESTARTBLOCK;
>>> +		imap.br_state = XFS_EXT_NORM;
>>> +
>>> +		if (cow_fsb == NULLFILEOFF) {
>>> +			goto found_imap;
>>> +		} else if (cow_fsb > offset_fsb) {
>>> +			xfs_trim_extent(&imap, offset_fsb,
>>> +					cow_fsb - offset_fsb);
>>> +			goto found_imap;
>>> +		}
>>> +
>>> +		/* COW fork blocks overlap the hole */
>>> +		xfs_trim_extent(&imap, offset_fsb,
>>> +			    cmap.br_startoff + cmap.br_blockcount - offset_fsb);
>>> +		start = XFS_FSB_TO_B(mp, imap.br_startoff);
>>> +		end = XFS_FSB_TO_B(mp,
>>> +				   imap.br_startoff + imap.br_blockcount) - 1;
>> So, we are including the bytes in the block number (imap.br_startoff + imap.br_blockcount - 1)th,
>> right? That is why a -1 after XFS_FSB_TO_B()?
> Not sure I follow what you mean by the "bytes in the block number"
> phrasing..? Anyways, the XFS_FSB_TO_B() here should return the starting
> byte offset of the first block beyond the range (exclusive). The -1
> changes that to the last byte offset of the range we're interested in
> (inclusive), which I believe is what the filemap api wants..

Yeah, that answers my question. Thank you.

--NR

>
> Brian
>
>> --NR
>>> +		if (filemap_range_needs_writeback(mapping, start, end)) {
>>>   			xfs_iunlock(ip, lockmode);
>>> -			error = filemap_write_and_wait_range(inode->i_mapping,
>>> -						offset, offset + count - 1);
>>> +			error = filemap_write_and_wait_range(mapping, start,
>>> +							     end);
>>>   			if (error)
>>>   				return error;
>>>   			goto restart;
>>>   		}
>>> -		xfs_hole_to_iomap(ip, iomap, offset_fsb, imap.br_startoff);
>>> -		goto out_unlock;
>>> +
>>> +		goto found_imap;
>>>   	}
>>>   
>>>   	/*

-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

