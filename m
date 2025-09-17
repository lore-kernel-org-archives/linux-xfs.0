Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FF02FF64B
	for <linux-xfs@vger.kernel.org>; Wed, 17 Sep 2025 17:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758131773; cv=none; b=XynVwZ7iShvLHObZVAB4UT94DRoO0vxZLPhFi+ih6i6Ci/6TGS9ScP0l7PS/ENpxNWio2QMmxPpZMxL2e/gZ8qbW+/6CM7AL5mcCvLtvDlpGxDNhi1vWIIvq6/mZE5ELawJCR2EVUU+l9nyxjgKgktIxGj56ZqRGOJdRkHlrOdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758131773; c=relaxed/simple;
	bh=QB0+xT5W+FgZj3/TibpzVjXdFkOwXEdw58TkjILn+LM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QwSztiyS5KUHllE+4LA6QuzIb4HRxFOkopipAMixBTJ0MRy1/i382ksGJKivgqn5lGLBIER9U0kT/VRZLt3fGOWxHZZ4nrsuWTkCXzbC5Jxy+DtnjcfFjwD4VRoiKBGz3pe42kXzOK6j4mot7gYP+fyNQeKOZXydR0ueGQmfHmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E78kYVN4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E78kYVN4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758131770;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gBbhNro+EWZBD+kQ9pa6vL5w+XwALepwcdtZmJDa+Do=;
	b=E78kYVN4sS0OC1mOD/1ejeTWOsKHBHY5bQ6BtBpS/AbXUbFNF0uPOUG4BHcnN4xAmwRAWM
	UoseA4/1e19rzQxdi94GbXlLl7Uzhx/1SRtpV/U2dhqm+zO1DqdPq6EXjdAH/dAi8QZ0Zg
	Cj3mK5N5WrOURIW4WKFZoXsHa1TfW8w=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-17-cokWAq9_M6S_YB1b7twy9Q-1; Wed,
 17 Sep 2025 13:56:08 -0400
X-MC-Unique: cokWAq9_M6S_YB1b7twy9Q-1
X-Mimecast-MFC-AGG-ID: cokWAq9_M6S_YB1b7twy9Q_1758131767
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 993571800599;
	Wed, 17 Sep 2025 17:56:07 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.134])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D437619560B1;
	Wed, 17 Sep 2025 17:56:06 +0000 (UTC)
Date: Wed, 17 Sep 2025 14:00:11 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: remove l_iclog_heads
Message-ID: <aMr3K1gW2IqvhpKr@bfoster>
References: <20250916135646.218644-1-hch@lst.de>
 <20250916135646.218644-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250916135646.218644-8-hch@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Tue, Sep 16, 2025 at 06:56:31AM -0700, Christoph Hellwig wrote:
> l_iclog_heads is only used in one place and can be trivially derived
> from l_iclog_hsize by a single shift operation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c      | 11 +++--------
>  fs/xfs/xfs_log_priv.h |  1 -
>  2 files changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index a8e2539defbf..ca46cdef4ea4 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1277,13 +1277,8 @@ xlog_get_iclog_buffer_size(
>  
>  	log->l_iclog_bufs = mp->m_logbufs;
>  	log->l_iclog_size = mp->m_logbsize;
> -
> -	/*
> -	 * # headers = size / 32k - one header holds cycles from 32k of data.
> -	 */
> -	log->l_iclog_heads =
> -		DIV_ROUND_UP(mp->m_logbsize, XLOG_HEADER_CYCLE_SIZE);
> -	log->l_iclog_hsize = log->l_iclog_heads << BBSHIFT;
> +	/* combined size of the log record headers: */
> +	log->l_iclog_hsize = DIV_ROUND_UP(mp->m_logbsize, XLOG_CYCLE_DATA_SIZE);

I haven't grokked the full series but this looked suspicious at first
glance because it rounds a byte unit field (logbsize) to a sector unit
value. After some rubber ducking with AI, it suggests this might be
problematic for log buf sizes < 32k (i.e. 16kb is the min supported).
I've since closed the window and lost the output, but I think it
suggested open coding the original calculation:

	hsize = DIV_ROUND_UP(m_logbsize, XLOG_HEADER_CYCLE_SIZE) << BBSHIFT;

Brian

>  }
>  
>  void
> @@ -1534,7 +1529,7 @@ xlog_pack_data(
>  		dp += BBSIZE;
>  	}
>  
> -	for (i = 0; i < log->l_iclog_heads - 1; i++)
> +	for (i = 0; i < (log->l_iclog_hsize >> BBSHIFT) - 1; i++)
>  		rhead->h_ext[i].xh_cycle = cycle_lsn;
>  }
>  
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index ac98ac71152d..17733ba7f251 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -406,7 +406,6 @@ struct xlog {
>  	struct list_head	*l_buf_cancel_table;
>  	struct list_head	r_dfops;	/* recovered log intent items */
>  	int			l_iclog_hsize;  /* size of iclog header */
> -	int			l_iclog_heads;  /* # of iclog header sectors */
>  	uint			l_sectBBsize;   /* sector size in BBs (2^n) */
>  	int			l_iclog_size;	/* size of log in bytes */
>  	int			l_iclog_bufs;	/* number of iclog buffers */
> -- 
> 2.47.2
> 
> 

