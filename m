Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAACF2F60CF
	for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 09:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763977126; cv=none; b=Xt4IiE3VXluvNgHdOxrg7sT2uz32SvRYDqL8rryyE9FzOeoJAyAsgfwcWB0a5hfmYpcocqJ+akRI4QOZl4br+ZyAAX+DVTUUm+7W6LhJOz6UlYkq5LOwzwfnGhXKne9erFZ1t2PxJBf+mtwr56y1Un2SMMaRTRRliiN5PKkvF/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763977126; c=relaxed/simple;
	bh=x1sm8zFzm57Nsie/BiDMCgK/WoZJkcwXtr1Bz1A2UEA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SOfyTE3Ih2pcEuifY3SWsEzlEoFYLlvL6KaeKHSFR/i5eBe2XK2MjcJZu3q6r0g4/+QpY5pUXO5wozdQAH6XTYKC5Da1KVoWR5nXThfO/S87bw0CHaLI+0cGNhL0YkJoYfTqis2M0GHLLyYPfyqfQJCnm48dgPSKgfg6yBFGMEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QzrlxtHK; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QzrlxtHK"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-42b3669ca3dso1624228f8f.0
        for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 01:38:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763977122; x=1764581922; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ez5oWnr0g5lJcYE17xXQIOUfbJdYxhjH/dkAdjtphcM=;
        b=QzrlxtHKD50Epg4FSqmaUb14n9TplS0J1MzD7G5K2X3onIeBnQcSM1VCd4ZWe2toxQ
         PGCLTttvlgZPkKLofBc5SEYV047sc69oBGbRpl77jdX4pF8q/SMU1luxHj+MXU70hcBB
         TBKNSMkZJjfPUp0fdNqB8bg/7dLleGWslGHrfywB5rfD1/8XXRYH0Ji5FBIV+Gi+g7GN
         oNfXUd+ojsjbtV20pM7AHwLRAJBjhOr4sGUF9ulm+5QJ2Negh7CZVA9KL3XKAR3yT+uX
         KDkiKZESvYqNYFkcHicSuVfxkJHu7tJozL7RQsPeaEs9lkgJGORV9Wuqmbg0Ox8SLG5W
         WkpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763977122; x=1764581922;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ez5oWnr0g5lJcYE17xXQIOUfbJdYxhjH/dkAdjtphcM=;
        b=gG1IhRfK0BQbgrhr3OodlELXoS0z4NuNPlLz45GNERyix2kTXPHBXsKATJXB1xoRMK
         tZseigFIFGMtAnrQIy5ssX4IaeWFc52GdxboE4Uq0s51i7RF1h0iofPenhO9lpIcJYn5
         KHY12xWs5xCpQIvSpYLvooKirhrVXE7DbjbfVmGOSf5NXVL32vwJK9f2393Tf75Oqf1/
         11Lu39I6W9qfA4xm23pfYTUhQQmn24Q1BDCNmeMdk34fC0ZT7x0BBMs/bUekaTggaB2i
         JvjdbiVS6HUVBPUhv0mZXU9bZebB2XZ2xjbeVdS6Oq3u6k7QjVGN1E8oI5wYH49N/mUf
         fOeA==
X-Gm-Message-State: AOJu0YzMcivih6VLx5b9SWhMDdH7pPFzqjMMAJAfgJ8y2oFjYZodypmu
	LNsGN/5fMRneUzmDiGthRnxGT0V50JBMjvNyhWZs43hn6nZggOb5qJ4v
X-Gm-Gg: ASbGncvMiCPTAHinZQkAGWggnHpXavmiRUNZj3Pipshza6xaXp/SvpTu3Jux+PuWLK5
	oGq16xKb7Fj8DISC1dndOQl4jr7HIJQSn5G4j/hbJUoDMBIq7bdNCNCOe9/D46hOgI3Izg1Bt+N
	Lr3Ogg3r4ewTnKaaZ8rMTvV8JV22F939H2Gd7x5GLo7qeQBqav2I7lyBls1JUcjFT3xrs98YO/P
	sgDb7tY0TYX6YSrrAV5zs4vKte+/qzCt+U57/xz62PxVRT8tf74ZL0BpxvTHuNc0wFNvM0zOKxz
	C9aI/2aUHhfapHayeXxHlCjhbBKhOZD/VfW7+ExDyd7xEXHEXRGKtVwKQanROs4LMIEfo7iw0uF
	D/i0QjdjzkYJ6Fr8frsVVZz/RZkMLjZq6nGAKYB1jzayX+pM/MkGhWKyRADsB2PMIc0QNWCBJuM
	gF0CEfrQX8FBJGd0D+PByG7u73tf2pUPVGzog+zh4SAWm72fuNa0zUg3HE+eII7OWhgW0Tzw==
X-Google-Smtp-Source: AGHT+IENW9m3klxtw0nGzzYb0YuI2qhcaUhH+j5o3ryTtkgBsMNb9wDRdlWckj20/efUr4iV9E1Kmw==
X-Received: by 2002:a05:6000:25c4:b0:425:769e:515a with SMTP id ffacd0b85a97d-42cc1d1969emr10593299f8f.42.1763977121877;
        Mon, 24 Nov 2025 01:38:41 -0800 (PST)
Received: from f13 ([2a01:e11:3:1ff0:2c27:4c8e:8db1:96b5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7fa3a81sm27747911f8f.26.2025.11.24.01.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 01:38:41 -0800 (PST)
Date: Mon, 24 Nov 2025 10:38:39 +0100
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev, 
	smoser@chainguard.dev, djwong@kernel.org
Subject: Re: [PATCH v2] libxfs: support reproducible filesystems using
 deterministic time/seed
Message-ID: <cd7hvirjj5wbthwun5a5dxxakxcbqpovjnrp27mjqsdxas7i77@2tvep6rp2rvi>
References: <20251108143953.4189618-1-luca.dimaio1@gmail.com>
 <aSP3jzYTU8KkY2vs@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSP3jzYTU8KkY2vs@infradead.org>

On Sun, Nov 23, 2025 at 10:13:35PM -0800, Christoph Hellwig wrote:
> Btw, any chance you could submit a testcase for xfstests that uses
> these options to create fully reproducible images and tests that
> they never change?  Having this functionality exercised in the test
> suite would be really helpful.  This could be as simple as creating
> a file system using the various file types and then checking the
> hash never changes.

Hi Christoph, yea I agree, will work on it in a separate patch set
thanks.

L.
