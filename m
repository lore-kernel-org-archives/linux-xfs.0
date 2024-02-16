Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48FF712F588
	for <linux-xfs@vger.kernel.org>; Fri, 16 Feb 2024 16:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708100328; cv=none; b=VvWYoHEqK6X/+lavf8OspvgQIVp7EAGFDW0+mH9NCT6wec0m3uf8Aa1jRUDL/LeVmpcdjayOAnmW+tdfBAjSloXFkmmWX2zAqlQlfBavc+i6RpGUNL+YuAHqDVN9pgCY6Ni2fu0sK/9wsEmx4xKL4o5mYLCJyfqRYPVVle/B2Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708100328; c=relaxed/simple;
	bh=oAIAF9jWPO0acrS2NbTV0zUQvpgImhp11qMZffcY4E0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mmx1WdnTGQQJVXyngSJopQyHHcSD+ON7XrtolT2kdgFa7BQsLu3dYOZBjuG0bhhd37qE93PUGQSNJTS4TZn0VX9WYxqZT5tarA5G3NDsBer+VpHTNvDTCkzYelc7R9rr1m0alz7RFTK4UlN+D7vthwwTv56mytQhs+wRVV0GBFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GvrH7GrH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GvrH7GrH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708100326;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A2YIpXUrLBVFDjCdRtbxFdnmZBsfcrvCwPfrXnzyGhY=;
	b=GvrH7GrHimgsGw1gdGTgOsy57/zrh+bDrUBkohCQT4s+26P6b+3XXidvKRTMndfuh9pKBi
	qSE0TcOL6A9Mx5/2fXFU6EqDcGmZroe2yUBNzPF15DCG60Wn9VXx53gd/zgTH/u6p2CB+q
	TmNq0AQO95LJSLmvD+x+Izt7NDqbJd4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-MOkomwcyNnyGoQwwXR8F2w-1; Fri, 16 Feb 2024 11:18:44 -0500
X-MC-Unique: MOkomwcyNnyGoQwwXR8F2w-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-33cecd335b4so532037f8f.1
        for <linux-xfs@vger.kernel.org>; Fri, 16 Feb 2024 08:18:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708100323; x=1708705123;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A2YIpXUrLBVFDjCdRtbxFdnmZBsfcrvCwPfrXnzyGhY=;
        b=SMu/KtKxDy0aqPpuq76NZttQ+SAQxf1qytdrLZQWUHiLGHzDiQPK1WO9iERHzVEE1Z
         sboxPRWb6pl1FY5A6JJ/JBCranHy64MHojsJEKU8nbg6GkTRaCWRbTna7Qw/T1INP+KW
         OPtE29JTn2Yu5o5naLcRRqmi9qF6zzH6RwcrQcHrg+Yrk4Z9wPOBO7SdymfAUTvMQv4P
         v79j5WcZZE/GMxpgcK/p6USZoX6B5iCDaUmNLfNBMgaPR2OZzB0XeWVfzNicNjxkDlH3
         U7P46+BFQaqDxL55KjZQ8EV0+ZIurAa8Co3p6vzzhDEbWG8KU0Ugl8y3jYnZoyMY/jBy
         aBQw==
X-Forwarded-Encrypted: i=1; AJvYcCW/scQTTjZKyIuHLYog7aUFArWuY3UhqGBSHfr60NKiff66bbD+Arh78a3qzvPxkEr1tnLhlhP3dkkSI8TdX3CX72HSNhCKxNaW
X-Gm-Message-State: AOJu0Yw85spK/bZtQ66U8PwvGfpbvBvgxfXyrOwOts4Qvr0zYZWXof26
	oLxJe9iWGse9QV9pAxvFLpmh2WvRJwk24DDeEzNFLEP7lEHwob1UGe3dqGevpsWzcWMEO24S5+p
	fOJhzLOo6jtImM3ejoM8IhnONjMnw7yS3vj7tuZvqx1ShRn834bNkO3Cw
X-Received: by 2002:a5d:598e:0:b0:33d:f35:d2b0 with SMTP id n14-20020a5d598e000000b0033d0f35d2b0mr4485885wri.60.1708100323276;
        Fri, 16 Feb 2024 08:18:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG24xD/qEQngS320sUxhv3KFD9tZJkUH2ncwvgXi9rTVBThj3r4tNaTBSA4BLAcsH8YxzEfbg==
X-Received: by 2002:a5d:598e:0:b0:33d:f35:d2b0 with SMTP id n14-20020a5d598e000000b0033d0f35d2b0mr4485868wri.60.1708100322935;
        Fri, 16 Feb 2024 08:18:42 -0800 (PST)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id bs28-20020a056000071c00b0033d247309a9sm1079418wrb.12.2024.02.16.08.18.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Feb 2024 08:18:42 -0800 (PST)
Date: Fri, 16 Feb 2024 17:18:41 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, chandan.babu@oracle.com, djwong@kernel.org, ebiggers@kernel.org
Subject: Re: [PATCH v4 06/25] fsverity: pass log_blocksize to
 end_enable_verity()
Message-ID: <sh4gfd5ajjuryg2yqu6u6mpqlpuyjsas2axvzs3xli5gc6xb5f@b5r7urrxxn7b>
References: <20240212165821.1901300-1-aalbersh@redhat.com>
 <20240212165821.1901300-7-aalbersh@redhat.com>
 <Zc6GDNMj3gAk20nc@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zc6GDNMj3gAk20nc@dread.disaster.area>

On 2024-02-16 08:45:48, Dave Chinner wrote:
> On Mon, Feb 12, 2024 at 05:58:03PM +0100, Andrey Albershteyn wrote:
> > XFS will need to know log_blocksize to remove the tree in case of an
>                         ^^^^^^^^^^^^^
> tree blocksize?

Thanks, yes tree

-- 
- Andrey

