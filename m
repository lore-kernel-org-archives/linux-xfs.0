Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1EBF14B070
	for <linux-xfs@vger.kernel.org>; Tue,  2 Apr 2024 16:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712075213; cv=none; b=GXfPAZS1D6dEpdqkoaV/G5bJYmSfVIo2rFUk2kFBNttdlUi1ScOsiNhf67cLyTHVzzGDSE9mEaSH2pBcQjKI8V0nMTCYZ6Laz5q6Xx7wDW8Ru9ChSccg3NTwJyVaxOQPCwrzhILKHgDLdRSX4/yT14nUW2U+eKrpU4JRLYH1tMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712075213; c=relaxed/simple;
	bh=F5+iyGUCvQpuV8lv12EAHUDCmUU3i5EFr4dh4MbLXwQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bSAnHLUUrtlEQtdiINObOg7XfsYLtxVt168TQxparxy13pf/fVBU3WqjYg1tawSdMNx4dJI6QpWB7RgnnTKBlyYjzC9dhLUEfVU7MteiDoLAcERNRBAwdGohQ65C3F695iOeR7ugBBaP+c0ipHpabx9hNPvoExti59WK8UKO93Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H3qNaJE0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H3qNaJE0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712075209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7TpGFn21m1i2uNjneulzVfYfTm+8lK5ZR+k7A+k840E=;
	b=H3qNaJE0/eHrNDRcntWhOsyyjsb7I3r7M9z8wr4fX6ry+Yj8KU6MpqSy9thKMIhknsfZuH
	fJoAN9zoQUZW/BC+OgbyLoVquz8J+TerYUxpLkjr314cpwrfrWKf6edbAIcMij+oJRZy+d
	RN/UjntLli9l9pxi2MZ8POnV9EXoWO8=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-WblnGkV8MgOZc4sRa-Zqag-1; Tue, 02 Apr 2024 12:26:48 -0400
X-MC-Unique: WblnGkV8MgOZc4sRa-Zqag-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a466c7b0587so375194166b.0
        for <linux-xfs@vger.kernel.org>; Tue, 02 Apr 2024 09:26:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712075207; x=1712680007;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7TpGFn21m1i2uNjneulzVfYfTm+8lK5ZR+k7A+k840E=;
        b=Hjvn3tWv09M1SCJnfufEtEdUOY3hSi2sVP+srxklBsoZNe6SiWiINLGkWpwKVUHwpI
         +tmHniZRoP0xVIckGELhwh/alhiFeuHHgsTZfsvrIMV/3J4bWg3aklEGXBBiJlJqzQtO
         V0nyt7Mef9iiTcHrBseoXJF6P+Z0FDtK5t73ec/sMafjIjapvwWobZDEPTk2iFjpBV2K
         UaPoWxbPPVz2mzcNn5oH8tX6A7kwzw+Hgve6ivZW6DxdeuYNafVssqic3jtJIwK1/kNh
         KixvuEda83hGvgN6j9F6ffyiJzkdnO+9McY//7yAwOgKJGaCX2xZFDzHimIoMegHmdIY
         RLtA==
X-Forwarded-Encrypted: i=1; AJvYcCUeVWTZ3zhJJgYN2ZtMhHDbkL/RFHbPWCLoYKob68oNbqg6dGQUHmGw+LXS008giA5FxHzZusQqqsg4WbIu/V67BBx3fvPqLw4D
X-Gm-Message-State: AOJu0YwmjEjcxn8byWrAeo4hYKq9k+Htu185ZDNAqFa9W85znzA0Mdt6
	hgtRaVcbxNpqndk1ziztjppmcnGknw610YR12xCdBmXbD3F8KobOaTsjy4ZbauVlczQmd/SflBf
	LBkbfVvQ9pdgb8wvSmRmWwoxD7q8LJTpQkL7G+cAt6nwYxpUpUBymXhcU6ItiXn19
X-Received: by 2002:a17:906:1390:b0:a4e:3a09:4854 with SMTP id f16-20020a170906139000b00a4e3a094854mr179148ejc.61.1712075206747;
        Tue, 02 Apr 2024 09:26:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGbgALg3k0jk88bFML2ntWceIt+4WbChdRCLZb4p2oD8DsKtXsq8JdftPPwH7GoLWKYGoeFWQ==
X-Received: by 2002:a17:906:1390:b0:a4e:3a09:4854 with SMTP id f16-20020a170906139000b00a4e3a094854mr179128ejc.61.1712075206163;
        Tue, 02 Apr 2024 09:26:46 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id bw17-20020a170906c1d100b00a46b4544da2sm6658587ejb.125.2024.04.02.09.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 09:26:45 -0700 (PDT)
Date: Tue, 2 Apr 2024 18:26:45 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: ebiggers@kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, fsverity@lists.linux.dev
Subject: Re: [PATCH 26/29] xfs: clear the verity iflag when not appropriate
Message-ID: <smmx4hendu6fbin2kcuowsmlvwjm2nmqk7bd3mce65qawpf4ej@5d6demmjry5e>
References: <171175868489.1988170.9803938936906955260.stgit@frogsfrogsfrogs>
 <171175868990.1988170.5463670567083439208.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171175868990.1988170.5463670567083439208.stgit@frogsfrogsfrogs>

On 2024-03-29 17:42:50, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Clear the verity inode flag if the fs doesn't support verity or if it
> isn't a regular file.  This will clean up a busted inode enough that we
> will be able to iget it.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/inode_repair.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> 
> diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
> index fb8d1ba1f35c0..30e62f00a17a6 100644
> --- a/fs/xfs/scrub/inode_repair.c
> +++ b/fs/xfs/scrub/inode_repair.c
> @@ -566,6 +566,8 @@ xrep_dinode_flags(
>  		dip->di_nrext64_pad = 0;
>  	else if (dip->di_version >= 3)
>  		dip->di_v3_pad = 0;
> +	if (!xfs_has_verity(mp) || !S_ISREG(mode))
> +		flags2 &= ~XFS_DIFLAG2_VERITY;
>  
>  	if (flags2 & XFS_DIFLAG2_METADIR) {
>  		xfs_failaddr_t	fa;
> 

Looks good to me:
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>

-- 
- Andrey

