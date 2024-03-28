Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F291E1DA5E
	for <linux-xfs@vger.kernel.org>; Thu, 28 Mar 2024 04:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711600061; cv=none; b=m1vq825q73cWKjp5vodpqf4tZN0PD1FxqTTsxqezwLmB0N0jrlV9shZuqvmeZ1Oa+2jAKJhXkqXntS41fn9Ocq7/7KrR4Lu+qbOp2JAYVYXkoQM+RJ9vR+iCy7nZhmNUzkGaOFRvL8QhY/eCk1RFKpV9Dy/kiiPPlz4kFaNt+gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711600061; c=relaxed/simple;
	bh=npvGrKPTGctujE1i1j7WFaa3E4UtjZ4sJ+OV/F7qR2s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pJ+QM/EiehUJC7yZteqcNIeZbaRVnHDj7qq8QSGy1XwwMCr1y+XHE/D0sMsULTdWkU2FmEdXUtbgZEeazx2em9+D9IwkBdC217rquK9MaclmBR7bo+dL3EAbBCDdpQxaLrTs2WAvsNrBjsv9QQkZd0Ri89El2mF/Y1cxPjYptVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=R5p3lamU; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="R5p3lamU"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6e73e8bdea2so532859b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 21:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1711600059; x=1712204859; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wuvLpCa1cnZhin+ssI5p337DKn3LL+yYkFLBDdooWto=;
        b=R5p3lamUu5v1XGuGpCidP6dUjuNk8uWV43oczu1G7vmoGVjXrxuJ9idouj6AqQEJIZ
         BO5xnhqovk72673OzvYSLT76WSQjFSZRaG24B5sQ4sqb5wytcyIh3hKaRCvGwOHRaSbI
         2ZFRYdzK2vJACZbNYCMM62eNeCz4HWKgPqzivoikdG909P3wEj8OwM7Oygl2xV2Z72zH
         HwQHXFX2tZgzTiP4fCom5ArvFsmhft0MTNFgoyx1rXxxrJrexGa5gSGEKPc2NF6oZnrw
         qqBpLENNVW1kbIIoSvCprp0AltJlrWZiXCbjZQcvENVh3pgUpcxdNkSObB7yv51IVH0a
         Ub3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711600059; x=1712204859;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wuvLpCa1cnZhin+ssI5p337DKn3LL+yYkFLBDdooWto=;
        b=vWdN9KqF2LzGKliP2XpIFTzl4yJYKlmDcBRKKW3KRZNuXlZtGQoR/cpfyN0E8Pgfpy
         AmwYmIF121zQTKQ+M/aY2p6eDA+CwIuVtl73/+IHlw6YKpakPe2BiegriXtRSQcxaJlb
         psY7OXLB5nTPvY1im2nU2k3upxs++aqbjKcE7XgIis3c2OHgatmgjus5LRq+IOPbC7NF
         IpYSzmf4MJ0mDQcTpoAsnm5H+NdqXRtOXEH/JTqII4lw/D6dTeawvOvJX5sPa0RVqO2p
         XNuRW0n6KsIywecOqvpNUz6+2u09AW+10eCryIclvWKo4OGVb1YOctE0ZesnkjXfAb/R
         g7jg==
X-Forwarded-Encrypted: i=1; AJvYcCVnS13VdrVlGfgLEloq1pA0J8u53eXIjOnAD5BMwO/NFXE4SMMjdHxxDpP1LKOTVtuiv+5a14niuQ73Rv9b+2LiO9Hi5TV8jG4z
X-Gm-Message-State: AOJu0YxahHPa+90ZcJkzouMZvwqj3HEi2yqmX8SxT2z/+DqVpumkr5Cn
	3gWlhmLWE9xEaosPIKQ0j6OeXcaGo4jp9bOdshI4vhPOkR1LqgtbWOcKwq7C2b4=
X-Google-Smtp-Source: AGHT+IEaS5Wgpobo7J5VRnAljrG8gAA3MnKJR0HIg3tb79vLgyctMYcgmiIU3+R02Ms8o74pI4NOqQ==
X-Received: by 2002:a05:6a21:3a85:b0:1a5:6d13:2afc with SMTP id zv5-20020a056a213a8500b001a56d132afcmr956021pzb.11.1711600059124;
        Wed, 27 Mar 2024 21:27:39 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id m9-20020a170902db0900b001dd578121d4sm396127plx.204.2024.03.27.21.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 21:27:38 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rphMW-00Cgph-0L;
	Thu, 28 Mar 2024 15:27:36 +1100
Date: Thu, 28 Mar 2024 15:27:36 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/13] xfs: support RT inodes in xfs_mod_delalloc
Message-ID: <ZgTxuNgPIy6/PujI@dread.disaster.area>
References: <20240327110318.2776850-1-hch@lst.de>
 <20240327110318.2776850-10-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327110318.2776850-10-hch@lst.de>

On Wed, Mar 27, 2024 at 12:03:14PM +0100, Christoph Hellwig wrote:
> To prepare for re-enabling delalloc on RT devices, track the data blocks
> (which use the RT device when the inode sits on it) and the indirect
> blocks (which don't) separately to xfs_mod_delalloc, and add a new
> percpu counter to also track the RT delalloc blocks.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
.....
> diff --git a/fs/xfs/scrub/fscounters_repair.c b/fs/xfs/scrub/fscounters_repair.c
> index 94cdb852bee462..210ebbcf3e1520 100644
> --- a/fs/xfs/scrub/fscounters_repair.c
> +++ b/fs/xfs/scrub/fscounters_repair.c
> @@ -65,7 +65,8 @@ xrep_fscounters(
>  	percpu_counter_set(&mp->m_icount, fsc->icount);
>  	percpu_counter_set(&mp->m_ifree, fsc->ifree);
>  	percpu_counter_set(&mp->m_fdblocks, fsc->fdblocks);
> -	percpu_counter_set(&mp->m_frextents, fsc->frextents);
> +	percpu_counter_set(&mp->m_frextents,
> +		fsc->frextents - fsc->frextents_delayed);
>  	mp->m_sb.sb_frextents = fsc->frextents;

Why do we set mp->m_frextents differently to mp->m_fdblocks?
Surely if we have to care about delalloc blocks here, we have to
process both data device and rt device delalloc block accounting the
same way, right?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
