Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF23171093
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 12:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481135; cv=none; b=u/12BvUDFXG7uBZ1mg2ZF6FP5UZ+KumvOGGleFpJU4puC03Eaz3hwmnZO4QrsAio4yVRxudXvqgZWXa0qG9uT1/zzHCUjYwASslvPkAkWEVzegPTDdVa5oCOlpzPCj3uP16vzmiNg52VmaFzxuYLlydXq7XxFELZrJ26fhqS7vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481135; c=relaxed/simple;
	bh=sBwO4tPURPfK/Tpoqq7ijMiBEHW84wlDyIODrCdIFCU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gkiWahVR06WbQYLs14tsdxV7BXNaBZPSUG3zDEneXozQf8p3lYCWYpNSJNqlMP6aTCX53vgnfxFG941F7wl5GngtEbbnMXGZL2DoZ9zoIA8eLJXg+0cP5x7ChJqbZGKe6gn9pv4WlbC9GUEcKIC95XxwDsubXvJreArsQP41UTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HDCOFFrv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HDCOFFrv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714481133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R4X6n0pLuVBUf+BlkM+ca3r2rZEzvEw8vYRriJB7tN4=;
	b=HDCOFFrvaj8c3/90tyF8lTssXiGQVLHf1YRgOnhF7Rb/0VKdGKomL3Vvf7GLoBb6fGZqNu
	rwsSImXjGVJEVNV+4+0Rwz9YBeKB0rMGU429XXA7J/p/uPZLENOdH3fdz4EcF2xqUXXXfJ
	pFqxbIi847JLAki7KSTAKNus6W1Dp2M=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-379-7nyyPC8xPByR9GDXYyEdgA-1; Tue, 30 Apr 2024 08:45:32 -0400
X-MC-Unique: 7nyyPC8xPByR9GDXYyEdgA-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a524b774e39so607190066b.1
        for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 05:45:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714481131; x=1715085931;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R4X6n0pLuVBUf+BlkM+ca3r2rZEzvEw8vYRriJB7tN4=;
        b=RbsXq7uG6BqVbAB++olYLkiQIq2ifmAJLohob/tImWgBIkU1QRfEgUoe7hUb2wtklt
         f5zqqYcaqcWEDH3r9AmPZELf3sUTRjcJLmhlTwtgqFAIsOqx078TA8QLgNAOlGkwo6HB
         f1yQ0qRz9GkTyUFL4hbIcFVyN1Q4y+4lO4dCR/gs3Xh79iIjZcN8EfZ3xMV4THmHFmRR
         7UxF9356yDy4Z+UX13AxlwOaSb0mI8cX5NVIPaXg3dbEtWQfvEcm67adKA0j2dZfDPLa
         ZPMot/GQ2zyIX9YzuLe4XSKeosFMHKOW7+mj9SWv9G6U57op9jZsrhSN3btmNUtF41Xo
         aHJw==
X-Forwarded-Encrypted: i=1; AJvYcCXGu/otbAn6vkD5mg8kZo94mzA65mokijdqVg18fz0qYlmNILbL7oGqZcnRYTxaraAPAsRImxpXVObWYffisttlrtt0Wh3Ur9Dm
X-Gm-Message-State: AOJu0YyvaTCUJGvlHuBzYn5+tTivMuVBgTEcPCu8dFtq2y34BX9J0O64
	0M93AIJ3RVF4DrZ2gB9b4BvK21aLvZk4Sru8fECrE/Q9DNnEzjwISKyUMeuMcc5ZmK0N1or815L
	H9Krj0Ib0anUMkxG+afLJNMUvTo5Q3PitgQnx4LFWBEI51yTVkSZWCl5D
X-Received: by 2002:a17:906:384b:b0:a58:7172:1ab0 with SMTP id w11-20020a170906384b00b00a5871721ab0mr2477676ejc.16.1714481130921;
        Tue, 30 Apr 2024 05:45:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHTDZWzi552+qruMRrzcUaprNH9Uh7FvvQtJYCo7WBIUu82K3ES4iheNJ+29jVddUBCcqoTNQ==
X-Received: by 2002:a17:906:384b:b0:a58:7172:1ab0 with SMTP id w11-20020a170906384b00b00a5871721ab0mr2477642ejc.16.1714481130382;
        Tue, 30 Apr 2024 05:45:30 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id a4-20020a1709062b0400b00a58bf7c8de8sm5776845ejg.201.2024.04.30.05.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Apr 2024 05:45:30 -0700 (PDT)
Date: Tue, 30 Apr 2024 14:45:29 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, ebiggers@kernel.org, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs/122: adapt to fsverity
Message-ID: <wrxpj5cduflmsthmgrlbdewpis5mkpz6rnrcsmgapybtznavxp@dryj5f364uxa>
References: <171444687971.962488.18035230926224414854.stgit@frogsfrogsfrogs>
 <171444688024.962488.13214660928692324111.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171444688024.962488.13214660928692324111.stgit@frogsfrogsfrogs>

On 2024-04-29 20:41:34, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add fields for fsverity ondisk structures.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/122.out |    2 ++
>  1 file changed, 2 insertions(+)
> 
> 
> diff --git a/tests/xfs/122.out b/tests/xfs/122.out
> index 019fe7545f..22f36c0311 100644
> --- a/tests/xfs/122.out
> +++ b/tests/xfs/122.out
> @@ -65,6 +65,7 @@ sizeof(struct xfs_agfl) = 36
>  sizeof(struct xfs_attr3_leaf_hdr) = 80
>  sizeof(struct xfs_attr3_leafblock) = 88
>  sizeof(struct xfs_attr3_rmt_hdr) = 56
> +sizeof(struct xfs_attr3_rmtverity_hdr) = 36
>  sizeof(struct xfs_attr_sf_entry) = 3
>  sizeof(struct xfs_attr_sf_hdr) = 4
>  sizeof(struct xfs_attr_shortform) = 8
> @@ -120,6 +121,7 @@ sizeof(struct xfs_log_dinode) = 176
>  sizeof(struct xfs_log_legacy_timestamp) = 8
>  sizeof(struct xfs_map_extent) = 32
>  sizeof(struct xfs_map_freesp) = 32
> +sizeof(struct xfs_merkle_key) = 8
>  sizeof(struct xfs_parent_rec) = 12
>  sizeof(struct xfs_phys_extent) = 16
>  sizeof(struct xfs_refcount_key) = 4
> 
> 

Shouldn't this patch be squashed with previous one?

-- 
- Andrey

