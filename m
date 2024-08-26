Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F93635
	for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2024 00:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724633266; cv=none; b=K8R1SrsGhF2ANScXklmHga1bj/Ue0KRzWLShF8sRHucLyWa3SuwxO0391kjuqjvidIB0wqVCCtJP/07NBEIlJQlAOyNsL4+T6jfeXgmQK9Oh+G9X0JHZ2Nb7MB2nGnGJxN7CgTIiZOpqhWH+FlM8WWYC2Owh43iNoD8itCpS/Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724633266; c=relaxed/simple;
	bh=jRb5UNHeuQ326GfPaQ7eMoMRD4LW5ZBmzlNWHwvI4Pc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i8vr0qXTEA/RqjZ2URMPoND40DzgfXAqdPubxcQVP03xnnp/Hf5XyQBHRNP609Z+NRxFyhJDEmK+DocajX+7BhE9Hm3GvalMUkBOYurmXyVC7hX8HDaQJ2zMMFOX4za8oXqwIc7Hy4h4r2IjtDJ/ttSmNitjH2e3u+zm/ldZNB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=ZJxTFFu8; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="ZJxTFFu8"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-201ed196debso30809035ad.1
        for <linux-xfs@vger.kernel.org>; Sun, 25 Aug 2024 17:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724633265; x=1725238065; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0L/MA7ItD2gfwCYYc8gOUSLmd0Bl11b7rjn1Nb3xuCw=;
        b=ZJxTFFu8AXdjSx1uunnIsx1TsA1SwBOTvhYfcbP4VFCVN4xXqxB7i0lDYlO28tRqxP
         nf/DfncioJ++sv4QN4JMuLBxhsQMMDuyVt95LozLoBK7bTPZxWEjvXxHnIT54k5SCWqw
         GLL+WL6MAspRzQEgULIjq38kOMTkfCeIsNgnfBDl5DeBrrlcAZua3NZabJe1qrGsxty6
         QjHmoxUcDrTqUtizoeSzAwOejP+B2Mz/+/VH9b8ReGqvFX25YIyu4314oo7gN329K4UM
         hxw5Y3UInr1jsAeZVAfkOXrh8g1gFwAvUwrVy430294SzuhC8C1V9VPDVY4RFfIZqinA
         +DXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724633265; x=1725238065;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0L/MA7ItD2gfwCYYc8gOUSLmd0Bl11b7rjn1Nb3xuCw=;
        b=uVPv3GyN7B5PUyGHWwPPcCHAFNPI0wNB6UWqd55brN4MOfsac9tT4KwCLLtLJT4JPz
         D/bf2dU/5JxLvMpbUUvzwfqpODaE1HeSRErLgc29iBtrBFduhOCZktPsoAiHv5MAZrP3
         zC8fYn5zLvvXT7zIIllgzMGdIR5uVNLVzh1pLVdHg8XKsKYTBbLyyzCXyliYeVrBXE0G
         OP7epnyUjMYE2fXEfXAQW5l9TS2as3VrFEqE4fsFDQ8DSgNjzLf1TcndRTv9yLXBndx/
         m9AgyzBz6XJmxMfp1l+A8rpLuNvDz7teEa/0VPLECwLudesPUAqB54NblAGdJY1h5OnE
         ba3A==
X-Forwarded-Encrypted: i=1; AJvYcCWwmTQpi0p2x9KwD8bcGFl2DlKoC073erdm2kDWdK7riwAM+UvTJJgLy1ukcyqeva+Vb+qGMIKLbEI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCALCOzOfr4hYCJw4otr+W/2qxdTbQVxVKtspGpFw5ZHyho2Bl
	4lzh9GwHcHkMRtWeHtBxImEJVyubFKn2vBcCzEJun6dssLmbAZi8EOIVg63C1loAqt66kJf3drM
	y
X-Google-Smtp-Source: AGHT+IE0O4omLIGP6IaR/FDMKAnhqxqxoODlILLWn235NxiAvLMKlH9ZHaFphvqiCeLew8TG/ZQUQw==
X-Received: by 2002:a17:903:5c5:b0:202:1529:3b01 with SMTP id d9443c01a7336-2039e4e87dcmr67530475ad.39.1724633264656;
        Sun, 25 Aug 2024 17:47:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20385564dd9sm58398485ad.51.2024.08.25.17.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2024 17:47:44 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1siNtV-00CmWp-1C;
	Mon, 26 Aug 2024 10:47:41 +1000
Date: Mon, 26 Aug 2024 10:47:41 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/26] xfs: don't count metadata directory files to quota
Message-ID: <ZsvQrb4o0vUAL/lP@dread.disaster.area>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
 <172437085364.57482.4719664018853105804.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437085364.57482.4719664018853105804.stgit@frogsfrogsfrogs>

On Thu, Aug 22, 2024 at 05:05:01PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Files in the metadata directory tree are internal to the filesystem.
> Don't count the inodes or the blocks they use in the root dquot because
> users do not need to know about their resource usage.  This will also
> quiet down complaints about dquot usage not matching du output.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_dquot.c       |    1 +
>  fs/xfs/xfs_qm.c          |   11 +++++++++++
>  fs/xfs/xfs_quota.h       |    5 +++++
>  fs/xfs/xfs_trans_dquot.c |    6 ++++++
>  4 files changed, 23 insertions(+)
> 
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index c1b211c260a9d..3bf47458c517a 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -983,6 +983,7 @@ xfs_qm_dqget_inode(
>  
>  	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
>  	ASSERT(xfs_inode_dquot(ip, type) == NULL);
> +	ASSERT(!xfs_is_metadir_inode(ip));
>  
>  	id = xfs_qm_id_for_quotatype(ip, type);
>  
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index d0674d84af3ec..ec983cca9adae 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -304,6 +304,8 @@ xfs_qm_need_dqattach(
>  		return false;
>  	if (xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
>  		return false;
> +	if (xfs_is_metadir_inode(ip))
> +		return false;
>  	return true;
>  }
>  
> @@ -326,6 +328,7 @@ xfs_qm_dqattach_locked(
>  		return 0;
>  
>  	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
> +	ASSERT(!xfs_is_metadir_inode(ip));
>  
>  	if (XFS_IS_UQUOTA_ON(mp) && !ip->i_udquot) {
>  		error = xfs_qm_dqattach_one(ip, XFS_DQTYPE_USER,
> @@ -1204,6 +1207,10 @@ xfs_qm_dqusage_adjust(
>  		}
>  	}
>  
> +	/* Metadata directory files are not accounted to user-visible quotas. */
> +	if (xfs_is_metadir_inode(ip))
> +		goto error0;
> +

Hmmmm. I'm starting to think that xfs_iget() should not return
metadata inodes unless a new XFS_IGET_METAINODE flag is set.

That would replace all these post xfs_iget() checks with a single
check in xfs_iget(), and then xfs_trans_metafile_iget() is the only
place that sets this specific flag.

That means stuff like VFS lookups, bulkstat, quotacheck, and
filehandle lookups will never return metadata inodes and we don't
need to add special checks all over for them...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
