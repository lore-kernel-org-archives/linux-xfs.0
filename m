Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CB72EC0B5
	for <linux-xfs@vger.kernel.org>; Thu,  8 Jan 2026 19:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767901254; cv=none; b=AqgvHDTkJnuAgnW82q7neeysh7dhBfmixloSkzQi7ke1cpvpzB94+2Bj0L3yg+/8/taamiIGfOpVFi0iVD4oiMAVudgFtFlEZM3FLFQy++z3EHDh2dg8UEog/QGncw2LNMKrXK65ki0p4omCakrRBvVf5NSP6F9uxbtbv9HhIaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767901254; c=relaxed/simple;
	bh=/tW1n/AXS7MiZXEw3xOd44lafimLB8iubpmO20kH+0U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SgkVDarrk+Yq5mP+8GHmUuFhCWE+h79PE6db+BJV1vkd+f6D7P2OUKQDHsCJfatUAyC+8EmXln1Ihx/ZOZwYDstGfy4S6BMaAmR3fsVSs3tVsrgVDXT0jAW8/DZtVuLdaV/y+Fo4ewS22j+kGULFj0FMnDIy5kx5v9KAg+qTYa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VmBAyWzQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VmBAyWzQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767901251;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NUFzp0JP2Hqvh8hDHztRsCRdXcYC07dwpyc3hD4Gztw=;
	b=VmBAyWzQAKx6S2U4ZPTa5m5zoa5H8RuMuYEAjTIRQJlCMAdXEWdODuXMHvtorb0MNAt3kL
	2QICtBALNkzFouQg69AssxZCRKqR0Q6G4RYC5V0VLGL/SDNVvg+52w975D3iNL3gFlmvoy
	pUTrC/yVZxh2eTgqY/0j2RYyLRAnsqc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-134-R62I53pgO5yPgJ3ExGfmbA-1; Thu,
 08 Jan 2026 14:40:50 -0500
X-MC-Unique: R62I53pgO5yPgJ3ExGfmbA-1
X-Mimecast-MFC-AGG-ID: R62I53pgO5yPgJ3ExGfmbA_1767901249
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 28A4E19560B5;
	Thu,  8 Jan 2026 19:40:49 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.127])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9CF3219560A2;
	Thu,  8 Jan 2026 19:40:48 +0000 (UTC)
Date: Thu, 8 Jan 2026 14:40:46 -0500
From: Brian Foster <bfoster@redhat.com>
To: Mark Tinguely <mark.tinguely@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [External] : [PATCH] xfs: set max_agbno to allow sparse alloc of
 last full inode chunk
Message-ID: <aWAIPub1XzMHXOY7@bfoster>
References: <20260108141129.7765-1-bfoster@redhat.com>
 <32881f8f-3b68-49c3-95b0-b1889c08d281@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32881f8f-3b68-49c3-95b0-b1889c08d281@oracle.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Adding linux-xfs back to cc.

On Thu, Jan 08, 2026 at 12:37:46PM -0600, Mark Tinguely wrote:
> On 1/8/26 8:11 AM, Brian Foster wrote:
> > Sparse inode cluster allocation sets min/max agbno values to avoid
> > allocating an inode cluster that might map to an invalid inode
> > chunk. For example, we can't have an inode record mapped to agbno 0
> > or that extends past the end of a runt AG of misaligned size.
> > 
> > The initial calculation of max_agbno is unnecessarily conservative,
> > however. This has triggered a corner case allocation failure where a
> > small runt AG (i.e. 2063 blocks) is mostly full save for an extent
> > to the EOFS boundary: [2050,13]. max_agbno is set to 2048 in this
> > case, which happens to be the offset of the last possible valid
> > inode chunk in the AG. In practice, we should be able to allocate
> > the 4-block cluster at agbno 2052 to map to the parent inode record
> > at agbno 2048, but the max_agbno value precludes it.
> > 
> 
> With the same logic, wouldn't the 4 block cluster at agbno 2056 also
> be a valid sparse inode cluster?
> 

Nope.. the problem there is that 4 block cluster would map to an inode
record at the same agbno 2056, but that record in the inobt would be
invalid because there are only 7 blocks before the end of the 2063 block
runt AG (full inode records are 8 blocks in this example). So IIRC the
metadata verifiers will complain about this and consider it corruption
and whatnot.

That was actually the issue fixed by Dave's more recent commit
13325333582d ("xfs: fix sparse inode limits on runt AG") in this same
area. The subtlety here is that the calculation was off in this regard
from the start, but it never mattered as such because it wasn't
effective in this small runt AG case in the first place. So that fix
made the min/max agbno bounding logic effective, and with that in place
this fell out more recently pointing out that the original calculation
was a bit too conservative.

Brian

> thanks,
> 
> Mark.
> 

