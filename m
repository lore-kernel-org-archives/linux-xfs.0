Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3C75FB9C
	for <linux-xfs@vger.kernel.org>; Thu,  2 May 2024 17:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714669517; cv=none; b=beq/WY4LYfLoX8HBA/JI7ndcfkAe6Jb6dVK7XRmOhjG/ht+POv1oqjBABVql9BukfZVKo3nzDwcYA5xtWbMFRQLTh5xzh+HopqwUBQfC3wV9IvqSsNFWmvmg7tRdlZLSexK6SLL3s9pkWTwdHpMoEahCFMT4mwMplZrlHSY5ZPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714669517; c=relaxed/simple;
	bh=inLpcop0Lb7aOfay9b8xok/bn6UOBqZfABOPjLwtFYc=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=N+lVy3yYTkVjSPHhsX/Tuk8Wt9ctMyMLuZSRvxRXU5awlz2F7egOaWymAevd9csPEPfuZAm9V36y2z3P4DCv4pf9aVRW5CN2+N0HMX4Og/uAUuqIueW9/rHmQsEqKO2yn8jlFJ2gVg8ABeBklK/IJpuQk+74oij0B70jrwxkfi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WFDpw0wG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WFDpw0wG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E1EC113CC;
	Thu,  2 May 2024 17:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714669517;
	bh=inLpcop0Lb7aOfay9b8xok/bn6UOBqZfABOPjLwtFYc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WFDpw0wGzwR2VzyTxf8IouXr1iaLkycTisV2RNEWinWNffyfpEm0tfTDM+L6LV6k0
	 g/x+WPa+/9xDp6HjAWnw5oRRk9+8VFGI0X7t43TrfnzTgK8CxdXOa2XLb6Z608kMrf
	 bgl3caiTv22Pk4IRcpnkJh9HQtTxh6mZKUPQR2MA=
Date: Thu, 2 May 2024 10:05:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-mm@kvack.org, linux-xfs@vger.kernel.org, hch@lst.de,
 osalvador@suse.de, elver@google.com, vbabka@suse.cz, andreyknvl@gmail.com
Subject: Re: [PATCH 0/3] mm: fix nested allocation context filtering
Message-Id: <20240502100514.cce09f1fab6914a56491debf@linux-foundation.org>
In-Reply-To: <20240430054604.4169568-1-david@fromorbit.com>
References: <20240430054604.4169568-1-david@fromorbit.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 30 Apr 2024 15:28:22 +1000 Dave Chinner <david@fromorbit.com> wrote:

> This patchset is the followup to the comment I made earlier today:
> 
> https://lore.kernel.org/linux-xfs/ZjAyIWUzDipofHFJ@dread.disaster.area/
> 
> Tl;dr: Memory allocations that are done inside the public memory
> allocation API need to obey the reclaim recursion constraints placed
> on the allocation by the original caller, including the "don't track
> recursion for this allocation" case defined by __GFP_NOLOCKDEP.

I resolved a number of conflicts here, mainly due to the addition
of GFP_NOLOCKDEP in stackdepot and page-owner.

https://lore.kernel.org/all/20240418141133.22950-1-ryabinin.a.a@gmail.com/T/#u
https://lkml.kernel.org/r/20240429082828.1615986-1-hch@lst.de

Please check the resulting code?
