Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB965786B
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 17:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710352341; cv=none; b=PFERooUBPwPjzKgoqoUCm6jy3Yb6FYXxwLw4d52a8UpVaAg2xqMEOUQZGPQX4VHe3Vya5hNcCGukWmdUafCQ8CvBpzFhmJcmUtr2/ZbJo9x1rVn6osIv7g/BUgHRG7rfqXbbZHEGhOz1VKSElOlomvafdNd+0Hp5fFRBuWHr6zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710352341; c=relaxed/simple;
	bh=kN8BJgW8E6me8ZKR2K5NlZ6XfjY36xFhw8CqZ+YeT7w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mGdKX2crclxILQTsgOtx+DJRxOv522ftFgISLFd5ddEXOqpw/gqVuO645LkAlApv544lMAeVzYhwys+kLWB2oqCdjDTyj/VmSZJV6TBAKjoiYWZDW55xzM33w3R65z4fK43JDcLkLdZx50MgT+ss+50ZMJRa49hn05I6/DQzNdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IGzrKMV+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IGzrKMV+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710352338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UICod6fir4VTb9IhOwZazv03gppqYZdga9QpTxw9LZI=;
	b=IGzrKMV+IT0KDsmHe2xYI+/kfGlm4QdK3aRMefxW4wZc0Mek42MOiu6BLxa6GqMHByAtWX
	K0h7J6eekvHssxs418bJ/ZJIfRP5VUv/rl+RpU7Ste8S0Wf8dM+eqXtmUr6g9QbdaFfl0o
	SgmbHsJXTYIezSBi9gzPw4uUSGiylVo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-306-6ScMyEz6MSSR7oIAPTll_w-1; Wed,
 13 Mar 2024 13:52:16 -0400
X-MC-Unique: 6ScMyEz6MSSR7oIAPTll_w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7CDB93C0C105;
	Wed, 13 Mar 2024 17:52:16 +0000 (UTC)
Received: from redhat.com (unknown [10.22.16.77])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F0E32C017A1;
	Wed, 13 Mar 2024 17:52:15 +0000 (UTC)
Date: Wed, 13 Mar 2024 12:52:14 -0500
From: Bill O'Donnell <bodonnel@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs_repair: double-check with shortform attr
 verifiers
Message-ID: <ZfHnzhooYMEGhSAA@redhat.com>
References: <171029432867.2063555.10851813376051369769.stgit@frogsfrogsfrogs>
 <171029432882.2063555.14424210570382825212.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029432882.2063555.14424210570382825212.stgit@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

On Tue, Mar 12, 2024 at 07:11:17PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Call the shortform attr structure verifier as the last thing we do in
> process_shortform_attr to make sure that we don't leave any latent
> errors for the kernel to stumble over.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>

> ---
>  repair/attr_repair.c |   17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> 
> diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> index 01e4afb90d5c..f117f9aef9ce 100644
> --- a/repair/attr_repair.c
> +++ b/repair/attr_repair.c
> @@ -212,6 +212,7 @@ process_shortform_attr(
>  {
>  	struct xfs_attr_sf_hdr		*hdr = XFS_DFORK_APTR(dip);
>  	struct xfs_attr_sf_entry	*currententry, *nextentry, *tempentry;
> +	xfs_failaddr_t			fa;
>  	int				i, junkit;
>  	int				currentsize, remainingspace;
>  
> @@ -373,6 +374,22 @@ process_shortform_attr(
>  		}
>  	}
>  
> +	fa = libxfs_attr_shortform_verify(hdr, be16_to_cpu(hdr->totsize));
> +	if (fa) {
> +		if (no_modify) {
> +			do_warn(
> +	_("inode %" PRIu64 " shortform attr verifier failure, would have cleared attrs\n"),
> +				ino);
> +		} else {
> +			do_warn(
> +	_("inode %" PRIu64 " shortform attr verifier failure, cleared attrs\n"),
> +				ino);
> +			hdr->count = 0;
> +			hdr->totsize = cpu_to_be16(sizeof(struct xfs_attr_sf_hdr));
> +			*repair = 1;
> +		}
> +	}
> +
>  	return(*repair);
>  }
>  
> 
> 

