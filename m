Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BAC38388
	for <linux-xfs@vger.kernel.org>; Thu, 28 Mar 2024 04:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711599381; cv=none; b=mk/e3z7X2SNviMawsLg5/hZU2u+J+U1GcyS5IuLef1YPig7JVQgHHB171TCW4r26iVo4c9N0UrWpZviXMLG34xXUGpXklE5ZchXbco7nSdFh44V+pER668JNlL5BWLUR/vqtFQ5zKynL5cXecBGM3hD65pukBqV3oPmPNKSbMO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711599381; c=relaxed/simple;
	bh=Ke7H98tpQiU54aT2SU6QwJgT3UCOguYxVbN4qBMZgSQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lpbtp2igMZbhJoFgkS9hnmaibwL1oIC5wXz7UVgS6aQDEWezTNDtfmmB04bgkVVU/9vr4EnuSD0cPGD9tkW+iZRauM6qci55iwi58NZJVhWWmzJXmtBQXS4xM5v8/v1lu3PdrnRyBKazl9vn1IMY+9CMJhkx0WhFgr+nHJD8CQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=YCe9END3; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="YCe9END3"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1e04ac4209eso4391805ad.1
        for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 21:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1711599380; x=1712204180; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AKxxyn7/M/hZWBxx4mcVhUIRYmeUaRf9Pio6OvkZtxw=;
        b=YCe9END3sYFFQOztHG9X8+i5Ufqb6TRNgvKZQNV43DaWHYJngoxQVijJJVwZ3VAF/X
         3CAiquU7G1D/BwlYdyCpktRjpLc2uVEkutL6Eu0Bk+dA+fazZM7FyP00KvASDZk1Wiys
         wjAgzTfuR4NfeEFkgfEzXaciE3r2UxxzFZQS7UyfO0ULC42dOG3Yd97yb+YVleMcnL5m
         VGska6CPQ6BAPm9SczdQ+/hBxo1UE1B4QeQrp0r29U1eMwUruncURh8trP99P66pBS/u
         6gPBajzIB9H2fM9uJzUFfsDwkbh6kBeUdSaoIMF8pG5F0HxbzE17ukgqVOHJfgANErdT
         lliw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711599380; x=1712204180;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AKxxyn7/M/hZWBxx4mcVhUIRYmeUaRf9Pio6OvkZtxw=;
        b=DHMxYnid8e7Nb6Hgqm7hT4dcO/Nv/Cks7zKKx4FbYHxLyWv166BXh7P3r+h5+1XgKL
         dx5avE/z+xR9cZpvEXvg6yx62GS1fLV6/rU0BAGyzom0+uChqsYZZulHaPDXTv5zjmGC
         /D3ZZWaSsasF0D+K5rwznsrfoeibbY33DRg7YVqI0Uv5h5hQjL3papRMKKqcZH6mAkLA
         hKCdG8Hxg27/3y1VNnprp8OXBEuK/1Ts9Ckg10PPYdaL604Br33Lf7knm95r5Rd/j3QD
         JQ8BgYVD2pOLP7wHwXtY+sG6t1/jKhZJ9ZSK4tym3Nlt83SY658yesPCLvAxjX+fVDIf
         4PzQ==
X-Forwarded-Encrypted: i=1; AJvYcCXP18wGvXy9I0lAAb+JgHMVCFJ1zYGRuovuqRrIMqqo7T++3ZFQqbPUCt3YWwBWdLsCqwNcYdv+bw8jgvTuyBA/1GXX04z7JSQM
X-Gm-Message-State: AOJu0YzMjS6VNts+tAHubA2FBt3MT6I9kX2EGy1R2vZSaz5BG7H/Yy8w
	/3s9g0eJ/UQckqFcO5ErrSbroHuwrbSo075BZy9i7c1oXKoQkM9Ni2wrrGyQI0Y=
X-Google-Smtp-Source: AGHT+IFk7/0c0sdCb567su94zRchlC11s4aPjgHThLQ6mXmk3F/h5pJHTWGkZQPQvTdM3KkcMug36Q==
X-Received: by 2002:a17:902:7844:b0:1dd:2eed:52a5 with SMTP id e4-20020a170902784400b001dd2eed52a5mr1518549pln.37.1711599379448;
        Wed, 27 Mar 2024 21:16:19 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id u14-20020a17090341ce00b001e0ae032370sm389179ple.58.2024.03.27.21.16.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 21:16:19 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rphBY-00Cg9s-2R;
	Thu, 28 Mar 2024 15:16:16 +1100
Date: Thu, 28 Mar 2024 15:16:16 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/13] xfs: block deltas in
 xfs_trans_unreserve_and_mod_sb must be positive
Message-ID: <ZgTvEIIV41UGlf2p@dread.disaster.area>
References: <20240327110318.2776850-1-hch@lst.de>
 <20240327110318.2776850-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327110318.2776850-6-hch@lst.de>

On Wed, Mar 27, 2024 at 12:03:10PM +0100, Christoph Hellwig wrote:
> And to make that more clear, rearrange the code a bit and add asserts
> and a comment.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Yup, that helps a lot.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
