Received: from mail-pj1-f68.google.com (mail-pj1-f68.google.com [209.85.216.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48FED3C3C07
	for <linux-xfs@vger.kernel.org>; Sat, 13 Jun 2026 08:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781338413; cv=none; b=Y4QufC17cq8bGPMXbT80vyb1g/7IOMWO9eq4xno+qbYZ5+tvL6udL5B9JxzNG9YZxZDjm2qDOXAi/at3eVi5BSR1H0aNFZ8Xo0Gexqta+btYDmFRYDSQiWBV6wmuskyBSRBmJelaAqRniFsFT37LxZMs5vs9xFdTgbc+UWfvdU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781338413; c=relaxed/simple;
	bh=joUaGFct2DoPnYiVYvdUR5Zha0jVgohYXldhAfMVt4w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iOmMa7CxAdUOnKjUAlZqM4JXVkg6kVTnQm1+zkO6YtGbWtirkv1yAa8jM5FCXFdLrvh+6FD8/ZWvc6IZ9NNkM8k5Fue9Hp07Iyb3JLuJkbsgERYVeCfhZ3kopgY3Ke13wLSfh2HGuxpeuExpvII3TEsw+T+LFtrt9lUT6xUm73Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S99l+Gil; arc=none smtp.client-ip=209.85.216.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S99l+Gil"
Received: by mail-pj1-f68.google.com with SMTP id 98e67ed59e1d1-36b95eb4bb4so1127873a91.3
        for <linux-xfs@vger.kernel.org>; Sat, 13 Jun 2026 01:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781338412; x=1781943212; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=joUaGFct2DoPnYiVYvdUR5Zha0jVgohYXldhAfMVt4w=;
        b=S99l+GiloRyCH4oFwREU+ODvJl2uwkZiBo5OdT/FzcjQ7okLpxBj2eXWvIoSjiBp2S
         Xeo1JuIuQCf+SFEIAnqjWFf6P9HzsnOdq6T01+q1Png09EHShUoBCgMpRrsom+xd+c2W
         Z7CM7xMzlg+tBHZxp7Jlzf8XXqBUuHn/KMBNwiTaI1CkuNXCX4YmuBCQ3wMtG8SxOvMu
         NN6eyGed8i/sPgPb4O57dVkc/x11xMl/g6GaTdW5TYrh9r2MCcrSISZSSeaN5kYSqOYW
         M49RLb4nu0Mr8O7Q25gwFHh2MzJHQEFF0MyBxN5rEcqA38CEqnDyIn0kJWQKWWP9rRoP
         U+mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781338412; x=1781943212;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=joUaGFct2DoPnYiVYvdUR5Zha0jVgohYXldhAfMVt4w=;
        b=hvihAdOXbvy9z6f3HjXRrEvJeEtoH0Cvmy2FYf1pXtwnyQi+ViTYcQf43oakGf2jYm
         7tUD1h8YxVf4bRIyvfTI7uKAaCasxONS7bXvRSOQ+UyuO9kBDZvT2q+Fy7F/ElIWM45I
         ZR4e0KXs0dDp1txivpwjdgPGDfLuf9vU0IRNG4tYX3m92K3z5UWw1NJwIA4NDme0Y9Do
         yMZ0YnwpTE115OVgWO2S4Y6Zj+RcqVqVdaMNXGY3WjeA1td5zPCxVyLfSZAyb0gTuB/a
         kcq8v+R6/35G2vIt0+Ud1bWSa5bR+5fdO0pAJcxb4Ua7+iM3As777o1ZEt1gsHb6UG8p
         SfqA==
X-Forwarded-Encrypted: i=1; AFNElJ90povO9EDCj0VXiI6rKZ9inA09xUTvDCQXqXA+AELNOIxVAoVsDqib2edGcnSWVd1EKJKJhkTDYLU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxab8IYRHYCf0UmVtPbKX1k0HI6GJA/Qt8QtM+M0CNl6Loj+3SX
	bAxNJRvPsyw0X3GNd/uo5wDr0apJiNsWyUpcr5nBGbMvy1VTc0oLMYzC
X-Gm-Gg: Acq92OGSQco0oJQyekeIYmUjVV96hKsVUIFYhX/ygrYCMkhZVeiv11TaN6YAKLi3N5I
	6bb3QphIBLZGXNIJdGESNcqb9Oqhue5qXobT7bBzHWvkf96BnVsQof31Gf/jlXxNVg5zdFkHBeE
	MK4F31zoQewg007hY2kvUfyXXWVYcWhuRMYjCW7nrB0kgwRtdvfWOdfxs88f/4k8881GVndGCZm
	VNTtm/338QnZ8hfAox5C77bEYR6qtPrsOXAodCMDSwoR8SorRGAryTKh6rnjbK5OXhTq3R73Ixr
	sZ7X2hWbPGvjdPX3qeML6qGwL6DZD46cbcJjJa8dQNUlQZb/cV8eoOnTkFBMapjCdDOrNtxY/uD
	+xYUATmbAVKwgN+ewc292RA8WH+te414901NbLkls7x/3U8fv7aTjqy8tGyWSllRUTTBaM5t3mP
	YYi3mSOShroalFwvjm/mDx
X-Received: by 2002:a17:90b:3885:b0:36b:bb66:fbd0 with SMTP id 98e67ed59e1d1-37a01a3bcc3mr6292806a91.4.1781338411517;
        Sat, 13 Jun 2026 01:13:31 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c866519faabsm3985393a12.24.2026.06.13.01.13.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 01:13:30 -0700 (PDT)
From: Zhang Cen <rollkingzzc@gmail.com>
To: Mikhail Lobanov <m.lobanov@rosa.ru>
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>,
	Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Zhang Cen <rollkingzzc@gmail.com>
Subject: Re: [PATCH v5 2/2] xfs: shut down the filesystem on a failed mount
Date: Sat, 13 Jun 2026 16:13:22 +0800
Message-Id: <20260613081322.895929-1-rollkingzzc@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260610191904.12533-2-m.lobanov@rosa.ru>
References: <20260610191904.12533-1-m.lobanov@rosa.ru> <20260610191904.12533-2-m.lobanov@rosa.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Mikhail and Christoph,

Sorry for the delayed follow-up. I was tied up with other work recently and
did not get a chance to continue following up on this issue.

This series appears to address the same mount-failure inodegc/quota teardown
race that I reported earlier here:

https://lore.kernel.org/linux-xfs/20260528053554.3047829-1-rollkingzzc@gmail.com/

Could you please carry the following tags?

Reported-by: Zhang Cen <rollkingzzc@gmail.com>
Closes: https://lore.kernel.org/linux-xfs/20260528053554.3047829-1-rollkingzzc@gmail.com/

Thanks,
Zhang Cen
