Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB143BBFC7
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jun 2026 14:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782311078; cv=none; b=X3OMXlK15W+LzUGktLcFtbEsUY9Yeo/rI6H9J6SQoB+G1chuBtJRjG67ubQg7qdLUMteq3bv9kbTkMyqb8YCzqmmS8xwAiQ45y2YaSUoy0hlrcNQ/IdI7VWs2fHoVdPa+z4b+alASQ39vUQbsfKxS4v3luhjZS+xsQu4QEQ2J3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782311078; c=relaxed/simple;
	bh=+GvPHtbjBfoeFHgSA3GIQrRzol9K7XiFhRwqivJDapw=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References:
	 MIME-version:Content-type; b=As6JaAV8BkKc5fiP4NbJGyxrAfdRbpwU+1KFVqu/cS2veSpsuJGl9Sopq0QomewhHbl4GlxMonbN9g2Bv51dUuzzvGnHHpIGHTIgdI7Bun9c2028FHR0WOhZoKqMBgDKld0GxPUIy85IJxvnLcsdjjoJWpyRt3XKp5Q29yMwOew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AcMSf/jl; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AcMSf/jl"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2c7cfa17fedso8586305ad.3
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jun 2026 07:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782311076; x=1782915876; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bC7GeOhZGz0je76Vr4XAaqeVuPBssFAF57vnDxsL79M=;
        b=AcMSf/jlCJU2ILuSt+66WbpetxY2HadsHQVxaA/1YzNOwOVJf6n4RLaG1DmmcY6C7p
         TIlPgl5GFj2+dPxYJTMwPia9v9Oh8ViLz3dd8+7bhnGkU8x2iGj0nQxSfc+MsXKNj/AL
         x0mJtdLNhk4c2+6dcqg5wYXcNiPXJO1vZks1nY9wk5yS5gzhdt+gneIE3OI5jHv4Xeaq
         DiReOB/Y4FQHNP5xcG8OzvSCbTqCISOt70ReiblXb8Pac7claoinWoXJFNrsMshEt589
         fFCCiCHURgnayZiapliKnusbAgNylNCa7+XnbSDGBFbW3uneBo7Fbi/kvv4nOj1QPDJp
         fAXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782311076; x=1782915876;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bC7GeOhZGz0je76Vr4XAaqeVuPBssFAF57vnDxsL79M=;
        b=OveS1jsvm3hpK4myDSBMqGxsj7SIGiLIHn3sqHyq8P/mErBhUJpecSIMdEqI9h5IJx
         7o5Ac1Hbkb55eiDx54B24BaM6wshOUov2xwYF481jXHLkeR+XjkLkqQ868onaiGnVTmW
         kIDBsGV6iUX1C8Dap0Dz9BMyVyFTlSkyTU3XJTbeBWfO/BTDucL5c+Qx7A/wkE2exkaC
         W3RhYKRkzPtCD9Gy9uS1xjPoddn+L2rQF4zJMBtllVnLpdRUWCYoGPs65jcCdoiXUv4j
         V1sl14dXHH63QwW0Sdk1sqSyFp3Y0BWXOAijJuaWjwu91XKvYTRMLgVLmbxEJDkf53ai
         4wFw==
X-Forwarded-Encrypted: i=1; AHgh+Rom9nqExhNMtE2u6ZdwHGunYMBm2J5cZM4jRwMN9uZCN2J61awWTcymChmFQVyAEH4M0DgFrxI08sI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZtyBPMjiHbeJYYTFvR2WSNy1cjuO8nXmsKfgQTxff2R6I+quu
	2i/WGuubiKHZVb+x/w5iqoY+xglaPh/1Py1HRsGZqshrOmXCt1uWNNDa
X-Gm-Gg: AfdE7ckyAMQNHOdsiEuMzOt0XNdh+5VSsf9LjXQmsTev4UhQiTlhtZrIMm7fWbrpIEp
	ZfIKp6sE6jjYvKtK9Ux28c/4RrvdPGgtrg4gpNx0qzLBkB0U1fFinpeZaiWmV4aahg8LYreX1Bg
	0V4zJxr/7gyMQVyPxxRvM+5stKUJ2l1NlP3/3SUI5/+yyDCkWkLxqkb6AMvMdO5tM5QzbqAZI3L
	PJoQt6Sy1w/WSJlktuZ6C1A2XLKdG+kG0YtJaslJiM2n5er2TzuSno94lEiu8H94cKAPPlgkc5M
	EHFJ6zoSE4TOX2Z+gF8WNctV6mz8UFTI9LPVvsOx+yYBv+u734PDlBQmVfF+Obx8D7k5BYCRB1+
	IRN3LvCLnGkcZeHTzXzDetAxgXgwVme5l9Ua4m0Q7O/s5q0d1bC51CORpHSH+lSGTSt9fQOx0uS
	67gDlJ3xPl9I0Ceek=
X-Received: by 2002:a17:903:1d0:b0:2bf:3309:ecce with SMTP id d9443c01a7336-2c7e15804acmr39177245ad.28.1782311076310;
        Wed, 24 Jun 2026 07:24:36 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7439f86aesm135035155ad.49.2026.06.24.07.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 07:24:35 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Salvatore Dipietro <dipiets@amazon.it>, willy@infradead.org
Cc: dipiets@amazon.it, abuehaze@amazon.com, akpm@linux-foundation.org, alisaidi@amazon.com, blakgeof@amazon.com, brauner@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org, stable@vger.kernel.org, vbabka@suse.com, David Hildenbrand (Arm) <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH 1/1] iomap: avoid compaction for costly folio order allocation
In-Reply-To: <20260624080639.17100-1-dipiets@amazon.it>
Date: Wed, 24 Jun 2026 17:51:18 +0530
Message-ID: <o6h0w2m9.ritesh.list@gmail.com>
References: <20260527162412.19922-1-dipiets@amazon.it> <20260624080639.17100-1-dipiets@amazon.it>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Salvatore Dipietro <dipiets@amazon.it> writes:

> Hi Ritesh, Matthew,
>
> I wanted to kindly follow up on my summary from May 27th regarding the best path 
> forward for this patch.
>

Hi Salvatore,

Sorry about the delay. I did bring this topic up in one of our internal
ext4 community calls. And to share some context, MM community thinks we
need a better long term fix for this problem rather than patching call
sites and/or playing tricks like - 

diff --git a/mm/filemap.c b/mm/filemap.c
index 4e636647100c..f2343c26dd63 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2007,8 +2007,13 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 			gfp_t alloc_gfp = gfp;
 
 			err = -ENOMEM;
-			if (order > min_order)
-				alloc_gfp |= __GFP_NORETRY | __GFP_NOWARN;
+			if (order > min_order) {
+				alloc_gfp |= __GFP_NOWARN;
+				if (order > PAGE_ALLOC_COSTLY_ORDER)
+					alloc_gfp &= ~__GFP_DIRECT_RECLAIM;
+				else
+					alloc_gfp |= __GFP_NORETRY;
+			}

Unfortunately most of the folks might be missing free cycles
to work on this problem right now :( - Hence the delay in addressing
this..


However - I would like to bring this problem to other MM community
members as well who might have an interest in this space. Can we look
into the proposed solutions from Salvatore and suggest the next steps
please? 

Maybe if someone can share what is MM community looking  for here - I
guess that will be a good start. Looking into the table I think
Salvatore had also shared a diff for kicking kcompactd in the background
[2].

[2]: https://lore.kernel.org/all/20260506123326.17293-1-dipiets@amazon.it/

(Sorry I still have few other things on my plate before I start look
into this more actively. But let's hear from others, who have better
knowledge than me on this.)

> To recap, we benchmarked all proposed variations and shared the results:
>
> | Patch                          | Change Location        | Avg TPS    | % vs Baseline |
> |--------------------------------|------------------------|------------|:-------------:|
> | Baseline (no patch)            | —                      | 101,979.75 |       —       |
> | v1 (original, iomap caller)    | fs/iomap/buffered-io.c | 141,194.20 |    +38.45%    |
> | Ritesh's suggestion            | mm/filemap.c           | 139,200.61 |    +36.50%    |
> | Matthew's suggestion           | mm/filemap.c           | 143,863.82 |    +41.07%    |
> | kcompactd background           | mm/page_alloc.c        | 134,278.47 |    +31.67%    |
>


-ritesh

