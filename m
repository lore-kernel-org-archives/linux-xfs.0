Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8B4199FAB
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2025 13:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738072521; cv=none; b=jfDR8Y8pGKI8fuPcLVRMTtMZjyfqV0s/DnEm+iTjTUyBfSiGGA1ZL/mF1rHEPsQDR5y07EDJ5ohZi60DX1XB1pls6NCsmftVQkXtONRvHYkLa1Ii4kD+Z35OfvH/skkCz2wl8mTLdx4twMyi1Ix+9OS4huFSXbou4VI1zYT1bwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738072521; c=relaxed/simple;
	bh=VPEvCUdcTDDyxm6RZ+WwoWbgaYSmkW0AOcLkcfzB6qM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tzgP5b4sundu01LuoPiXYvR7vknHL6+ttOIB6F5LowZkWaZ1qEuaKzhq2cVNrq8bzGaGUbNlXq0MM/LTeepowP//R2tuQh7L+xCWbYuFEyH1G0DPsuM0NAnyorpS1OBQx0dHKloNqnSxiguhVUv9Y/3RgMNtfln20pK8wuMzSeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KwHvyD8O; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KwHvyD8O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738072518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y0awQQoqamDdf6hmE2qj5vIkQWsOvHfrmYqN0w07Tgw=;
	b=KwHvyD8OKGYuxAFMLsPorPwbQRrPiYizTNroYP4dljKCbHqediwR1OOoGNXu8upR1rQsSh
	EHE5/N+H3vTbGOTUNus9vz5oVhIhHLxiqDiUSe1+MxKMf/TFJoV9JSCsPbrbADDxJlcpRQ
	3m64t0GhYA2tvkJgwKspTXotdBSpr8c=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-590-LqKFgQNoM_yGe5loRFz60g-1; Tue,
 28 Jan 2025 08:55:17 -0500
X-MC-Unique: LqKFgQNoM_yGe5loRFz60g-1
X-Mimecast-MFC-AGG-ID: LqKFgQNoM_yGe5loRFz60g
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6A36D19560A3;
	Tue, 28 Jan 2025 13:55:16 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.118])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4ED2130001BE;
	Tue, 28 Jan 2025 13:55:15 +0000 (UTC)
Date: Tue, 28 Jan 2025 08:57:27 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 6/7] iomap: advance the iter directly on unshare range
Message-ID: <Z5jiR8vjG7MT3Psv@bfoster>
References: <20250122133434.535192-1-bfoster@redhat.com>
 <20250122133434.535192-7-bfoster@redhat.com>
 <Z5htdTPrS58_QKsc@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z5htdTPrS58_QKsc@infradead.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Mon, Jan 27, 2025 at 09:39:01PM -0800, Christoph Hellwig wrote:
> On Wed, Jan 22, 2025 at 08:34:33AM -0500, Brian Foster wrote:
> > +	size_t bytes = iomap_length(iter);
> 
> > +		bytes = min_t(u64, SIZE_MAX, bytes);
> 
> bytes needs to be a u64 for the min logic to work on 32-bit systems.
> 

Ah, thanks. FYI, I also have the following change from followon work to
fold into this to completely remove advances via iter.processed:

-       if (!iomap_want_unshare_iter(iter))
-               return bytes;
+       if (!iomap_want_unshare_iter(iter)) {
+               iomap_iter_advance(iter, bytes);
+               return 0;
+       }

And the analogous change in the next patch for zero range (unwritten &&
!range_dirty) as well.

Finally, I'm still working through converting the rest of the ops to use
iomap_iter_advance(), but I was thinking about renaming iter.processed
to iter.status as a final step. Thoughts on a rename in general or on
the actual name?

Brian

