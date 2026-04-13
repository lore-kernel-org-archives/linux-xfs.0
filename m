Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945C53AE6E6
	for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2026 14:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776092272; cv=none; b=umYbJzc8VYeyxjhngOjnWpyyN7qxT5Qah1u++cPgiXVvLyumN5XELGbL6EQiAM+4OZR/sqHgHGB96T8RVSbZPMCvbKTY5effcDoZ9tFPl+Y8o2aObJO4u243F12Yhbd+2xe2zXSzc7KBVaH43MaTdDBARNsYdcn8CLRsp5RQltk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776092272; c=relaxed/simple;
	bh=8xzCu8QZVIWaB+51owuJWZfid/LTY5fMn2BDq0vYHH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aVmqql6lYBz4sp6/VxR/dDo3qAj4Th+EZ+RddDEETyN/w1pr5LxOei2olJaqqCp6g7RB/rlGdAM7cp0R4T+Qddc1ZULkomk8j7nEsTcExEPCCfDqQwF4nhdsnghPBaht8YNI8sWkUPj4O1YmWlcv9a3gAlUwz2/TJGYGtP3xxd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HwMEWYyL; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cwc6evFd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HwMEWYyL";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cwc6evFd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776092270;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+XXlg2OhuiXB6EXI3h+3Z6Fbnf7T5TecX0/by/2GEdw=;
	b=HwMEWYyL1DlpgAxRwHeXhBgy2UgYOnowWgPjghxzs0uHk+T0wekKO3sFDPGBDg9QoU6ZwG
	0rUBwiOCamxWz/xvrM5zv55U0/nZnIpzuzmFPhlH5PInW9+TY3ZDhGSohKjFpcFh51b35+
	i1QxmPeixCeoLYuGmhoMIF1UKkKavW4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-473-JbrXGX5ZMzmu0sWzRP5eDA-1; Mon, 13 Apr 2026 10:57:45 -0400
X-MC-Unique: JbrXGX5ZMzmu0sWzRP5eDA-1
X-Mimecast-MFC-AGG-ID: JbrXGX5ZMzmu0sWzRP5eDA_1776092264
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-488dcff87b7so12211415e9.2
        for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2026 07:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1776092264; x=1776697064; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+XXlg2OhuiXB6EXI3h+3Z6Fbnf7T5TecX0/by/2GEdw=;
        b=Cwc6evFd3rs8n6kasih5Hqihoyt4o1/Ga6skaFcGwInVtr1zABQNvOMn8yxD6mm6FV
         5TzefzF+pSwFR5TXvJKgQNlRkBwtVDKKiFR9L1KgMRiNEXnVXN2nnZHbnrhRt4SscB0A
         FGyqmE0aTGA2c9pxcESw/gGW7EnpL9EpFn6rePXT0lljJQBI3il2fLCXtG/HvYIMBJRE
         8zbeArd9hmKzGylMNDTNiduWds4dLFTKpcsSHxx6sxC6d+NIefAxGgCtUYwiRlMQsA7u
         wQzm/BZuFLNInFKvReUDezI+bAQbHUbhD160QdaMktRsBLYbmR0wvM/3wl8x65sWRB7M
         3jLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776092264; x=1776697064;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+XXlg2OhuiXB6EXI3h+3Z6Fbnf7T5TecX0/by/2GEdw=;
        b=h2y4oL5bd3m5OxadwpM7u9hJI3Rt0iHvp0K0gJ0ubxozEoTqM0AcIOxK+EiOqehhzH
         EGxOYN7OMjH5gtXQXHx4/bnLG5ukVpcyfYZ/eFx2sxZbXLH5+oTgNWmRBSeoPWrU8Z82
         8aJxZeIGcLq3L2b0eJbGgRvIP2CXBmLvzq0cKz5Z+lRbu96X5hj7JzZInKVyIBGEsrOB
         TQGXWiyxix1dkRnY8suU+E9/T9+P/uZ154bHYqCRp71taJ/y8vc6NmA5Fap+DK6ABEaV
         S15y7gcSWlRaiWtUSTKOC3UPfYxTrIAlLwATA3b6VP90FO4zmVJX+VqSgvFqElRmvt+u
         V1QA==
X-Forwarded-Encrypted: i=1; AFNElJ9rYcc0Ai1VIA+Y74MzbUd4XhAvw1jXXK99oA50yq7ozPOv0WBzR4TjCV7Ko8bdhjbGr2UabTSn+aA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZpZkR4EM5RlZow0bVwtlP6bPMUf7UYiTNYsYozk8YzcccuCkE
	qCcb1dPLHQ3gx5IWl8huNN3pGFpUq2pc4ABcP0Obi3xToakfQXF4KWXiCK5N0MTYArJjS2xZDQA
	90/CvdhMONNEaiE2zV25mSHmMTJ6WtVt8n36NA9t4iANjnIt+U11w49Zalvqw
X-Gm-Gg: AeBDieuSXNtS2WL0v9C29a33na452F08d5fiM6R7xz8yZEMvNdeaQSP2+6I8H1x5rw1
	868y7faYZxk30O0hipxmO3X3svBrBurNMz1PasdJ0+b11zlf7rQTvWkd/46Wkum/iRhzdykUa70
	gsmVsVNiNpderVwg8TBZbNh/gt0RAyATzy5MDtlWWPtNik7AuVSEYDymwUjRsmcVFzMB86QbWxB
	KVXquk2XB+1rmcS+2vIPdgLBJO0+yTXmCRRbkXFGwHL8Ng0E17/47KN90dr1hmNHRxlAJ4Au2cj
	urJin6MDW0ISR9roija7zf4IzqkR106fAclPZgHRGC5IX4+P5+NiXu0YoD1WFX/sAjwhtzT5BRT
	2jKlrGGgBDpFmZw==
X-Received: by 2002:a05:600c:3149:b0:488:ab26:8fe0 with SMTP id 5b1f17b1804b1-488d68432f2mr192799205e9.15.1776092264138;
        Mon, 13 Apr 2026 07:57:44 -0700 (PDT)
X-Received: by 2002:a05:600c:3149:b0:488:ab26:8fe0 with SMTP id 5b1f17b1804b1-488d68432f2mr192798615e9.15.1776092263476;
        Mon, 13 Apr 2026 07:57:43 -0700 (PDT)
Received: from thinky ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d5b3d4dbsm301341195e9.14.2026.04.13.07.57.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 07:57:43 -0700 (PDT)
Date: Mon, 13 Apr 2026 16:57:41 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Andreas Tille <tille@debian.org>, 
	XFS Development Team <linux-xfs@vger.kernel.org>, Anibal Monsalve Salazar <anibal@debian.org>, 
	Nathan Scott <nathans@debian.org>
Subject: Re: [PATCH] debian: add version control tags to control
Message-ID: <knkipaowrdtq3wlxvr3xbjkvbtcu6hb75gmgeo2jkthl4orfin@hmmjv75l72z3>
References: <20260413143800.GI1048989@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413143800.GI1048989@frogsfrogsfrogs>

On 2026-04-13 07:38:00, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add some vcs fields to point to the official sources for the debian
> package (which is to say, upstream xfsprogs).
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  debian/control |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/debian/control b/debian/control
> index d50960fba205bb..738f3a15fefe79 100644
> --- a/debian/control
> +++ b/debian/control
> @@ -18,6 +18,8 @@ Build-Depends: debhelper (>= 12),
>   uuid-dev
>  Standards-Version: 4.0.0
>  Homepage: https://xfs.wiki.kernel.org/
> +Vcs-Browser: https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> +Vcs-Git: https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git -b master

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey

