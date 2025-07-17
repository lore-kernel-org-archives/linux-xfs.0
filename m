Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683FF29E0F8
	for <linux-xfs@vger.kernel.org>; Thu, 17 Jul 2025 12:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752753718; cv=none; b=AX8g1RA0QA3RwJ3k9yQBrVw4PT5llxYunNn0JNk1i2F9m2SlU9nAHMrigLwEFpL2Nl60KCLT1YUCx+bMWP8hcXotlFOmOiu+4JO3DebRqm+1WsXsVQNyFvdt1LnzPKUIY7KB+fUhN9vMjk8564z9zILuSEJAWy/SaV1F5ldCA1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752753718; c=relaxed/simple;
	bh=kjEyn7nEjF8oiVB6GgmGedSuLAr7HCIjBycrDFOZBKY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=kfJ+dtfjxSRkyU0/EeT8IAkDxvdLbV29iy56duvIbS/Kco0AmHWxnMru+DsKuw8NS0DBiXnSIkwcuWyVM2qVZzUi4dYlgE6T3xINODdkCLdGLBCykiBG/EjcKmd/JKqrlw3gn6cZf87vG/blrz6eEtWmm+o1Tnu8vuXfY2uSOIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=TE3pE2QA; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="TE3pE2QA"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3df210930f7so4230285ab.1
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jul 2025 05:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752753714; x=1753358514; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=61ZOPEc1Npv0N7lkKyvYLgeXrgu1p1u4u8vtKljsiog=;
        b=TE3pE2QA2m2IWyaG+26IMVsGhjGpHMAkaeR2/qnWvaWmeH12NrY2LW50qEjNmq/wyh
         gMGzK228z4MNv+KyT+qI6vJ6SQdsIYk9Q8sRSUgTCGx7H5aARx25LXlpiQ2RMxa30Gu+
         BMl+TSt+HN7RoASpOtFow7xXM0ucnphiI6hBQXpQdERPtJScj6FU2xApu02GvzlQ2khG
         D4a3S22aaRUpw85f51Ztqb46c81Wa9JuKClTW+f6Oc/a80OG57NdFZgjagqRKlhWsPdy
         8mvH51TIPdQaLO13iXGkJ/vXW+rxAAFpsHbGqiPBKuiBDnHK8Qo8cQj85bgU7vHGuuBw
         HXfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752753714; x=1753358514;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=61ZOPEc1Npv0N7lkKyvYLgeXrgu1p1u4u8vtKljsiog=;
        b=QgGBFgbNiC1zp4OXN+q9EyHbRP7Sj5ntDtpCRtY1zOhuWIZi/GwU9ecuZuVZmelPA0
         iszmNG5yowq2ZWdzEZiu9VgoH3FURpUyJfuFQ0lMMTED7i+AO16PbcOMlYSD7eCkx8N6
         THIPyFxoCoGF8dbtr3vOmvuEj0Ay6Uh07u+hDAzO4WJyFJL0C1DACEC+vc4Zt3oGoaXn
         fXTvOlidmSJMLtGbmxsj5xpbu56S6Skp7iFIQ8qStN0beKEDdK+y/4zzl7CdOVbewICO
         g+vZQNu4x1hXSloamMGyRE2IaL2ySm9xh04ztaUyt4AvVr7cFvXYfzVHRcyhwgwj4oFU
         Ht1g==
X-Forwarded-Encrypted: i=1; AJvYcCWw33LCTubQ1kINv3CyczFqrD4MN7MVi4ThrKj8w2fD70P/8roY8nIVNQwxA/SMMPLm/DfiST6Q/ZU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzfDPtr+CDfplkO33OnWxvv+qPSk7w5rBxEQxGPjnIjsPxd9Zb
	yDIRfvA0bjMDfAakjSxfcE9hTDOl6wQmMt4GVNbM5GNHZ5M3roAOrW6TYLJPMKKDOaY=
X-Gm-Gg: ASbGncv8GEO5/MeBpdk6elEbh9ekrE2oYfGNoAU+xg1+nHEQmsk4ln0noyCb80Ey0+u
	P+GZ55j8ZwTPrNLERnlUZ6ismhtdGIAD/vu0WE2j2osw9bAduRMVnYSk2aYAeTe32KSwWdw5UF0
	Piu2zGw26vfgkwxnHsl3SNxbCSf0R5QM+fXxeIgwmlegNqM1WB2K0kdRboI894FviFXMngWF3TV
	DgJnUu7WtvGt2Eo+t7zK9MPnhFOIkQf45j3erjTf74iFv6fUfXwC5wn+iJYE6JAtWtycvgTDeL4
	/omdzB2iudAy0CNH9r/EYCvq65I8JepsEWOaYsxs8xinnoNfTOQBJWGackSBk1JVKh9+i0hkFc0
	iMMYJLh/M3AixWw==
X-Google-Smtp-Source: AGHT+IGuqUVz1MlM22DWouaSIEqVc7JUz/swP0ZPOQK4pvQiO3B+o4V938h5qOKiQPbhSq72i+cb3A==
X-Received: by 2002:a05:6e02:4618:b0:3df:e7d:fda8 with SMTP id e9e14a558f8ab-3e28b718bcamr29664265ab.1.1752753712400;
        Thu, 17 Jul 2025 05:01:52 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e24611ce92sm49563745ab.6.2025.07.17.05.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jul 2025 05:01:51 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, 
 song@kernel.org, yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, 
 cem@kernel.org, John Garry <john.g.garry@oracle.com>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
 linux-raid@vger.kernel.org, linux-block@vger.kernel.org, 
 ojaswin@linux.ibm.com, martin.petersen@oracle.com, 
 akpm@linux-foundation.org, linux-xfs@vger.kernel.org, djwong@kernel.org, 
 dlemoal@kernel.org
In-Reply-To: <20250711105258.3135198-1-john.g.garry@oracle.com>
References: <20250711105258.3135198-1-john.g.garry@oracle.com>
Subject: Re: [PATCH v7 0/6] block/md/dm: set chunk_sectors from stacked dev
 stripe size
Message-Id: <175275371113.371765.7347642796595215334.b4-ty@kernel.dk>
Date: Thu, 17 Jul 2025 06:01:51 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Fri, 11 Jul 2025 10:52:52 +0000, John Garry wrote:
> This value in io_min is used to configure any atomic write limit for the
> stacked device. The idea is that the atomic write unit max is a
> power-of-2 factor of the stripe size, and the stripe size is available
> in io_min.
> 
> Using io_min causes issues, as:
> a. it may be mutated
> b. the check for io_min being set for determining if we are dealing with
> a striped device is hard to get right, as reported in [0].
> 
> [...]

Applied, thanks!

[1/6] ilog2: add max_pow_of_two_factor()
      commit: 6381061d82141909c382811978ccdd7566698bca
[2/6] block: sanitize chunk_sectors for atomic write limits
      commit: 1de67e8e28fc47d71ee06ffa0185da549b378ffb
[3/6] md/raid0: set chunk_sectors limit
      commit: 4b8beba60d324d259f5a1d1923aea2c205d17ebc
[4/6] md/raid10: set chunk_sectors limit
      commit: 7ef50c4c6a9c36fa3ea6f1681a80c0bf9a797345
[5/6] dm-stripe: limit chunk_sectors to the stripe size
      commit: 5fb9d4341b782a80eefa0dc1664d131ac3c8885d
[6/6] block: use chunk_sectors when evaluating stacked atomic write limits
      commit: 63d092d1c1b1f773232c67c87debe557aab5aca0

Best regards,
-- 
Jens Axboe



