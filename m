Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE33F148FF7
	for <linux-xfs@vger.kernel.org>; Thu, 12 Sep 2024 22:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726179162; cv=none; b=ETK0F3NZ/7eptK7OjqccULQvfDZoB3SGYPS5M4A5dPEnE/qljE8TL1Q4d9wZfheiTkQS/FYWZfE7imjOOShEwIV+tS3XEr29fUXd+I280s8HMH71os8JZaGkvLVAw2IcU7FL3zDsiRK4p9ApD3N/xN8P+QzMCdVq5vOdYCzIpLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726179162; c=relaxed/simple;
	bh=UlYy7Hlbdt+rczKfYZZW2LIR+Y5Cgkp3NmyR7eArPLU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H0A4YQOrwXCA4hzdGuq+pnSDptVmf5+PnZl81keYpP7tPKsgM7WrIrODOiNkL/wvWX6o+2eLQdPnLJ+lu3/HUDT5zAYq4M63BpNbXDmDQoTIXlnnfPGIHtudjnJTWI9Ikf2SNpA0Rm/vITcIu8PtKriZIZ1vb9lKqqCt8Kv7o+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZNch9qJu; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZNch9qJu"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2d873dc644dso1224307a91.3
        for <linux-xfs@vger.kernel.org>; Thu, 12 Sep 2024 15:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726179159; x=1726783959; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6XHoL0ZBi9GE7Zl5WoiwZ5w6Gz6wVLeamEWBzoE27iE=;
        b=ZNch9qJumqv92QI8ZUAkl/0w69TYW8NdOpM66ZLbwHUqtU5657xSWUIsgIoBdc2sgj
         j/t3yvECkQDqscjnevuytcT/kSUrKPU+IZL5Rjwu3vbO7GXtWEXgkfFH6CVn4ZA/igOT
         Hradv1CtkfX1tIjayTBIZ1bjBx3zMXbXLKffYXnH/aZ/HsHLPp9tRvhbuT5z7oxdWKaI
         SXe8h3UmRqhcROd45KVKaVthcqc286AQPSTl7lnSsC0tvRxsnyebL09iys6tgNKMZzbr
         L/8np1YmHF8elGMcL+JryHQJyYGbOPF9+luUljsSFdXvb9mpeJuOEWrolAKYVADmv5ht
         RFng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726179159; x=1726783959;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6XHoL0ZBi9GE7Zl5WoiwZ5w6Gz6wVLeamEWBzoE27iE=;
        b=vkyq4+Bj5jmaa5pzVdr5CnKTwt4iYWm66qmww06k7Emq/K/gfWo60ubUNeDIEUZSTF
         TnHJxkbt0p3V2FBwc8FYuBZbXv4JYYWSGuTDy8LZKLgsgtO+FvMksjxmO1SuAIU+e0pc
         5BMC8lgX6/h0AZ0QgHjcsDzMccfZtEPEtvrLsCO9pDcNiwypJYgL4fNFxedz4vePJDhF
         d8ME/Wj7ee8NzTg2Wqsqigx0HJUuI4sgnlex3YjWRt2JCM5XCNFe/o6fnV+3vkRPxCSu
         ggr6ChGBQ3j/LlsczK6RU5q2lCKkTHrBUwIrdMD9bKrczbBpoIcc5unijw7DD0ecWFL9
         nuUQ==
X-Forwarded-Encrypted: i=1; AJvYcCV7dU7QMHFYTEkEghWVIljkQpY8rY0c6dFbh4nVnS1wzP05nVKDCWJ4Owhxi3xIPP2pcGi3XByMI5k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyf1JCqQly7dOuRV1d1YKdec53wzv9ZWZKKZA7zoZIyjP8RU3QP
	/IIuTA7t3BPFI8eQE9d7bhN2Hy7wyrhKj2zW8errsrl2YblOLW5Dy9CY5G5J0y8=
X-Google-Smtp-Source: AGHT+IFpTCq6+ukL7H58M1PsiI9W1iyXsSunsAA643ZhHhX6ctp4jDxCLQSXqpQypnPnbrvP1So3dQ==
X-Received: by 2002:a17:90b:4a4a:b0:2da:7536:2b8c with SMTP id 98e67ed59e1d1-2dba0082fecmr5160596a91.36.1726179158919;
        Thu, 12 Sep 2024 15:12:38 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dbb9ced741sm211330a91.39.2024.09.12.15.12.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Sep 2024 15:12:38 -0700 (PDT)
Message-ID: <0fc8c3e7-e5d2-40db-8661-8c7199f84e43@kernel.dk>
Date: Thu, 12 Sep 2024 16:12:36 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Known and unfixed active data loss bug in MM + XFS with large
 folios since Dec 2021 (any kernel from 6.1 upwards)
To: Matthew Wilcox <willy@infradead.org>,
 Christian Theune <ct@flyingcircus.io>
Cc: linux-mm@kvack.org, "linux-xfs@vger.kernel.org"
 <linux-xfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 Daniel Dao <dqminh@cloudflare.com>, Dave Chinner <david@fromorbit.com>,
 clm@meta.com, regressions@lists.linux.dev, regressions@leemhuis.info
References: <A5A976CB-DB57-4513-A700-656580488AB6@flyingcircus.io>
 <ZuNjNNmrDPVsVK03@casper.infradead.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZuNjNNmrDPVsVK03@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/12/24 3:55 PM, Matthew Wilcox wrote:
> On Thu, Sep 12, 2024 at 11:18:34PM +0200, Christian Theune wrote:
>> This bug is very hard to reproduce but has been known to exist as a
>> ?fluke? for a while already. I have invested a number of days trying
>> to come up with workloads to trigger it quicker than that stochastic
>> ?once every few weeks in a fleet of 1.5k machines", but it eludes
>> me so far. I know that this also affects Facebook/Meta as well as
>> Cloudflare who are both running newer kernels (at least 6.1, 6.6,
>> and 6.9) with the above mentioned patch reverted. I?m from a much
>> smaller company and seeing that those guys are running with this patch
>> reverted (that now makes their kernel basically an untested/unsupported
>> deviation from the mainline) smells like desparation. I?m with a
>> much smaller team and company and I?m wondering why this isn?t
>> tackled more urgently from more hands to make it shallow (hopefully).
> 
> This passive-aggressive nonsense is deeply aggravating.  I've known
> about this bug for much longer, but like you I am utterly unable to
> reproduce it.  I've spent months looking for the bug, and I cannot.

What passive aggressiveness?! There's a data corruption bug where we
know what causes it, yet we continue to ship it. That's aggravating.

People are aware of the bug, and since there's no good reproducer, it's
hard to fix. That part is fine and understandable. What seems amiss here
is the fact that large folio support for xfs hasn't just been reverted
until the issue is understood and resolved.

When I saw Christian's report, I seemed to recall that we ran into this
at Meta too. And we did, and hence have been reverting it since our 5.19
release (and hence 6.4, 6.9, and 6.11 next). We should not be shipping
things that are known broken.

-- 
Jens Axboe
