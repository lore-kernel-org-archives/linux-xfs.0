Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB86916CD24
	for <linux-xfs@vger.kernel.org>; Fri,  9 Aug 2024 23:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723244792; cv=none; b=mb6vHb9J3++O3rtaI8ud+fyV2uzWNT2mVnD5xLg6PzNIyDdwPytLc97WRIXfuyZCxMwTdDphrmtzq5aaoaH5Y/1ZPj+WLwpDfSAzE5mkRXhuMXxkyijaSpO+H/R9i4Wlmah9UVWQ9sOJ+UQxaFat3Aaz4rHxnECOQ0H0VF8xW00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723244792; c=relaxed/simple;
	bh=bZwx8Awwb4wvIVQy1/czHFUPIfNr4eP4NZCskia242k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nALN+4CT0KXB4ZY2g+8EFy8PmScSe4Vgscc7nThi8/D4mqVCxb4kILpEc33PAM6IJYig2RzCO/JXDfpeTBPMRl5gCS31ljlsgnhdvmLq0WIO5oGzowXZjJtFiY6Mus7x6jjMXgp/m4m5MEcv1ojhzyT0dBDT62I1GubpowMOjKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=0sAAqdaV; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="0sAAqdaV"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7104f93a20eso2207422b3a.1
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2024 16:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1723244790; x=1723849590; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qLXIcRQfqVWPyILBS4NCRfPx9XX6KjuIPWCqoJLoWeA=;
        b=0sAAqdaVpPO3iyjm2HzGDbw8C/23AthllCIdx8Mdw2GRf2bU7a8k0o1b633V6zL7Va
         s5TqNmnLg4ZsVYMtSAv3KhWXrVq+hiAAZb4Bm88Cewgq/9ChimCJd6ZMQQt3qSu6jFDZ
         7Yp64wlH/vF6hxzlP5puvWqMlus4RLgLnCIjmSRLnYLYpeLI1wTdeenS41IVLSeQmI+c
         FtfMVSkmIK2Xod85tY8oMe9MDj4yvitIdCIACP9yrfHCJ1VWRo+jg3Cu2QwbUQMbWEcc
         ujW/dFCiLheNJrkvz+dHchK0XfhRnxJWle5iM2GlD9PwfBS7OMzLl4cFSGJsB85gF0+B
         7+6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723244790; x=1723849590;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qLXIcRQfqVWPyILBS4NCRfPx9XX6KjuIPWCqoJLoWeA=;
        b=VkXS5p2oty3/6q0b6/hmlFOB4grp9g2OB7QxOmwM59ngfo4LnerqMJhOGIjiv1E1ma
         jeOydwtXiOWp3fsDWW6b4uCctB4BltF+Ef97vFSs601yFM0LhQQ1o33tKsOe82QXGJ/8
         z1Xb8a3gNPi7pVHMsdiItVahRKBKfPp2w9l5CWbTtb+t4uJuvMXWPBZYwN5uZUvqUOcR
         pLH5rgBx87cAjwHKqXzv/GG2t8C/NuwePsfe1zjCvDA9pdYIJ/kUoIPZ4Ux2pZemn4uT
         AvyC05tndsBWgRUSViAQ285y4giHm1VJGXMadoJZsLA0JJReDTMzq+U3FcwUCdhilM7g
         rZAA==
X-Forwarded-Encrypted: i=1; AJvYcCXAwhPlTlc+talW+ePC6eQGOpaBw18cMuHS2JqAP9CdqYVScmYD7WkMJRc8FNfFnbkniZhUPKfnEXoG0oJI1PhqJT7boMhiDOO6
X-Gm-Message-State: AOJu0Yx+IP90LiOuYd31PLbNFgrwl6SFJl0Z8KWNdh0ZuR57ldVZB7P/
	N3PZ9O4vfzLsU4eLuSdHGa383g3iqPVnUQVdNhY9ZWs3H51xVXRF9U/pOcBd+sc=
X-Google-Smtp-Source: AGHT+IEUU8G/DVGE6NlsSYImmjk9rN+qyR0QXuoHxE6GCaGPWCZFRMYYJIt81OTDQfegBeHuVGXukw==
X-Received: by 2002:a05:6a00:2d97:b0:705:a450:a993 with SMTP id d2e1a72fcca58-710dc762037mr3670855b3a.17.1723244789985;
        Fri, 09 Aug 2024 16:06:29 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-710e5ab79casm258567b3a.199.2024.08.09.16.06.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 16:06:29 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1scYgk-00BQOS-1c;
	Sat, 10 Aug 2024 09:06:26 +1000
Date: Sat, 10 Aug 2024 09:06:26 +1000
From: Dave Chinner <david@fromorbit.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-fsdevel@vger.kernel.org, jack@suse.cz,
	amir73il@gmail.com, brauner@kernel.org, linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v3 16/16] xfs: add pre-content fsnotify hook for write
 faults
Message-ID: <Zrag8qezssak5rVY@dread.disaster.area>
References: <cover.1723228772.git.josef@toxicpanda.com>
 <89eb3a19d19c9b4bc19b6edbc708a8a33a911516.1723228772.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89eb3a19d19c9b4bc19b6edbc708a8a33a911516.1723228772.git.josef@toxicpanda.com>

On Fri, Aug 09, 2024 at 02:44:24PM -0400, Josef Bacik wrote:
> xfs has it's own handling for write faults, so we need to add the
> pre-content fsnotify hook for this case.  Reads go through filemap_fault
> so they're handled properly there.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/xfs/xfs_file.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 4cdc54dc9686..a00436dd29d1 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1328,8 +1328,13 @@ __xfs_filemap_fault(
>  
>  	trace_xfs_filemap_fault(XFS_I(inode), order, write_fault);
>  
> -	if (write_fault)
> -		return xfs_write_fault(vmf, order);
> +	if (write_fault) {
> +		vm_fault_t ret = filemap_maybe_emit_fsnotify_event(vmf);
> +		if (unlikely(ret))
> +			return ret;
> +		xfs_write_fault(vmf, order);
> +	}
> +
>  	if (IS_DAX(inode))
>  		return xfs_dax_read_fault(vmf, order);
>  	return filemap_fault(vmf);

Looks good now.

Acked-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
