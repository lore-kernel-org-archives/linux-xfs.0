Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Km8JtMfx"
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5679410FA
	for <linux-xfs@vger.kernel.org>; Thu, 30 Nov 2023 13:10:42 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id 98e67ed59e1d1-28657040cdcso56815a91.3
        for <linux-xfs@vger.kernel.org>; Thu, 30 Nov 2023 13:10:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1701378642; x=1701983442; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/sRx+Jqf97+NiQ/oo0AK9REAGsSB677imx6VDbBDBPw=;
        b=Km8JtMfxfwYvu/zeg3TFokOr+llQNUz+H/GxvxsWAjDYt6PU9iTzC3WZJB+Eg6vEIL
         c+cuwZ8N2sWDTlLFDZ0NxE5/6n5bblotEgAAIJnZCVlZgy9UvrLgdJZutICxmSYcfRZE
         /sjNFxIc6pe4opf/Gco5ASXmorfGBnTXgYIplE3q4/CD7H1bUdxHQwOfYi0BXuD6tDWa
         KJccNMN8sC6fF+xJn0nb2Ti9a7GFt4ZgEncVQsRNMu/eNWaYVZ+0OunZcoB+wP3r5ky3
         PmgxZVn4Df9AAEFh5pa/Uhs7QemtKkWTcOzbad4Bi+kjdU9Ntq18I+TqrbL3WYAAIi0v
         xBYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701378642; x=1701983442;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/sRx+Jqf97+NiQ/oo0AK9REAGsSB677imx6VDbBDBPw=;
        b=JWenldo4uUz7a8rDtGUAMx5w9lxNTrDyXQGMIieqxE7uiTen3a58vRS8+hs43jsoGZ
         Y5YuEiMqIJb6Rz65/ThnmoXf1xEgS9bflj1/L7aJLuVBnUBUzxyVlrubh94Ngwf8pnWW
         ko8usZUK1JfQjtHbd0YxwdLULxLQPXl7U05kLpYYVqVterrXzP+RVFQIcGRRopbfKgFw
         N10+6gfesFVHYmhPp0GKjZG3SsU1urdjft+nX7fYuKBCB3qxNDfqSewk80iPZsLNThF8
         HVjZ82lqz3TkIsgiOZ7nQJS1zLVoH/agX4dkg1Q21moVUGp7GV7mq7BaFAnAeaTVOIpj
         zF4w==
X-Gm-Message-State: AOJu0Yy3ZtkiuxCV1N35N5gUNaYuYDNohOsWw7ExUZwEq8tp+3t0Qtwc
	km1qOy3T33d2g+1ku2d07TaPIg==
X-Google-Smtp-Source: AGHT+IGvDV12X2Cf2tSiZBcr9G1HEkwxlH7M0D5faUl77dI7BTBzZ5FwmwUTmMZr0vZ2RffJE7o8oQ==
X-Received: by 2002:a17:90b:4b86:b0:286:3074:c632 with SMTP id lr6-20020a17090b4b8600b002863074c632mr4500797pjb.22.1701378641794;
        Thu, 30 Nov 2023 13:10:41 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id kh14-20020a17090b34ce00b002859a1d9fb7sm1768396pjb.2.2023.11.30.13.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 13:10:41 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1r8oIw-0027MJ-1v;
	Fri, 01 Dec 2023 08:10:38 +1100
Date: Fri, 1 Dec 2023 08:10:38 +1100
From: Dave Chinner <david@fromorbit.com>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	linux-kernel@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>, dchinner@redhat.com
Subject: Re: [RFC 1/7] iomap: Don't fall back to buffered write if the write
 is atomic
Message-ID: <ZWj6Tt1zKUL4WPGr@dread.disaster.area>
References: <cover.1701339358.git.ojaswin@linux.ibm.com>
 <09ec4c88b565c85dee91eccf6e894a0c047d9e69.1701339358.git.ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09ec4c88b565c85dee91eccf6e894a0c047d9e69.1701339358.git.ojaswin@linux.ibm.com>

On Thu, Nov 30, 2023 at 07:23:09PM +0530, Ojaswin Mujoo wrote:
> Currently, iomap only supports atomic writes for direct IOs and there is
> no guarantees that a buffered IO will be atomic. Hence, if the user has
> explicitly requested the direct write to be atomic and there's a
> failure, return -EIO instead of falling back to buffered IO.
> 
> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> ---
>  fs/iomap/direct-io.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index 6ef25e26f1a1..3e7cd9bc8f4d 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -662,7 +662,13 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  			if (ret != -EAGAIN) {
>  				trace_iomap_dio_invalidate_fail(inode, iomi.pos,
>  								iomi.len);
> -				ret = -ENOTBLK;
> +				/*
> +				 * if this write was supposed to be atomic,
> +				 * return the err rather than trying to fall
> +				 * back to buffered IO.
> +				 */
> +				if (!atomic_write)
> +					ret = -ENOTBLK;

This belongs in the caller when it receives an -ENOTBLK from
iomap_dio_rw(). The iomap code is saying "this IO cannot be done
with direct IO" by returning this value, and then the caller can
make the determination of whether to run a buffered IO or not.

For example, a filesystem might still be able to perform an atomic
IO via a COW-based buffered IO slow path. Sure, ext4 can't do this,
but the above patch would prevent filesystems that could from being
able to implement such a fallback....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
