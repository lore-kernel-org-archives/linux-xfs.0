Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF768F6F
	for <linux-xfs@vger.kernel.org>; Sat, 18 Oct 2025 04:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760761040; cv=none; b=EVb03l0N278ZSStqcDm/Vv2ghH0uBdk4eDQiA9uzFllUwOp7+SPhow25A95KBARZarLvrkWHebe6CJKzVptCUruKpKaG3DIdQtWAPdYS0dTIquxUlr5g0ZlCX+glE3CAw3aI7opZMluSYAty/6khHmSi4yWGeMeXEMPtlypdIKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760761040; c=relaxed/simple;
	bh=edER6qjVjNY3GmT9vdncW32pqx794+3a87v9trVo6RA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qI/fGhXK43iek/wfq+AeSW9LD90Ml+ceYw/AiJW14fXeD6M0jMzWr+30pThHEq4E6lfWRY3bwBkR7TZzbd6t6Ph+q8z4BfTZ6/yvL42drcYb7qNejCPiR6WgEvXk2Ujuo1+f4eSJNR9icepFMl2DziykiEAiZszkSNJgKSPAE+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hDm3KumL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hDm3KumL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CF94C4CEF8;
	Sat, 18 Oct 2025 04:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760761040;
	bh=edER6qjVjNY3GmT9vdncW32pqx794+3a87v9trVo6RA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hDm3KumLYXKlAt2Idt6K6O85mhYosWna0BmhIUIYQ0F0oAjlguKiM7OFRvVUtunK8
	 vQBAWw1ChvLcR4DpC+VY0tQfNkl0a8Ok+f46A+h3wBke+3G59hkMHOqcybDyyFqUY7
	 whzHA/xoOA1fk4zYjB69Nq+DaKjhLkLg4B/IXG86dWv5FuqLoP5a+wFlpOR1a7SuJ/
	 pVP3G+3t2z2g5CZJDzuMCQTDDvb6b9+6XsaygwXMfk97jUcaIxgQUStGTS1cxVBWom
	 ncqWIUTcVRddbtmphcAICTJxn0PrFsxmWeIXWEYPsEw7rgGQdIWNQVZT6iArvuLlR5
	 CLlbOTYRkCpFg==
Message-ID: <677e4465-fa8d-4363-be07-523c4b6f7d2a@kernel.org>
Date: Sat, 18 Oct 2025 13:17:18 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] xfs: cache open zone in inode->i_private
To: Christoph Hellwig <hch@lst.de>, cem@kernel.org
Cc: hans.holmberg@wdc.com, linux-xfs@vger.kernel.org
References: <20251017035607.652393-1-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251017035607.652393-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/17/25 12:55, Christoph Hellwig wrote:
> The MRU cache for open zones is unfortunately still not ideal, as it can
> time out pretty easily when doing heavy I/O to hard disks using up most
> or all open zones.  One option would be to just increase the timeout,
> but while looking into that I realized we're just better off caching it
> indefinitely as there is no real downside to that once we don't hold a
> reference to the cache open zone.
> 
> So switch the open zone to RCU freeing, and then stash the last used
> open zone into inode->i_private.  This helps to significantly reduce
> fragmentation by keeping I/O localized to zones for workloads that
> write using many open files to HDD.
> 
> Fixes: 4e4d52075577 ("xfs: add the zoned space allocator")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
