Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F171F6FBF
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jul 2024 02:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719801012; cv=none; b=JnihtlpEPi5aWYBy2TIPNXe3AV7obmykRtNlfgxGMW6A6BllMZaaTMftSD1a5rM3r4XMsOAlVdlhmWg8QAFYpT5BYd7siDCVLnRQcRewXX0ct9VAVWEApvPtTQzjcNs6Io/9wsZM4Wsvntz1ni7qivBkPA8n5TyTtK4nh5vgunY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719801012; c=relaxed/simple;
	bh=DRH6s4L20XXWMZ3TY+N/ZS7R1lcC8QIWL3eCc8DyInQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=diheJVvyA4ilN/6wXNE34UpBNqWsEYx2++Gm1Y0HXmbJsKWptC8HtMeqxlc7p0jFQTK4PJ4swDEurubMZsPDQv3TgCUy6d1zo1cDfMhfO1nA740WJxOcApsFw1XytpIivy7heZ6zzb4KL3kfGQwrZvfvXP7nNc9U0OJvyV5JRFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=ciuyXIGg; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="ciuyXIGg"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-7276dff62b6so2497754a12.1
        for <linux-xfs@vger.kernel.org>; Sun, 30 Jun 2024 19:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1719801009; x=1720405809; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MSBicNcklROatUuIBNiwtFsZXVmnzGPTjHJq0xkEBwc=;
        b=ciuyXIGgoYons5tNf6C0cHjAAHJ8AHyYzZ3gV4lOhrWFi2Jn4dtRQeO6Yi+/v4E/82
         SvrNlC2O6+U2GW6LX7VjIUI4havkY4PRIT0SdR4QSAPAQwX0JZu41MEyFflYZZcKzLxs
         eqOprVnXXNKeFQwFge52OBnSpdmPTOE3o7/tliTYS3cXWkyIU9sSaTTaUvRMZaJQxfPQ
         6Q+s2UX6yssoqjXnTaJttpbbxMTjZvZcdBz/vok2VL4G7DKGKSBGbhNndKnsNK0vZu0g
         ulzUu39WF35MNvbg79EKwh6uh4IJ4WMEvuVWsUUCRkP64SFeRrKdOHvgbM4db9ElglpB
         2CiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719801009; x=1720405809;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MSBicNcklROatUuIBNiwtFsZXVmnzGPTjHJq0xkEBwc=;
        b=b1D0npf8rNGiOj7Kc6LLufTIze0Rr1Mchpo0QmRGZb2bwX0b5dlNNtplSnKv2B+K1u
         8e8I11TgFe/Vt0cS6yIdReXUPFNID1cPpn44JlM6xMl5Z0OcrxM5FK5t5VogqpL+2EnY
         8EYD3ah1d/4Fnc0JyyQBoNeE+epK0I/4YwskEd8tQp7EEQN8rb2Q/Qw81BYNBZOe4Itp
         CHwUMsy3OuwTj597XZ8IAgy7TyDfSaXG5vTEpRmmoeBQ7Lhms3Eyp2SMbYGV4j5GTjpG
         wXKvbGjNXmbTkyOJ7XKxkJdlNAEA8Xoo8NIX962omk+RyX3fy6oFiZ649saiDysHTl33
         gEew==
X-Forwarded-Encrypted: i=1; AJvYcCUE4Sv6BclutYHbiuQcE5uFi4gS0EHAkNXM/jMoCX3thYxdberqnctadvIX/PFIkUdtCo+V2afN32/JskP5Dzv3oYPtryt3LQQr
X-Gm-Message-State: AOJu0YzzhbUW9uYrQQyZCID/KznyBdNh8vFdLzav32mx2saWNnPPxU+S
	EF41ko14CoM+kacqcbtcle2VTbhgZn1kM5ZOAvnbEXFUO5U9FpUvb7qFgD/M7lw=
X-Google-Smtp-Source: AGHT+IGfuvWdRcjidV4S9XysleefDjy9IBEYtwCKGjJlchcjDMQKchcnBE0eMtORXikYiPwOZq3ibw==
X-Received: by 2002:a17:90a:bf06:b0:2c8:8bf8:4e24 with SMTP id 98e67ed59e1d1-2c93d1ba669mr6841672a91.8.1719801009002;
        Sun, 30 Jun 2024 19:30:09 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c91ce16865sm5582815a91.4.2024.06.30.19.30.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jun 2024 19:30:08 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sO6nu-00HQoM-0f;
	Mon, 01 Jul 2024 12:30:06 +1000
Date: Mon, 1 Jul 2024 12:30:06 +1000
From: Dave Chinner <david@fromorbit.com>
To: Zizhi Wo <wozizhi@huawei.com>
Cc: chandan.babu@oracle.com, djwong@kernel.org, dchinner@redhat.com,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	yangerkun@huawei.com
Subject: Re: [PATCH V3] xfs: Avoid races with cnt_btree lastrec updates
Message-ID: <ZoIUrmB2Jc1KK9Tv@dread.disaster.area>
References: <20240625014651.382485-1-wozizhi@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240625014651.382485-1-wozizhi@huawei.com>

On Tue, Jun 25, 2024 at 09:46:51AM +0800, Zizhi Wo wrote:
> A concurrent file creation and little writing could unexpectedly return
> -ENOSPC error since there is a race window that the allocator could get
> the wrong agf->agf_longest.
> 
> Write file process steps:
> 1) Find the entry that best meets the conditions, then calculate the start
>    address and length of the remaining part of the entry after allocation.
> 2) Delete this entry and update the -current- agf->agf_longest.
> 3) Insert the remaining unused parts of this entry based on the
>    calculations in 1), and update the agf->agf_longest again if necessary.
> 
> Create file process steps:
> 1) Check whether there are free inodes in the inode chunk.
> 2) If there is no free inode, check whether there has space for creating
>    inode chunks, perform the no-lock judgment first.
> 3) If the judgment succeeds, the judgment is performed again with agf lock
>    held. Otherwire, an error is returned directly.
> 
> If the write process is in step 2) but not go to 3) yet, the create file
> process goes to 2) at this time, it may be mistaken for no space,
> resulting in the file system still has space but the file creation fails.
> 
> We have sent two different commits to the community in order to fix this
> problem[1][2]. Unfortunately, both solutions have flaws. In [2], I
> discussed with Dave and Darrick, realized that a better solution to this
> problem requires the "last cnt record tracking" to be ripped out of the
> generic btree code. And surprisingly, Dave directly provided his fix code.
> This patch includes appropriate modifications based on his tmp-code to
> address this issue.
> 
> The entire fix can be roughly divided into two parts:
> 1) Delete the code related to lastrec-update in the generic btree code.
> 2) Place the process of updating longest freespace with cntbt separately
>    to the end of the cntbt modifications. Move the cursor to the rightmost
>    firstly, and update the longest free extent based on the record.
> 
> Note that we can not update the longest with xfs_alloc_get_rec() after
> find the longest record, as xfs_verify_agbno() may not pass because
> pag->block_count is updated on the outside. Therefore, use
> xfs_btree_get_rec() as a replacement.
> 
> [1] https://lore.kernel.org/all/20240419061848.1032366-2-yebin10@huawei.com
> [2] https://lore.kernel.org/all/20240604071121.3981686-1-wozizhi@huawei.com
> 
> Reported by: Ye Bin <yebin10@huawei.com>
> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c       | 115 ++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_alloc_btree.c |  64 ------------------
>  fs/xfs/libxfs/xfs_btree.c       |  51 --------------
>  fs/xfs/libxfs/xfs_btree.h       |  16 +----
>  4 files changed, 116 insertions(+), 130 deletions(-)

Mostly looks good. One small thing to fix, though.

> +/*
> + * Find the rightmost record of the cntbt, and return the longest free space
> + * recorded in it. Simply set both the block number and the length to their
> + * maximum values before searching.
> + */
> +static int
> +xfs_cntbt_longest(
> +	struct xfs_btree_cur	*cnt_cur,
> +	xfs_extlen_t		*longest)
> +{
> +	struct xfs_alloc_rec_incore irec;
> +	union xfs_btree_rec	    *rec;
> +	int			    stat = 0;
> +	int			    error;
> +
> +	memset(&cnt_cur->bc_rec, 0xFF, sizeof(cnt_cur->bc_rec));
> +	error = xfs_btree_lookup(cnt_cur, XFS_LOOKUP_LE, &stat);
> +	if (error)
> +		return error;
> +	if (!stat) {
> +		/* totally empty tree */
> +		*longest = 0;
> +		return 0;
> +	}
> +
> +	error = xfs_btree_get_rec(cnt_cur, &rec, &stat);
> +	if (error)
> +		return error;
> +	if (!stat) {
> +		ASSERT(0);
> +		*longest = 0;
> +		return 0;

If we don't find a record, some kind of btree corruption has been
encountered. Rather than "ASSERT(0)" here, this should fail in
production systems in a way that admins and online repair will
notice:

	if (XFS_IS_CORRUPT(mp, stat != 0)) {
		xfs_btree_mark_sick(cnt_cur);
		return -EFSCORRUPTED;
	}

-Dave.
-- 
Dave Chinner
david@fromorbit.com
