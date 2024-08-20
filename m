Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D217B18B474
	for <linux-xfs@vger.kernel.org>; Tue, 20 Aug 2024 23:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724196282; cv=none; b=paTfzkJz59z+i25vOAPQvTXin061XUqev4lCGr3Y2XhuMAe2MDKoc23AIYOTW9/iMzp0B2dXSH2aqa0akZKDzJ/nyxzGK+BTZq4LcljfnEbdFDlRx+2X9hevKpeJ+RfFEJLR1kgmwZoyBuw0YOswNHBxOpA2csD9kFTIalq+pjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724196282; c=relaxed/simple;
	bh=ktj3J694UJT11cdVq07iovQ6VNYIzh45Q7Ed964y7SU=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=BevgmETTmeh8d5ritm+UKnCPMmpXwRpbYjFos31NKE/iTkBo2ZvG8D9QPSJzRQpw8N5bg2yLXB2Oi8Wir/hXGjd7h36eQX9utUTZQ5X6mwziZS3YsZ6u6FT2z9MH0t0WvSBm8tjfGII+dwUuS7Sia+jC3yrWrvxvLV4JZODzP18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gyJ36ngD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gyJ36ngD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724196279;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4wTO3rn8cai9pfp8/7PSJNm83ubFTKdJd8PEervFV6A=;
	b=gyJ36ngD9QiLbvdyDKvQWjYH3AUBeFiS2/bd2PMHLvJEG8I/kUNl8Pj3RJTnvhuFfYBXmO
	JFFhUBHtcrkL9s6YKJTKPPtBf/lGMFUcyPrtLPzKOhLSpa+JxqQ0IBCK3bOYddqfJeGtIM
	euMNaOLpbGH67uR8b/isC00mUG6bGsM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-612-V0HWiyhqP0C_oN7kg_4XJA-1; Tue,
 20 Aug 2024 19:24:34 -0400
X-MC-Unique: V0HWiyhqP0C_oN7kg_4XJA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 76A721955D47;
	Tue, 20 Aug 2024 23:24:31 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.30])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AA4AC19560AA;
	Tue, 20 Aug 2024 23:24:25 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20240818165124.7jrop5sgtv5pjd3g@quentin>
References: <20240818165124.7jrop5sgtv5pjd3g@quentin> <20240815090849.972355-1-kernel@pankajraghav.com> <2924797.1723836663@warthog.procyon.org.uk>
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: dhowells@redhat.com, brauner@kernel.org, akpm@linux-foundation.org,
    chandan.babu@oracle.com, linux-fsdevel@vger.kernel.org,
    djwong@kernel.org, hare@suse.de, gost.dev@samsung.com,
    linux-xfs@vger.kernel.org, hch@lst.de, david@fromorbit.com,
    Zi Yan <ziy@nvidia.com>, yang@os.amperecomputing.com,
    linux-kernel@vger.kernel.org, linux-mm@kvack.org,
    willy@infradead.org, john.g.garry@oracle.com,
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
Content-ID: <3792764.1724196264.1@warthog.procyon.org.uk>
Date: Wed, 21 Aug 2024 00:24:24 +0100
Message-ID: <3792765.1724196264@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Okay, I think I've found the bugs in my code and in truncate.  It appears
they're affected by your code, but exist upstream.  You can add:

	Tested-by: David Howells <dhowells@redhat.com>

to patches 1-5 if you wish.

David

