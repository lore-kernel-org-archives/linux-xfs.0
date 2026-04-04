Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E14288C2C
	for <linux-xfs@vger.kernel.org>; Sat,  4 Apr 2026 01:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775267038; cv=none; b=LZQp+xcYdzKhlgx+ZyWrDyzosez+0O9tag083PaaTbtEnsnAFiP3G4iaJAFIvUhHPvBL2L98CYD6e9U+efcUNwUv6mvIsfLtEtbB6oMTFtZdisca8M3bnwG1fQjw8XrJJLgvGDwK+6ghe5yRgpVKo9jbf/ED9qEucFjWGNW86ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775267038; c=relaxed/simple;
	bh=o+mXn+mO3TOBOhs6Vj4ImptTHtx9x7UXnCndYtnzSCE=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=mHciysPF8Os9ARDNja8B1kJJPNsy6sEWnbXqKrsAxPRyUf+a/F+sUYHGPEf+pNiFlICWL1npPyO+xAIALFJjcOeUw06sItBM47BtncC4L/n2WZpIAbZGh7y3bqbxM3Y7dS98wI6UpETCyDedGTglE8DY6NHg8SqnfMslNkOYI8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nXr3C9g2; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nXr3C9g2"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2b25cf1b5f0so14354835ad.3
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2026 18:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775267037; x=1775871837; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mSmUlQx+7wcM8hvk6KgWAN6mYWx05Ua8pH5lZ6mYZjw=;
        b=nXr3C9g2rOFq3lOWtfJXdm1R3NpHTu0T5mbjoqhvOlZ9h18+ISrPrL4zOUB/n+NNrB
         SHEf23xnLEPX/yTwckXO60RlK5cx6bJLu4CLZpJ6GRhUnAxc/ARpRIN/ziZy4zLNrCEq
         PCptii73YhlofADub/f6Z7mOeowVBjS+LTCtxtGz3wN+g06GowochDaJUc8f5zh5mQOG
         fjydkerhn2of1EDtc9N2L+ThYnMV4qQxlC7UvyjzTDE7lwNh5Xis44qUOW9+i/MyDdRm
         IV+BXh6LNwwnHlFIGbXi8u0atoU76iTmq8pLH/Vd/9uhYE51qLVGibdJ41EWk3AlGhKv
         dFKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775267037; x=1775871837;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mSmUlQx+7wcM8hvk6KgWAN6mYWx05Ua8pH5lZ6mYZjw=;
        b=cdik3dJnKBmW8V8ttZxTu2UwM0IvGE1wn7AfsokLefCPtCMR5cgtG0cARO0Q6WDZ4r
         Gqc6jXh+Oqprcu8Lt/MLJojfLiYS53k+PD/DVwlVlCXFsGIpj5KlIHNUrNlUWsmrXmRf
         0G05jx3NWu3/1QSwk7pz/sHPo1lP+iN6hbD00M+fERjw/Ldhu5RQeDVEZ5y3F3lILZV0
         ENxZGjL9zYj+BPQMZMBw9pfzvcwICeUuLoHvatx3cTlWXOqqL2sXDnt4+I0Ay8XhByQZ
         iytlhyW7l/PIPcVeHl4FrgloWTufRhmsNKzFOUqPhGsQxemuf3ygw5hyD50A7D05Z44l
         Zxzw==
X-Forwarded-Encrypted: i=1; AJvYcCWDQKa1CUaYwr1JhasVCu8YJ6j1swT17LaMbWgjtRHQnDPm/Sg6rSu3/1+HFSoEGwETiwXJNsLwX3Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZJFHTnnG9Keqm/GMwKuhm9fW4pZmUJ2UuUFsNxWNG7wOfcxLg
	+dD6F+UVOdBh5IqLrGKOcrwgWbfN5SWimr7sbpKuejuL/gBRqc4j648u
X-Gm-Gg: AeBDieuUJfUHlt5/GwLmae0m1KZwoxGZdYP9xcJeDNPy/5wGeyWbwJORfuNasfE24Y4
	Yy2jyai+nNnh9ggPTz3yRvbp5BXPKq0dw+kHNqSeV26hVeUm1ThLc3M22k4Sbk7GYzhj2vEIJ2C
	exdavWScC0QxlYbwnCXmktIhf7SyPxcduhTMOEZ1AM9KY2IPdY0rwyI4APhWfk6aMdudCcInjHL
	urivrcKjQYrm1yEkmH7OojlQzU5BSd6QRdnPfuMm79Uvi0LtZLtjVVLtb2XDsuSeYljT2Npj8w+
	d5g3VGeU0TzbrPRH5WHUYm7daIjw7oQpCbTAMj091aVyPR7T7JOKJl1hkiCe/U1mPgMQbNB8PYp
	i/vSo1+Ot54HB19pFWrF5lbG5gBQJJB9+FljkHmCQexYa9lksM0Pqh/Pt10zO/Su/NhyWzV/tY3
	l+SXMnfVM7tTguSpHQY5Ye3bwK5syf8MYk
X-Received: by 2002:a17:903:1ae3:b0:2b0:afad:7aad with SMTP id d9443c01a7336-2b2818016c3mr52841215ad.45.1775267036795;
        Fri, 03 Apr 2026 18:43:56 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2749cbca2sm65157255ad.73.2026.04.03.18.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 18:43:56 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Salvatore Dipietro <dipiets@amazon.it>, linux-kernel@vger.kernel.org
Cc: dipiets@amazon.it, alisaidi@amazon.com, blakgeof@amazon.com, abuehaze@amazon.de, dipietro.salvatore@gmail.com, willy@infradead.org, stable@vger.kernel.org, Christian Brauner <brauner@kernel.org>, "Darrick J.
 Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/1] iomap: avoid compaction for costly folio order allocation
In-Reply-To: <20260403193535.9970-2-dipiets@amazon.it>
Date: Sat, 04 Apr 2026 06:43:06 +0530
Message-ID: <bjfzmst9.ritesh.list@gmail.com>
References: <20260403193535.9970-1-dipiets@amazon.it> <20260403193535.9970-2-dipiets@amazon.it>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>


Let's cc: linux-mm too.

Salvatore Dipietro <dipiets@amazon.it> writes:

> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> introduced high-order folio allocations in the buffered write
> path. When memory is fragmented, each failed allocation triggers

Isn't it the right thing to do i.e. run compaction, when memory is
fragmented? 

> compaction and drain_all_pages() via __alloc_pages_slowpath(),
> causing a 0.75x throughput drop on pgbench (simple-update) with 
> 1024 clients on a 96-vCPU arm64 system.
>

I think removing the __GFP_DIRECT_RECLAIM flag unconditionally at the
caller may cause -ENOMEM. Note that it is the __filemap_get_folio()
which retries with smaller order allocations, so instead of changing the
callers, shouldn't this be fixed in __filemap_get_folio() instead?

Maybe in there too, we should keep the reclaim flag (if passed by
caller) at least for <= PAGE_ALLOC_COSTLY_ORDER + 1

Thoughts?

-ritesh
