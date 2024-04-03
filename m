Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C07113665F
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 21:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712180959; cv=none; b=i2mMQWhHXU31ALZvTBGh0jVPGWJYwyW28OP1XF0XBc7FlwDmYJO2SSh8S0ioN837zSLGcQxpcR9WjN4apqNPlsrBMTlbVpxnycZ7eixW4hh7+ACw9lIV9XkNPWPZFC+k6wQgOYfAwrHKBDsqrPHmwxnDhZfV7WMt5dinz4+Fgn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712180959; c=relaxed/simple;
	bh=day7nq7QmxDko+2EHDLMZMsxny42N+8S+D1TgwNoE/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bEhGY6cx55D/P03lELgDoU/ez0uz+Rm47jxZqSKoe7Wf/DB8pXirh4Q3+7LrwoSYLnk+hQAruhwtkvBK6R2hAWsWPg6guNnDR4lE/sLfDyWRwXYp0m1b44iqkcX/SgT26c7eEEK0dxitFXer3IiODuIaBxi3K9q0JVkbD5jOe90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=LSo1E084; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="LSo1E084"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-22e7560b94aso177359fac.2
        for <linux-xfs@vger.kernel.org>; Wed, 03 Apr 2024 14:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712180957; x=1712785757; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=giChApwNW/j0USihHXAJPbkF+bMlrgvSNERdh2WM8+A=;
        b=LSo1E084m4WQi/Jem1T+P9hXG9S+oN1tVu15H1Np9+jeyFLtUtjW0VKQNdKlzjxNZt
         RnZ82Vm1kcN9Ci11yKkrqYb4cmBWz4zV1GpP6JVG4yJQ5zHSrnj9OINb7wZOUZS86XuJ
         FB/s5ugYV9u1owT2UjMaqm7J0snHgqr6IgE+hKSCh0g97Xm7lAqE+oUFFS3I1KL5gmj2
         Arh7PU5FwR+4rW2+Ybb1/IBrlu3N75EGryq5RfXMHzd+gF53daEupGgHmMoqSFD3LtsC
         ff/TMPwklvxW6UDCpa19mMcrJrEqz0G3DGBtH4MQU4iWCHoYWfzo3kWsyjES03uEF7ez
         RXTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712180957; x=1712785757;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=giChApwNW/j0USihHXAJPbkF+bMlrgvSNERdh2WM8+A=;
        b=TV3f7JAshaC24JMdDzk1lo8Rxstui99gLt+HXE0D4gRa4P71G1AdNRnWMpFbTeks88
         W5XHqJgN117dx9Cll3SncM3T702JWU7ddRbkUbUbIHv6E4g0SYmsT4o7mFxxRwubX9Tg
         HsKOgp1XGdiNWG0yWep3cZ8Wd5Iai6rL48Cy//GUzvxXx9S9zMKsG6KGVnkbxKDstwJm
         j3LZWGzsWbnsyYSJuncVwskUBAPOW0y4NGKw0EzwAwlsUOJcwmbhgnte5ITr+CcFXes+
         WAC9WK0GRro73gEi67s9FH0hCcJIMy6JP6iJMBRvxsGUdSBBkjhx46FNCYr+g6s+T7Ur
         0m3Q==
X-Gm-Message-State: AOJu0YwGBzZGBRFg5tPVk6AhZJ8P2UBFrjoTQ41f7VqrQ08mNiCHwSBG
	2K/983+oSrmuLcbhVM3S6kxnHgnkxOn2M9gMWCSsfY4mo6MX8nsGNBvBNxrQ2DvAdHq9FXUEMge
	4
X-Google-Smtp-Source: AGHT+IE+S/kVYAQecZMO/iwQ9CTYezZo5b/TrVeku0ggnTqSqQYQhzFJ5BENT6+H6QmgKf/0nUE2Og==
X-Received: by 2002:a05:6870:1298:b0:220:e608:89c with SMTP id 24-20020a056870129800b00220e608089cmr480814oal.28.1712180957096;
        Wed, 03 Apr 2024 14:49:17 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id d21-20020a634f15000000b005dbd0facb4dsm11808616pgb.61.2024.04.03.14.49.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Apr 2024 14:49:16 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rs8Tp-002ybC-0z;
	Thu, 04 Apr 2024 08:49:13 +1100
Date: Thu, 4 Apr 2024 08:49:13 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, chandanbabu@kernel.org
Subject: Re: [PATCH 3/4] xfs: handle allocation failure in
 xfs_dquot_disk_alloc()
Message-ID: <Zg3O2d8GozDujblD@dread.disaster.area>
References: <20240402221127.1200501-1-david@fromorbit.com>
 <20240402221127.1200501-4-david@fromorbit.com>
 <Zg1ieA0NA9Bd_i3P@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zg1ieA0NA9Bd_i3P@infradead.org>

On Wed, Apr 03, 2024 at 07:06:48AM -0700, Christoph Hellwig wrote:
> On Wed, Apr 03, 2024 at 08:38:18AM +1100, Dave Chinner wrote:
> > @@ -356,6 +356,23 @@ xfs_dquot_disk_alloc(
> >  	if (error)
> >  		goto err_cancel;
> >  
> > +	if (nmaps == 0) {
> > +		/*
> > +		 * Unexpected ENOSPC - the transaction reservation should have
> > +		 * guaranteed that this allocation will succeed. We don't know
> > +		 * why this happened, so just back out gracefully.
> 
> So looking at this code, xfs_dquot_disk_alloc allocates it's own
> transaction, and does so without a space reservation. 

It does have a valid space reservation:

	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_dqalloc,
                        XFS_QM_DQALLOC_SPACE_RES(mp), 0, 0, &tp);

The space reservation is XFS_QM_DQALLOC_SPACE_RES(mp):

#define XFS_QM_DQALLOC_SPACE_RES(mp)    \
        (XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK) + \
         XFS_DQUOT_CLUSTER_SIZE_FSB)

which is correct for allocating a single XFS_DQUOT_CLUSTER_SIZE_FSB
sized extent.

> In other words:
> an ENOSPC is entirely expected here in the current form.

I disagree with that assessment. :) 

> The code, just 
> like many other callers of xfs_bmapi_write, just fails to handle
> the weird 0 return value and zero nmaps convention properly.

Yes, that's exactly what this patch is fixing regardless of the
cause of the failure. It's the right thing to do - error handling by
assumption (i.e. ASSERT()) is simply poor code....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
