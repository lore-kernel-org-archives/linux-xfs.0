Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58D71EA7DB
	for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2026 10:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776855600; cv=none; b=eZbiidW71SKfRfpqnZLmWaFPbkMIkEqgtyCd3gcDTDx+GAOapUG8U0NVthbr8HC4WJo6985hiJ915WXLrzPewG/vPbSpyynQfZ6pCuOK+jKy9EBw/z5YAve1f9+DPI134Fo47pT831eq72R8VwSXywIWFAO/ewU8A95SdpZ+1oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776855600; c=relaxed/simple;
	bh=n48wvyxb3Y6EIjjJloYuiiV91f0Unk3er5xo3n6m/Lw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VOVlcdD5v3ziWwK2Gf7LKwVBW/l+B5WJ2IZQj89Vcw/lrNhSOHlCF5+/4/ITq07sUh2s00cgEW7VYG/EbhORI0Y2qRWlFwCrqEnssynGwJ7gqiTFqQLAWmWgYeX5/UOvdfzQJ97bfN3Gt8iYlB18V6DzrqHUDgDk6VGQOq6jy+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aLdIF0dU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aLdIF0dU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776855597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=izjl8drGARtnJbDgV470Smw6Us4DYi0R0XZK5bmOh0M=;
	b=aLdIF0dU1jYYNI0aSt/22W69gVoq+Dplvx0NPn5jih0h15C4WWzZfeGu1wyUcUwJ9qTktP
	TIMPLdWcpCval/752Y3uqc4Jmj3c5H75lX8H5Q8GDcwjUpwzd4GP6a3d3pHYmfF+SoPb7j
	2VZzTgJd39909TNc37yoZiotuOz1QlU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-501-9KUf4_wFM6uiEpVsiOBTvw-1; Wed,
 22 Apr 2026 06:59:54 -0400
X-MC-Unique: 9KUf4_wFM6uiEpVsiOBTvw-1
X-Mimecast-MFC-AGG-ID: 9KUf4_wFM6uiEpVsiOBTvw_1776855593
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ED44B19560B3;
	Wed, 22 Apr 2026 10:59:52 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.73])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 22825180047F;
	Wed, 22 Apr 2026 10:59:51 +0000 (UTC)
Date: Wed, 22 Apr 2026 06:59:48 -0400
From: Brian Foster <bfoster@redhat.com>
To: Fengnan Chang <fengnanchang@gmail.com>
Cc: brauner@kernel.org, djwong@kernel.org, hch@infradead.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, lidiangang@bytedance.com,
	Fengnan Chang <changfengnan@bytedance.com>
Subject: Re: [PATCH v2] iomap: avoid memset iomap when iter is done
Message-ID: <aeiqJDF1S3nlme72@bfoster>
References: <20260420061630.62077-1-changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420061630.62077-1-changfengnan@bytedance.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Mon, Apr 20, 2026 at 02:16:30PM +0800, Fengnan Chang wrote:
> When iomap_iter() finishes its iteration (returns <= 0), it is no longer
> necessary to memset the entire iomap and srcmap structures.
> 
> In high-IOPS scenarios (like 4k randread NVMe polling with io_uring),
> where the majority of I/Os complete in a single extent map, this wasted
> memory write bandwidth, as the caller will just discard the iterator.
> Use this command to test:
> taskset -c 30 ./t/io_uring -p1 -d512 -b4096 -s32 -c32 -F1 -B1 -R1 -X1
> -n1 -P1 /mnt/testfile
> IOPS improve about 5% on ext4 and XFS.
> 
> However, we MUST still call iomap_iter_reset_iomap() to release the
> folio_batch if IOMAP_F_FOLIO_BATCH is set, otherwise we leak page
> references. Therefore, split the cleanup logic: always release the
> folio_batch, but skip the memset() when ret <= 0.
> 
> Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/iomap/iter.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
> index c04796f6e57f..e4a29829591a 100644
> --- a/fs/iomap/iter.c
> +++ b/fs/iomap/iter.c
> @@ -6,17 +6,13 @@
>  #include <linux/iomap.h>
>  #include "trace.h"
>  
> -static inline void iomap_iter_reset_iomap(struct iomap_iter *iter)
> +static inline void iomap_iter_clean_fbatch(struct iomap_iter *iter)
>  {
>  	if (iter->iomap.flags & IOMAP_F_FOLIO_BATCH) {
>  		folio_batch_release(iter->fbatch);
>  		folio_batch_reinit(iter->fbatch);
>  		iter->iomap.flags &= ~IOMAP_F_FOLIO_BATCH;
>  	}
> -
> -	iter->status = 0;
> -	memset(&iter->iomap, 0, sizeof(iter->iomap));
> -	memset(&iter->srcmap, 0, sizeof(iter->srcmap));
>  }
>  
>  /* Advance the current iterator position and decrement the remaining length */
> @@ -102,10 +98,14 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
>  		ret = 0;
>  	else
>  		ret = 1;
> -	iomap_iter_reset_iomap(iter);
> +	iomap_iter_clean_fbatch(iter);
> +	iter->status = 0;
>  	if (ret <= 0)
>  		return ret;
>  
> +	memset(&iter->iomap, 0, sizeof(iter->iomap));
> +	memset(&iter->srcmap, 0, sizeof(iter->srcmap));
> +
>  begin:
>  	ret = ops->iomap_begin(iter->inode, iter->pos, iter->len, iter->flags,
>  			       &iter->iomap, &iter->srcmap);
> -- 
> 2.39.5 (Apple Git-154)
> 
> 

