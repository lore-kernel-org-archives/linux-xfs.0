Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7271C84A0;
	Wed, 26 Nov 2025 09:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764149453; cv=none; b=KKyD9gcfE3E+BgVS/iGLHFA2wGHLC9Tl90wpLYXugDE/cszghCbLMJ8Qi0ssfIkc6kqaY0FAHvZ7BnT0Bpj86wNRdwcWNz/qFJf+arfAcz8uS5qRnnasZBv+GkUe1fzN67k8MterONGWzTvVFf86fcBmOtXdt+U17DCMSClO3bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764149453; c=relaxed/simple;
	bh=rvAFQp/faQsWmqG5lWB+/qsMqMuI5z5YHmDfU6uEkF8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OQz0xZT7IPkQ7Xh3tXS37bA+x2+t/GybNkDoungCFcttSjpOB6Fd5kIKpJZ4diFELZDCwdS5TDcVcKjK7riwBXBzgrqC6J9EWv/3mDwkiMzXw08pjuYXHwbd0xIZLkgdVSv3qcLGApFIeMubSZFpllyINPlQnw+wIeemmCStuQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tfamtFo1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tfamtFo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F28C113D0;
	Wed, 26 Nov 2025 09:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764149452;
	bh=rvAFQp/faQsWmqG5lWB+/qsMqMuI5z5YHmDfU6uEkF8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tfamtFo1RaMpb1YTFVTdd+c4JdiuPUAKmY22K0Bh+XtC7jGR9e5K/FItW6P+de8Ca
	 2xrkw4O2ZmB39hfCmDLis+XMDtlSIKs9cGW8mk7RZLGTUy7GLCEL+7D5hrzbRamwaJ
	 T8+zsGzGW/+Sxg/LKtfoH6Mk5wSQcRfPYhLoo2KcxiLn3iPqZJ0apjkthqfGtVBW+y
	 UeY1uy/gVK+RcmZraH3A8sERKIi5Y7XKc4qj2I2yHfDGa17BbRWh/Z607juBkN8MZC
	 UivIL3OEC4ViCjB1l0qBIeKQUheEiGzY15J7HRY8FCx1iv2/aoIW3iOwpkZG3tDWJx
	 hbjU2ly4jHJsQ==
Message-ID: <7cec7231-33f7-44ec-b82e-f12fba15392f@kernel.org>
Date: Wed, 26 Nov 2025 18:26:39 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 2/5] dm: ignore discard return value
To: Wilfred Mallawa <wilfred.opensource@gmail.com>,
 Chaitanya Kulkarni <ckulkarnilinux@gmail.com>, axboe@kernel.dk,
 agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
 yukuai@fnnas.com, hch@lst.de, sagi@grimberg.me, kch@nvidia.com,
 jaegeuk@kernel.org, chao@kernel.org, cem@kernel.org
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, bpf@vger.kernel.org
References: <20251124025737.203571-1-ckulkarnilinux@gmail.com>
 <20251124025737.203571-3-ckulkarnilinux@gmail.com>
 <2f356d3564524c8c8b314ca759ec9cb07659d42a.camel@gmail.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <2f356d3564524c8c8b314ca759ec9cb07659d42a.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/26/25 8:41 AM, Wilfred Mallawa wrote:
> On Sun, 2025-11-23 at 18:57 -0800, Chaitanya Kulkarni wrote:
>> __blkdev_issue_discard() always returns 0, making all error checking
>> at call sites dead code.
>>
>> For dm-thin change issue_discard() return type to void, in
>> passdown_double_checking_shared_status() remove the r assignment from
>> return value of the issue_discard(), for end_discard() hardcod value
> 
> Hey Chaitanya,
> 
> Typo here s/hardcod/hardcode. Otherwise, with the split as other have
> suggested:

s/hardcod/hardcoded

> 
> 
> Reviewed-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
> 
> Regards,
> Wilfred
> 


-- 
Damien Le Moal
Western Digital Research
