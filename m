Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1128F5B
	for <linux-xfs@vger.kernel.org>; Wed,  8 May 2024 01:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715131761; cv=none; b=u62m4v3KM1FokOA/kx3RrQW8BzcJ4RTyrNNH0TOe/vMzw5D5KtiEYFpU0MxPlBrpsdsxx471q2MLIJ7qxdE5ZQQDgI3VpLDXMdgyDwBbpPoTDKyVK4SBaLYFbC0dz7cagimbOkejddWMXSM/opXY6+iNU6LKr+/YdKTGgKur/Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715131761; c=relaxed/simple;
	bh=S+KmA9dSLhjXnhJF873IqV/Gd9cnIAVOxz54318nTNs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CVlxLsQDrqiEQ6pVtiL/f3YYMqbLyabQyfzEviS5JdYkZ/f+LGMaoR13X/OicpsjIqCxqRs33tLVWuYf1EPS8USPrgpZgPmpdELdihTjmy9gSfvDp996dRrJnMJQ8xYKBRENhAECTAzZJM3NWVdtObaCs0cMvRMNhLwgd4MtbjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=oO3OfM6q; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="oO3OfM6q"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6f44bcbaae7so2900135b3a.2
        for <linux-xfs@vger.kernel.org>; Tue, 07 May 2024 18:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1715131760; x=1715736560; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tzB4aecjphlPEDzQe5NK3FsOS2K2mixibavsvosnc7o=;
        b=oO3OfM6qLLjMz9aUHLhklQ0uPj2Y5ZRMWlLy9gma4k33HACixpV2Ake6Hpax5RliMZ
         2M4Tgj1YvJCseaP4E7iKLcqV6toXKblk9O+jIE+VuhqtbkTg2vt2ljEvPmJW+AqCqaos
         Vjau5N7VOUKC373kRYF41noOFbH2SmJN88qpAw5Wv4IFccy8k16lkWaHp64/x5yJePsx
         RcTE794ew9YpKBqG2LJZbvwjCC/IfBkQCT7t1JfRpxzbM1KBm2zDp08Qggoz+LmiPTXQ
         nlqNlYSa47jpXxlTsKRayZE5TPnHNbOiYEMYP+hDIVEHnCA++qGXxoOMY8zMPyBAAzWq
         pceA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715131760; x=1715736560;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tzB4aecjphlPEDzQe5NK3FsOS2K2mixibavsvosnc7o=;
        b=XlH3EcAk8qf6w1TeKgcCOv29rekoCbT6fsPTCoDPK1jXN/b68f8UGuTbukyTnPtE8/
         bkj7/x339RCBXNsyOwqBUd74db3lTrjHJ0ojRUHVlzm2XUC3Zwq5q3w89IW87To6sJNJ
         ABY9XvEeaItHnHaZd7kPPGfzVK5LLHwyZKNfo3FGMrjtaDM42jYgSILp7VYds/Xay8pB
         qQ9tc+RG9nzrjrYhxOoZ0Fq0UFk/mo8OlnmeVSAA2rwqFgkPoCF6GDrbo0Thno5TrAcU
         3DfGRuO9TQlqcKmv5E87boDi697kofHnnaCbfjZaKWCPwQXlj5tc9EVTR+Hj2jsKMbe5
         t7eQ==
X-Forwarded-Encrypted: i=1; AJvYcCVFsOxow2m3xWP3TAC0abaoMZCUFefx9dTEVeitP+Wlo5X34V4AFNbr9j3e3palLrgUGe0LAINUPT2DH6d+7vx9JZI8yOFvT5O9
X-Gm-Message-State: AOJu0YzsEe7TSbHvJdyqRsE64ChR10D05KtQ8bEc2r5yPZpD9GuEbmHt
	FUJ8C6VqjDo9ZaMG0y6o5P1Ah9BcYy8Ci1LVIvqdPtkaO3FYeRNcsQK+D96v1hQ=
X-Google-Smtp-Source: AGHT+IFRCw8e0cW7ldgPKWllS3XVUq4LhbnIO0GsLRIB6i79BIUwHKsbT8AkP/LXEDjMS63xwL/0KA==
X-Received: by 2002:a05:6a00:1410:b0:6ea:b9a1:63d7 with SMTP id d2e1a72fcca58-6f49c20eba9mr1696829b3a.10.1715131759520;
        Tue, 07 May 2024 18:29:19 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id fi39-20020a056a0039a700b006f3f9e4dfd4sm10040409pfb.60.2024.05.07.18.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 May 2024 18:29:19 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1s4W7P-007LB8-18;
	Wed, 08 May 2024 11:29:15 +1000
Date: Wed, 8 May 2024 11:29:15 +1000
From: Dave Chinner <david@fromorbit.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] xfs: check for negatives in xfs_exchange_range_checks()
Message-ID: <ZjrVaynGeygNaDtQ@dread.disaster.area>
References: <0e7def98-1479-4f3a-a69a-5f4d09e12fa8@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e7def98-1479-4f3a-a69a-5f4d09e12fa8@moroto.mountain>

On Sat, May 04, 2024 at 02:27:36PM +0300, Dan Carpenter wrote:
> The fxr->file1_offset and fxr->file2_offset variables come from the user
> in xfs_ioc_exchange_range().  They are size loff_t which is an s64.
> Check the they aren't negative.
> 
> Fixes: 9a64d9b3109d ("xfs: introduce new file range exchange ioctl")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
> From static analysis.  Untested.  Sorry!
> 
>  fs/xfs/xfs_exchrange.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/xfs/xfs_exchrange.c b/fs/xfs/xfs_exchrange.c
> index c8a655c92c92..3465e152d928 100644
> --- a/fs/xfs/xfs_exchrange.c
> +++ b/fs/xfs/xfs_exchrange.c
> @@ -337,6 +337,9 @@ xfs_exchange_range_checks(
>  	if (IS_SWAPFILE(inode1) || IS_SWAPFILE(inode2))
>  		return -ETXTBSY;
>  
> +	if (fxr->file1_offset < 0 || fxr->file2_offset < 0)
> +		return -EINVAL;

Aren't the operational offset/lengths already checked for underflow
and overflow via xfs_exchange_range_verify_area()?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
