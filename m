Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81301EA87
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 18:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718305128; cv=none; b=cv8yJilYIjcqZqw6PXQ+B7MCMZblWKYLGrkv4ZLtttrchxWTGQRFE//hozttneICWFimZKWv5pSV+P8jdbhBPc+NXLzmf4WitBWxCXv/xlM/oY2tEs9YBZv3rsGy2rADSVdTXWJ8+s0oXLI5ziHjZ3rnapcWZbTkPp0Ox9HVgno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718305128; c=relaxed/simple;
	bh=n1NXydYG96gaZWzfhmX5JTWlK0dvD5UBy1b7qwR83D4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UEfLwVOSTu8JfXNWWCduFCI+l8qC/S9+yUrG1OCsrrrESO4U3TOz7GobRBapJAgSsCa8ztrrHMmM08y57fFVC7fjRKI5iv0KLk2dY/EB7BzIjkfKOvKX72FSRzUqoZDKeUw0QSDq4zgWyLrG33EB01rHaPPP6yeKfzWvsAEorqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NXpNQC7n; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NXpNQC7n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718305126;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zfkWquWikMdmUEbJi+WoXoK8adVjJbhkm3l60MDa1Kk=;
	b=NXpNQC7nF4MN7geEH+Vk71T0BV9PHo3xzDZuFKcsDqM94lYEJyMfwtw/ua+BWlXEM9CCV2
	SDrA9W9TiU+7WeOO6nBAL71g5uaGXV/P8A6+v+lmK2u7XWLT5RMqQhsFxGNqjrMth0FxK9
	wdqHDBgg4IZu5Tl5D707pkvt9EDWeDI=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-546-mE47VRhiO_qFlaqbt8F1yA-1; Thu,
 13 Jun 2024 14:58:44 -0400
X-MC-Unique: mE47VRhiO_qFlaqbt8F1yA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 87B77195608F;
	Thu, 13 Jun 2024 18:58:43 +0000 (UTC)
Received: from redhat.com (unknown [10.22.34.24])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8B8191956050;
	Thu, 13 Jun 2024 18:58:42 +0000 (UTC)
Date: Thu, 13 Jun 2024 13:58:39 -0500
From: Bill O'Donnell <bodonnel@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, cmaiolino@redhat.com
Subject: Re: [PATCH 2/4] xfs_db: fix unitialized variable ifake->if_levels
Message-ID: <ZmtBXwlJ3VhJJttV@redhat.com>
References: <20240613181745.1052423-1-bodonnel@redhat.com>
 <20240613181745.1052423-3-bodonnel@redhat.com>
 <Zms8Q0TYysO2w39p@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zms8Q0TYysO2w39p@infradead.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Thu, Jun 13, 2024 at 11:36:51AM -0700, Christoph Hellwig wrote:
> On Thu, Jun 13, 2024 at 01:07:06PM -0500, Bill O'Donnell wrote:
> > Initialize if_levels to 0.
> > 
> > Coverity-id: 1596600, 1596597
> > 
> > Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
> > ---
> >  db/bmap_inflate.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/db/bmap_inflate.c b/db/bmap_inflate.c
> > index 33b0c954..8232f486 100644
> > --- a/db/bmap_inflate.c
> > +++ b/db/bmap_inflate.c
> > @@ -351,6 +351,7 @@ build_new_datafork(
> >  	/* Set up staging for the new bmbt */
> >  	ifake.if_fork = kmem_cache_zalloc(xfs_ifork_cache, 0);
> >  	ifake.if_fork_size = xfs_inode_fork_size(ip, XFS_DATA_FORK);
> > +	ifake.if_levels = 0;
> >  	bmap_cur = libxfs_bmbt_stage_cursor(ip->i_mount, ip, &ifake);
> >  
> >  	/*
> > @@ -404,6 +405,7 @@ estimate_size(
> >  
> >  	ifake.if_fork = kmem_cache_zalloc(xfs_ifork_cache, 0);
> >  	ifake.if_fork_size = xfs_inode_fork_size(ip, XFS_DATA_FORK);
> > +	ifake.if_levels = 0;
> 
> Maybe initialize it at declaration time by doing:
> 
> 	struct xbtree_ifakeroot		ifake = { };
> 
> to future-proof against adding more fields?
> 
Makes sense, I'll send a new version.
Thanks-
Bill

