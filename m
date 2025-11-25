Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C218B2ED17C
	for <linux-xfs@vger.kernel.org>; Tue, 25 Nov 2025 23:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764113618; cv=none; b=AQqHeEsCdDrWDPYWgRjqEaGXpBxDeMVEcdYCwhVmAsXOcIuyvltEvOMwWjl21Uq67Q9AkAOukQwy24IEOX2jr3eEiV0vDCf339HUFrc6HprIyh862b62Bq8oIWbZKjJEUfVwxPlPqBYx7ltCDuD/9NS/lacvD4EswXGJyT6Hom8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764113618; c=relaxed/simple;
	bh=3rkC5tVLIYNbT+NJhSO0xtU9bfDYrwdByb9M2iU+wBw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aWPqc4kc3b0VXKcfF/gyx58B6V+21dSWd+wQ+C9wfWtSA70kDwLqBxqscCSDO9xLmn+XugWbW4XujR131iWQUYp6zexaFUi1D2rbvfomozzXAK5bhTctbDtLe2IkX6xtvF5mDBq3Ka1HiTMtolsz0M0/PS9h+byWJ7ZMmJLIgz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RapJjHXY; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RapJjHXY"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3434700be69so8638320a91.1
        for <linux-xfs@vger.kernel.org>; Tue, 25 Nov 2025 15:33:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764113616; x=1764718416; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3rkC5tVLIYNbT+NJhSO0xtU9bfDYrwdByb9M2iU+wBw=;
        b=RapJjHXYPOdTLcYLs/FvDuCH+2uk3C4YvOZho6lQ2DUunXzuffgOyrJJdJTT+zKarB
         Y5bxS7QTjTICzx73EqYjfUkyl0FVw4x9IAxmcOzG0aCf9aVAGcQLF+SDf8po/2gyqqil
         u+gb4VscO1GMmQtuJOgEikKXerndt1NLulnw2mreQGqo90I/pv4WCBVSlk7wWQqvo0fD
         8ZxKliCAngF8pEnFcZP66ohQJSs5e4FCjllfn5lHxNKjvERABRh6B4AROdQzHDTgEkH+
         MWlBTtaGwqr/gZ+ENsb+GNvzwbp76+nYbH4gEUbWlRmpDTMmG7owIjbQdwNz9RDxBy+J
         8lnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764113616; x=1764718416;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3rkC5tVLIYNbT+NJhSO0xtU9bfDYrwdByb9M2iU+wBw=;
        b=SvZkY9WapbGc5RWuHg2k8LUDyHsrpdIWu1Tt83W35Q/CaOFDNzVM3fEpMpn4VYkPV+
         fzawfZk10LoUcQY/jbWD8UQ6RQwJkK/xlMfplr+sR5LLls48IgjtXyqUv3OBLwNvslQK
         55SCIAjhApFKnT5wYxlpV99urwq05z6+YDabxzpqZwTtFvRJVA2eL2rOsZ1WUBL+6Ugy
         VWWAVeYxgQg3bAIpVtvV2M1yrCd6PUH7KGQxKJi26uYqkuuIScqkVh4ci8KKS1JuRVhZ
         Xfqk82GzDrYlyVBXni7MH337Ka9eXG8/L5lis3YdGThY+LE9y8RrNAta4yjf8vHkyQXY
         2GOQ==
X-Forwarded-Encrypted: i=1; AJvYcCWp4atuHSJFzPZXnJKP+Yqd/7jFawgIIXEiopmGESwzhKBviV0UuwjU+VDODZoGxLuszM7o7E7Kemo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRpZOrnaJecxQ/jd36k+kZa/mg5ebSAG1m4BhVj1CiW8EfV/BK
	PhtHt7YAXs8Arub489QA6MeQgQOHpx1kcWJNy5tqkP9q3GbumfFVoqVB
X-Gm-Gg: ASbGncuQftW5Z3tIZP4HpF44LLsf31do2rGbCBI8ElTIDtQUMAgQw4SeAfAeLyih2Ct
	fP14khv/NruyHiB/Kx1InPtplDSIKHzhKSKdTNbtUqhIxvqIEoiX5QsbOZhK3UfveuibQhvMeU5
	NE30o1UiKztZtr1MFmjASP9w42jo4kohtgHSmJKW/fRIpRw5QFjiR2Jv9UrnmK5zXUzVR/sIleG
	dx2azYqgc6aoErepmcmDvOcMquJ9jr7EGUuNB0KIQe5F0mtG+gt2aiFhgUa3euM50zGpvafV/UO
	HFVJueg8NEH+FLxl6lsnN1yNMTF/0KlvVoVlqS0a1MbgZ5bUs2e120phJ3nSlhRRDXFH23tJX9g
	4DP8YFfPF9vAmSZkuQ9JkDS3bTbDQJJuUo7Jul9Wixgyp1TgBsfym43eo4ho2ky+zsQdaLVRa/R
	5HmwOJOfG4YhJvwejzvsA68zFdKjk=
X-Google-Smtp-Source: AGHT+IGN2yQvKPDnQSI+rfi8GFgwmIi2Dp/WjRDvh8wa+7M3RBmYm0POoYwrQhejduq1ue9sQHFv6Q==
X-Received: by 2002:a17:90b:3a4e:b0:33f:ebc2:645 with SMTP id 98e67ed59e1d1-3475ed448a0mr4374100a91.20.1764113616140;
        Tue, 25 Nov 2025 15:33:36 -0800 (PST)
Received: from [192.168.0.233] ([159.196.5.243])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3475ff0eae4sm1654152a91.4.2025.11.25.15.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 15:33:35 -0800 (PST)
Message-ID: <2146e663be965ee0d7ef446c7c716d1c77a8a416.camel@gmail.com>
Subject: Re: [PATCH V2 1/5] block: ignore discard return value
From: Wilfred Mallawa <wilfred.opensource@gmail.com>
To: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>, axboe@kernel.dk, 
	agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org, 
	yukuai@fnnas.com, hch@lst.de, sagi@grimberg.me, kch@nvidia.com,
 jaegeuk@kernel.org, 	chao@kernel.org, cem@kernel.org
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-xfs@vger.kernel.org, bpf@vger.kernel.org
Date: Wed, 26 Nov 2025 09:33:26 +1000
In-Reply-To: <20251124025737.203571-2-ckulkarnilinux@gmail.com>
References: <20251124025737.203571-1-ckulkarnilinux@gmail.com>
	 <20251124025737.203571-2-ckulkarnilinux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 (3.58.1-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Reviewed-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>

Regards,
Wilfred
