Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33802836AF
	for <linux-xfs@vger.kernel.org>; Wed,  5 Nov 2025 18:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762367837; cv=none; b=YDNYnPdmErkxQty60Ofeo0Xf0c5N+/Md+rq6Yo4oYFu2teyBOCPnUzurni8IybOOOH2Nx+HWo4kCEY0nZuAboNZuY0jPQ6mQRIGPgfOgzc+T3lvafVxKq6qn1r6r4CPn8GgjahyiNzLEM+EKJ7KoBQG7Lsd/8uuOkRdEOa5+8Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762367837; c=relaxed/simple;
	bh=w1KYQIP//0eBMv4//DhZ5KFx9PNW1UPFH7nnebTruwA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P+dhmMx6jUZc8av7CWB5/Lns5+/Ch5Dxt/8O7cXlvndVo4eAdhaUAEGLxVXVh9BRPBwpf7zrLAXUdhaWM3sSQJPL4iEFGiuXDS/MJljymBUVMU88SQZtwfdLo8TIqmItxwXeSl++l/xN+oihrDYiHxe7gSOfpgm2Dp4C+sEhuMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fYVCN4Of; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fYVCN4Of"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-429bcddad32so104459f8f.3
        for <linux-xfs@vger.kernel.org>; Wed, 05 Nov 2025 10:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762367832; x=1762972632; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wVms5zHRqmmTEZveui8rFB3VRHHPz5yVXKILCesT61s=;
        b=fYVCN4OfbHIr8B6q0Fi2RkHSRnuiG8B6MV/syAoNmWfmZuE8ZlusEVg3Pxq17sxR2v
         7AkJFhY7iCk+P/zK0QeVYfM3eWMSeeYDlikkK639vYgdmNG49juLIQskyq3AZY6yMYjx
         yTev4+Oj088dMF8IXyH2XTXsnz8C/6Eh3kSn9HIovoxccDTgbLnSmWSHcQZ+WNckNFiK
         lCaMSfbb7ZZoq+2+O9PX8PodM/MiZP0K/rYwn/z2RdZo++j2yZBUqEJfQZpV/HGQLTQH
         zhanoIv2dkwGV4Pe0knKElXwBIAVqJqXT6PhTpFHxfSlSI/40HlRhhEC+nRYsoGS3n/h
         UT0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762367832; x=1762972632;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wVms5zHRqmmTEZveui8rFB3VRHHPz5yVXKILCesT61s=;
        b=vpgH3Q+NX/no1lDROhj3luCoz7Rhka29B4MeXGOEpALmCuUBZPJhifF/Be9ffHjcD/
         1lbb6N3vccCGOH6EFcU3Jlac7wH7URRZA0OYsxthNZlMs1FFujYDOExj07JIOqUsspCm
         C4jAwuLj2KgSqPrqUlFnfp9N/AibK7wADNr/+BHZpQ3K0vrBtodfUQJO/Nr0yvXm6Poo
         5U6R1CN5T9TnecClGvLLKyVXlWizYgRkARO5qfRuM2fZEx/Qlrq7zZ5FpK0BT4mtvkvk
         EqvlV/zN78ts6iAPHW+Nl0jaokvTH9iA/Ug/hDbZQs80w6OC30sWRlwX88XxuCy6PXFX
         HHaw==
X-Forwarded-Encrypted: i=1; AJvYcCVgFcCHfbcQeSDcQDvXw+/7gra/BrlwQIO6rXzc3w3mnuKh89Zqf0XqYgBIXyf/ncbUDFerztKNrIE=@vger.kernel.org
X-Gm-Message-State: AOJu0YykDzKT/m9R6puTTWnbYoiOAoW+zgOorEPpRrX7fIf/sYWBGsMV
	MqP7TpRIIHfLcUlLjZKXzmh8gyTptOz+plRob1A0qi/+9Ih7D67P27F4jdjzWf/Iv+qtDysJj/g
	iAxCUQVvKzR5ZJ1iUukx8iSMwBxaV7zXTbYtHRrqelQ==
X-Gm-Gg: ASbGncsuDY9dQqsLc/M1WV1Zm6sbxdzdW+cNjwi000NfmcaL1UqFBB4ZsRfDc7LJB5f
	FyIcvezCKJGe5+wn7z5OEi3BfGF9tD1HKdMO+cTbs8WbQ3gHEYr7YNLkzhQlWcud972YjgMZoRZ
	htZ+ae6MclfBikMztnYejNfwZOe5c7hhtvSvb03y1BAQevaas0L/GuvQFRaDme2UMfLZ/Qk1Xx6
	Td7E9jaGmeGyTm4dSzX6pOIp62I3HqLSut6rnVtvp6La9ggBk9sw/oWaCdtOebVtSrHbIDdObXi
	uxZatHlU0a7XzKE4lkHElcHr8x7x9Xg3SVJYO6H6XCxqr24hxgmjDUPcEmzFPJdIUSX0
X-Google-Smtp-Source: AGHT+IG5bZpCpAJS0uB9KNssTM0G9hDscPSWpbhRk73gTjzcEZVb+SiJRjSt3rx+GFSKRtyh83PP5p7jyKcIDWTsbQs=
X-Received: by 2002:a05:6000:4593:b0:429:de20:3d84 with SMTP id
 ffacd0b85a97d-429e35d299emr2327042f8f.6.1762367832176; Wed, 05 Nov 2025
 10:37:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251104-work-guards-v1-0-5108ac78a171@kernel.org> <20251104-work-guards-v1-7-5108ac78a171@kernel.org>
In-Reply-To: <20251104-work-guards-v1-7-5108ac78a171@kernel.org>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 5 Nov 2025 19:37:01 +0100
X-Gm-Features: AWmQ_bmfaeOypajqSuDAqK1J5uivhcjJ2drotaSadJ4EnDW1YFSkgONoikGnaIQ
Message-ID: <CAPjX3Feor+wY-_rniWOaGQf_7RPaUQLDZmmjABDkAav8AExaxA@mail.gmail.com>
Subject: Re: [PATCH RFC 7/8] open: use super write guard in do_ftruncate()
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 4 Nov 2025 at 13:16, Christian Brauner <brauner@kernel.org> wrote:
>
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> ---
>  fs/open.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/fs/open.c b/fs/open.c
> index 3d64372ecc67..1d73a17192da 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -191,12 +191,9 @@ int do_ftruncate(struct file *file, loff_t length, int small)
>         if (error)
>                 return error;
>
> -       sb_start_write(inode->i_sb);
> -       error = do_truncate(file_mnt_idmap(file), dentry, length,
> -                           ATTR_MTIME | ATTR_CTIME, file);
> -       sb_end_write(inode->i_sb);
> -
> -       return error;
> +       scoped_guard(super_write, inode->i_sb)
> +               return do_truncate(file_mnt_idmap(file), dentry, length,
> +                                  ATTR_MTIME | ATTR_CTIME, file);

Again, why scoped_guard? It does not make sense, or do I miss something?

--nX

>  }
>
>  int do_sys_ftruncate(unsigned int fd, loff_t length, int small)
>
> --
> 2.47.3
>
>
