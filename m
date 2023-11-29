Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="1m7GaBJA"
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C006818D
	for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 01:04:40 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-6cbc8199a2aso5625735b3a.1
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 01:04:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1701248680; x=1701853480; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IJkUwFni1tyd1Oj/0WIsU7esF/PDsZcmLt4NR+sDyhA=;
        b=1m7GaBJAX/dBoRSQky6TREt+1U8mO1oI0WgxSpNuoJblzBB03cw5l5PT6qDgruRROw
         m8v07aPBQEdJEZeSiukVl4MwJH2ZDL+SlcdDiUJekhCniVJz45y5CMY1Ul61pvwQ3C3q
         ILs9TPFeFTcu8o8D+s+rfYvBsPcZM0LAocIG0qblC7cr6WCLQQSx9cIRxGn/aW5cLHmx
         jl0ZzQfb78/kTspGnb2HtgVPwmQCDYlylKmQTYdUBeKckNs7SZFS/P2iFGwYt7JAWNgG
         x+f/p7Jkq5zvTJ16ce7XqNmMjOIJXjKP/UETFhA6hakkF6g77YsuGKyprpsM+02HsN2K
         Ju2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701248680; x=1701853480;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IJkUwFni1tyd1Oj/0WIsU7esF/PDsZcmLt4NR+sDyhA=;
        b=IP/dO3it61Tt4hbp6J8lHPzIj+Hq7+PZ+94EMf1oqF8l8QJdgx86PeTUaLcrBrdZtI
         cY+CalNuKMh8Oaiv1khDncBZz6fTLV+MUeu+AhE7xJ3uxSciqo9R0EBcVbn2s23hC97r
         H+2ZNtEcoL5ZTO1kZOCaKcCNjMOshJZ+XordPoFQzQd3wDOkDxS2PZA6AINyRGVZ6Ix9
         OXS+8CK0QfkGt+70SiCU+07dOHxhQPafwLG4FTC44l/8xdVwUa0vJJ84+D8smg5zdMPZ
         Ed1yn0gKlRm36NhLbSJIfdHvgNmWuhzB3ZIN/mo1gMrdaFG3ds7HmQMcCiTPNEl8JWa0
         x8rg==
X-Gm-Message-State: AOJu0YwMqDRrxS5AXg2qIxkUGEScQplVaeqeFaH88rQ5w5nYqeLt483O
	mstM15Wl8qWccpCUvLMxIgKTnQ==
X-Google-Smtp-Source: AGHT+IHQ7A+ROUiPAUUtY1Bc1W2rd4y42lCFAgTt5oxHaM+7IKovLk3TNzT/G4os+71nI+Fk2jOC8Q==
X-Received: by 2002:a05:6a20:728f:b0:18c:4b7:2da5 with SMTP id o15-20020a056a20728f00b0018c04b72da5mr17600536pzk.54.1701248680233;
        Wed, 29 Nov 2023 01:04:40 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id y10-20020a170902b48a00b001cfb52ebffesm7939595plr.147.2023.11.29.01.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Nov 2023 01:04:39 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1r8GUn-001Req-1b;
	Wed, 29 Nov 2023 20:04:37 +1100
Date: Wed, 29 Nov 2023 20:04:37 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Zhang Tianci <zhangtianci.1997@bytedance.com>,
	Brian Foster <bfoster@redhat.com>, Ben Myers <bpm@sgi.com>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	xieyongji@bytedance.com, me@jcix.top,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 1/2] xfs: ensure logflagsp is initialized in
 xfs_bmap_del_extent_real
Message-ID: <ZWb+pR7AvTY8VLRR@dread.disaster.area>
References: <20231129075832.73600-1-zhangjiachen.jaycee@bytedance.com>
 <20231129075832.73600-2-zhangjiachen.jaycee@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231129075832.73600-2-zhangjiachen.jaycee@bytedance.com>

On Wed, Nov 29, 2023 at 03:58:31PM +0800, Jiachen Zhang wrote:
> In the case of returning -ENOSPC, ensure logflagsp is initialized by 0.
> Otherwise the caller __xfs_bunmapi will set uninitialized illegal
> tmp_logflags value into xfs log, which might cause unpredictable error
> in the log recovery procedure.
> 
> Also, remove the flags variable and set the *logflagsp directly, so that
> the code should be more robust in the long run.
> 
> Fixes: 1b24b633aafe ("xfs: move some more code into xfs_bmap_del_extent_real")
> Signed-off-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index be62acffad6c..9435bd6c950b 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5010,7 +5010,6 @@ xfs_bmap_del_extent_real(
>  	xfs_fileoff_t		del_endoff;	/* first offset past del */
>  	int			do_fx;	/* free extent at end of routine */
>  	int			error;	/* error return value */
> -	int			flags = 0;/* inode logging flags */
>  	struct xfs_bmbt_irec	got;	/* current extent entry */
>  	xfs_fileoff_t		got_endoff;	/* first offset past got */
>  	int			i;	/* temp state */
> @@ -5023,6 +5022,8 @@ xfs_bmap_del_extent_real(
>  	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
>  	struct xfs_bmbt_irec	old;
>  
> +	*logflagsp = 0;
> +
>  	mp = ip->i_mount;
>  	XFS_STATS_INC(mp, xs_del_exlist);
>  
> @@ -5048,10 +5049,12 @@ xfs_bmap_del_extent_real(
>  	if (tp->t_blk_res == 0 &&
>  	    ifp->if_format == XFS_DINODE_FMT_EXTENTS &&
>  	    ifp->if_nextents >= XFS_IFORK_MAXEXT(ip, whichfork) &&
> -	    del->br_startoff > got.br_startoff && del_endoff < got_endoff)
> -		return -ENOSPC;
> +	    del->br_startoff > got.br_startoff && del_endoff < got_endoff) {
> +		error = -ENOSPC;
> +		goto done;
> +	}

Now that you've added initialisation of logflagsp, the need for the
error stacking goto pattern goes away completely. Anywhere that has
a "goto done" can be converted to a direct 'return error' call and
the done label can be removed.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
