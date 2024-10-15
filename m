Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D4E1BF58
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 00:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728953535; cv=none; b=LxQzsc3f5WqzvrEZWeUt3iAFSiebz4U84QCPrE23r2sAZQEOh6CznOASpPEHezhCMWdjV0nyiYhRBT465PJnAOBz3oUeVzhYKo8Qc5sfRu0KTya3te1CJygeOu45Y1J8iN9y30mUpxLc6NzwOSUq/u96TlOR+py/UunENyHBcFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728953535; c=relaxed/simple;
	bh=prObU9/CPJVXUdCVT0yQMASI5BbOfMqGaGPm2QSgbJc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c17NtDEb7PE3z7ExnHuR7oo4zUc7o0msXlX07T08YumJeCXLevKkmwfhjeXpjEMcztjie8Zu9jznjwJHeS9GaXuypB/KjHbLgxcu7BH0iUeHWb2s9fuOUVYD3HuAGEE3tfXK5Kov0XNf1NU8fXLBy69MZykHh8edkfnGYLJFcaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=xaQWPnoC; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="xaQWPnoC"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2e30fb8cb07so1935823a91.3
        for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 17:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1728953533; x=1729558333; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=V/0tpPAazYMgVTNaahnI5P7lfKW0ti3bYAnOjbFYeCA=;
        b=xaQWPnoCbawlzXcXPUofuMRnFiRX78bIpOGJdscyenK96SfeZ/S93gReii18UAEZfN
         b62jKs/ghaipmp+ZPAc6KgiBzkqWlhpwKPURIzVjaaMmVwUtkQ+4bVqU7gXdApy7VZjk
         iqTJ2U6IyKo3U6MlLbwpa0mH+aeOa/vs+4GGRvyK294GPB7R8T+fKVY6IgatY/ccK/l6
         K1PN10SramdyfTjI7OYYBzrfL6loTdMnqb7Xka0J0gbXdwl7xu09tIt2h0K005JKfvsA
         y7b+Bu4C5pDytmXLuVHlv7PlBSkuNStRL1TQKB/RWWzLNqqOAqELdD6x0sd+vdtHwZMB
         3RhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728953533; x=1729558333;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V/0tpPAazYMgVTNaahnI5P7lfKW0ti3bYAnOjbFYeCA=;
        b=BSf2GCz+H7UwjmM29rSbloaaN90zpQ5ilR8W5tl87VZOBooPb/NCqyau4wOPxaFkmS
         SZ7b2iijeMhnTsU75v+kMxyh1CtfcGbMNHZOvPYF/UYRgqYPKwofgex/c/rGa90sTsSh
         mcH3OGRbgzQyAAbIIduwxNT5prq3zZMoJwaUza53RjZO96dTc/sCWJQjf0A451X7LIzQ
         5i+hLst70HnHCGlkEw94ctCoDAZtBgDJI2CmU0UkbCwcZnBZIXkuY+P7jQSoYhM4PyPV
         iqN8FM3QgolnFZ/IFCQsDHg15v/YAB9sWNqyaGKDkxlrjkSHwfxdJdKTthI1bpbLZNVQ
         s6DQ==
X-Gm-Message-State: AOJu0Yy02ehPV6z/juB+sWMUKU7DMSGO4fmS6jEIV6YeuAVLDm0KgsJE
	pN8FXtWC7PKat8FM8rJmOMiEB2ECPAC5yK8qBvL8OsgrRy1c3SlifvqWcaAVkTQ=
X-Google-Smtp-Source: AGHT+IGWNcCAaTOKU84fljRrUvMYOTPdoKF4ZC7fhsf0Ix01cpsuyMZmVN0nuKM97wrdNQzmBBAm2w==
X-Received: by 2002:a17:90b:b03:b0:2e2:8349:239d with SMTP id 98e67ed59e1d1-2e2f0d7a8b6mr14760299a91.28.1728953533274;
        Mon, 14 Oct 2024 17:52:13 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-209-182.pa.vic.optusnet.com.au. [49.186.209.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e392f747b0sm177900a91.51.2024.10.14.17.52.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2024 17:52:12 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t0VnG-000us5-1Q;
	Tue, 15 Oct 2024 11:52:10 +1100
Date: Tue, 15 Oct 2024 11:52:10 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 02/16] xfs: factor out a generic xfs_group structure
Message-ID: <Zw28ugUCTXtRLFWS@dread.disaster.area>
References: <172860641207.4176300.780787546464458623.stgit@frogsfrogsfrogs>
 <172860641288.4176300.12597066672597648144.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172860641288.4176300.12597066672597648144.stgit@frogsfrogsfrogs>

On Thu, Oct 10, 2024 at 05:44:42PM -0700, Darrick J. Wong wrote:
> @@ -232,9 +276,9 @@ xfs_perag_next(
>  	xfs_agnumber_t		*agno,
>  	xfs_agnumber_t		end_agno)
>  {
> -	struct xfs_mount	*mp = pag->pag_mount;
> +	struct xfs_mount	*mp = pag_mount(pag);
>  
> -	*agno = pag->pag_agno + 1;
> +	*agno = pag->pag_group.xg_index + 1;

pag_agno(pag) + 1?

>  	xfs_perag_rele(pag);
>  	while (*agno <= end_agno) {
>  		pag = xfs_perag_grab(mp, *agno);
> @@ -265,9 +309,9 @@ xfs_perag_next_wrap(
>  	xfs_agnumber_t		restart_agno,
>  	xfs_agnumber_t		wrap_agno)
>  {
> -	struct xfs_mount	*mp = pag->pag_mount;
> +	struct xfs_mount	*mp = pag_mount(pag);
>  
> -	*agno = pag->pag_agno + 1;
> +	*agno = pag->pag_group.xg_index + 1;

Same.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
