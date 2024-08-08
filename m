Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1D9156257
	for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2024 23:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723158210; cv=none; b=SyQV9b5T2NHH2UjXF6oe0LxqCG8c6dmGXdCgjLWbEoK+m2622TPsYMg7JkGv6t5M29eC2Y4ncYm9qe1kE0pLc5C9XqgIobiJcGrouMXW8GSRYuiOJAm7rYgP/JRYHmUrMqLWtpQi6QAtHJXKf114l8V3CAi+R2xBAY3LR29k8So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723158210; c=relaxed/simple;
	bh=53OMQDqcQmaUBrGmOxTmlma4fg3pPX4ccjav8seDQog=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dm7aCbps19Eq7qfoTKZTcOlDtDnXm7gCXrQLjScq9Yv7lS4/aOpKUJ64id66ycjRrlazqW5ha1mf2KwFQ1bD3lGviTKFFObmd/GupSsV2itw2ykX3aE/DIjvnZxlRFr2t7dyH3JruA2T1d0nj07c1+jVPz5D4sAX8xYtGpWGKhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=DiHoZUag; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="DiHoZUag"
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-260f863109cso875859fac.1
        for <linux-xfs@vger.kernel.org>; Thu, 08 Aug 2024 16:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1723158207; x=1723763007; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dOgcC+bAcPFruYEDE5iZfp7QevUMJEXGwkW+uZQBI7Q=;
        b=DiHoZUagDxWhrJvMf3ZwcBxRg5EoiUswAF3htt/h3r3ATsoUWl8Myr+tDDwoswf3S2
         kPVZtmZzMwKODzeJ80REBkGIzJa6G5XZEgjkOkF9NFZa8jTNCRKR69/6c53ruPyH29Ra
         mqRqkoOjp6zJp3B75KJTuB4xzzFehQzs0+6gGh43AgcSoe9VEVTfpLpTBiJ1rQHZg71o
         igg0poDjYp0P2UB1QPbkO5mBzkNr93wRF+HmgunEx/4aUDk/HuiFQqlhbpcacx3eY36S
         lSrz8LNSsUye2XU/VGnEcypGZ8Y7BJlfQDw1l8ocHJrh1s69hW62xFhgG2PC0eM1BD1a
         KNxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723158207; x=1723763007;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dOgcC+bAcPFruYEDE5iZfp7QevUMJEXGwkW+uZQBI7Q=;
        b=tiQrmn2+9fSmLiIhWGfjGeK5tUN9FzwutR2l+esMCi6Vg/FnR7F4CD2IphP8aA1V0S
         66fHgFONUgB4jKMDr4LkK6yGeg9N0WZ1/mwQKrMkxKth8Rvv0iZGVdFXUZvrIGPf8VyM
         kZoboJj1i0I8nETiAcK+gBT7spwxkz1wabi1/qlF1VTFiuVNgKGAKyMcYXXeRleecwC9
         3odnA/ptf8xiDY38xNhQFqQH5F/lEq+DqmwAMlMMygESNfRnzgb0pOZQ69FYmXZ4sC7C
         VtsmkjLK6dGy0f+LBfrbVVrx6V94RtqeaA/C2KdanD64OGC/JO15XIr5xE7itoVN3s1r
         2zqg==
X-Forwarded-Encrypted: i=1; AJvYcCWNSCqsmj1nlccUHi9nqowknuHvB6imfdq0PRj0lr5755l2BIiEN/y4PeMCJd8T6mcptT18Nue+fGejn5Zc4XhHN4spenCR8Rdj
X-Gm-Message-State: AOJu0YxRQ54qqYHyvpET/BJAa20XULDPbpcXhvNrmcb9D+kVEQG6QpzK
	DBLI/+9b3W1ZZrQCFnARAPRvlOmSX3hn6ptyguxG+3/h5zarAkRSxqGm7YuXuv0=
X-Google-Smtp-Source: AGHT+IG2QkjumnG5n+CFeoXYaL+HWlKGdIvACMgIu1Rk3RY7CfZzQDB7xJyiRIJZL2S9WnFurWTJhA==
X-Received: by 2002:a05:6871:14e:b0:260:fc8c:2d28 with SMTP id 586e51a60fabf-2692b69af89mr3993244fac.22.1723158207302;
        Thu, 08 Aug 2024 16:03:27 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7c1dd6197d2sm2151450a12.75.2024.08.08.16.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 16:03:26 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1scCAG-00AFFQ-1S;
	Fri, 09 Aug 2024 09:03:24 +1000
Date: Fri, 9 Aug 2024 09:03:24 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs: check XFS_EOFBLOCKS_RELEASED earlier in
 xfs_release_eofblocks
Message-ID: <ZrVOvDkhX7Mfoxy+@dread.disaster.area>
References: <20240808152826.3028421-1-hch@lst.de>
 <20240808152826.3028421-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240808152826.3028421-8-hch@lst.de>

On Thu, Aug 08, 2024 at 08:27:33AM -0700, Christoph Hellwig wrote:
> If the XFS_EOFBLOCKS_RELEASED flag is set, we are not going to free the
> eofblocks, so don't bother locking the inode or performing the checks in
> xfs_can_free_eofblocks.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_file.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 30b553ac8f56bb..f1593690ba88d2 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1234,9 +1234,9 @@ xfs_file_release(
>  	 */
>  	if (inode->i_nlink &&
>  	    (file->f_mode & FMODE_WRITE) &&
> +	    !xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED) &&
>  	    xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
> -		if (xfs_can_free_eofblocks(ip) &&
> -		    !xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED)) {
> +		if (xfs_can_free_eofblocks(ip)) {
>  			xfs_free_eofblocks(ip);
>  			xfs_iflags_set(ip, XFS_EOFBLOCKS_RELEASED);
>  		}

The test and set here is racy. A long time can pass between the test
and the setting of the flag, so maybe this should be optimised to
something like:

	if (inode->i_nlink &&
	    (file->f_mode & FMODE_WRITE) &&
	    (!(ip->i_flags & XFS_EOFBLOCKS_RELEASED)) &&
	    xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
		if (xfs_can_free_eofblocks(ip) &&
		    !xfs_iflags_test_and_set(ip, XFS_EOFBLOCKS_RELEASED))
			xfs_free_eofblocks(ip);
		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
	}

I do wonder, though - why do we need to hold the IOLOCK to call
xfs_can_free_eofblocks()? The only thing that really needs
serialisation is the xfS_bmapi_read() call, and that's done under
the ILOCK not the IOLOCK. Sure, xfs_free_eofblocks() needs the
IOLOCK because it's effectively a truncate w.r.t. extending writes,
but races with extending writes while checking if we need to do that
operation aren't really a big deal. Worst case is we take the
lock and free the EOF blocks beyond the writes we raced with.

What am I missing here?

i.e. it seems to me that the logic here could be:

	if (inode->i_nlink &&
	    (file->f_mode & FMODE_WRITE) &&
	    (!(ip->i_flags & XFS_EOFBLOCKS_RELEASED)) &&
	    xfs_can_free_eofblocks(ip) &&
	    xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL) &&
	    !xfs_iflags_test_and_set(ip, XFS_EOFBLOCKS_RELEASED)) {
		xfs_free_eofblocks(ip);
		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
	}

And so avoids attempting to take or taking locks in all the cases
where locks can be avoided.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
