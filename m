Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA74217557C
	for <linux-xfs@vger.kernel.org>; Mon, 25 Nov 2024 21:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732568629; cv=none; b=ji1RQ8FtBGKCTZ6M9ghjbEukkHfq0L2IP+xJBWpRCuvRYcyBBZBQdksXGq2U6jPy24WxFwvoBqmjpn1e8O+FbvMyIKigv4ZLxE8TKEkEE2aS+jAaW8nXSlltN90Me5hxs3aP/eU1GYDoagHxIHN/Dcj4QXKY3QuobgED0iyfdr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732568629; c=relaxed/simple;
	bh=kYbta3tAWAo4BkodZo4MGc86spv0VvTS6IS487XSYEs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qs+YHs7RMl34I+pUGR7ji1EhnVdmtM0m2utEcyWGs7vOd1cxysiBOPq7K8p6iiBTM5qTmfBT+c6KmXhALQcGWvfXHF8DMyogD+BdCzEIpXs4g/9m1Gz9Fx4qQzAzzTpiRKOoXPrBH70LdtKhnqYmT6J9tQUIZ6MnVaiEtqC7UfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=WhCXc3da; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="WhCXc3da"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-724f81cc659so1870686b3a.2
        for <linux-xfs@vger.kernel.org>; Mon, 25 Nov 2024 13:03:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1732568627; x=1733173427; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7OHTQ+7Sc+VjqzZ+g7+Qrd5AJo0mqddh6xd03j3GFtg=;
        b=WhCXc3da0ZnpZ5EG0+4F71eN5mXyGzHqZo6kiUyiUCuxfsxdGXbT/J2grWNuHS+8A7
         yVbv4fr93pBz1/Y837JCbkNFhCoBEPBSqg+9RDi8Yh4cNFrIpwLhDGl8QtXgMtbi2DLY
         35e/bEKITRjQ1UQyekTZ087W8jvpd9MjwPCmG5ku2m1lVoY4fptLr6Y+VjiVele7uQWG
         BYq66oU9JD2/hwuc/Bb5Ds57UG3cgOz7ZSTURoXjfNrMBCjn0X4Y81VEn/8hjL4FPOnd
         pVrURK3O4D3Vs4WKaxbl9GSYFN0wl1yEdFtTuA0yKqAN7bi4vl4pAoZyE3vTN1+mKQ2D
         p0Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732568627; x=1733173427;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7OHTQ+7Sc+VjqzZ+g7+Qrd5AJo0mqddh6xd03j3GFtg=;
        b=moKHWv/XAL3EmzVO2kjLe6KT68rWr8o7S550n9UhdVIp88a/eKVZr3OB4VXnXr5Oh5
         uAa3f3lGSVz8xMmSQ3JEnMp5N9u0yqG4WUmFHCjVfPyRaWoOAheNEjwXpngVkEYltK/p
         bxS9cH4H7Kl5Gyzq+XAXaPKvMVqPiLnqxzGu7qrFJYc7G9Gvpg0rZxXWlzkZD7IPgSfg
         jDGlS5bgGRmk6rrDfGaIeQGBX6xHtDl9xQtXFdz0eVwE+PY0LEtHMbTBOBqoB3VRglYz
         esLC/KXK8kqOC5A3/3ROvNV/HcYdKksVkarW5OY5iFdtKbcHlpD/WRglMqz3uBCXoeOr
         vnAw==
X-Forwarded-Encrypted: i=1; AJvYcCVwdAr4qrbglIr6GfFyTvNOHRULMrVyTadAoybxtLPBlpM0vYIiOgnjB+Kd7ln4e+PSqzWxWQzsvXM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKAm+6ImD4jibVtuzccMCvdhgJy09zexnGRSI/YXoEICfNq4yB
	TmanPh+K4R+uYlsySk40N4AoEyHjO44gWSn2zwhm0Yy3+LWDWQnnzwZh5BZGc00=
X-Gm-Gg: ASbGnctbqu11ipkbZmHfmSD39TrqGbtZqQcXewavmBY9ukrbE6Pf6+colOC6UITyFDf
	KVX6eXb2Wyorf7a5Bw+Q9/CY32BR9yCq9jFrrtRYMxB5MWOsMIz3yGZQeTOBQTnvmX+U44oesdt
	LLilOjvn0B2JL46pt1wZxNqOCuIzbK8b5Vh7pgSYEUEX7Ezzgk8U2ojyfINmcYnaq2mRJrt0ZZQ
	eqckZ6F+lMq9MGyb7lnb7k1ucY3v+CqGc139p+PWxlNXHs8FqGYSa4OFW1sfbgtCj9U+VsTWQPH
	K7Vvr8RAx47cVDimtWVBNVzsbw==
X-Google-Smtp-Source: AGHT+IG2DpWE9r0w8j2QI7Rgw6UoL4E7CdySBNGfh1WAKJMyUU5VlOZOJQ9FOmaYeHgak1pS7K2NYA==
X-Received: by 2002:a05:6a00:10c8:b0:71e:21:d2d8 with SMTP id d2e1a72fcca58-724df5dd7f8mr16932771b3a.7.1732568626947;
        Mon, 25 Nov 2024 13:03:46 -0800 (PST)
Received: from dread.disaster.area (pa49-180-121-96.pa.nsw.optusnet.com.au. [49.180.121.96])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7fbcbfc068csm6149899a12.13.2024.11.25.13.03.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2024 13:03:46 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tFgFD-000000032KL-1Gu5;
	Tue, 26 Nov 2024 08:03:43 +1100
Date: Tue, 26 Nov 2024 08:03:43 +1100
From: Dave Chinner <david@fromorbit.com>
To: Long Li <leo.lilong@huawei.com>
Cc: djwong@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com,
	lonuxli.64@gmail.com
Subject: Re: [PATCH] xfs: fix race condition in inodegc list and cpumask
 handling
Message-ID: <Z0TmLzSmLr78T8Im@dread.disaster.area>
References: <20241125015258.2652325-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241125015258.2652325-1-leo.lilong@huawei.com>

On Mon, Nov 25, 2024 at 09:52:58AM +0800, Long Li wrote:
> There is a race condition between inodegc queue and inodegc worker where
> the cpumask bit may not be set when concurrent operations occur.

What problems does this cause? i.e. how do we identify systems
hitting this issue?

> 
> Current problematic sequence:
> 
>   CPU0                             CPU1
>   --------------------             ---------------------
>   xfs_inodegc_queue()              xfs_inodegc_worker()
>                                      llist_del_all(&gc->list)
>     llist_add(&ip->i_gclist, &gc->list)
>     cpumask_test_and_set_cpu()
>                                      cpumask_clear_cpu()
>                   < cpumask not set >
> 
> Fix this by moving llist_del_all() after cpumask_clear_cpu() to ensure
> proper ordering. This change ensures that when the worker thread clears
> the cpumask, any concurrent queue operations will either properly set
> the cpumask bit or have already emptied the list.
> 
> Also remove unnecessary smp_mb__{before/after}_atomic() barriers since
> the llist_* operations already provide required ordering semantics. it
> make the code cleaner.

IIRC, the barriers were for ordering the cpumask bitmap ops against
llist operations. There are calls elsewhere to for_each_cpu() that
then use llist_empty() checks (e.g xfs_inodegc_queue_all/wait_all),
so on relaxed architectures (like alpha) I think we have to ensure
the bitmask ops carried full ordering against the independent llist
ops themselves. i.e. llist_empty() just uses READ_ONCE, so it only
orders against other llist ops and won't guarantee any specific
ordering against against cpumask modifications.

I could be remembering incorrectly, but I think that was the
original reason for the barriers. Can you please confirm that the
cpumask iteration/llist_empty checks do not need these bitmask
barriers anymore? If that's ok, then the change looks fine.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
