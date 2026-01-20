Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB5643901E
	for <linux-xfs@vger.kernel.org>; Tue, 20 Jan 2026 14:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768919320; cv=none; b=RuKOsqQ052X/kH0ZVcLhUSeOTqTu3TkapzcgBfA/2/4WNeSYwm9Qlssi3edKGad4swAjbkjF5Lu6mD3fX0z1eEjNcZ2K89+xYEC/ub+c5XYsTQTDqHRw9fsi2b+Nx0zghdHTzP+dTHus7+lG0VBv4tMpL2vdXgO8yVsZnAPf394=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768919320; c=relaxed/simple;
	bh=YREwUOegbBvSFFoxBrWYb7rRCsAZ5TRV+R178NJAUaY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T5pUz/oxvJaN+JuNWqAkkcqnqJHMPAI9gvp9HfB+KsBfmxVgbxhu+v+G5VdXAPWna5nUfbhGKT01nTqXdKE+RBn5+yehzxrPUxYmrTkhkmdhsponJkF7Jk/0A3fBlFDB3fo5G28sS4BCBB8KZ+zHkP2vW6zsRtI+llhd+AjEd8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J1J5kGVq; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=EJMedsgM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J1J5kGVq";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="EJMedsgM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768919314;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pmXBAiulLyW2nuyxM1hqOPWqFs2an/tVfUTdxFuYfQI=;
	b=J1J5kGVqweqZ4+OYq1gxBN5JbI7Yyvvo8vViqAKA+I7awGrETxph7xj2pEnF6MK7aggoT4
	HwV2Irsm0xaeCXmgt8vBua+C1Au8mVdlEMVqnvliyRDkU3WukyXx3WlTISYSZkpbf5U5WN
	/knj7FzId4C6gPsmQ9zJ92mzXNxQzmE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-33WmI0-kMomIakRa9b-iHg-1; Tue, 20 Jan 2026 09:28:32 -0500
X-MC-Unique: 33WmI0-kMomIakRa9b-iHg-1
X-Mimecast-MFC-AGG-ID: 33WmI0-kMomIakRa9b-iHg_1768919311
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-430fd96b2f5so5272091f8f.3
        for <linux-xfs@vger.kernel.org>; Tue, 20 Jan 2026 06:28:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768919311; x=1769524111; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pmXBAiulLyW2nuyxM1hqOPWqFs2an/tVfUTdxFuYfQI=;
        b=EJMedsgMdov/ElntslSP6jR/5VwE7K0WWy1QWOrT3msCRTE+ngJhS4hwbdd0w0Ekyp
         DBeOHNe51onMf8YX+GYeGOJhtFFYme+JbqdE7K5dbG2zNGdqcYiGHFG4xno7amIveeF5
         rA4Q9In+nvyp1x1R5RlrzNxVZk+HPPJS87fDHSNEovkawlw/qj2B0dehs+P0NSdVHMs4
         7z4+ht98kHrBCBSJwGU7/BrRHv2hxCjDhT/3+9U0v5oOfgHiwn7f2IZ21YTI+dGJ2O6d
         03vn/1LfYJvfL62NV++Du5kdWRyW+M6sLFPlzYRtLn3D5aFEZLkgJw780gPuycirZliO
         xMuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768919311; x=1769524111;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pmXBAiulLyW2nuyxM1hqOPWqFs2an/tVfUTdxFuYfQI=;
        b=fvUC3i+iJTOTxi//He9vzD8UDsCJEn30F32KwaizDhSL6459UutV2RrPReRESyDnmN
         gvQITnlLiiNT9ZqY6bUKqMGlrOounjXstoNOd9ioDtaPvBtc8bUEzUZjBAniSnGDaECV
         uXAxFVRmVyT5KKV+V+1s7HmRz9XUG+QbnaeztMLcGqL62m/DaLzr82KwZGTVaG9EB27D
         a/DL42G13pm38HH2PL4EP3yU7K3RvpBHZ3btEDuTjOk3Nvyq0Pk5LYB0fWl/854FW7/n
         iLR8khWu9DcgeAhtpK3GkICidKylZ7IO6FEnjG2aYulg0cjbzQ3WNMCqr2TvEqzVtayZ
         0ymA==
X-Forwarded-Encrypted: i=1; AJvYcCUXXYCkTHMOzKQ5mWrqHwiSNvVjb23OT0/tv07drqfCUWLkd7BIUl41Hlfmfiy5bppwPNX4Mgo7IF0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxS8k3Fpx1keTrZjj0uKUPsD3JeZKsf0rygZHiP0fOIak88ePES
	oO2M+s8CVI30wx562fXNp3/lwgvF9TsBIbgHOqdnd3hAgQf0wFtvIFPwSRvNz8c0UQMwFyKl0uN
	cfznyOXI96/4p9XMSrj1zl34JAzJS8md12nNr1zXKFMKJCRFKunGjx1S/zGIbRo7/e1uk
X-Gm-Gg: AZuq6aLI8m1bGmtrfN2giccTz6tMBVOuvSOganBlxpp022DkhK1MvP18OawS2YnyTLh
	BccnJ1D0UHi7G2f8Xk3iPloZryjpFoJfvM/W8Y8ln+75fX1GRaarcAVJLufvOtgQ+0tJIO8NAzg
	nG7OWDyIhzAowUWzr6Uk4+Mg20YsnATHU/DEnC9XGRrihWrYwO5oK8ctd0kC4FCs3cZzFNzMGR/
	II046ZzOeUH7JtoNZCcjf+peBfxWOGAvcPilj381vT4MWRUk569GyIRWYVi83hw0mUq13KRf3TS
	eFaicTUHzMKQnmw71JG5AqnZ2If60BD1ENkn90tlDJgeCuqEDnueU/a65UskidHyi1ZIWAINyRI
	=
X-Received: by 2002:a05:6000:2481:b0:430:fdfc:7dd3 with SMTP id ffacd0b85a97d-4358ff62780mr2851107f8f.50.1768919310852;
        Tue, 20 Jan 2026 06:28:30 -0800 (PST)
X-Received: by 2002:a05:6000:2481:b0:430:fdfc:7dd3 with SMTP id ffacd0b85a97d-4358ff62780mr2851069f8f.50.1768919310365;
        Tue, 20 Jan 2026 06:28:30 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4356997e6cdsm31109563f8f.31.2026.01.20.06.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jan 2026 06:28:29 -0800 (PST)
Date: Tue, 20 Jan 2026 15:28:29 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, 
	Damien Le Moal <dlemoal@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/4] xfs: use blkdev_report_zones_cached()
Message-ID: <yw6bc76kuh56avbb5nxlvdkrattk57s5z65defzbdoohp5wtvt@h346oio32jdk>
References: <20260109162324.2386829-1-hch@lst.de>
 <20260109162324.2386829-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260109162324.2386829-2-hch@lst.de>

On 2026-01-09 17:22:52, Christoph Hellwig wrote:
> From: Damien Le Moal <dlemoal@kernel.org>
> 
> Source kernel commit: e04ccfc28252f181ea8d469d834b48e7dece65b2
> 
> Modify xfs_mount_zones() to replace the call to blkdev_report_zones()
> with blkdev_report_zones_cached() to speed-up mount operations.
> Since this causes xfs_zone_validate_seq() to see zones with the
> BLK_ZONE_COND_ACTIVE condition, this function is also modified to acept
> this condition as valid.
> 
> With this change, mounting a freshly formatted large capacity (30 TB)
> SMR HDD completes under 2s compared to over 4.7s before.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/platform_defs.h | 4 ++++
>  libxfs/xfs_zones.c      | 1 +
>  2 files changed, 5 insertions(+)
> 
> diff --git a/include/platform_defs.h b/include/platform_defs.h
> index da966490b0f5..cfdaca642645 100644
> --- a/include/platform_defs.h
> +++ b/include/platform_defs.h
> @@ -307,4 +307,8 @@ struct kvec {
>  	size_t iov_len;
>  };
>  
> +#ifndef BLK_ZONE_COND_ACTIVE /* added in Linux 6.19 */
> +#define BLK_ZONE_COND_ACTIVE	0xff

hmm I think #ifndef doesn't work for enum member. Compiling against
linux 6.19-rc6: 

../include/platform_defs.h:311:33: error: expected identifier before numeric constant
  311 | #define BLK_ZONE_COND_ACTIVE    0xff
      |                                 ^~~~
/linux-headers-v6.19-rc6/include/linux/blkzoned.h:84:9: note: in expansion of macro ‘BLK_ZONE_COND_ACTIVE’
   84 |         BLK_ZONE_COND_ACTIVE    = 0xFF,
      |         ^~~~~~~~~~~~~~~~~~~~

-- 
- Andrey

