Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62A62DF3F2
	for <linux-xfs@vger.kernel.org>; Thu, 18 Dec 2025 09:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766050819; cv=none; b=NQL/GFJJJ3gxy33SVgTvom4jJtVCKWxC36eTfKcafVnR4E1GoXaqUVb/EDKIbd44ijXDRv7gmfUJWhYJEPlc3lr3ylaZxQsmWIgk84I7s9UOHFCQZ/YhFwfrX5AlPOjoMUPyq1dpl4ogUeIhhYQZ5XDDfnqpqgey3rjqGe+zFcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766050819; c=relaxed/simple;
	bh=ky5Q1T+ezas+6lHUJs5lgO7Nb5r4ocP/kZLPfuMxAbI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XBDnaovXdLiSkuTBdBlMrw3lWfAmxkhgEO5irKrBWpuKXjLICpojD/tdqhQvz9m6f7XXs5XA35s1IXmCWeFmlFzS+hoQDou03u1iZuyCFFX+VU6yMG3d7VG2XEsROGI0Pd2Qhet6De6qxzciFrpjvBVf5ALx43CPlzHll3goKbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ToiB5/Ur; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ToiB5/Ur"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766050816;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gdoVLXx4c8oXv89VmjV0/oZ5aqeNJYRBkgDgvRg7VFw=;
	b=ToiB5/UrOZtshUtjP9xvcnuMtSrQagtMKBXj8NiTjd3jZqwUqBWIqfV8UhtzFeDX6BQPzh
	wGiQBR54s51X9CdEUblYpo+Q3TuZG8xMEn1LtnUyfkWzHpFXHmKpNrk50qZ8dHBbyLBYgZ
	2drOeHSHd+ozNob4JfVQuTmxRoXNdGM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-422-XjyHrbePM0O-UgWrDE71Gg-1; Thu,
 18 Dec 2025 04:40:12 -0500
X-MC-Unique: XjyHrbePM0O-UgWrDE71Gg-1
X-Mimecast-MFC-AGG-ID: XjyHrbePM0O-UgWrDE71Gg_1766050811
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 936C318011FB;
	Thu, 18 Dec 2025 09:40:11 +0000 (UTC)
Received: from fedora (unknown [10.72.116.190])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A5E6B19560B4;
	Thu, 18 Dec 2025 09:40:06 +0000 (UTC)
Date: Thu, 18 Dec 2025 17:40:00 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] block: add a bio_reuse helper
Message-ID: <aUPL8Jr39N-SIf_W@fedora>
References: <20251218063234.1539374-1-hch@lst.de>
 <20251218063234.1539374-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218063234.1539374-2-hch@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Thu, Dec 18, 2025 at 07:31:45AM +0100, Christoph Hellwig wrote:
> Add a helper to allow an existing bio to be resubmitted withtout
> having to re-add the payload.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/bio.c         | 25 +++++++++++++++++++++++++
>  include/linux/bio.h |  1 +
>  2 files changed, 26 insertions(+)
> 
> diff --git a/block/bio.c b/block/bio.c
> index e726c0e280a8..1b68ae877468 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -311,6 +311,31 @@ void bio_reset(struct bio *bio, struct block_device *bdev, blk_opf_t opf)
>  }
>  EXPORT_SYMBOL(bio_reset);
>  
> +/**
> + * bio_reuse - reuse a bio with the payload left intact
> + * @bio bio to reuse
> + *
> + * Allow reusing an existing bio for another operation with all set up
> + * fields including the payload, device and end_io handler left intact.
> + *
> + * Typically used for bios first used to read data which is then written
> + * to another location without modification.
> + */
> +void bio_reuse(struct bio *bio)
> +{
> +	unsigned short vcnt = bio->bi_vcnt, i;
> +	bio_end_io_t *end_io = bio->bi_end_io;
> +	void *private = bio->bi_private;

The incoming bio can't be a cloned bio, so

	WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED));

should be added.

Otherwise, it looks fine.

Thanks,
Ming

