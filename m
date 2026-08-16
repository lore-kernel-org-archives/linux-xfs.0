Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F3BE54B
	for <linux-xfs@vger.kernel.org>; Sun, 16 Aug 2026 00:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786838546; cv=none; b=qlFYUsoRLtmREtCB0UFNoqFDrNC1dR0ilXZrUnxjOp+Ww0rs3cSBxRavkjwtcsLezy6fmKq8CM0uSz+Czyh85T90+NMlMecY04fuU4UgX4reccFQtFfMp5VRpnFGn1WfVOJAl1EGb4izXV16pprt7F5oW8GOF/Widmtbkia8kNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786838546; c=relaxed/simple;
	bh=uXchtAgIJ0fURM9ygukRqhjROnhWDMmRQ7wlREF2dTo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=LmAdCRwNoqrybvWA0FJwclHfAqHoXWDOtsPrCVNS/dVSpqS9ebm7NIEdPMBq+3LsTbHFVudWNkEjGEUYatcILw974psJW3GEkeeLb4rlihvZMpmV8EY0a1afcNHAsEH29OBLeMYy3HGJkGhYFBaQd9fpqQtjRgM0BKvNmdcQBmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=wKF9FK4C; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="wKF9FK4C"
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-4ab8cb2a6e4so1497915b6e.0
        for <linux-xfs@vger.kernel.org>; Sat, 15 Aug 2026 17:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1786838544; x=1787443344; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d6liC8uD3F6/S6ZJfKuSXQx8GeoIfO2pZ4/+PmXMPPM=;
        b=wKF9FK4CbPXJJtkrxhSXVfyAaFw/G1dFG9qGWNv3SuLl9afv3L4Ro2JD4WizODXvRJ
         UC4AuigLKvTJ1yK2/jGJ+iMyijPz1qtLC/eoNdq3bG6Kra245qPKL3cNPI1xBkcijD1w
         b0cc4A6+3SIcLZ0tUTKJRZO5KCGtXLMMr2LIXteGamMuz9vH4756Jz6mKawS6bTx7g7e
         S1umDhYilud8n2CMAZEfts9HzY2t85X6CCXItwWpkQF/AReGrtUYZ3mU9JmoOFUTuy7O
         wi+WdwANFSlOZXmgtYQcX5WyMXxRVEQtZUGOuSRHHg7KdQkpjfksExVT7dd/xWecqP1C
         UJPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786838544; x=1787443344;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d6liC8uD3F6/S6ZJfKuSXQx8GeoIfO2pZ4/+PmXMPPM=;
        b=JsrsCt3WTpFR6hvTBC32inPZ16zeUO8gESGPmuWwrGf7F82fD+X1X++iTaPGehVPli
         q/mZH4o8V5qWtHi7TVxoIo+uwc04UrJEStnebSQo1m0EHCrYHldcbpCporC+4JydAfcp
         YW8/I+VjM/h2FOyC7WyzR74I0QCfPbpj9Yl3PmaFhBmuGFzNVfP3oSa7HxAenL8y/bOk
         bjEQqRJsuch9U/j17W7uLC4RpyYHTGcnKgxXSD7KF99nCrwapoJz1M2df3/dD6HeLtBa
         fM3/qUFzInINLBKV2jGd2ruAaVWbOd6zfSuJL78bdIrX0coF6aCEyNJEty7A3oouhP4A
         0mpA==
X-Forwarded-Encrypted: i=1; AHgh+RqqHB2RLnWpusNC1l0rJYhEFJG/LMnM3OXtucGlczl27Lm6cUFfxieutUnCoui2GCbYIJnCrYSK3Yc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxt3xzek38VHC7+HczhmFRUJDue5HCYbX3iIMfovabL7fJrGrV1
	Nkknjlsy7Dmv0w7p6yrqtTu3QuNtdcrlxhmNavL3i1Ex9JEVGsIQUW0hBp789hZSjAs=
X-Gm-Gg: AR+sD12SFmLfktVhAGAjMaILUMVuogENE0eXQCxc83FoV7yIaSpNQaFSPq5XWya53LP
	vg6Nyn4XJjX3g2puCmA9fPs2EeOU26TsFhi5vVFnHXUMEU81NzEZgzxUH9K8xvxqwOicoOqqxHJ
	vRdy1TFTuzBBfo5N9fuM7LM2GyJz9rGyYYwViZazbPHcFzrfwqRkTaxtiUkN09Rd7nkHmdWATLG
	d0pcw6m9CqXd3TITRRI4GnXzdjOMH6KfXxDM0Em2LMZOijVcEhE+8Ydv70GFXrRrb85xXfqG9OE
	e1XrWklwRgUr1P/5n6C5hbKegsEPkD88BBKSCPuN11/UTzM5zRfY9CeDNZtrC4ZyeyFjOKCo9YH
	J3f/72AUWYhO+gJRTjwqzb/hbW2nqRUwKc2VQW6S2ZF2YHlx2HOtuRLvhpF8ruXrv5OXP187oFg
	/dLmR7TLGUf8z7sJ0yIh5jX8Mtxewm3ccRLRwkaSdi+jjdVWJMCRd+0+rDVb4mJ+bjzEMZkCZYO
	oFhQv35Uu2ikYr0cnSca+FulIcirusWSimIDR5Nyg==
X-Received: by 2002:a05:6808:1918:b0:4ab:32ea:95f6 with SMTP id 5614622812f47-4b241e5f0c0mr15455005b6e.13.1786838543975;
        Sat, 15 Aug 2026 17:02:23 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b24d92462dsm4347729b6e.5.2026.08.15.17.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2026 17:02:19 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>, 
 Jan Kara <jack@suse.cz>, Tal Zussman <tz2294@columbia.edu>
Cc: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260810-xfs-dontcache-double-defer-v1-1-aea7484b3e49@columbia.edu>
References: <20260810-xfs-dontcache-double-defer-v1-1-aea7484b3e49@columbia.edu>
Subject: Re: [PATCH] xfs: avoid double deferrals for RWF_DONTCACHE writes
Message-Id: <178683853844.1984298.10537884425177679953.b4-ty@b4>
Date: Sat, 15 Aug 2026 18:02:18 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2


On Mon, 10 Aug 2026 12:39:19 -0400, Tal Zussman wrote:
> XFS already defers some writes to a workqueue when transactions are
> needed to process the I/O completion. Disable the block layer bio task
> completion in this case to avoid a major performance drop.

Applied, thanks!

[1/1] xfs: avoid double deferrals for RWF_DONTCACHE writes
      commit: 913dcbc5670cb772bddf9799d17f975e020e8326

Best regards,
-- 
Jens Axboe



