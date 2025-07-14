Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024DA248866
	for <linux-xfs@vger.kernel.org>; Mon, 14 Jul 2025 13:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752500345; cv=none; b=UGefHDLHfvBA69Ek68RlbkcHosIuyeFNef91osXV2ftsqK3kCxxa+hN4T/GhR/MmgQLwMPfhUc+R9/aDm126tjVP0m6Nh7LSef6DpeyXSA/XRUpwAiNuGArm4zmyrG3rvUiM5MK8h6r9a4Y7Dnc0vO7IJ7Yj44Qeg+2eAJKIVfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752500345; c=relaxed/simple;
	bh=oYKXk4nbBnL/ucMHWoLTvCYOT04ehTMMnlTfjgEHc0I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bHQgNTujz4zBHg/Do0F2G9ZKWb1GkKRlr3uTAXC/U6jboBcmvpyb0Lj0p7KRSopQ2nv3hh/+9HFhXem/+A2AOOLSyrlG3D8yfLRsIFEP1im0WryUDNu75VDvFcf0WVHUwUZbG7tVejZ03OsoO/Htn2/2vPXGmAl88bVHc4GUx0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TE6yn6dr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TE6yn6dr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752500343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4Uhi1uFmJKyPqz0Sbh3TdHMzQjP8yWANmP/X7v+lUCQ=;
	b=TE6yn6dr64Xp7JX6aB6Z7EtrZZPehGv1DVhyOpx/0OJkswNRgDRGQoiInBzRbKrGcr6pQe
	4v3M1zUecqZEhg0IMUm+cumnHowdsl4injVwIcWAYvVu16sudbPUgj+KABetahcRlDG/Hf
	6MZqVsUpqJhkUOjdDjQf5xyWNK/KNrc=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-311-b0nWq0qONmarVTdsqbi0Vw-1; Mon,
 14 Jul 2025 09:38:54 -0400
X-MC-Unique: b0nWq0qONmarVTdsqbi0Vw-1
X-Mimecast-MFC-AGG-ID: b0nWq0qONmarVTdsqbi0Vw_1752500330
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4489519560B3;
	Mon, 14 Jul 2025 13:38:50 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.43])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1006630001A1;
	Mon, 14 Jul 2025 13:38:48 +0000 (UTC)
Date: Mon, 14 Jul 2025 09:42:30 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, djwong@kernel.org, willy@infradead.org
Subject: Re: [PATCH v2 2/7] iomap: move pos+len BUG_ON() to after folio lookup
Message-ID: <aHUJRjkNPf_o3DzM@bfoster>
References: <20250714132059.288129-1-bfoster@redhat.com>
 <20250714132059.288129-3-bfoster@redhat.com>
 <aHUECH7KsHYBs0Re@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aHUECH7KsHYBs0Re@infradead.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Mon, Jul 14, 2025 at 06:20:08AM -0700, Christoph Hellwig wrote:
> On Mon, Jul 14, 2025 at 09:20:54AM -0400, Brian Foster wrote:
> > The bug checks at the top of iomap_write_begin() assume the pos/len
> > reflect exactly the next range to process. This may no longer be the
> > case once the get folio path is able to process a folio batch from
> > the filesystem. Move the check a bit further down after the folio
> > lookup and range trim to verify everything lines up with the current
> > iomap.
> 
> The subject line is wrong now that the checks are removed entirely.
> 

Er yeah, I have to update the commit log description too.

Brian

> The patch itself looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

