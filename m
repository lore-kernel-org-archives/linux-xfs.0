Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39A614AD2D
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 15:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460215; cv=none; b=fRkrd3GRj1sSmIFup4d7enjjOvyUtXtDfY2yEjYfaJsnXDJurPtjfGMGlEpNYqyxG+tUjXCtM2STXXQgVxy7GoHr391K2yIB513TLpgBIPL7gX6fi/LIFLKZPcYJAPJDKvx/sDqybcGFIyKE3urihSRFGewXQ+CX8vk94ABmVEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460215; c=relaxed/simple;
	bh=zLnvnEOcdUyhzmmRtR8Z/CXpb9a5HWr2hDFZK2Zd6D4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yje/h99p1afbQVDSZe892XNjEV8qGw2ZmDhyPz71lHxJwLLQEpFDRsbQ9sEIKPi3i2CKzpHdrp0E3cbJ/6w10EDuXOFqxnnAGsDqdIPFh4xaXgH2n0rsbvdpnLwdyM3+6I7GsyTbCn4QEEeadz2H9j1xKPlGisps3x70qqLtP8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MqsKo74l; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MqsKo74l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739460212;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V6NSGpmF6A7FjNLzw1CLnE7K0XPUQNNO6LfnQ/NE8F4=;
	b=MqsKo74lMyQWqR9uaZIOua66SiVyHF93iVBKuGNb/9eei0LCdrY/G6vKBn1n8jeyNGplwt
	PtT5+rChgoequy0Ld5u6/LYxG54dIPm0pcZIMCFdY4pGUKcXHuwvxR0jtn7qFtyaAyWvFS
	QYWuLlPWUka6lDO+qILH+g7Z6YYd1BE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-42-M6NJswIkO1unNNHoVOYoYQ-1; Thu,
 13 Feb 2025 10:23:28 -0500
X-MC-Unique: M6NJswIkO1unNNHoVOYoYQ-1
X-Mimecast-MFC-AGG-ID: M6NJswIkO1unNNHoVOYoYQ_1739460207
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E6D351801A10;
	Thu, 13 Feb 2025 15:23:26 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.88])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 03F6119373D9;
	Thu, 13 Feb 2025 15:23:25 +0000 (UTC)
Date: Thu, 13 Feb 2025 10:25:51 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH 02/10] iomap: advance the iter on direct I/O
Message-ID: <Z64O_46KzghJIkv0@bfoster>
References: <20250212135712.506987-1-bfoster@redhat.com>
 <20250212135712.506987-3-bfoster@redhat.com>
 <Z62WiAHDVL_pDPOa@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z62WiAHDVL_pDPOa@infradead.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Wed, Feb 12, 2025 at 10:51:52PM -0800, Christoph Hellwig wrote:
> On Wed, Feb 12, 2025 at 08:57:04AM -0500, Brian Foster wrote:
> > Update iomap direct I/O to advance the iter directly rather than via
> > iter.processed. Since unique subhelpers exist for various mapping
> > types, advance in the commonly called iomap_dio_iter() function.
> > Update the switch statement branches to fall out, advance by the
> > number of bytes processed and return either success or failure.
> 
> Can we push the advance into iomap_dio_{bio,hole,inline}_iter?
> It think that would be a bit cleaner as I tried to keep them as
> self-contained as possible.
> 
> 

Sure, I think we can do it that way if that's preferable. I'll have to
take a closer look at iomap_dio_bio_iter() as that one looks a little
more involved at a glance, but TBH I suspect the worst case is we could
advance in the out path and have pretty much the same behavior as this
patch.

Brian

