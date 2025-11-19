Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD912DAFDB
	for <linux-xfs@vger.kernel.org>; Wed, 19 Nov 2025 06:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763534475; cv=none; b=aNJlZb2KQviXr4FGiNUEhzbYOpCIlUPVmTIRimPel+2S+PHeup7/ZwDlMMw6on7ITzMQT1AgFlZ4jBWra9aMS16JBT8Y7oOW/CppEPJJs497gldiyhJfGRvSkqewl+8nTgkR/bFObw7hWtNVNXDW3Oid3BNVLXCNNKglNGBRTRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763534475; c=relaxed/simple;
	bh=MNlxAmLgawovaMhiSoY6dvGO6cR5f0XXs71s8LepdpE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LlRR5oY66Ljs0UpaBCKal1a4fqENw9o4B6EYei9wxx01KbXiIrpBmt4LxXPt2KdzF2dIs/F3eg7JoQgQRAiaqvCJh0DagLuRS3TX+BzFw77tMYRql0gwmmkLqsI5df6zR4QQOL8GvVrmBCdowwz66AL29mnGDpvyC21fmd8EFVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=3AiTdteO; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="3AiTdteO"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7aace33b75bso5832359b3a.1
        for <linux-xfs@vger.kernel.org>; Tue, 18 Nov 2025 22:41:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1763534472; x=1764139272; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4ox4Jdqw071Aow8Vgui5YWFKHX9iaB4/6AjiFngL540=;
        b=3AiTdteOeEt4iamiDfw4fYr+hf4gbQQVyj/5Q+xCM4uBaSXj9pRAEjz8AW1wiFm9uX
         o/db6VukBNWgUN927nU73wkVIqY3cPfy+PocKfAXNQMC4CtVpLhxPXS++872dFLyCskw
         ueVyPc2A2pIJOmidmKqSN3pYm+pnGwpeyBRVtgQDPMvE4y9FcpXfatXWESabAfAepilJ
         2hfAOUwRb4VlsaxluD9rG2h0UJnxUoYD5fcK2Hn6m0Ec7acyW6VlXe3/wO/RMvNMx0ag
         amNmMeHQ6iwqMGfiiyxmSif7gq9JJ4G2hANL3EwR2rRb7k2y47hstvqOiGnhdxIxgi54
         OUFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763534472; x=1764139272;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4ox4Jdqw071Aow8Vgui5YWFKHX9iaB4/6AjiFngL540=;
        b=OBKuVE4+Rn/qB8YJnetqUq4AAVZy8dYcvbQ6iPr8owYJSWADDIr/3hz/Y59YXeZ606
         fsdh61I57J9WAJGzQ41dmqdmnj+Prx2wqXbM3uD6qnn/KYtxQrwEkytzW1AGoU0MMm3B
         OaBC7IFWJw0qEMmuws28F36iahdMUYjNR2YmrHo3FOXAWbiLfMGyiHmD6zLcCbbgrP4d
         S/RIKqBYrbwkACqg/1LDE/0zWN5o4SucyFqurCKU8z08JmH7LJtsgehF/CyVSSjIngRs
         lBZ9rdGMpHN4CPI25MwgvOJAbxpYE7L+xW9/jRGPO5rtg6mnIy7Z2DQEUh2ECUmx7hZq
         1ETw==
X-Forwarded-Encrypted: i=1; AJvYcCVo7Is2uE+9vsYftcI+1xb5H+4Uo3JM13VVjEiQGXd8Hy6v2nF1ZSzZXepZvQE7EuvQBa2MO5QS2Os=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwRLT+E7qTYCbStLfzVO9RLBeqEl7gN6R7XFQ99ydYfMdOPSf9
	j66ySSljc7tTBgrlMA5qmSGwVbCjaHy7N4ccBwD4q9HbTw2uW6U2h+DQ0Lwav1IxFtU=
X-Gm-Gg: ASbGncuFPiE9tQntncTbt/fqCVRMxCJYXxCaQt7NhhpdrWSJDs1JhyRGHpzQN8iwRGk
	Yvb5CVnuQUJW9wB0XLV/BBC62NLP0X3kjT7uCXcKB4S00HywWI7wbdGpj1l5Jfxa1FyYd2p24NE
	TThVud4TLK5ADJWpk76bJRiZbcqMf/zLo8Y4CojZRQJ1630O8nSJnbl69WjvXZGsIuTnIPCgQNk
	JiqDFpYgVSZz0094SbQtNHBvO9JFkg6G0kFArKTg39vU/hbhGhubQY/p3D3KxKGHKp2tgKzs8fZ
	tBWT5Kj9CsZ6TG+rNdbFxlxsVqWGNBar5wnxa/vgU1x/d2ev9ogoeYj9JZmeQyXu/bLWrVeXAvE
	BQ58agUGImeog7Hq0hF1brl74NH8SNiBL+EzROECW/sB2GSfal8DbTrbtFLwYRE69iMieM169nc
	8rNTg1BCkMfd665oF98aY+Vf24aD/tU58AQVGUF0fYRoenYmoLocexSnK8kLBIzg==
X-Google-Smtp-Source: AGHT+IEruiAirTHdnAOhENqkEjN/7Ew6b0s0+dDkYqDV6AhWrMGH2r3cUUQZIT9qBcgrazwzINNSdw==
X-Received: by 2002:a05:6a00:94fa:b0:7a2:84f3:cefc with SMTP id d2e1a72fcca58-7ba371d36cbmr22709655b3a.0.1763534472332;
        Tue, 18 Nov 2025 22:41:12 -0800 (PST)
Received: from dread.disaster.area (pa49-181-58-136.pa.nsw.optusnet.com.au. [49.181.58.136])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b9250d24b9sm18450140b3a.17.2025.11.18.22.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 22:41:12 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vLbsL-0000000CmsE-1Mly;
	Wed, 19 Nov 2025 17:41:09 +1100
Date: Wed, 19 Nov 2025 17:41:09 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: =?utf-8?B?5p2O5aSp5a6H?= <lty218@stu.pku.edu.cn>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>, cem <cem@kernel.org>
Subject: Re: [BUG] xfs: NULL pointer dereference in xfs_buf.h: xfs_buf_daddr()
Message-ID: <aR1mhcGvS7yxCG-R@dread.disaster.area>
References: <AA6A7gB4JrG-pMrNGmqTzap7.1.1763463974419.Hmail.2200013188@stu.pku.edu.cn>
 <aR1eeeCKE4AJSKwL@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aR1eeeCKE4AJSKwL@infradead.org>

On Tue, Nov 18, 2025 at 10:06:49PM -0800, Christoph Hellwig wrote:
> On Tue, Nov 18, 2025 at 07:06:14PM +0800, 李天宇 wrote:
> > The kernel reports a kernel NULL pointer dereference when the sys_mount is called. This is triggered by the statement b_maps[0], where b_maps is NULL.
> > 
> > This bug was discovered through a fuzzing framework on Linux v6.2
> 
> Linux 6.2 is ancient (Feb 2023), and the buffer cache code has seen a
> major rewrite since:
> 
> ch@brick:~/work/linux$ git diff v6.2..HEAD fs/xfs/xfs_buf.[ch] | diffstat
>  xfs_buf.c | 1651 +++++++++++++++++++++++++++++++++++++++-----------------------------------------------------
>   xfs_buf.h |   96 +++--
> 2 files changed, 768 insertions(+), 979 deletions(-)
> 
> hch@brick:~/work/linux$ wc -l fs/xfs/xfs_buf.[ch]
>  2132 fs/xfs/xfs_buf.c
>   391 fs/xfs/xfs_buf.h
>  2523 total
> 
> so I'm not sure how relevant this report is, especially without a good
> report.

It's not even a buffer cache bug. Something trashed a buffer
pointer in a btree cursor and xfs_buf_daddr() is the first
dereference to trip over it. It looks like random memory
corruption to me, so unless it is reproduced on a TOT kernel there's
no point spending any time looking at it...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
