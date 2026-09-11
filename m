Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B8E370D4D
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 00:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789084832; cv=none; b=Y3btvV3PUQWxBHfq+DEkF2UMBwQh+cEIDx9/NaUdFYwVkMB9WKHFYUAZkNUhmDUZsRh3d7QAkL/W3Y4we48RlaylluXgCed/GOl3DpbleXrU/DKdZi6aSsPri6bSbSP6s1dvC9d26V0Ll/3Ow2xJftY1gmJgiH1k0lqPV2aip3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789084832; c=relaxed/simple;
	bh=3KUR6t0AsaA9SjJf1itJV4UsWyIfNCivzbPZHr57FsY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TD4wAVEVlUP1xQuUwlJWHeHhLlYAAXYkQxb4gh36ACNKjiiju9lURev6puwwgYDhdEJsVsMAKErQl+QN32NRjwP6+UlxbtSEG58sergMRJ0YkFBd8MFOlJ9rW1ikzeBaeiDuVfoTsxeR28j67DOK/iRPLP19MsDxKHLRvFQYLmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iO/P/XDi; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iO/P/XDi"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-39b2ad862bdso403831a91.2
        for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 17:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789084831; x=1789689631; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3KUR6t0AsaA9SjJf1itJV4UsWyIfNCivzbPZHr57FsY=;
        b=iO/P/XDi6qxstUTQt/4dgRlxuRcfLpsIyXNExMyAjXtsGlOrfd6JYNtR9CXFq0pFnk
         Jgs9lEl8jJzmfI6mDnjRAuqGNwKIyxBf2MrtOoHqsCu2rBT9TWyunv8J57Zjj6EculoR
         20cxu7oDlbf4v64N7lOYBlEFKQV3jvAquqR7u61GiOWTJsubQSdWs2k/KfwOAa+XALRA
         qavZHk+QzCgOVKcjNm2JREtlD4eVw5YUdFeh/LThHW4nBVSrFYMM8QtSRLrHY3YcT26K
         XYNpKKplV6afHO0e8NHD01mIdLjaiMJ7wEvnkrnUUr+S8P6U+Xnh/FFg2qpRLiaJQwuU
         RCZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789084831; x=1789689631;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3KUR6t0AsaA9SjJf1itJV4UsWyIfNCivzbPZHr57FsY=;
        b=dq+FZDgF9WiWhIMj9S4w5Vki+OZp1QbixfM5GYzkb0huRHkbFWg3A85sgx18rDw+5e
         hU1EYr4RV9er/vF0WGPtS3CGcs8OMrcyaF15cOqi/ucPxZnQ2cmDoFDoYxXWCBd1edYE
         Jfs2TjAoOr/2eK2ooGuMWv2YEy0sw5+KlBlHw46IMXYr1hqgBDHeRjcSuBhIKc+1mN86
         o0tPB6YcH82rIhAkN3/RGE7o5gx2g9c80cn9uu0npViNFGZIpWhoyV+4KtAg56SBsRcZ
         gubelnY7IaFchFZwYYkzxKa6l+IqvHmo+d13VGp0xyGmGMGL0X8ZLNe/YlQh1S3gxKP9
         cZTg==
X-Forwarded-Encrypted: i=1; AKwUvByRsEwi6EIolUvcTy0DkwVQBdEsRhEp+sHmu96EIBsnIFfUbuKc/8AqNc4x3eOknAIQVOLRGXGaOl0=@vger.kernel.org
X-Gm-Message-State: AFuF++mvzNo5OriYHSFkn2mDWaXnWZsxIHkQKpJtMR5XoNGQ+hpSOsDm
	zUD61GdRUzLkUr/a0RE+hSkZXkGpWtLPnsca3gzcfr5EwgW1jOJA7fzs
X-Gm-Gg: AYBFou1rL9tcNiB/YJdx7BFH8KsoxBLinipmNyHIiJuRO/aj58CFNunctPPnXCmk159
	QnFm70JdmmN4CxKnN0EtanmmJ8kwan6Ox0BWsazs0P408WWO04eS2FqFFpUbCfOC06aSUBxAypQ
	k7cVr8+mILG50OErx6j4YtqfO3N9nVbDzXlH0V8UEjs5E9uFjKIL5Mku1jGgVEFXFiz2f/6JX+m
	M51KVEvwH3NSN5V4kArXxaHbxfgm7sBnmO9OMoIU0Na3Z3wTJFNRkZFCHPSxHnNCcKzENiaI8bi
	c4ULhjhkkTrL7jvw3iJvCXs0FZelh0Lw2bR8TEa1HItm30e8mbYIteyk54g6l7CnWkPeex9eO/q
	0QuiZNplT5mX0o2XTpVZ8EI9dxevww+fQlqnNWxXdxFAgD1KA8qniHP+4ij5u5Dg7u5J14h6xj6
	hwI7NeljYdERj1cHA50oESFtEWRwF8ExGs1Oxev9w3Fasdt+5/Jm8eR0CRoBfsaEyfBjIiZzwLY
	6yYOLDfTNu7eqekvnCZJAt47u0erXLIztoVTCogkM7GX4/kuPa2yQU=
X-Received: by 2002:a17:90b:5287:b0:398:9bd5:490d with SMTP id 98e67ed59e1d1-39d9c22e224mr2133451a91.20.1789084830361;
        Thu, 10 Sep 2026 17:00:30 -0700 (PDT)
Received: from lima-xfs.. (174-126-236-85.cpe.sparklight.net. [174.126.236.85])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d9d8cd962sm221097a91.2.2026.09.10.17.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 17:00:29 -0700 (PDT)
From: Eric Peterson <linuxinstalled@gmail.com>
To: Eric Sandeen <sandeen@sandeen.net>,
	linux-xfs@vger.kernel.org
Cc: Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <dgc@kernel.org>,
	linux-kernel@vger.kernel.org,
	eric.peterson@hpe.com,
	Eric Peterson <linuxinstalled@gmail.com>
Subject: Re: [PATCH] xfs: add per-mount read/write I/O completion counters
Date: Thu, 10 Sep 2026 18:00:02 -0600
Message-Id: <20260911000002.4089325-1-linuxinstalled@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <1c5bebcd-76f5-407f-b3af-a6170fff2497@sandeen.net>
References: <20260828033429.4070267-1-linuxinstalled@gmail.com> <1c5bebcd-76f5-407f-b3af-a6170fff2497@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Eric,

I have an application that sends IO through several different layers.
In my case:
Ethernet adapter -> NFS -> XFS -> Block device -> SSD

I already have visibility of qdepth/RT and IOPS at the ethernet
adapter, block dev, and SSD, but I'm missing information about what is
going on in the middle.

I wanted a "light touch" way of measuring what is going on in the middle
so that I could have hard data about the performance impact of my
changes.
As part of that "light touch", I wanted to avoid a method that would
artificially inflate metrics due to the increased load from
instrumentation.
In addition, my approach was to follow the existing code structure of
counters that were already present.

Regarding Dave's points about edge cases he illustrated, I am in
agreement with them on the technical basis.
If precision is decided to be more important than overhead, then this is
not the right course of action.
However, I disagree that the edge cases make this a "useless" way of
taking measurements.
As I shared, there are still several applications that would benefit
from this.

Regarding whether these counters get merged or not, I already have them
present in my kernel builds.
My personal needs are met.
I chose to submit a patch because I believed others could also find
benefit from them.
If the cost of the stat was cheap enough, and given the right
understanding of the caveats of this method, it was worth sharing.

-Other Eric
