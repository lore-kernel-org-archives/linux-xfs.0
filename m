Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B89D214213
	for <linux-xfs@vger.kernel.org>; Fri, 10 Jan 2025 17:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736531357; cv=none; b=WXfBMojK6RJpBRTeiBdeLn9pi7HxfUpC82J+wMloFbskg5oYam2aKjFdjfs2CTjVWXJ2QAJaMDBbYllYxLkx1xI2+ZYqhAoP4mBDyRusRQbTjS3IS5IQFkD78A4ZjLxMh4jLgCwlgEumaDFdPlOVpYXuL0DUPrv7nFZHUo7K4hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736531357; c=relaxed/simple;
	bh=clUVcotYiys8hPm6lsgfnK6ugzToYmep5mt13KXfGEc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hVfparr0hRYp0rKpReelKW7879mkpJHZj3FqbrxZeDWr+It/u6ZCI62KJavdRr8P5zgBG9qZAkVON6I79S4RPeQTcniWueO6DTraLTbhI/RKrFx26Vt0qBGu1ayuU2qHrafCL/XltS8x5dkQ0umoeqYFvwWryayYDT7fA/GkhPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HxJ7z98K; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HxJ7z98K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736531353;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AmTC5bacod4P1SYPlw6KCII1FFu38/8xcWMX5LBYrV4=;
	b=HxJ7z98KiS36fCAA2A7fEpFrSUQhHDRN2yj5c74o3Gn2M1afAS9q/DD/MucOVNcHqglmbO
	pLEH1OlxsVq8JD9YSxM8t8ORcEOLmW7gNp+vgRAnW3glIwJHWOBFUuIZNChEc8KhVoOIrf
	SAJS8tZ/4NBezLSSCGOu3tnABHxaHb0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-635-DQ8CyvQ2N2CYSGP_0zJ2LQ-1; Fri,
 10 Jan 2025 12:49:10 -0500
X-MC-Unique: DQ8CyvQ2N2CYSGP_0zJ2LQ-1
X-Mimecast-MFC-AGG-ID: DQ8CyvQ2N2CYSGP_0zJ2LQ
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C3C5419560BB;
	Fri, 10 Jan 2025 17:49:09 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.122])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 09A2219560AB;
	Fri, 10 Jan 2025 17:49:08 +0000 (UTC)
Date: Fri, 10 Jan 2025 12:51:15 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] iomap: advance the iter directly on buffered writes
Message-ID: <Z4FeE4F4Hp_PznnV@bfoster>
References: <20241213143610.1002526-1-bfoster@redhat.com>
 <20241213143610.1002526-5-bfoster@redhat.com>
 <Z392eER1_ceFfMJe@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z392eER1_ceFfMJe@infradead.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Wed, Jan 08, 2025 at 11:10:48PM -0800, Christoph Hellwig wrote:
> On Fri, Dec 13, 2024 at 09:36:08AM -0500, Brian Foster wrote:
> > +		loff_t pos = iter->pos;
> > +		loff_t length = iomap_length(iter);
> 
> AFAICS we could just do away with these local variables as they should
> never get out of sync with the values in the iter.  If so I'd love to see
> that one.  If they can get out of sync and we actually need them, that
> would warrant a comment.
> 
> Otherwise this looks good to me, and the same applies to the next two
> patches.
> 

Hmm.. they should not get out of sync, but that wasn't necessarily the
point here. For one, this is trying to be incremental and highlight the
actual logic changes, but also I didn't want to just go and replace
every usage of pos with iter->pos when it only needs to be read at a
certain point.

This might be a little more clear after the (non-squashed) fbatch
patches which move where pos is sampled (to handle that it can change at
that point) and drop some of the pos function params, but if we still
want to clean that up at the end I'd rather do it as a standalone patch
at that point.

All that said, length is only used for the bytes check so I can probably
kill that one off here.

Brian

