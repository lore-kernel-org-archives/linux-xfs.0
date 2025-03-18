Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3C4202997
	for <linux-xfs@vger.kernel.org>; Tue, 18 Mar 2025 10:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742293897; cv=none; b=kQRLyLSqinJ6xKZw4UnzC5B/G5Jr4eEN/4BVr4L6LJ7JzqJt/kHQQ4aBtkaBU9PaUvErgqgMHUJylEmhoqMQD0GhaBnH5uD/6lgJWmQjk0FY7PqDkGrvO7cEjOy2F0ndn+tK5sGhwh0iErl4WnZtPiwslZ9P/wXeOqa7dbE+xOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742293897; c=relaxed/simple;
	bh=ZZLMWcWGweFl3XGZvpVrYN0GFG0tQUpMCRn20qEkEk0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YDHD2GBOyB4YKhWplJ3PaoOy1fXSsVxwfg4PiMPXVA2XQLvDV6DWe8cS1z/v5T5TM4Y95sx4927bhgYuFRI34Phj20kognerf1BrKTTr1kaVMCD5Wn08EoXImT9QJNKJC08RgRCzfJOlhPrkT87yYBCGLXZVszb6WaXoeEHvHFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Uxc7QPW0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Uxc7QPW0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742293891;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rKwNA0LJgjEkuWXa1Fp0dlmvJtilzAhm+XTC0OfygHc=;
	b=Uxc7QPW0R4b+16cW7aw225SydWlvDHlILckIsOpLWp9J+d7bOknlD+BwbBBXyMmeEjC0vK
	Opk8E9l1NIoA0yNg793yH30c3wmWsxp6KzwymQA5vf5pjPONiqEjctNixiflTepNfr51Ko
	ND+bL/pTBXWFjcksubaX+MiU0NmOK2Y=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-618-TSXJHfn2NW6_xr4EmNktmg-1; Tue, 18 Mar 2025 06:31:29 -0400
X-MC-Unique: TSXJHfn2NW6_xr4EmNktmg-1
X-Mimecast-MFC-AGG-ID: TSXJHfn2NW6_xr4EmNktmg_1742293889
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-39130f02631so2642977f8f.2
        for <linux-xfs@vger.kernel.org>; Tue, 18 Mar 2025 03:31:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742293888; x=1742898688;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rKwNA0LJgjEkuWXa1Fp0dlmvJtilzAhm+XTC0OfygHc=;
        b=YhdrGrKS4sL2aT9eP4K8RhzTyP2YLz7osUo4/SS4hdPpqSZ3HrVcGCDVVCp55FFqgt
         JxZa/89swkwxLuoBEudO7X3jWudXdcIpddPHT2YV+VcV9gOAMkUXSdAfKFSRQip2cYL4
         egpdEFKCZiQVAnAhwpynpzQoBpCZH6ogNbWcUz9ykXmgxDFnua9MbXQtoW0/yQ1zDkk1
         lkycAJBm3lpzZGwgab5zykonKsPb5MIFvjLM375akLGr5fOqO1v37SIqZn9hze1N2oIX
         ku/DBnbf53WZ8yneWS7g5GSrvan7sVM9WccDT5GM8bR6hcp2joaZI+DMHxgGA7G1pg5c
         mXbA==
X-Gm-Message-State: AOJu0YxQQbypPOmr0rg1bvF+4Ztm0+3AF3z9BEVO3U134rs0Up5dVJgv
	DqVhVwtjtIEzLqD0zqp22snZEeCE39bLdYraVLa6ehAQH26QuAVssimcsLPX8SrsNvkqtw2iJ98
	/34OVspOCn/4IQK8m/rOPoK/OTVvfBxTi2HcJ4FItm65rYu/l8JGdXFFd
X-Gm-Gg: ASbGncsEMBRakvQf4HsvklzDktagbu87ZADhbp4VB0yYTd6p8rSYVdg+cKLspyrvSlD
	/phGvlfJDTPap7WdgHt+zXFywePAbvcC2CxgzYnuGZRK1mLAZTNS6Fq3VtiKfIJLIBkS+Dl5Z2X
	aPTqY6eWyT2gGgHnf024hX1yEZzjKRpocRZecPgWud87AyQGQN+6FRv9LtrSrMYcaXuGBdOSzsG
	w6JxhmkDwhNpGlL+12b2/LO0MNCCtduoX/r7inFqcEarmSbJsdNnwyiv+UumFmGjT80EOiUGtwf
	58U+oGIPF2fKpyZVJv+dAW73VsdguXzsEyY=
X-Received: by 2002:a5d:6c65:0:b0:399:6b22:a98e with SMTP id ffacd0b85a97d-3996b22a9admr2951095f8f.21.1742293888623;
        Tue, 18 Mar 2025 03:31:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGNWjiiG2UB164+QLMVQc1VLkG4nMDWtF/7zGZ2EHXTTA/IqgXPsZWhu6ed/MSpw3yrfWR7UQ==
X-Received: by 2002:a5d:6c65:0:b0:399:6b22:a98e with SMTP id ffacd0b85a97d-3996b22a9admr2951070f8f.21.1742293888268;
        Tue, 18 Mar 2025 03:31:28 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395c7df3506sm18222503f8f.11.2025.03.18.03.31.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Mar 2025 03:31:27 -0700 (PDT)
Date: Tue, 18 Mar 2025 11:31:27 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Yureka Lilian <yuka@yuka.dev>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] mkfs: fix build on 32-bit platforms
Message-ID: <yo2uzy6o2eghyo36yw23c32ug4yfgwua4mchkmqdz4nvgn7pev@k3radqctjvja>
References: <20250318095410.198438-1-yuka@yuka.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250318095410.198438-1-yuka@yuka.dev>

On 2025-03-18 10:53:35, Yureka Lilian wrote:
> Fixes "proto.c:1136:1: error: conflicting types for 'filesize'; have 'off_t(int)' {aka 'long long int(int)'}"
> 
> Fixes: 73fb78e5
> Signed-off-by: Yureka Lilian <yuka@yuka.dev>
> ---
>  mkfs/proto.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mkfs/proto.c b/mkfs/proto.c
> index 6dd3a200..981f5b11 100644
> --- a/mkfs/proto.c
> +++ b/mkfs/proto.c
> @@ -20,7 +20,7 @@ static struct xfs_trans * getres(struct xfs_mount *mp, uint blocks);
>  static void rsvfile(xfs_mount_t *mp, xfs_inode_t *ip, long long len);
>  static int newregfile(char **pp, char **fname);
>  static void rtinit(xfs_mount_t *mp);
> -static long filesize(int fd);
> +static off_t filesize(int fd);
>  static int slashes_are_spaces;
>  
>  /*
> -- 
> 2.48.1
> 
> 

Already fixed in for-next branch [1]. Will be in next release

[1]: https://web.git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/commit/?h=for-next&id=a5466cee9874412cfdd187f07c5276e1d4ef0fea

-- 
- Andrey

