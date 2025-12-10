Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93438306D49
	for <linux-xfs@vger.kernel.org>; Wed, 10 Dec 2025 11:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765365016; cv=none; b=noby+SngTHf7CxMfl9BYMknFUT6cCEgYcv/yZUvmScL0MEaE/Gb86dz9ZqwohfMBXtQ3Y+GmltPHag5K38aApRaws1f/9Sbh3vudMzku4MQK5HKP1RDAv/vsipLmnrWRh8/zBY9hQ1JCfKQnJq7/dzRBHUnxXARfWIQEn2Hu6ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765365016; c=relaxed/simple;
	bh=GnOKlSBZGXmZxgcXwqV2a7fKoOZp/0C0hnA0ab959uw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qpKg+DuewpwdCUpWoMMgqFn9HsKgwJLliiVn9qedpGHBwZFleF80mpMrelBN3VkL71WTxLfQy7is6GvUyNekiD/Qq8JxPvOjG2U7gDgcESziciIfiOU2M+HbDirWJBZURBrUSgW0L49SGUlhM2vxB8En7DBrzmRKcovE3vyIhyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cXq7Kb4d; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=dMJpHUUG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cXq7Kb4d";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="dMJpHUUG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765365013;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZTdf9NBDcg2h2xHZM9Og6ZlBWU9/XGdNn8Bb0lySuqU=;
	b=cXq7Kb4dow8fDWNs4DpdGzjnVIQBYzYmJn3ABQ1CM+30ku2qxxLyc/p8Bg16YEkWzJxy6u
	1kSlB6+aWaInZvBn2h9T0zxa0AND13tggjF/jaoxUontdTrBV2bXg3tIB0FVKj1rulAYkK
	SzFGYlM91djP7PDXiuTkmxD10d3Yxgw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-492-KEs9pBCoN-qMFzLxS3Kgrw-1; Wed, 10 Dec 2025 06:10:12 -0500
X-MC-Unique: KEs9pBCoN-qMFzLxS3Kgrw-1
X-Mimecast-MFC-AGG-ID: KEs9pBCoN-qMFzLxS3Kgrw_1765365011
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4779ecc3cc8so40843525e9.3
        for <linux-xfs@vger.kernel.org>; Wed, 10 Dec 2025 03:10:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765365011; x=1765969811; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZTdf9NBDcg2h2xHZM9Og6ZlBWU9/XGdNn8Bb0lySuqU=;
        b=dMJpHUUGGorl7y+DVt2CVtpR87potYFmiNI89jm8eRROrPMEDMyZDlwwCDeSoRpg/A
         iUGKccla41mnhA5ntiWHTFHuFVWBAWWncbKmD6AZcB57wQlR6nNoClbKDJNpQYPMf4sS
         ZtuXUAShoK27LFo0X4rIaAs5Zfiopm4fz1WXtUGVY/aXQlK6z88etv3+N1XKuxYgGiSp
         GAbZHfCsZEbmK6r5Wfnp+lOYXJ6MP4meno19Rx3K9+G4+xlA8CuJjssLUhXXSv552bQs
         E4W6uEyDYyzPIknClkA5RVw3RX+jP/Z8byntk/Il1Ko0Bvs2XnDgkKu3XiRgLA9mk+n9
         Wkag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765365011; x=1765969811;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZTdf9NBDcg2h2xHZM9Og6ZlBWU9/XGdNn8Bb0lySuqU=;
        b=OSh8gH1ehZ/gJEsHFGNFRuhBaB6bmz8X5JYmQQRuyF504+K5VFDOVTt0wfOcdSuuTg
         VV+BzDoBL4wo0/dwT6f7lKyRvTWjVW6Opy7rTsa7UG1F1OS2rqwx/PKxLN79IOuvoovZ
         /KWNDkYDnVPjNZllWubRkpkC5592xWR7skpMKzHZvd7wY9YqXIfV3uV8K8VmZ3tB0HY8
         a/5zo98TUekCXPkvOOevMv4NjnRfE/zIG9YjeneVGSi9LB8tzQBQNA3Z0DTZkKqVq6bF
         fI1C3nDbdOU8nzcrS31x0mUuSUJpatB3IAWfyEq+Tv0OgRpyLFIKK9FkcdJvCC10GCrK
         BX1A==
X-Gm-Message-State: AOJu0YwWVJzzPyCIDCltjfp1iA+S8Uvxk4IgSshi6tzkN5ZVKRcUfU0A
	c+T5FRnLP2+SyRFFzG7CK3ioLyLZIwWhlaVJVdffJTeoW68al1VJcACxEd1Zw5bqPo0OkxGX9DZ
	bD6sEz4Z6m3zk8+Kr+N4DPQoA6cFfqJl7HLfIF1fczgvWd3O9A1ZWebkEgSiF
X-Gm-Gg: ASbGnct9uhhNbk251hP4rPLWX3Q3kvQinmou3r3fh1pq7xw+kIFi73qrdlvC1OPsoYK
	sCWwZbG1uYFphCFu1ejmItBVVFRkXhedVScjeUvzMkwlEpGIwJwqGtOdn0Cfy46797ab/OxJP8B
	QFq7HKBePHzlh36kBATWtMFiDScm0ZG0FxMZWDBhnJllYy5/PiZLhDWGIJEjZ2d7B96jozuwXJo
	y8MwOnWpWKUB+Fo9tFOUDbzXdUIzmOR5aWPTVGmHR6aE925RUcG5IaAjv4JdsKSCohkylR98WT3
	X3VWidCIHB471IudgfxNHiPAV5hs1p+ZGpdXEOlw64RI/gD7DguJYuAZguvNaTr5Z5S4XIrs1KA
	=
X-Received: by 2002:a05:600c:4fd5:b0:475:e067:f23d with SMTP id 5b1f17b1804b1-47a8379581dmr21160165e9.25.1765365010603;
        Wed, 10 Dec 2025 03:10:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHy9w5aXAuO0/d1G6MxscVHJdgzog9OhsxJv7hcLetbtNbRzM41JgPq556ZMXZieTAqKh7Fxg==
X-Received: by 2002:a05:600c:4fd5:b0:475:e067:f23d with SMTP id 5b1f17b1804b1-47a8379581dmr21159635e9.25.1765365009893;
        Wed, 10 Dec 2025 03:10:09 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a82d1d497sm38402515e9.4.2025.12.10.03.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 03:10:09 -0800 (PST)
Date: Wed, 10 Dec 2025 12:10:08 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_logprint: fix pointer bug
Message-ID: <twgfncanrsgunjvdrijj3lhyjbemeybtjidplfxnjmjmzukchh@mhlm543xexwp>
References: <20251209205738.GY89472@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251209205738.GY89472@frogsfrogsfrogs>

On 2025-12-09 12:57:38, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> generic/055 captures a crash in xfs_logprint due to an incorrect
> refactoring trying to increment a pointer-to-pointer whereas before it
> incremented a pointer.
> 
> Fixes: 5a9b7e95140893 ("logprint: factor out a xlog_print_op helper")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  logprint/log_misc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/logprint/log_misc.c b/logprint/log_misc.c
> index 16353ebd728f35..8e0589c161b871 100644
> --- a/logprint/log_misc.c
> +++ b/logprint/log_misc.c
> @@ -992,7 +992,7 @@ xlog_print_op(
>  			printf("0x%02x ", (unsigned int)**ptr);
>  			if (n % 16 == 15)
>  				printf("\n");
> -			ptr++;
> +			(*ptr)++;
>  		}
>  		printf("\n");
>  		return true;
> 

Hmm, checking the results I also see the segfauls in 055.full but
test is passing. Is there any xfstests setting to make it fail on
coredumps/segfaults?

-- 
- Andrey

