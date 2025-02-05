Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F789227B88
	for <linux-xfs@vger.kernel.org>; Wed,  5 Feb 2025 00:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738716278; cv=none; b=Flu5LwKNKFF9376awM8ltkaqzrPn8tsbkK06+lXmrMhoslfevcmeET/vW/TMLh1Z4gvnbDYcxQ/BQ3D9GqDLstaIU53UCUgiUWphYhuvuFTN5ikv0OhUi22JBWGco/r+Mwug4hm20Z8w28iWyiPOKVBezCcjmKnBdMlFRRXh0cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738716278; c=relaxed/simple;
	bh=pVwcbcQv1YyjKzLqh4R9W2H8jCN4OFAbje3WYYAvJiI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hb0CCEXCV+Fiflw+/n2IQWxCS3dGgJEm0DgpbgjOyX4Q9ByKPpBqizhHdSxpgMnjYAxjYvIT8X+OdnTeHrG3PYMC6TTdaQscUkXleu4GwMA9DNs6HlBI3HUT+RQHZ1OnXDmQOKaCAt2sY2ZFQ1VPf/8M2q0Ot/EMmD/q5OR8iDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=V5MwExqq; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="V5MwExqq"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2161eb94cceso78971965ad.2
        for <linux-xfs@vger.kernel.org>; Tue, 04 Feb 2025 16:44:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1738716276; x=1739321076; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RffbSUq7Mb4CXVvoaSPP7Q/PUJaOswOKzvdfco/hHvQ=;
        b=V5MwExqqnEMTQohuNimx2wnoQzPgU4QltKVMlla2oaP53Rxvy9pvBP9QGeZ1AV8Gyx
         uPtiyW2vGc77WmTYWy/GX/TYXql767z1TcNFFCg36DlRrQjce8A+SRaSDunEomMl4vvb
         QLvMl3LnVIPg93wDhL/cBbQRgK8LCJdii+1rhQSbDvp2PD1tvhx8gNQq+t/p7TumPTFO
         c+S2sAhAmNsZRSwRW16WylR1BMaPdkcfaIlN+Vg/w1O+D6a9Ox5QJiKdzN/ycggPG47m
         yPnmLvhqaiEJ33NK0ObqMjBgZgjmpjEwbPYnVvAG5FEt5FGEjZlEPgKl/U5qIsdw03ql
         jyyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738716276; x=1739321076;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RffbSUq7Mb4CXVvoaSPP7Q/PUJaOswOKzvdfco/hHvQ=;
        b=foM5XbeuFQ7k9UKXLv8jJPGtKJ+mmwXkktVKlMOaEzSDTMBM+84tJFGIApFNCET0fO
         1I8ttw2wu8YnrM7f/enqiNcC92lItMvcfBF69ddkCSsdAvpxd/RlPtVuE8GZYHj+Jl19
         ed89mHTgh3hiGxY/fKA9y12p6/XnOhNMmZ/9zvG70zG482MgML0IFeQOrmu5ZXZPgAKN
         Npwrok8waSAfxvlfyM5kdBVPPYWrnWbRu8A5LrAzXXK3RiTdM/0oT42TXiqz4Pgt45SX
         DH72IcveuZXaPYCRRM+eh0edpvupgpXcq1A8kWXWv9AIPhfDkmiNVbDeAHPxc6453HkX
         LW9A==
X-Forwarded-Encrypted: i=1; AJvYcCV7eh2XXzl2sxz7AslCXqMbpbhnS2e5vrgf288qC+CPZoC2NBbUd6dEpB0Hh5hDf6mqCpDio9TCzck=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9mep/mfYseJZ4vs8F0fFC09Ylv5n9dvrEAOO9X3dlggmZZ4ex
	w2/Sul6EaVyjLFQY+EA1mVrhqsqdUfXxJciXNNYMPIW6AehU6EAUkDuU5uI+1+U=
X-Gm-Gg: ASbGncvU8aUPBPVrZX/7f3Gt2o/dnQKOi47ENKoTl1yvmUxuAHO/VbtXpCWTXLzHmKr
	QpnwoeBAu/Ua0EhZCIhJD8tfQnBY7p9JYBX9VBPl9qWYwdlzpZRP0egSOxDsJmZuYUXcM8vDq8E
	ts3FL77fRuNCRqGjbyTP63uapPCgjLbfb9DMwiLf/rKZsbOaKQ8/CIza2HODS1GfHpEG8HSuPAc
	UQ7pc50CuwG5HJfd+LOL9IUCin1x1vSHnJL0MlA0LEDQGeML05svv+ilFlxqWk1YixRHAIYS8Nk
	ACI904CGs1Ia+F+6B7YNy6oBU2P0196BLGjgQ/QFHvqoy2rpHxj4eHiA
X-Google-Smtp-Source: AGHT+IEhKSwpLYzPu4QRekgpin1CFdbsdE0ayHeI6NAJn1J2Zyn36Rb4p17Kg+OzteJjP2Meu8yV+g==
X-Received: by 2002:a05:6300:668a:b0:1e1:94ee:c37a with SMTP id adf61e73a8af0-1ede883b7b3mr1333827637.15.1738716276600;
        Tue, 04 Feb 2025 16:44:36 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72fe6424efcsm11177632b3a.41.2025.02.04.16.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 16:44:36 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tfTWs-0000000EjOQ-0KVK;
	Wed, 05 Feb 2025 11:44:34 +1100
Date: Wed, 5 Feb 2025 11:44:34 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/34] fuzzy: stop __stress_scrub_fsx_loop if fsx fails
Message-ID: <Z6K0cg6OOZhntkf2@dread.disaster.area>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
 <173870406473.546134.15374973350883945437.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173870406473.546134.15374973350883945437.stgit@frogsfrogsfrogs>

On Tue, Feb 04, 2025 at 01:28:34PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Stop the fsx scrub stress loop if fsx returns a nonzero error code.
> 
> Cc: <fstests@vger.kernel.org> # v2023.01.15
> Fixes: a2056ca8917bc8 ("fuzzy: enhance scrub stress testing to use fsx")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  common/fuzzy |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
