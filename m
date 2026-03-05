Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87A13BA238
	for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2026 15:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772723205; cv=none; b=cgnzHnGg8wn4ThwtmDZiqxnS/RcKymmI1aWwrQL+tLsGd8/PcSL0Ns1AG0aBXC/82Y7FGt4GyeJ/7NG+7qga0A96Uhm9B659aKx/BvlmyWkpufvxPNZ6c7Zn32SPQWMgDkdRFZF5mc1P9WzR2W937egE51aVGkvCeFsZeEU3K3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772723205; c=relaxed/simple;
	bh=gBKW/SjArm8OI64gCkOV8ulWTcxoo8IoUyQkqOHdzpM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WMMWsrz7477S8Z97O8EJYTuLyuxouKVbsWVngXhJJzTuA3pNlPPzKuYUpS/Sde45ABuVcI5I/mjAPuLwmbTIVAQFFJjlNJGpRzU2ASOC5l6cUfCfACo9W2cRJnbHi4iMLJOgh65T7yHOVMK4ps+IZ241hogvJ9f9ei+Md5YQo2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RC7bU9pp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RC7bU9pp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772723201;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QCzDSxbURvoDB/9BEgMytBCLNQre5XUKKfayKWK2Z4o=;
	b=RC7bU9ppR0FO+RxHbKLMQWBWWSQXc7bR/vwH5/3Gay6NX8blzJAMZgxgW8bVP8rVc3Y4ZB
	Xq7yKraJVK52GQe62QOno2fVspVEE+bilKDBOLiegA8PvzgcNEHMzGLYkOXFlvbv/N+YRO
	yB3xbcmj0CzUE3jak6odqncMZ6TD+SY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-680-3kykvpSIMdOTVHek5dHrGQ-1; Thu,
 05 Mar 2026 10:06:40 -0500
X-MC-Unique: 3kykvpSIMdOTVHek5dHrGQ-1
X-Mimecast-MFC-AGG-ID: 3kykvpSIMdOTVHek5dHrGQ_1772723199
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5F5C61955F2D;
	Thu,  5 Mar 2026 15:06:38 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.115])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B36481956095;
	Thu,  5 Mar 2026 15:06:37 +0000 (UTC)
Date: Thu, 5 Mar 2026 10:06:35 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/5] iomap, xfs: lift zero range hole mapping flush
 into xfs
Message-ID: <aamb-zfiAd0xYqQP@bfoster>
References: <aY9hY7TwgMXJNzkI@bfoster>
 <aaXesgEmu46X7OwD@bfoster>
 <aabyFY0l7GTEHnoQ@infradead.org>
 <aacv39AZ5P9ubOZ5@bfoster>
 <aagv8y96vGHvbOdX@infradead.org>
 <aag-_c8G_L5MQ42m@bfoster>
 <aahEk4yNqd15BIt7@infradead.org>
 <aahJcVkrkLRtsJO9@bfoster>
 <aahmBCz1xJBCPcZ-@bfoster>
 <aamPDBAAuK8vvYDw@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aamPDBAAuK8vvYDw@infradead.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Thu, Mar 05, 2026 at 06:11:24AM -0800, Christoph Hellwig wrote:
> On Wed, Mar 04, 2026 at 12:04:04PM -0500, Brian Foster wrote:
> > This patch seems to work on a quick test. It's basically the two patches
> > squashed together (I'd post them as independent patches), so nothing too
> > different, but if we fix up the zero logic first that helps clean up the
> > indentation as a bonus.
> 
> Cool, thanks a lot for putting in this extra effort!
> 
> Cosmetic comment on the comment:
> 
> > +	/*
> > +	 * We don't allocate blocks for zeroing a hole, but we only report a
> > +	 * hole in zoned mode if one exists in both the COW and data forks.
> 
> I'd reword this a bit as:
> 
> 	/*
> 	 * When zeroing, don't allocate blocks for holes as they already
> 	 * zeroes, but we need to ensure that no extents exist in both
> 	 * the data and COW fork to ensure this really is a hole.
> > +	 *
> > +	 * There is currently a corner case where writeback removes the COW fork
> > +	 * mapping and unlocks the inode, leaving a transient state where a hole
> > +	 * exists in both forks until write completion maps blocks into the data
> > +	 * fork. Until we can avoid this transient hole state, detect and avoid
> > +	 * this with a flush of any such range that appears dirty in pagecache.
> > +	 */
> 
> 

Sure. I had reworked the latter part of the comment as well. With both
the changes it currently looks like:

        /*
         * When zeroing, don't allocate blocks for holes as they are already
         * zeroes, but we need to ensure that no extents exist in both the data
         * and COW fork to ensure this really is a hole.
         *
         * A window exists where we might observe a hole in both forks with
         * valid data in cache. Writeback removes the COW fork blocks on
         * submission but doesn't remap into the data fork until completion. If
         * the data fork was previously a hole, we'll fail to zero. Until we
         * find a way to avoid this transient state, check for dirty pagecache
         * and flush to wait on blocks to land in the data fork.
         */

Brian

