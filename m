Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CF01E47A8
	for <linux-xfs@vger.kernel.org>; Mon, 14 Jul 2025 13:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752500344; cv=none; b=PuiSmVHZ8xcmADYDby0R7tVa9Pz41P3p8ZdlxOVfW8bCgVPwSy1mNiyK4ugGXxkPguJRmKAQqEeVRsdmC5kWe+F1KEzlL2j7ZqyAP9BAJusvAKlG3RaOEi14WFX5Mssxh/bC/t+CmRKIoBl0mwfVdEoKq8THl+pvN5Reieodf28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752500344; c=relaxed/simple;
	bh=uqVM8DCOecLRMSWwfCMP4U2syF28xrRLCFZtT0XQEeA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R+6Egn1UsnmxCnb9RdLQs4HoHOrpxzx6XdSs7o2+e1rW05P1zTbnRtIb4dcnFEcVfLC2VGNK5KlKA7v0enq+QP/3+OUnPdaE/MxuPwoOv3oPbdkXk1FfR+iL+6PDjqPLYhdFKgidbb71WLiC947Fng35XL7hqia2hVnM5tWJzA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QN/SJBBi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QN/SJBBi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752500341;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=78ELezR9/WM68ny3VH62OCs9mnwuCAXrTRQ3vgvPl24=;
	b=QN/SJBBiS3ySJOm2B1WynOORxX8aCv+N9WZXlnlG2W07+Jz0MlNPPTs7fJgn43bc9r5Jjc
	LpwVWTJ9elaZmc6EzYzIquKNSGY1+FUSCqyw+Vqlm6lSxbSKQfo8d5D2oqFejGWuSjayDd
	3yTFzzysg0L1M2DnrpuPH6XoumauuL8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-203-eTBeY3LjNmy-M3LcqYZQdw-1; Mon,
 14 Jul 2025 09:39:00 -0400
X-MC-Unique: eTBeY3LjNmy-M3LcqYZQdw-1
X-Mimecast-MFC-AGG-ID: eTBeY3LjNmy-M3LcqYZQdw_1752500337
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C03471955F41;
	Mon, 14 Jul 2025 13:38:57 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.43])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8CD3A180045B;
	Mon, 14 Jul 2025 13:38:56 +0000 (UTC)
Date: Mon, 14 Jul 2025 09:42:38 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, djwong@kernel.org, willy@infradead.org
Subject: Re: [PATCH v2 7/7] xfs: error tag to force zeroing on debug kernels
Message-ID: <aHUJToKyf6cq4T2f@bfoster>
References: <20250714132059.288129-1-bfoster@redhat.com>
 <20250714132059.288129-8-bfoster@redhat.com>
 <aHUEtVJK6PPepNde@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aHUEtVJK6PPepNde@infradead.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Mon, Jul 14, 2025 at 06:23:01AM -0700, Christoph Hellwig wrote:
> On Mon, Jul 14, 2025 at 09:20:59AM -0400, Brian Foster wrote:
> > -	error = xfs_free_file_space(XFS_I(inode), offset, len, ac);
> > -	if (error)
> > -		return error;
> > +	/* randomly force zeroing to exercise zero range */
> 
> This comment feels very sparse for this somewhat confusing behavior.
> Can you add a shortened version of the commit message here explaining
> why this is useful?
> 

Sure, will fix.

Brian

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

