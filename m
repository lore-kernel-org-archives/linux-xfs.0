Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCDDD3382D3
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 13:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771506017; cv=none; b=IyMEpxd86EUaPzM1V635o6B+jw6GKLhkhXpeAk6jMoDq2+83Hi4q0Sy5U3jvMz0VlmHglDeZz5e8MEewurj4erSP/C+LkT+dcInGbQf8/rli8l9KVJVDJqvmwV7pLLIxwQspLqf3ay5Xl6BGNuPRNldg9+w1CQe5tRz4yxy27lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771506017; c=relaxed/simple;
	bh=hlu4srWB7+MTqqrrEztAIVIK0Nl3yD8y6slEbQdtLUQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i4dEyEOl7RZnw7EwKN/mf9HyVQKvO2NHWRMkaj9dspB9/vmO2c5gX7JAcfokIHJMRVZLxMkcpOG43ZvB7Y6OzgFr8xhEYOMMFEZhX2PnuRx0Qbp9X54Jwt0VbIScyKfREopxW70bhBCiyleoPKbj4hu6YK5XuTSkfklS1mKNqrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YOEglM03; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=GCa5jAhK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YOEglM03";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="GCa5jAhK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771506015;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YRdmcSb5fRzx6pFuColKu/1eTpEZSmutbO/RV80LleY=;
	b=YOEglM03njEkyNNheIA3lWvSyRMPyPtVfyaHlito7O3mcFwvk4SY9ZcyhTAv7oPA7bUaQs
	TERtOCVak21RcoC1dO7zPEVW6idwDEJOCVmHShd0nl581XSWVndbSq3nKfXNe5w0iMDiwd
	b2OyKXl9w7YXb/gpC6l+iyZfJJSciII=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-196-8Iav1L2HMzKeTFQmzOZHiA-1; Thu, 19 Feb 2026 08:00:14 -0500
X-MC-Unique: 8Iav1L2HMzKeTFQmzOZHiA-1
X-Mimecast-MFC-AGG-ID: 8Iav1L2HMzKeTFQmzOZHiA_1771506013
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4836cd6dfe6so8450285e9.2
        for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 05:00:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771506013; x=1772110813; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YRdmcSb5fRzx6pFuColKu/1eTpEZSmutbO/RV80LleY=;
        b=GCa5jAhK+QWrPhYS6nxhEgWcPuYIyTc4deUx0+ECJREvSEkdTyZbPUUdE01DXQ8/ei
         hnNWRPr9LN/DEvJ+1lcR/KVKvHsEsu2sOGktv1g0mA48Dh9FyQGiiKPZvpMwwqL4vz6x
         RzCgCSU0gaXfffhqoeAS4OZA78IYti9wt7tPHGOgQj4jNFcuRNM5NHFhBXl2I3P+qYMv
         bjEXZ1wUZvYbYrqS7VyJd38XXAbnpZ8EIZ8DRfFwr4jlFTwmbY3qdYDCQByOw8E9ViGW
         OtKNlOJ3kawVveMOyeoVkqNnfpJJQFJAoVUyjTqxZ/hTACaQn9nbgXEsypIrKmZPyIHv
         FRRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771506013; x=1772110813;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YRdmcSb5fRzx6pFuColKu/1eTpEZSmutbO/RV80LleY=;
        b=uj8wHtoOwSs0zRWDkV+NY/3Cj9jIPNdckXVkoY3DCD+aVbINAt3N8y8hy9t8s66tTu
         loiUunHxPe1AhrK31YYxJrEt3YT2jHrwcVUHLr6qOCPQgAFOdY9TFkDW2SLwOXP6pY+D
         svtMbMSzKj7jNFBgZ6gKo1FmQ2fvHjQvo3rY+cw0W6JR2PAYTy9AruxFKmeIRd2glLB3
         8/a9mmM7efyAOvm1ig2e4ygyTxSxli30p8P2GDQTe0gMxMWVd1ta7a6LxrgnH81rVL8r
         vzXqfIQWXFWsCOBKXD7bwvluaOLMWskxnQNisOCwjjXzk4wHovYPkj0bZC28OEVwaj6j
         p7TQ==
X-Forwarded-Encrypted: i=1; AJvYcCX3cYWxYgc4SYNyJnAOZ9y57PlrPzffI0ygHJg7SPkXSeBarg8lYVgASvc7fk2MIVjr85PFxJYfNHM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEUv7hnY38d7zZSk7YBE9LRKDoHYvAKr1FVRgwsfKoyhn79fHG
	RIjQ1iDA3WXnx7xO8hZyZhtuCCh+uwemolNc8pqNXb8dQCIWtPUPWxQ3rwJSCszI8c+OP6jI8UO
	PfaBb+8yYUU7fe2iqNn9lkn3mERSTolE93MpiaatMS6QZtUzEtm/0+DArQGnVguOPRCHg
X-Gm-Gg: AZuq6aJ3GDN3/c2L+u/C3tGrxaTD9OsEN5VmT76755ke20VSySKAgVgeU7V5ZjAiERR
	z1NA7nqdcIZUh+XB3dlnNBJWQlwzHmWElMY773bRnxHMLi2XQVQmN30C4DkvkIrrUb7umebD7Xe
	qSHZSOmTPEIILENvhDKqaHgt8xO24UL/Dca5WusfxI8u/bEhMVYaXdKUAQ1ZMzfLKn9AT4lP1tW
	46PVkdOK+gu/4ZaNgnz/Ol600KB6DnZt8TLKbaOAj1WY64Eb2bgH+wSK6d/G1g+w0+GIgi9G+kn
	lNOIkYPgdvcDo6jcE1yC9BqwwHBP/XNI2GslE+mWeHY7u3ho988qM/pWDxxL9+tvbvDB3YTi+AS
	ZGXk5eCa0pRQ=
X-Received: by 2002:a05:600c:8189:b0:483:6f37:1b61 with SMTP id 5b1f17b1804b1-48379bac876mr281468115e9.4.1771506012884;
        Thu, 19 Feb 2026 05:00:12 -0800 (PST)
X-Received: by 2002:a05:600c:8189:b0:483:6f37:1b61 with SMTP id 5b1f17b1804b1-48379bac876mr281467615e9.4.1771506012330;
        Thu, 19 Feb 2026 05:00:12 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4839f9835f9sm16027655e9.19.2026.02.19.05.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 05:00:12 -0800 (PST)
Date: Thu, 19 Feb 2026 14:00:11 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de
Subject: Re: [PATCH v3 04/35] fsverity: generate and store zero-block hash
Message-ID: <uty67fmpx24hs7ecrgb5ewjhdwl6gxcwm7mosfsfstl5ir47qr@52amkzbbvilv>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
 <20260217231937.1183679-5-aalbersh@kernel.org>
 <20260218220433.GD6467@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260218220433.GD6467@frogsfrogsfrogs>

> >  
> > +	fsverity_hash_block(params, page_address(ZERO_PAGE(0)),
> > +			    params->zero_digest);
> 
> Hrm.  At first I thought "Now that xfs supports blocksize > pagesize
> you actually need to compute this with a zeroed folio."  But then I
> remembered that merkle tree blocksize != filesystem blocksize.  So I
> guess as long as *fsverity* doesn't support merkle tree blocksize >
> pagesize then this is still ok?
> 

yes and this is hashes a single merkle block from the page, so only
zero_page will need to be updated to fit merkle block size

-- 
- Andrey

