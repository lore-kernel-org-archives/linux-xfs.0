Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F73A2931EE;
	Wed,  2 Sep 2026 20:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788381860; cv=none; b=OwzhKcRbAe8Y9sGQ0SVJOTKlOnRVGl8Y9vwAnsYvOPEWoZLJt7pDa5LSOhimz1/acO6AprrxwQdyscJUIe0EsVyaWdFz6g55zA8wArVhNxdSHdEIDj8tHe5gl950IYxecfwVJJ/sj5Yh1TBR3lXkpnKZpI2L82R2tw3zZd48NYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788381860; c=relaxed/simple;
	bh=7aNWSFpWuquVIQ13xCfToRy753eQj3g0I95rfUkqJSI=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=cqVM3gkYVam+ejbh0HEvIeaLvOxh1mevZy+8I6v97KfKjajkTO0DwF2EtcMxzeoeITOHm+S6CUfehbVu8z18F3oK3mR76YglgNTKXJ5dJ2dHTCmMm32SFNLjWvAErdesoXqcBNjs5J74VKHYNSJrB/+8rPs5F6m9/oRLi71dkv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cvI5z0qY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cvI5z0qY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65EE21F000E9;
	Wed,  2 Sep 2026 20:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788381858;
	bh=qSgNjnh8lLWVVyFB4dtxw8VS2iuPHbxG9BXo7PwVjDA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=cvI5z0qYp/y5i2UlogUYll7apXy3p57/EUpKyeTITSkQgBrLYX7c3WWxXE/Lnpy59
	 +v4U5EUm+IjdYvf64PC9UMTVhP7Eo+4901Q3h7qtFcfh0FkONuj1CId83cn8QFLmPz
	 eebBfhDqGJV+qCIplXL6PpB28HpCgBSFE5ikYP1c=
Date: Wed, 2 Sep 2026 13:44:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <brauner@kernel.org>, <djwong@kernel.org>, <cem@kernel.org>,
 <vbabka@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
 <brendan.jackman@linux.dev>, <hannes@cmpxchg.org>, <ziy@nvidia.com>,
 <david@kernel.org>, <qi.zheng@linux.dev>, <shakeel.butt@linux.dev>,
 <ljs@kernel.org>, <linux-xfs@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH 0/4] mm: replace PF_KCOMPACTD/PF_KSWAPD with
 kthread_func()
Message-Id: <20260902134417.c44503a1d65533f81fb1c391@linux-foundation.org>
In-Reply-To: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
References: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 2 Sep 2026 21:16:49 +0800 Kefeng Wang <wangkefeng.wang@huawei.com> wrote:

> The task_struct->flags field is a limited 32-bit resource. Two flag bits,
> PF_KCOMPACTD and PF_KSWAPD, are used to identify whether a kernel thread
> is kcompactd or kswapd. Converting these to use kthread_func() frees up
> two valuable flag bits for future use.

Well that was popular.

Sashiko might have found a problem in the existing XFS code:

	https://sashiko.dev/#/patchset/20260902131653.1338227-1-wangkefeng.wang@huawei.com


