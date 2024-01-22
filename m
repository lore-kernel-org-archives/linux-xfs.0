Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E703A4A35
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 04:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705899527; cv=none; b=rLe7fn/C/I4Vwj2o54RvC/IVmJcapG0YfsfZ0J38n5lPjmVTI+XnEHYbHJMG9CoRyJBIqBmjgBlJP63rLu+gVi7qhoKJqUTfGB4lZqhJy0juAFN/1GJ2PZgO11GbTE7yAnN/dX+M0TyqrSnq27w5uVaRF4cHxJ8bjlgY/GPOc/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705899527; c=relaxed/simple;
	bh=3vxU1LAV3k8d7wYW3oX+MlNrTLFNNGMEYpfgc7RFllk=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=rLl5oedX5cjatGLiJA2oljhHCIHd9Okwd7EYEZUn0M3Ep5HgoiLhqn7xxna9YTxAD+9aH/LT7ehIjjGauj99pMIEVIuqgzJGW2Dn009sqwnGkEyTD8EXNxkx6h+WPC8DrKgf4G3Zm6aK2ggfCnc91muJbVk4jPcM6dWoUOfOjC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org; spf=pass smtp.mailfrom=gentoo.org; arc=none smtp.client-ip=140.211.166.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
References: <20231215013657.1995699-1-sam@gentoo.org>
 <20231215013657.1995699-2-sam@gentoo.org> <ZYEwFUy6bFO3h7Lz@infradead.org>
 <87v88k1yeq.fsf@gentoo.org>
User-agent: mu4e 1.10.8; emacs 30.0.50
From: Sam James <sam@gentoo.org>
To: Sam James <sam@gentoo.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, Felix
 Janda <felix.janda@posteo.de>
Subject: Re: [PATCH v3 2/4] io: Assert we have a sensible off_t
Date: Mon, 22 Jan 2024 04:58:07 +0000
Organization: Gentoo
In-reply-to: <87v88k1yeq.fsf@gentoo.org>
Message-ID: <877ck2x8uc.fsf@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Sam James <sam@gentoo.org> writes:

> Christoph Hellwig <hch@infradead.org> writes:
>
>> On Fri, Dec 15, 2023 at 01:36:41AM +0000, Sam James wrote:
>>> +	/* We're only interested in supporting an off_t which can handle >=4GiB. */
>>
>> This adds a < 80 character line.  Also I find the wording a bit odd, the
>> point is that xfsprogs relies on (it or rather will with your entire
>> series), so maybe:
>>
>> 	/*
>> 	 * xfsprogs relies on the LFS interfaces with a 64-bit off_t to
>> 	 * actually support sensible file systems sizes.
>> 	 */
>>
>> And while I'm nitpicking, maybe a better place would be to move this to
>> libxfs as that's where we really care.  If you use the C99 static_assert
>> instead of the kernel BUILD_BUG_ON this can even move outside a function
>> and just into a header somewhere, say include/xfs,h.  Which actually
>> happens to have this assert in an awkware open coded way already:
>>
>> /*
>>  * make sure that any user of the xfs headers has a 64bit off_t type
>>  */
>> extern int xfs_assert_largefile[sizeof(off_t)-8];
>>
>> Enough of my stream of consciousness, sorry.  To summarize the findings:
>>
>>  - we don't really need this patch all
>>  - but cleaning up xfs_assert_largefile to just use static_assert would
>>    probably be nice to have anyway
>
> Thanks, I agree, but I think static_assert is C11 (and then it gets a
> nicer name in C23). If it's still fine for us, I can then use it.
>
> Does it change your thinking at all or should I send a v4 with it
> included?

ping. I don't mind doing a followup, but I'd love to get this in given
there's a bunch of other projects still to handle with this sort of
problem.

>
> Thanks,
> sam

