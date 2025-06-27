Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666C22E8888
	for <linux-xfs@vger.kernel.org>; Fri, 27 Jun 2025 15:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751036947; cv=none; b=HAy2FoOcGWeA6oZWj1FmnbIWfUpThBKCef4Y0YOCEAl4QheeWbx8i36zKiioyvUnURdmq206xRT9pVRziNDJbqYZlSLT2UvZHuUtKZ0Erv4HyDW5zdQSMeIMYwj9sTz54MLyeMUJ5BWPkkEDtIeaApOn/2VqjJGnCZ0J/k4raec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751036947; c=relaxed/simple;
	bh=j2Kp4ByTynxMxZFAECpHzhDq6OgU/84lOPY3VD4IkHQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S3nPyeloAjDo2U21bjThsGi5b4mWkDoOs/D4UvclhCPx3RMSFNCV7pwZQico4ImOPPI5Ic5taiwnbC06dVKPvQern2/3de8g98STHpFWpa/9zpiUESRoYNIv14YpZTS/DuD4EmQfF6IDq30RIRasy9QZiblCTS/D0seuPQcFXJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IYXJ0jGW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IYXJ0jGW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751036944;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p08g1TteKuU6lqS39A8I2g1O1d0/ryJS74NUU/1Ttl0=;
	b=IYXJ0jGWobzor30sMMFpMkDJFjZFobuc/M3flucwDd/FkVopOuxyVfjQKb80PQ6jTanKre
	x52AnRwxyXWqe6SFgj3nA+DYzZREBJBgUZPVBBfSmJY/g7B9K4dm5Y+nEYQ9+cpLVpf8RD
	NAxKJ4xgjxBsOv9GdTEc8eVVj1bi49g=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-660-m3yqy2mQNpau2TytoNj6IQ-1; Fri,
 27 Jun 2025 11:08:58 -0400
X-MC-Unique: m3yqy2mQNpau2TytoNj6IQ-1
X-Mimecast-MFC-AGG-ID: m3yqy2mQNpau2TytoNj6IQ_1751036936
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 46612195F170;
	Fri, 27 Jun 2025 15:08:56 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.142])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 50DE7180035E;
	Fri, 27 Jun 2025 15:08:53 +0000 (UTC)
Date: Fri, 27 Jun 2025 11:12:31 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-block@vger.kernel.org, gfs2@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH 02/12] iomap: cleanup the pending writeback tracking in
 iomap_writepage_map_blocks
Message-ID: <aF6035WlvIRoPDSh@bfoster>
References: <20250627070328.975394-1-hch@lst.de>
 <20250627070328.975394-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250627070328.975394-3-hch@lst.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Fri, Jun 27, 2025 at 09:02:35AM +0200, Christoph Hellwig wrote:
> From: Joanne Koong <joannelkoong@gmail.com>
> 
> We don't care about the count of outstanding ioends, just if there is one.
> Replace the count variable passed to iomap_writepage_map_blocks with a
> boolean to make that more clear.
> 
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> [hch: rename the variable, update the commit message]
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/iomap/buffered-io.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index b5162e0323d0..ec2f70c6ec33 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -1758,7 +1758,7 @@ static int iomap_add_to_ioend(struct iomap_writeback_ctx *wpc,
>  
>  static int iomap_writepage_map_blocks(struct iomap_writeback_ctx *wpc,
>  		struct folio *folio, u64 pos, u64 end_pos, unsigned dirty_len,
> -		unsigned *count)
> +		bool *wb_pending)
>  {
>  	int error;
>  
> @@ -1786,7 +1786,7 @@ static int iomap_writepage_map_blocks(struct iomap_writeback_ctx *wpc,
>  			error = iomap_add_to_ioend(wpc, folio, pos, end_pos,
>  					map_len);
>  			if (!error)
> -				(*count)++;
> +				*wb_pending = true;
>  			break;
>  		}
>  		dirty_len -= map_len;
> @@ -1873,7 +1873,7 @@ static int iomap_writepage_map(struct iomap_writeback_ctx *wpc,
>  	u64 pos = folio_pos(folio);
>  	u64 end_pos = pos + folio_size(folio);
>  	u64 end_aligned = 0;
> -	unsigned count = 0;
> +	bool wb_pending = false;
>  	int error = 0;
>  	u32 rlen;
>  
> @@ -1917,13 +1917,13 @@ static int iomap_writepage_map(struct iomap_writeback_ctx *wpc,
>  	end_aligned = round_up(end_pos, i_blocksize(inode));
>  	while ((rlen = iomap_find_dirty_range(folio, &pos, end_aligned))) {
>  		error = iomap_writepage_map_blocks(wpc, folio, pos, end_pos,
> -				rlen, &count);
> +				rlen, &wb_pending);
>  		if (error)
>  			break;
>  		pos += rlen;
>  	}
>  
> -	if (count)
> +	if (wb_pending)
>  		wpc->nr_folios++;
>  
>  	/*
> @@ -1945,7 +1945,7 @@ static int iomap_writepage_map(struct iomap_writeback_ctx *wpc,
>  		if (atomic_dec_and_test(&ifs->write_bytes_pending))
>  			folio_end_writeback(folio);
>  	} else {
> -		if (!count)
> +		if (!wb_pending)
>  			folio_end_writeback(folio);
>  	}
>  	mapping_set_error(inode->i_mapping, error);
> -- 
> 2.47.2
> 
> 

