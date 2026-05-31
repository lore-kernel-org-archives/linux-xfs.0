Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB9635B63F
	for <linux-xfs@vger.kernel.org>; Sun, 31 May 2026 23:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780270174; cv=none; b=Af0/cIbhytD60nBD8PvUv09pV+7KrZxFXNK7FE4qQ6jN7kttCe6L8sdVTjIwc8yktAvE9aFw3sm3QqZza9Gtjt1sLSTOwao+0YfORIlT66I4ec62vqjEyK8QzIduNJC7xLXHATKIxhAFx+f+gk7SlpT41mYtbR8G3rvII7B14Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780270174; c=relaxed/simple;
	bh=wpN2DMoqi9CmEHMcXbGGMbu29Axnf2IHOptAkTUYXbE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PWsfsFOhvTx9IO2gL752rwZFBGrMqwBmFSX3kWmzksg+okB8WzOy/NKdqTwHNgKDBHlXscP4znaR3Qr/KmUYSI6A/ejeztdRYpyz5rBAi5qyURBBcXhbxH+AFzzMyzspLmlp2ulclr7qrEkdy1qpqXnvlFk8h+6/AzaNzfejHEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F3MSwmDq; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F3MSwmDq"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-4600ddc4017so579533f8f.0
        for <linux-xfs@vger.kernel.org>; Sun, 31 May 2026 16:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780270171; x=1780874971; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hQRXdo9YxYwyrzUF+NcSdzn+gwHEuyRiq4J1P14JkS4=;
        b=F3MSwmDqrJ572O84JWel5Y10PTK+Qu0ZEj0/BHeMgVXume+YGx40fQGSAGCHlq4bP1
         xXHlPMuNgCSBBGMBgG842gSM4RQy/+zm8eX9D7uZgFMSuGLu+CsifFZsXdc0ZgObtkDr
         dJB9R6s1MEonwcK8o6snC/F99JU0hGe7BH9qZxSwv56N9ayEAWuG8VxyOo7rMW+KTmvM
         VKWr54ZVBKzIKoGetpO6+7hIHEf2Tsbq0mD+pDUOEKIcN9qrgQqKLaginOxNry7hle6a
         N/7dPS2Pgy3gdWeazu8wvWiC+3Q8W7d9qWAg3jAlVeUCAuX1UE4pqPjV31eWWw8sHtNR
         IGsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780270171; x=1780874971;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hQRXdo9YxYwyrzUF+NcSdzn+gwHEuyRiq4J1P14JkS4=;
        b=RoRlNLiEcBKqXWGlqHWW+MlRSTDBJmF4LplCOSSD8e86JsfrX29ylTxUrnFfRqZFuc
         Ac1gIthMsWaw1HoHcOFt+TAdjn2VTlqQUV4iPQr4G/Cu9QtdRuSdShKXKzim+97yr/q9
         yQ0zBXsCZUMX5+H2k8Iy5vYkoUyo+rQUvdJBLS/AGpIv5JX8qVk2ywciEAZIBcQVsIK7
         XpxBBPIA1EpoiaayYFPNn+IGQPSoO+8zTPHndxqILbiHORs2exaD3GedUEkEC0dVEmLq
         St+CXqQNs00g/SCwW7CnIvFGkfkNrH8RxVIY0AACXFbW2XvoSmYwlGCoGxdizUSH0q18
         EgMw==
X-Forwarded-Encrypted: i=1; AFNElJ+subpeOx+4X432XQit2Vi/9ymNZjIAvnCEZ9jrZ5KMKaQH9w+mTE2XwOgNCDjWXfy9TDdsvB1tSKg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTrPvfxz4zC3aPMSh6/zcU24ejIQVxU821Mbu5yaeFNgM4DRNf
	u7M6URty+t8odjF4O+Ebras1PmFekjuixCeKA0k7fu6bgUNtU6XgsNE1
X-Gm-Gg: Acq92OFSX+5Fjt+I1ZPsvTFXy0RY7Uh2hUkZadqRJBjWSPSuEj866AHou/FbhR0VWsY
	LXnv1RDW9JXPsWUSnhnBw3hd2Emg4PD/RTvnRdx6ZQMOqy1iE1Tix2k0VCdz5dW8A9KA9sjOHFx
	y+Fj9DwWF3Q1d93dAxvM+X4lqzk/deXQXSsiM0Qr1VfLxyCW2I8ixuBBtNIVZupQ3j5v+8FXYDv
	P2ADnIzK9TH7Pz0H3C3w5K2VtwalD/KprhnxieDngdoHOe388CtpV7DdUm3o56uZDFG5u8znGd4
	lPBawcuzRAObBPLTqP2eibb+XMuoNFsx84hH46O5MBmTu95MDQWfcNbM4K2AQEtqWBzWOhY8kjv
	iMbqqsyqZ1Ns+W6LRuZgO7VXUGGsWawaoz4xaC1vwGsePgatohieDZSjuGYLQBSX8gpIij17C5B
	Wxfc/oNwFLFC+AnDkpOYxxhX7iZf7xQaQ5X1wyDAvWqJ9OQej1CgR3G26dlUiEbcwOFBx/0qLA5
	6o=
X-Received: by 2002:adf:f14e:0:b0:43d:7d24:b510 with SMTP id ffacd0b85a97d-45ef6b5ae44mr11062126f8f.22.1780270171265;
        Sun, 31 May 2026 16:29:31 -0700 (PDT)
Received: from localhost (pat-125-253.wlan.net.ed.ac.uk. [192.41.125.253])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef354bb7asm20512971f8f.20.2026.05.31.16.29.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2026 16:29:30 -0700 (PDT)
Date: Mon, 1 Jun 2026 00:29:29 +0100
From: Karim Manaouil <kmanaouil.dev@gmail.com>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: abuehaze@amazon.com, akpm@linux-foundation.org, alisaidi@amazon.com,
	blakgeof@amazon.com, brauner@kernel.org,
	dipietro.salvatore@gmail.com, djwong@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org,
	ritesh.list@gmail.com, stable@vger.kernel.org, vbabka@suse.com,
	willy@infradead.org
Subject: Re: [PATCH 1/1] iomap: avoid compaction for costly folio order
 allocation
Message-ID: <20260531232929.mn6f76yrnc6e4cpf@wrangler>
References: <20260506123326.17293-1-dipiets@amazon.it>
 <20260527162412.19922-1-dipiets@amazon.it>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260527162412.19922-1-dipiets@amazon.it>

On Wed, May 27, 2026 at 04:24:10PM +0000, Salvatore Dipietro wrote:
> 
> Thanks Ritesh and Matthew for the continued feedback and guidance on this thread.
> I'd like to summarize where we stand and ask for your input on the best path forward.
> 
> Summary of approaches tested:
> We've now benchmarked all proposed variations (pgbench simple-update, 1024 clients, 
> 96-vCPU arm64, huge_pages=off, PREEMPT_NONE applied [1]):
> 
> | Patch                          | Change Location       | Avg TPS    | % vs Baseline |
> |--------------------------------|-----------------------|-----------:|:-------------:|
> | Baseline (no patch)            | —                     | 101,979.75 |       —       |
> | v1 (original, iomap caller)    | fs/iomap/buffered-io.c| 141,194.20 |    +38.45%    |
> | Ritesh's suggestion            | mm/filemap.c          | 139,200.61 |    +36.50%    |
> | Matthew's suggestion           | mm/filemap.c          | 143,863.82 |    +41.07%    |
> | kcompactd background           | mm/page_alloc.c       | 134,278.47 |    +31.67%    |
> 
> 
> All approaches recover significant throughput. The kcompactd approach (background 
> compaction and returning nopage for costly orders with __GFP_NORETRY) aligns with the
> architectural direction Dave and Christoph proposed, keeping compaction out of the direct 
> reclaim path, and lives entirely in the page allocator. 
> 
> Based on the discussion, I see two possible directions and would appreciate your guidance:
> 
> 1. Page allocator fix (mm/page_alloc.c): The kcompactd background approach addresses 
> Matthew's concern that filemap.c shouldn't know about PAGE_ALLOC_COSTLY_ORDER, and aligns 
> with Dave's vision of removing compaction from the direct reclaim path.
> 
> 2. filemap fix (mm/filemap.c): Both Ritesh's and Matthew's suggestions are minimal, 
> backportable, and preserve lightweight reclaim for non-costly orders. 
> Ritesh's variant differentiates between costly and non-costly orders, while Matthew's 
> is simpler and performs best.

I am not very familiar with THPs in the page cache, but for anonymous
memory, we have /sys/kernel/mm/transparent_hugepages/defrag which
decides what to do in the event of a THP allocation failure, whether to
enter a synchronous compaction or wake up kcompactd.

Check vma_thp_gfp_mask(). Maybe you should adopt something similar called
file_thp_gfp_mask().

The problem with fallback is that your application is never going to get
a THP and eventually TLB pressure might actually end up slowing you
down in the long run.

Also compaction is only really tried if it makes sense. That is if
enough free memory is available to actually perform the compaction and
have a chance of creating a large enough huge page. So compaction is
actually never performed under accute memory pressure. Which means your
system actually has enough free pages, but somehow the compaction is
slow and inefficient.

I am just trying to think loudly here and address the root cause. The
real problem here is fragmentation due to unmovable pages, probably in
your case the page tables. We should work more on reducing pageblock
type mixing. Also page tables can actually be made movable so that
compaction can treat them as movable pages.


> 
> Would either of these directions be acceptable for a v3, or would you prefer a different approach?
> 
> I'm happy to test any additional variations or direction to move this forward
> 
> Salvatore
> 
> 
> [1] https://lore.kernel.org/all/20260403191942.21410-1-dipiets@amazon.it/T/#m8baeeaf48aa7ae5342c8c2db8f4e1c27e03c1368
> 
> 
> 
> 
> AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico
> 
> 

-- 
~karim
