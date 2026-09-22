Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355195304DA;
	Tue, 22 Sep 2026 08:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790066686; cv=none; b=DNB/9dxXudCIzaEof7MyUQvec23AHgN9AG2DDHJFxlT0ZY+gdfWUn/EXbrAFQyyL9BtWcDgM2boDU6hxmwI6Ip5CGBvZg+TEeFnqXx4JRQ74zRBgrjje7lyeQqjtQ8er/Yz4vp8f/HYKzOk0sW11y6bOgB8u0Xmso1lj3RnufIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790066686; c=relaxed/simple;
	bh=DUSkfVYgfTiFqlSTR4nIte/BcODYaelUi+O3xWKYpuo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZGpP0CYoyTMDI7g53oqnRJCWjiNShzzPrT0bUmzRKWFkiMXBHK2+7mbdpktowOU4VnAjUhLlxZ4UHb+WRVFt2OGuxzVKtrXlP5LlbigA0tXR2SyQl9XqIZKjrhgqXIMGqtMEvQzTF7+gkB1qFFTK3L4VmeEEuAzSPL649MAWZEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PEd6vwyj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PEd6vwyj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41A91F000FF;
	Tue, 22 Sep 2026 08:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790066684;
	bh=L9gRbNdTUyxjBKhfXOwyDG8aLSnmaNHJRGWuT8eoOdQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PEd6vwyjKQxK5UZsdTxDL09OnRctY2OsBjqmyGXNYrnRjXQZGHf+hbwPe8JUBETIU
	 +AWWI+KsUl7zDmP70bRLe1XuN/SpnZ5nYrXoBcAi16Fzd844xZl3U4STpyBdeN3Vnp
	 2i+e6n/FFhXvKu7OGh5RYYyV6vU78J7IXUBe/ZWQgNohK116msVaraZdhVheM9HroE
	 79raJmEA+RmtQa6Hsirv8NZJFFMDuKjzI1sXLNBJuObT2KB9iBsZsbI+zIMfvGRqCW
	 mcbwRB2eiG7y5MPU+hxjWTgRqGyAKpJ16wYvt9KNLrwk9RWhVEU5X/W+TvfrZzwQNk
	 0shQ3gMxQOfkw==
Message-ID: <c6e2c1e1-a285-406e-a2b6-c09e05df91d8@kernel.org>
Date: Tue, 22 Sep 2026 10:44:37 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Matt Fleming
 <matt@readmodwrite.com>, Salvatore Dipietro <dipiets@amazon.it>,
 abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com,
 brauner@kernel.org, brendan.jackman@linux.dev, david@redhat.com,
 dgc@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org,
 hch@infradead.org, hch@lst.de, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
 mhocko@suse.com, ritesh.list@gmail.com, rvvandan@amazon.com,
 stable@vger.kernel.org, surenb@google.com, willy@infradead.org,
 ziy@nvidia.com
References: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
 <20260910114602.926944-1-dipiets@amazon.it> <aqQlUr-1h07G8JWM@cmpxchg.org>
 <8d6a8a63-4adc-458a-b548-a47bf5ff8eb7@kernel.org>
 <aqq8pWI0u1IZNWHT@cmpxchg.org>
 <9f415dc7-adad-4161-b20d-7c3173f50ff3@kernel.org>
 <20260918142813.6ea628dfcc32baf57ba70220@linux-foundation.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <20260918142813.6ea628dfcc32baf57ba70220@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/18/26 11:28 PM, Andrew Morton wrote:
> On Fri, 18 Sep 2026 09:05:40 +0200 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:
> 
>>>> Unless I'm mistaken about that MIGRATE_HIGHATOMIC part, it seems all sashiko
>>>> concerns can be dismissed and then indeed v4 is the better version.
>>>
>>> It looks like a real issue to me, but one that already exists
>>> independent of Salvatore's change.
>>
>> But Salvatore's change (v4, not v5 IIUC) will make it worse because
>> __GFP_DIRECT_RECLAIM + __GFP_NORETRY costly order opportunistic attempts
>> with fallback will start eating the highatomic reserves too?
>>
>> In that case the fix for this should probably be part of the same PR to
>> Linus and be also stable with Fixes: 281dd25c1a01
> 
> Oh.  I thought this was settled.
> 
> I've removed "mm/page_alloc: avoid direct compaction for costly
> __GFP_NORETRY allocations" v4 from mm-hotfixes-stable and re-added it
> to mm-hotfixes-unstable and I'll await developments.

Since it's fixing a bug from 6.6 it would actually IMHO be better to
target 7.4 and not treat it as an urgent 7.3 fix.
