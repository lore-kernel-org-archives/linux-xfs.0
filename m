Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB153B19BF
	for <linux-xfs@vger.kernel.org>; Fri, 17 Jul 2026 09:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784279880; cv=none; b=feUwCizMPwZy+G8TZKIvDGLc22/fIji8ujsnKNay5fn3UIGy59AWsb0RIVUpN1MKRe7UNXJxENyobTFbHDdY2eLtSxlYjZ7K5fqMMVKfgjN+tFUTIIaEnlRUX6WrXXUSfAXA2UMD0pswgMty+hM8D7EUsqQIQzrCcInBxmoTzHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784279880; c=relaxed/simple;
	bh=j1d4OwHSC24RZ3PCDiL6zO1EGGo53he2G+xgKhAUJ+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=If9TkHXfs6ehbuDZuaLa8la2gqBEqVYr52Z8j60k+VZhHyHv4LcjsII3YtrwPtRTZuCtZntHQBuL4lFuNVnB0hvdm1b79L+bvtlsdvBNt9Yr2DaGYQyx4qJknYY/242iXC5++HugTS/U1kwQQzB/PqfWzc/euk/zYN3E0A3VSgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L5irfKZJ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=jbld5qWJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L5irfKZJ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="jbld5qWJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784279876;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aGkiWf6l8Chxi56rGjAcZp5qaksvTw1+70Wj3aMFidM=;
	b=L5irfKZJc7z1TX5h7XEPWACT4KfB6brBeDSVmuoXW8DbhGD12ocuZ6t4hr4uOagj3bVqTC
	NPl+vD5FXwGKJrkqML6VuvtORNKcQprVli3v48cKLDpiYURhoWwoH+3Fbu5edQw8Cxme5Q
	Le3a1WPN7bvzA0n7PYIi3Gv9SeDDB68=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-339-KolOJqvrNjKG52FkE7v6-w-1; Fri, 17 Jul 2026 05:17:54 -0400
X-MC-Unique: KolOJqvrNjKG52FkE7v6-w-1
X-Mimecast-MFC-AGG-ID: KolOJqvrNjKG52FkE7v6-w_1784279873
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4954a93c565so2620855e9.2
        for <linux-xfs@vger.kernel.org>; Fri, 17 Jul 2026 02:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1784279873; x=1784884673; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aGkiWf6l8Chxi56rGjAcZp5qaksvTw1+70Wj3aMFidM=;
        b=jbld5qWJnTHc2D+/1lkWwqFCf9YcWGwMdpeeue3yJvnURQSgmDu3u8xFrEtCuLE3UJ
         5GqWUIQuqtdnsjjdAdKi3GS3CYfnSS76XvPM3sGt01nfv9AGhAq+cqOgJwsJuOom7aXM
         6GG6KMGUEjGKobA/E+xXflcc+zST7vpEfaj//apHCZFidxg/uWE+1MqjjdqmjhyEi9oi
         7ajqEYBi/eZS+JwtxYOJhLJDdRsvRsSz2equl1SOp3UGWCg3oRt83FO5qFN7QG93t5+u
         zyFMeZa0zTcsbjUOmxCDQHC1+ygswKUfJKAcWMLtjHPOYWIstpd8mx8xZH5iwbDdHjav
         b9kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784279873; x=1784884673;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aGkiWf6l8Chxi56rGjAcZp5qaksvTw1+70Wj3aMFidM=;
        b=lZ2xQJmYv5HzRIzhexXS6UgBUECMxLv928UkQwEFVHD7IvcY5yIzcAEfdy5pmq9aI2
         IWJtR98d/7cp5A5gCWFyMQGAjT+SHm21JhF3b4En50tcyuh5FFtNdgyQcgQTmCm/lbLe
         oHp1C4YlSsIqnzaTMWWCppVEueH38aBp5PwmaqCinosfj16s6iNyv8t+I6dOaihvY71N
         e2GF8uS4xpcVzlRvY2otGtcnLlNacS2BpF9Hr8nBETMlusJ16wYHz4Pq7jr+CU2yKWS8
         Kkw8dqkjGcOcieZI6xcVviSI3I3HbRYTZNMfJsvQAbhE3ynh+cG5QFpdix+p8SBUHq9F
         SQfQ==
X-Forwarded-Encrypted: i=1; AHgh+RpNFxaLVU0Z9XB17tZ/JkcdPiN8kMBzuiesNUn8LTvw/1gb8SWo4K7eZTTGDw0vkteKp+A/GzuYD3Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwN+34J4Us89ddisWxMWcT//T3FvY4dDD0smP1Mq313RvWORnXI
	dZelR5MhtPtxFwjKNCjtQOUFYhXOAj+5gWQ/Cco/yzQDG7JsPt7QNAoOt3mL2caS5wZ4cfRNeN2
	V4mk6p9wujS2r5cVxblS7aO+ScL8gHnrQekcD1pJixuwyVkv0GBmZQaXTW/cp
X-Gm-Gg: AfdE7cnOTfpBQbrvuWr0/bWjJqBM5p3RwqOEWk52CZgHqELvZ7YwfRHH8WfDgnpxJi3
	zFwInHijVci5RIz7dBhqGRzWFVYOeko46ALJBytdZKo72+6lysMD/4W1UC1upr5ax0yPJGKcfkD
	R0BUwP+XPC+Ql7lJ0CJeLbOELQIb0WI7M/IXudPIbbT8hEiD2zz+ZYsHfVh66FFX1Iwkf5A2ASe
	giEnzVsQ8KfH1wVO4DPg8HzHMf136OPyiXbRBAWOylbwaGMLysboc9Bx4Ar6G2PpGnGv+XQbvwa
	/MSO7Pxljjave3nUTMUrYhuKu8iQpltCbmll9CpZfkMg6KVXyBAVUyiH6i43Fbl7u/U7QG9NsBt
	TwHxdUFWX9LZrhs4fJtd30M/kxcwCEyYvIdw=
X-Received: by 2002:a05:600c:3114:b0:493:f5bf:4dc6 with SMTP id 5b1f17b1804b1-4954a3ec720mr19148465e9.7.1784279873253;
        Fri, 17 Jul 2026 02:17:53 -0700 (PDT)
X-Received: by 2002:a05:600c:3114:b0:493:f5bf:4dc6 with SMTP id 5b1f17b1804b1-4954a3ec720mr19148035e9.7.1784279872753;
        Fri, 17 Jul 2026 02:17:52 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-495499f3f99sm32835045e9.0.2026.07.17.02.17.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 02:17:52 -0700 (PDT)
Date: Fri, 17 Jul 2026 11:17:51 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	djwong@kernel.org, p.raghav@samsung.com, rallenh@hotmail.com, yi.zhang@huawei.com
Subject: Re: [ANNOUNCE] xfsprogs: for-next updated to 2525ce2aa93b
Message-ID: <alny-dR51yCdFb5j@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <alnttbpthqqEdTJQ@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <20260717085701.GB31819@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717085701.GB31819@lst.de>

On 2026-07-17 10:57:01, Christoph Hellwig wrote:
> Btw, do you plan for a 7.1.1 release with the installation issues?
> That would probably safe us a lot of complains once users start
> trying to build it.

yes, just prepared it. Will send it out soon.

-- 
- Andrey

