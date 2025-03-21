Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40431DEFF3
	for <linux-xfs@vger.kernel.org>; Fri, 21 Mar 2025 17:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742579917; cv=none; b=lXyPtMuITzkbgUQCaUHPD12XCIKSFpod0bu3eeeYQofD6R8ZEGqoEPZbT6mlhfErCmvCzL+I20OKdekkevy9zqhY5IrR15g26tK1puE2tieNDV5OK8DFrpe7N/r1CpHZOSW8COrz0cvi/m5qG0SzyQvtneucG93zE0JHIxEs8ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742579917; c=relaxed/simple;
	bh=2Ru2ldz2ofk+AHhsfAkk62lDGN2UrG1soVQErnvPGMk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HKA9fEHn+0+bfBOw0gKWt+UflMJFiBwEjOsCVbr2w7FRo+lYu84I0gH34XGzp4TN94ost7deNNVdCf6ITU2R/mTYTsvbrIq0GnDIGXygcLgn/73rpuE8iF0go5Vs5dwaG/BHP/tUEncGBzXkEJ0o0BZ575AWBp+thykhl096FNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OetgFGZo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OetgFGZo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742579914;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Se9FF70wKa4auCbCzL4knABrywTG1+vzNlIQ4bhESHM=;
	b=OetgFGZoqhR5NWgXOot0wnHLM7IMfeGc7hOGvEjH0n4LaaEwHnFS/B3t9VcvdGvB6EvcMQ
	xU97n0O9OBYlgsASRuwO598VRKfX8st2/1zTPpgkX2yfcKjoS6ozti2tpA+3bEMhWX2tej
	/Kor3rKYINo0rI5eS6vGLBy3br/QTCs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-35-NbLAcL9kOnSDmg_RHdxTng-1; Fri, 21 Mar 2025 13:58:32 -0400
X-MC-Unique: NbLAcL9kOnSDmg_RHdxTng-1
X-Mimecast-MFC-AGG-ID: NbLAcL9kOnSDmg_RHdxTng_1742579911
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43cf172ffe1so16584725e9.3
        for <linux-xfs@vger.kernel.org>; Fri, 21 Mar 2025 10:58:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742579911; x=1743184711;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Se9FF70wKa4auCbCzL4knABrywTG1+vzNlIQ4bhESHM=;
        b=dHzURzU89vFpg3F+2wlziWGaEfE2mkNXzdVJGZIWQU2OM950OHfBE07MoGdaTttLoD
         1dXmx8N+xdmv6ERRcsDKZ8ByVO2C7OoCIefJ6i9B3kpH12xFuGD139HTgq9rsxnj501v
         uzJsEtLAaAa69qb87aXqh2s8HnukVJBYy4k6kJG0au9Op0/QlfeyHyrVhyPQ3cCcUCgM
         6FaBs4eAYQZHvvv1oPRtIHp89W+MLPfWbfnLdnW7ro3yPM8cx+cyxSdwoZlbkmt6I09u
         cEnO5uEzuSWbaJfULZpJO2lMq4W4SkfRNPt/8P4gDbVv1VTh12CPR9FgkU39c5Dm3RB/
         VewA==
X-Forwarded-Encrypted: i=1; AJvYcCWeVsVmJTnz8nMRbvDeQPnyAOScKQMSM3yAgAx4dnpDwsxhDN3LniFTua50YLOitgW7sKwfVjwuy4E=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZVqw8iAvEH7GMEZnBw24FqapfP1I8+ci/JICT3eOEwrL9iHUz
	fmuLNNPXpkgKSgTxIlhhzOWsAQjmVtPyntFadr6XwiRZ90CkqlgiKRp3WVTogrvg6/YXno9vC+X
	EKtnQIsE/f4zsmx8BNRRLTsZUQpOn4lF8FiMGxZcl1B+2WLdSWHtbFxdMmZ4PsYw3
X-Gm-Gg: ASbGncsJglBQ2Oh0SuTMUkaX8nX2jxMrG1Z9vgbffpi0I37yxOrhC+0LjrnsQAzLo8k
	0j6lHKMktlLzy8YQu4NPj39P0MEu81RYCXqE3PIhyL9BLJpYZQ2oBAqZ1i16PiIpEaGFCGuyYQV
	JoTeweJ+M/HLxHKviYXcklBGmgiUlCAs2nss8J/ovawVltx9V1ehwTwmyOltehzYcktqHjtIICD
	Qfa/FUt60ZU1+THnjhIZHGOts4zgqbC2LrjFCDLdDZCLcFhgZ8DwkewQgfL1s7/Zli77F+VvoCn
	P9MfEYZHqbBFP3ECLQ6FhZnL+qIDaqMRSIU=
X-Received: by 2002:a05:600c:3584:b0:43c:e7ae:4bc9 with SMTP id 5b1f17b1804b1-43d509e45abmr32163495e9.1.1742579911244;
        Fri, 21 Mar 2025 10:58:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGqeIUs8nwYwB4aoqswanbQHsYlgqrp/oFIse68kWggpKpb7MSmS5KN2AyT6vVegvouqkqfLQ==
X-Received: by 2002:a05:600c:3584:b0:43c:e7ae:4bc9 with SMTP id 5b1f17b1804b1-43d509e45abmr32163325e9.1.1742579910818;
        Fri, 21 Mar 2025 10:58:30 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3997f9eff79sm2971717f8f.95.2025.03.21.10.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Mar 2025 10:58:30 -0700 (PDT)
Date: Fri, 21 Mar 2025 18:58:29 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/4] xfs_repair: don't recreate /quota metadir if there
 are no quota inodes
Message-ID: <6r7q2mbb3uoum7i75nxf34d6xrko6rddf3xncj6w26hdjr2qie@nnqbontz7xsk>
References: <174257453579.474645.8898419892158892144.stgit@frogsfrogsfrogs>
 <174257453614.474645.7529877430708333135.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174257453614.474645.7529877430708333135.stgit@frogsfrogsfrogs>

On 2025-03-21 09:31:31, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If repair does not discover even a single quota file, then don't have it
> try to create a /quota metadir to hold them.  This avoids pointless
> repair failures on quota-less filesystems that are nearly full.
> 
> Found via generic/558 on a zoned=1 filesystem.
> 
> Cc: <linux-xfs@vger.kernel.org> # v6.13.0
> Fixes: b790ab2a303d58 ("xfs_repair: support quota inodes in the metadata directory")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  repair/phase6.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 4064a84b24509f..2d526dda484293 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -3538,6 +3538,11 @@ reset_quota_metadir_inodes(
>  	struct xfs_inode	*dp = NULL;
>  	int			error;
>  
> +	if (!has_quota_inode(XFS_DQTYPE_USER) &&
> +	    !has_quota_inode(XFS_DQTYPE_GROUP) &&
> +	    !has_quota_inode(XFS_DQTYPE_PROJ))
> +		return;
> +
>  	error = -libxfs_dqinode_mkdir_parent(mp, &dp);
>  	if (error)
>  		do_error(_("failed to create quota metadir (%d)\n"),
> 

LGTM
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey

