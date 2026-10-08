Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FD44718DC
	for <linux-xfs@vger.kernel.org>; Thu,  8 Oct 2026 11:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791459858; cv=pass; b=gaw2cio2WvDgbw26lZ34pBaguj/ChitGpesgW2G71bPXQzXbAmsBeSH47eNWl3F5Ji9nBTj6fVyDf7dG7fTUJjw3JDV7iMZuOS8UwCOi9JqRhytzbZTQiRCF1IkifrFXzr69seDEqzO3g7Hiu/EjWlUxtRQjI03JXbFhLBU+8wo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791459858; c=relaxed/simple;
	bh=F2zqmRM3iI8PS9kUAZsutdB8oUyV5WrW6uLyCJ4oLY4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oUNNzgpRLGlhFpLlkYqZ6qOC18/rd197EKN1cAwINB0i9idraGO66I10aRcU4dk/AR29XwdlGN2+djGOBlO2YPo0AbhccykGxxy9SJcbYSW9369/LKB4Jy3Hhnz7MtHIRGwmDf0GXLQ40wvzN4NSQjeGdDFrryMHl1LMG6N0xA0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VV/LqYgr; arc=pass smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VV/LqYgr"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c2e69aa07c3so710723966b.1
        for <linux-xfs@vger.kernel.org>; Thu, 08 Oct 2026 04:44:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791459855; cv=none;
        d=google.com; s=arc-20260327;
        b=L6oKWJmEs0FyAmPxtF6TyzX/pd81rOM7uUqDyTHRID6EviXyO5EMlAwkD29z+8nnce
         htwpz8u2pmAWfAZ5scOMWQ5ccOBBVNoFNTHFHzpANqSyN1N1cF0smeRBg9GlTsnT8MuE
         DdEG30r9una7ll5jejhmSEJyKoPLJCerftrPxtCv0ExYVVye5v+6hPcpDw15nx7y35Ry
         y7Ewp+EEEk/dxDvcIFhd/F7Z1c/oN1Gk53AyxKE3xtOAszo6CXOYAsgNzVkAbW0Lsy2j
         JCwqC5hbjsHg7kwMWFWqSSmq1ZCIZ99vx5pJD138yqDJ2aYw1VklUdJLOKSEJtV7naok
         wJcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=KgCzrz5MTmEOiMmZEKQzXUh1jqi6chxJJkO653u8cQM=;
        fh=K6CO8PUYjw04sco3/ZrR9Z+jze2w80ihy0nqD4/VIAQ=;
        b=D2WSTcrLRg1hliUZWPriTkBQI+8KdLxp/TuiM4v3jBR1QYgpCclDnq/dxEvIPAMa4i
         jhHWR3XQwi+4eRZwzTbJwecdcry1qSdD/HRabPDRa26fIgpAnuHKWCXgH0FMZvQODIYR
         xGGrRiatpByKq76hWKLaypmvvhaA/LS9HvSLy4fuR2K1NGkEq5OCYbCIVrvBjfHDT1lP
         A4hI4ryYO126qWQPF9LKLBOLlxubjjWq339u/VcchzQjMuXRLrcfNYFNU47QudK9ufSU
         J7mb/mERxjFx/gm932q0YXHur4B8gWO+B0uE1xvcXrag6pFialHtGdSRD20fN8IaqVeG
         y0Tw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791459855; x=1792064655; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KgCzrz5MTmEOiMmZEKQzXUh1jqi6chxJJkO653u8cQM=;
        b=VV/LqYgrRW9eEl12HGYoRR+wMChxl2LrM2nwtyU0xEbl1cukRqaYwZJ7oCPH12F62s
         fqfVvji06WvNhJZDcwUCXqBTbk6B6RehQHk2E7bHDQRkfGr2QlWeR/+1L1bR9Tt02WNH
         KqMSK5YBUyWVLWEZ+xn8bTPelsBxK5qu0yJUM8J20GfrogldibkSuB6lHFlpctmVLiHw
         /JN+MuXX6sxIHFgo6ABcPkLlxQH7/KTMmOQdtnwjFhSaPmI6tUyF7xHG3P/X3O4HqcZL
         xZzf6AigYpZoKrCsyngOzcMPAwMH9eFoeP3+SF/bZ2fjDa04Rv9V+M+v160az0sghyZt
         gGYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791459855; x=1792064655;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=KgCzrz5MTmEOiMmZEKQzXUh1jqi6chxJJkO653u8cQM=;
        b=tGXD4s18/N32ehI7NTlKv7VKlrd12top0nlTNiRBIgNP3h8kLrRFsIK6Zlm/Bhmhi0
         8eO08Mz8iUj2ie1xzmGedKyj76xgOyB6HJnIO9E3L26Ueh7Zo0MvkyC+N1a04pYOpOqJ
         LyVjpsHJjYVFfTxfWtdHQpbtIvIjK3p2SaEowox3YfmK+5BBo287Uifo2yW3Ovf8bzcB
         pZ0AawLWGk43Zezyi+USnAl4sO8UTl1BA8V/jpfpO2bBhqc3svvO0yA31VIqusCIdlid
         JAOPRM3dqchQcwbRbWxJ7Lr4hX1Shu1cfTBTKz+rAXbdX/CCa4GqAue7Mv862siL9Dz6
         Cdtg==
X-Forwarded-Encrypted: i=1; AKwUvBxvBSXTw0E0oYZw+2bq7geRaScbeIqvgTDfQIRaCYmvfb0Z5aMEbj7SkMR3gFnyTjAlsGDFQjWLnsM=@vger.kernel.org
X-Gm-Message-State: AFq9FYIR9+cHZuKUfHCm0cBetEl0TgY4aLstAYbsQ3JvXrxZEvOQBt4w
	ZAjr92w3KZUrTqg4wTGSFsymJ4GBP/OP5/tWMHVxRl/9JbmvrzJud6hp3KnS9pOyJ5A7dbQ8QB4
	Yv91a3Ggx2iuQTLjwMa8/L7OUCuv49g==
X-Gm-Gg: AYBFou22zE9vrDo7xV68uarxM7Aq5qRC5WR2UKGLBJmGN0/MP6IbtXGsMZ1EdHoci9p
	wHiGc436WOYvMGI3aWuXGdJ8O0YbW0ExIl6nWJkibx65VX9+GW2Wiik7lOH+EjERLAcbuJkfulN
	RCTi4qvGdkNh5o0DhDZts50KzG1RnmrshhfMoPa4BXZYRojvmfldqSN5gLXBis1dwfMoKFYjwoK
	wHn6VvkTIaM3GeXfO4S3zc2AwLbfVJq+6ck/qB4vzxRRVxpD+1kXzoysP0NyHOgpItjvNX5vdSD
	Fyxch/dD0ybo9P09EJgxFQ6gtECqW4/OnQoN8Fdq2r9SzxnSRuhVjI0c9bT7XduJ47fjnvVWEbs
	jJ1bCFTchGvqrvUvUoNbRMNqSqGlXrGkDod6s8iVJKE7bsDnhto3A
X-Received: by 2002:a17:907:1c94:b0:c2e:32d3:1b5 with SMTP id
 a640c23a62f3a-c317c0ad02fmr523121266b.32.1791459854813; Thu, 08 Oct 2026
 04:44:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260924100032.2733101-1-hch@lst.de> <20260924100032.2733101-19-hch@lst.de>
In-Reply-To: <20260924100032.2733101-19-hch@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Thu, 8 Oct 2026 17:13:35 +0530
X-Gm-Features: AclHuK9ii9nY2tZvVAGfNbbhZVmNqFIbUD29KvWXyt6MDnjdmu7KJpQUpIenNsM
Message-ID: <CACzX3At0e+qWoNrvrPuryGrOxpGcH1fr=Ymq1spmG0qqiJ+d-w@mail.gmail.com>
Subject: Re: [PATCH 18/21] xfs: don't try to verify checksums on empty zones
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Content-Type: text/plain; charset="UTF-8"

> +               error = xfs_csum_verify(mp, bio, saved_iter, csum_buf, bno,
> +                               false);

Could an open zone be verified past oz_allocated here? XFS_RTG_FREE is
cleared on opening, but the verification range is not bounded by
oz_allocated. xfs_zone_rgbno_is_valid() treats only the prefix below
oz_allocated as valid; should this trim the verification range at that
boundary? Otherwise a whole-rtdev XFS_IOC_VERIFY_MEDIA request returns
a spurious userspace error.
