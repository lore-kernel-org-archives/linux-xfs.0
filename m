Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2B513DDAA
	for <linux-xfs@vger.kernel.org>; Mon,  5 May 2025 14:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746455767; cv=none; b=XTh1xIsbY5UU48oVRgrDmllFs4ERhB/yJcsdpPt+YmMs+yCcDhaKRRZAZpIzJvPMKnswCaDdeihuRfzHBpxmOvdTFDgPI75HbqearjAT5lNojxnTkt0e0wFa/Zvhn3aapbQR8tcn7CjTMCukf3Hd/gaMB5y4KGZcSdoUPfS9x90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746455767; c=relaxed/simple;
	bh=NiI0SBUsKfVpu0bDBlAYkaz3dlUVkI3VQo63VHd3cgA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UWNveohUavN6sFKREi+0LWvF6RTvv3B42vz5hNJ25zMg2L7LasZhI6tjszs7/PQ3xXSQaTU9dxl9K/oGaj8XHJ/8cQK4x2ichcThV93y6IClEGxDmhx0nh7nx+iA0YvKuvaoONZ4mNOPJJWcJBhkYRmrgT/Br9zKngrBYY5pt6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RSXymy/e; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RSXymy/e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746455765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zQ12Lp7Fa/GVMIpOsV31AcmZU5JB46fQ8f0PIoZ9GfI=;
	b=RSXymy/eFv7gtq7LrPgNtMm37GZc/lJnANwzrIjAJiuS438ZD8a4PfA1TZoqEsuhnmc9CJ
	XfATMOJq3QxQxC0cxIAxjneDEROU3542bPZWhNdrUbNbhPHFhaHMkSc4pfRJzGTWoY13B3
	JUfa34of2JoFtrtvjHkqwI4167nFfeg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-266-1AN63fzMMheKjOgrOoopSw-1; Mon,
 05 May 2025 10:36:02 -0400
X-MC-Unique: 1AN63fzMMheKjOgrOoopSw-1
X-Mimecast-MFC-AGG-ID: 1AN63fzMMheKjOgrOoopSw_1746455761
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 155F4180087A;
	Mon,  5 May 2025 14:36:01 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.112])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4B54D1954B00;
	Mon,  5 May 2025 14:36:00 +0000 (UTC)
Date: Mon, 5 May 2025 10:39:11 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] iomap: rework iomap_write_begin() to return folio
 offset and length
Message-ID: <aBjNj7ahzAzTqjdy@bfoster>
References: <20250430190112.690800-1-bfoster@redhat.com>
 <20250430190112.690800-7-bfoster@redhat.com>
 <aBh_P4L99oRiJssd@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBh_P4L99oRiJssd@infradead.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Mon, May 05, 2025 at 02:05:03AM -0700, Christoph Hellwig wrote:
> On Wed, Apr 30, 2025 at 03:01:12PM -0400, Brian Foster wrote:
> > +	len = *plen > 0 ? min_t(u64, len, *plen) : len;
> 
> 	len = min_not_zero(len, *plen);
> 

Ah, nice. Thanks.

Brian

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

