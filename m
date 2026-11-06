Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793973973;
	b=soZFUsB05tKAyW8kcCloxNwdgQV3hNOO5U1WIZi66hBD6qUXTwZzghCESoTZ48e56Xoq
	 NNrcQkHerbVZXERgvzTdqW6KVi38uLxkBYhZu3enT08+Qz4pESt8oW6hyUL+eCLdg+skp
	 dQ+LSE84ukrCcXQ+SxVIP/j7bCtl8RqPD+txFP82j1Tip930V/7wuM7AaEnr0UoE1TDgU
	 o4j19kbmtdzGp5W8PsxmOU9lxyymZ4AIQJJv9XPyUTg2mfer9FzwQElI2TD2g1G+NnME9
	 cvmWDjaR1rz69HkJeOdHh2tHpJ6eS1bU5MsUtXOs88WwGpt/1W9v5x47szX5XT+pgZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793973973;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=eqhBVbUtw3dy734MGt0XscJMrayl/heBjdE55TwHpBE=;
	b=CtiflXPgnk6/gK4WBh/ZS73n6i4soJZnKYiVrxOAgHM4ng9LdnyQDuOvYfn6PM/x7GE0
	 Xvs1fYw9LCBgUiOQgGGIVHEhTkLU/0992xfSrYexlqTwPcQmHUJ12X2eYb09depoqIOYa
	 ptB69+5l7S0tD3Q/87aE254KGo7rGha/bEVaPqLXFtgpUiw9Z04bUty3vyNt8PxMLnSKd
	 tCa1j5i9iWR5x5DBaiYHR600bhnfLApcS9lBWyfCG7tWW03ms6gBPRJs0rbqr1xwM1xjg
	 AY7hQZeL1uj84PunAoWE7NvqKOjymDRvrBSe1B5QmnAx5SIHsiuPl/lxktraNBuRJMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmpxchg.org;
	spf=pass smtp.mailfrom=cmpxchg.org;
	arc=none smtp.remote-ip=209.85.128.181
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7091606A331
	for <linux-xfs@vger.kernel.org>; Fri,  6 Nov 2026 14:06:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E7091606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-8b309147589so5647027b3.1
        for <linux-xfs@vger.kernel.org>; Fri, 06 Nov 2026 06:06:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1793973967; x=1794578767; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eqhBVbUtw3dy734MGt0XscJMrayl/heBjdE55TwHpBE=;
        b=rEFjIsRctA59Iu2/BHBn1Bio1Z530ac+g4EEE4umpjlRFctJ/W1yi+oJAJdR8sIKtC
         0ANk4+IEeh+gWZdP8+5Abj0Wi+7JUGtI3eOPnJ0wMnngrGVtvT7+mdXKDwBc4VjMOreA
         HRXNX16MAj9gPw3V6sQG29RsCMeifuq7vktm82eZ1OL9M0wUFDM8b1mHYrWOWDjP7hoA
         FgchrqECOX93FzgDhG9Sn07L+FCR1PCSxN8pDG5a+ABli7EEuG5ifSugYUsuO9WbK3uX
         2labLzJdsWWlMl8/Ibz30wICnbSFS6Rx+DAJRAtH3OrhgDaH9x+c/HNq/PuJNNkUGIVa
         0UdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793973967; x=1794578767;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eqhBVbUtw3dy734MGt0XscJMrayl/heBjdE55TwHpBE=;
        b=MXkq3T0fqjCjm1pP09S5UATMUse+zO7rLPTJMKZWHWucxXSGWpIpAKSVPSa6WzWkq8
         sHnDv+cYqyTSwbKPhHOpye8ozvEI3i3eBkUvreTg2h08mcXw/Dzz0YKN1dLGKbrj2wm/
         xrrU6ke5zBj9v867eynMMw8KEDnP924DL43G4QeGu6RJT05Jn4Oings42A06qH35/Pdi
         RCsNGg48xEbnKPBOgLJVTmKxr0ZCNRF15kyGQokZh+OLSNZ/drNBi7AHj4CKNF+YNejr
         UQhNlpK3Xxrc1rkJzLdDexMp4zCnIFnNjNE80kfExyhRGoC8SzWwaNpm5GOz/hx6C4W+
         mdVA==
X-Forwarded-Encrypted: i=1; AL+hErGoyzkRuHenYFXdzXx9z88CR2ARX2RZi7oHRNu7VnT5DQfH/lTHoUR21Js4tP6RTfOS/BVBAnQ4wsE=@vger.kernel.org
X-Gm-Message-State: APuU4Z9ETw3Wl9nEA07EVTwm+TnSxX/L1TPgPt5N7Is9tNqoo4rUuAIv
	VaXMowi8l/QFqrvlm7jeOmAQueLA+WXwTj6FNRxAB72j0rYyb2eRnru8C35HlksM6Z0=
X-Gm-Gg: AYBFou1yVvYKMulH9sokgtorvbViCEp4T5t+8odDMFJhVLgVXHMKDUd+/PjHcGi5d21
	vcVi07ISi0KFd0ZtPBVIlNtQmJCKB4HkCbPB4JIIm/6IktB1nUP7nEkt9Av8gjpyxxhZEbpp4JC
	pj86vC4grm35ciOzMyfio8wj/6eZxaq0vrBen7vZWy1Zuz6UP/GmIne61q33owsSOd0EVVXe9Il
	gEGPbSBETQVemyShVEWdvxS+DhwsbQOJn/GmugnwZR5l+s5ZzHINDzDA52e7+4kDhbO5LzJO59M
	J8jvVwK4JIcQHu6ABW2Xf9ZHjoAFBuq91uNY517e9kD3NVJxT/XzIp9MZSR6uiT9UkWBwaK0/UI
	LKuarusEO/BrevqpyQVDHPJ+Toc88eauWDHM5AodVj3RJkewaeZ2fF+5yvAbTiSQCw4RwBVebSE
	aod4/SAx+w7ynPRlM9LLiZG14wVpI5UM7yLwXSi/KDeAbhy9kslvTzSExW3lczxMz1YxgqwR4AE
	dADPAo6VqxiaX2MKVi9OyyHn4hGOMTSRs26prM0YHA9Ej7tVXi4I9AYELnHJ7EQqioh1dhfKb7S
	1zy+vUKGQdtDykhuY5CYndil1R3w
X-Received: by 2002:a05:690c:560f:10b0:8b3:10df:54a3 with SMTP id 00721157ae682-8b341b1ebe2mr10611897b3.65.1793973966605;
        Fri, 06 Nov 2026 06:06:06 -0800 (PST)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b33f856f99sm19108527b3.34.2026.11.06.06.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 06:06:04 -0800 (PST)
Date: Fri, 6 Nov 2026 09:06:00 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Dave Chinner <dgc@kernel.org>
Cc: Kaitao Cheng <kaitao.cheng@linux.dev>, gregkh@linuxfoundation.org,
	arve@android.com, tkjos@android.com, brauner@kernel.org,
	cmllamas@google.com, aliceryhl@google.com, nat@pixelcluster.dev,
	arunpravin.paneerselvam@amd.com, maarten.lankhorst@linux.intel.com,
	mripard@kernel.org, tzimmermann@suse.de, airlied@gmail.com,
	simona@ffwll.ch, viro@zeniv.linux.org.uk, agruenba@redhat.com,
	trondmy@kernel.org, anna@kernel.org, cel@kernel.org,
	jlayton@kernel.org, cem@kernel.org, akpm@linux-foundation.org,
	david@fromorbit.com, david@kernel.org, hughd@google.com,
	yosry@kernel.org, nphamcs@gmail.com, matthew.auld@intel.com,
	matthew.brost@intel.com, thomas.hellstrom@linux.intel.com,
	jack@suse.cz, neil@brown.name, okorniev@redhat.com,
	Dai.Ngo@oracle.com, tom@talpey.com, qi.zheng@linux.dev,
	roman.gushchin@linux.dev, muchun.song@linux.dev, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, liam@infradead.org,
	nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
	kas@kernel.org, mhocko@kernel.org, shakeel.butt@linux.dev,
	ljs@kernel.org, kasong@tencent.com, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev,
	chengming.zhou@linux.dev, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
	gfs2@lists.linux.dev, linux-nfs@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH] mm/list_lru: Account node removals in isolation helpers
Message-ID: <au3eyCrHiuhbJx3u@cmpxchg.org>
References: <20261103045053.59548-1-kaitao.cheng@linux.dev>
 <aupITfr9pBKPrU20@dread>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aupITfr9pBKPrU20@dread>

On Wed, Nov 04, 2026 at 07:47:09AM +1100, Dave Chinner wrote:
> On Tue, Nov 03, 2026 at 12:50:53PM +0800, Kaitao Cheng wrote:
> > From: Kaitao Cheng <chengkaitao@kylinos.cn>
> > 
> > Successful writeback calls zswap_entry_free(), which removes the entry
> > from the LRU and decrements both the sublist and node item counts.
> > shrink_memcg_cb() then returns LRU_REMOVED_RETRY, causing the LRU walker
> > to decrement the node count again.
> > 
> > The affected call path before this change is:
> > 
> >   __list_lru_walk_one()
> >     shrink_memcg_cb()
> >       zswap_writeback_entry()
> >         zswap_entry_free()
> >           zswap_lru_del()
> >             list_lru_del()
> >               __list_lru_del()
> >                 atomic_long_dec()  /* first node count decrement */
> >       return LRU_REMOVED_RETRY
> >     atomic_long_dec()              /* second node count decrement */
> 
> That's a bug in the zswap code. You shouldn't be calling
> list_lru_del() from __list_lru_walk_one() context.

Grr, Kaitao you dropped the wrong thing that I thought had merit in my
proposal...

Dave, would you mind taking a look at my patch at
https://lore.kernel.org/all/auJkvb-Lq0M5Enkz@cmpxchg.org/?

Ignore zswap for a second. I know it has problems. Most of it stems
from the fact that we rely on the swap locking and do none of our own
locking/lifetime on the zswap entry. As a result we work around it in
odd ways. Sorry, you didn't ask :-) That's worth revisiting, although
it's likely more invasive work.

The observation that led to the patch above was a much simpler one:
since we now have the caller-locked __list_lru_del() anyway, the only
difference between that and the list_lru_isolate* is the
accounting. The patch is about one thing: removing the isolate helpers
entirely. There is then simply one tool for caller-locked list
unlinking, __list_lru_del(). It removes an avoidable distinction,
shrinks the API surface, makes it harder to screw up.

The zswap weirdness made me look at list_lru. Consider it a stress
test from idiotic code :-) But I would propose the list_lru
simplification for its own sake, regardless of what we do with zswap.
