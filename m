Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3353513BC0E;
	Sun, 20 Apr 2025 09:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745142427; cv=none; b=t7ntFSMi+GFbYmMqhH9Bn6jBmOZ13Q/deriz6cqiOuUlvw2v4mTZfWkAo7i4jLddYtBLa34e7DhX4CgrFQpqbZr7Fnqa7RSt12o52p2sYbJdgPzt6AkYKrVTf100VX2uczoTnoaHQ3KhfXLNgE/qblMYo2Xb4yXppYiLgplGBU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745142427; c=relaxed/simple;
	bh=/ZOqv278q2ZTXUneUVZ0jLxKfZSxoGlL/oJi7uf3QIs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rREb9MGE1R283j2t1yqahXFt4HdfAenu7QW5QontHXJBK+KJT9YF1VyrqukpAZS05v51Xj3JNKdSMguRFG3ld9IIfmE+PJskePICkiEBfnifjYHBpiPPSeDvNcJNCYe/tNqVsbbNilHGCqZRlYL8+0qGZ+5ujPA+k2Ton8ZGKKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QoHeC6iY; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QoHeC6iY"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-224019ad9edso45380445ad.1;
        Sun, 20 Apr 2025 02:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745142424; x=1745747224; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NwGjcfQn9dffbQqYDt/0oQtNjwiBuJchu3RJ+FcdXoA=;
        b=QoHeC6iYVKTxGODd+WubtEhR9zaIe2wKeaHMGOtAZsG1z++15bc/EdO5AgMLDoJV0m
         G9ZNSKidd8cW1K26KEMUZClDSvrCdrABZnCPPj4FeJm8WWRaq8SY9IS2NuYuYTRCYtKZ
         DVLUXStk9/em48nRADLe26lRSFP6/0pBk3AWYmGVTSCCsSPMtUnrfA21EvyDLoBdEAdC
         zpHV+T2MOktLloRfOpAQZRUVmmh07iiyTBk9nZH8LyIlqpWTV4yH/8ZquqCkkNuxjoyL
         M88eKcJa6hjIlnjNUDLRo/rD4asxlTnXSnn/ceXeZhFATzonu+thQ28mMfQ21w/E/gvN
         TsPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745142424; x=1745747224;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NwGjcfQn9dffbQqYDt/0oQtNjwiBuJchu3RJ+FcdXoA=;
        b=v6tdmRUdNbfwQOQAR1Fh9OVrZMV+17J9nAr0Ud4QrGwZdVaLZThhMcZG5v+VrX6+pc
         hmBqabBuWGr5qWd9q1Z1NFUbwAGNxQx9fd4iFR6Ivi7SYccHnZBYt12yVUZ1a9ps2sAC
         RPgDhJFmp4L8WLpwXmuex4Fi+uGLP6i2GyCCpzZxiIj2LQ8sYEFITJI76s6ArWFmEf/e
         pPRwZa6wD/3GTY443wIrqbZjX3ebgSZNr00B2w9Ek8BSOv0XD1AdwHlfG/bfoNHd4Xhr
         uj0THIUUL03dG/EAAjAbFWHX1JBTi9Pw170AnecSN49fzGMQU4E8vvFLcjNe6Uz9ra63
         KopA==
X-Forwarded-Encrypted: i=1; AJvYcCUoKYM14VaCSOt17HN7VgLUdpz+ULhn7aDR/8TD8WP9qDCJ5aFaCgA8B4Atay1m5fzYswoN0To+Z78E@vger.kernel.org, AJvYcCVEVeh3/wFF3DEG+KbG31lvEDkgj+ClQ47UpRREKwLDGVGOEmM8dEs1qwwFPlCCXYFU/GtJSLw7/+zLZF8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7kXUuUOpkVmR5PPmosPK5Kodacqf2/nLUnC60lhlYzLPhTPwe
	GoPKAMNGfX1ix7KunJscqV/4P46GV9mGWZxK3S2miVj1jP+QHBRB
X-Gm-Gg: ASbGncvirrBSLXDBy6l6tPff+6LM3diTq3DveCgQeIzGI6ZOgArb/zw5k/7eL9vDeLv
	KvhfsR0klXCFzOgvb4SDigXbBzl9JR2nleZ6DeUp1VA140LxgTSVgyFMEtSjP78QjWvrudyxm1U
	3W9DpYPViNwyUsX42qMaPk8jthRYWTEiWrxLDFZfNBysKYv3B3Dvr1VDgO7G5/qSCuZ/KeI+aYq
	atIEg8SEhcJc1HoOJ+D/zxosHQxLRfF4USKwCwfBHN3KmbgKXc2x3xvzOrj06R0lvoz7neBS7Ug
	D3j04//cHQ11SfyQifxLZQbUnOW+Nk7Wd/7OyFvlORy5kDQ1rq1Rlg==
X-Google-Smtp-Source: AGHT+IHeKEE/UxATDdchD69yalqsOikmgiA+/+GRAMjf3xor5QEZatBPH41VBe8xcfbMzEZ7DedVgw==
X-Received: by 2002:a17:902:ce84:b0:224:24d3:6103 with SMTP id d9443c01a7336-22c5361988bmr121198995ad.35.1745142424295;
        Sun, 20 Apr 2025 02:47:04 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c50bdb34fsm45831705ad.31.2025.04.20.02.47.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Apr 2025 02:47:03 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Sun, 20 Apr 2025 02:47:02 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>, hch <hch@lst.de>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: add tunable threshold parameter for triggering zone
 GC
Message-ID: <476cf4b6-e3e6-4a64-a400-cc1f05ea44cc@roeck-us.net>
References: <20250325091007.24070-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250325091007.24070-1-hans.holmberg@wdc.com>

On Tue, Mar 25, 2025 at 09:10:49AM +0000, Hans Holmberg wrote:
> Presently we start garbage collection late - when we start running
> out of free zones to backfill max_open_zones. This is a reasonable
> default as it minimizes write amplification. The longer we wait,
> the more blocks are invalidated and reclaim cost less in terms
> of blocks to relocate.
> 
> Starting this late however introduces a risk of GC being outcompeted
> by user writes. If GC can't keep up, user writes will be forced to
> wait for free zones with high tail latencies as a result.
> 
> This is not a problem under normal circumstances, but if fragmentation
> is bad and user write pressure is high (multiple full-throttle
> writers) we will "bottom out" of free zones.
> 
> To mitigate this, introduce a zonegc_low_space tunable that lets the
> user specify a percentage of how much of the unused space that GC
> should keep available for writing. A high value will reclaim more of
> the space occupied by unused blocks, creating a larger buffer against
> write bursts.
> 
> This comes at a cost as write amplification is increased. To
> illustrate this using a sample workload, setting zonegc_low_space to
> 60% avoids high (500ms) max latencies while increasing write
> amplification by 15%.
> 
...
>  bool
>  xfs_zoned_need_gc(
>  	struct xfs_mount	*mp)
>  {
> +	s64			available, free;
> +
...
> +
> +	free = xfs_estimate_freecounter(mp, XC_FREE_RTEXTENTS);
> +	if (available < mult_frac(free, mp->m_zonegc_low_space, 100))
> +		return true;
> +

With some 32-bit builds (parisc, openrisc so far):

Error log:
ERROR: modpost: "__divdi3" [fs/xfs/xfs.ko] undefined!
ERROR: modpost: "__umoddi3" [fs/xfs/xfs.ko] undefined!
ERROR: modpost: "__moddi3" [fs/xfs/xfs.ko] undefined!
ERROR: modpost: "__udivdi3" [fs/xfs/xfs.ko] undefined!

Guenter
