Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF352F532F
	for <linux-xfs@vger.kernel.org>; Tue, 17 Jun 2025 22:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750199727; cv=none; b=am+D1T983FriIqevMbUr+3iPf6fWe3zTlRbCrGujiGnpSI0qYhfeZ8UeOqiLNnZw2H60oNlSz80t9WzV02zcgRpMxj3k2ojfjwfmTNmQKnsSXewvoh6T7AjoXT5qNQlmQYM1i8B4TnGoFNL4SVa59HjheOUlSfWQzChLWJ3BPtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750199727; c=relaxed/simple;
	bh=1LwpQYQ8vV9Yp7xSE7r3j5Gz/pi79MqsZYXhBsPq1PI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p9fHp/FDv5DgH6iUok8vP1+nPx1pk8fpH/jYgtZVzHrozxJYD7IqWY7Uw85RIiOY4w0ndr7UHWQ/eU2+PvYDIhiaZ9La6tle/yOz7kUoF70e5PgugV/Crkxsc+hTcpgv19DnBi5GQMPqZomhlEKDY8FEIyMYVxxsC23N/TfRq+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=pAelLAOG; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="pAelLAOG"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-747fba9f962so141438b3a.0
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jun 2025 15:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1750199725; x=1750804525; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oqM6E4pYb8ToCj404tvr9xMsBDXlf0joR68K+bg2388=;
        b=pAelLAOGM2Sc6zf0yH9TCa80LHoZK945wEztefoXeeAo0sv7liSNzpZoQDntWW83Ae
         DkUYRTE6VWOmrOmYdcz1wxMMO75bxQ4em3cGwTwbze+hRgDXt5pndhNqc0NSJIsHguop
         ej2jwIASklF8Iu+uK+eEr1TRsVVgnvAs61/2KZ6HqOgV5Qb9kXvcxNQyIqsBCaVyPkza
         S9zEXrzZCvYLVysT6CvKDqmXi5zCaPNJdj4tEBJxHlrLZL9Jx7ybuZUwYPkwDrgsMZbj
         i99IKtxnRpG6GTw3MIXOPO6L1jLlFdQgVSwvDZUa8m15JXHLUaXhuxUCpBE214Z3IO87
         XvJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750199725; x=1750804525;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oqM6E4pYb8ToCj404tvr9xMsBDXlf0joR68K+bg2388=;
        b=W4tflRc0cBOBZza1j5c0BbwZRz+gFOoBUxnvGqfxLM1mDoIAyqzZKkxNcD/ouVyUc/
         XxxnskxfCDazkjh7OqQQvOcPKqAc/AUtG29W3pzWPPVP7ThjN8gyyWxZeb8LyHbYcDLM
         zjaEPkOOJ2+EsQg/DR4KChT9HbYSPCoece+wh6YYvciF8NEudb/brBbYoaICNc1hCyFC
         xDPXRi/oQ4XhYvg82ROkNwHLIORJclwN5sWCtTKAfVtxf/phT/3xcfdEpsmbuSSQoiIw
         XnERkbvgdQUA6ItSV1C3s9a5XbqLDuYrm6EYZKFLjwI3h7H+XSz7OoFcw2WnZI1qWY70
         q3lg==
X-Forwarded-Encrypted: i=1; AJvYcCWnSdd0V3HPu0GVNrzfwUk45JTYNv3CzSA6JklfEvdnS9XuMueeuK55u/fiYHy1pO12Rl6jBrLl7d0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzeth6E6nmGVtMYRUkKTDRssRrMcmA3tJygzpxbFvM9GJncRpAT
	icflKwh4Pb39rBYdmvshoBRFsuinpkDzEGeI80uv80GE3+7uRkid5UgyNLinFr5P8Ic=
X-Gm-Gg: ASbGncsP6cUTJbIiv26Xw3kGsHdkWOHV7LXGiRBIHLm0Q5jX1SqBAAa8xGqsoGj0P3E
	zU3UUhC4/1P+LcZxuwXK/8rV0PXZvtmADeySlqc7j9NEDr4+qt2+K+f5Ma2fhBE4D5lFmZ8q2VJ
	sSF5jAHDl3Llo+SMb03+bLFTB54auj9A9Wd9Ls3Fo+38CtJjCWZ7B80T/aM3fNRDVnJ+wU40FPs
	y7Mhzn/Rlv/R/DjukiB1l7XOygNMztnBSyeRBJhxX+nzvHPp/Km6es4nvh5VcbKtLV3Qaai/Alj
	+ZkRnDpxCjpdr57m5sSBf+7XSp9N8ptbENWpAUSoDKjF4QirLoFyOnIi7TpfVAYptR9axmeTby1
	pPtWKZ4nS6HjfjcutbO8rKUzz7JYMBgZmEVAnOA==
X-Google-Smtp-Source: AGHT+IElctafbrppd8kIYbt1GKxVPFByOdinrXCKLG00L434F4V/9mjE5OwJXPNRuiPakdkO0kDMgg==
X-Received: by 2002:a05:6a00:854:b0:736:9f2e:1357 with SMTP id d2e1a72fcca58-748e7077f9dmr346767b3a.12.1750199724720;
        Tue, 17 Jun 2025 15:35:24 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-184-88.pa.nsw.optusnet.com.au. [49.180.184.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-748900ca8afsm9785937b3a.145.2025.06.17.15.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 15:35:24 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uRetl-00000000B0S-38M4;
	Wed, 18 Jun 2025 08:35:21 +1000
Date: Wed, 18 Jun 2025 08:35:21 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: cleanup log item formatting
Message-ID: <aFHtqTWIueE9IvOI@dread.disaster.area>
References: <20250610051644.2052814-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250610051644.2052814-1-hch@lst.de>

On Tue, Jun 10, 2025 at 07:14:57AM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> I dug into a rabit hole about the log item formatting recently,
> and noticed that the handling of the opheaders is still pretty
> ugly because it leaks pre-delayed logging implementation
> details into the log item implementations.
> 
> The core of this series is to remove the to reserve space in the
> CIL buffers/shadow buffers for the opheaders that already were
> generated more or less on the fly by the lowlevel log write
> code anyway, but there's lots of other cleanups around it.
> 
> Diffstat:
>  libxfs/xfs_log_format.h  |   54 -----
>  libxfs/xfs_log_recover.h |    6 
>  xfs_attr_item.c          |  156 +++++++-------
>  xfs_attr_item.h          |    8 
>  xfs_bmap_item.c          |   28 +-
>  xfs_buf_item.c           |   27 +-
>  xfs_buf_item.h           |    2 
>  xfs_buf_item_recover.c   |   38 +--
>  xfs_dquot_item.c         |    9 
>  xfs_dquot_item_recover.c |   20 -
>  xfs_exchmaps_item.c      |   19 -
>  xfs_extfree_item.c       |   69 +++---
>  xfs_icreate_item.c       |    8 
>  xfs_inode_item.c         |   55 ++---
>  xfs_inode_item.h         |    4 
>  xfs_inode_item_recover.c |   26 +-
>  xfs_log.c                |  503 ++++++++++++++++++-----------------------------
>  xfs_log.h                |  106 ++++-----
>  xfs_log_cil.c            |  195 ++++++++++--------
>  xfs_log_priv.h           |   29 ++
>  xfs_log_recover.c        |   16 -
>  xfs_refcount_item.c      |   44 +---
>  xfs_rmap_item.c          |   44 +---
>  xfs_trans.h              |    5 
>  24 files changed, 668 insertions(+), 803 deletions(-)

That's a pretty major rewrite of the core journal formatting and
iclog writing subsystem. That's going to need a lot of careful
review as well as correctness and recovery testing. It probably also
needs perf regression testing, as these paths are critical for
metadata performance...

Do you have a git branch for this series that I can pull?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
