Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2046376E0
	for <linux-xfs@vger.kernel.org>; Wed, 14 Aug 2024 02:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723603628; cv=none; b=RXZEJn1chA2evenLbblrocY3wO+ukQ7d5IhtUut7OiSPz/SLOLKTkCkuIYgvvkXZRAef2GXUdUsmy03/2FjxJri3jG/mh1ZlCoJh++0CyWnCke3S3xJmuqhaqLU4c/9fW55EvkFfkBeDRDeOnLon+GWUn7nOQk0RQuTqTAH6Hao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723603628; c=relaxed/simple;
	bh=+XSQP6JjRisu6j+WPBg6o/c6mx52smfB/O54cIEbdwE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NQT/xwD61xKc91Nv1agM0b2+2W+O0GnlJH3hKKMwvt7ujWVXViaWWR+Z+GB/MlJisoWzeb/EJ+lm0XdCOqRuHB+9+6xl5tJKtlNcZaJ0VL5+wNBfRPbK3fmtDOrHq+Dpl1R4hBycGzQbIVUyxs0PuPSotThSOLIvJnBwUc2RfMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=YFWlQEIl; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="YFWlQEIl"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-7ae3d7222d4so4263013a12.3
        for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2024 19:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1723603626; x=1724208426; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HndCF9glIkOMUvWq/mEOxgU2lZeOnPtNB9Xnwe55q3I=;
        b=YFWlQEIlPEvEWs0LdGfHHM4fN5ynFFJBk8v1jaZnuX5K5gT2mZtwj+CV34rQ8lFYT8
         pJ4JDvB2JuYI0ogyER/u/NmiAtvWNiV+K0q490ReT5TPyxyCBkPVTDvGUKMNwW+003fe
         Nxyfr5Q6PqhRG3aAFoad11jOWKeG1fIEhYP8R8zKo6fKVPSb1Ftx8ifk1yifQkhRFnuV
         oMIqlKymMo2xs6W1LeLV0pjKMsWZSc7fxCETKBsTFO/gnxyV7MtZsW52zIL2NeMnxv7G
         0/A84dxRf50jgYW1VF6ZdGKNQhXqJNFNxl2g92SLH8kcnmeMDZUxNa0OqJT61M0R9Se2
         H94w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723603626; x=1724208426;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HndCF9glIkOMUvWq/mEOxgU2lZeOnPtNB9Xnwe55q3I=;
        b=RYfCt2eA68U0gnMNVz4fNAzKZkJCXNuW8czjIGxK8o2y/o/18bJXe9v/JG9CehDiAu
         5pVlkAJUnmFG6YYRe3C6cbBInRo1KyHB8fm9ntDsIfu4wBvDENRa4zsJfXBEsZIySxKU
         Pzr/v+W9JDoDNPaxuhi2L9EySsJfpUxSRso39eoUNfrtk7zoS442kcFPaS6gJ5BP+HQf
         MfiK9BSl4W5aemdYpny9HJZDQ+kd1WEpos9XPav88E8oI7iDcpr+KENPFJ2rav4u7wHX
         KVI2C/am7+Xg2w2spEPphATpjceeSix1MCICb5ertswGA+lG+e3bPEhPTRK9FHp3AOWt
         AhwA==
X-Gm-Message-State: AOJu0YyC+edjamG/1pB9h9aId5DSt4Vjyio7LbaKOkQr4iqYx/2NrWa/
	Lcvg4I3tKoUZjiRbtLYRBd4cA4WpwKYmsgcg2rUOMt587c7KSmC86BWSoYFaaKQ=
X-Google-Smtp-Source: AGHT+IHp+5SEOXnqyHBJUu8nZh2c1nW001BOSSG1PaVG7oaO5Q+f5qABUl3n1SRexvQ5+uArfDwtLA==
X-Received: by 2002:a05:6a21:3a81:b0:1c6:f043:693f with SMTP id adf61e73a8af0-1c8eae6f47dmr1952825637.17.1723603625970;
        Tue, 13 Aug 2024 19:47:05 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201cd14de23sm20058735ad.104.2024.08.13.19.47.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2024 19:47:05 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1se42R-00GJdn-1E;
	Wed, 14 Aug 2024 12:47:03 +1000
Date: Wed, 14 Aug 2024 12:47:03 +1000
From: Dave Chinner <david@fromorbit.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, djwong@kernel.org, hch@infradead.org,
	brauner@kernel.org, jack@suse.cz, willy@infradead.org,
	yi.zhang@huawei.com, chengzhihao1@huawei.com, yukuai3@huawei.com
Subject: Re: [PATCH v2 0/6] iomap: some minor non-critical fixes and
 improvements when block size < folio size
Message-ID: <Zrwap10baOW8XeIv@dread.disaster.area>
References: <20240812121159.3775074-1-yi.zhang@huaweicloud.com>
 <ZrwNG9ftNaV4AJDd@dread.disaster.area>
 <feead66e-5b83-7e54-1164-c7c61e78e7be@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <feead66e-5b83-7e54-1164-c7c61e78e7be@huaweicloud.com>

On Wed, Aug 14, 2024 at 10:14:01AM +0800, Zhang Yi wrote:
> On 2024/8/14 9:49, Dave Chinner wrote:
> > important to know if the changes made actually provided the benefit
> > we expected them to make....
> > 
> > i.e. this is the sort of table of results I'd like to see provided:
> > 
> > platform	base		v1		v2
> > x86		524708.0	569218.0	????
> > arm64		801965.0	871605.0	????
> > 
> 
>  platform	base		v1		v2
>  x86		524708.0	571315.0 	569218.0
>  arm64	801965.0	876077.0	871605.0

So avoiding the lock cycle in iomap_write_begin() (in patch 5) in
this partial block write workload made no difference to performance
at all, and removing a lock cycle in iomap_write_end provided all
that gain?

Is this an overwrite workload or a file extending workload? The
result implies that iomap_block_needs_zeroing() is returning false,
hence it's an overwrite workload and it's reading partial blocks
from disk. i.e. it is doing synchronous RMW cycles from the ramdisk
and so still calling the uptodate bitmap update function rather than
hitting the zeroing case and skipping it.

Hence I'm just trying to understand what the test is doing because
that tells me what the result should be...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
