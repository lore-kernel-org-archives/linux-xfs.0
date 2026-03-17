Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE0232AAA0;
	Tue, 17 Mar 2026 09:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773739273; cv=none; b=sEQiQGKyY9/csMcq/QdqHCPth6nYPB7z8/41WHWzQ1Mtvc0e/+jc9D50j4UgGi8ZkgdRsAyzxujreIzsN2Fqn5nPFKTbNqXCle08CoW/+kxr4i92fQmNiLR2qkzkx5+HXU39m9Lb8gGk8SK6TJwMn/T7DN5hWsXpM8mjTTs7ato=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773739273; c=relaxed/simple;
	bh=Nb+z3ERNb4mYPAq2w04pUMsia9eivhsePXExpNPqpUM=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=Us5A7t7eCdGSX4G1qFa3vC02izJa4XAvFgp1uKm6wIy/4tgoqW9sZkL+o60jmtMTN8G0+iU94y4R6a8PX1unsMFU/+M79iskj4OPa2j7Fs0haY/FwEG6BZlN56aTQ0umQLw0rYuXwAItBATN3LzEazyBWTbFRzy8N0i8RVwHVgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i9X4BeG7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i9X4BeG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99CC1C4CEF7;
	Tue, 17 Mar 2026 09:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773739273;
	bh=Nb+z3ERNb4mYPAq2w04pUMsia9eivhsePXExpNPqpUM=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=i9X4BeG7QM21TD20y696jUkaoliMwB0q+MPMMT5ynyvu5uGDczI20fqrVZbtqmE6X
	 /KLl0SyQf0BGfLKKR/X9R7/rTJZzenAjoXQZxBTfZAw8jkWtyQK0b8pQkOPHF+Pc0V
	 Fy6M+EQ53U5oYELoqLbNMfKhMqtPBRu/xfpV2dmjr5Mv69WjICprlWau08ueZuigkv
	 o5fQEBGXoIC/LwzsmaQHk8ss13KwaijqZrrZN9OmGMGShA7oD2f0kX3dPxuMkbivIm
	 DGkDNc4Ne3sJUY6lJWVFw4x47Gf1v/3UvXhD0ZfLX+8Wf08f9b4g5FBH4iofUmOhfR
	 hwWlmUUoz82vw==
Message-ID: <aab8aebb-9703-4b6d-8ac6-e4811e972898@kernel.org>
Date: Tue, 17 Mar 2026 10:21:08 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: Re: [PATCH v3] iomap: add allocation cache for iomap_dio
Content-Language: en-US
To: Christoph Hellwig <hch@infradead.org>,
 changfengnan <changfengnan@bytedance.com>
Cc: Dave Chinner <david@fromorbit.com>, Harry Yoo <harry.yoo@oracle.com>,
 Hao Li <hao.li@linux.dev>, guzebing <guzebing1612@gmail.com>,
 brauner@kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 guzebing@bytedance.com, syzbot@syzkaller.appspotmail.com, linux-mm@kvack.org
References: <20260115021108.1913695-1-guzebing1612@gmail.com>
 <aWh06YoiJrR3-J-X@dread.disaster.area>
 <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.e7ce3c98.9b89.4c0d.96b4.bddcc787e1ed@bytedance.com>
 <d2598f65-8666-43f4-a9c1-73bee678f8d7@kernel.org>
 <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.e7a4a183.1b5a.4776.80f3.36cd4d9bdb3b@bytedance.com>
 <abeb4474-8f3a-49c4-bb73-50f2a633d179@kernel.org>
 <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.b89f1572.8ddd.443e.a91a.9f6964f1a150@bytedance.com>
 <abkbE_zh79iCd5zs@infradead.org>
In-Reply-To: <abkbE_zh79iCd5zs@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 3/17/26 10:12, Christoph Hellwig wrote:
> On Tue, Mar 17, 2026 at 04:33:24PM +0800, changfengnan wrote:
>> > IO is not my area but getting from 1.19M to 1.20M doesn't look like it's
>> > worth the custom code? (possibly from 1.17M to 1.20M it also wasn't).
>> Yes, at least for now, there’s no need for a per-CPU.
>> It might be better to replace kmalloc with a new cache, but my tests so far
>> haven’t shown any performance improvements.  I’ll look into it further.
> 
> Does using a kmem_cache help?  That should generally be a nice win
> anyway due to keeping the objects together.

I think that's exactly what "It might be better to replace kmalloc with a
new cache" meant, and apparently with no improvements.
You might want to try create it with SLAB_NO_MERGE flag so it's really a
separate cache. Custom sheaf_capacity might also achieve that effect, but in
order to have deterministic results, the flag is a sure way.
