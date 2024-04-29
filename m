Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A03244377
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 12:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714392994; cv=none; b=ZhZx/TQchlb2OsLSUkqxHe9/0n6y+Fm9jEXdVKpbotvKhARkBKloowGlhZZTykV2FEuWQaBLoUflGxoi+Y6BlRnYfBHJ3CLuzqY+y8thFghalIbzrnW3PmfASOSb97CIh9o65xajdm5oKhBK1szaE3/z+8SvBT8Gm552OKV3eMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714392994; c=relaxed/simple;
	bh=innJfsjCuO6wbQsIcDJeg+x3OxPMSCDYeliBpDSyYi4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gNHxqk29SyXBv4X7Ha0W55rldP+0a+/0mDXO3XIsYT8PTqeT+o6ApTKuvuzhb2MjCdAR2gU0Ge2+CHP2g3hAvwEBKZclqZiBKhuDmRndk51igjkNlBCLcDvmpakLjMgw9m0krouYJbHbefT73cbtPlProUzslUAz2CCzDqLt5aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VgLZgXI6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VgLZgXI6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714392992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DfHfEGYWEjkqDKDaO2JsAXHSjbdMhE7dpXUDGi2KIu8=;
	b=VgLZgXI62SmPbTcnW09TPA4x7vXjbqCD/s1z386gj9CBEctrvKrbVowA8RPVeSTSefAd/s
	omFTI9lza10UMd+bt/kUHBn5BgoH0uTD2xUtmP+JKQU6vc6ULcOHjJlPl6tOJi/pTWH8R5
	/8l1dPeC7X8P5Qj7IT83K60K9eGCftg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-216-KH4lCXH5OESdYiE8f70UgQ-1; Mon, 29 Apr 2024 08:16:26 -0400
X-MC-Unique: KH4lCXH5OESdYiE8f70UgQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 159E5810BDC;
	Mon, 29 Apr 2024 12:16:26 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.117])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C80D71121313;
	Mon, 29 Apr 2024 12:16:25 +0000 (UTC)
Date: Mon, 29 Apr 2024 08:18:44 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Sam Sun <samsun1006219@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: restrict the h_size fixup in
 xlog_do_recovery_pass
Message-ID: <Zi-QJG3tuRptnDVX@bfoster>
References: <20240429070200.1586537-1-hch@lst.de>
 <20240429070200.1586537-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240429070200.1586537-3-hch@lst.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

On Mon, Apr 29, 2024 at 09:01:59AM +0200, Christoph Hellwig wrote:
> The reflink and rmap features require a fixed xfsprogs, so don't allow
> this fixup for them.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Seems reasonable..

>  fs/xfs/xfs_log_recover.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index bb8957927c3c2e..d73bec65f93b46 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3040,10 +3040,14 @@ xlog_do_recovery_pass(
>  		 * Detect this condition here. Use lsunit for the buffer size as
>  		 * long as this looks like the mkfs case. Otherwise, return an
>  		 * error to avoid a buffer overrun.
> +		 *
> +		 * Reject the invalid size if the file system has new enough
> +		 * features that require a fixed mkfs.
>  		 */
>  		h_size = be32_to_cpu(rhead->h_size);
>  		h_len = be32_to_cpu(rhead->h_len);
> -		if (h_len > h_size && h_len <= log->l_mp->m_logbsize &&
> +		if (!xfs_has_reflink(log->l_mp) && xfs_has_reflink(log->l_mp) &&
> +		    h_len > h_size && h_len <= log->l_mp->m_logbsize &&

... but I'm going to assume this hasn't been tested. ;) Do you mean to
also check !rmapbt here?

Can you please also just double check that we still handle the original
mkfs problem correctly after these changes? I think that just means mkfs
from a sufficiently old xfsprogs using a larger log stripe unit, and
confirm the fs mounts (with a warning).

Brian

>  		    rhead->h_num_logops == cpu_to_be32(1)) {
>  			xfs_warn(log->l_mp,
>  		"invalid iclog size (%d bytes), using lsunit (%d bytes)",
> -- 
> 2.39.2
> 
> 

