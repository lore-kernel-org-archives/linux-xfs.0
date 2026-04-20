Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5917330662
	for <linux-xfs@vger.kernel.org>; Mon, 20 Apr 2026 15:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776699550; cv=none; b=jDvw1FGZOoPSvrAn92DBiKsubVocCJTjVhylVn8FcTNdSBUXhAMpf6u/mJH08lr9C94VApEwvEcv9AYfZ2aXxTVo1yIUqyfMLlIsUkFOcLibD4SDgDIxYgCDCyvUSqbKhzD6SlTzISARf2fbg40R8XTENnw9RT0HP3HI6KaLkGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776699550; c=relaxed/simple;
	bh=OpjiveNUdBCMWkd0DjcgJEWsHSIOB5BTtPJrvtArM70=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EPKfnYRUQqyYEXXmnkyY38lT0iyMmwWDlo05OY91xvXgcjfDOx5bT5fUQ7Nj/4fKU7nQ8KQ+StjiG/nBHgmMyCq9hSpA4w3ME8sxn6GiWg559pJzzMY/akM+SeZDXCHwN97c8tQwJvYQROmkLrXBNtFi/JxTwZ4jPoe0Sa73g7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JzGYkbDi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JzGYkbDi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E3EC19425;
	Mon, 20 Apr 2026 15:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776699549;
	bh=OpjiveNUdBCMWkd0DjcgJEWsHSIOB5BTtPJrvtArM70=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JzGYkbDimT7MB5MhZLbW6jL+epKLbAAFkX2jUcp1rIg3UC/UCxxvNnY1Rl8ajCen8
	 PvMxkxN1Uw1SgJGronHP66514Jf6RniuwdXxjjkFu0+4rH+AJ6ziAJrNaTS58ljwsU
	 wQrvQlLWU1OcEykix5VaklqsUF5fL3bYB+QZa5kCvK0T0h7Lt0YvLo4zYzVQ+mQvq9
	 XAE9sKhpnTj2MzIsov94V0g+A9JWVyNAq1sID95hP4bM5zvIsEbgpdT/7PMyRmA0r/
	 8ipl+5/HVmj0Svv4xr/oxhvkxzSDfFA5vwqJJgMVkqL1YbJJZngN5XtL3Q0IBrtR/Y
	 FyCSqCe926LwA==
Message-ID: <17d88271-d362-4029-97e6-ae900d4e562c@kernel.org>
Date: Mon, 20 Apr 2026 17:39:06 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] xfs: expose the number of free zones in sysfs
To: Niklas Cassel <cassel@kernel.org>, Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Hans Holmberg <hans.holmberg@wdc.com>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, linux-xfs@vger.kernel.org
References: <20260420135011.624587-4-cassel@kernel.org>
 <20260420135011.624587-5-cassel@kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260420135011.624587-5-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/04/20 15:50, Niklas Cassel wrote:
> The number of free zones is currently available in /proc/<pid>/mountstats
> (which contains stats for all mounted zoned XFS filesystems), under
> "free zones:".
> 
> Add a sysfs attribute /sys/fs/xfs/<dev>/zoned/nr_free_zones for the same.
> This makes it trivial for monitoring software to read the value, for a
> specific filesystem, without any complex parsing.
> 
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Looks good to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
