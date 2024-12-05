Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6BF1C3C03;
	Thu,  5 Dec 2024 12:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733401089; cv=none; b=R98XitIkSAECAkC7rD22FeUok4Z9pNhF+JweIXiHcVLQoHok6POyMDeMM11KuZOErcOZpZKDQ0ovdxo9JNzl7T5TjkTu2S+0wn/i6XfGYm0ClLg1UuuNqTVDR9Luv3uBeX0Pn0XiTsqhPXfyU1ZqoV4ggyZ5Vklrc7GgRw5TD70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733401089; c=relaxed/simple;
	bh=PUo62EJX+BThvQDC+w6LdhB+MzzOKByD86KNhcVhO4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8uZxCiQMyT8cC+uJnqpEEgCBiOMvqb/noe/xa+EiQXmdzsoUCrYZSa27ye9IwSCg2RC85hqISLg47pW4/A2wNq8pHTIeR8JeBsioHiMRqIS5sTTV/EcSQ2BGvb077+1IQCOFJLu/PgwtOnhqI1n4dlq6HJok+Rb1Z5Qwg71RdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RdHa0+7a; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RdHa0+7a"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-7fc8f0598cdso1550421a12.1;
        Thu, 05 Dec 2024 04:18:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733401087; x=1734005887; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Zt64//0+yWmwpsvZsN0hvJBXBIQLXcI79/2PST6f/w=;
        b=RdHa0+7a2QhNqwNwoneQt5kvZ5bxFWwi7bTqJeQuWBDU0OX5UFBeI//6d/T2h/r+k3
         V75sYbH3mJ2HJM1hz6SltKzhfQNBQjATVlosZZ7cAu4Hl1+RG7nALudW/z6rg9awF4nv
         XDqx8L1zqiaQn3dDlgyZmJoZUV4SRxuMJ+d6D/ZxxjWV0sb3rKLBMfozLIAWKss9su3l
         TEWOKAdArXMsjlhnls2Wb0h+wATmh8QVYGm6kgU0tQHDSftm+TKZjoBWi30fmwlPns7O
         bjaaG79rU9Nyu7N/iCdPHt25g4k6hSIiT2FZMeSFpMgqYUdRqcYkodSgkE6za56Bzo3r
         9zgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733401087; x=1734005887;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Zt64//0+yWmwpsvZsN0hvJBXBIQLXcI79/2PST6f/w=;
        b=sVqLuFT9RHcl6Oy/AY0+ti9dirrtu7tELpVhpfRmay5vJ5T+z9zfWHPGiV7/aNA4ko
         pIeLtUlxbUPL1X8ii6GQGyq65oPfjvROHoEPk/UL718NqMqW4mEpMmlhJ0Y4qI0YBx9E
         q4/62d6EVWd+yiICvp+ye564opkHtU9aeq3UceNLhlWeY3zFSIzWWO7mb3z6zLqfNcSe
         dP94CajeriGGW0zdlsWTwGSmEwOlswXlFgDQW+2SA+CdYfZ6qXw9mpzveus28sGuAhRK
         hdu3pdxrEEmbBL2D68XapXz+DiGv/f3+3M6hGOAopa26gB7+E04dG9dHlYF8ABA1Kvsv
         vmZg==
X-Forwarded-Encrypted: i=1; AJvYcCUSw2fC0x1xNldLmfpxAu0fpvr0sxwQRAOEcmfccz+pqyQp2muVh6opn8snkSz9ulOeMrNTJ5MAN1xkQS4=@vger.kernel.org, AJvYcCXxqcGs0cnHcl1wVor1myImXvg7qFEp3t6jBGllKxMwxp70CPenJMOCy7xW6ZXG+n+ferGahBuWWyw5@vger.kernel.org
X-Gm-Message-State: AOJu0YxpuMT9TKELTQbpZgWc4DiVs4UhJnLzVczQxdTQUQn4DADWuCi1
	xurrblSm/ymH0LN9eH2IbM1gA+ujrieQpN3xNX8Lv1yWxY02GVHj
X-Gm-Gg: ASbGncubRhA0t0MoX3TVfEMBXBoHYKaxUEtNWYPvCXUb3DQipT46P/rpuzymPVrCIMh
	HsLSeSa2E/PJd3TvmqsCItrsrh/xkWSYolN8uOzMkEAbRCqyhJXf0/CG78zMZt3dJOFyI4s8xKo
	N9kkvyqepu3cmL5eGb3sNID4b7O7E4hCKVd6NAUmhCW2W6UEepPgFW1jlfsCZiB+JrcJxsQQaHw
	QEpxKCz+2CJKnxJ2U+NEYL7aL/yTh0hNA6y+Nh7Jj8huc5ztvIR21iY8sT1glqxIQ==
X-Google-Smtp-Source: AGHT+IEL5UGfuGeAUmqHASTYYAbwyriaMmTb6+Tzmt59nbNRjOJxQtSnbfBYSLMnz3+//KwU/WkxNg==
X-Received: by 2002:a05:6a20:7f91:b0:1e0:c713:9a92 with SMTP id adf61e73a8af0-1e17d381480mr4841220637.6.1733401087030;
        Thu, 05 Dec 2024 04:18:07 -0800 (PST)
Received: from localhost.localdomain ([119.28.17.178])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7fd1568eadbsm1159255a12.12.2024.12.05.04.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2024 04:18:06 -0800 (PST)
From: Jinliang Zheng <alexjlzheng@gmail.com>
X-Google-Original-From: Jinliang Zheng <alexjlzheng@tencent.com>
To: david@fromorbit.com
Cc: alexjlzheng@gmail.com,
	alexjlzheng@tencent.com,
	cem@kernel.org,
	chandanbabu@kernel.org,
	dchinner@redhat.com,
	djwong@kernel.org,
	hch@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [RESEND PATCH v2] xfs: fix the entry condition of exact EOF block allocation optimization
Date: Thu,  5 Dec 2024 20:18:02 +0800
Message-ID: <20241205121802.1232223-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.41.1
In-Reply-To: <Z09stGvgxKV91XfX@dread.disaster.area>
References: <Z09stGvgxKV91XfX@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 4 Dec 2024 07:40:20 +1100, Dave Chinner wrote:
> On Sat, Nov 31, 2024 at 07:11:32PM +0800, Jinliang Zheng wrote:
> > When we call create(), lseek() and write() sequentially, offset != 0
> > cannot be used as a judgment condition for whether the file already
> > has extents.
> > 
> > Furthermore, when xfs_bmap_adjacent() has not given a better blkno,
> > it is not necessary to use exact EOF block allocation.
> > 
> > Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
> > ---
> > Changelog:
> > - V2: Fix the entry condition
> > - V1: https://lore.kernel.org/linux-xfs/ZyFJm7xg7Msd6eVr@dread.disaster.area/T/#t
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c | 12 +++++++-----
> >  1 file changed, 7 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 36dd08d13293..c1e5372b6b2e 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -3531,12 +3531,14 @@ xfs_bmap_btalloc_at_eof(
> >  	int			error;
> >  
> >  	/*
> > -	 * If there are already extents in the file, try an exact EOF block
> > -	 * allocation to extend the file as a contiguous extent. If that fails,
> > -	 * or it's the first allocation in a file, just try for a stripe aligned
> > -	 * allocation.
> > +	 * If there are already extents in the file, and xfs_bmap_adjacent() has
> > +	 * given a better blkno, try an exact EOF block allocation to extend the
> > +	 * file as a contiguous extent. If that fails, or it's the first
> > +	 * allocation in a file, just try for a stripe aligned allocation.
> >  	 */
> > -	if (ap->offset) {
> > +	if (ap->prev.br_startoff != NULLFILEOFF &&
> > +	     !isnullstartblock(ap->prev.br_startblock) &&
> > +	     xfs_bmap_adjacent_valid(ap, ap->blkno, ap->prev.br_startblock)) {
> 
> There's no need for calling xfs_bmap_adjacent_valid() here -
> we know that ap->blkno is valid because the
> bounds checking has already been done by xfs_bmap_adjacent().

I'm sorry that I didn't express it clearly, what I meant here is: if we want
to extend the file as a contiguous extent, then ap->blkno must be a better
choice given by xfs_bmap_adjacent() than other default values.

/*
 * If allocating at eof, and there's a previous real block,
 * try to use its last block as our starting point.
 */
if (ap->eof && ap->prev.br_startoff != NULLFILEOFF &&
    !isnullstartblock(ap->prev.br_startblock) &&
    xfs_bmap_adjacent_valid(ap,
		ap->prev.br_startblock + ap->prev.br_blockcount,
		ap->prev.br_startblock)) {
	ap->blkno = ap->prev.br_startblock + ap->prev.br_blockcount; <--- better A
	/*
	 * Adjust for the gap between prevp and us.
	 */
	adjust = ap->offset -
		(ap->prev.br_startoff + ap->prev.br_blockcount);
	if (adjust && xfs_bmap_adjacent_valid(ap, ap->blkno + adjust,
			ap->prev.br_startblock))
		ap->blkno += adjust;                                 <--- better B
	return true;
}

Only when we reach 'better A' or 'better B' of xfs_bmap_adjacent() above, it
is worth trying to use xfs_alloc_vextent_EXACT_bno(). Otherwise, NEAR is
more suitable than EXACT.

Therefore, we need xfs_bmap_adjacent() to determine whether xfs_bmap_adjacent()
has indeed modified ap->blkno.

> 
> Actually, for another patch, the bounds checking in
> xfs_bmap_adjacent_valid() is incorrect. What happens if the last AG
> is a runt? i.e. it open codes xfs_verify_fsbno() and gets it wrong.

For general scenarios, I agree.

But here, the parameters x and y of xfs_bmap_adjacent_valid() are both derived
from ap->prev. Is it possible that it exceeds mp->m_sb.sb_agcount or
mp->m_sb.sb_agblocks?

Thank you :)
Jinliang Zheng

> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
