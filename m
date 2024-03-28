Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138E920DF7
	for <linux-xfs@vger.kernel.org>; Thu, 28 Mar 2024 04:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711600789; cv=none; b=dhNdHvwfajpiwmTh4YLYZU/A+GAgUcVl87Th50yo0ZQSgBuHMYXaeqxFqZfavndIBrSTO+NvsL7yRdCqEUqMqE8M2l/d/RsOirDuZ8AVxT4eOP5L+kCcGn3J+6MDraUhXsDrKiwYhs4+lA6MJmW8VzrNGRCZr5r9WLveL2OJDNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711600789; c=relaxed/simple;
	bh=gAYfbs5/UXaMHU6Nn7i/KMFISaW2UNedKeo012BvIsc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WedO4n7y5YBCoWev9qhYlP0XnfeOZuwLy2tLehumpEobrgLJ+Tayb2TmD+ZHSOy9KUHM+oGgPwC0WjtHGto5l7v94/InxaZ0scQ+G8dChIv5Gp+e8mzgcPV+iENscdlbcKqZjZdrI9w/48v/ucICyCRQWiJ7dCWBCuuBQolJAxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=VxvsgTI+; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="VxvsgTI+"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6ea9a605ca7so448669b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 21:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1711600787; x=1712205587; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OIStuihfXCHY9tP0NPfo5WjS4VyWwcMNeJl3yHPqGME=;
        b=VxvsgTI+raEJqOsvMuFcjPn9r7Fg8o2ZsGpgVxLbOpCuzl00qTGE8sq6XYe9eyAibP
         WwGTjGMLQ3f/9qMH1OwD72ZtKf1oYL/9hRPwKS/LbucFu1OgZWfEcbUCzQPN4wH/0Box
         2ZHUI5BrWnoTOnXURtUJFE2hg+jiAlMlF6P/bvgVH6trXzmFdOF1JzHHQy4qVILhzRxn
         14HNiz5aQ8ifcO0yXRsn9GRUSVlzI60L92uvlDBoyjgW5rS2beIivt0p5hPqBikDNkhg
         OR9+dC6RMRJdESU/BLTBdhPU5b2CbFySjghlUqkjIZEWX2jrOow/QXWJ7ooGRwOeGSQH
         VGhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711600787; x=1712205587;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OIStuihfXCHY9tP0NPfo5WjS4VyWwcMNeJl3yHPqGME=;
        b=NtE9eQh5hszd7E+BooHD0z69+d7VkAhuBIulPLwSBQ/dK8ETMQe+J9McsxWhRCtpfX
         2+OMu1NxVxQeXaQvuiEs9L0L1y7p5h3m9U676w/XVzzksd67xOvhcR8mRb862C71ullX
         VLQ5ifDFl2NCMVz24jpEeJ/D4LYrYrnWoc7wXCkv8vRwiKN0v2bxfuRWsXs8pAoeVAUv
         DlXsbyxbPSgVhUtpGJfcky9+oZMXW0wq8B+Dma6tpQSrULYGcCWoyi2h3HRa6vsMG2A9
         FNr30hlMK6125WaSmhcBELhc0viN5QnRBwHH7jMMNL1zFcihc1lKHjeeKgMj8qLZoTAB
         y3mw==
X-Forwarded-Encrypted: i=1; AJvYcCUlPo2Xx2h/eSg1KTqIDRmz/hmTzBbmIlYVG+GFHdo3EPwGNqV6GdzzKTcSvOjupSvwyyTy5TWSIdXAhosEMWJjYRSSY7CBA+k6
X-Gm-Message-State: AOJu0YwrRmEcAhz43FegLuUZ3VaLlpkUaIm7Q6Glkd0m0VUHvjlVp6kr
	6lJN/OUM2zi6M7UcwONTUN+KGKtObHtHry9ghjugi2AazuzhDJ6IT20jJFzXlLk=
X-Google-Smtp-Source: AGHT+IFvDWlKbwmqa23UMMoEdXbUhh66RLpE2Q/4mhZeE1ucFm9Cu/UrL5KV4/8Y10D+w/GkbWWEFg==
X-Received: by 2002:a05:6a00:3928:b0:6e7:1ce6:a2f5 with SMTP id fh40-20020a056a00392800b006e71ce6a2f5mr1721652pfb.17.1711600787273;
        Wed, 27 Mar 2024 21:39:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id fj14-20020a056a003a0e00b006e554afa254sm403636pfb.38.2024.03.27.21.39.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 21:39:46 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rphYG-00ChPC-28;
	Thu, 28 Mar 2024 15:39:44 +1100
Date: Thu, 28 Mar 2024 15:39:44 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/13] xfs: reinstate delalloc for RT inodes (if
 sb_rextsize == 1)
Message-ID: <ZgT0kHCD5AthOKjQ@dread.disaster.area>
References: <20240327110318.2776850-1-hch@lst.de>
 <20240327110318.2776850-14-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327110318.2776850-14-hch@lst.de>

On Wed, Mar 27, 2024 at 12:03:18PM +0100, Christoph Hellwig wrote:
> Commit aff3a9edb708 ("xfs: Use preallocation for inodes with extsz
> hints") disabled delayed allocation for all inodes with extent size
> hints due a data exposure problem.  It turns out we fixed this data
> exposure problem since by always creating unwritten extents for
> delalloc conversions due to more data exposure problems, but the
> writeback path doesn't actually support extent size hints when
> converting delalloc these days, which probably isn't a problem given
> that people using the hints know what they get.
>
> However due to the way how xfs_get_extsz_hint is implemented, it
> always claims an extent size hint for RT inodes even if the RT
> extent size is a single FSB.  Due to that the above commit effectively
> disabled delalloc support for RT inodes.
> 
> Switch xfs_get_extsz_hint to return 0 for this case and work around
> that in a few places to reinstate delalloc support for RT inodes on
> file systems with an sb_rextsize of 1.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Looks OK.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
