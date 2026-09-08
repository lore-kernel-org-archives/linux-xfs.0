Received: from m16.mail.126.com (m16.mail.126.com [220.197.31.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F38041C6A;
	Tue,  8 Sep 2026 02:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788833904; cv=none; b=m3l4PtMjBZm4gCWz5wwVqPMUHRFPW5PIjjaFPOKzTTkMQESiglLvSM01LT30+wo6uR3ca38PnT32bPdhtb5kPqqZC9ftN4BuCKzju0T9m6Zdt4DkSnty5mUuH2zjlJy3MIrAw6UiFJE8TVoIQMcrCEbfBhVgbMplHA8D3ZSQLbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788833904; c=relaxed/simple;
	bh=YI5XWM2vIbeaTqAD4dMZrDmq04eSZo1WcgGIMDXZARE=;
	h=Message-ID:Date:From:MIME-Version:To:CC:Subject:References:
	 In-Reply-To:Content-Type; b=m8YjAlbF6DXgxIrHgTreG7UkKP5PTTeNCx09PMem66snlxw/IdEMClRg+zewYplfY3Ps8mnEcfgjAOJMnOHZjT1qmHJKEc956g7reuFxLjQDOs7KqUaEEbydsTHqwSmO0mgfVCsSHrENfITokvMUYoxiCA9wEZl4UKGRJy6436Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=Hux03YSM; arc=none smtp.client-ip=220.197.31.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="Hux03YSM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=Message-ID:Date:From:MIME-Version:To:Subject:
	Content-Type; bh=Rm0Rv7fok0SCJUn9VSjAe7VIwlYtln47RXDjm3iS2Tc=;
	b=Hux03YSMo3dG/xZPhiI9wwuANbSAtM8KtiNyOwZL3QppaSJZBe4z6SapzRNHuk
	N3DE+kW73sw5OeZ3ADVqT/e5vLyRXDWcQwqslYY+B2o9uVlXwtgcXlhAT0W3+7Uz
	a957BsvFs327N0tgKFH0OCFLG9DGZTs3qOImaiUrdELo4=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wDH78pDcJ9q_O+sAg--.19288S2;
	Tue, 08 Sep 2026 10:17:39 +0800 (CST)
Message-ID: <6A9F7022.6020206@126.com>
Date: Tue, 08 Sep 2026 10:17:06 +0800
From: Hongling Zeng <zhongling0719@126.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
To: Dave Chinner <dgc@kernel.org>, 
 Hongling Zeng <zenghongling@kylinos.cn>
CC: cem@kernel.org, darrick.wong@oracle.com, chandanrlinux@gmail.com, 
 linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
Subject: Re: [PATCH v2] xfs: bound logged region access in inode buffer recovery
References: <20260907080450.314067-1-zenghongling@kylinos.cn> <ap8ucHIw-pKLhh9c@dread>
In-Reply-To: <ap8ucHIw-pKLhh9c@dread>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDH78pDcJ9q_O+sAg--.19288S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxWF1rCr4kZr1UGr13XF15CFg_yoWrXFy8pF
	Z3KF4q9rnrtFZ2yFs2vw4UX3yFka93tay5GFn8Arn5Cr15Gw1aqFWftF1jqFy7CrnYva1j
	qr4UXasrWas8Za7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j-WrJUUUUU=
X-CM-SenderInfo: x2kr0wpolqwiqxrzqiyswou0bp/xtbBrgOuf2qfcEMTjAAA3l


在 2026年09月08日 05:36, Dave Chinner 写道:
> On Mon, Sep 07, 2026 at 04:04:50PM +0800, Hongling Zeng wrote:
>> xlog_recover_do_inode_buffer() reads the logged di_next_unlinked field
>> from a log record buffer at a computed offset:
>>
>>          logged_nextp = item->ri_buf[item_index].iov_base +
>>                          next_unlinked_offset - reg_buf_offset;
>>          *buffer_nextp = *logged_nextp;
>>
>> The only protection against reading past the log record buffer are
>> ASSERT()s, which compile away on non-DEBUG kernels.  The existing
>> XFS_IS_CORRUPT(*logged_nextp == 0) check also dereferences the pointer
>> before validating that the computed offset lies within the logged region.
>>
>> A crafted log record can make the computed offset exceed iov_len, causing
>> an out-of-bounds read from the log record buffer during inode buffer
>> recovery.
>>
>> Convert the relevant ASSERT-only checks into runtime corruption checks and
>> verify that the logged di_next_unlinked field lies entirely within the log
>> iovec before dereferencing it.
>>
>> Fixes: 1094d3f12363 ("xfs: refactor log recovery buffer item dispatch for pass2 commit functions")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
> <sigh>
>
> I'm going to say what I've said before again here, and it applies to
> the BLF bitmap range checks patches you posted yesterday, too:
>
> Hacking the same types of region size and range checks into every
> log item type in an ad-hoc manner is not the right way to address
> these log item verification issues.
>
> We need to add a robust verification layer to the journal to verify
> all the journal level metadata (e.g. ophdrs, transaction headers,
> initial log item regions, per-log item type verification, etc) so
> that we check *all* the journal items for sanity before we use them.
>
> This is the same architecture we use for metadata (the verifier
> layer) and it applies to the journal for the same reasons and
> provides the same benefits (i.e. validate at first access, rest of
> the code can assume validity and not have to clutter logic with
> random validity checks to prevent bad behaviour.)
>
> The high level design doc and rough plan I put together last time I
> brought this up is in the patch below. If you're not willing or able
> to spent time and tokens on fixing this entire class of problems for
> everyone, then let please let me know ASAP.
>
> -Dave.
   Hi Dave,

   Thanks for the detailed feedback. I understand the concern: the ad-hoc
   region checks I posted don't address log recovery validation
   systematically.

   I'll withdraw the inode buffer and BLF bitmap patches and switch to
   the design-driven approach. I'll post your patch 5 first (the
   unchecked ri_buf[ri_cnt-1] in add_to_cont_trans(), the unbounded
   kvrealloc() there, the missing oh_len alignment check in
   process_data() - all reachable bugs, no restructuring), then work
   through the rest of Phase 1.

   Three points to confirm before coding:

   1. I don't see a write-side guarantee that a region is split at most
      once - xlog_write_partial() can emit multiple continuations. So
      beyond your patch 2 treating the header as a normal accumulated
      region, note that today a third fragment walks into
      ri_buf[ri_cnt-1] with ri_cnt == 0 / ri_buf == NULL. Correct?

   2. For the zero-length first fragment: if this is old-log
      compatibility only, I'd document it that way and keep the special
      handling as narrow as possible rather than introducing a generic
      anonymous item state. Note the doc's ri_in_continuation has no
      owner at that point since no item exists yet - narrow handling
      avoids that entirely.

   3. For testing I'll cover each phase with crafted-log images and run
      xfstests. My bigger worry is over-strict validation rejecting valid
      logs, which only shows up replaying real crash logs - what
      coverage do you expect there? And should the design doc go in
      first so the series can reference it?

   Thanks,
   Hongling

