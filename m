Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4138A13C908
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 01:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728954542; cv=none; b=qA4YsJ1028FfaN9IHYYJ64TcGV0CLfrLaz9AuCt06twBRX26pLyWq0s+MTIy2B/wJTtwpKfIBYkqCDcMOTyF1O4dTyPYUBIofuJ7iU1N2r84DoNR5gDQvdSzjfSC1/yqxxHkz2bJXmq23TbWkyRR4cTbkqyPp7RnvTmqGvCjn7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728954542; c=relaxed/simple;
	bh=H4pmppWfGzR2gI9E1Weev2HBi2xUc1rkUCAxoQcUydo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bn7LqvX5p2k/ncme8FV3unazTHvZ4NXoMaN+HOW9274ivPHWhLd/uGGAjIsnNalpIvCdMvKFFxPY5K+FrwqI9VKVJmJa+M8dgHIvC4hl5lYBZ+Rc+jVVBDUn6Sjmr+GVz/tOfpMn3vWOswFUFS3U3CioA9Mx50hyiYT9eaczkKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=xI8TPr1p; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="xI8TPr1p"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-20ce65c8e13so13635095ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 18:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1728954539; x=1729559339; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+YZrxE+kV5C0MWQkd78I3eNOxbZ7DWhLRNrPAiXAMv0=;
        b=xI8TPr1pIct10piJib14cW4iHRgxq1hIJkzEXIAgMO2Wn1UKXOMNR4UC0OoPGotGiB
         CApNdFCGh72hYtodkw2pTk6tDInxmxQkFJ72xT3pi1uwCIfrmcaCedn8gsyMwY4bnD2I
         gMQGlnnpXg4iNc9nPqezDMtdRe4NhczksWzz/67+LCRkAcYGYaeT13zk1zm0bB757x/x
         1ykD4yHZ7C/mrcnaBjd3u1NfASPd/F5s7Zufv36m7REqx/grqqFHVOHGXIAhsCGc+rcR
         fStqojrzd6JdpIhODFxiohzPR4aVPkY9pQvdFma20eyw/Zbk4yx+qCjXcY0vohx6JJTG
         Bolw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728954539; x=1729559339;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+YZrxE+kV5C0MWQkd78I3eNOxbZ7DWhLRNrPAiXAMv0=;
        b=Kz/ddOZCfLy4HAqQuf+x5th/DJx3M/qU2oUOIF4QrUIxDqsvl2GFl3Kf4Rw9o6B7l4
         sslAZcUQ1hBUApyGkdAYzLZ1RfzutOWv+Vq63Nv05M2IZLMmXt+sJedTXzF/K4MzwscO
         jnCJMlS7uOJ2HAKXqEaw9b2jEzjGQ4DAwh0zfxjhSuhmHdI6RuDfAt/M+QEV86e2oS47
         Vla3Buqf2phS6CHWx7XXP7nZGp/FYlw6DoSIEPQq4RRcOl5JIWa8RkQL+0XUCW3XRLc5
         xRiioGKhgWQ/euFPriut1jyX6ZcF7Xs97aGmyIo4kbaZgCCx7dqUzwwHCEnh5vBmjb1I
         f2QQ==
X-Gm-Message-State: AOJu0YzrCQPIJmzSQ2L2lO3v7p8kaV5TEHEHfNVFJecHxGBaxu9MOHSo
	UePTQ29iMrwnOYGMom6wTsAz6RGj2oU0ja/jsCTAfquzbSXIpqrjh1O+AyKen9LAFCEPOHCCTMT
	4
X-Google-Smtp-Source: AGHT+IGrDyCvhUOHP5X6MnCYL24AjYV6NsegZt+zv1cjFk7uKWUyYkAV/MuS4GilIu9QrrgGdY3bxw==
X-Received: by 2002:a17:902:f707:b0:20b:a6f5:2768 with SMTP id d9443c01a7336-20ca142984emr181735235ad.10.1728954539498;
        Mon, 14 Oct 2024 18:08:59 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-209-182.pa.vic.optusnet.com.au. [49.186.209.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20d1804c68bsm1572355ad.185.2024.10.14.18.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2024 18:08:59 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t0W3U-000vHi-20;
	Tue, 15 Oct 2024 12:08:56 +1100
Date: Tue, 15 Oct 2024 12:08:56 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 10/16] xfs: convert extent busy tracking to the generic
 group structure
Message-ID: <Zw3AqAuiDKKKowCa@dread.disaster.area>
References: <172860641207.4176300.780787546464458623.stgit@frogsfrogsfrogs>
 <172860641435.4176300.8386911960329501440.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172860641435.4176300.8386911960329501440.stgit@frogsfrogsfrogs>

On Thu, Oct 10, 2024 at 05:46:48PM -0700, Darrick J. Wong wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Prepare for tracking busy RT extents by passing the generic group
> structure to the xfs_extent_busy_class tracepoints.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_extent_busy.c |   12 +++++++-----
>  fs/xfs/xfs_trace.h       |   34 +++++++++++++++++++++-------------
>  2 files changed, 28 insertions(+), 18 deletions(-)

Subject is basically the same as the next patch - swap "busy"
and "extent" and they are the same. Perhaps this should be
called "Convert extent busy trace points to generic groups".

> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index 2806fc6ab4800d..ff10307702f011 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -41,7 +41,7 @@ xfs_extent_busy_insert_list(
>  	new->flags = flags;
>  
>  	/* trace before insert to be able to see failed inserts */
> -	trace_xfs_extent_busy(pag, bno, len);
> +	trace_xfs_extent_busy(&pag->pag_group, bno, len);
>  
>  	spin_lock(&pag->pagb_lock);
>  	rbp = &pag->pagb_tree.rb_node;
> @@ -278,13 +278,13 @@ xfs_extent_busy_update_extent(
>  		ASSERT(0);
>  	}
>  
> -	trace_xfs_extent_busy_reuse(pag, fbno, flen);
> +	trace_xfs_extent_busy_reuse(&pag->pag_group, fbno, flen);
>  	return true;
>  
>  out_force_log:
>  	spin_unlock(&pag->pagb_lock);
>  	xfs_log_force(pag_mount(pag), XFS_LOG_SYNC);
> -	trace_xfs_extent_busy_force(pag, fbno, flen);
> +	trace_xfs_extent_busy_force(&pag->pag_group, fbno, flen);
>  	spin_lock(&pag->pagb_lock);
>  	return false;
>  }
> @@ -496,7 +496,8 @@ xfs_extent_busy_trim(
>  out:
>  
>  	if (fbno != *bno || flen != *len) {
> -		trace_xfs_extent_busy_trim(args->pag, *bno, *len, fbno, flen);
> +		trace_xfs_extent_busy_trim(&args->pag->pag_group, *bno, *len,
> +				fbno, flen);

Also, the more I see this sort of convert, the more I want to see a
pag_group(args->pag) helper to match with stuff like pag_mount() and
pag_agno()....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
