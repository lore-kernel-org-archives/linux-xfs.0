Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458272628D
	for <linux-xfs@vger.kernel.org>; Sun,  7 Apr 2024 23:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712531255; cv=none; b=YzRkwOr/Mm42z+jU7OMkcxAtgZ3rWU79hKCLKvZkkQ1vyuAZ2SxZqcXFMMf1FDpre/1vZS24y9TerB5BdR+CglR8vbF1Lh0TufBWajlwIxwcfDRm4BoSXCvaw/mdLDkp4CTQFVml1tqgD3gfAUg87mecwGm7BFD/Kh/OXnPUafY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712531255; c=relaxed/simple;
	bh=ONGjKFAbP2KwL8tk+cWYx8n07qbkcNEh2mFLOF5mvag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qtgGmKxEBL4O0WIgKQxmTORJO1hb2IOFcLd5WlTJU6B99R4jaa7aLjB+OStyJBub7lNjtOfnk5YR0lRFaP4GiTY5vObiyERj/rUBxmuhcl27JH77pfAVBqZNSv0OMYCbRQ/2/1FjlsAxpSFso7lgYIz2f2bCBfAiPkcbKuJybyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Clndp4Uf; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Clndp4Uf"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6ecf3f001c5so3121210b3a.1
        for <linux-xfs@vger.kernel.org>; Sun, 07 Apr 2024 16:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712531253; x=1713136053; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wXL05i7JyxmKJkez86hUqR8lOvldxozW+o8Pbcsoq6U=;
        b=Clndp4Ufd7EDq69ov8RvitMnM4/gn29qSipsJJo6tnn9xkFgq2np6kqaIlNy+FQAqY
         Ie7Xh5FJ7zjO3NbBpp/nZzJJ+FhTb62Szciad6I56DSawyEJuEi5evO8i7+PD/gwHyqc
         jlYdFMJDHSWUPHZlSbxq1/Lvg2baxoG4o4ZY2c82rxxFwtG4ssFTHdHSyet9aBU0kMGE
         KjfG6QDmzPbFsDC3wMr1p6uwo1HOxWUEWEOtgM3I07kAyZLHExqhNSPzw3BEPGl/uBuj
         zYtKOsbpChR7YnNlf9nUm5XITp2afFLbMRpvAwhuofXJDAG7HEW3SlInct8VAfSf1WCz
         vpGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712531253; x=1713136053;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wXL05i7JyxmKJkez86hUqR8lOvldxozW+o8Pbcsoq6U=;
        b=du3VNBpScdGQl+CXSZj3lLk7sRuobtiqlU2tMORWxEllICClC3xdBt5HKMb9JhcsUv
         0jhn/FD+xfHvV2Cndhl36gcIAKeqlrTMEsMj8rvlxOU/Qis6IHgztm6dO96IXLENAw6T
         BIplU66wdyFmm1m2oL2GeGY2ZEcdmxqQUN1dhv/WiGgif8dNQsjFJfLAfbEAMIz2tisq
         TgPjdeCNT/fgxhAiqUpy9aCCFtJiSfBH8PPwiluWJGCR/zaYMQjaVntSV7jV8u1OcQMk
         1lmZb2C4C29UGoxscsQr/0IuSpaK+8ciyr8/G/5dywSLds/UrZdir6+8rJqSjPiqFkf2
         LzRg==
X-Forwarded-Encrypted: i=1; AJvYcCVetzMf8EXuWWWVeajFWMD2298wdynF9MS+wjBy9Occo1SHm+xLYtL77j4CJgBzbp8I10kLuvqCjPq4JhfXMYr7o3G3aPFjTYte
X-Gm-Message-State: AOJu0Yz8lWQk37BWNFpPDqNZ5LLT9FBvIFppQRTRCneHU8Qgxvrn+/jU
	43ZnSUBAu9MrLhODm9hQ14w3oR3ZTvtfcCgB9X/yNxi28nb40Q6YXZp3BGkTXEg=
X-Google-Smtp-Source: AGHT+IHsSvc4wdwn+oxkQtRqcEQJowrMZfLjcXAmQqT7gaFiEeAos2k8drR5jW2CILt0ZNNJFIap1Q==
X-Received: by 2002:a05:6a21:1506:b0:1a7:7ac1:a3ba with SMTP id nq6-20020a056a21150600b001a77ac1a3bamr618180pzb.53.1712531253353;
        Sun, 07 Apr 2024 16:07:33 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id ei24-20020a17090ae55800b002a386a4d6b0sm4889235pjb.6.2024.04.07.16.07.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Apr 2024 16:07:32 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rtbbl-007jAi-0k;
	Mon, 08 Apr 2024 09:07:29 +1000
Date: Mon, 8 Apr 2024 09:07:29 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: hoist multi-fsb allocation unit detection to a
 helper
Message-ID: <ZhMnMWaQueOm+0Td@dread.disaster.area>
References: <171150380117.3216450.660937377362010507.stgit@frogsfrogsfrogs>
 <171150380216.3216450.3675851752965499332.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171150380216.3216450.3675851752965499332.stgit@frogsfrogsfrogs>

On Tue, Mar 26, 2024 at 06:52:18PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Replace the open-coded logic to decide if a file has a multi-fsb
> allocation unit to a helper to make the code easier to read.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_bmap_util.c |    4 ++--
>  fs/xfs/xfs_inode.h     |    9 +++++++++
>  2 files changed, 11 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 19e11d1da6607..c17b5858fed62 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -542,7 +542,7 @@ xfs_can_free_eofblocks(
>  	 * forever.
>  	 */
>  	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_ISIZE(ip));
> -	if (XFS_IS_REALTIME_INODE(ip) && mp->m_sb.sb_rextsize > 1)
> +	if (xfs_inode_has_bigallocunit(ip))
>  		end_fsb = xfs_rtb_roundup_rtx(mp, end_fsb);

This makes no sense with the upcoming forced alignment changes to
this code.

That essentially brings "big alloc unit" to the data device based on
extent size hints, and it will need to do different rounding
calculations depending on whether it is a RT inode or not. Hence I
don't think hiding the RT specific allocation/truncation setup like
this is compatible with those changes - it will simply have to be
undone before it can be reworked....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
