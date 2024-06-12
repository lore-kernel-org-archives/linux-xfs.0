Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8EC153BE4
	for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2024 07:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718178686; cv=none; b=MImcnr8r8vKxYZziKREGiF4RMEDJixB7GULp7/Oi9xnyrL8G+wGBH92gUOBSH1tfVnt7pB60hau9RGfDOdvQYBK+px0co0haqPZ+a+yWHOh+XHUb5912Q/a8FTCyaDTovedKidZI/bKyAUYlnb9/0yPZ9BdQt8H4xMQkMHJ2iOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718178686; c=relaxed/simple;
	bh=sZYtzv4VmPJ9VIAC4vjHYxiewwXiUUTn7ioIQRg72b4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sfl3FZbZz/YAMghBtyb5JNfuFBccJ2bWiSL15jv3U/fNBjG0RUhnNn7ZAh66dQ2JTzM33ZHBw+B2ZQZoZ/i+mzSsOcwsW9ppUMsvv+WPyACT1dI3/agzdNezRuDTLLF/Hheuykf0PK9IdfIwlaId43lykAdXHzgStEZIYvzEMJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=afGEamsw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="afGEamsw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718178684;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xIaaK6W8uT5BSnueoPNeLW1MUPaP1VwOj2mmYxfHPko=;
	b=afGEamsw/DpL3yf75ecX3imjIrunbigjU7BIDibFGHWCpF3/6JFZ5DuWQUrWmjEiLNn6vG
	fs0zcWREBYia516OpRkqJaKKtb7lDQzJLHFkYXcaTklJj/acrCRaE6rPdukw56NtucCUXs
	pyRqP1ybcB/4LHgK3JWL5RyO3KdwUT4=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-441-X-5h9zUCMFGifGpiDreSFA-1; Wed, 12 Jun 2024 03:51:18 -0400
X-MC-Unique: X-5h9zUCMFGifGpiDreSFA-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1f71d5a85f9so17043475ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2024 00:51:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718178677; x=1718783477;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xIaaK6W8uT5BSnueoPNeLW1MUPaP1VwOj2mmYxfHPko=;
        b=F90FE6bBc+xRVvKgbNckPgR6s4hkVZWCDc++5Uu1eE8tfX1ESn5isxucfCdeCfds+j
         QGvS5GTuKZXJeDTJH/LvOm7+ZOq1cseo5CQ+FFlC6OPz4vQKKvYA2+COqH7zGv+l/1JL
         tYP4f58IN+ECsX1nayMw3eafbs2FzqonLG48FwLTQspcbCwib91qZ3rlZ/9kqEjih1in
         /3w9yhhBRYYvNQAKaAOaBnOhrl4L0hRW3V4j6ZnOarHs55Lk2zq5GAL+D7s5oVJ0mU9z
         QWxvJRf51Fc5b3eQARtcrp1vTm03nHSyoU/58BpOsaeTgZMUTWDui+IqlHSj5nd40G+Y
         xNLg==
X-Forwarded-Encrypted: i=1; AJvYcCXdauEjWNpHl3U0hhj9gyhLm1EMV4+4G30lSaM3aehHioDklMcIQREcgi+smSdsgaVaGY+Ig134JlDD4ZRRqXSBzNuWEsOOPQ/X
X-Gm-Message-State: AOJu0YwT6QoQpqiki2oWdxym1vPoNZi0OqAWrr8Pb3ng/klSzms1RvsH
	CM8ba7PDIBWMpunucO4j1LnGxg4yrU0oMowxKew/wvqQn6oQV0KrW25cq62DPtu+1cKcXkz1heA
	4mnJ09Pj6Um0OhkEzDumQjYiU26ih+BLv0aK2QKpwW+4ks+yfV2y1xjFU4g==
X-Received: by 2002:a17:902:d4c7:b0:1f7:1525:ddfc with SMTP id d9443c01a7336-1f83b56bcf9mr11315755ad.20.1718178677076;
        Wed, 12 Jun 2024 00:51:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHMX7aSBeEp6lKbXd+g1sAM5yfWtpI+0C98OJ7FfMPgAute/8BdN1T/JNbfc807HHvAghLdtQ==
X-Received: by 2002:a17:902:d4c7:b0:1f7:1525:ddfc with SMTP id d9443c01a7336-1f83b56bcf9mr11315425ad.20.1718178676391;
        Wed, 12 Jun 2024 00:51:16 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f72561cfb4sm35303155ad.268.2024.06.12.00.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 00:51:16 -0700 (PDT)
Date: Wed, 12 Jun 2024 15:51:09 +0800
From: Zorro Lang <zlang@redhat.com>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: patches@lists.linux.dev, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
	ziy@nvidia.com, vbabka@suse.cz, seanjc@google.com,
	willy@infradead.org, david@redhat.com, hughd@google.com,
	linmiaohe@huawei.com, muchun.song@linux.dev, osalvador@suse.de,
	p.raghav@samsung.com, da.gomez@samsung.com, hare@suse.de,
	john.g.garry@oracle.com
Subject: Re: [PATCH 4/5] _require_debugfs(): simplify and fix for debian
Message-ID: <20240612075109.b7omu4pipo2p4sjx@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240611030203.1719072-1-mcgrof@kernel.org>
 <20240611030203.1719072-5-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240611030203.1719072-5-mcgrof@kernel.org>

On Mon, Jun 10, 2024 at 08:02:01PM -0700, Luis Chamberlain wrote:
> Using findmnt -S debugfs arguments does not really output anything on
> debian, and is not needed, fix that.
> 
> Fixes: 8e8fb3da709e ("fstests: fix _require_debugfs and call it properly")
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---

Thanks for fixing it.

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  common/rc | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/common/rc b/common/rc
> index 18ad25662d5c..30beef4e5c02 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -3025,7 +3025,7 @@ _require_debugfs()
>  	local type
>  
>  	if [ -d "$DEBUGFS_MNT" ];then
> -		type=$(findmnt -rncv -T $DEBUGFS_MNT -S debugfs -o FSTYPE)
> +		type=$(findmnt -rncv -T $DEBUGFS_MNT -o FSTYPE)
>  		[ "$type" = "debugfs" ] && return 0
>  	fi
>  
> -- 
> 2.43.0
> 
> 

