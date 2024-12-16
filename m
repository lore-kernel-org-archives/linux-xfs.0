Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851F4204C2C
	for <linux-xfs@vger.kernel.org>; Mon, 16 Dec 2024 13:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734355457; cv=none; b=mIEQoX5c8r4pcHlpiO0gMwq5LOSa62f257u7rWMD/apP3SAJNhXSO5JdqEi8sE0Bff+HxMLY8qTcT1o5BXgfjEriIC6+8PsjpdyhsqbMt7CFeq6ObBlDNAP1TpC83kJOH3g8IZVBW7UTS9Pbz3MXSVoXuJSRRzakQDmDYr/PlEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734355457; c=relaxed/simple;
	bh=o1KDuk5SDSf+nwrFSu95QN8aCPJkKiJ1/ZANj0uq4aw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s9TxfUteXRHu0b1fKZMn7J8DcTgStqr5g4bBJqbfPjXa0B6CVFpDj3w9WTbZ1qvhsL7egtGuG8pw6oE1J9mRXbpLrtFZDhjW5OWUKzc5P295Fe2tuWVbZFiXQZsabuHDGgc1zsJQQW1Vg+iOb7ZldpAKcyA6pIvRnWt4kfhw8/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XyqRQcxk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XyqRQcxk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734355454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UFbiGHJCTzjgfJE6LRZDtN+PEcYeeGB+Bku3450Xyzg=;
	b=XyqRQcxkD5jrNvuTwZja5Isu2H311ETuUwJuOsSS7AXjoAnr8a36PjKcHiOK88kCiy6ouu
	n/Ig+uy6+LvNzOddEack7IkBHCmZw0wxyMAlP/83Mx8R+m464+KfomAmRCqa7otDEc+gdJ
	wIajbhHf17Va1/yM7DlfQKNHfzNmZZM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-358-rbqd1cEBPoCWgveFeHbQ5g-1; Mon,
 16 Dec 2024 08:24:13 -0500
X-MC-Unique: rbqd1cEBPoCWgveFeHbQ5g-1
X-Mimecast-MFC-AGG-ID: rbqd1cEBPoCWgveFeHbQ5g
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B6A281955E92;
	Mon, 16 Dec 2024 13:24:11 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.41])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BF5A71956052;
	Mon, 16 Dec 2024 13:24:10 +0000 (UTC)
Date: Mon, 16 Dec 2024 08:25:57 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/21] xfs: create incore realtime group structures
Message-ID: <Z2AqZaGP587xtjWq@bfoster>
References: <173084396885.1871025.10467232711863188560.stgit@frogsfrogsfrogs>
 <173084396972.1871025.1072909621633581351.stgit@frogsfrogsfrogs>
 <Z1g0MxNmVKpFgXsU@bfoster>
 <Z1kMRAzsOla3QhNR@infradead.org>
 <Z1_K_Bo9lmhJez8R@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1_K_Bo9lmhJez8R@infradead.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Sun, Dec 15, 2024 at 10:38:52PM -0800, Christoph Hellwig wrote:
> On Tue, Dec 10, 2024 at 07:51:32PM -0800, Christoph Hellwig wrote:
> > So without CONFIG_XFS_RT we obviously should not update rgcounts,
> > but should also fail the mount earlier if there are RGs.  Turns out
> > that non-rtg file systems have a fake RTG if they have a rt subvolume,
> > and the count is always set to 1.  So yes, this should just return 0
> > and your fix is correct.
> 
> Are you going to send this fix formally?  Or should I?
> 
> 

I don't really have a patch to send. I was just trying to provide enough
debug analysis to hopefully be useful to somebody who knows this code
better than I do..

Brian

