Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1152114AD2D
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 15:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460315; cv=none; b=WoDZB8Slu6cLOrzqwv5muRfyGUeW8WP27wiXd1TCOEElf6cCDuCFkPRCEbojkIjeJbX6H9c2hln7ypSDFgWCMQFrGoNh9vbTRZOjCuhFijBQDLrOlPAURkcKkkhmzatExwL9DW4wQSkTaaP8IOZtW+9p6rbfPhsQJDyQofp2I28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460315; c=relaxed/simple;
	bh=qroDevgXEZz2C/CItepIJ5ZwJT4MGtAx+nNtt24ca3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X4H+8pwlJAzRmzP/yvYeSP8lTHeZmD8xA4BYwlzk4iOJ0TiBKvkGDhqqLqwBUxTcHCy3+Zne/9BMMykOty3hzW2I7PHuVgQ3OtXogmJJYCZo/fYWhAwBBA+0SXsEo4v+IJG9pzcioTR8vfS8b8ekE0hRfy/9a+Gk8+h0ZlMzSUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TXHznf9n; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TXHznf9n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739460313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=It7+x6W7wvGYoNCVJXcV6cFYTwCk46Qqe/wvmYHAHvA=;
	b=TXHznf9nEXIR6G7Xto/lND0NJETAT7dZrVOJcnEr4cPxpaGU6Am748J6Dcj68iuAeW2JOw
	oFqZGvc2B0xrnO7rNH86qkfn6BUw3JUq9iy8FXecC2bt9sj9boyLnlZ54MK4ahiHvK+g+1
	5ec0YsRmvy5d2tzMSMdCF+emM22M3OU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-638-hu7n3gJYMXiIvhb3yZWDGA-1; Thu,
 13 Feb 2025 10:25:09 -0500
X-MC-Unique: hu7n3gJYMXiIvhb3yZWDGA-1
X-Mimecast-MFC-AGG-ID: hu7n3gJYMXiIvhb3yZWDGA
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 91538180034A;
	Thu, 13 Feb 2025 15:25:07 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.88])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 84EB018004A7;
	Thu, 13 Feb 2025 15:25:06 +0000 (UTC)
Date: Thu, 13 Feb 2025 10:27:32 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH 05/10] dax: advance the iomap_iter on zero range
Message-ID: <Z64PZG8cc-iSijxu@bfoster>
References: <20250212135712.506987-1-bfoster@redhat.com>
 <20250212135712.506987-6-bfoster@redhat.com>
 <Z62XvvwsadBSXAaQ@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z62XvvwsadBSXAaQ@infradead.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Wed, Feb 12, 2025 at 10:57:02PM -0800, Christoph Hellwig wrote:
> On Wed, Feb 12, 2025 at 08:57:07AM -0500, Brian Foster wrote:
> > @@ -1372,33 +1371,35 @@ static s64 dax_zero_iter(struct iomap_iter *iter, bool *did_zero)
> >  	 */
> >  	if (iomap->flags & IOMAP_F_SHARED)
> >  		invalidate_inode_pages2_range(iter->inode->i_mapping,
> > -					      pos >> PAGE_SHIFT,
> > -					      (pos + length - 1) >> PAGE_SHIFT);
> > +					      iter->pos >> PAGE_SHIFT,
> > +					      (iter->pos + length - 1) >> PAGE_SHIFT);
> 
> Relaly long line here.  I think this would benefit from normal two
> tab argument continuation indentation (and a less stupid calling
> convention for invalidate_inode_pages2_range, but that's a different
> story).
> 

Yeah, I'll change it.

Brian

