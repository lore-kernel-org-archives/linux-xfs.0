Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8ED91F5FD
	for <linux-xfs@vger.kernel.org>; Sun, 18 Aug 2024 20:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724012192; cv=none; b=isOPOxLhHu+aRIw6OxRML/bqwEkDlxByH8FF29e1LZ5ffYaMhGOMd+0w0Ph4m1ZiSVOow+sFTqBBlJpXTh08sM5LXDCCCPz5fQ9puTJSGyrEaONWHlLlElc21J162h4i8NKDuYOaDM5w9NxX9cYwpYmKL7Q4fBmPv4w9Xt5URcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724012192; c=relaxed/simple;
	bh=TGUbjXVA9aSl50o7GSmUfIw+O8tTGf4xBLnLzbfqck8=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=NGypf693c4dxj5kuZf/GwD++SK6XzPYOnY60mZcMojtd1OjgKOs1BvTh2bG0cqIfdBT2ZPLyvlTTilvu8KSoetvhh/cmxnI5Lo5k9c40rJx2xeJq9G42IPUFh30UpPWioUGF16+nfpas11ulUH4P2sqNP4JCebZXZdX+8u2ztGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J9BHqRkB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J9BHqRkB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724012189;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9pnN2touy3okUISVQBvLtGnxKUZwMFoasBZg0jnjJZE=;
	b=J9BHqRkBWdHQo2p3TWcSa0anUdexT86xXE/DIA9ZTejKgnsk81VWvzUZXPhg+EolqPDsAl
	UNAtmio2nWOaD21GLK9rRy91285SMB6Aj3N4ew7atyLpB/kAGj0cGcN6pq5qoOsLqlD028
	P/ZAo0s50n0O4rFZeEE8j9DE2k2uYV4=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-398-9tKNDKzHPnWMT12Xkczofg-1; Sun,
 18 Aug 2024 16:16:28 -0400
X-MC-Unique: 9tKNDKzHPnWMT12Xkczofg-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4036219560B4;
	Sun, 18 Aug 2024 20:16:24 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.30])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 00B8C30001A4;
	Sun, 18 Aug 2024 20:16:17 +0000 (UTC)
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
Content-ID: <3141776.1724012176.1@warthog.procyon.org.uk>
Date: Sun, 18 Aug 2024 21:16:16 +0100
Message-ID: <3141777.1724012176@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Pankaj Raghav (Samsung) <kernel@pankajraghav.com> wrote:

> I am no expert in network filesystems but are you sure there are no
> PAGE_SIZE assumption when manipulating folios from the page cache in
> AFS?

Note that I've removed the knowledge of the pagecache from 9p, afs and cifs to
netfslib and intend to do the same to ceph.  The client filesystems just
provide read and write ops to netfslib and netfslib uses those to do ordinary
buffered I/O, unbuffered I/O (selectable by mount option on some filesystems)
and DIO.

That said, I'm not sure that I haven't made some PAGE_SIZE assumptions.  I
don't *think* I have since netfslib is fully multipage folio capable, but I
can't guarantee it.

Mostly this was just a note to you that there might be an issue with your code
- but I haven't investigated it yet and it could well be in my code.

Apparently, I also need to update xfstests, so it could be that too.

> > 	ls /afs/openafs.org/www/docs.openafs.org/
> > 
> > and browse the publicly accessible files under there.
> 
> Great. But is this enough to run FStests? I assume I also need some afs
> server to run the fstests?

Sadly not, but if you turn on some tracepoints, you can see netfslib operating
under the bonnet.

> Are the tests just failing or are you getting some kernel panic?

Just failing.

Thanks,
David

