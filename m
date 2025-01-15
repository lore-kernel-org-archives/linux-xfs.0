Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53BA81D63C9
	for <linux-xfs@vger.kernel.org>; Wed, 15 Jan 2025 19:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736970739; cv=none; b=GVKg83jygcimg7m0mEz45Z1u6R4EA6rRrUkm2ICjKsnf/ekvyxC5g8Q6uDSZP3JvV+QcFyjLo/gEB1Y/xoT/wKYPoKZpURkdZjV/AkcYLwyH5/zq6eUjcDvJuVy/QMtLJU2JGYIBVloid3qxER/fnb8hqSnV1qC9NVraAyDJgZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736970739; c=relaxed/simple;
	bh=yONHGbUTahj+XrObv/UIGGwZuOcdk2uL9AI/CFnzB/w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DQL2Z46XqxOaNg+v3X07Xgl6dRHUmlZpnB1jdhX3t6d34JM7MweZrAP266jMKg/iZ77sPC4Z7XkOMLO4L4bdb5Tb1++6o1YLEmJv56TxyMokb6VCkeNY3c3C2mZesnpzZvhALQaqOugmavTkgnp3ilo4Prar5j5zn28ecFxL21M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=JcbxXkhV; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="JcbxXkhV"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-218c8aca5f1so1854635ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jan 2025 11:52:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1736970737; x=1737575537; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0VqveMYCq0eRALEG0hCd1Pr3K4Tua5ddZX00MrZ56nw=;
        b=JcbxXkhVtyEStKMY90g9gDqRBRdJairKdd5eAmS1Uo5ViHnmG7IMma7lKqB+OXBu6i
         6+4XqJ/9HuRjcAdhXbHDDeyN/M7biw6MLAZRjTkm7UAPjpAhNsO6pfiso2foau7UOMGe
         NZm+06x0I75ReDaD+BMlqMVWEuXW5FDjgCEL76WFfyht/U8L42IaeccQpdRa26QIrcwE
         IOV/rwrWgFfM5nQIlfVRjjL4vaeOt3JN8tLyAQ+vcBEMbsPOrqfWAxnRSsbu7MoTOtXj
         nntfcL0zpD0bXGFI1dn47wF4uBMJ8gw4l/eUs5usFlMRHX+HoRD8LWbQV0Z09dLH1mq9
         Hi4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736970737; x=1737575537;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0VqveMYCq0eRALEG0hCd1Pr3K4Tua5ddZX00MrZ56nw=;
        b=Zt2S3JoWA79PVIcihX1BZ+5p0mxiiOcndXRPSs0UTgWAv6/H2pCvy8nbmzjwyNhEL0
         zscWCTWADMmsmBS8PkVcxSx2XnPgLae/O2ODubE8Q7ehHl+N8fUiw/fP1GQHLLR7Wirv
         ahRGEHDsrOjVm2aekFMTrfL/hR5HWkeyIotScC8aQHD75qWv4mhdLGn3GNfdhiVSfIL1
         XT9/Z/4mzYavxd/YeDLwJAD56Xa/vZgRvShvBfkm8w8wM2x29kTUr78LeHRWND5prLsw
         uHEiaW6sYNbiAlHMeRM7wgbS9GQv4iQiFesB+dAwar+yfuGaDYsB3yUOak6aG46cig40
         L1Og==
X-Forwarded-Encrypted: i=1; AJvYcCV4nW88PJQ2jc0qgVd6je+ty0DSf39m37iLzYVMh8jxeoPxYsOu4lpQ2dVwEYugGY1mY398/fDZKAY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDztiJlZbPrSr7c+bqsibLPKJgcePbyeUL5KiKMZlJ4gkaQnk+
	zFN9itLi1GoRTIz4joeKUoTJEcfDcj9zrgpZVPHnBBd3eq2rqTF7MTWkqR64sk4RIL5kH+jbHoE
	n
X-Gm-Gg: ASbGnctkgzXYrTLDGrCjfp4089+mbYja4e5u85KItsSWN7+ROv5fLJIdl3xh4fNYNk+
	dl4/e9SjRVf5+L2qFoTAxs2aDbGsfkJmlR5SVBKuPcDlWpV/TYSdxBtJd6MX7lmkgLiu0nhGfSR
	Sxmm10Y9iDKQgZwTYYDRDZGM+DQQvA9ss39XChn2cC2TFlYuA0TLnuiz25I0pxGv5X+kiIuIRMx
	zZLbDPFVcYW+dbhAgDhlhzO2AQFMKqOUV01CzT78HGu9KiOC6zcYHS62EoT3EedsLZTtJk8TqtT
	/DVYeQbJ5KjMmwdsFO8QWZwHemMiLvBO
X-Google-Smtp-Source: AGHT+IFEfJMq5Dd0X1cVhtovGCGL83TJumRQJDWJnf+4bUvBVrrTL6DhwlG4lAN0Po0x2a5yPUMfeQ==
X-Received: by 2002:a05:6a21:38b:b0:1e0:c50c:9842 with SMTP id adf61e73a8af0-1e88d361a43mr54722805637.31.1736970737692;
        Wed, 15 Jan 2025 11:52:17 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72d4056d5aesm9573865b3a.43.2025.01.15.11.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2025 11:52:17 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tY9R0-00000006IoV-1Ltx;
	Thu, 16 Jan 2025 06:52:14 +1100
Date: Thu, 16 Jan 2025 06:52:14 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jinliang Zheng <alexjlzheng@gmail.com>
Cc: dchinner@redhat.com, djwong@kernel.org, cem@kernel.org,
	chandanbabu@kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jinliang Zheng <alexjlzheng@tencent.com>
Subject: Re: [RESEND PATCH v3] xfs: fix the entry condition of exact EOF
 block allocation optimization
Message-ID: <Z4gR7u9WBnyApKQV@dread.disaster.area>
References: <20250115123525.134269-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250115123525.134269-1-alexjlzheng@tencent.com>

On Wed, Jan 15, 2025 at 08:35:25PM +0800, Jinliang Zheng wrote:
> When we call create(), lseek() and write() sequentially, offset != 0
> cannot be used as a judgment condition for whether the file already
> has extents.
> 
> Furthermore, when xfs_bmap_adjacent() has not given a better blkno,
> it is not necessary to use exact EOF block allocation.
> 
> Suggested-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
> ---
> Changelog:
> - V3: use ap->eof to mark whether to use the EXACT allocation algorithm
> - V2: https://lore.kernel.org/linux-xfs/Z1I74KeyZRv2pBBT@dread.disaster.area/
> - V1: https://lore.kernel.org/linux-xfs/ZyFJm7xg7Msd6eVr@dread.disaster.area/T/#t
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
