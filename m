Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F251B1F3D56
	for <linux-xfs@vger.kernel.org>; Tue, 11 Aug 2026 17:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786467913; cv=none; b=QKFeCzJGsmBrUnTITpDxLIBhNeKuNIp4TMdjG5mv4KuNlcTlVPz+FFXzSwqBI48Q7mufeMhP+y4OsSM8lLVZ2S3v0RBF83fyHoeTsrxgveeNkjWfzNMoP9uPo0Iju8/7OvykwTDGxznzvtwBicw/0l6oLgeUCRveXyJWLGJ4Yu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786467913; c=relaxed/simple;
	bh=uwTSYi5tQEQ2p21ljVAOmBvJaYsBBgTsxSGbAdL3Nwo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DM629Acg7S33pt2c99wr85Zbtw1KUZqxwlE4GrNhdpCoAeAcqk7Sj6OA2GD6Ch9VYynphzrIFuqNlueMBOx99KPegH9ynytFqvNUnEWnZ5r+azJ77slC/YvVw2MTDHyDSy6KD6aMmiDNe1R23yAqjaGgUkWAiBmY4h/Y6KM7DPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZGCAE26u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZGCAE26u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B031F000E9;
	Tue, 11 Aug 2026 17:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786467911;
	bh=F5yiDQ4P+0/hTufpcr07MKVPiePHbp2ikNBMUZePcck=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZGCAE26uSuyeyJ79NxD77Z9hB3fTuM8/snZ4nfS0unrOu0XMwFMcULDoMlnm7ETux
	 MiKWXHSu74c7zIjf+BGYRANZJu7CwqJJg7LO/bKs0IwA3TRK+co0yKsRWxppo0S22e
	 IawAhHVBRlMcGRZJdezfl41/g+ez4G6VVFU9/tHMYw7ubSh4l8Bps5yfiBzjnysGJR
	 XiOSY6rFUgO814H5Wwm0RlIhzeIO/z9STmCQiWuzUF7fhFIF5PUuyMp5QhC8jA7onp
	 jA9ygiFyHX+s4Hw0sNqPNfSa1kPcoy1bmj1LoAQXeBqSyI/0liJQCLdg5vh+g9BrHs
	 fFH2/v6C6aiIw==
Message-ID: <deca0c4c-9f42-4e02-a218-a8005b53fbae@kernel.org>
Date: Tue, 11 Aug 2026 10:05:01 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] xfs: fix racy open zone caching
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: Wilfred Mallawa <wilfred.mallawa@wdc.com>,
 Hans Holmberg <hans.holmberg@wdc.com>,
 Andrey Albershteyn <aalbersh@kernel.org>, "Darrick J. Wong"
 <djwong@kernel.org>, linux-xfs@vger.kernel.org
References: <20260811164912.124416-1-hch@lst.de>
 <20260811164912.124416-3-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260811164912.124416-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/08/11 9:48, Christoph Hellwig wrote:
> When testing on very fast storage devices, I've observed writers using
> io_uring creating many open zones with just a few kiB written to it,
> which then don't get used.  I tracked this down to multiple io_uring
> helper threads finding a full zone in i_private, and then going on to
> select a one, with the final one winning the race and leaving it in
> i_private.
> 
> Fix this by dropping full zones from i_private as soon we find them,
> checking cached for a cached zoned when a single writes needs a new zone,
> and by keeping an existing cached zone in xfs_set_cached_zone when it
> still has space available, dropping the newly found/allocated one
> instead.  This uses i_flags_lock as a low-level spinlock for short
> hold times to avoid interactions with the ilock, which is used for
> completions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
