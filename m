Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C26361DD2;
	Tue,  2 Jun 2026 16:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780417549; cv=none; b=Okiz5nVBR8Jxi/ShnMKppPs2EwWQdiChFLkwcWQvCVeL0FJW6PBCMX5apuRsYN8XCd7yrtSwi88ZwLXXJTJQpTMIahtC1iVivhFEvcr8Y84whLGVGntOWB/UQxSfTFodsrO0mfiju+lPF/1wi7dtyTYska1YHfaCI62R5K7TYhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780417549; c=relaxed/simple;
	bh=r+WdoKCvunqOYeDwnUd0iG3+8WJfyoo/VBVmmShWDKY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HtZoNL0OlXseoChmZ3g6GvUOPQpffV9JQFrfZ1qIENHEVer15wTSN7EJhpadzYrqNcAX/HG9xhVVaPv4TcRNS8A+kawdMgg64IawNxBYnbb1Bu8hd0rBvJUdDVYhYCVkbVNd2kzWvsu0uiBJeIgR+hLA4NsNqv1LjqTzcKDR3I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=QHT/h0Kj; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="QHT/h0Kj"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780417533; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=EpbqZJcq9Oh/PxoRgOKb2trtx+eeWnzATpjIZdwAlPw=;
	b=QHT/h0KjMDQS0rMG27/RWqAxkygw6EmL7udbD7FEH2jh3c9tBklITTQYWhI90yFZxrVwFpI8iW8BPR7TuU3u+2ucLe3Jf0EWI7QPjloGi0vZkOdDXv5hMypKBkzfpdto+IG9qF6rzhM0v62IYfrRt4CjQ1RujRZmXy6z6HTOnrY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R931e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X44xNwS_1780417532;
Received: from 30.120.66.214(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X44xNwS_1780417532 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 03 Jun 2026 00:25:33 +0800
Message-ID: <7c5bfcf0-36a3-4cc6-bf31-6af4fc901c37@linux.alibaba.com>
Date: Wed, 3 Jun 2026 00:25:31 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 7/8] erofs: open via dedicated fs bdev helpers
To: Christian Brauner <brauner@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
 linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org,
 Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>
References: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org>
 <20260602-work-super-bdev_holder_global-v1-7-bb0fd82f3861@kernel.org>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260602-work-super-bdev_holder_global-v1-7-bb0fd82f3861@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/6/2 18:10, Christian Brauner wrote:
> Route opens through fs_bdev_file_open_by_path() so each external device
> is registered against the correct superblock, and convert the matching
> releases.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>   fs/erofs/data.c     |  6 +++++
>   fs/erofs/internal.h | 10 ++++++++
>   fs/erofs/super.c    | 66 +++++++++++++++++++++++++++++++++++++++++++----------
>   fs/erofs/zdata.c    | 10 +++++---
>   4 files changed, 77 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/erofs/data.c b/fs/erofs/data.c
> index 44da21c9d777..5220585293df 100644
> --- a/fs/erofs/data.c
> +++ b/fs/erofs/data.c
> @@ -69,6 +69,9 @@ int erofs_init_metabuf(struct erofs_buf *buf, struct super_block *sb,
>   {
>   	struct erofs_sb_info *sbi = EROFS_SB(sb);
>   
> +	if (erofs_is_shutdown(sb))
> +		return -EIO;
> +
>   	buf->file = NULL;
>   	if (in_metabox) {
>   		if (unlikely(!sbi->metabox_inode))
> @@ -236,6 +239,9 @@ int erofs_map_dev(struct super_block *sb, struct erofs_map_dev *map)
>   		}
>   		up_read(&devs->rwsem);
>   	}
> +	if (erofs_is_shutdown(sb) ||
> +	    (map->m_dif && READ_ONCE(map->m_dif->dead)))
> +		return -EIO;

Take a quick look at the code, maybe we can just add
the SHUTDOWN status only since I don't think remove an
individual blob device is useful for the typical image
use cases, so there is no need adding `dead` for each
individual extra device.

and just bail out if erofs_is_shutdown() at the very
beginning of erofs_map_dev()?

>   	return 0;
>   }
>   

...

> diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
> index 43bb5a6a9924..89ae91935364 100644
> --- a/fs/erofs/zdata.c
> +++ b/fs/erofs/zdata.c
> @@ -1697,11 +1697,15 @@ static void z_erofs_submit_queue(struct z_erofs_frontend *f,
>   			continue;
>   		}
>   
> -		/* no device id here, thus it will always succeed */
>   		mdev = (struct erofs_map_dev) {
>   			.m_pa = round_down(pcl->pos, sb->s_blocksize),
>   		};
> -		(void)erofs_map_dev(sb, &mdev);
> +		if (erofs_map_dev(sb, &mdev)) {
> +			/* the backing device is gone; fail the batch */
> +			q[JQ_SUBMIT]->eio = true;
> +			qtail[JQ_SUBMIT] = &pcl->next;
> +			continue;
> +		}

It needs some injection tests anyway.

May I ask if it's an urgent 7.2 work? If not, I could
make a preparation patch for the upcoming 7.2 cycle
to handle erofs_map_dev() failure here so you don't
need to bother with this in this patchset.

I will seek more time to resolve the recent todos
yet always intercepted by other unrelated stuffs.

Thanks,
Gao Xaing
