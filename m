Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D60321449
	for <linux-xfs@vger.kernel.org>; Tue, 23 Sep 2025 10:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758625048; cv=none; b=OmeTxvDE3R40wnBOHa20LP6ToeCYgQYk3omLB2swQWnGAJbDje/NDAjBjRY7wNU7YW/vf/tdTW4K/ga5nUBmCifu3/Ic71g2SS/ztXph4Y182AWIKjvAydhc3X51Lk8usBUMC0A4i7cF/yjEX2kqKjD/LW1k+VUC3eeTOppBqZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758625048; c=relaxed/simple;
	bh=2MeXdCvURTAzTkx6QMrHRp3S9A86YdzLDwHjZbC85GA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mYQTtRawZ73NuSViJLt9TcTrg/UIVL+Q/ZDVmc2mr/CFvE8xww83sV5AGLkibPEhdv3KAFLsbw8lZytS528wenE15plkXqWOelkn1Lb/sFAE2OOBQLOhCM1ZrARn81ZVeJUQA6z1yc24FGW9hSGD3oY4NTmGVM4iob2fgUk6A/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=obz8Q7fe; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="obz8Q7fe"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4ce9b5de951so11184651cf.2
        for <linux-xfs@vger.kernel.org>; Tue, 23 Sep 2025 03:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1758625045; x=1759229845; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2MeXdCvURTAzTkx6QMrHRp3S9A86YdzLDwHjZbC85GA=;
        b=obz8Q7fe5LBkTIYZ3NmPerF6qas5s+UrHsjnvSndrBrgV0iPTJ74xVIMWZCpy7Fw6F
         EhRej21X55jgkWuxaSbt5uRPqlxK/vN9ZH1q9JU3lgduw9d+iBWeVbfqswDjlKvJIUQl
         kwseM2zeOykEi93MJYTkti7Sx8c17uOI17Weg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758625045; x=1759229845;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2MeXdCvURTAzTkx6QMrHRp3S9A86YdzLDwHjZbC85GA=;
        b=dxWyRfpDeGGibrTSb5x2EbsWoaAuvfeKuTPi3+S31B5gnTYWRDaLaTRcP0hs1MMwim
         Fvda/CtkPEq+beHQJc7F4Tu5JLiiDDNlcKpBhl2cvB0tmbp7mMCaD6BfU+tSH7HZt8ds
         Gk/hO/BSP23krcCbVlU4jv+qz/VJjUSnzrug5GUoKThMzNwgwFsMKVwH47Pc9IUjHdXP
         ysDt9rj+mo8IQ8LFp0Y2Iu0uzUzutQ2TEx5SiNLvZfgWAIt98gwZqSHLjcJD50CPg4Qv
         gRJ7vCp7RRifMvuFQM8kzQdMHLGuuLIHBXAZAhsChceis7ownv+041yIb67OY44ObOXD
         W0BA==
X-Forwarded-Encrypted: i=1; AJvYcCXdWCv2zTzIyEP1S3E1WYwD+KQ3pMlkRSBLyNq+w3EbOobM4O0Ltz6HPvLnrAMEWenvF19zprcEKDg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpcYEb0JjaGBhk8Xp3GAEIUODou0/Ohv8q3f9Xsmncmd8pqTgc
	Q2MIJ6PFE/glnR/PAo1pItQM4DSUUb4rmPVIIjASuwtECmdW826BbgqbIAd7nEExrLIzMTMyP4U
	b9nP/nK7QVQbcv362ShujJ66g+eysjmuQLcKjjVGcB/C0FasXZOpg
X-Gm-Gg: ASbGncvoOs1jziV3q9+dggcka/DOUr6hsDe9PWJn+A5mVr82xN6EAXPUCrue5z4Chm6
	NTAo319ecwXJ11TjaVKKx5hdISQCR2kSlbauC2T+JSt2l+zrWQpFE99YTnBt8VVZr6Ll08gfUL9
	eo7gvS34k/b85m1mA4iUAycyxY8CrQeNfXMWsNywsFSiePRy5iBD4a3LtrN7kOzthnh5wX7fFdD
	myi8xuZSe2u4gtNV6dDkj9tbNvH+368LJshtgY=
X-Google-Smtp-Source: AGHT+IEX2FQnjqBT2nQROo/GmnwQJfhYdbUuQlAtXjIqq8yTbxUzJNVyAUEw1AzJLuqsGAuVc3X8Dzc7i/5z5z12nKQ=
X-Received: by 2002:a05:622a:1ba7:b0:4b7:964d:a473 with SMTP id
 d75a77b69052e-4d36e7cf86dmr22388341cf.52.1758625045299; Tue, 23 Sep 2025
 03:57:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <175798149979.381990.14913079500562122255.stgit@frogsfrogsfrogs> <175798150049.381990.18237050995359031628.stgit@frogsfrogsfrogs>
In-Reply-To: <175798150049.381990.18237050995359031628.stgit@frogsfrogsfrogs>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 23 Sep 2025 12:57:14 +0200
X-Gm-Features: AS18NWDgcLlZa783VDIvuFp9dEh3HG2MSYk9_Y7d4QE4zvlotxO9EgkDJG273xY
Message-ID: <CAJfpegvQogdf_NaiOk2GqCBYYL0qwOrJRLOV-b8HnUj0iPPXGQ@mail.gmail.com>
Subject: Re: [PATCH 1/8] fuse: fix livelock in synchronous file put from
 fuseblk workers
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, bernd@bsbernd.com, linux-xfs@vger.kernel.org, 
	John@groves.net, linux-fsdevel@vger.kernel.org, neal@gompa.dev, 
	joannelkoong@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 16 Sept 2025 at 02:24, Darrick J. Wong <djwong@kernel.org> wrote:

> Fix this by only using asynchronous fputs when closing files, and leave
> a comment explaining why.
>
> Cc: <stable@vger.kernel.org> # v2.6.38
> Fixes: 5a18ec176c934c ("fuse: fix hang of single threaded fuseblk filesystem")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Applied, thanks.

Miklos
