Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CBF23ED7B
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 14:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736778212; cv=none; b=WKcKsbLMvXVTWthAcGBIxWcW/hsh63BkDg3OKa5PdA7/TdWmk7S7+uOX6YnnkjWdO901Cq98GqIRjY3TPy2zKQ/1U5u1hl41EIw/k30iyHIy66ClnFJEURxeDhX2UqjR0GB/5SP8ucew9p1tSY2hzMm2kWTFy9Hbd3yQyr6bNAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736778212; c=relaxed/simple;
	bh=ZiVkU3ieMxuFoPQqlEuab44LJ+CLdRjJ9y/dJVzcfg4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H23bN+OXK9rWCSl74qlGDED/hjOy3L+F62wv5x4sbH5omi1wZzmpOmjU/6jiIry+JTv0x0pMMcYyHuq0U6Dy7pKkDB8Ta8DgVsJhdrqWSi7F4d5B+OYkmIpD6uOtNFCgQHNM35g8VgRtfJh9QVzPzV272CSm1CaQkKnjNyaXQ1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iZX3y65u; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iZX3y65u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736778210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J4oAaAjM2XjU/h2onTlrQ9TCcfAUUmAcwGjULRZ2X4Y=;
	b=iZX3y65ujmq6cb5FJhORwVe+2YpH/3DM4rgDjB6zXZTgeGtmBK3STYf6Kn3Wsaoa2Ofa+1
	Ja17+KKHlXmEKLEI2Hxu4SU9UutHFmSowRjXDa+YZMATgTsuelLvFmnDambKdftoSz7BVk
	hoP4vG06IMpuOwm8L1QK7GSEcdXwCSU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-604-bPgOs30VNOeDbU1HokFlNA-1; Mon,
 13 Jan 2025 09:23:28 -0500
X-MC-Unique: bPgOs30VNOeDbU1HokFlNA-1
X-Mimecast-MFC-AGG-ID: bPgOs30VNOeDbU1HokFlNA
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7489F1956080;
	Mon, 13 Jan 2025 14:23:27 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.118])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AFEB23003FD1;
	Mon, 13 Jan 2025 14:23:26 +0000 (UTC)
Date: Mon, 13 Jan 2025 09:25:38 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] iomap: support incremental iomap_iter advances
Message-ID: <Z4UiYikZaxqBOp-c@bfoster>
References: <20241213143610.1002526-1-bfoster@redhat.com>
 <20241213143610.1002526-4-bfoster@redhat.com>
 <Z391qhtj_c56nfc2@infradead.org>
 <Z4Fd4tUp1hFmGB2G@bfoster>
 <Z4SbLBtacHgN3qd-@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z4SbLBtacHgN3qd-@infradead.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Sun, Jan 12, 2025 at 08:48:44PM -0800, Christoph Hellwig wrote:
> On Fri, Jan 10, 2025 at 12:50:26PM -0500, Brian Foster wrote:
> > Yeah, I agree this is a wart. Another option I thought about was
> > creating a new flag to declare which iteration mode a particular
> > operation uses, if for nothing else but to improve clarity.
> 
> I actually really like the model where the processing loop always
> advances.  It'll make a few things I have on my mind much easier.
> 
> That doesn't mean I want to force you to go all the way for the initial
> patch series, but I'd love to see a full switchover, and preferably
> without a too long window of having both.
> 

Ok, thanks. I'm on board with that, just need to dig back into it to be
certain of details or roadblocks..

Another thing that crossed my mind is that it might be preferable to
convert across at least one release cycle regardless, just from a risk
management standpoint. I.e., introduce for zero range in one release,
let the test robots and whatnot come at me with whatever issues that
might exist, and then follow up with broader changes from there. But
anyways, one thing at a time..

Brian

> > reason.. would we think this is a worthwhile iteration cleanup on its
> > own?
> 
> Yes.
> 

