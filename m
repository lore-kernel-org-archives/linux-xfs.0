Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793960785;
	b=32NI4fEz5vsSJ9T06Mvg0kR5zmyasiKPW63cFGoNnkxRxaxQoPPFfJOiJ0SIUiywkW1L
	 KQtSOWwvQD7RI/ATj8HZsSw/HgkFWBKzE44roeQrUihbsy00sZucGt0STlHZPY2IoA1zk
	 x1fMaaJCFrh9YpIgw84d0vkagO/B7jqySvTtWngWBEpxZ1gMSFkqKBInBRXDhZLSIjuWd
	 4dArYG/7+5sC1mFWKA/18Qog5JSxBm2VA2W8cg9B2V8LnQgu2zGJ1nGVt2cnMBnzR9r3H
	 +Xtm7YwBe71pU3JDeXHIxB1FP9au7V8SqVOLNKNJJodqWO5C8LgvndebrypAsEeUgng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793960785;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=RqQSYGOZZG/aIHhMQ8HE+3EsiHhz5Y9+6eyhSvGw+c0=;
	b=maLzDZpyTPqz7b+7hp9SL1vE2+9g09LCaE4PyPOtbhklxojNcyncwJi7KSlBafUAb2jt
	 mG3+evQ69ayM5pEtmi2xtGqN/feVza0vWvDqslaiWhl+SBTzS1/PuPJLQaUwNgnn0g/DB
	 CX/7uHRHlJNnA15xvO9sKRE7ec06FVjA/ZSo4ONl3XLW0a724ZofjdAOiOQlgPMBGbO/Q
	 kLSqTUpR2s9MM+dFjF3fW3tx8QektlufH2CDDIFHvEYvfbrndiHwH7sLag0fa4MTpjqBx
	 YtYo2Df8TJesUi3vkqVBWhGYtKT2dwWMJoFkKqeBhYZBHqYQl8/yTZrf/oSC9sQfvCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C78606A329;
	Fri,  6 Nov 2026 10:26:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4C78606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 48CA668BEB; Fri,  6 Nov 2026 11:26:19 +0100 (CET)
Date: Fri, 6 Nov 2026 11:26:18 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: ebiggers@kernel.org, hch@lst.de, fsverity@lists.linux.dev,
	dsterba@suse.com, linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	brauner@kernel.org, viro@zeniv.linux.org.uk, jaegeuk@kernel.org,
	chao@kernel.org, tytso@mit.edu, Boris Burkov <boris@bur.io>
Subject: Re: [PATCH v2 1/5] fsverity: strip FS_VERITY_FL from
 FS_IOC_SETFLAGS
Message-ID: <20261106102618.GA5319@lst.de>
References: <20261105115532.613467-1-aalbersh@kernel.org> <20261105115532.613467-2-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105115532.613467-2-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 05, 2026 at 12:55:26PM +0100, Andrey Albershteyn wrote:
> The common use of FS_IOC_GETFLAGS/SETFLAGS is get-modify-set loop.
> Filesystems could return verity status with GETFLAGS, attempting to then
> pass FS_VERITY_FL to SETFLAGS is not allowed.
> 
> The ext4 and f2fs already treat FS_VERITY_FL in the set path as no-op,
> however, BTRFS returns -EOPNOTSUPP. So, the modification of other flags
> doesn't work on BTRFS for fsverity inodes.
> 
> Fix it for BTRFS and anyone else, the ext4 and f2fs masking becomes
> no-op. The file_get/setattr() path is fine here as this flag is cleared
> right before fileattr_set_prepare(). The future fsverity support in XFS
> would also need it.
> 
> Cc: Boris Burkov <boris@bur.io>
> Cc: David Sterba <dsterba@suse.com>
> Fixes: 146054090b08 ("btrfs: initial fsverity support")
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  fs/file_attr.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/fs/file_attr.c b/fs/file_attr.c
> index 833e03810b24..b43977d5f8e0 100644
> --- a/fs/file_attr.c
> +++ b/fs/file_attr.c
> @@ -199,6 +199,16 @@ static int fileattr_set_prepare(struct inode *inode,
>  	if (err)
>  		return err;
>  
> +	/*
> +	 * verity is settable only via FS_IOC_ENABLE_VERITY; never through
> +	 * fileattr

Maybe spell out FS_VERITY_FL above?  Starting the sentence with a lower
case letter looks odd, and spelling out the flag name doens't hurt.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

