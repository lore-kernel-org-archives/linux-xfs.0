Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469F115AAD5
	for <linux-xfs@vger.kernel.org>; Tue,  2 Apr 2024 18:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712081107; cv=none; b=QAXStY0R4rwhoRNMM3/K3krDr6wM/Fz92uNagQIlSiS8d4XpW+iNo1Ge0L5mYAckrcIRFDlcbyDnYFyDZOV94r4lcJhGYLh0cdfTClA6D9agp3l00UEkP082PbuMkbCvzcm9uRi1D425A7LUl7HQobrDr89jUW/hJMaGCdyPfH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712081107; c=relaxed/simple;
	bh=BmvQ+0xao1n5voXSxUVflO7jZ9eSYVUGYxtndPxgVXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bdYJh2BMl021/YPtHvPQjHsHVI50MYnSMsLDPphM/GZ2VrbgZhTCX/DxRvSPXQlG/E9EunxGcrzTTjZKwkZdeUVKtLk+exx3THZRr2hPiz3m8jWIo4gB5cNbj3gXLOQIqNXrnQJOEIGW2VDLH3HyF5/db9pJMzsy3JT4HmhIa14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PDMP1P0m; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PDMP1P0m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712081105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QxsmDw4gKSaDCVTh8/y79dF5qk4AA3NIv/V1UZhqWH0=;
	b=PDMP1P0mP+SWDoSvcsAsRjTNfE/3oeP1Rrai6o8MzULz1IlI7yY44O3fmxr6RwK26hNQvK
	ZrmZ+rZYh24aHV3D/SniUuCLzJfQNs+yJCmvdIazn3wklbiP3FfSZpZm2mf/+oeAX6YwPn
	5zLwz6BFjXKg0Vvdt8dgkkyQFNUTc04=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-372-vbKlzVnNNHqrSF1kVJoWaQ-1; Tue, 02 Apr 2024 14:04:59 -0400
X-MC-Unique: vbKlzVnNNHqrSF1kVJoWaQ-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-516a50d2d1cso1799251e87.3
        for <linux-xfs@vger.kernel.org>; Tue, 02 Apr 2024 11:04:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712081098; x=1712685898;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QxsmDw4gKSaDCVTh8/y79dF5qk4AA3NIv/V1UZhqWH0=;
        b=EBRUOX/tABptUv8HPxle1bSPEKh+vghw6K+arzeX1o7ku66GC2gHRw0EPUm2DCMmk0
         nhaGNoyIiGTIjyYkeFalDfm3JMCnmW9vY6COoyag9D92cxlDCQF0VBNoW/6Mug1imRWt
         jFPw/7ZNusymZkbTe+CYRltWaqVGmFN2UcAcjLwcSOJI2F10X9lJgfU/6v7QwQtRsrcR
         qpKFAsbJBVj72VJAoyhJ/4tpFIwefPdwECegpAaV3hoMKo3D5TrdUYV9BK/1+aGgDbhr
         jVZE7S6lwCePgRzxA4CFxDBVeNrVKPhPe+KPwD3RAacxk5TsO57r724G0JA7dwOWA/Gp
         JqEA==
X-Forwarded-Encrypted: i=1; AJvYcCVDGKisy1o4ATTJ+uB25fQY2hiMMd3OUUV+pJ2/VwCCXwpH2WGaPto3gq1k7NNqyKmSu4k247A2rpZjaI4T/nMeGyfdpZGiFACQ
X-Gm-Message-State: AOJu0YyIW1AAzu3LjjDnExXI0dLw0/3pXryh0OneAtkg12lAxcjcbsPs
	ztNoSipI44fg24iHNzGK1WlC8BJcxAwgWcaBeqnLC9WWOQW7I26FkyXMczqTLEK2WLH2AnAt/Z+
	XStN0ZILP+CLblndYniZzTiQlswZtEWErWAElq5pPkHm08A0cNA++fK3N
X-Received: by 2002:a19:2d4c:0:b0:513:ed0f:36c9 with SMTP id t12-20020a192d4c000000b00513ed0f36c9mr9132291lft.45.1712081097771;
        Tue, 02 Apr 2024 11:04:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFzWp30/35ol9RiIOdC+Dvt7bTyK8WadGPxAm9ZdLb9mGQnaUhhgWBUQWoANMM+1yaQOUy+yQ==
X-Received: by 2002:a19:2d4c:0:b0:513:ed0f:36c9 with SMTP id t12-20020a192d4c000000b00513ed0f36c9mr9132275lft.45.1712081097240;
        Tue, 02 Apr 2024 11:04:57 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id a17-20020a05640233d100b0056ded9bc62esm886769edc.43.2024.04.02.11.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 11:04:56 -0700 (PDT)
Date: Tue, 2 Apr 2024 20:04:56 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: ebiggers@kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, fsverity@lists.linux.dev
Subject: Re: [PATCH 28/29] xfs: allow verity files to be opened even if the
 fsverity metadata is damaged
Message-ID: <deqh2ho6ra7tahcuczessc336kmsj3ltgsk6jhu34jrbwwkjqg@uvgkpd5kz542>
References: <171175868489.1988170.9803938936906955260.stgit@frogsfrogsfrogs>
 <171175869022.1988170.16501260874882118498.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171175869022.1988170.16501260874882118498.stgit@frogsfrogsfrogs>

On 2024-03-29 17:43:22, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> There are more things that one can do with an open file descriptor on
> XFS -- query extended attributes, scan for metadata damage, repair
> metadata, etc.  None of this is possible if the fsverity metadata are
> damaged, because that prevents the file from being opened.
> 
> Ignore a selective set of error codes that we know fsverity_file_open to
> return if the verity descriptor is nonsense.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/iomap/buffered-io.c |    8 ++++++++
>  fs/xfs/xfs_file.c      |   19 ++++++++++++++++++-
>  2 files changed, 26 insertions(+), 1 deletion(-)
> 
> 

Looks good to me:
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>

-- 
- Andrey

