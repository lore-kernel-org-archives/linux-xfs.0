Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66240238171
	for <linux-xfs@vger.kernel.org>; Fri, 17 Apr 2026 01:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776389066; cv=none; b=SNBvnhsFtDOjwPQoG7AI1bzCJ8/hwadYXAGTeQ7fiTMee77p9O32X/dgPIDumZ0sNr/TuiXJlLq86PNzlLZSxNSKHxi39RWNf1IdP0zIQhDntCE06x+6BfWjqZQRrhB13rM20VEZhi2pU1nelfGjVTnlt+6y48d8/BOvvHNc3Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776389066; c=relaxed/simple;
	bh=Tw/UOvoceKE5QujmyaO+aYDZQJfXIPjW1vWdAuK5CJY=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=QH7GQxZ9vt+V38fZ/u1L9vvt9yBI2IqRhoyDRe9Uy2xurneNGeMMy8BRNyYcIvGUYxsWpkXeNrdetiikN5cti5JazN2kM3C3C4AY+GXVcTKdP61rY9kiGxTEFXhc3zpV3F24UY3OBRrHfeZ/83AEfbvb2wxXMsdiNZzxGMw/fzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=r4ZKHWdD; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r4ZKHWdD"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-358e3cc5e7eso93629a91.0
        for <linux-xfs@vger.kernel.org>; Thu, 16 Apr 2026 18:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776389065; x=1776993865; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cpOJeXbfkQGfp2oJxb2u3PSnQNyOEp2e2c25qGS5Duw=;
        b=r4ZKHWdDGZarPAient8RdIqeZHFIyyeLztwzfm9mgWYxQanoy7gvEscGAUfkCXJaLM
         KBzM/2oySD+RYhjpNkpzg0bRDOWF0LRsL1d4OnsD98L1kZErgEeex5HOluoXemHZ3FSg
         0CTzISE8DOvbJeWFldlyGuqemcgYGClczucGH3sxISikMEx1/9HSD7XGRJi/5zOK3Oyq
         8P2OT35I4uWdJi0tIWH+8HJSx3QY/L6I5sunN/T63KjLZ1ffA8L+NUrL+tlSxfJDFlIG
         8Vk67M7DYDoLnbJ0YiI1kKN3g9SGfkGdWmCa9Kg94k6xtcd98cjWqoC+SHyzVPZ+zxW4
         tGgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776389065; x=1776993865;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cpOJeXbfkQGfp2oJxb2u3PSnQNyOEp2e2c25qGS5Duw=;
        b=Vb8s1EpCrzsstE3JxHCJlPNz3ed0DcvRrksyUEXSs6EoVKOSHdCFkbtUpqbuQjZKcF
         oCzx+HgFS5tkKIMwykdWftwJk2W9AYshVS/CiWuQLJM0fb0EBGoIAsnyRlFcd1USbb12
         9l1la/mATD+StZtiAnsNy0mEqE2R1OHxey/MhU8Q6Jo+KN84uDdxrGkzgxuRnHfj/p87
         wLHoZYp7sAyUTfds2MaFlnDXQbjUPuiPZkjbGOKITl4WXs+B+Wb8cXhqb9JXf7xS+Bll
         w0CaQ2sBbAx31CyC/+sqZIeyB3SrVFU6GmxMvWQsXME0GA1BoZXjOj5S4QnBygkqj1vU
         OGUA==
X-Forwarded-Encrypted: i=1; AFNElJ/PM8nM4mrfInMNIu/oZbis0Knx6R+G+5/czDCWxvAiznXutmRZCodkbO0gYbYhN0WHaJfWpNADwc0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsaRtlK33d86ASMHMwHE8t8okiDV4AIr+J5l7Fl3zISefjsOTr
	SYYHKff0ivRhEnA8Is+DzAplRwsat2vRuE+az21C1nOI+kpM73xYSoqT
X-Gm-Gg: AeBDieuejP6Jki+Lc1yrMHoeKNr4u2sTXoMFIXMN1slP/HJTE6V7u7m8lguwvihQ7PO
	S5IrKRuvSjs9w/8pwe8/wEEpTHZpjtJ8Qr/HjssdGhKVq/+PBd+f+GfbmpcI7gtJod4Ksrzqdr2
	m6PUhZvJAZmmiab0VLHIBsHqZKh7znobGV12Ie2WdaHSAAMKTxBYgv7Bf9ErfFZheQoHLeJ2zCg
	tHFzUsCVnncD/pNjkLABzBxPIUG1OqQcwnn4uqXE+TEN0kng/zFASQqCwhR+L0TkjXTDyUSXTjf
	xcl8Ajg4AsETlGYCuidYgw8Y4ok4SWCm5JWUslvMIMki7qH0u/xAlEHQ20IGaxyw5hMF5H+S4P/
	qlwTVoNEEKp7PChhYNWvRkxJDr/70VHKUuPrjx4VgbKKiiFAmVUCSe4zDlKYDwRcF8dHa2Mr9k8
	Knjvuv5xjiAZguJTilM/LBoXiOW870HmmAK5M+n+YaD7I=
X-Received: by 2002:a17:90b:2fc8:b0:35e:5a4c:9069 with SMTP id 98e67ed59e1d1-3614048a431mr688213a91.14.1776389064664;
        Thu, 16 Apr 2026 18:24:24 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab20c6asm1525035ad.58.2026.04.16.18.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 18:24:23 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Matthew Wilcox <willy@infradead.org>, Salvatore Dipietro <dipiets@amazon.it>
Cc: linux-kernel@vger.kernel.org, alisaidi@amazon.com, blakgeof@amazon.com, abuehaze@amazon.de, dipietro.salvatore@gmail.com, stable@vger.kernel.org, Christian Brauner <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/1] iomap: avoid compaction for costly folio order allocation
In-Reply-To: <5x66n04a.ritesh.list@gmail.com>
Date: Thu, 16 Apr 2026 20:44:05 +0530
Message-ID: <ldenszsy.ritesh.list@gmail.com>
References: <20260403193535.9970-1-dipiets@amazon.it> <20260403193535.9970-2-dipiets@amazon.it> <adCQTF1PQnlbNMO8@casper.infradead.org> <5x66n04a.ritesh.list@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

Ritesh Harjani (IBM) <ritesh.list@gmail.com> writes:

> Matthew Wilcox <willy@infradead.org> writes:
>
>> On Fri, Apr 03, 2026 at 07:35:34PM +0000, Salvatore Dipietro wrote:
>>> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
>>> introduced high-order folio allocations in the buffered write
>>> path. When memory is fragmented, each failed allocation triggers
>>> compaction and drain_all_pages() via __alloc_pages_slowpath(),
>>> causing a 0.75x throughput drop on pgbench (simple-update) with 
>>> 1024 clients on a 96-vCPU arm64 system.
>>> 
>>> Strip __GFP_DIRECT_RECLAIM from folio allocations in
>>> iomap_get_folio() when the order exceeds PAGE_ALLOC_COSTLY_ORDER,
>>> making them purely opportunistic.
>>
>> If you look at __filemap_get_folio_mpol(), that's kind of being tried
>> already:
>>
>>                         if (order > min_order)
>>                                 alloc_gfp |= __GFP_NORETRY | __GFP_NOWARN;
>>
>>  * %__GFP_NORETRY: The VM implementation will try only very lightweight
>>  * memory direct reclaim to get some memory under memory pressure (thus
>>  * it can sleep). It will avoid disruptive actions like OOM killer. The
>>  * caller must handle the failure which is quite likely to happen under
>>  * heavy memory pressure. The flag is suitable when failure can easily be
>>  * handled at small cost, such as reduced throughput.
>>
>> which, from the description, seemed like the right approach.  So either
>> the description or the implementation should be updated, I suppose?
>>
>> Now, what happens if you change those two lines to:
>>
>> 			if (order > min_order) {
>> 				alloc_gfp &= ~__GFP_DIRECT_RECLAIM;
>> 				alloc_gfp |= __GFP_NOWARN;
>> 			}
>
> Hi Matthew,
>
> Shouldn't we try this instead? This would still allows us to keep
> __GFP_NORETRY and hence light weight direct reclaim/compaction for
> atleast the non-costly order allocations, right?
>
>  			if (order > min_order) {
> 				alloc_gfp |= __GFP_NOWARN;
> 				if (order > PAGE_ALLOC_COSTLY_ORDER)
> 					alloc_gfp &= ~__GFP_DIRECT_RECLAIM;
> 				else
> 					alloc_gfp |= __GFP_NORETRY;
> 			}
>

Hi Salvatore,

Did you get a chance to test the above two options (shared by Matthew
and me)? And were you able to recover the performance back with those?

So, in a longer run, as Dave suggested, we might need to fix this by
maybe considering removing compaction in the direct reclaim path. But I
guess for fixing it in older kernel releases, we might need a quick fix
,so maybe worth trying the above suggested changes, perhaps.

Also, I am somehow not able to hit this problem at my end (even after
creating a bit of memory fragmentation). So please also feel free to
share the steps, if you have a setup to re-create it easily.

-ritesh
