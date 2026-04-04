Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC5E1DED40
	for <linux-xfs@vger.kernel.org>; Sat,  4 Apr 2026 17:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775323492; cv=none; b=L7U4TbYgyDS0/4ViNLmwRQOdFQPnftmGhRLlG0d9VzfsYU17ZOAXhQfoEvBPiQYrDg2XpuZrLwU3jE/d81YMnV3cwBvBuxNrePOiCpzWMtSfoan4plFa+Sp1FlwpWUHzDPM7Ty3bOMUCDdzu5ELGjbivUJMqkWJoNe02fyA4Zuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775323492; c=relaxed/simple;
	bh=2ilu1jQHox2wTnDUggPiw1YzGE41A4ol+N4ZXaAB6KA=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=CYp3XOqC3oMLOPECN9ezbrRPPfTRISIev00h1pv875cmTq8hxC4VTWIGxqTNDKtJBbvmb0OUUUfYDLyFihDIlnW9f2cU6h64hIVpYeeFZpIdNRiFTBTAJqu6B/BQyWTA31ZM5c1xD6f9TYItfpNu9mAPXGr5I7QuM4FMx+xBny0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kk8rrRmP; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kk8rrRmP"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c76cce85bd9so897892a12.1
        for <linux-xfs@vger.kernel.org>; Sat, 04 Apr 2026 10:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775323490; x=1775928290; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1oGf/F8Zl1olrj7LHwmAzkM6a8hyoOTJaO/XdIoQa0M=;
        b=kk8rrRmPpX7wAXHUbZx/ke+qQGAuwWtLhIiRmt5/bjDkrdTaLaP42RRuL8RM9UnR8d
         iRp2ZawRGYlV5yhKaZmcviKkrYAGB4pQSf84bpqtiD5VN+amsk5ARKpN4Sg4e2VhUvEI
         MBb5bz7P6wruAhSAA6Q1ZK0SNt+sAGsfQ+rwp02WiBKP3eBFVA6FNoQ49OquAdamIX2Y
         qcGVIIhbHlf3adsicex7fvdtjycGxax5n0m5XaSGvMNfIsYflUQjl2ly1/dhNIqV9/2Y
         B91W/A7RMtYE8VXS8ME1KD2Ct9/ZoXvU5Plm32bNXhBxwVQeskDJT/1pdAFnLHkO9omW
         a7xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775323490; x=1775928290;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1oGf/F8Zl1olrj7LHwmAzkM6a8hyoOTJaO/XdIoQa0M=;
        b=RRsKyyP44WS8T5R1Vda2OJPcnmClKY13+Qk5xXjx8M60Poi/CgsfDaxGW2nV29WAm0
         XDbSSGMuD3N/yVlG4ucPDIruSt4G9lImrv2kvKodZhP8foQgI05qvqcKn2X+Zg6+ufNJ
         nudesHAaBaZXNvrOzaU+W2uyQJ3xa1UUQ8lHGpaOC8nSaTSXxhOvF8mejanRH/yDSH8d
         N3EXed8OMrV0lEMSQhpPtiO2rTtXr16AFDoCEL4xVI1Hzw3NLsC4lx+e/eRXo2Ctl8dX
         BhnuYW1oABIQPKZ1Pg3o+orJ6cmAoKjiqx8KDAWGA7qrDCTvz48DtFMhLVKvgwEC/V4O
         6Nhg==
X-Forwarded-Encrypted: i=1; AJvYcCVki00rPhJd1Yo/AIHBLBUrtoXPlrnJzpPdj6cFF5tF9ftZrYDNxbCaM+uOUFPSZjD82TdqMgZZn8Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YyO9evV2CS83QyUjgaZVItvh8DZ0cLrwCxxp0WXZEOmdFZDyiL6
	2G6q2EOGqr1Io2fwo1HxsyTbmWy1vSq2WA2sI4Huht0LoEWOri8U/ohd
X-Gm-Gg: AeBDies7Vt4bOeuvFKzMJYrX4qCMGTvVF0R75aLm47u0fdwGDqsOIHy5Qar6z8qBDwA
	MA2d3Lj5cgxLCpxhCclwYvBN/gG45QC0FhOjLLS1O+nIi43DJAKasfxEvT+83sJDHaG1LTZHQG4
	1yc6V/nRLqMMixjNzeFWo4dCYCM+CUGf9X+8NlajFxhKqXf7bdRUCkcjD0KaG23cQ37Vxu4vmsb
	9SsLF9gAXv+CL+vNXOSkpoZtVUPfjl6nYCgPhSRglMw+RxZE50M74SPwiMNDc6Wy6/segFKcxSv
	Z5Gi52mPh6RAUEoDm7+tYc/uQhtAjp8XIJeWn3/p/u39Ko1q4R3ocfsDSVXU9Oj6cJAVYOpuZbZ
	LKiwPFpp9rHiDWXRHuAA/Ilbc+Tq9gA5VhDBSv79vK1hXmOhrcQue1+H+HUqSZh6u6Tz8sdMjv+
	/Nwy6W5TodEkhSWSE2uNm6lA==
X-Received: by 2002:a05:6a20:2454:b0:39b:8dcb:f37d with SMTP id adf61e73a8af0-39f2ee01ce5mr7551700637.17.1775323490281;
        Sat, 04 Apr 2026 10:24:50 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76c657e703sm7990160a12.22.2026.04.04.10.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Apr 2026 10:24:49 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Matthew Wilcox <willy@infradead.org>, Salvatore Dipietro <dipiets@amazon.it>
Cc: linux-kernel@vger.kernel.org, alisaidi@amazon.com, blakgeof@amazon.com, abuehaze@amazon.de, dipietro.salvatore@gmail.com, stable@vger.kernel.org, Christian Brauner <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/1] iomap: avoid compaction for costly folio order allocation
In-Reply-To: <adCQTF1PQnlbNMO8@casper.infradead.org>
Date: Sat, 04 Apr 2026 22:17:33 +0530
Message-ID: <5x66n04a.ritesh.list@gmail.com>
References: <20260403193535.9970-1-dipiets@amazon.it> <20260403193535.9970-2-dipiets@amazon.it> <adCQTF1PQnlbNMO8@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

Matthew Wilcox <willy@infradead.org> writes:

> On Fri, Apr 03, 2026 at 07:35:34PM +0000, Salvatore Dipietro wrote:
>> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
>> introduced high-order folio allocations in the buffered write
>> path. When memory is fragmented, each failed allocation triggers
>> compaction and drain_all_pages() via __alloc_pages_slowpath(),
>> causing a 0.75x throughput drop on pgbench (simple-update) with 
>> 1024 clients on a 96-vCPU arm64 system.
>> 
>> Strip __GFP_DIRECT_RECLAIM from folio allocations in
>> iomap_get_folio() when the order exceeds PAGE_ALLOC_COSTLY_ORDER,
>> making them purely opportunistic.
>
> If you look at __filemap_get_folio_mpol(), that's kind of being tried
> already:
>
>                         if (order > min_order)
>                                 alloc_gfp |= __GFP_NORETRY | __GFP_NOWARN;
>
>  * %__GFP_NORETRY: The VM implementation will try only very lightweight
>  * memory direct reclaim to get some memory under memory pressure (thus
>  * it can sleep). It will avoid disruptive actions like OOM killer. The
>  * caller must handle the failure which is quite likely to happen under
>  * heavy memory pressure. The flag is suitable when failure can easily be
>  * handled at small cost, such as reduced throughput.
>
> which, from the description, seemed like the right approach.  So either
> the description or the implementation should be updated, I suppose?
>
> Now, what happens if you change those two lines to:
>
> 			if (order > min_order) {
> 				alloc_gfp &= ~__GFP_DIRECT_RECLAIM;
> 				alloc_gfp |= __GFP_NOWARN;
> 			}

Hi Matthew,

Shouldn't we try this instead? This would still allows us to keep
__GFP_NORETRY and hence light weight direct reclaim/compaction for
atleast the non-costly order allocations, right?

 			if (order > min_order) {
				alloc_gfp |= __GFP_NOWARN;
				if (order > PAGE_ALLOC_COSTLY_ORDER)
					alloc_gfp &= ~__GFP_DIRECT_RECLAIM;
				else
					alloc_gfp |= __GFP_NORETRY;
			}

-ritesh

>
> Do you recover the performance?
