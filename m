Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127552C1B1
	for <linux-xfs@vger.kernel.org>; Tue, 20 Feb 2024 23:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708473407; cv=none; b=Pcvk6zHjbNhmYL8/NkFU8qaRq92KJOlFzeqkeDkQeo626MKfo+I0wvzfQe8eQa+l/GPkrE8xMFlKOsHgWXh3DupKuMdnlEC1Q8xNRUzTNPGgT55IatI4SiCDUdlCm3Di8LCzJ6gP9oUiGC517px2OafsxKx2MqKJAl6rrqcD5SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708473407; c=relaxed/simple;
	bh=bOYEmtb8TIAhSRBa2P7+j3npWbNp1Zz2O3N+Wbd9kAg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EWassz+BNmrOf9jPGCLxEAU7iao3Y15b2laJvpCLtdjR+ccjk7UOFERypw518hBpQ4/o2gTeqFt3o9kPkFw8FYetNHZymIL8AfucJmx3+OsZi/8e9s8ZLfWikf+67YEf9mLtYak23pydhyCsMXdUb7A09actroqLFkAQmFWzfh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Xtdf6P1G; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Xtdf6P1G"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1dbae7b8ff2so25007055ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 20 Feb 2024 15:56:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1708473405; x=1709078205; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zy/rgs0g/TbA1UDA0cVJ8uBAr2YACRPG8fR71g83JJo=;
        b=Xtdf6P1GRVOT4XAsqprnd5SBdK7I/KwyCLGppgxn92vGi3wpHCh4rOFX6FhADsU8An
         8f6GzYnnojy5gkgrhoBctFmbOv0i33LxaB9FMiU2kKemXmwHpwSWanbBq3h1/DEyPooo
         HlBkLxt7AvgSlWlz04F9BYNPBeZC1u73uslAhvv5dwpUfaMRy2yQDZas04nROm0iq1Se
         jFx/XgWfoCntaWITEl9ErV/HBCsRKWz0Wgzm8vtRdUjxqxZLzbYiN8MH3UvuY60JMeLU
         fG+IYpTVJ6OFMlqhMMiDp+x5rhepN+FtB5FPNjQUoj6OkJilqOc6WZDmPSSl9jx/wNkU
         744w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708473405; x=1709078205;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zy/rgs0g/TbA1UDA0cVJ8uBAr2YACRPG8fR71g83JJo=;
        b=Yls1CARDo7ReNEM8XEVtPjy0nX8JdM66eoJnJme6Zdh6SqJCrX0vc9baal8EUoBgNX
         m+ArffPh6e43qyaAcRDTq8MxD9gTF9rNNqA/adZLv5+WjUmRQleGTjLwlayKiB8SkbAd
         HMlOxRmZXtP/HEG2L9lNkh6sF3gubTRXj4qzNJdrd67UuhB2goLbO7ei6s2bYaY2e6CS
         WIf8IwNxOEpRHXL58cYcO4JkW7k+PdEZgkbYl00/T3yJtAj+8NokWJmziy9J4CXt97i0
         fDw9lzeNUqVBj/1BPbXoSwCcDPfGIOoc9JdHi0Jv9kzHhDtDdp1I6N6/xfjZF+FGlJbD
         0I4A==
X-Forwarded-Encrypted: i=1; AJvYcCUuShnB7VJ4jGjagoMt2hi+34HWxfxaBVbkI7WHFshJo0D2obk8eN4vtfG1OjNUz0xdvLzUzOmnDFaw6qst/vRlNFkt3I/+CFq9
X-Gm-Message-State: AOJu0Yx54e0vwezdmriiHvg+kTTHRvLYujKRVFsqOF1VVjI18u84xYsc
	U86MpiUP/ZEDhSbYrvL6pi6+BrRXkStUXJzPJ6B6+ORFWp0htnGj3V16EFqrYfc=
X-Google-Smtp-Source: AGHT+IFotZJCcbrZixEBtgri2TFS4JXpCO2EQWoDNfr5rKn5a4FAtP5Nc/i6qSkf1cC3p/mg2mPeRw==
X-Received: by 2002:a17:903:2342:b0:1db:d9ed:f91d with SMTP id c2-20020a170903234200b001dbd9edf91dmr10759987plh.33.1708473405306;
        Tue, 20 Feb 2024 15:56:45 -0800 (PST)
Received: from dread.disaster.area (pa49-181-247-196.pa.nsw.optusnet.com.au. [49.181.247.196])
        by smtp.gmail.com with ESMTPSA id 6-20020a170902e9c600b001d706e373a9sm6776810plk.292.2024.02.20.15.56.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Feb 2024 15:56:44 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rcZyc-009HRC-1h;
	Wed, 21 Feb 2024 10:56:42 +1100
Date: Wed, 21 Feb 2024 10:56:42 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, Hui Su <sh_def@163.com>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 10/22] xfs: use shmem_kernel_file_setup in xfile_create
Message-ID: <ZdU8Ov0vWsI84Brz@dread.disaster.area>
References: <20240219062730.3031391-1-hch@lst.de>
 <20240219062730.3031391-11-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240219062730.3031391-11-hch@lst.de>

On Mon, Feb 19, 2024 at 07:27:18AM +0100, Christoph Hellwig wrote:
> shmem_kernel_file_setup is equivalent to shmem_file_setup except that it
> already sets the S_PRIVATE flag.  Use it instead of open coding the
> logic.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/scrub/xfile.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
> index e649558351bc5a..99a2b48f5662e6 100644
> --- a/fs/xfs/scrub/xfile.c
> +++ b/fs/xfs/scrub/xfile.c
> @@ -68,7 +68,7 @@ xfile_create(
>  	if (!xf)
>  		return -ENOMEM;
>  
> -	xf->file = shmem_file_setup(description, isize, VM_NORESERVE);
> +	xf->file = shmem_kernel_file_setup(description, isize, VM_NORESERVE);
>  	if (IS_ERR(xf->file)) {
>  		error = PTR_ERR(xf->file);
>  		goto out_xfile;
> @@ -85,7 +85,7 @@ xfile_create(
>  			    FMODE_LSEEK;
>  	xf->file->f_flags |= O_RDWR | O_LARGEFILE | O_NOATIME;
>  	inode = file_inode(xf->file);
> -	inode->i_flags |= S_PRIVATE | S_NOCMTIME | S_NOATIME;
> +	inode->i_flags |= S_NOCMTIME | S_NOATIME;
>  	inode->i_mode &= ~0177;
>  	inode->i_uid = GLOBAL_ROOT_UID;
>  	inode->i_gid = GLOBAL_ROOT_GID;

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
