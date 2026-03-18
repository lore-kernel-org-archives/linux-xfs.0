Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37CEC3A8744
	for <linux-xfs@vger.kernel.org>; Wed, 18 Mar 2026 11:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773834438; cv=none; b=u2u8DFoBZSPF0gX3JN4DDkOjFPoWbQlwOevNJAejlHMStE1cpPv3uTUitAuAmh1R4bBmqH5PrMAgZSszHXW4i1pYFVy9Hu5VgC5QHe8V3THLLC+uRhZMVVbc08jEKAQdZPyIvtDNzh3DBwWvMCSm8LRQja2gjIZ7NIWjN4K5OeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773834438; c=relaxed/simple;
	bh=2Ipopl0IQ2kMsETuclRp432Zn6T29/+ZR3DIinF01Ws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mvU6Nuc7qXtkMMNNI/GeFuXnXsLf6fMQn/uvRTPwTMuTm6yh7URXRapjpozKdl3hXa/Adu5K9/svqst9AHuQZAI+YYb+gc754Y1xtClvmXuuw0/zyDseqAWTSf8moVOY8DZGwG1Ju28HNj62SzFdOTtukJSvC1eYb4On2zEwc18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dbRS2Wpi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dbRS2Wpi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773834436;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UzUL77Vm2Epi/AWTl/ukHAQYpuQ+5LWDqq/vJjfksbs=;
	b=dbRS2WpinZDzo4mZeZTZKBUFzifB+VCmhFLIk9mLCLrIkVD0emnhN8ZKca2T0yto//rdM3
	zHWt9Kn1ndGGsnAab4hYR7b4EkC2pDKzcPUegciSTXKynk0KSmdsKk79s+KX+gC7eMbM/B
	Dcb+6QgK64EdG7xisz8+ptJFGa4/tpg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-110-xreNIDfAOB2oVfcT5pf2FQ-1; Wed,
 18 Mar 2026 07:47:13 -0400
X-MC-Unique: xreNIDfAOB2oVfcT5pf2FQ-1
X-Mimecast-MFC-AGG-ID: xreNIDfAOB2oVfcT5pf2FQ_1773834431
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D06861944EBF;
	Wed, 18 Mar 2026 11:47:11 +0000 (UTC)
Received: from bfoster (unknown [10.22.89.178])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C960B18001FE;
	Wed, 18 Mar 2026 11:47:10 +0000 (UTC)
Date: Wed, 18 Mar 2026 07:47:08 -0400
From: Brian Foster <bfoster@redhat.com>
To: Dave Chinner <dgc@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 4/4] xfs: don't decrement the buffer LRU count for in-use
 buffers
Message-ID: <abqQvDoZv1Dbb2Hz@bfoster>
References: <20260317134110.1691097-1-hch@lst.de>
 <20260317134110.1691097-5-hch@lst.de>
 <abnQcrRk55SEqPu0@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abnQcrRk55SEqPu0@dread>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Wed, Mar 18, 2026 at 09:06:42AM +1100, Dave Chinner wrote:
> On Tue, Mar 17, 2026 at 02:40:55PM +0100, Christoph Hellwig wrote:
> > XFS buffers are added to the LRU when they are unused, but are only
> > removed from the LRU lazily when the LRU list scan finds a used buffer.
> > So far this only happen when the LRU counter hits 0, which is suboptimal
> > as buffers that were added to the LRU, but are in use again still consume
> > LRU scanning resources and are aged while actually in use.
> > 
> > Fix this by checking for in-use buffers and removing the from the LRU
> > before decrementing the LRU counter.
> 
> So I wondered why you put the "in use" check where you did a couple
> of patches ago - it didn't make a lot of sense to me because 'in use
> buffers' typically reset the lru count to their maximum at the same
> time they lookup, lock and take a reference to the buffer. The the
> lock and reference are dropped at the same time when we are done
> with the buffer, so it never made sense to decrement the LRU count
> whilst buffers are locked and referenced...
> 
> Can you just fold this back into the original patch that introduces
> this check?
> 

I explicitly asked Christoph to split this out in an earlier version
because it unnecessarily combines logical changes. The in-use check in
the first patch has nothing to do with how LRU references are tracked or
set, but rather exists because the LRU itself no longer has a hold on
the buffer. Therefore it cannot maintain its own hold while a used
buffer may go on to sit on the dispose list for some period of time.
Instead it has to either free the buffer or not, so the in-use check
leaves the fate of the buffer to the holder(s).

AFAICT this is effectively similar to how existing code works. Whereas
this patch changes how the LRU refcount is managed by always removing
in-use buffers. Note that I'm not arguing whether current behavior makes
sense, just that it's a change in behavior because regardless of whether
holders reset b_lru_ref, nothing totally prevents an LRU resident buffer
from cycling out while in use. This makes it easier to separate
functional rework from buffer LRU behavior change on the off chance that
this leads to an issue down the road and somebody needs to bisect
through these changes.

Brian

> -Dave.
> -- 
> Dave Chinner
> dgc@kernel.org
> 

