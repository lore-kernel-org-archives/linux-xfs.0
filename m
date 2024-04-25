Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF3D149DF6
	for <linux-xfs@vger.kernel.org>; Thu, 25 Apr 2024 13:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714053348; cv=none; b=shRHGyUaYWE3FSq1UxkLQ813fLtLfbDxei7KX0ApCLMC+/kqmy/jfKAHS3P53sf2uAnwEw6hgINyKFaDJeasSq2xJH/HxU9FleQgPSe0FR+U2BvVwg/+CPsF6Op/A9uZWuxgfsreqwcExuqAB+WUJheZmTf2HpkgdGkZGf6Pl4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714053348; c=relaxed/simple;
	bh=0gOGWX754Dme5o75hzHeRnF10h1sIbteWYGixJF88Zo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a/TuRJSit/a6C06bT5RByHtVXujoM7Av2ax3RgjBnVdV6pkPTSdvPsJ0jt3uG4bbqtYCsQxdeMx70G0Vb4wIywyVBnnM5Ds+idDC8XTg54MyZErk6t50+w0ekvg4n8k6Co8tWsnNAX2ygf1Y4UTJWHqE2BBYi9wYLvX9smY+RYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XBaf+gFu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XBaf+gFu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714053345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SIrQNZSOyGumQ4W9WyC3jnI0g+lXhd8s1D7EZMPy8ok=;
	b=XBaf+gFuzlVkbmJYRolHjy1wDXd3NGn9/rM0UKIowQpY7/E7nJ1feUHyBtTI7mLduuIkEs
	Qgb+hR83goJHoTikotJEMN4t7fIHUw80HdTdQXQY/egE+pP5pmNAgcy6nomaZI/1tlsSjb
	e5WtpWCJdVPcIfmDF4ONxZts/SOEHRs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-274-Aqd1LsKTOJ6ER0lihQRU_Q-1; Thu, 25 Apr 2024 09:55:40 -0400
X-MC-Unique: Aqd1LsKTOJ6ER0lihQRU_Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C8D481827141;
	Thu, 25 Apr 2024 13:55:38 +0000 (UTC)
Received: from bfoster (unknown [10.22.16.38])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7127DEC686;
	Thu, 25 Apr 2024 13:55:38 +0000 (UTC)
Date: Thu, 25 Apr 2024 09:57:54 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Sam Sun <samsun1006219@gmail.com>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, djwong@kernel.org,
	chandan.babu@oracle.com, syzkaller-bugs@googlegroups.com,
	xrivendell7@gmail.com
Subject: Re: [Linux kernel bug] KASAN: slab-out-of-bounds Read in xlog_cksum
Message-ID: <ZiphYrREkQvxkE-U@bfoster>
References: <CAEkJfYO++C-pxyqzfoXFKEvmMQEnrgkQ2QcG6radAWJMqdXQCQ@mail.gmail.com>
 <ZipWt03PhXs2Yc84@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZipWt03PhXs2Yc84@infradead.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

On Thu, Apr 25, 2024 at 06:12:23AM -0700, Christoph Hellwig wrote:
> This triggers the workaround for really old xfsprogs putting in a
> bogus h_size:
> 
> [   12.101992] XFS (loop0): invalid iclog size (0 bytes), using lsunit (65536 bytes)
> 
> but then calculates the log recovery buffer size based on the actual
> on-disk h_size value.  The patch below open codes xlog_logrec_hblks and
> fixes this particular reproducer.  But I wonder if we should limit the
> workaround.  Brian, you don't happpen to remember how old xfsprogs had
> to be to require your workaround (commit a70f9fe52daa8)?
> 

No, but a little digging turns up xfsprogs commit 20fbd4593ff2 ("libxfs:
format the log with valid log record headers"), which I think is what
you're looking for..? That went in around v4.5 or so, so I suppose
anything earlier than that is affected.

Brian

> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index b445e8ce4a7d21..b3ea546508dc93 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2999,7 +2999,7 @@ xlog_do_recovery_pass(
>  	int			error = 0, h_size, h_len;
>  	int			error2 = 0;
>  	int			bblks, split_bblks;
> -	int			hblks, split_hblks, wrapped_hblks;
> +	int			hblks = 1, split_hblks, wrapped_hblks;
>  	int			i;
>  	struct hlist_head	rhash[XLOG_RHASH_SIZE];
>  	LIST_HEAD		(buffer_list);
> @@ -3055,14 +3055,16 @@ xlog_do_recovery_pass(
>  		if (error)
>  			goto bread_err1;
>  
> -		hblks = xlog_logrec_hblks(log, rhead);
> -		if (hblks != 1) {
> -			kvfree(hbp);
> -			hbp = xlog_alloc_buffer(log, hblks);
> +		if ((rhead->h_version & cpu_to_be32(XLOG_VERSION_2)) &&
> +		    h_size > XLOG_HEADER_CYCLE_SIZE) {
> +			hblks = DIV_ROUND_UP(h_size, XLOG_HEADER_CYCLE_SIZE);
> +			if (hblks > 1) {
> +				kvfree(hbp);
> +				hbp = xlog_alloc_buffer(log, hblks);
> +			}
>  		}
>  	} else {
>  		ASSERT(log->l_sectBBsize == 1);
> -		hblks = 1;
>  		hbp = xlog_alloc_buffer(log, 1);
>  		h_size = XLOG_BIG_RECORD_BSIZE;
>  	}
> 

