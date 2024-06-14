Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F8F4962D
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 15:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718378425; cv=none; b=avde3Q7WHNZHSXh9dB9+zIpiX5NUN/h/E9joGq/6845FWoWEpyxRJ5q+U4Lqegvcp5D7lhI0n8JrzulPYnOf4wsc7IRi9pCSrRrONEe1nOVtnFwJQjkFZnjVUAW4aEc21AG2p6VNhuYX28W4myLGGXoXsoyd9E1luOsQ2ft7fkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718378425; c=relaxed/simple;
	bh=5hTEftEierEaVOMxkXS3YODAbZJ/CNliE01jMiVCMfw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ecxnxM9nl9OZk9ElZSVyNSMy07JBBHNqstlTHBIZwv+ZdIVt0o25EUrBd/BWiuqlJkyZ12FO7e2wqD021/vxitNGugXmWsO3h7xc+Gbv13bKK9qdpv27NtE9W7SQ15etyzKinyRAHOCoT1cyXG0Dc+R8FO1ydGGmzHKPZwGT36E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EhSQCl4y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EhSQCl4y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718378422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qvMkXCqpTzC37v42kF0eHiY4ABZMwvFr45Bz3uYKiqA=;
	b=EhSQCl4yYqAe10j8Hwg4XS1T145zDMHu0Dymx8o94hjySLPfoSXkKHIN3d44Yt5SYsaF1n
	++zWJAFj4yX4UtyTGy8YkdGM/uKfsTvR9fkJzy7tNpeRboeX+oFC1/OJWsCz20E8fNVmnx
	Ae1SgHW7V5HZ16NXa46/89Sr5JSXJ/4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-622-DbK6rL76Oneqpc3oZ6ivPg-1; Fri,
 14 Jun 2024 11:20:19 -0400
X-MC-Unique: DbK6rL76Oneqpc3oZ6ivPg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A0F7619560BE;
	Fri, 14 Jun 2024 15:20:18 +0000 (UTC)
Received: from redhat.com (unknown [10.22.34.24])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 81CDE19560AA;
	Fri, 14 Jun 2024 15:20:17 +0000 (UTC)
Date: Fri, 14 Jun 2024 10:20:14 -0500
From: Bill O'Donnell <bodonnel@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, cmaiolino@redhat.com
Subject: Re: [PATCH v2 3/4] xfs_fsr: correct type in fsrprintf() call
Message-ID: <ZmxfrgpV36aZeimA@redhat.com>
References: <20240613211933.1169581-1-bodonnel@redhat.com>
 <20240613211933.1169581-4-bodonnel@redhat.com>
 <20240614035408.GD6125@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240614035408.GD6125@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Thu, Jun 13, 2024 at 08:54:08PM -0700, Darrick J. Wong wrote:
> On Thu, Jun 13, 2024 at 04:09:17PM -0500, Bill O'Donnell wrote:
> > Use %ld instead of %d for howlong variable.
> > 
> > Coverity-id: 1596598
> > 
> > Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
> > ---
> >  fsr/xfs_fsr.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> > index fdd37756..d204e3a4 100644
> > --- a/fsr/xfs_fsr.c
> > +++ b/fsr/xfs_fsr.c
> > @@ -426,7 +426,7 @@ fsrallfs(char *mtab, time_t howlong, char *leftofffile)
> >  	fsdesc_t *fsp;
> >  	struct stat sb, sb2;
> >  
> > -	fsrprintf("xfs_fsr -m %s -t %d -f %s ...\n", mtab, howlong, leftofffile);
> > +	fsrprintf("xfs_fsr -m %s -t %ld -f %s ...\n", mtab, howlong, leftofffile);
> 
> The exact definition of time_t varies by platform and architecture.
> I'd paste that is, but in libc it's a twisty mess of indirection that
> eventually ends at 'signed long int' or 'long long int'.
> 
> Either way, some linter is likely to balk at this, so you might as well
> cast howlong to (long long) and use %lld here.

Good idea. I'll send a v3.
Thanks-
Bill


> 
> --D
> 
> >  
> >  	endtime = starttime + howlong;
> >  	fs = fsbase;
> > -- 
> > 2.45.2
> > 
> > 
> 

