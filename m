Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6BF4206F
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 20:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713300698; cv=none; b=js9GSfZ3BKxrryVPPJHgnKM4ATsdOTB6nUy536REuLfZJz4Ck/56F/lJnaozPU9pJVfe5RNOK+Sz2uhBloysaDad7+LmdjeBJBFK9weXLbTYHCN4CiAQx2QCEEjzuPAXAIOTq1JCHvhUIm2XSl9uN64fokoRfFOzuLpAfr5Y5K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713300698; c=relaxed/simple;
	bh=AmfOe1SzX9fiDhhw5LQHCi/xnkvd68rrEOHL22qkCLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AWJlolUsw8TBlxz336awNaK2760Bmjs17r3ZOzlvAwuI8VbtNiCq2js3ECSq7Sz6e1v16on6VHJM82jx1b3ZC6SMdgnwLXoDffD97FAq9WumiBUSgwQtPEjnkIy+qPlcmdnXOm/kFIwW5fUf9oabnvyIzM38g28CgEGG+gchfg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jV+AhGBQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jV+AhGBQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713300695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Of+PMqEPaWCdLn8a4kywvlLarwKj8YdAdJ5gQumwoeo=;
	b=jV+AhGBQoEAYa98WXZfrCUBiK2L1ojpY2MxEMRmqDaVSMM2Vh0i5dwkvIStH5c5hszlmvA
	+NMnH/kxYBY2ZkmcN5v8/bwtQZ2XtjwuUHZM7M8qAYBduVDC5IuUpUQr9BaiZeElwuPebb
	t4eu1NGdOlxy1+h9XmAh+Yt+CSyVBxQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-656-JKfBPgaePZi8l0zkA6oHcQ-1; Tue, 16 Apr 2024 16:51:32 -0400
X-MC-Unique: JKfBPgaePZi8l0zkA6oHcQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4665B80A1B7;
	Tue, 16 Apr 2024 20:51:32 +0000 (UTC)
Received: from redhat.com (unknown [10.22.34.175])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0AA97492BD4;
	Tue, 16 Apr 2024 20:51:31 +0000 (UTC)
Date: Tue, 16 Apr 2024 15:51:30 -0500
From: Bill O'Donnell <bodonnel@redhat.com>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 0/4] xfsprogs random fixes found by Coverity scan
Message-ID: <Zh7k0u7CqyNx3y8W@redhat.com>
References: <20240416202402.724492-1-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416202402.724492-1-aalbersh@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

On Tue, Apr 16, 2024 at 10:23:58PM +0200, Andrey Albershteyn wrote:
> This is bunch of random fixes found by Coverity scan, there's memory
> leak, truncation of time_t to int, access overflow, and freeing of
> uninitialized struct.
> 
> --
> Andrey

Could you add a brief change history on patch 0/4 for v2?
Besides that, the series looks fine to me and you can add:
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>

> 
> Andrey Albershteyn (4):
>   xfs_db: fix leak in flist_find_ftyp()
>   xfs_repair: make duration take time_t
>   xfs_scrub: don't call phase_end if phase_rusage was not initialized
>   xfs_fsr: convert fsrallfs to use time_t instead of int
> 
>  db/flist.c          | 4 +++-
>  fsr/xfs_fsr.c       | 8 ++++++--
>  repair/globals.c    | 2 +-
>  repair/globals.h    | 2 +-
>  repair/progress.c   | 7 ++++---
>  repair/progress.h   | 2 +-
>  repair/xfs_repair.c | 2 +-
>  scrub/xfs_scrub.c   | 3 ++-
>  8 files changed, 19 insertions(+), 11 deletions(-)
> 
> -- 
> 2.42.0
> 
> 

