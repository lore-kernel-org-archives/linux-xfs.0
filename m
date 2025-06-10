Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB83728ECD4
	for <linux-xfs@vger.kernel.org>; Tue, 10 Jun 2025 12:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749557594; cv=none; b=RYA40mjRIdfDV8pHhbHymmOLJjnCzC5DrRY/79JAm58NZTWxNIi/jLKzvCc03FDXJa/T/oqtSyu9NJRZgW17UyAElVZm0m+mjP3QsDMqdvJqqgRxDi6542vPqn2+RSmMs+jHq16JwDxAy7j2c8BhBHOb7mgDqMhj2nGxI2yd99I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749557594; c=relaxed/simple;
	bh=mzbZlpAOR/Pt9RbE4H2dw2sePah/VWNwkDic8n/Ah40=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qzl6QibJk3J3FP2O5wh0NOizb5Z4OmhC+uF1inntxwHS2dfgPnE0fu6zhm9THC/sSzdyuQcCm59hVmJ82Hp3aqLxZnvsjXFpDrMfSfYL7dejj3PbPAbuwyAk9ErQnGlXE92ekrWe8myO13UxjPndW4QL27Bf4x9Xt+YzU/yrnVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=erhJq517; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="erhJq517"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749557591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=heKlbXfDgVVxe8Ad9VgCzHCzkhfC1CaiT7d1fNBqdeo=;
	b=erhJq51743ygbDWN8tzhLSegT4Kc3YIhjzB+4Yhlg97OM35MgTMkS8E/OmSnqh+sItFbpL
	2hjDzO7Vp9YeF2oBGD+feOUOr/HIJOTrz6pMZTOKFI1uE7/thDZ4j/jg6kLEghAF7qINZw
	6WbO+4c+Vu6IeGI05FOcHl9qh2q9fNY=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-528-_zIHByZTNMCjtTFLLKzi-g-1; Tue,
 10 Jun 2025 08:13:06 -0400
X-MC-Unique: _zIHByZTNMCjtTFLLKzi-g-1
X-Mimecast-MFC-AGG-ID: _zIHByZTNMCjtTFLLKzi-g_1749557585
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 05BBE195604F;
	Tue, 10 Jun 2025 12:13:05 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.100])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E8BAB30001B1;
	Tue, 10 Jun 2025 12:13:03 +0000 (UTC)
Date: Tue, 10 Jun 2025 08:16:38 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/7] iomap: move pos+len BUG_ON() to after folio lookup
Message-ID: <aEgiJtDFPZ4eWzzg@bfoster>
References: <20250605173357.579720-1-bfoster@redhat.com>
 <20250605173357.579720-2-bfoster@redhat.com>
 <20250609161649.GF6156@frogsfrogsfrogs>
 <aEeyow8IRhSYpTow@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aEeyow8IRhSYpTow@infradead.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Mon, Jun 09, 2025 at 09:20:51PM -0700, Christoph Hellwig wrote:
> On Mon, Jun 09, 2025 at 09:16:49AM -0700, Darrick J. Wong wrote:
> > Hmm.  Do we even /need/ these checks?
> > 
> > len is already basically just min(SIZE_MAX, iter->len,
> > iomap->offset + iomap->length, srcmap->offset + srcmap->length)
> > 
> > So by definition they should never trigger, right?
> 
> Yes, now that it is after the range trim it feels pretty pointless.
> So count me in for just removing it.
> 
> 

Fair points.. I'll update this patch to just drop it.

Brian

