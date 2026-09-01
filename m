Received: from m16.mail.126.com (m16.mail.126.com [220.197.31.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2375C36B937;
	Tue,  1 Sep 2026 09:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788256695; cv=none; b=rnvNb6Ej4bvi8TcamBfhQ0HxDbLw7ErDqWMuX9JPFeF5vIKzAEMShWD7nMm/AcnjVepgUAYgvI57JUtRoshA2MCj5AfkM1YDNpua/UclhiP8r+pd6TmWOAnZSvZ7bRaaxtke/TqNBoY5OI92n3AgQ8eh2nkID0YYaYh/tAFo4JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788256695; c=relaxed/simple;
	bh=XYMbeXBfOEyRxC0i3CmUy2DlQ0vfDIFt9a2avoP6ZX0=;
	h=Message-ID:Date:From:MIME-Version:To:CC:Subject:References:
	 In-Reply-To:Content-Type; b=aFRnH6jQ9Btt5h0DkIOERVRdhiCg8MUxu5CAiLkPYdxNS5/HV9VpTyJf69P7d9UuaEW2GmXGyqAfYz7b0ZZuzEbitaH3g3xTS6oZxcoPaqkuRze3YHU0b4Upime9il51xZrsMxEtH72C+Z54rD2OdKKKHqvkIX78dkDavzHgpjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=MIcHzRaw; arc=none smtp.client-ip=220.197.31.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="MIcHzRaw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=Message-ID:Date:From:MIME-Version:To:Subject:
	Content-Type; bh=KLhdG1AqRzKa01vbe6PNzPfrnJzkqfVznwo/f7/UnT4=;
	b=MIcHzRawpTqSO9KHRv0uQFEDdDbxyc/nJ+kZSJcP4J7SBp0rTnR19KvFd1cn/l
	HpG7fUrTnORyxoPNPfBE4h7JTXbsTaA9BE0C1GNNyMGahAyKPK9PkBY1zLHGyJnx
	drC23U4Lb6ofteW3iVjXoLmNtXFXP4IMv/0gGlRHhsBcE=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wDnz7aSoZZqmGXeHQ--.58331S2;
	Tue, 01 Sep 2026 17:57:38 +0800 (CST)
Message-ID: <6A96A175.1090700@126.com>
Date: Tue, 01 Sep 2026 17:57:09 +0800
From: Hongling Zeng <zhongling0719@126.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
To: Carlos Maiolino <cem@kernel.org>
CC: Hongling Zeng <zenghongling@kylinos.cn>, darrick.wong@oracle.com, 
 chandanrlinux@gmail.com, linux-xfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: fix array bounds checking in log recovery
References: <20260824094535.219503-1-zenghongling@kylinos.cn> <apZ5UptiKsVGgPHZ@andromeda.toxiclabs.cc> <6A969D6D.6060808@126.com> <apafftcOk6XIDYTQ@andromeda.toxiclabs.cc>
In-Reply-To: <apafftcOk6XIDYTQ@andromeda.toxiclabs.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnz7aSoZZqmGXeHQ--.58331S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxXr15GFyfJw1fKF18Jr4xJFb_yoWrAF4fpr
	s3ta1DCw4DJr1xtrn2q3W5Was3K348Jr4Uur43Gw17ur9xKr17urWYqFyjg3s7Ar4qva1j
	9r45ZrWfurW5ZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j-TmfUUUUU=
X-CM-SenderInfo: x2kr0wpolqwiqxrzqiyswou0bp/xtbBrhPMnWqWoZM2DAAA3Y


在 2026年09月01日 17:49, Carlos Maiolino 写道:
> On Tue, Sep 01, 2026 at 05:39:57PM +0800, Hongling Zeng wrote:
>> 在 2026年09月01日 15:06, Carlos Maiolino 写道:
>>> On Mon, Aug 24, 2026 at 05:45:35PM +0800, Hongling Zeng wrote:
>>>> The log recovery code increments array indices based on bits set in
>>>> blf_data_map without verifying that the indices stay within the bounds
>>>> of the item->ri_buf array.
>>>>
>>>> Since blf_data_map is from untrusted log data, a malicious log could set
>>>> many bits while ri_total is small, causing array index overflow.
>>>>
>>>> This can result in an out-of-bounds access during log recovery, causing
>>>> a kernel crash or memory corruption.
>>>>
>>>> This patch adds array bounds checking for ri_buf access in
>>>> xlog_recover_do_reg_buffer() and xlog_recover_do_inode_buffer().
>>>>
>>>> The check in xlog_recover_do_inode_buffer() is placed right before the
>>>> actual array access, not after incrementing the index, to avoid false
>>>> positives when processing the last valid region.
>>>>
>>>> Fixes: 1094d3f12363 ("xfs: refactor log recovery buffer item dispatch for pass2 commit functions")
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
>>> Hi,
>>>
>>> is this a re-send? A v2? Please specify why you are sending the same
>>> patche again. This saves a lot of time trying to understand why there
>>> are two patches with the same subject in the list.
>> Hi ,
>> This is the same patch version, but the previous submission failed to
>> apply because my local repository was out of date. I updated my tree and
>> resubmitted the patch with the same fix.
>>
>> Sorry for the confusion.
> So this is not the same version, it's a rebase against top of the tree
> and that should be properly described.
>
> I'll be updating for-next soon this week, please rebase it again on top
> of for-next once I publish it and re-send it.
>
> Cheers,
> Carlos
> |
> |
|Thanks for the clarification.

Got it — this is a rebase, not a new version. I’ll wait for your updated
for-next tree, rebase the fix on top of it, and resend it with an
appropriate changelog.

Sorry for the confusion.

Thanks,
Hongling|
>> Thanks,
>> Hongling
>>>> ---
>>>>    fs/xfs/xfs_buf_item_recover.c | 26 ++++++++++++++++++++++++++
>>>>    1 file changed, 26 insertions(+)
>>>>
>>>> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
>>>> index 57929f115055..7148716366ba 100644
>>>> --- a/fs/xfs/xfs_buf_item_recover.c
>>>> +++ b/fs/xfs/xfs_buf_item_recover.c
>>>> @@ -485,6 +485,19 @@ xlog_recover_do_reg_buffer(
>>>>    			break;
>>>>    		nbits = xfs_contig_bits(buf_f->blf_data_map,
>>>>    					buf_f->blf_map_size, bit);
>>>> +
>>>> +		/*
>>>> +		 * The bitmap can have more bits set than there are regions
>>>> +		 * in ri_buf, so we must check array bounds before using the
>>>> +		 * index to access ri_buf[i].
>>>> +		 */
>>>> +		if (XFS_IS_CORRUPT(mp, i >= item->ri_total)) {
>>>> +			xfs_alert(mp,
>>>> +		"Buffer log item index (%d) exceeds allocated regions (%d).",
>>>> +					i, item->ri_total);
>>>> +			return -EFSCORRUPTED;
>>>> +		}
>>>> +
>>>>    		ASSERT(nbits > 0);
>>>>    		ASSERT(item->ri_buf[i].iov_base != NULL);
>>>>    		ASSERT(item->ri_buf[i].iov_len % XFS_BLF_CHUNK == 0);
>>>> @@ -688,6 +701,19 @@ xlog_recover_do_inode_buffer(
>>>>    		if (next_unlinked_offset < reg_buf_offset)
>>>>    			continue;
>>>> +		/*
>>>> +		 * Check array bounds here (right before accessing ri_buf)
>>>> +		 * rather than after incrementing item_index. This avoids
>>>> +		 * incorrectly rejecting logs when item_index reaches
>>>> +		 * ri_total after processing the final valid region.
>>>> +		 */
>>>> +		if (XFS_IS_CORRUPT(mp, item_index >= item->ri_total)) {
>>>> +			xfs_alert(mp,
>>>> +		"Inode buffer log item index (%d) exceeds allocated regions (%d).",
>>>> +				item_index, item->ri_total);
>>>> +			return -EFSCORRUPTED;
>>>> +		}
>>>> +
>>>>    		ASSERT(item->ri_buf[item_index].iov_base != NULL);
>>>>    		ASSERT((item->ri_buf[item_index].iov_len % XFS_BLF_CHUNK) == 0);
>>>>    		ASSERT((reg_buf_offset + reg_buf_bytes) <= BBTOB(bp->b_length));
>>>> -- 
>>>> 2.25.1
>>>>
>>>>
>>

