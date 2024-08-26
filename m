Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E02929A2
	for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2024 09:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724665969; cv=none; b=PADWeUkS2p8ZxO9h/mgAJdx0moH1Dtqo7EIJgA/x3kyPpNmLkS8LPucRPClVEJlMOJI1bl6/315BYrj3oqpGaYWALZk9/PKjFUboKx9GCn8KSnT11NaPoITMETB4keTGuow8RBIZkcQGZRqBpxBhxfm8rHboelY5ARwRa2/xaGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724665969; c=relaxed/simple;
	bh=yVv2ZD4JDRaJnmRo41nYxebQYsdVvgAf0RXCib/5zfA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PnQQ/5M/k5jO8LXN+aTajkNCEQWVYZOgDNP7pWG/2McVNfLQS3MooL/R8sDDz0cZL4mftQWyUYQD7WVB1V4VJC2iwJu5XMXN+vdTtRFHonl7XpR0OEqpPwyfpKwwEecl8UxJj8QdptqNZXbGl3BrLoKRJOaG69GuIR6TShft8x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=22aaa44+; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="22aaa44+"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7142a30e3bdso3722580b3a.0
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2024 02:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724665967; x=1725270767; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=d+4uWT5u9EXwJzJqPfMzWlIWod6Em7RtLIma3A0QCBs=;
        b=22aaa44+it2Z/MELu2hR9AMrI5TPi3+NW7TqoF2jUX/0QCxB6fWFwEF9gmvHoxkRAt
         8CZQQFq31m8HB89yb+LmdJ/Jb7F735KNRyUBUv2oWMT7x8jnVbXdzn0pwKhB0sBFJ6ec
         w9JgyvHwGocfSYEzoyD7uTWGCnowzrDj3G7z7cmF6LtO84eNVrhRTFYJBfV1REqqcfts
         KmgPbDy3wE7fXsNRBROJFVL9jkcn4GyR0yaLx8gPnfVjS5Avm+MYA6bLp6LBD2M/QfsG
         UFbSXAR9HS9s3ggQtU3DijsfOZFHTIkLiGp6FytQoPbRqwYuuZdUfLAGpW/fT422MRLD
         83aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724665967; x=1725270767;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d+4uWT5u9EXwJzJqPfMzWlIWod6Em7RtLIma3A0QCBs=;
        b=qMnV/Ib/P776O9Xjjb85T5Db8PW8DXyTczv7IWv9qe3P12SHV7Hg0F9K9d+65/jdjf
         TKuyUbLy+k7EKku9NAjP9FkXVFBwK5LfbQUbRAaMEoF9vjNaHUFkBJ7McddcghFKvZDU
         YHsdSaN6lc2M20KEmrWA1jREPBVdc2rWicHB0fZiJZEuqzB4A2nMhlxK25TBXIwlYIqi
         84h0tYnQfFLVjo4uFVkRLf4UoonqhB/+06YIlxq5a04KkfzJT8nQUXwcr3kM8PgG17sv
         ZIFXZ12VaCOBJh/jgOa244O4rk2Hf9QOtK3IV3e7Vkem3FHoV+6fVGiqIcvM3Ha+wiT1
         kBDQ==
X-Forwarded-Encrypted: i=1; AJvYcCWERZMgVVByHkR2odHk5Z+IZ8uca+N8Bf6NSLWZOCx+tWilyzyryA5hUVicYhWlrH9oNjOB8V/gu/E=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwE2VYiqJPYlDi+o6umLKW1/D4sevbzfH8N5EpM5APNtfGVbFj
	hoiW+Gt16ChxTTjqy206CbxzzE4ZTl9cAbNW3u1yaBGSohpd9f78Y5+VWb6MOHQ=
X-Google-Smtp-Source: AGHT+IFnXgbIsIn9FHkZFYHVE8s6fWd7Vo2X13C2vOv6GRybDPOCulAxtivfoeFJ4JXIBBHm6QtSsQ==
X-Received: by 2002:a05:6a21:394c:b0:1be:c41d:b6b7 with SMTP id adf61e73a8af0-1cc89ee525fmr19190282637.19.1724665966752;
        Mon, 26 Aug 2024 02:52:46 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7cd9abfd5b1sm7267259a12.0.2024.08.26.02.52.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 02:52:46 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1siWOy-00DE9N-02;
	Mon, 26 Aug 2024 19:52:44 +1000
Date: Mon, 26 Aug 2024 19:52:43 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: update sb field checks when metadir is turned on
Message-ID: <ZsxQa3xvdkrwvN48@dread.disaster.area>
References: <172437089342.61495.12289421749855228771.stgit@frogsfrogsfrogs>
 <172437089450.61495.17228908896759675474.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437089450.61495.17228908896759675474.stgit@frogsfrogsfrogs>

On Thu, Aug 22, 2024 at 05:29:15PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When metadir is enabled, we want to check the two new rtgroups fields,
> and we don't want to check the old inumbers that are now in the metadir.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/agheader.c |   36 ++++++++++++++++++++++++------------
>  1 file changed, 24 insertions(+), 12 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> index cad997f38a424..0d22d70950a5c 100644
> --- a/fs/xfs/scrub/agheader.c
> +++ b/fs/xfs/scrub/agheader.c
> @@ -147,14 +147,14 @@ xchk_superblock(
>  	if (xfs_has_metadir(sc->mp)) {
>  		if (sb->sb_metadirino != cpu_to_be64(mp->m_sb.sb_metadirino))
>  			xchk_block_set_preen(sc, bp);
> +	} else {
> +		if (sb->sb_rbmino != cpu_to_be64(mp->m_sb.sb_rbmino))
> +			xchk_block_set_preen(sc, bp);
> +
> +		if (sb->sb_rsumino != cpu_to_be64(mp->m_sb.sb_rsumino))
> +			xchk_block_set_preen(sc, bp);
>  	}
>  
> -	if (sb->sb_rbmino != cpu_to_be64(mp->m_sb.sb_rbmino))
> -		xchk_block_set_preen(sc, bp);
> -
> -	if (sb->sb_rsumino != cpu_to_be64(mp->m_sb.sb_rsumino))
> -		xchk_block_set_preen(sc, bp);
> -

If metadir is enabled, then shouldn't sb->sb_rbmino/sb_rsumino both
be NULLFSINO to indicate they aren't valid?

Given the rt inodes should have a well defined value even when
metadir is enabled, I would say the current code that is validating
the values are consistent with the primary across all secondary
superblocks is correct and this change is unnecessary....


> @@ -229,11 +229,13 @@ xchk_superblock(
>  	 * sb_icount, sb_ifree, sb_fdblocks, sb_frexents
>  	 */
>  
> -	if (sb->sb_uquotino != cpu_to_be64(mp->m_sb.sb_uquotino))
> -		xchk_block_set_preen(sc, bp);
> +	if (!xfs_has_metadir(mp)) {
> +		if (sb->sb_uquotino != cpu_to_be64(mp->m_sb.sb_uquotino))
> +			xchk_block_set_preen(sc, bp);
>  
> -	if (sb->sb_gquotino != cpu_to_be64(mp->m_sb.sb_gquotino))
> -		xchk_block_set_preen(sc, bp);
> +		if (sb->sb_gquotino != cpu_to_be64(mp->m_sb.sb_gquotino))
> +			xchk_block_set_preen(sc, bp);
> +	}

Same - if metadir is in use and quota inodes are in the metadir,
then the superblock quota inodes should be NULLFSINO....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
