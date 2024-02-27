Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5464DF4EB
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 05:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709010411; cv=none; b=cleXELKyscT+KnY6poNfIAQ/+SOoIlTdtddaP36DcFfU8/PRN5p7OCOI4njsSL7+UMdwujNiS3O32QosnolcoI+DDijE39Su9dEK74aX+0Nj7Syizp3ZzVmpgumyykO47QcDkBXH2DrjnXRfYuApcNhRL9U0tOsgBeK74bBnYRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709010411; c=relaxed/simple;
	bh=AH0jqZ1dQINk8NwdH3KNFenJyXPuxSNfH5LBZelhK6Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dsnQaXNRNmoEMLycgl0PAVDY8EwRM2IDjfnax2UuS0LJu6Dd8dsM5vWMIQFPR08rEKVh+Eh9I+V3CNg/NdfFBdpwGkP1OcKNkTKUQewjAaI6UG+cICyyAmWqCFtIo/H8zpLJCGQpOuSVrBYjGBSkK4cItrjil8s2aLkbW8Bv7Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T0Q1vJ1T; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T0Q1vJ1T"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-5cedfc32250so3632561a12.0
        for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2024 21:06:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709010409; x=1709615209; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/zEt4TNdrppFebRd2JNeFWomSsjCJ1r3bM2Cd8rmtxI=;
        b=T0Q1vJ1TR4YOheaih8Gg5x5PRkt4zASEmN9/LW8vCATkh3B9hS4BjvJNoYoE7UUyTR
         KIGhvLP4KGh1ynv0J8FOPOZ37NpO/LaRqSRedIpAgQKFKTh6zNGtElpbLwQnEvQ0CtC9
         HaUwdAuo3MT1UCFtAGIosTbWvK75KiniF4yPCvLNG0TylCvIopr801W3L98awvc14JeS
         7F83+AemUiq/2nyK/KlUHfosmUXqP90Ne+rNY9PuHPI+lmRloHuEGQdTG7+jQnHquTiI
         8AAELlEtNaUJQeRhyVwALvSiHFTO6LroDPJwglXI7mHieVhPm/zemmeg/TYvYkBD+70N
         ePiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709010409; x=1709615209;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/zEt4TNdrppFebRd2JNeFWomSsjCJ1r3bM2Cd8rmtxI=;
        b=o3eaY5v6gwPYc6TRI6UHwOLR59Ws9bG2f56hoQpwSS/xoJtum9eTP8C4rZhuAzLP4G
         Xm/+blSGlJkFjgPo40t9VzjHHJ2sa16DaMR3yG9op4BleakV5uPFHiq6QWxCS6vLvvYC
         xdl7VzsZNf50yJyBmQi+PoJobivDyRrLdWo7/XzZdnj0b4kkfAvRJK2UXsiJupSxx8d9
         N0A95X4LIgCqght2ggv3KFXh1vhsOsLdcU4JRSGr0yFOVRNLm9ZQLxnD3gEHewA9CbkR
         RwuLIV1N3ycfsO4Yn4VacL1rxBCxCTzqnfwZCzymhZ3c6eHQclEGrZ7GkP1Sg34dwmHq
         T6rg==
X-Forwarded-Encrypted: i=1; AJvYcCVGmOzxXPoieQKdw1SkqGFSPUm1zEBREloqAV+i8kQEnsgRWkxL1fYcRjYMlh9OU7W/D8pUC0vKj84jcY5mgp5xLIDD69EVngWr
X-Gm-Message-State: AOJu0YyW5sDe+Kdnx+CjCgDEQPt+gMi5OuxpdSD0LWOOCO1OyY2ESKhC
	bYJWayjV4z5pk+fH1Ct0MVH3P4yK5QpNMMJRurR3qHgCaPDUZFql
X-Google-Smtp-Source: AGHT+IHAr+Q2pzLwIL1qx1OmUJ/dZMF7sLuyoYAQDHCR7KDHFO8kb2mar/yQYfH+Vo7ver/bBJ6TaA==
X-Received: by 2002:a05:6a20:d704:b0:1a0:e468:f954 with SMTP id iz4-20020a056a20d70400b001a0e468f954mr1468396pzb.4.1709010409568;
        Mon, 26 Feb 2024 21:06:49 -0800 (PST)
Received: from [10.0.2.15] (KD106167171201.ppp-bb.dion.ne.jp. [106.167.171.201])
        by smtp.gmail.com with ESMTPSA id kx5-20020a17090b228500b0029a7a2fbb25sm5470691pjb.57.2024.02.26.21.06.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Feb 2024 21:06:49 -0800 (PST)
Message-ID: <73224e1a-b9b6-43dd-a142-6b9521fea147@gmail.com>
Date: Tue, 27 Feb 2024 14:06:48 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH 2/2] mm/shmem.c: Use new form of *@param in kernel-doc
Content-Language: en-US
To: Chandan Babu R <chandan.babu@oracle.com>, Christoph Hellwig <hch@lst.de>
Cc: Jonathan Corbet <corbet@lwn.net>,
 Mauro Carvalho Chehab <mchehab@kernel.org>,
 Stephen Rothwell <sfr@canb.auug.org.au>,
 Andrew Morton <akpm@linux-foundation.org>, linux-xfs@vger.kernel.org,
 linux-mm@kvack.org, Akira Yokosawa <akiyks@gmail.com>
References: <fa7249e6-0656-4daa-985d-28d350a452ac@gmail.com>
From: Akira Yokosawa <akiyks@gmail.com>
In-Reply-To: <fa7249e6-0656-4daa-985d-28d350a452ac@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Use the form of *@param which kernel-doc recognizes now.
This resolves the warnings from "make htmldocs" as reported in [1].

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Link: [1] https://lore.kernel.org/r/20240223153636.41358be5@canb.auug.org.au/
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Akira Yokosawa <akiyks@gmail.com>
---
 mm/shmem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index fb76da93d369..cf3689926418 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2152,8 +2152,8 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
  * There is no need to reserve space before calling folio_mark_dirty().
  *
  * When no folio is found, the behavior depends on @sgp:
- *  - for SGP_READ, *foliop is %NULL and 0 is returned
- *  - for SGP_NOALLOC, *foliop is %NULL and -ENOENT is returned
+ *  - for SGP_READ, *@foliop is %NULL and 0 is returned
+ *  - for SGP_NOALLOC, *@foliop is %NULL and -ENOENT is returned
  *  - for all other flags a new folio is allocated, inserted into the
  *    page cache and returned locked in @foliop.
  *
-- 
2.34.1


