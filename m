Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35CF2C853
	for <linux-xfs@vger.kernel.org>; Thu,  6 Jun 2024 02:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717641045; cv=none; b=suPMDp40kLH71XSww3q9d7vErKgCJdofup4+/oLFK37XltcBQyv378v41QRh0TXRTOEP6HkuMakkMoXd60eebhNzXBn7ca/D9aOSWsv+wo6MX2Y6cUK5pZq3fccRksa+mpBMfUHJsPq2qUMhB7KlDhNIJZkep0XM0UOBedLufQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717641045; c=relaxed/simple;
	bh=i+7S1vRPcGSA7nDng2dCq3jxvemu3HRbYmR0uZ1C46c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QgZMo0XXFMTvLWfvA7xFMejGceaAJac0OgbyhAz3xeNe8LrZhi2hcrFq2HYDsbCoZCKiJSdxIhV1hDLOkYPEF5AHXUbVprNC5Iei4HlY5HoIkiiGnWfJpH6GjKUF/NHgd9O5bDQRZjJzMr/f6n0d1hcf34SYdlahyhztnLdOP58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=ChxizVT+; arc=none smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="ChxizVT+"
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-5ba6dd7b976so237673eaf.1
        for <linux-xfs@vger.kernel.org>; Wed, 05 Jun 2024 19:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1717641043; x=1718245843; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7cZm3oCfHJnoUzoVhEH1Ub7kGBKks5yQE+FU+nrpKfE=;
        b=ChxizVT+C8jpR8maftu2lHZmE4DKILDeJFKOHEEs5hd6TighBjrCztK4RdRi95IrOt
         s+UTzhTKA2pyV65SgVRuzTaiohdspDmB4BT14a05CzYPmt93Zpv1WfSIvy5SeP+oMeMR
         olNyor1O+7oiuK7LjUgObrqwF96HAAA8ILya3tSTWbjqxRD0VnXdRk6eszFsynNE7+bD
         rcNb8ZuFeCkBwBo/IihdvxqKdK1fNDsvRzdf357lfVddgpOO9DdmfSsEt9gZ01AgZjXB
         6SObr57MRLCOOwnbTZtqRJ4o6uefWIRr86jtA2DtxT/z+6CavyaoFdQNnHUWsKf/Xzp/
         wUtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717641043; x=1718245843;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7cZm3oCfHJnoUzoVhEH1Ub7kGBKks5yQE+FU+nrpKfE=;
        b=vCsOzVRiLop3EblEEoAIv89OdN5oO1v7BhsYZ4/X3ftFMGWh2Fh0UjNwsKGgP9LbwK
         sN6AWZoEjRS5FQZdd3R47GB6upRJF4x8yPL8H5Ga4JZTuYFpzN3LQfzV/0gnLpCJpoX8
         ZCz7wAfMv45P60howwIpeSlM7+fSjsmjiFW8TktO6akVVaIEjPkvLiPle/vOZvnyCgS/
         6Rk3Tr31qHkG+bkF+OLoSiDsRShf77FQeIsEKrwmCRLqP+2o/H17tvQRiZqb8i6g9Xbp
         h4k9+h65SpVYZedYkUxuHFYhneITP/CfbVISuUckLTQk+m7PhIkMxQSujJAKD3rJEULv
         +AMQ==
X-Gm-Message-State: AOJu0YyQpIorUlqsvIUVSWfjXXoxRwVuxloCLGMlAauo2kprLaAagVJQ
	RBh5R6v8FGvXjXQK1cOs5GAZST0jeSfMfwUnr+csIxEnUN2ytLJyvq7SV9Rl0mw1TU41pb0ulWB
	9
X-Google-Smtp-Source: AGHT+IG0AJiRRk5WPn6Ii7lt1shesAfENud4fdNJ/eysSNRN6g6ieIuIDgf793GSYpKVgxljHJvVOg==
X-Received: by 2002:a05:6358:2810:b0:19c:277f:ef37 with SMTP id e5c5f4694b2df-19c6cb1924emr525367855d.28.1717641042560;
        Wed, 05 Jun 2024 19:30:42 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-6de20180426sm195737a12.4.2024.06.05.19.30.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jun 2024 19:30:42 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sF2tj-005rqi-2S;
	Thu, 06 Jun 2024 12:30:39 +1000
Date: Thu, 6 Jun 2024 12:30:39 +1000
From: Dave Chinner <david@fromorbit.com>
To: lei lu <llfamsec@gmail.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: add bounds checking to xlog_recover_process_data
Message-ID: <ZmEfT43mf/RAkvLH@dread.disaster.area>
References: <20240603094608.83491-1-llfamsec@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240603094608.83491-1-llfamsec@gmail.com>

On Mon, Jun 03, 2024 at 05:46:08PM +0800, lei lu wrote:
> There is a lack of verification of the space occupied by fixed members
> of xlog_op_header in the xlog_recover_process_data.
> 
> We can create a crafted image to trigger an out of bounds read by
> following these steps:
>     1) Mount an image of xfs, and do some file operations to leave records
>     2) Before umounting, copy the image for subsequent steps to simulate
>        abnormal exit. Because umount will ensure that tail_blk and
>        head_blk are the same, which will result in the inability to enter
>        xlog_recover_process_data
>     3) Write a tool to parse and modify the copied image in step 2
>     4) Make the end of the xlog_op_header entries only 1 byte away from
>        xlog_rec_header->h_size
>     5) xlog_rec_header->h_num_logops++
>     6) Modify xlog_rec_header->h_crc
> 
> Fix:
> Add a check to make sure there is sufficient space to access fixed members
> of xlog_op_header.
> 
> Signed-off-by: lei lu <llfamsec@gmail.com>
> ---
>  fs/xfs/xfs_log_recover.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 1251c81e55f9..14609ce212db 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2456,7 +2456,10 @@ xlog_recover_process_data(
>  
>  		ohead = (struct xlog_op_header *)dp;
>  		dp += sizeof(*ohead);
> -		ASSERT(dp <= end);
> +		if (dp > end) {
> +			xfs_warn(log->l_mp, "%s: op header overrun", __func__);
> +			return -EFSCORRUPTED;
> +		}

looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
