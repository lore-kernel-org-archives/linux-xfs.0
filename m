Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B714128816
	for <linux-xfs@vger.kernel.org>; Thu, 27 Mar 2025 19:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743104900; cv=none; b=IK1uyXzkxRlZ3fDj3dMMKaOVujtuZhm/OxgYC+sVy7rZZOE5RH+6oKwcq5ZqYs5hdok57WliGA5IIkBzTIk2bBNtLlGMUnydmcBCaW11895Ux/9kLfHXqUO98OiRP7YeeHnESS2C+aMYuJT2EUEuVsRSJ8AucgGRifp3snESYG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743104900; c=relaxed/simple;
	bh=J6VhbvIW0qrAYRfW3LYqg4Cd285vNVJbPHr9T4ABLAc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Jo+ko42I1gRqoeqxQWfr5wMaTaWhjlM+5IJb/S4y6M4Jh4L1GcE3Y3pCJLizRWKJD0kBYA5adXZqs40YuIi7QjyZKN66ratN50Z91eNDSMAgQ4tM0U+qZAmz0z4+ExnBp2IshyDj+aR0rUuGEa3/AdI7Lp7QBy0WIUcSTJd4qTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a9VLvMiO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a9VLvMiO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743104897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t8in9XTDiS1T5+D3V4IV9TmAj6q98zp/LnP64cTAWaQ=;
	b=a9VLvMiOHsawBEpfu+uei+9rgw+pXzmJJIzTQtL9LDAgLURgXuL5RwUJMwkuAXSd4ctixk
	4r+2hOeO5+U5mMAquq2EXETrUl7hgS0rkIK4rLZgc30FUrAGv73tVxRaOImsGRl9rNpsa1
	Li3zjomvNyeaBtrgytEsWHTT+m5emdM=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-lT-uAKojOVS1wMc4QQvA0A-1; Thu, 27 Mar 2025 15:48:15 -0400
X-MC-Unique: lT-uAKojOVS1wMc4QQvA0A-1
X-Mimecast-MFC-AGG-ID: lT-uAKojOVS1wMc4QQvA0A_1743104895
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3d453d367a0so25325265ab.3
        for <linux-xfs@vger.kernel.org>; Thu, 27 Mar 2025 12:48:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743104895; x=1743709695;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t8in9XTDiS1T5+D3V4IV9TmAj6q98zp/LnP64cTAWaQ=;
        b=WiH9omAwRaCro/OBmc4UIXeMR1Rl8s3NyxJv9P0sZtgA8pCTTLqWlcl+8U22UCbUr3
         DkIQdGPYqUhtREieUCBLgYvJDZQAdReJh3MDG0eQoptPqoIH0pfuXlVnGjpknNz6u+Pz
         dQZcxQam6m8EfA6KnywBFs3PD/92JsME3+A8dZgfIDeuVgfQCg6LoddqwDxL5R3f+YOs
         AGre+LJJyfiWEqWWv+/UHB+jtkxI77XCidoRPhWZSO2DLPkiNjrbndpN3G6KJ//Ou3pC
         IcEnjnq8PmUplDb/nXMk6h7R7Dn/s05VnD7s5Pv2dj4xaoJko3C2y9ZTq52eBSCpS7HJ
         ai6Q==
X-Gm-Message-State: AOJu0YxGxzvM8TNxBM3sQDd0eHFnxf7YCA4lQvQJjB3QtmIxB+t9aplp
	wi/G3JqlxeTx/4Rwr+mV/tNymuEe/kRUyyGtChameXkiSWQiDJwLAG0ev62fQlXlTOi6n9kaT28
	ldAv1v0dbM+ZNxGPCG88l+868IZTudHydiYBWpebgioOMPm8i0JEaMhcBSQ==
X-Gm-Gg: ASbGncszshQx2Zh4lpp/Z4SO2yXd7ZVuV8WLsDWR6O1XnF1TzkrqWV66E/MKWwP/YSd
	JKsXI6OKEGmkdF8PjkwR5Pml3PHv00l6Xz1akr4Tzup5kiYs41qO2JUmBE3w2euvsU8I8KkcAV0
	//fT5YS2P/Phs2IkEgBMWk6/AVZTa+35Ksv9YpGJCRyZOaPmvTEg4dwAHcllzrvcnCG6sSncNoK
	z1WhdNKmwJE3JEnnDMa93u1upanGfC7BKVmb5+c7HC2x25qTRo0Pc7rBYkIgB1U9gBL5DOmUVtY
	Q6UA9Rju+H8d4LlbRbtMCx9q
X-Received: by 2002:a05:6e02:380a:b0:3d4:6e2f:b487 with SMTP id e9e14a558f8ab-3d5cccea2e4mr52709295ab.0.1743104894993;
        Thu, 27 Mar 2025 12:48:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEoHcB3M7o2YCDQGN2iIeFZYbtSDZ4kHmP2SUJhtwrCAxd9qWOlChrZ2r66oBxRyBZrLkDA+w==
X-Received: by 2002:a05:6e02:380a:b0:3d4:6e2f:b487 with SMTP id e9e14a558f8ab-3d5cccea2e4mr52709185ab.0.1743104894540;
        Thu, 27 Mar 2025 12:48:14 -0700 (PDT)
Received: from [10.0.0.176] ([65.128.108.16])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d5d5ae9eb0sm860535ab.57.2025.03.27.12.48.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Mar 2025 12:48:14 -0700 (PDT)
Message-ID: <0e47cb04-542c-460a-a5b9-e9b0f3ef6c1f@redhat.com>
Date: Thu, 27 Mar 2025 14:48:11 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH GRUB] fs/xfs: fix large extent counters incompat feature
 support
From: Eric Sandeen <sandeen@redhat.com>
To: grub-devel@gnu.org
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 Anthony Iliopoulos <ailiop@suse.com>, Marta Lewandowska
 <mlewando@redhat.com>, Jon DeVree <nuxi@vault24.org>
References: <985816b8-35e6-4083-994f-ec9138bd35d2@redhat.com>
Content-Language: en-US
In-Reply-To: <985816b8-35e6-4083-994f-ec9138bd35d2@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Grub folks, ping on this? It has 2 reviews and testing but I don't see it
merged yet.

Thanks,
-Eric

On 12/4/24 7:50 AM, Eric Sandeen wrote:
> When large extent counter / NREXT64 support was added to grub, it missed
> a couple of direct reads of nextents which need to be changed to the new
> NREXT64-aware helper as well. Without this, we'll have mis-reads of some
> directories with this feature enabled.
> 
> (The large extent counter fix likely raced on merge with
> 07318ee7e ("fs/xfs: Fix XFS directory extent parsing") which added the new
> direct nextents reads just prior, causing this issue.)
> 
> Fixes: aa7c1322671e ("fs/xfs: Add large extent counters incompat feature support")
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/grub-core/fs/xfs.c b/grub-core/fs/xfs.c
> index 8e02ab4a3..92046f9bd 100644
> --- a/grub-core/fs/xfs.c
> +++ b/grub-core/fs/xfs.c
> @@ -926,7 +926,7 @@ grub_xfs_iterate_dir (grub_fshelp_node_t dir,
>  	     * Leaf and tail information are only in the data block if the number
>  	     * of extents is 1.
>  	     */
> -	    if (dir->inode.nextents == grub_cpu_to_be32_compile_time (1))
> +	    if (grub_xfs_get_inode_nextents(&dir->inode) == 1)
>  	      {
>  		struct grub_xfs_dirblock_tail *tail = grub_xfs_dir_tail (dir->data, dirblock);
>  
> @@ -980,7 +980,7 @@ grub_xfs_iterate_dir (grub_fshelp_node_t dir,
>  		 * The expected number of directory entries is only tracked for the
>  		 * single extent case.
>  		 */
> -		if (dir->inode.nextents == grub_cpu_to_be32_compile_time (1))
> +		if (grub_xfs_get_inode_nextents(&dir->inode) == 1)
>  		  {
>  		    /* Check if last direntry in this block is reached. */
>  		    entries--;
> 
> 

