Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F6B227E83
	for <linux-xfs@vger.kernel.org>; Tue,  8 Jul 2025 09:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751968147; cv=none; b=Y1+gIzRhSqaAGquvINxkX4sYnuRaamw10G8253hJ+nmKBxwnJZYHQ3SJNd5czDV8zbeVJQRdeIr2gusLK4/8LXQoccFzcgq3E3vlN4K9u6jdnHm+/PIkhXMs9Cqs7unytTb1RclejNWCj6FFHdcN/N8g3+KSmTZQ+rXp0kzM4WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751968147; c=relaxed/simple;
	bh=Q79VbRW19HkBZKVuJvLaZo6VdvFJCvi4GmBiP0okT1M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lWv56fq35yJDI7kCOmB/hbu4jiUdbRFCNnzWk6ihXFySMgud7np+Osk9WF2gguFrH+w8R0VW9jlb/jJ0U6tUap5GiiBGOsYy+sPIL15IrAW3Tje219NTf/KP4cJwiXUoQlqBB3kLUJ9bvjmDhAtXrMQDkTbHxNUr6woGjIp1wZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 5689n2Cs013493;
	Tue, 8 Jul 2025 18:49:02 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.6] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 5689n2YS013485
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 8 Jul 2025 18:49:02 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <70e7df49-ebba-4121-ae8d-83e04fbe25ba@I-love.SAKURA.ne.jp>
Date: Tue, 8 Jul 2025 18:48:59 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in xfs_init_fs_context
To: Vlastimil Babka <vbabka@suse.cz>, Dave Chinner <david@fromorbit.com>
Cc: Zi Yan <ziy@nvidia.com>, Barry Song <baohua@kernel.org>,
        Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
        syzbot <syzbot+359a67b608de1ef72f65@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com,
        david@redhat.com, gourry@gourry.net, joshua.hahnjy@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        matthew.brost@intel.com, rakie.kim@sk.com,
        syzkaller-bugs@googlegroups.com, ying.huang@linux.alibaba.com,
        Harry Yoo <harry.yoo@oracle.com>, Michal Hocko <mhocko@suse.com>,
        Matthew Wilcox <willy@infradead.org>
References: <6861c281.a70a0220.3b7e22.0ab8.GAE@google.com>
 <DDD5FAAF-F698-4FC8-B49C-FD1D3B283A8E@nvidia.com>
 <1921ec99-7abb-42f1-a56b-d1f0f5bc1377@I-love.SAKURA.ne.jp>
 <630b4379-751a-4bf1-a249-f2e051ec77d6@suse.cz>
 <aGxF7NqHNK7Vtd1_@dread.disaster.area>
 <5397779c-9a89-4dd3-9937-208fefb58f78@suse.cz>
Content-Language: en-US
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <5397779c-9a89-4dd3-9937-208fefb58f78@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Anti-Virus-Server: fsav102.rs.sakura.ne.jp
X-Virus-Status: clean

On 2025/07/08 17:50, Vlastimil Babka wrote:
> On 7/8/25 00:10, Dave Chinner wrote:
>> On Wed, Jul 02, 2025 at 09:30:30AM +0200, Vlastimil Babka wrote:
>>> On 7/2/25 3:41 AM, Tetsuo Handa wrote:
>>>> By the way, why is xfs_init_fs_context() using __GFP_NOFAIL ?
>>>>
>>>> 	mp = kzalloc(sizeof(struct xfs_mount), GFP_KERNEL | __GFP_NOFAIL);
>>>> 	if (!mp)
>>>> 		return -ENOMEM;
>>>>
>>>> This looks an allocation attempt which can fail safely.
>>
>> It's irrelevant - it shouldn't fail regardless of __GFP_NOFAIL being
>> specified.
> 
> If you mean the "too small to fail" behavior then it's generally true,
> except in some corner cases like being an oom victim, in which case the
> allocation can fail - the userspace process is doomed anyway. But a (small)
> kernel allocation not handling NULL would still need __GFP_NOFAIL to prevent
> that corner case.

init_fs_context() is allowed to fail.

https://elixir.bootlin.com/linux/v6.16-rc4/source/fs/fs_context.c#L318
https://elixir.bootlin.com/linux/v6.16-rc4/source/fs/ext4/super.c#L1990

Therefore, I wonder why xfs does not want xfs_init_fs_context() to fail
with -ENOMEM.

