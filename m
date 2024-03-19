Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0FD6519D
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 14:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710860397; cv=none; b=Pbywt4IbdhLl7IOCD8HGNCMVRPe97Q9KOCUebWWmI4Uut/fkasqyWY3Pixdi814gAgAMUOiHUgqIs5ya9TQyBky0G+Sgipf2eXvUznxdc4AYpwW6Pqbi9ARtoIMe8ByCn4K03NnBsW1jmrmp55Gm90DfJ1AzI+r+b9dH0thfQ0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710860397; c=relaxed/simple;
	bh=ajxpaMC3T8IunaZ5P+9lA5RJwsCq/EAHYOIJkPgl3hw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OrQ8zlxYC53BHGXnYhoc/i2Lcm1iVLt+whAcwZysY/6GZk79DN0aZvBsGDi49TmxLnWYswAC7BzJvXulk2M7qeeCrQPu/0aGk8d3KAWR/0vwafk4Noq12Py2NMOmKqcshdqq9haf5Ij/Srxgrh8xG9c78mHKa9FKR1X/kQQLUTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ftQkLnC5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ftQkLnC5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710860394;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ia2sWuwHy79VhH6nPO9UUd5RJV3cIBJb+5/X2TNMkJY=;
	b=ftQkLnC5O/Dmjtes3F7rp/e/yek9cX4Pv2Ds+azFcwA1dsugi6SC2vD2zlMQeH9HV7oi1Z
	YAQt88tugdPVggNK3yPax8fPKMMD7cyNJU75dDDi0iv1f0mbVsioKcVnmQnNgrOiuLS+xs
	6wzK2EYOKznDQWZrmX7uCtzKg/cyq+8=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-132-DoCGF8ifPcSHzGHelhS0Pw-1; Tue, 19 Mar 2024 10:59:52 -0400
X-MC-Unique: DoCGF8ifPcSHzGHelhS0Pw-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a450265c7b6so313544866b.0
        for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 07:59:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710860391; x=1711465191;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ia2sWuwHy79VhH6nPO9UUd5RJV3cIBJb+5/X2TNMkJY=;
        b=PN8iKCoLBRXCVCsjFioMll2UkWZGXMqhQIeUvcBcRki4c9FXnrIJtWd3Tp/+FyWoF1
         lyf4io9p9dIKqp4WbP1yo5J22xDWHCwJz84172Kec7UWMkw5gJ7gjgokEv7go/65Of2v
         cLI5AYKIcfUQldkc48g3y0qPFXgoLK8JTonMNk7HYagLy4ksHMN9GLAEciSO3CSKN4pu
         V4OOdGninyc7Bn4CE38UMhi5+y93tPPMDcyrmVJfv36e5hOiAWjP0UrOXz/X3Y1eZYZ5
         c2E0MO2Qr5FD/jKaqOz1Nvz/cZ542GSpQGrdeT1W9/gLE8NLn7Ntflqvm3IknUDEClw3
         VjNg==
X-Forwarded-Encrypted: i=1; AJvYcCU56WVA33/6VF44I8ckgvlsu2h4mn8qlfJDQnwkJaTfnY7DtCJYcYkVmj7/lLit6i/ICHn0CtfIIbprRSRA19HJTLaQhSH5sPDs
X-Gm-Message-State: AOJu0YyiX16SzKPzQ8INry8s+03M9+EubtGuOosJoW8oBx/3X6RwZ2tO
	GjY8yD1pzt84w8lyZxAIifRektN0jzYAY9bN+uZ5Xf/PRgrzNBM8jnWs5KZubDKxE0OCkwqHNkr
	Khuj6+/xwZ/ll93JvfhwKas8ejk88yb+VS9QgTyBz7zwBOQNICiVR2mk3
X-Received: by 2002:a17:906:bc95:b0:a46:9b71:b852 with SMTP id lv21-20020a170906bc9500b00a469b71b852mr1799577ejb.26.1710860390633;
        Tue, 19 Mar 2024 07:59:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHGkhUvQ74NDR8xixLTTUY2PjtMB1t6xn8SFEqwr9V0Tb0eFn1ewzSnxrxKXEH+0uqKR3BI3w==
X-Received: by 2002:a17:906:bc95:b0:a46:9b71:b852 with SMTP id lv21-20020a170906bc9500b00a469b71b852mr1799556ejb.26.1710860390115;
        Tue, 19 Mar 2024 07:59:50 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id nb33-20020a1709071ca100b00a46da83f7fdsm1040601ejc.145.2024.03.19.07.59.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 07:59:49 -0700 (PDT)
Date: Tue, 19 Mar 2024 15:59:48 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: ebiggers@kernel.org, zlang@redhat.com, fsverity@lists.linux.dev, 
	fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org, guan@eryu.me, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs/{021,122}: adapt to fsverity xattrs
Message-ID: <qwe6bnzuqkmef5hpwf6hzv5ce447xij7ko67vvasjcnzxy4eho@xnvyvawp5mba>
References: <171069248832.2687004.7611830288449050659.stgit@frogsfrogsfrogs>
 <171069248865.2687004.1285202749756679401.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171069248865.2687004.1285202749756679401.stgit@frogsfrogsfrogs>

On 2024-03-17 09:39:33, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Adjust these tests to accomdate the use of xattrs to store fsverity
> metadata.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Is it against one of pptrs branches? doesn't seem to apply on
for-next

> ---
>  tests/xfs/021     |    3 +++
>  tests/xfs/122.out |    1 +
>  2 files changed, 4 insertions(+)
> 
> 
> diff --git a/tests/xfs/021 b/tests/xfs/021
> index ef307fc064..dcecf41958 100755
> --- a/tests/xfs/021
> +++ b/tests/xfs/021
> @@ -118,6 +118,7 @@ _scratch_xfs_db -r -c "inode $inum_1" -c "print a.sfattr"  | \
>  	perl -ne '
>  /\.secure/ && next;
>  /\.parent/ && next;
> +/\.verity/ && next;
>  	print unless /^\d+:\[.*/;'
>  
>  echo "*** dump attributes (2)"
> @@ -128,6 +129,7 @@ _scratch_xfs_db -r -c "inode $inum_2" -c "a a.bmx[0].startblock" -c print  \
>  	| perl -ne '
>  s/,secure//;
>  s/,parent//;
> +s/,verity//;
>  s/info.hdr/info/;
>  /hdr.info.crc/ && next;
>  /hdr.info.bno/ && next;
> @@ -135,6 +137,7 @@ s/info.hdr/info/;
>  /hdr.info.lsn/ && next;
>  /hdr.info.owner/ && next;
>  /\.parent/ && next;
> +/\.verity/ && next;
>  s/^(hdr.info.magic =) 0x3bee/\1 0xfbee/;
>  s/^(hdr.firstused =) (\d+)/\1 FIRSTUSED/;
>  s/^(hdr.freemap\[0-2] = \[base,size]).*/\1 [FREEMAP..]/;
> diff --git a/tests/xfs/122.out b/tests/xfs/122.out
> index 3a99ce77bb..ff886b4eec 100644
> --- a/tests/xfs/122.out
> +++ b/tests/xfs/122.out
> @@ -141,6 +141,7 @@ sizeof(struct xfs_scrub_vec) = 16
>  sizeof(struct xfs_scrub_vec_head) = 32
>  sizeof(struct xfs_swap_extent) = 64
>  sizeof(struct xfs_unmount_log_format) = 8
> +sizeof(struct xfs_verity_merkle_key) = 8
>  sizeof(struct xfs_xmd_log_format) = 16
>  sizeof(struct xfs_xmi_log_format) = 80
>  sizeof(union xfs_rtword_raw) = 4
> 

-- 
- Andrey

