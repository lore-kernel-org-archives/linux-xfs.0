Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74E939657E
	for <linux-xfs@vger.kernel.org>; Thu, 16 Apr 2026 13:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776346056; cv=none; b=HVC/Ae0s+qDno8WEmqTnf2qZg3qu9TbGP/cMk3gyskdHWcS473jT2Wz5TfvgmigkKw9vSiQeQ9Lt4pDkAEAWDbdgkSrQ0lFFCMu7jgFbDTGhWKZd1aqfkLSoUDQzV9NR3RbrOAbCLT7iMcXkdSaZNa8zvtvPr9nj9Gt1VpsZ6WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776346056; c=relaxed/simple;
	bh=2bUHpcR1VdsiaIYxdeAHmpdfrXvaIuwbl5WykP7k+M8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uBAIDXlRnykHHBqvEfIMvZ60rl0JlsZR4FgWcyJ3xhjFdJSqQyJ3660sEaqDBYm9NQ6irxsQMNbmwNxDFaKPLzWuv9onHml3l7TL5nNKYthWzGB4SfswD7VarD/3dAFhwZP+hL91V0Mm5ok0+iFtsIS/3Wwwd/mJ6oZFCNEB4H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ia5HTfYD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ia5HTfYD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776346054;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Kd4xzrW3cdgab5XjQjDHE08ZAJkyG+TMqdOu59r6BZc=;
	b=Ia5HTfYDpx5sBon29EgAFdDtBWxPlqF66w/A3G16nnVrqbYKQPvxf7bgWfSTuLeQEkCYs7
	dV3gxwC7dG4+VKw3VCGsg/omitBVg8vtonIkiWwG4OrkeeLxkglLT3ILyqFGXeg8qp/ahc
	FppG7hq1XhqsQRgZHkqHz01EuKTKMao=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-482-AVTfZuPtPHq98oCOk9kJhg-1; Thu,
 16 Apr 2026 09:27:28 -0400
X-MC-Unique: AVTfZuPtPHq98oCOk9kJhg-1
X-Mimecast-MFC-AGG-ID: AVTfZuPtPHq98oCOk9kJhg_1776346047
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E7B6E1955F29;
	Thu, 16 Apr 2026 13:27:26 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.58])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8448218004AD;
	Thu, 16 Apr 2026 13:27:24 +0000 (UTC)
Date: Thu, 16 Apr 2026 09:27:22 -0400
From: Brian Foster <bfoster@redhat.com>
To: Fengnan Chang <fengnanchang@gmail.com>
Cc: brauner@kernel.org, djwong@kernel.org, hch@infradead.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, lidiangang@bytedance.com,
	Fengnan Chang <changfengnan@bytedance.com>
Subject: Re: [PATCH] iomap: avoid memset iomap when iter is done
Message-ID: <aeDjui2LGSidEHcJ@bfoster>
References: <20260416030642.26744-1-changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260416030642.26744-1-changfengnan@bytedance.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Thu, Apr 16, 2026 at 11:06:42AM +0800, Fengnan Chang wrote:
> When iomap_iter() finishes its iteration (returns <= 0), it is no longer
> necessary to memset the entire iomap and srcmap structures.
> 
> In high-IOPS scenarios (like 4k randread NVMe polling with io_uring),
> where the majority of I/Os complete in a single extent map, this wasted
> memory write bandwidth, as the caller will just discard the iterator.
> 
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
>  fs/iomap/iter.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
> index c04796f6e57f..91eb5e6165ff 100644
> --- a/fs/iomap/iter.c
> +++ b/fs/iomap/iter.c
> @@ -15,8 +15,6 @@ static inline void iomap_iter_reset_iomap(struct iomap_iter *iter)
>  	}
>  
>  	iter->status = 0;
> -	memset(&iter->iomap, 0, sizeof(iter->iomap));
> -	memset(&iter->srcmap, 0, sizeof(iter->srcmap));
>  }
>  
>  /* Advance the current iterator position and decrement the remaining length */
> @@ -106,6 +104,9 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
>  	if (ret <= 0)
>  		return ret;
>  
> +	memset(&iter->iomap, 0, sizeof(iter->iomap));
> +	memset(&iter->srcmap, 0, sizeof(iter->srcmap));
> +

This seems reasonable to me in principle, but it feels a little odd to
leave a reset helper that doesn't really do a "reset." I wonder if this
should be refactored into an iomap_iter_complete() (i.e. "complete an
iteration") helper that includes the ret assignment logic just above the
reset call and returns it, and then maybe leave a oneline comment above
the memset so somebody doesn't blindly fold it back in the future. So
for example:

	ret = iomap_iter_complete(iter);
	if (ret <= 0)
		return ret;

	/* save cycles and only clear the mappings if we plan to iterate */
	memset(..);
	...

We'd probably have to recheck some of the iter state within the new
helper, but that doesn't seem like a big deal to me. Thoughts?

Brian

>  begin:
>  	ret = ops->iomap_begin(iter->inode, iter->pos, iter->len, iter->flags,
>  			       &iter->iomap, &iter->srcmap);
> -- 
> 2.39.5 (Apple Git-154)
> 
> 

