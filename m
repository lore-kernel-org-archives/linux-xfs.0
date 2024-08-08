Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A6D12E1EE
	for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2024 22:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723156598; cv=none; b=rABPFf2s9X2hStzTQgql6Yr5xB4ljZKDTp1JBAXXzBvKODSXVEVC3BWN6Ez3/196EcEU8tmGaNLneNXbfZDljPGgqfuU2eTn7cAt/6sybtqbx4STE9En5eHJgVeFgHy+n5qve2bM3FSJAoqLVq9Hb4MmM4ggK3LquPcNw9CLcE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723156598; c=relaxed/simple;
	bh=5GPVo4MIVLMt2ufu13wRaxRGQziWADfNbZAsCPjwUFo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j1V9caPyJgMiDTSTerOuwwArpeTnCg6y5KN/leCa/Jrlb+7iHYykv1MhEl2GZ1ZZqHXRzJHu17wCux0TKgb+wMGkwTdtyN3kO+oUv7KiH8UkIUiSqLckUbBnaGRzYRaQ5QDRT3tmSXCX5ChLMlPpeNy/qmzcATTTZtQUrPKmi60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=jRvfzF9T; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="jRvfzF9T"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2d1c1fb5cafso962872a91.2
        for <linux-xfs@vger.kernel.org>; Thu, 08 Aug 2024 15:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1723156596; x=1723761396; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OY4d1yvw42w9g7hzdG6ROmo6dvglITY8dmVf01bVFKY=;
        b=jRvfzF9TOLz4eRHuEWoB4YgRYA4Qd9aV1Com4te1j0W67Zn6WVeUR/75laG6fmTQyD
         wzcxS4P4fHv5ake9f0iZzsN468zUEQR8BbCyyVAGJOi96ozuZ3rr9u+Tqb0kxQWN5GOW
         zhzXJTG6mS+gechSiC6iv+p5uIHVVjLVqm8x6XaRiMmqjyAOgaj6YQ/+Tx327eVOGjtH
         s/bQalHPROkuqUJfuJ/E4d7/Vn5VP3PmlS0LSZD4abzNF5YHet7Hsm6xY/mzLLEMrzOL
         WXt1vGm+G3MV0LgUYwQctsCSJugeuBGHR55Edffjmnlt/X6sqhV0zegQisnkAAqDsRXu
         MQtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723156596; x=1723761396;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OY4d1yvw42w9g7hzdG6ROmo6dvglITY8dmVf01bVFKY=;
        b=DieMW6ZRxGgoa6jt/nf26lMsjRTkgP8QoPIe+15FWaIVmiL4rISy9b5BNQmsdsRUZ2
         7OucuA7jnAD5NhUGFQFHUaI7gT0KynW7tnhVjFlu1a1ySx6uE1+X7AyCLIdz0I7ZYkmZ
         gGnCO7oRuz3XVigqN1/8W6PkwKaLPwx3Fd8CtVyO+0SU/Dld5bQKkx1D+QJhGwO1Y/ht
         i4fDaGghVx9J5PKYeNvUEWlgXUqh/XlEwC68fr5UJbFk9x/PpKULmFVaLPBcyslPIeT0
         DsMPpiMLJ40gedC6vAeqXorKhMicWmVQrIw9av8ZqWjQplv2j6TcciQYcScgThbBR7fa
         570A==
X-Forwarded-Encrypted: i=1; AJvYcCVwVBegMXW5KB4U6Dalfi3AsZLFU0IB3L8INXf14kfffLKHPaQv21C0U6THG5sK1PIdlJRqctyLDtK7G5kxM3q2FShRcSiFXGfv
X-Gm-Message-State: AOJu0YyA/FxO8RhV0ID7pQ20WLhiBpcp1G2BeDp8gbrSnth6Tv1lr/92
	QaLMhfkO/g8fP+Sy6aAbZHc64BoiVmbf1+hV0fyFhgewetDMXTbBFxzm11i2Wug=
X-Google-Smtp-Source: AGHT+IEsP+AETEnEWNjipJhzrgP7lIgtC56S6TUYlk+od/gI+G+0iCykP052T6PqpmJ///Wl+KH54Q==
X-Received: by 2002:a17:90a:f682:b0:2c3:2557:3de8 with SMTP id 98e67ed59e1d1-2d1c34585d8mr3858160a91.33.1723156596112;
        Thu, 08 Aug 2024 15:36:36 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d1b3b5a39bsm3975499a91.50.2024.08.08.15.36.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 15:36:35 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1scBkH-00ADrd-15;
	Fri, 09 Aug 2024 08:36:33 +1000
Date: Fri, 9 Aug 2024 08:36:33 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] xfs: only free posteof blocks on first close
Message-ID: <ZrVIcay+jnfM7mM5@dread.disaster.area>
References: <20240808152826.3028421-1-hch@lst.de>
 <20240808152826.3028421-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240808152826.3028421-7-hch@lst.de>

On Thu, Aug 08, 2024 at 08:27:32AM -0700, Christoph Hellwig wrote:
> From: "Darrick J. Wong" <djwong@kernel.org>
> 
> Certain workloads fragment files on XFS very badly, such as a software
> package that creates a number of threads, each of which repeatedly run
> the sequence: open a file, perform a synchronous write, and close the
> file, which defeats the speculative preallocation mechanism.  We work
> around this problem by only deleting posteof blocks the /first/ time a
> file is closed to preserve the behavior that unpacking a tarball lays
> out files one after the other with no gaps.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> [hch: rebased, updated comment, renamed the flag]
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_file.c  | 32 +++++++++++---------------------
>  fs/xfs/xfs_inode.h |  4 ++--
>  2 files changed, 13 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 60424e64230743..30b553ac8f56bb 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1204,15 +1204,21 @@ xfs_file_release(
>  	 * exposed to that problem.
>  	 */
>  	if (xfs_iflags_test_and_clear(ip, XFS_ITRUNCATED)) {
> -		xfs_iflags_clear(ip, XFS_IDIRTY_RELEASE);
> +		xfs_iflags_clear(ip, XFS_EOFBLOCKS_RELEASED);
>  		if (ip->i_delayed_blks > 0)
>  			filemap_flush(inode->i_mapping);
>  	}

This should probably be open coded to minimise lock cycles and lock
contention on the flags lock when concurrent open/sync write/close 
cycles are run on the file (as recently reported by Mateusz). i.e:

	if (ip->i_flags & XFS_ITRUNCATED) {
		spin_lock(&ip->i_flags_lock);
		if (ip->i_flags & XFS_ITRUNCATED)
			ip->i_flags &= ~(XFS_ITRUNCATED | XFS_EOFBLOCKS_RELEASED);
		spin_unlock(&ip->i_flags_lock);
		if (ip->i_delayed_blks > 0)
			filemap_flush(inode->i_mapping);
	}

....
> @@ -1230,25 +1236,9 @@ xfs_file_release(
>  	    (file->f_mode & FMODE_WRITE) &&
>  	    xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
>  		if (xfs_can_free_eofblocks(ip) &&
> -		    !xfs_iflags_test(ip, XFS_IDIRTY_RELEASE)) {
> -			/*
> -			 * Check if the inode is being opened, written and
> -			 * closed frequently and we have delayed allocation
> -			 * blocks outstanding (e.g. streaming writes from the
> -			 * NFS server), truncating the blocks past EOF will
> -			 * cause fragmentation to occur.
> -			 *
> -			 * In this case don't do the truncation, but we have to
> -			 * be careful how we detect this case. Blocks beyond EOF
> -			 * show up as i_delayed_blks even when the inode is
> -			 * clean, so we need to truncate them away first before
> -			 * checking for a dirty release. Hence on the first
> -			 * dirty close we will still remove the speculative
> -			 * allocation, but after that we will leave it in place.
> -			 */
> +		    !xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED)) {
>  			xfs_free_eofblocks(ip);
> -			if (ip->i_delayed_blks)
> -				xfs_iflags_set(ip, XFS_IDIRTY_RELEASE);
> +			xfs_iflags_set(ip, XFS_EOFBLOCKS_RELEASED);

		     !xfs_iflags_test_and_set(ip, XFS_EOFBLOCKS_RELEASED)
			xfs_free_eofblocks(ip);

This also avoids an extra lock cycle to set the flag....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
