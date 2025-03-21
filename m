Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074371E51FF
	for <linux-xfs@vger.kernel.org>; Fri, 21 Mar 2025 21:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742594261; cv=none; b=fuIBMOTfv5Kxh0ucH2rLRkhln+iRnGaYA9ATn5AaNgGrh2AMfRizUjhjvlea9U4L+i87QYQ6hmTSRBehmaYPZX+cm6zREFv+z8pB7+JM+28XhnZHi38294NhGhRKCnXr7zHLBrqOruJPPGJ0XkTwm2hehSZkHyHJuXZN6ly5YGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742594261; c=relaxed/simple;
	bh=B7awNUWkEbuvRhZXqgJhir4oYJSkgENTSghEvbQgQkE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c3kwBGjT37chw2GUoz58gGYtFS3GWFaqz8HJC77HNMK98UtVhmbQ36TV0Oi9N0s/3YjcivpsnRYwpy+Q9XA0Ntud6yclLaAunwmfIpyDZFGerLWEA9ck3fvuKqSP3uTNSOVVUaFPsTqgmCtm5FKfcrKb7dzzWbuO9PZLThaammk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=enNFqys6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="enNFqys6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742594258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/KcOwbkEShIi5owNAoz7926k0/CQp2on+3xebzAo/2g=;
	b=enNFqys6HRY7QAgk5J5xB42zDWs/4vyQse36yU+JomOGzzpHq7bZissMykGweF3omwkeUf
	/7PPiHBuqwmr9oAuxiBgFQjIUxEeJ/8aIegYcJFRFK6mFcZsVNMxKti+VzEvs108HQBGBf
	sxejGyaAXpumtAy8DOts8pqsZ5RRxRE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-308-aV6-m5Y6MVSvlpcq-vWhsA-1; Fri,
 21 Mar 2025 17:57:33 -0400
X-MC-Unique: aV6-m5Y6MVSvlpcq-vWhsA-1
X-Mimecast-MFC-AGG-ID: aV6-m5Y6MVSvlpcq-vWhsA_1742594252
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 31DB31800349;
	Fri, 21 Mar 2025 21:57:32 +0000 (UTC)
Received: from redhat.com (unknown [10.22.65.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BB1EC195609D;
	Fri, 21 Mar 2025 21:57:30 +0000 (UTC)
Date: Fri, 21 Mar 2025 16:57:28 -0500
From: Bill O'Donnell <bodonnel@redhat.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, hch@infradead.org
Subject: Re: [PATCH v2] xfs_repair: handling a block with bad crc, bad uuid,
 and bad magic number needs fixing
Message-ID: <d42e43awslatpfwhr4sgry6ymbcf4v5mcyo7i7dwrv44f36t2l@brvxfrf4kh3y>
References: <20250321142848.676719-2-bodonnel@redhat.com>
 <01ac135a-356f-4590-8a57-58ccae374db5@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01ac135a-356f-4590-8a57-58ccae374db5@sandeen.net>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Fri, Mar 21, 2025 at 03:49:59PM -0500, Eric Sandeen wrote:
> On 3/21/25 9:28 AM, bodonnel@redhat.com wrote:
> > From: Bill O'Donnell <bodonnel@redhat.com>
> > 
> > In certain cases, if a block is so messed up that crc, uuid and magic
> > number are all bad, we need to not only detect in phase3 but fix it
> > properly in phase6. In the current code, the mechanism doesn't work
> > in that it only pays attention to one of the parameters.
> > 
> > Note: in this case, the nlink inode link count drops to 1, but
> > re-running xfs_repair fixes it back to 2. This is a side effect that
> > should probably be handled in update_inode_nlinks() with separate patch.
> > Regardless, running xfs_repair twice fixes the issue. Also, this patch
> > fixes the issue with v5, but not v4 xfs.
> 
> Nitpick: IIRC V4 filesystems do not have UUIDs in metadata blocks,
> so I think this problem is unique to corrupted V5 filesystems.

Right. I'll send a patch version 3, just to clarify the message.

Thanks!
-Bill


> 
> -Eric
> 

