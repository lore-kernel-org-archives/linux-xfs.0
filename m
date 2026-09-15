Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CD3413791
	for <linux-xfs@vger.kernel.org>; Tue, 15 Sep 2026 16:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789489060; cv=none; b=JrgPhvMx4FrsplK1A3fNxihjGvMsX9oe62P2Gwn6/7zA7K1gHD6PuAoH9Vc4bsZoT6sLNvbb5OJneGxwYik02VhGgflUcJCnQgOCsemm8He0qrAam7IDnx8XQMJpPAx4DrbkE+809Vh81HZ9OB20xfAPpqfFEU9SNQLzoa5ji0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789489060; c=relaxed/simple;
	bh=cJFv5mLfQ+9Fzjda7I53xSLIzgCeDtC5OhcBV6QuJ1A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=egFfKoGNBLpJcQHjud07u1ZVZutBu26Z7+GPsSGQtixeC4Lc0p/fwstTegkmRTifTVcpAFZRlf26t0fQsblMTohmBAufdh1Wbq1Gs4ZiyY+tv4Y8OtWxTDhmg2PxWv9JJk38ppGrZppomnEneUerIjIW0pbvQsNDL7McaxIYmxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=fS188pRZ; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="fS188pRZ"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-93a10f9a2easo94271785a.0
        for <linux-xfs@vger.kernel.org>; Tue, 15 Sep 2026 09:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1789489056; x=1790093856; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dXoaSOzLcSniPHeJqnrgZd+b23tx7/MvhGFOoQXutdY=;
        b=fS188pRZsdThyEpLvlNZN99q+hwl3CD+Kr2Wcvt/OecrNMB6fo474ehP2cESjPm/GR
         ruEMIrrjiBE5+BG/jlseEmTdlx9lOKKM9IAPmrK/sdqftum3P1otF9eO0XhT2ITE9d/o
         KC2XYTJutZa5vsEHhm69/g4W7CH9TesEMUU9dsBndWo0W8RaY/r4g49ULSc6SpQ1M34V
         FpgwcjBi+gujZZJny/7+PkxWQy/tZWYRWAVo6hpzF4P/tDKoAKUe9tdOzHuvcIB0LF0E
         YGHtdrmbl89RPPk2qN4bPBZvcO/iMoYthZo/+vkJW9VEfehRrtCfcOFcehK7mW1C1YT6
         RkWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789489056; x=1790093856;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dXoaSOzLcSniPHeJqnrgZd+b23tx7/MvhGFOoQXutdY=;
        b=z+wjDyLNo+V6PrKA2pqH/kYtwtHAFtAC//goDiiviv9e7NxA76iGm27sQaMYxJRzU7
         RO/b9XqHyHRyC9Yc25Td6QU8bqp9qyAT1jVIJ6qMExbYKaun5U8leRR7lPCudIhTLHSk
         62k5fAqULqeG+vWMukla+DV7jCYDXgrthcfbUkxN8u2chO33JHMNi+/dhM2Rg7A/3yHh
         tgiBE/8V7Dzuda+SpJn7vaIeLffHsrQ4Gi39WdiA4VXWCAEB2DOnpUagGCOO4t5m34/a
         ZGIX3rNX3W5oB9Hi5LiOpEyQ82r1mpNyMqeBTEvNU/HUPsUHytY/IWXkeXvU3OHhYvbz
         hVJw==
X-Forwarded-Encrypted: i=1; AKwUvBxYbItsE7P1kM/OJxi3XEJG3Z9DLoLjsbEUcAz9lKK6hTsfXJre3YfkT48qBxaNidn3EjUzT53x02o=@vger.kernel.org
X-Gm-Message-State: AFuF++ng3tfWe0nX/b4hjWuE9GCNAtZiLI8x8z77t+shWJWw05BDAR5t
	ayYEXTwhnfZmNpWCyE8Ck2O25cZ+0LBY3KTW7Vr6Md4rnaA3wfGniNXdJVelym3lYwk=
X-Gm-Gg: AYBFou1pmXxfmapV+vzyc3HUJtYWnt1t3WZM2cELqwtZXGfxkPdmEn8GifeMLk3Jl21
	r5wCkBCIMu5us+INcw+baozos3PaVbqeUiXJtW2hEkQxixvLq05seZ2ZLEuErSJeiOzCIaVEE4n
	54aHz+kWyZEqz55VpJFiEJa7yk8KB7rwqyhDdMParoql3o4tCxFet+PQGpveczj3IudL90XoXz+
	IH9lCKSOhn/WhcuYzqRVrl30Ub3hnEMrpqHmA14k8W+BDKKhgL5YN1zwfcnIwwvk9o6ojPbVB22
	7DGelgDPAvThX3xdDziIhSHNfPJUU6dVDcni+hnKAlLAL0Pl0Ctw7dcMvMdVolay7lUVr85yL9X
	X72HYohrGr1K5wHPZPOkKGxygA3qfDD5nYu8TSJerFY1T38jJE9UkAqCzT7cWIB5YC0ZpwYq0ZA
	4g1oqFBX+XZxsJJIAc02x1AzNvD2GEOBgSUnZQLZExrzrlf5wY3aNvb+MluxzrfN/+9uiSog==
X-Received: by 2002:a05:620a:2607:b0:939:b7f4:c7dd with SMTP id af79cd13be357-93a3477ff9cmr603922085a.47.1789489055702;
        Tue, 15 Sep 2026 09:17:35 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9123bddd5e1sm2362876d6.3.2026.09.15.09.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 09:17:35 -0700 (PDT)
Date: Tue, 15 Sep 2026 12:17:34 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: akpm@linux-foundation.org, abuehaze@amazon.com, alisaidi@amazon.com,
	blakgeof@amazon.com, brauner@kernel.org, brendan.jackman@linux.dev,
	david@redhat.com, dgc@kernel.org, dipietro.salvatore@gmail.com,
	djwong@kernel.org, hch@infradead.org, hch@lst.de,
	jackmanb@google.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, mhocko@suse.com, ritesh.list@gmail.com,
	rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
	vbabka@kernel.org, vbabka@suse.cz, willy@infradead.org,
	ziy@nvidia.com
Subject: Re: [PATCH v5] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Message-ID: <aqlvnm8AKp5f_UhG@cmpxchg.org>
References: <20260911093209.d9181d5950778897935f6bcb@linux-foundation.org>
 <20260915160042.1265958-1-dipiets@amazon.it>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915160042.1265958-1-dipiets@amazon.it>

On Tue, Sep 15, 2026 at 04:00:42PM +0000, Salvatore Dipietro wrote:
> 
> On Fri, 11 Sep 2026 09:32:00 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > does any of this look real?
> 
> The mechanism seems real, but it only shows up with vm.defrag_mode=1,
> which is off by default.
> 
> With defrag_mode=1, a costly __GFP_NORETRY allocation that used to fail
> cleanly can now succeed by fragmenting another migratetype's pageblock,
> which seems like the wrong trade for a caller whose premise is a cheap
> lower-order fallback. Johannes, do we want to keep it strict?

Yes, avoiding the fallback is a good idea. The user already
communicated they can handle failure and have fallback options.

> If so, we could add a condition like below. It is equally
> applicable to v4 and v5. Happy to send it separately or in v6.
> 
> 	/*
> 	 * Reclaim/compaction cannot run, so defrag_mode's strategy
> 	 * of enforcing ALLOC_NOFRAGMENT cannot be fulfilled. Allow
> 	 * fallbacks rather than failing the allocation outright.
> 	 * Not for costly __GFP_NORETRY: those have a cheap lower
> 	 * order fallback, so failing beats fragmenting.
> 	 */
> 	if (defrag_mode && (alloc_flags & ALLOC_NOFRAGMENT) &&
> 	    !(costly_order && (gfp_mask & __GFP_NORETRY)) &&

It would be possible to remove the costly_order gate here and just
bail on __GFP_NORETRY. But no strong feelings.
