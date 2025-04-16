Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3E61537DA
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 08:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744792043; cv=none; b=S6RCtqRA5JiGv8ZuEGrHiO35cotDP48P9vdRQ1Ia9NZ1pra2SW0u0ZKwgIejgmgWfVUCuj42rDKQ5wZk7Ny+y2sYH+nW4mV7cWy8NnKZmMMRhAj1sNZJkRbJcD6nQnS5EkB4CEq3QvGVLLxVMR+j3j9IKx+fsje80wGEhHxPmS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744792043; c=relaxed/simple;
	bh=kJ2pKFlJsNFV8mov2fY786sHX0/kMhg1T1Q/x4vBu5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OPD5ZzHVY+il+b2D1lcWlw94xrTXIYH2Bcau8QsnHjkLWn613/+xaWM3XoLClqVaIoPr8JFr1OU3ZCl+RnVzqonQG9yAhciOKY+jKwYX6pnfE7FdWb5dEbXAp1iVBNxwWEB4pQK0RpmPYdKGS/ML4PdQx3pYAnSoNOAmdYnB+dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bn4/qSiN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bn4/qSiN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744792040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tM1bJ8+bP/5ss1y/JiQq93nSEPN6BrSBT5gyJEgaiF8=;
	b=bn4/qSiN/B8G0cC4eNe3Os7mGM7HDGbzseEzKP1KbxkDG7hi4DBBsoXrpNYQy2U+lEivVW
	sUbK1To6ikH1KYFH4grMs1yi+6k7tknNPavRuWb8R0YKx1PS2deCMg7EiAnbcIXcvtxsPH
	2gH+CPtoYV8ftg0tunKfT9i+gTwtfgY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-510-k7ATiWijNPC_d_dPQOyvVA-1; Wed, 16 Apr 2025 04:27:17 -0400
X-MC-Unique: k7ATiWijNPC_d_dPQOyvVA-1
X-Mimecast-MFC-AGG-ID: k7ATiWijNPC_d_dPQOyvVA_1744792036
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43d22c304adso1879935e9.0
        for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 01:27:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744792036; x=1745396836;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tM1bJ8+bP/5ss1y/JiQq93nSEPN6BrSBT5gyJEgaiF8=;
        b=M19VVkeWphJW2GVRvzlYLL+jLYUYANGB1OPkjQ+v1W3VTew73RBCmvhqiOIXZJqrwT
         njGwJjrGW/gdKyI+CZGAqBItJ1DrOudBeqlEwjJw2sOgNh1UFB4jQ8gOpnL0BPeIlA4A
         f17BsEO0QdKBITa71R3+kdfRza2eyIlRuqBHQhG4mdPPQ3C+ZeScHOxRYkbi382zAfhu
         cA1lDkI/UcLaiFTxdjK8/T70RdX/+XCaT9DWnVAU2J5NUaKmqz5E8nVl2L2HiTTDnI0g
         9h0IUNx2Mpwso4igP96OoKjF4XJekbe75hufWgVXdu6+s5bUrNUwKCAAvs7ALv2cYdjG
         bMtw==
X-Gm-Message-State: AOJu0YwcHDiuD9RS00AW9zZQ5dSgwcl05Ph5eO1LpVsVbVA1BsHdVbZP
	12v+CvxC2Mk4f05XnJP6G2QIeczV2UkF7RgiIZiOw5yqaPogIXZhctHGy77/LGa/znkRDivGR0i
	lbPcmOPvwtpc5kRxBRtwqxDSbDeQcP0mgUduaP5OvFcIAVNI8++lR9LZy
X-Gm-Gg: ASbGncsYc0RkCcPAeOgctCHc7Pyz7TtzPgU9PXrpZctfwVX2VHFumRQQ/VNDH0Kb9CC
	mj6ByvQ4IRVBlh0YfgBw/uyOpTOsCGrf8h9WCIPiukhhljDbeTe51M25MmxAX1scvvoKD/vi6f1
	sJ9nVYZ7EjD6gXMu+Tf1eo6NO9OqkKXQ3NLkA2uyItwa+rcnv2KbRQ94dwRh45aIIpL0vjo5Fhn
	SRZDEX4mgCZzHIlDpDdA0Jysy89qy+Q0rHAaGL4dSxynnBajzbd8cVaV9m0NqD6mRYnm4n5tu9T
	9MtQc3k7jJ3kx9drspKcNtTqb5weftk=
X-Received: by 2002:a05:600c:4f8e:b0:43d:1bf6:15e1 with SMTP id 5b1f17b1804b1-4405d765a54mr5694495e9.1.1744792035969;
        Wed, 16 Apr 2025 01:27:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGwPFJqXXTVSiQ2GMCBJHSF5TfETJyPBEJnz6n8uiOKGphxkdYeHeodWG2ziOrblK/oIsVrsw==
X-Received: by 2002:a05:600c:4f8e:b0:43d:1bf6:15e1 with SMTP id 5b1f17b1804b1-4405d765a54mr5694275e9.1.1744792035509;
        Wed, 16 Apr 2025 01:27:15 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4405b510a9esm13875695e9.29.2025.04.16.01.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Apr 2025 01:27:15 -0700 (PDT)
Date: Wed, 16 Apr 2025 10:27:14 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "user.mail" <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, aalbersh@kernel.org, bodonnel@redhat.com
Subject: Re: [PATCH] xfs_repair: Bump link count if longform_dir2_rebuild
 yields shortform dir
Message-ID: <svae5kylidq7qa2ntbj42pk3purrlkm3xron24i5y3cpdadxgg@62vgk3bxgauq>
References: <20250415180923.264941-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250415180923.264941-1-sandeen@redhat.com>

On 2025-04-15 13:09:23, user.mail wrote:
> From: Eric Sandeen <sandeen@redhat.com>
> 
> If longform_dir2_rebuild() has so few entries in *hashtab that it results
> in a short form directory, bump the link count manually as shortform
> directories have no explicit "." entry.
> 
> Without this, repair will end with i.e.:
> 
> resetting inode 131 nlinks from 2 to 1
> 
> in this case, because it thinks this directory inode only has 1 link
> discovered, and then a 2nd repair will fix it:
> 
> resetting inode 131 nlinks from 1 to 2
> 
> because shortform_dir2_entry_check() explicitly adds the extra ref when
> the (newly-created)shortform directory is checked:
> 
>         /*
>          * no '.' entry in shortform dirs, just bump up ref count by 1
>          * '..' was already (or will be) accounted for and checked when
>          * the directory is reached or will be taken care of when the
>          * directory is moved to orphanage.
>          */
>         add_inode_ref(current_irec, current_ino_offset);
> 
> Avoid this by adding the extra ref if we convert from longform to
> shortform.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: user.mail <sandeen@redhat.com>

I will drop this SoB when applying

> ---
>  repair/phase6.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index dbc090a5..8804278a 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -1392,6 +1392,13 @@ _("name create failed in ino %" PRIu64 " (%d)\n"), ino, error);
>  _("name create failed (%d) during rebuild\n"), error);
>  	}
>  
> +	/*
> +	 * If we added too few entries to retain longform, add the extra
> +	 * ref for . as this is now a shortform directory.
> +	 */
> +	if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL)
> +		add_inode_ref(irec, ino_offset);
> +
>  	return;
>  
>  out_bmap_cancel:
> -- 
> 2.49.0
> 
> 

-- 
- Andrey

