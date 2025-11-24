Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1503E25A2BB;
	Mon, 24 Nov 2025 16:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764001931; cv=none; b=JqSdR9xHvkUZQduvpNNbBTePW1jCh19UriF8Zq5eO3Abb3m9sT3BYnkJXX56BfZuJhs6I8UQSqOzeTup3RHteeWzsOuPovdpo7Nj8JIV2rxSnmLWj3ZUEJCnt/BIRWGTBna3KJADeOgna3u7EWp7CzpjNDtZyY0mJh+OwYp0o74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764001931; c=relaxed/simple;
	bh=4Ihr2xY2wgSOftRj5NcKrvlZykOIIbVqk1yArKoHlEo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VzBNWEUNL8BkG4DHMu2zY4Ype3CgThV2lvv2jupCW/aKj0t2B2IHSrxGfZREA+JjOL7iqJb6eFELenm3lYbh7RVs/ZWIiRbiD3wwcsClk9pBi9I++kLA0504l+k5zngXvnCg6DrfJx624oN9jpaWiskvl1vupbX4mWX5TM5oHXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mceUupg+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mceUupg+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DFC0C4CEF1;
	Mon, 24 Nov 2025 16:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764001930;
	bh=4Ihr2xY2wgSOftRj5NcKrvlZykOIIbVqk1yArKoHlEo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mceUupg+EFw0+3+7ITYucdyTfL8D2Ae+u7Riol/IOeVRUEp1ZXxh5eF6fvsneubs0
	 jQUcLBG9SNmxqRrZecEldYCDnASSYOy4Fc6a6pQ9RiEs+MM9GnCMweoPOea8F/uub/
	 sX5vsOaf1VWJdyY9XbxOjzAiho/t4HcxR9b4Om63JVew2Az/pKrmjRw8nTTLv/UPiM
	 MTe3aAsNxXMTpWK5Ddqq4Ra3YM66AZMpEh/5eBlpVUTC45fiKO9eU+PPBN4hgZv+MA
	 GrpTFPVm44LaYoP7Ha76pDYdylPnci0M6gLL9HYYBADvusC8rFgwuwjvlLhAUJR0IV
	 uHc1hRHdc5yDg==
Date: Mon, 24 Nov 2025 08:32:09 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: brauner@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	syzbot+a2b9a4ed0d61b1efb3f5@syzkaller.appspotmail.com
Subject: Re: [PATCH] iomap: allocate s_dio_done_wq for async reads as well
Message-ID: <20251124163209.GA7926@frogsfrogsfrogs>
References: <20251124140013.902853-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124140013.902853-1-hch@lst.de>

On Mon, Nov 24, 2025 at 03:00:13PM +0100, Christoph Hellwig wrote:
> Since commit 222f2c7c6d14 ("iomap: always run error completions in user
> context"), read error completions are deferred to s_dio_done_wq.  This
> means the workqueue also needs to be allocated for async reads.
> 
> Fixes: 222f2c7c6d14 ("iomap: always run error completions in user context")
> Reported-by: syzbot+a2b9a4ed0d61b1efb3f5@syzkaller.appspotmail.com
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Tested-by: syzbot+a2b9a4ed0d61b1efb3f5@syzkaller.appspotmail.com

Heh, ooops. :/

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/iomap/direct-io.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index d4e2e328d893..8e273408453a 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -738,12 +738,12 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  			}
>  			goto out_free_dio;
>  		}
> +	}
>  
> -		if (!wait_for_completion && !inode->i_sb->s_dio_done_wq) {
> -			ret = sb_init_dio_done_wq(inode->i_sb);
> -			if (ret < 0)
> -				goto out_free_dio;
> -		}
> +	if (!wait_for_completion && !inode->i_sb->s_dio_done_wq) {
> +		ret = sb_init_dio_done_wq(inode->i_sb);
> +		if (ret < 0)
> +			goto out_free_dio;
>  	}
>  
>  	inode_dio_begin(inode);
> -- 
> 2.47.3
> 
> 
