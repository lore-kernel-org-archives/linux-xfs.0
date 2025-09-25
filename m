Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1FBE3148CD
	for <linux-xfs@vger.kernel.org>; Thu, 25 Sep 2025 18:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758826542; cv=none; b=BHew8sM94GK3jpvAaPrvBJbSSIjXWeN7IB1+lHiqfp6g0itktGsoUZCgJW1GzQ8FC7Udsn1f1dvJHfQHIVXfc/X7eI5hzzlULtgmpuu6RiYRlsPVzvzH+NI2fPF/RYr0PJsD9CpfeHX+1e+J/nrKsguAAiesJb0cO1prP0A+iuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758826542; c=relaxed/simple;
	bh=x7ygrI33kIAzoBAo55q0Aa5oENsdcjKJIJkw1CzXsQo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SHbjL1QTpp5NKvx7+QzwUt6XJHmvL3I/pXKo0Fjb/YcKZEYXUa2+N1HoDzEQ2rqMn9S/vEsOlaRx/IdDgnOXgD4e+1dA3BbnMbuGmSpa/rS3nDsS/RM/lTOyrhERgUyRMJ6T3pE7h8qWDRg4XHVxj2NeklLy7sJNj0hrqr696ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NqRaBymP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NqRaBymP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758826539;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tMONzo2AhO5H0XYthMIALnHr8kJUEuRK/ZwZjgdlpeQ=;
	b=NqRaBymPDkPbtvWhentp2Fb7XdUHuMXY8ZIFH1c/RlbiiW89bZPyuX1ow2QKoxhcifNg4i
	mqz0W1MzKAhqVMY357122AxMmxGytW6yAoWDc73YQfWPmfSQEcirCUy6b1tSb1lDQ6/2IH
	dVaDnjUfkMwvBdU2Z/P8nVA562is6D8=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-635-S84nCjDdP6O1k0a0wG0M8w-1; Thu,
 25 Sep 2025 14:55:36 -0400
X-MC-Unique: S84nCjDdP6O1k0a0wG0M8w-1
X-Mimecast-MFC-AGG-ID: S84nCjDdP6O1k0a0wG0M8w_1758826534
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 677C71956086;
	Thu, 25 Sep 2025 18:55:34 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.134])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 28E9430002D1;
	Thu, 25 Sep 2025 18:55:32 +0000 (UTC)
Date: Thu, 25 Sep 2025 14:59:42 -0400
From: Brian Foster <bfoster@redhat.com>
To: alexjlzheng@gmail.com
Cc: brauner@kernel.org, djwong@kernel.org, hch@infradead.org,
	kernel@pankajraghav.com, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	yi.zhang@huawei.com, Jinliang Zheng <alexjlzheng@tencent.com>
Subject: Re: [PATCH v5 1/4] iomap: make sure iomap_adjust_read_range() are
 aligned with block_size
Message-ID: <aNWRHkLos9bM8a_8@bfoster>
References: <20250923042158.1196568-1-alexjlzheng@tencent.com>
 <20250923042158.1196568-2-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923042158.1196568-2-alexjlzheng@tencent.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Tue, Sep 23, 2025 at 12:21:55PM +0800, alexjlzheng@gmail.com wrote:
> From: Jinliang Zheng <alexjlzheng@tencent.com>
> 
> iomap_folio_state marks the uptodate state in units of block_size, so
> it is better to check that pos and length are aligned with block_size.
> 
> Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
> ---
>  fs/iomap/buffered-io.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index fd827398afd2..ee1b2cd8a4b4 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -234,6 +234,9 @@ static void iomap_adjust_read_range(struct inode *inode, struct folio *folio,
>  	unsigned first = poff >> block_bits;
>  	unsigned last = (poff + plen - 1) >> block_bits;
>  
> +	WARN_ON_ONCE(*pos & (block_size - 1));
> +	WARN_ON_ONCE(length & (block_size - 1));
> +

I thought Joanne's patch [1] enhanced this function to deal with this
sort of corner case. Is this necessary if we go that route or am I
missing something?

Brian

[1] https://lore.kernel.org/linux-fsdevel/20250922180042.1775241-1-joannelkoong@gmail.com/

>  	/*
>  	 * If the block size is smaller than the page size, we need to check the
>  	 * per-block uptodate status and adjust the offset and length if needed
> -- 
> 2.49.0
> 
> 

