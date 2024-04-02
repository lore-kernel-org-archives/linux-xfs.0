Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7495914A
	for <linux-xfs@vger.kernel.org>; Tue,  2 Apr 2024 10:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712052604; cv=none; b=sr8wJG9GdY5b/8fJvVDys7Vj+I5WOShQiEaCRPZbuWm2ULpy7iqBlB2dFV9i2+6pM+zzDBjqmBu36LG6o0SEUDDM6wv8oZB6P44ca6pVBZVyHaMIRlO+w2wIq6CtrECS0V4I75m7KwAgb9Swp+XlvZJu6CgXYNnmJIvhulAPD74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712052604; c=relaxed/simple;
	bh=/JGXRN8dEC7eeRXxGa+oKn7ljW+2uWu90I5ZH1yx0qA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b0i7jGa2mGvmjAAP3z0/ruLSiwHo6moS+8kWTpj+YzHTAcfskMxn4PiJ+ohSPYXKTZwdaqaqGWkLGN+yHYgR7KrtusrQUTUukz9m36Wnzw+9RWqLmGG5UCgp7qpGEd6CzqzSA2C/i2QppV0fMaifVGkxpEakCiXZzoK3eS334Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QsBsCrx0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QsBsCrx0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712052602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v9XlJw1dV2M7uYBf21EnZFlthleFX+QwDn8eShFVjlA=;
	b=QsBsCrx01nJGGzmctI/5mh1ovuv0aipcXaE2CJDmPwgkC7Av53Te+fGvt1wFjbMAa1DtXl
	BEgxl8n/VvaoHsFPt8DCs/gkGo5qqQ/3zg11xgi4JrsMYgT6DyeGuLmP7OHZcIn+wAmKy4
	pFU/IXob3lWIr8kPLEpVamGAo7Aig6s=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-9nOPgTdqPD2kQ8FjmulAqA-1; Tue, 02 Apr 2024 06:10:01 -0400
X-MC-Unique: 9nOPgTdqPD2kQ8FjmulAqA-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a473f5a84aaso396770466b.2
        for <linux-xfs@vger.kernel.org>; Tue, 02 Apr 2024 03:10:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712052600; x=1712657400;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v9XlJw1dV2M7uYBf21EnZFlthleFX+QwDn8eShFVjlA=;
        b=xQsg9OROlnm/vOmoZHt8N+mgYOU8PVEK576g3AGrwnZ42DFu/G8RmNfaH5q6rCr1Jx
         j8CFFWDGZWMDkNfbrxkeslr8jb9/jea/XUEV9U2wF90fsOKwGVLoj6t7s2Zspe5qNl+X
         rGos5cPJGsjmhhTHcJyksVr7ie+hoNgKn+sIcVQHAMxDHJsnbS7MZDsyK6Nh03gKxWta
         fbwlgauSIfWX6XwZ1sLXLW27iPVwNLNPrwRUMPBQp+nfSxpDJrWd1mAc2ylp0fvzjnvs
         4jaKRXAo9IHqkS0A4Fokdj+rChi9hMi9J90nYTYVIc6+SIqdH36WpAg0bn1EGhNonhNh
         Z2mw==
X-Forwarded-Encrypted: i=1; AJvYcCVrMc3udQc45OTcTq0CLZGrLAnhzHLWovSfUMx0xjK4eNU6R1zOFtYkK8O1+dMSCmZPocgu5ptO3PwKq3fEgV19k3hMlBzt3JtP
X-Gm-Message-State: AOJu0YzD/ZfkMbZoaF565Eeby6ag7rBOrai3yTl9GExCuUJ3OZ0dNZ75
	vuR/lRbaNH+06jVH6Ke6hsfvDPtPKPgGgR32TR9G2yd8WZBuijMdG3dZpXISXvs9ljzmgdtteLS
	Tw1/RxaZO0EoG+wzcIuQxl9cMBmYg4D4Qgk3zeCwZcJ3qHzlBPViY/RMQ
X-Received: by 2002:a17:906:db04:b0:a4e:2b9e:5b73 with SMTP id xj4-20020a170906db0400b00a4e2b9e5b73mr9263818ejb.49.1712052599650;
        Tue, 02 Apr 2024 03:09:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFPmM5eoOjJMkZksPERAor7w6Un4kTdCaPd2xs3JL0jSqmFfArdXtjO3HZoKySsiA/UzXarTQ==
X-Received: by 2002:a17:906:db04:b0:a4e:2b9e:5b73 with SMTP id xj4-20020a170906db0400b00a4e2b9e5b73mr9263784ejb.49.1712052598992;
        Tue, 02 Apr 2024 03:09:58 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id pw14-20020a17090720ae00b00a4e35cc42c7sm5177827ejb.170.2024.04.02.03.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 03:09:58 -0700 (PDT)
Date: Tue, 2 Apr 2024 12:09:57 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: ebiggers@kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, fsverity@lists.linux.dev
Subject: Re: [PATCH 03/29] xfs: create a helper to compute the blockcount of
 a max sized remote value
Message-ID: <evbfen2l6tkue4flt74faxzwhwn5rm3iemnzuxeyvy6rfeh444@uqffnmrogel7>
References: <171175868489.1988170.9803938936906955260.stgit@frogsfrogsfrogs>
 <171175868610.1988170.11402681235329108487.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171175868610.1988170.11402681235329108487.stgit@frogsfrogsfrogs>

On 2024-03-29 17:36:50, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a helper function to compute the number of fsblocks needed to
> store a maximally-sized extended attribute value.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_attr.c        |    4 ++--
>  fs/xfs/libxfs/xfs_attr_remote.h |    6 ++++++
>  fs/xfs/scrub/reap.c             |    4 ++--
>  3 files changed, 10 insertions(+), 4 deletions(-)
> 
> 

Looks good to me:
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>

-- 
- Andrey

