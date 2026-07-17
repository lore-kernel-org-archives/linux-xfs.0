Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648AB282F0A
	for <linux-xfs@vger.kernel.org>; Fri, 17 Jul 2026 14:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784297635; cv=none; b=EwRekbXRMYhJjSB5XJp2UMJyz7DctSNL6oWFgdHhTxTcUf1bpUMVVBDAUsWiWjH3hWKzdULXpCQQi0ax0ZCCFfwd4oYbJQTqlEGe4amyPoWKRP3S4lUkxAtVDun791z7t+gTKyctScZ+kEniWWMc/UDxPdkjWQHysoRdkk+hHIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784297635; c=relaxed/simple;
	bh=zqVRQ+SgXsaw1EhOIcRIISPKxnr9FNJtMHqY5sTFBpw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GimYs2HTHUS6q621ZugRh5NOfWhTCECdj22PZDICGWcezyT9emrw1w8QBMTflqkZLBCwa2V0KTIVh6cE/xytFq+or2VzS4xexvLTrr1jBiDr9UXl5SLuYzLw5VoOxA965YsTaX1DA1zkKNc/WKx2QtiUSK/p7Gxjr6ZAeZGWMvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eXZ4Jjxz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eXZ4Jjxz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784297633;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EzLnqLs4FZ8EdLOU+WpGtjdfD/QgYlYhnju3fY3qw/g=;
	b=eXZ4Jjxz6NJfWd3EdwDdSNdusvUMxapkPaz2ThmX5rUXE1ggMG+FCT4doV1BxCtJYKVvGf
	4fmP0OrLVZc9122zAoc85dlvhS+x+OccSGS8a7uVvGU/swqX3Dp4/uY+oksQg8g4tOehqF
	rFbaJsxVErpsBdbWquIW3BEfbMXEbeo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-156-f8VmlPYcM8q0pU4EuXdsQw-1; Fri,
 17 Jul 2026 10:13:50 -0400
X-MC-Unique: f8VmlPYcM8q0pU4EuXdsQw-1
X-Mimecast-MFC-AGG-ID: f8VmlPYcM8q0pU4EuXdsQw_1784297628
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 76D83180075C;
	Fri, 17 Jul 2026 14:13:48 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.111])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BA370D75;
	Fri, 17 Jul 2026 14:13:47 +0000 (UTC)
Date: Fri, 17 Jul 2026 10:13:45 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/12] xfs: merge xfs_buf_reverify into xfs_buf_read_map
Message-ID: <alo4mWl188yS3UWn@bfoster>
References: <20260715145147.95654-1-hch@lst.de>
 <20260715145147.95654-11-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715145147.95654-11-hch@lst.de>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

On Wed, Jul 15, 2026 at 04:51:03PM +0200, Christoph Hellwig wrote:
> xfs_buf_read_map is the only caller of xfs_buf_reverify that is left.
> Merge it into that so that the comments can be moved closer to the
> logic, and redundant asserts can be removed.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c | 79 ++++++++++++++++++++++--------------------------
>  1 file changed, 36 insertions(+), 43 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 21c21491d72e..be3b25ccbea6 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
...
> @@ -685,18 +650,46 @@ xfs_buf_read_map(
>  
>  	trace_xfs_buf_read(bp, flags, _RET_IP_);
>  
> -	if (!(bp->b_flags & XBF_DONE)) {
> +	if (bp->b_flags & XBF_DONE) {
> +		ASSERT(bp->b_error == 0);
> +
> +		/*
> +		 * If the caller passed an ops structure and the buffer doesn't
> +		 * have ops assigned yet, set the ops and use them to verify the
> +		 * buffer contents.
> +		 *
> +		 * Under normal operations, every in-core buffer is verified on
> +		 * read I/O completion, but there are two scenarios that can
> +		 * lead to in-core buffers without an assigned ->b_ops:
> +		 *
> +		 *   1) During log recovery of buffers on a V4 filesystem.
> +		 *	These buffers are purged at the end of recovery, though.
> +		 *   2) Oonline repair intentionally reads with a NULL buffer

Online

