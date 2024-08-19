Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA4116CD38
	for <linux-xfs@vger.kernel.org>; Mon, 19 Aug 2024 14:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724076509; cv=none; b=KVBAMrs+Tj1VQG07wJQnmSH+XfFI80p0j0WciJ9MLSBhr3+KpzoRHHf4+ewwCzKE5eZO1GfHnbtxQ1KWxzJ1obOtI6xo4vdGCYN6uQkoVgauV7eMsV8o58WsCzGZBFXp83nn/+jgOcu5KZt2VOX+f497uFN1xNMT8J6JtmTqA5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724076509; c=relaxed/simple;
	bh=bfUU3TjT0pGgF5mvvVDRDiP7W/MFzy2EcVVV0czuQz8=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=Ud4OTbvIaSIbUuM9R7YB5kobDf/4eUeJFCbZ9eoZCROHFlEUVODlYKGbc8eqj0PkGCURUzIOJsDNuCCuxIYL0AZL6+560BtfMcMbNN/Qi1bO0mNIkbcO5cUQCDZ8h13fcrT4boagMkOEmUDaJ+xXS5iHJNYgdAnD+PwILm6icnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wgs/PyKc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wgs/PyKc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724076507;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6XYur11TPtGEn1C9y/LldAZB5i+hKJ1iTdKnEq29u2s=;
	b=Wgs/PyKcpAIbee8ln6v36dyFjPKgLTTCpkYIa5zMcsvW+nwBDsVFE/M/y/+pOakj/nJlhn
	azu2CkWnneDiV1mvi8m0ITi2PrzvM14SP3NH1tTfYbsPC9jC/uOhSXVgJ6NKlAUMzBpERf
	7pAMf/sUO/jXhBeVeYkucWUY3HZvubA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-61-jHbrzhgdPny4TS4KDOGWhQ-1; Mon,
 19 Aug 2024 10:08:20 -0400
X-MC-Unique: jHbrzhgdPny4TS4KDOGWhQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D6B441954B14;
	Mon, 19 Aug 2024 14:08:16 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.30])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EBABC1955BF8;
	Mon, 19 Aug 2024 14:08:10 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <03ae65df-a369-436d-b31c-b3cec6ca3bc1@suse.de>
References: <03ae65df-a369-436d-b31c-b3cec6ca3bc1@suse.de> <20240818165124.7jrop5sgtv5pjd3g@quentin> <20240815090849.972355-1-kernel@pankajraghav.com> <2924797.1723836663@warthog.procyon.org.uk> <3402933.1724068015@warthog.procyon.org.uk>
To: Hannes Reinecke <hare@suse.de>
Cc: dhowells@redhat.com,
    "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
    brauner@kernel.org, akpm@linux-foundation.org,
    chandan.babu@oracle.com, linux-fsdevel@vger.kernel.org,
    djwong@kernel.org, gost.dev@samsung.com, linux-xfs@vger.kernel.org,
    hch@lst.de, david@fromorbit.com, Zi Yan <ziy@nvidia.com>,
    yang@os.amperecomputing.com, linux-kernel@vger.kernel.org,
    linux-mm@kvack.org, willy@infradead.org, john.g.garry@oracle.com,
    cl@os.amperecomputing.com, p.raghav@samsung.com, mcgrof@kernel.org,
    ryan.roberts@arm.com
Subject: Re: [PATCH v12 00/10] enable bs > ps in XFS
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3427741.1724076489.1@warthog.procyon.org.uk>
Date: Mon, 19 Aug 2024 15:08:09 +0100
Message-ID: <3427742.1724076489@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Hannes Reinecke <hare@suse.de> wrote:

> Wouldn't the second truncate end up with a 4k file, and not an 8k?
> IE the resulting file will be:
> After step 1: 8k
> After step 2: 4
> After step 3: 4k

Yes, but the folio should still be an 8K folio, and it is:

>   pankaj-5833: netfs_folio: pfn=116fec i=0009e ix=00000-00001 inval-part

as indicated by the inclusive folio index range ix=00000-00001.

The problem is that the bottom four bytes of the file are getting cleared
somewhere.  They *should* be "XXXX", but they're all zeros.

David

