Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0D214C5B0
	for <linux-xfs@vger.kernel.org>; Tue,  2 Apr 2024 17:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712078113; cv=none; b=H8ccHs99eIaRALyHuaNFgw+PXbSQXOdS5KNLxJIUtwAdPBqRsfvagEVj0FO7H7Y+T5ZMR8BnsRUgnF8+W2CYEFYAQH3U7r1gI0Fnayo+3hppuUwEZ+mMB+jkcAM2haZDJ7bsSW3II4/moD3mx9VsQjDIZSxQS+rArbHjcH3OMh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712078113; c=relaxed/simple;
	bh=gONxLiG/KtKALcV3UaKI4cYHp0a8d+JcZLnRPZyZ83I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=loJygjmhaHifMhWNM/q/BUKSTfTvNmrWzRHogujIc8daDtuMAuUf6EC4o36sGR2cFJSTyYQqZPng0wsjLkWTgw4tlULah2VFzt5rMvn1eMD29Wflcax438YH+bDgThB0tjDcQeK/m3ACTefirrB+PnB33PMXv8xpHxfjDANov2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bvN3eUUT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bvN3eUUT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712078111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JH2SMOejoMJVVtHeJkNgAl35h2UZLOewvGHfqdN+G3A=;
	b=bvN3eUUT0j1ZU0cXHtJtvugFFlacexwIR7NkIzb635p32z+nAAnIhDHYAhVCH5yCPAk0Vo
	3IvybcoPyx0XdztbCMPQIObXVLQytgucF8JwjAay+gZKZmy1kCZyxTvmSmpUN4HkNgIlZZ
	xgwPFeZnY0WGMWbPXIM+lEAqsJTctOk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-ol4FsEKwM9CeczfDEKQPzA-1; Tue, 02 Apr 2024 13:15:08 -0400
X-MC-Unique: ol4FsEKwM9CeczfDEKQPzA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-41493ba3fcbso24217315e9.1
        for <linux-xfs@vger.kernel.org>; Tue, 02 Apr 2024 10:15:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712078107; x=1712682907;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JH2SMOejoMJVVtHeJkNgAl35h2UZLOewvGHfqdN+G3A=;
        b=ivNOWdQwtdwRJn5oaGl5MUu1ANv02ocKmoBQlmwMoHA4TYLWVqycj7Kyh7rNoZlcIB
         hwCjculT8Uf2Sz390VER4G8vbNOvmCGELMOQy7RGvDaNlwlJtzQW9H9WFHyMKoSz6PlM
         e0IHeSrxyYSftkXTrZxdmq9X+hz0tIxkH0MVO8Zo83GYnjv0dnseMAJDlc6/WEiteooR
         IJSEmwvBGj8QTAI0Iyuldptrn26FCT53Lx1LmcePcuN58JksyWj1JXIHN2sB+uHevm4I
         aMdBtg59xXzdy6Vqe9Cl3phxfVSdnUxdLq/zrDXZiJjN0ug3C5suLFVwOR5OmK1rDxva
         RCeA==
X-Forwarded-Encrypted: i=1; AJvYcCXNvhQvHH0YFr47f1GwjHCiWpFNZpFqVtScbfxQEVrlaOz7/FosyVTc4LoPCrHztczoK29aaWtPo9mjrEXqzVGy19jOLH0qv/k7
X-Gm-Message-State: AOJu0Yy8Bve2SZwpmb5wtid8A0pewOR06sur3s/FbHPc9a2Aq18NZrDm
	PSRNSkwveQw0oR6Pz1RVuQXJp3tDMhOtMtDuFQYFQQs7UL2M3llQtL+JYsLsrU8zIMl0o25+o/8
	RLlmpLg8yj6xly6ktsn6HFoDxptK0rsynbTl9dlE5ht2apbezwOB7OnjB
X-Received: by 2002:a05:600c:4583:b0:414:7198:88a7 with SMTP id r3-20020a05600c458300b00414719888a7mr10227230wmo.34.1712078107257;
        Tue, 02 Apr 2024 10:15:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEBkh/H8jx4WNfScg0QetIRqTHa3bAsRuQbjjcs0nbQsFEOKtPqhLK97VSqKnvJb3sIfaqaSQ==
X-Received: by 2002:a05:600c:4583:b0:414:7198:88a7 with SMTP id r3-20020a05600c458300b00414719888a7mr10227213wmo.34.1712078106668;
        Tue, 02 Apr 2024 10:15:06 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id fc11-20020a05600c524b00b0041408e16e6bsm18656884wmb.25.2024.04.02.10.15.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 10:15:06 -0700 (PDT)
Date: Tue, 2 Apr 2024 19:15:04 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: ebiggers@kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, fsverity@lists.linux.dev
Subject: Re: [PATCH 27/29] xfs: make it possible to disable fsverity
Message-ID: <lq4w62nepbmkxaktcpukts4v3jz6wbjfc7odv76iujttzrvyze@yglhbnoiwptc>
References: <171175868489.1988170.9803938936906955260.stgit@frogsfrogsfrogs>
 <171175869006.1988170.17755870506078239341.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171175869006.1988170.17755870506078239341.stgit@frogsfrogsfrogs>

On 2024-03-29 17:43:06, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create an experimental ioctl so that we can turn off fsverity.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_fs_staging.h |    3 ++
>  fs/xfs/xfs_fsverity.c          |   73 ++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_fsverity.h          |    3 ++
>  fs/xfs/xfs_ioctl.c             |    6 +++
>  4 files changed, 85 insertions(+)
> 
> 

Looks good to me:
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>

-- 
- Andrey

