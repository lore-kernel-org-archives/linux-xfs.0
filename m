Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850BD311C1B
	for <linux-xfs@vger.kernel.org>; Wed, 22 Oct 2025 09:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761124874; cv=none; b=gWmX+fZ001Q+nhBmds37B5BJX6u5p6YqDIqOQzo1QnwF4OtSf4t1wdf/SXj6c8b0r7sABQtL1xvAANopjf9K6QwaLJ2nbpaFnyYZdZyRWkSII20nM1Kgd7De5GUNziPI2wA0iMNEmuyZeiGXms8y2fKoxA/wm2FSMBMf+27dt1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761124874; c=relaxed/simple;
	bh=J2YSK7N794GUlHnx75fQhwm6v6LA7cxyz+e8D6Z82oE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=laXb3LlkAxp4L6eI2RsX9Xxudw1tSCxlssKgdXv96r/YE59h2th8rtt73XjTnS9eDphWvNZbW/0jz+MX/SiBOuU8+gBY63SpQaLd3HLq36go+YsrWH7HYJE06dXfolrQGYHresiU0GRD08wUSwWKKuUD5jI8q9lOOxUOKmF1z6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G6c3jJmQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G6c3jJmQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761124869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=51t2RWGgp5Brg+/m6qzVcpJk4Qoktdld/THNR5H9UsU=;
	b=G6c3jJmQ0Kytc4484bEQDfFm8pknT0gSPDwZgBY/rdfSrPi3vJUKK5yxulomGwg1s7QEqu
	p7t2nTW3+YRUu7h+faDTVGBUVsi6J6Lax+OO/itH628I34HEE2YeCXVztuSYOWbJx721tY
	1J4NQMSh9XWIU3Ii4hQeFchwaisPGtw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-325-sblmwACvPQSNEUFkw_KxCg-1; Wed, 22 Oct 2025 05:21:08 -0400
X-MC-Unique: sblmwACvPQSNEUFkw_KxCg-1
X-Mimecast-MFC-AGG-ID: sblmwACvPQSNEUFkw_KxCg_1761124867
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-4283bf5b764so2320397f8f.3
        for <linux-xfs@vger.kernel.org>; Wed, 22 Oct 2025 02:21:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761124866; x=1761729666;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=51t2RWGgp5Brg+/m6qzVcpJk4Qoktdld/THNR5H9UsU=;
        b=Y+F+eCDVCAuKXKASfntnhVGJ2mPpvjM9W205jD6DOpl8w2/UVW2du6kIZDbHZnUBdI
         eCCyLlKiPFBfWzdr+t10ab0Pv5OXPq3EHUOP8kb3xm709x3+ZY5jhMbywZJw5m58906D
         y4jCbbDudBQoIEexNYYSeGzFz/mOrSCUwqblpq5aZlmpO4X2bFjZuvGX6RbqkXRjauEU
         BY3IJ4vcD9yeCkU1PBe8/u0CUd3f87kXxeL0oVFqPNy2RgUo2fwgZUrNlbhtdc9nPeJ/
         z57ETFIPoeoFC0ziw0VbszITonshMMqrTPpRcfsdmoOVlvWO4Dn+YfmN9l2kqcn/wmkD
         VfrA==
X-Forwarded-Encrypted: i=1; AJvYcCXliU/bf0lXds8vc24/sRqtuYE0LwCkvo2Uoyu8FCyuJlYh8fERIUwPyfp1tN4uIl7gToSimwojN+g=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjisKvTygifptqWITLJzRWkZa0RXi53szeUyCLSJDKyTlHH2yZ
	bhR++xO0EBuTzQ21NfoZjvlYsF4qh2VHG+r8p0/JKT+/Tn8kCkodAvAzhrxb4LQWKsNHc11k82I
	0V/i7OKF1S7GTieqNh1t8fpFAKPR5UpWZyiCfaqu4pp+qLJsQsar03dAaFyteXyXx5mPV
X-Gm-Gg: ASbGnctPneGvkP9e+IcVY/eDYurqo0gWLexB4AzdQ6CYThZbNWHR+gLvo4frXtT2qlB
	giPGlDWHiL1f/0e880UwuLf2buL/DgGgSyx18eS6FviVKZzBN1sGR9bpNrDdzMmwN2ja2rJNRcK
	G7/3jhPZTl7c64FONdf1lepSNFFflCbSBBbP0VnIuvQaKITOhg4cp5BTdwT+1bBt6+TjrcErMxY
	UM6aQRszuYa3mcEmd8YpPnDLJFspbro7h8HwmtXUQbDqm47cEfkmXtLXAdXbVocvXSHLqJHMMFF
	6YAELG5rNx2pQW0PobMSo6vDxTJaXyujT77LdFMhvVbiWdHLq9T4vqppck1n2xbOFLk6VAmq3Jl
	GmF85H1a26Hc/tdmS4EM=
X-Received: by 2002:a05:6000:250d:b0:3fb:6f9d:2704 with SMTP id ffacd0b85a97d-42704d7ed25mr12864623f8f.28.1761124866343;
        Wed, 22 Oct 2025 02:21:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHSk7hSNGdxb3UWx83tWHnw1JMpdbIVBP1oqN2QXjEhizt5bPfZm3crPnxFVXRoaQG11o9NFw==
X-Received: by 2002:a05:6000:250d:b0:3fb:6f9d:2704 with SMTP id ffacd0b85a97d-42704d7ed25mr12864610f8f.28.1761124865780;
        Wed, 22 Oct 2025 02:21:05 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f009a6c5sm24805868f8f.28.2025.10.22.02.21.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 02:21:05 -0700 (PDT)
Date: Wed, 22 Oct 2025 11:20:34 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: improve a few messages in mkfs and xfs_copy
Message-ID: <trtxy4vqqc3vckeloicpdisjqie4q3vjskepwiiy4z6mc2t4lc@zyyabidih7az>
References: <20251022085232.2151491-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022085232.2151491-1-hch@lst.de>

On 2025-10-22 10:52:02, Christoph Hellwig wrote:
> Hi all,
> 
> these patches have been in my stash for a while and improve messages
> that confused me when I ran into them to be a bit more useful.
> 
> 

lgtm
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey

