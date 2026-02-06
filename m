Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593E723183F
	for <linux-xfs@vger.kernel.org>; Fri,  6 Feb 2026 22:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770416833; cv=none; b=XPk+wPUZqHkOWCn/4fHd2S8LuO9Rqd84WeZq5B6FI5P2G2jQhHndepT9Oht2s+hjgGaYD64tXQo14SumHPvDT2k9ol8nQH4YBaSC99gC8OHbPEwFmsknF+VVXUmXPs7jQ+W6ObfFgSVPOSbmz36WrPE3W9OL8NsiQ8nJ8n2DLnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770416833; c=relaxed/simple;
	bh=E+R9VnH/5nYvRH0t2JT7uiax3xd2qSeKJYS9J3oV0PI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dlfc/LQZhiCuCdtVpxe5ohYZHszAbc3qlqlCnxqCyaJR1P5De8UcY3YcCp2X/d8TEisehZq1pRSIBM6l7wEpU8uTYHDFwLoEzKXtRPTFkQJ93CWor6fgcLGGd/0Q+EZudMB4CmYiAg8cfL9r3YW+gxLZGvWWV3rjdqT0PezXeE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=2mkDFL/d; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="2mkDFL/d"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-82310b74496so1355778b3a.3
        for <linux-xfs@vger.kernel.org>; Fri, 06 Feb 2026 14:27:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1770416833; x=1771021633; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ePyEeKrzpfMJEGi5Q/BT3mifKnjoB4/x3Gb6lbNEHiM=;
        b=2mkDFL/d3s4wSvpZ3ElbsW6bBKS1xbrFmS8Nr5uxPZAsJkYdbRoN5Vzo7VT+aD5YgV
         rPcVWdHG9sMBgx1eEsBi4mpHG6pd3vgYWMQ+ifQj8dymEY9KEAaT4kDGZpqZJRbxoeLD
         sOR+POfQJghGHC3ewpFKuIw9nI89ahMwMR0nw1TSB067tzUIEaSYMwPO3A9QmpndKWB8
         VoR/dHVE1x6suSWVC2Ie+pRPyQzmLN0vzzVo7li/1JVMQATpF7YYYeX++wVkqe5go9z2
         aXOt/aDGE2lgYYwaAsA0mxb+CYKSD2DaWU+ITX71HMbCPjs6SYrYvdm/MS70IFxph8Al
         zOgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770416833; x=1771021633;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ePyEeKrzpfMJEGi5Q/BT3mifKnjoB4/x3Gb6lbNEHiM=;
        b=atNxywcGwKC042kwvHP6zO7fZS8acgZRkKyjTS66t5JG0jDacYTQu0Xg9uqxrw38vU
         Bnu6NfgdH9Bgip4RLuxXw01YGC2KLSXH41LlZoYcGZC2jfhLzT6ShiEIRv9iWGDr3gh6
         72JtDU3toJlm3ec615DVnAx21hpxdZ7gpdOrhXQOmO0J7VrGWKV5+sNrDldkwmqUbvib
         BtZwaUhDU5UyRwcSX1PQcLUJ/j/1Y2hiXMzrJfvhZ6o6wpuwKaXlj/Srx2vDT2WWakA2
         925c0SKqIHpgS0fCDxrAAjlyRSpfotIl/7+Vc19IWoCBgVXWch+886MJ7g9vGl3y3wMp
         CAJA==
X-Forwarded-Encrypted: i=1; AJvYcCWPG+BMWTj7yWDC6erbtBJ4bg0rpqECtNO5nlJ4kFtPU0s2bJG7rLmSgFhcpHcdz+xAmbwTCv++tjM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yypa/igADPrSmAyNgW/7+fxrmKyj61hWD3/WSu8atLZjMJdt5MJ
	TZWk6UxVJA477AcSgIMAEUuC3ChKzQS3DBWEvKXDPodh8s2Ri3/2Xv0dHVGA6wl/5f0=
X-Gm-Gg: AZuq6aKp61zd6kgpJ4CBmsbh9PHl/BY4f+advWrA3EQyr86uk6c77qQsZmejSc83dav
	kM9AWEfIQtvR3cPNiJmWACKpjA3TXzWb/W0UOe7LR9W7sxK95IKhyABYyPkuSxfUZrJS1+vu4EX
	Zc4rokcmVUw8K6NhQUMl1uQZ+idPT6n8yCecfPD6aFq65QN2iP2O9lxXwkWxU589AitTmFt40nB
	l93zL3FJfluMINCqufA4rUGGHp2xoSATsay3fi3bhPW2fXJKhUwd3RvzFwo/YxeRi0B9f0vx5vB
	Vmc29BeVETF6bPpDeKZUTHFTZvbdHOfUJLmjUYGoUviqV15gWC6yd4l9+Xj6OAO+anWEYylo5zU
	zlC1k/IBW0zhIG9P7gngZ7V7h4aL34+PT22LgLAn1M1WEwU/aR+DI3MkGcjc0vJzRMmqQU79ufB
	vgPLoZ+I1j4cHLRsuwVTn/jbWQMTWK+pKdZi+0SX3rmzGHuSEdkn+6OMwxs6JK/LCt7DOUCwDQH
	w==
X-Received: by 2002:a05:6a00:1790:b0:81f:49cc:ea11 with SMTP id d2e1a72fcca58-824417b8d66mr3640903b3a.65.1770416832498;
        Fri, 06 Feb 2026 14:27:12 -0800 (PST)
Received: from dread.disaster.area (pa49-180-164-75.pa.nsw.optusnet.com.au. [49.180.164.75])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824418de80dsm2939362b3a.62.2026.02.06.14.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Feb 2026 14:27:12 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.99.1)
	(envelope-from <david@fromorbit.com>)
	id 1voUI7-0000000Dt3m-3vc1;
	Sat, 07 Feb 2026 09:27:07 +1100
Date: Sat, 7 Feb 2026 09:27:07 +1100
From: Dave Chinner <david@fromorbit.com>
To: Wilfred Mallawa <wilfred.opensource@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>
Subject: Re: [PATCH] xfs: add static size checks for structures in xfs_fs.h
Message-ID: <aYZquyDjPqZIcKe4@dread.disaster.area>
References: <20260206030557.1201204-2-wilfred.opensource@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206030557.1201204-2-wilfred.opensource@gmail.com>

On Fri, Feb 06, 2026 at 01:05:58PM +1000, Wilfred Mallawa wrote:
> From: Wilfred Mallawa <wilfred.mallawa@wdc.com>
> 
> This patch adds static size checks for the structures in
> libxfs/xfs_fs.h. The structures with architecture dependent size for
> fields are ommited from this patch (such as xfs_bstat which depends on
> __kernel_long_t).

There's more than that.

Different architectures will have different padding, alignment and
holes for the same structure (e.g. 32 bit vs 64 bit) resulting in
different sizes for the same structure across different platforms.

This is not actually a bug in the UAPI - as long as the
architecture's userspace and the kernel are using the same structure
layout, variations in structure size and layout between architectures
don't matter.

IOWs, if these structures checks are sized to pass on x86_64, I'd
expect this change to result in build failures on various 32 bit
platforms....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
