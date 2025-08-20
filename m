Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47A2256D
	for <linux-xfs@vger.kernel.org>; Wed, 20 Aug 2025 00:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755648993; cv=none; b=RVkDG5HVjx26KiFTCzWqh8nzbrcuDTtsfabOA3+qJOkRoMz2aOEAHzOuPprfw25xj++b4RYjTrcae8ySBxzyWvjn2vHiwatZErmy3NnoSAANP9sWuUoT8Znjl5RhJHq8IVr9Ih99xPxS7FiouLTaZ0u4B5f4UPUmgqi6CTHUCHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755648993; c=relaxed/simple;
	bh=GDvADdeqxjdKyATgnnevu4e7YoIPfWPOHk7+2ewnUYc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R8IuODHvXWwtQEbrTqAranXzFXzmh22gT5npWcv+oLnBIgFDldgAEgDMJ4MgcfF3h+vAmPa4JqywyC+JvksMTbevkly/ioNnWEtvdor2HrL5kobzYaivxc0fbn6hkaMm6wgAhi7rEWsC50Qh8y0UYfqwdXqTaYVIZv8icXtNLZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KyIqdava; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KyIqdava"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755648990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zhCdA4IvAz0+fhnpFxV1YFQvf/0ftVh/ycxxwzlfWB0=;
	b=KyIqdava1jxMiJHSZDP380YDYbsSPmnSngE3EPYpA349a0j1JWmdW7+0/tIIbL38omA4WJ
	ipzlMYab5qt3ZGKiNAjH7rFrB8U0vBf9+M4U0A995M6SpbYYxjsKy7j/yl/FdC2ELkFNU7
	iOShoYGS5bn6HmQ7lRO5uujGOyg+E70=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-33-N3mr11CDOI22gXbfqeBV3w-1; Tue, 19 Aug 2025 20:16:29 -0400
X-MC-Unique: N3mr11CDOI22gXbfqeBV3w-1
X-Mimecast-MFC-AGG-ID: N3mr11CDOI22gXbfqeBV3w_1755648988
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3e67a51f6b0so21138955ab.3
        for <linux-xfs@vger.kernel.org>; Tue, 19 Aug 2025 17:16:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755648988; x=1756253788;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zhCdA4IvAz0+fhnpFxV1YFQvf/0ftVh/ycxxwzlfWB0=;
        b=urvS8s1RLGbTxxHSEnLaS3HeiLE5/KbaBfr/21FHg4bZSq4b5lCN1oOxOh5zTVkR7g
         2OHtO8DppMxXDb810/BZFtlB5h9P8ULBghMhFyw4cKParr9VxzAzk/Efwp0er7/8CPD0
         cbqIMYf+fya3ymxLxrkUDcLxue7HyFcugq+KI/DXi2CHeWbrV9fH8xrTwGd8sZYuncVv
         G78lbkPZE81bKUSIM1jp/6H0OxhKpJKfUGMCzP6kXfZXuhaYVr41dqlPHpwHnxn3ww07
         87z+WyqfvYdYQlLq1Ykl8VDgjNVY2C22N8Q9OuZzDy4KhEKmQzFGpYx2jcLW1ESwOj1v
         ILpw==
X-Forwarded-Encrypted: i=1; AJvYcCWiDfngYOIvQfIhOZ8c/UQpS/uHQQfB6OcGYrxM0mVKE4QU5bZToKUULLiZrkZkAJCX9s3Oc2beT9I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzr8Oq9kW9bEADsYCNCQCwB2aldo0gCOPMaNR6wQF7GenjNmtou
	7wzR5LtVjc3HJcXEdIuMU1m6gDjnX5Whi2b1xWcMiG/c9Qh3BK5bxaLeWwJT+BX7g0TtVLkScAO
	0R9EqxW7c32bNF3RJ9bUH+V+hqG2fckMYwa9GemGFqNp2zyF3TDMvhLfce92DFQ==
X-Gm-Gg: ASbGncuY9DZfzY+ZHJC7c63r2MXuhJU2gixHS7QfyNpqtwg83qMUNY272fW5jpKewYx
	BJk7UZA6Qk/bdSJFFQO7LA234iH7KjgHee09IjZE3k5qtyNF1om3xhriIQtJDs7lwOu2PE02kSj
	HpLa8wu/7lGio7zjHZF9tz4GPh+gvEMOEhNcBL2eNsSvXYcKxvgXV37YLtk/gcCoza27AjEXkpo
	5WnKAKM2BkriW53Ga8IomaAUZdcA85HVqkDsS1KG5GAy3I4Mg556U0ph3Rb6jq4Wtr7UvyQS3XO
	kGDfocJLmWh0hhdj56Hsdf0D7LHR4wRdfajdGaZXHqzSZm9VsjDgFei1e3tKg/NAkmtFRAK5DK3
	R
X-Received: by 2002:a05:6e02:1b07:b0:3e5:7c6d:ec8a with SMTP id e9e14a558f8ab-3e67ca8cbedmr18482195ab.16.1755648988171;
        Tue, 19 Aug 2025 17:16:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFTetA2a08HI+XJ0QKI7N72THcuoB2/RJ5LLZokoTiTD10QKAIeNhQxnvHVdXSuRreBnA0AmQ==
X-Received: by 2002:a05:6e02:1b07:b0:3e5:7c6d:ec8a with SMTP id e9e14a558f8ab-3e67ca8cbedmr18481905ab.16.1755648987850;
        Tue, 19 Aug 2025 17:16:27 -0700 (PDT)
Received: from [10.0.0.82] (75-168-243-62.mpls.qwest.net. [75.168.243.62])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50c94a47d31sm3664360173.89.2025.08.19.17.16.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 17:16:26 -0700 (PDT)
Message-ID: <3b40e330-4fa3-4e08-85ef-bfd4069059a9@redhat.com>
Date: Tue, 19 Aug 2025 19:16:25 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] xfs: remap block layer ENODATA read errors to EIO
To: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 Donald Douwsma <ddouwsma@redhat.com>
References: <1bd13475-3154-4ab4-8930-2c8cdc295829@redhat.com>
 <aKQxD_txX68w4Tb-@infradead.org>
 <573177fd-202d-4853-b0d1-c7b7d9bbf2f2@sandeen.net>
 <aKSW1yC3yyR6anIM@infradead.org>
 <0d424258-e1ba-47c3-a0ae-60e241ca3c7c@sandeen.net>
 <aKTwbJvRP1PA-vit@dread.disaster.area>
Content-Language: en-US
From: Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <aKTwbJvRP1PA-vit@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/19/25 4:45 PM, Dave Chinner wrote:
> On Tue, Aug 19, 2025 at 10:38:54AM -0500, Eric Sandeen wrote:

...

>> Ok, this is getting a little more complex. The ENODATA problem is
>> very specific, and has (oddly) been reported by users/customers twice
>> in recent days. Maybe I can send an acceptable fix for that specific,
>> observed problem (also suitable for -stable etc), then another
>> one that is more ambitious on top of that.
> 
> Right, the lowest risk, minimal targetted fix for the problem
> reported is to remap the error in the attr layers. Nothing else is
> then affected (ie. global changes of behaviour have significant
> potential for unexpected regressions), but the issue is solved for
> the users that are tripping over it.
> 
> Then, if someone really wants to completely rearchitect how we
> handle IO errors in XFS, that can be done as a separate project,
> with it's own justification, design review, planning for
> integration/deprecation/removal of existing error handling
> infrastructure, etc.
> 
> We do not tie acceptance of trivial bug fixes with a requirement to
> completely rearchitect fundamental filesystem behaviours that are
> only vaguely related to the bug that needs to be fixed.

Agree, though I don't think (I hope) that any of this discussion was
a NAK, just a "there might be a bigger problem to solve here, too" and
I agree with that. I do want to push to get the demonstrable bug fixed
in a direct, safe way first, though, and not bog it down with grander
plans.

I'll try to find time to do that, and look at the bigger problem,
if I have the time and ability. :)

Thanks,
-Eric

> -Dave.

