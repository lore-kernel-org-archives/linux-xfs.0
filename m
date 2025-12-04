Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89668333421
	for <linux-xfs@vger.kernel.org>; Thu,  4 Dec 2025 09:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764838829; cv=none; b=ewCJeIpXaEQ1xFJ93MTvcFDR91tQjjJhm9pfukAxgaW2S79NMKfrrEx4do9xYhXoH5eJZlb1iOKGrdiciU273O/OMfQRDHLkuX8aDAkI6L5wli/758X5ZGMi5KYSkj2z6Slqwfxo8Dhy+2Y0Vl+lVWnytf3UjcXGabyVCdIFTLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764838829; c=relaxed/simple;
	bh=72GPm1ULAj1WA2GXdfhiS+jYjGnUAprwyZKKNmKV62I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KToNWI1/BHEhDOM5YoLDnmG221Q9yyGYfgSgaKjN9i4ty9+eK6ZhOdPl6uj6ONRVwiuW7eSEguhDdfXPcbCyRhXNGyxiaOUyj+MKVIbl2ttDo3iPiXaN9EhLe7ZYl03eIVO9i3IjlWSkvPZsWS+u4FZ5uWOuNokOcTpnhashOuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=d8/pFBj4; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="d8/pFBj4"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7bc0cd6a13aso457413b3a.0
        for <linux-xfs@vger.kernel.org>; Thu, 04 Dec 2025 01:00:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1764838827; x=1765443627; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=72GPm1ULAj1WA2GXdfhiS+jYjGnUAprwyZKKNmKV62I=;
        b=d8/pFBj4FGRkH7QWlN8rQvDV6IlMWDUg605KeQ1gBOCr/BEoQshoR8T5DQFy2RO8N8
         c1k88JauWrYBi7WblT4cyXW3T8XrmXYkhRGNoUs0oap8m4ffw1QHEx0JRoB0N1OO1qs4
         MSivUcGmKJE03vLOq+EJGofaw+BYOBYJHGMn0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764838827; x=1765443627;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=72GPm1ULAj1WA2GXdfhiS+jYjGnUAprwyZKKNmKV62I=;
        b=lgV8OAxgloU3P+urLidDbDNwx9wpZlf8t/4VIV0S+czgEAt+fkDlsRVmR9DSGKVrol
         w4KO8EkBwpo1Me5NBsCfXRjFh3h06uT0X4nGeGv4UwfTMgOKZtSVte78OtVnhGMynsFN
         TzSApsAujoFBkCQ8ZnAB2+gcZKkBnAxWvw8N8XUnRrODEWuNv3rjtc6BqJHPpu2zPW1e
         szY5YO/KPCLWofSvzdxsYKpQVpw+o2ulKZMBiGfDP+QtrtwmLqTIYYk+poWvNKk8p/Vv
         DKn2Wi1rGu2ZIpklmeoIjN62PPgcCmloqsiMIhxOqSvcCFE84cDi81QIuO9ulyQLp9oh
         oR5Q==
X-Forwarded-Encrypted: i=1; AJvYcCUFqWtjjTWhNM6lC6IQYs83QnqBq3SL57eP7aUNjKnhfMRp0Ew+1W2qek5y8A+Bf4CViIY+R8KU0/I=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOdH+lQWBXAQYpT3vlhzzFg+wEcU45MU0wYH9YSIc5yXp7ixRc
	EFVTz0ebpIqwZ8ZmeYAlursa6bXfHcSX9i04IhRVAKskzw4q//9nubt+GEUXDbZxZQ==
X-Gm-Gg: ASbGncsRmfqJ6wKEjEO9hWNICE2g6VEq8DUs3m0qykRGKQqJ0SSw3i25uKnHisYYpxM
	v2sWFWFdW5fMdexlqziph1z5mZ2WrBpLytO4BBSJJyZsL93jPAjc0XQ6gJuDFkU24lZm04WuF9V
	zLWGtq7WE+Mx61tAgISkhQn5vcsy8iVpZpP4ee3SN0vOxBi8UTyOzcrLMvfSOH7mz3aqUd3qE/4
	knWhm8t4/G75evtpHUOgjzjgncwmOskeKajiqbL/y100I8uePbfijgPNuj8n80Vl9jQ9plz3rRt
	LMhAS1j8XQKX4YHt+unOn1/iApSGQOOelF9WMSoB/dhge34fQHZ9fm9gtEwI72IhGGR+UERY5kr
	OHiNkSGsrs90kUoCxuUglPM/xolGJ6thLd/SXNUWehj+14SDBgFgBXKBKVpcFbjDved4dYpEzjY
	bI1sTqICxWYQkado24eCDWAG2bCaQMt80A/EWIdL4qq/szMeZcy20=
X-Google-Smtp-Source: AGHT+IGrCmJXKAQtdU3NALKnC/NLtRATjkDSaaivHemq5nPaEpusucmf2NZ3eoouqNk9cTRRShNDMA==
X-Received: by 2002:a05:6a00:6fcd:b0:77d:c625:f5d3 with SMTP id d2e1a72fcca58-7e2020650a4mr2076684b3a.1.1764838826661;
        Thu, 04 Dec 2025 01:00:26 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:803c:ee65:39d6:745e])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7e29f2ece66sm1483482b3a.13.2025.12.04.01.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 01:00:26 -0800 (PST)
Date: Thu, 4 Dec 2025 18:00:21 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: zhangshida <starzhangzsd@gmail.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, agruenba@redhat.com, 
	ming.lei@redhat.com, hsiangkao@linux.alibaba.com, csander@purestorage.com, 
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux.dev, ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
Subject: Re: [PATCH v3 8/9] zram: Replace the repetitive bio chaining code
 patterns
Message-ID: <d3du6mmazbygxo2zkxqjxamfg44ovrfiilbof6rnllfjzxnnby@becwubn7keqe>
References: <20251129090122.2457896-1-zhangshida@kylinos.cn>
 <20251129090122.2457896-9-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251129090122.2457896-9-zhangshida@kylinos.cn>

On (25/11/29 17:01), zhangshida wrote:
> Replace duplicate bio chaining logic with the common
> bio_chain_and_submit helper function.

A friendly hint: Cc-ing maintainers doesn't hurt, mostly.

Looks good to me, there is a slight chance of a conflict with
another pending zram patches, but it's quite trivial to resolve.

Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
