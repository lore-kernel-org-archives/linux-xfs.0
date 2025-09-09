Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAABB2F0689
	for <linux-xfs@vger.kernel.org>; Tue,  9 Sep 2025 15:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757431361; cv=none; b=sK0m3XjI8gHLuu4hJbNN0jGOX5i0Vyo4+feGYV7oqVraecbHFPpxmrjI+Zyd+3vJYBDJrSZqAM23H7TDyI5YE69aTKaaq4bxBwg4WOdtQF+3ol/rBU8ODL/jFsqVJKniWhUd25+/Cwr6xegeeFmjdK7noQjW9U373SPBbpxmkms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757431361; c=relaxed/simple;
	bh=QEXhxovWYUHVgBkEl/gTdcNOIaqUcKQWivj1PPJZ8ak=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Af57L+vRopwmrWKmxFTtsTKZ8ZGxvXBuxTgouvG5RalOM/fjY87XKpdtX5BWpxuDSAcqT2neYzGEXcQDf3bxd25FCXPXEv9bHFk329FrD+8PY1lQaq3328T5gb4zxS5m02TYuuB3/PB80IHVv2zDhU4LHqkhAOnbGIfVG4IXoaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FxOCgdeI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FxOCgdeI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757431358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=z+VJfc5dyu/GsDQ2jOZqvhe7ZEO+uEqdgkyy6rtOglw=;
	b=FxOCgdeIDHe2cOeNNFAHI1IoHzw/aiW+7JFOq2gOletUVdYbS3qtbeYs+M0j2J34cgUjYF
	gyDecw/DYrZKtYu7cDJkrZlK3MezG/LkPofbohvymbYpc0Wyp9LkY2dleEKIwa0YE9AP/O
	jjIse3w24MhT6tQ8vfCDnPnLzfLyk+8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-MGi-h-pzNCyfv0PEXzDvPg-1; Tue, 09 Sep 2025 11:22:37 -0400
X-MC-Unique: MGi-h-pzNCyfv0PEXzDvPg-1
X-Mimecast-MFC-AGG-ID: MGi-h-pzNCyfv0PEXzDvPg_1757431356
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3e753e78902so378533f8f.1
        for <linux-xfs@vger.kernel.org>; Tue, 09 Sep 2025 08:22:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757431355; x=1758036155;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z+VJfc5dyu/GsDQ2jOZqvhe7ZEO+uEqdgkyy6rtOglw=;
        b=oxzEvgCxNjoBuRiUNHLZRWUukF2ah0Hy8aYEJGH9kWcTC1Rq+oIuj1y8o/mzJKfzVa
         Ou2x0faDXB6VZRQj6WJpmDyC1aFBl8RSMSK6PeoRKtxrNsf5Istoc0DPaXMX1VbEHDa3
         eInPty//ZWwaWkoZuD0LoCGu35GFhiIseh6f3xIeKsRQCJRrh7+jHMZzYLOErkRMEsj5
         pRUR9s9OQXWv3G9mM1yHz3NJ8IaJWvZ54aqpGd1NcoTZnV6vKMDSrNwErm/cuXyz0Obs
         s884ibJ3yEbAR/YoUTQOJ2Zx7Q0XXc2aR3NERgxGccdnnBSycP8R2eZwpcw6FiohUuMF
         Sy6w==
X-Gm-Message-State: AOJu0YxcWUg9mVccLLoR1UXOcmiQpAt1VcO+nZDCMM+7P1/Yv4R4a6Hu
	Pjyuod4S1xpAthfi06T68RoBljhty1izOYpqeiKCXCbQZswruH+WV4KwtqGoBKq9RpaB6nC6y0b
	tRCECkwZkJHjnODmAbNz54PmxE0A7jurV+rBIqmCpg8UZ55ODtHNi7qBivGeiCKBQFPU1KlbXUl
	5JE9M8SPDQNFrJMDx+g/XwXL6MT0gsK0aXx8Qf0B+ythmpKKE=
X-Gm-Gg: ASbGncsz6myFg0FqfNT7uSiCPX9F0MR8sIGs+VwNFYqYPXepnnmpT9nO0LY/fX9ylGI
	Ol/8D9h08lpdlGY517xDZhSXLZS9koa40QdFM+VqUJ9hKoquQLHvh2UgFf2lV48c22Raa81exaJ
	8zon434RXLkqCepCK49lTytdL+F7yS7dR2I7dBUvzQQCwDqwWCClDcYJOAU8xwsXuYbaxDf+Gjr
	vuBYSocYksF80FZkfl94fzmz1mGHujYtV5Oo7ZVwv2ZEZKDoSisqC2yHcvbkbOuzNmtFm5W2uex
	mB3z4HYWJVBlui3aF8XZXLXfT2jIRLHH
X-Received: by 2002:a05:6000:2dc4:b0:3c8:6b76:2ee9 with SMTP id ffacd0b85a97d-3e641a60df9mr9697507f8f.19.1757431355626;
        Tue, 09 Sep 2025 08:22:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFe+xRxRQCkMmtxwSoqIUZRLPvVS5q6Y6mHlK4cZ6jPSpPnLLyRBNTHyPyXEqUm7yVvcmuEvA==
X-Received: by 2002:a05:6000:2dc4:b0:3c8:6b76:2ee9 with SMTP id ffacd0b85a97d-3e641a60df9mr9697489f8f.19.1757431355195;
        Tue, 09 Sep 2025 08:22:35 -0700 (PDT)
Received: from thinky ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45de24ab648sm127055765e9.5.2025.09.09.08.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 08:22:34 -0700 (PDT)
Date: Tue, 9 Sep 2025 17:22:34 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	fstests@vger.kernel.org
Subject: Tests for file_getattr()/file_setattr() and xfsprogs update
Message-ID: <mqtzaalalgezpwfwmvrajiecz5y64mhs6h6pcghoq2hwkshcze@mxiscu7g7s32>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

This two patchsets are update to xfsprogs to utilize recently added
file_getattr() and file_setattr() syscalls.

The second patchset adds two tests to fstests, one generic one on
these syscals and second one is for XFS's original usecase for these
syscalls (projects quotas).

-- 
- Andrey

