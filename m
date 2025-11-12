Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2784232D44B
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 12:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762950672; cv=none; b=DQilHp9eEYfgwGNZ1zxU00bCnlvt5rfOey9d0M0TPpPwFB0o0tGvr11wG8WYsyR4f6rDD1hdE+37MOWR9YvfGUm1Ju/h+DuOHVlK0qRZikAWjbCLM8IGakEYLDHDFr6As8REyRugPtg398e2Y1Pq25WdlqA8YpCyBXbvhL44gQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762950672; c=relaxed/simple;
	bh=fBzCD+S/Q0bhMTu6DGyQLbBifn1yv9AM3vZyc2Ua55E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rkL0HuiHVgMVcTiJEXq9dBNMIxeqXMkMrKYXGpwRns9NsJbx8V4YYqAXnw/Gt1mAKuYnV2g9U+17W7uD2El/m4aIVKUOTIl5t+ixIHYJc1nusCSwR7M+h/y4HjJAhJMaz3w7fm04MhDTx6Jkl+Smo/5j0bW7Zr8kJfnacWblnmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DxyMBHOe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DxyMBHOe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762950667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D+pcmmtn0+D/t3JnLP0caZ+DUCoyUBZiXeEM0hM8S50=;
	b=DxyMBHOeh2v/8x8jfQx+wO/9uyVoALF2pVDQ02pmCtm2YlP+kvrWVoG3JMEaDDz2VPyd/B
	JSCqh8U9igEWVipGXlQkLAIdnfTnF93utpZ+3EpBcYfJlkhYc0F/smO9TIrGbZSgSWGNYD
	OiN/xPfljrf0NpjKCs40ZsTzFW84HzQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-353-AOA8VDqUOg6zl-GQbw-s0A-1; Wed,
 12 Nov 2025 07:31:04 -0500
X-MC-Unique: AOA8VDqUOg6zl-GQbw-s0A-1
X-Mimecast-MFC-AGG-ID: AOA8VDqUOg6zl-GQbw-s0A_1762950663
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C94B919560B6;
	Wed, 12 Nov 2025 12:31:02 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1109A1800451;
	Wed, 12 Nov 2025 12:31:01 +0000 (UTC)
Date: Wed, 12 Nov 2025 07:35:33 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] iomap: replace folio_batch allocation with stack
 allocation
Message-ID: <aRR_FdE96gzkskqP@bfoster>
References: <20251111175047.321869-1-bfoster@redhat.com>
 <aRRHzBlw6pc3cQjr@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRRHzBlw6pc3cQjr@infradead.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Wed, Nov 12, 2025 at 12:39:40AM -0800, Christoph Hellwig wrote:
> On Tue, Nov 11, 2025 at 12:50:47PM -0500, Brian Foster wrote:
> >  		if (imap.br_state == XFS_EXT_UNWRITTEN &&
> >  		    offset_fsb < eof_fsb) {
> > -			loff_t len = min(count,
> > -					 XFS_FSB_TO_B(mp, imap.br_blockcount));
> > +			loff_t foffset = offset, fend;
> >  
> > -			end = iomap_fill_dirty_folios(iter, offset, len);
> > +			fend = offset +
> > +			       min(count, XFS_FSB_TO_B(mp, imap.br_blockcount));
> > +			iomap_flags |= iomap_fill_dirty_folios(iter, &foffset,
> > +							       fend);
> >  			end_fsb = min_t(xfs_fileoff_t, end_fsb,
> > -					XFS_B_TO_FSB(mp, end));
> > +					XFS_B_TO_FSB(mp, foffset));
> 
> Maybe it's just me, but I found the old calling convention a lot more
> logic.  Why not keep it and extend it for passing the flags as an
> in/out argument?  That would also keep the churn down a bit.
> 

Hmm.. well I never really loved the flag return (or the end return), but
I wanted to make the iomap helper more consistent with the underlying
filemap helper because I think that reduces unnecessary complexity. I
suppose we could also make the flags an out param and either return void
or just pass through the filemap helper return (i.e. folio count)...

Brian

> Otherwise the change looks good.
> 

