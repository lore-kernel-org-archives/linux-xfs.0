Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4710265609
	for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 21:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764020706; cv=none; b=Pgq9LsN88c7Dq7GhZNMK9E7XniEcdpowPHGSx6csBQcytILeb27oVsIzlGTQQD3IpAUVYkniTxK+SELYOJwYzlvCqdNyh/9XhnRisUkV0wm9Hixuq86+4TQMMOpazE3lJ4CuHWTAVfBKNso3cgi5GZUc8DMJ6z4kWjb5Dzg80VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764020706; c=relaxed/simple;
	bh=OaNWkI/dcdAcPXpsXS3qagJygp7RcWHNYazgBaL9VHc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F0FabmXJQhse3W6bMpiStrfGbacxqL2nZ6/vv6BHL+fX2xjNOWPEDXyj2J332OOgN9HZcYDuBKQwDNvaLFIPOPOiOT8PAEN8eONso7rGvebG3SPT3zj9zPeXWTZHp3z9xoNH1/dgNMOolrFTIdWfyBPN1UWWn+1z3W6utPRS72s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=NjQGvZlI; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="NjQGvZlI"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7aab061e7cbso5628457b3a.1
        for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 13:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1764020704; x=1764625504; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NNsv43i2OQvz5OLalVIeDlNVznNw7I+brpQstgAAtI0=;
        b=NjQGvZlI/efA2Krjxf2G2UfgRDA+QKb98VRbff+ryCOfIP9pkbox5xA+m09/IdA2FM
         2BMGaxETaqIY2PTy5YFIO0vu6G+GxcCkG9fwDvG1rkIJrJ3oEol8uR16xk6JdQEIP6qt
         B3w63peg6f/WP96A33NHcqraHoJp2Z2nG1xVKzgFyq05tECv5A1EVrDeP+/KM8Gfovgh
         mVsUD5TaqzvsHABGmnaQjl4AfGvRN4SpoSVC6YHMyRwKi9523NCYXeCybWvSaJjDmVfe
         0QT6wU6Huj022QTRGDJu9DG1qCC8WVt/o+wanlyeOrU/Vop/FOXdVKWRYaqC6r2+5kcX
         qwUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764020704; x=1764625504;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NNsv43i2OQvz5OLalVIeDlNVznNw7I+brpQstgAAtI0=;
        b=SApaGeZxZZWlMBBtpH3ehp59AdL27zTtPIt/vhISJWyAHKzFbsJ21NZzHO1OIGjh4G
         Laeuxq1nS0Avjeqc23x5feqIUYKHq+q+mYmpGdPNCjYbpmLbmUcRJbmz9x2rgMzpilKd
         Y66ZUZIxXcQO55cHMMJOEBoaPae6+rMCh+pekPWkWnuQCYqos94VpdRRQfYcEVLfwDo/
         2dNNRYhDqsXSo0xJdfWcWwHrQdEW3zPzMavCkRY/cZFC6RYW7RO/UBV9j2uaLPtqSL30
         VKMi70W015Bc+Kx3Jzg9vUjRWw1tM//56XpYtoWJarf9mMpwiuu8T+O2Ig7/00PGWvJd
         MFtg==
X-Forwarded-Encrypted: i=1; AJvYcCUgGY3M17+zY6qqMcG6Pt0wzayqshsc4mVbqT8wUpnKfGC9TKetHsDBlYxeWwEpcuIXFsnxC5SbVRE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJM7Il8YreStI4rwdtHehrjwrmJ5rCbdU0qxhYDb4fQ5ioS2C8
	VlvEWoXCLm7OkZAWXxjTVGp73s4goojrnb0pV3YmHXvuhVGFLyekydtCASSHFLz2E1w=
X-Gm-Gg: ASbGncvkYI3n+y9f3Msla7o3sstaA6l9UlWBDJ0ypAK9o4xsoD7O1gXFHuReTUJXpOn
	cd12dpjDaUC5QMystItlrj9gcuZl5hkKnbTjzrhPO9LhAoqMfuHvFwFu4rjb78hRDxj4DGTe13p
	n5yuZ45/LW+CafvnPej4JdabGXsM7/o5Y667vi7EWJd1mT5ZBKGEso99Ip9NC7Rg8RHsu/lAP32
	fICjUGX03QqB6qn0V78LuyB3L9EYtXA2ZnBiEb/+xKm8NKWAEamIvc99KmOP7W9/cDD3IZtOf0y
	DY2ms460IjnZ4wSNPPAWXiTVCJFir/pCREcCkFYaE9N8AMyBRYrEZP12c6FGy4X3VFaSznSaDMw
	TPr+5Bh1GMqny3HoxySUqae9UqM0Xaofj5iFsWgm/OuaE/UgmJRSjRk1N4BP3+GTj5AI3cCCYTE
	kdTfv03NZlWYgzz3R4c1h/5uD1wCPcu9kj6bY0rEmqRUBtxpeQe/+lnFWuYeq9T6DBnzhx2p3o
X-Google-Smtp-Source: AGHT+IFQ0iEszH1nQ1G+8yhmc9CMltmxx8poRoBcqEr7VQXYIww2OLcCM1ETLiHMegh4RpRMW7/QIw==
X-Received: by 2002:a05:6a20:729f:b0:361:2d0c:fd81 with SMTP id adf61e73a8af0-3614eda84f6mr15126034637.28.1764020703700;
        Mon, 24 Nov 2025 13:45:03 -0800 (PST)
Received: from dread.disaster.area (pa49-181-58-136.pa.nsw.optusnet.com.au. [49.181.58.136])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bd75b61c29dsm14087028a12.0.2025.11.24.13.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 13:45:03 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vNeMm-0000000FGss-0B2V;
	Tue, 25 Nov 2025 08:45:00 +1100
Date: Tue, 25 Nov 2025 08:45:00 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: brauner@kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	syzbot+a2b9a4ed0d61b1efb3f5@syzkaller.appspotmail.com
Subject: Re: [PATCH] iomap: allocate s_dio_done_wq for async reads as well
Message-ID: <aSTR3GHyAZKdRCqo@dread.disaster.area>
References: <20251124140013.902853-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124140013.902853-1-hch@lst.de>

On Mon, Nov 24, 2025 at 03:00:13PM +0100, Christoph Hellwig wrote:
> Since commit 222f2c7c6d14 ("iomap: always run error completions in user
> context"), read error completions are deferred to s_dio_done_wq.  This
> means the workqueue also needs to be allocated for async reads.

The change LGTM, so:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

But I can't help but wonder about putting this in the fast path....

i.e. on the first io_uring/AIO DIO read or write, we will need
allocate this work queue. I think that's getting quite common in
applications and utilities these days, so filesystems are
increasingly likely to need this wq.

Maybe we should make this wq init unconditional and move it to fs
superblock initialisation?  That would remove this "only needed once
for init" check that is made on every call through the the IO fast
path....

-Dave.

-- 
Dave Chinner
david@fromorbit.com
