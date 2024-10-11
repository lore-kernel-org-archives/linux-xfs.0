Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E9D4431
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 14:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728655465; cv=none; b=UxCTcBHxMuOYcLwmIssJWhlQskMzj3oDkc+rMGHoF6diMl47BNdCiLeS5RDCxK+Zz+6x7DQkKhwSrPyHX/EbaBZ3jgu9ue0IIrtC3sDHAAGsvNycQjmBb6TzjFAjBEJOmk7DcIaQ6qyGq9MySdtW5oKZAgh2L8G+HlfXDQ5hmks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728655465; c=relaxed/simple;
	bh=Lq4Y8undbJEJp/AjMGnPLFMSbix3IfAis2hjI9pLxzw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BIopibx0gUUIMoC8tCYDhx8qVTL3/cA6SSNlFSclSpudw0EDyCDqW5RJBcUrKal5e4MAUBdQuGJzrzbtoF3W45of0tfZxW/+9/M002mswBMzIm5nXVGO0xoHEUcmtbaDXTQ4s54EwpnAyvFwmu1N7rRjl4gS/5UtYGsDmkFDbdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ILnvlSKI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ILnvlSKI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728655462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DRhRLpLKnYefoFaSDIxlE5yBFF4Hm/YYCFm64lls878=;
	b=ILnvlSKIYjEcgdC2z10rJqdeiJnRl5naFm7Z/p2ijV7XZpxDlToNbIbpb5vpMQeJ79vh6k
	dsNp4JDCXNrTLEqr+ny3Ex9mQ39vSpSKda+8lms9nNt3miwN/HWXzFRRVV1V/qOo07dj4p
	jq7H4jxnR+CKiJyrprGN62xe/UxDI7E=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-66-FHunU9kQMNGWthw0_pQRjg-1; Fri,
 11 Oct 2024 10:04:19 -0400
X-MC-Unique: FHunU9kQMNGWthw0_pQRjg-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 469CF19560AD;
	Fri, 11 Oct 2024 14:04:18 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.133])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 52B8D1955F42;
	Fri, 11 Oct 2024 14:04:17 +0000 (UTC)
Date: Fri, 11 Oct 2024 10:05:33 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: split xfs_trans_mod_sb
Message-ID: <ZwkwrTajIqYz2Ykw@bfoster>
References: <20240930164211.2357358-1-hch@lst.de>
 <20240930164211.2357358-8-hch@lst.de>
 <ZwffV8BDDJjr5xvV@bfoster>
 <20241011075408.GB2749@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241011075408.GB2749@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Fri, Oct 11, 2024 at 09:54:08AM +0200, Christoph Hellwig wrote:
> On Thu, Oct 10, 2024 at 10:06:15AM -0400, Brian Foster wrote:
> > Seems Ok, but not sure I see the point personally. Rather than a single
> > helper with flags, we have multiple helpers, some of which still mix
> > deltas via an incrementally harder to read boolean param. This seems
> > sort of arbitrary to me. Is this to support some future work?
> 
> I just find these multiplexers that have no common logic very confusing.
> 
> And yes, I also have some changes to share more logic between the
> delalloc vs non-delalloc block accounting.
> 

I'm not sure what you mean by no common logic. The original
trans_mod_sb() is basically a big switch statement for modifying the
appropriate transaction delta associated with a superblock field. That
seems logical to me.

Just to be clear, I don't really feel strongly about this one way or the
other. I don't object and I don't think it makes anything worse, and
it's less of a change if half this stuff goes away anyways by changing
how the sb is logged. But I also think sometimes code seems more clear
moreso because we go through the process of refactoring it (i.e.
familiarity bias) over what the code ultimately looks like.

*shrug* This is all subjective, I'm sure there are other opinions.

Brian

