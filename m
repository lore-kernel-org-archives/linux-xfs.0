Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8CB22257E
	for <linux-xfs@vger.kernel.org>; Wed,  5 Nov 2025 16:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762360696; cv=none; b=nYqzEph4AYOA9KaqqcWGFri3ntDmTsLfDaqyG0WDTYIVGeoo8IgmWrvt1K6u06lkDIH9h3zzg161JuhUObmhzlSo0zFNEEOCqLQbHU909tWKUDfd/GD8M0SEhSPHgOozbS8XH3YJVmbugZGEoDzR0PLSN2XB/HNvaqc5Wa0v/sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762360696; c=relaxed/simple;
	bh=IB05EblKhL135eVzQOGdqVSAaRbQ8gKw4M6wwiiepkw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aqR4S80j9B7YcRn2Sm23crRFsvbmapI3C0m/pCNpwrCCG9YLjGMhVe7b9y7SJTAvJsvyPiYbRfM40697PPF9E7grZ6Br1LB7QTdWLCB0i80J241B2dP/WzLWS7vfEW8Hx3gdeL9m9B+rrgET3f/8IgWO7xpGBT632ElQY2JiYJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JjbVpDcO; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JjbVpDcO"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-429c4c65485so52476f8f.0
        for <linux-xfs@vger.kernel.org>; Wed, 05 Nov 2025 08:38:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762360693; x=1762965493; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LbHuXuLIzszW8ax5jC5mySex6PqwZ4YZgNRjtsqrskA=;
        b=JjbVpDcOf/jiZBXuv/Otryyu0ZhthITMaIM4IW5/I5u5/BHU/4A0CHtA2N47nCKou6
         D7lcNz2/0Wq+NcsqBrKncBY+WPY0HdD8qx2+OjcWZteyFVcWJWywCBZXJzejiZ/yBmwj
         YqCaaOBN2qBrYL2BRNkblAFeEVD33wH+N+reHxqig8ySmaeNkPOHLFXjqFNlGV7/jlJw
         NVe4vRxEeZ/hzLLn6TyPQ/7fNyBpFJ8uO+Nl7O/3PQdE9SklxUApTtW5jgdGodoKS5N5
         MfaoKFrZgZrtL2Xiv0QaUBmIKfhy8o4UHX2AcmzxiljuguNPzuaV5SZYFjhUrruGNfdm
         OAkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762360693; x=1762965493;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LbHuXuLIzszW8ax5jC5mySex6PqwZ4YZgNRjtsqrskA=;
        b=L/7JpEyF1b8QAftB5zOE4yKDhdUUCmg0IiUmrvQKdCZSOBvbUoFRWzJW2gliOcvm3N
         oTnCOMf8xd4KmUIfi8t55SxTKklcw3FnD9beiKC+XLaO0ltrpfzpQSJbtmCdsDrJu22Y
         wJ0AKqu2QCsUhfAKDf6REzX+hQs6VXPMPFjpp6Lh8ZSgdiavCDuOKsczng+3qL2ruxWF
         gx+Ga+71JdsU0Gv6GlHasomXO7mbIZ5plqgSBmoYm7FdYvkuptQ5KY9fHe3f1zogRMtW
         fFTRpI3nXvk0ThvFjmPOOHnPr/Y4HYMa/+FzN4KdzCZbBz3h4nuN6hQskBBLMSiC62Nf
         Ga8g==
X-Forwarded-Encrypted: i=1; AJvYcCWciNmeLTKUPImKV0X91VN4JyhYpWhpj0tuMHmoF3Ih4+qrkg6lvEGsG4JwLdKyy4dPZRSUUacz7EU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwO68WhULYeHaRyPhVFNvZF3zPTA7qkyXX0iV03ag9lIgtnrZG6
	m44/U8C5YTPVffvGqMHrAQPn7azulOfCDt8hLlfZVNlJ5lpxX2Rg983Kboq8KNoa83S6gWBecvA
	KJod+RFjY1z8vmyAwFuBqnb/jYdkxDSPCna2Ct9GzYA==
X-Gm-Gg: ASbGncs/3HtwlxibaKNZHd0nKR5P1i91IoERcKRpmjIwuVxzU46nVxnWBGE4aZ+0EgS
	S92orGaInlZ5vZUuhfnTiwbPF4hJC0SlMrCpjo6VSBUMVtUJ3b54pdoj2SoQ+4PSdY8/+cQJTiI
	Pxfz5xhJPbxE2ckJq3VaaSXzhrNqM9/V0y1F7DiKhh0LQgNChZoTO8Q5Sy3iE38evpc6hVDiCpj
	gNrGfLlJFagx7Z+dY0PGGI7qArOXs59/KRkPEp0ANlu1mBvxF4421AaFRQMiC4XCriVeYxuSVL3
	2oKfOEL1EgbAhY4J+346G42I+ooe16QYYVoV/YZ0RpW9DoYr3IMliso3pQ==
X-Google-Smtp-Source: AGHT+IGJNIa/9qEOs2E840EbJH/OcafXkhGwOmmMo0TDuK8YRSQn+tMgefKtPW2tb5cKsMD1UIAuP2frisELZBu421U=
X-Received: by 2002:a05:6000:615:b0:3e9:ee54:af71 with SMTP id
 ffacd0b85a97d-429e32c82e0mr3641151f8f.12.1762360693049; Wed, 05 Nov 2025
 08:38:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251104-work-guards-v1-0-5108ac78a171@kernel.org> <20251104-work-guards-v1-3-5108ac78a171@kernel.org>
In-Reply-To: <20251104-work-guards-v1-3-5108ac78a171@kernel.org>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 5 Nov 2025 17:38:01 +0100
X-Gm-Features: AWmQ_bmQvhyjy3LzyEZU5BgedQdx4krqy6phuMugNr7MqLhXhxb6SOC0zAoqXec
Message-ID: <CAPjX3FfPyENVNve4Fe6YkYvTEwK3FBhaQ8ux1os9VVp_hYVRSA@mail.gmail.com>
Subject: Re: [PATCH RFC 3/8] btrfs: use super write guard btrfs_run_defrag_inode()
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 4 Nov 2025 at 13:14, Christian Brauner <brauner@kernel.org> wrote:
>
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> ---
>  fs/btrfs/defrag.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
> index 7b277934f66f..35fb8ee164dc 100644
> --- a/fs/btrfs/defrag.c
> +++ b/fs/btrfs/defrag.c
> @@ -254,10 +254,9 @@ static int btrfs_run_defrag_inode(struct btrfs_fs_info *fs_info,
>         range.extent_thresh = defrag->extent_thresh;
>         file_ra_state_init(ra, inode->vfs_inode.i_mapping);
>
> -       sb_start_write(fs_info->sb);
> -       ret = btrfs_defrag_file(inode, ra, &range, defrag->transid,
> -                               BTRFS_DEFRAG_BATCH);
> -       sb_end_write(fs_info->sb);
> +       scoped_guard(super_write, fs_info->sb)
> +               ret = btrfs_defrag_file(inode, ra, &range,
> +                                       defrag->transid, BTRFS_DEFRAG_BATCH);

We accept lines with up to ~100 characters in btrfs code.

--nX

>         iput(&inode->vfs_inode);
>
>         if (ret < 0)
>
> --
> 2.47.3
>
>
