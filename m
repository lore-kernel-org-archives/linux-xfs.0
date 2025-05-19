Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3608B244698;
	Mon, 19 May 2025 06:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747636543; cv=none; b=mO7NllM7PTuL1reSvzJbNsUPvkzfDjIBJcJTbbZxD2f/KPP65CKGppDeu6KKlp1NqAqQurRscrcJRcz6Sn9W0YT9Mmd9i+39oL3EtzP6n8p2ADIBCRRwRakLcpVO63+pKUhP2H1sMas1waPIT303/tsQ0Gnyod6+62HzjAGtqOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747636543; c=relaxed/simple;
	bh=yET65vWYLjgl35mfkLmqYcsb1shTxtfsLM1CGUf/VMI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=IltK+tCF9Ey129T1l7vJl8A9WkiOvp4WpcPbQ9JyCg0/bd3QBR4lxKd9yV/YqgG3pJyilyhzE17LuCDQ0u0Ca6H63Tlun7laTiTaBlCX0bo7+Gc4qlhrym2Oi3LKzQjjtm8tKuXW7Y5txtG3aITKqKlDHiljUAncfzTsp53e8sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QP16tsBe; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QP16tsBe"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-30f0d85a092so339915a91.0;
        Sun, 18 May 2025 23:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747636540; x=1748241340; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xU9eyjmSrtrXc60xASy21fm8WnzISRHLSXd5aK11pDA=;
        b=QP16tsBeS7p0dBUO3hzX9FWYy5nxyXZrdWd/2CED6lFeY448l5ZcIdqYVbTZE6JsM0
         W+xH1xoQ/iDk8y3w4Jo8H+5Ac9oKIFZs3Lb8wWMVullp7HPUFknfSeh46h/zhnhMtdbV
         lRCrc/5mGMoT/KLUVvUiHEGn5HC/4bTNIvrvvDIME4oaOggN6Kk6cXOmQwNnDzw86iD3
         FvN62DbT3bhkwRTUxVR/zaBlcLzCOdtI8echPSs3PCXFz/lAuOaE/3IcCX1CqVe8vMqR
         0Sa2TGxroQJ6+XeeCjDOkfGm/uFbdJCXk28UHLshP76Lui+JrQ48ctIGd5cHt3PjifQM
         7Dpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747636540; x=1748241340;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xU9eyjmSrtrXc60xASy21fm8WnzISRHLSXd5aK11pDA=;
        b=xRpCGIbYzy7fQtyUrDwY9TrFDGC/EV94PIWOhyUcvlSsnFUk2vrVNVFY2WnDuPzSU2
         Mlxowz0Au6pA2Vs5ZBN7UyLl7D9oywZYrrcbBik5vXwvPvMjy+Y1bmW7ZpLbJ1+3+8+E
         0n+DOhHbT++9dncPc167U1gm8DIbtq/q8GgiRBgb0j7eH9lGZRUL5yDg06eJRtffejWr
         2EqJLCcq9hNG/zoGQKyQ1m0hmzcFpu46fByNuUFkowdnkL4rXxIVtZt9irHHOgXmyS89
         BWWKnz24lAuElZNjrDMccreKFS/WvPIfAinCMMaJDRJuNMsaCNjKJsLxgoeKzOrIiA6V
         mCZw==
X-Forwarded-Encrypted: i=1; AJvYcCUQUOozZADA4/Um/hh9EooOY3YEGT4SGf+DTAo+WYCQmvqh0Oui8mduwvEYYr5QofJJijW16mFbKNaWt1A=@vger.kernel.org
X-Gm-Message-State: AOJu0YyC+Vfm9oztHUU1lMz2zg2voMzeT638XikVa5P8DMmXkZ2lyUJy
	y8d2os8WldaCx4bFRX6xyJqufEHh0djZ74Tp5urEQ0WuBMiLG9cAXGt+EujnAw==
X-Gm-Gg: ASbGncsCxyM8ulepJvqbtth8M6Bt3eyQAQuO/HK9fZcW+XOLVzBdBYxWhdYxUTwofgT
	qynHrcjOSyR95waebf3zRBC14IUdHVc3Al0bcbu9UUpVrnjGhCQNCkbK9PAZTK6a4wC6e7vF2/2
	Up35zy7sJzcggrlTp1vJeDGuLbatByS5AwRP9pF2YcL2s4IGSEPwtxD/SQtX0EKUp7e7Blob+lE
	tHwDMEAq6WLQE0thQlo858bQZggJOxWdYFiZa6H4N7a2pVLfi0x+h8xMP0fZRfMhByPc3MtnNRI
	R20ayay8HsHL+l54aTnRFfPcjMHJh97NHsdpPO29+G8Iq5PBZU7bk6+0USDOyB/xuv4yHXA1/Cj
	/Y0hu8Z+DrZ6lQOIni2EhFHDmAtAa
X-Google-Smtp-Source: AGHT+IFNtD1hva5l0grwa9LWSJv9C+Hi6a2v55OWP0J68Z2HyLxK4kIuRZ5Q0ZP8lw8u7lq2WwSS6A==
X-Received: by 2002:a17:90b:3c8f:b0:30c:540b:9ba with SMTP id 98e67ed59e1d1-30e7d51fa7cmr18472827a91.10.1747636540271;
        Sun, 18 May 2025 23:35:40 -0700 (PDT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.205.34.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30e7d489f95sm5852871a91.18.2025.05.18.23.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 May 2025 23:35:39 -0700 (PDT)
Message-ID: <a4d6cf65dd8537a5b047ccd4f39fd0e43c6f94be.camel@gmail.com>
Subject: Re: [PATCH] xfs: Remove unnecessary checks in functions related to
 xfs_fsmap
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: Zizhi Wo <wozizhi@huawei.com>, cem@kernel.org, djwong@kernel.org, 
	dchinner@redhat.com, osandov@fb.com, john.g.garry@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	yangerkun@huawei.com, leo.lilong@huawei.com
Date: Mon, 19 May 2025 12:05:35 +0530
In-Reply-To: <20250517074341.3841468-1-wozizhi@huawei.com>
References: <20250517074341.3841468-1-wozizhi@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

On Sat, 2025-05-17 at 15:43 +0800, Zizhi Wo wrote:
> From: Zizhi Wo <wozizhi@huaweicloud.com>
> 
> In __xfs_getfsmap_datadev(), if "pag_agno(pag) == end_ag", we don't need
> to check the result of query_fn(), because there won't be another iteration
Yes, this makes sense to me. Once pag_agno(pag) == end_ag, that will be the last iteration. "error"
is used later after coming out of the while loop. This looks good to me. 
Feel free to add

Reviewed-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>

> of the loop anyway. Also, both before and after the change, info->group
> will eventually be set to NULL and the reference count of xfs_group will
> also be decremented before exiting the iteration.
> 
> The same logic applies to other similar functions as well, so related
> cleanup operations are performed together.
> 
> Signed-off-by: Zizhi Wo <wozizhi@huaweicloud.com>
> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
> ---
>  fs/xfs/xfs_fsmap.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index 414b27a86458..792282aa8a29 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -579,8 +579,6 @@ __xfs_getfsmap_datadev(
>  		if (pag_agno(pag) == end_ag) {
>  			info->last = true;
>  			error = query_fn(tp, info, &bt_cur, priv);
> -			if (error)
> -				break;
>  		}
>  		info->group = NULL;
>  	}
> @@ -813,8 +811,6 @@ xfs_getfsmap_rtdev_rtbitmap(
>  			info->last = true;
>  			error = xfs_getfsmap_rtdev_rtbitmap_helper(rtg, tp,
>  					&ahigh, info);
> -			if (error)
> -				break;
>  		}
>  
>  		xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_BITMAP_SHARED);
> @@ -1018,8 +1014,6 @@ xfs_getfsmap_rtdev_rmapbt(
>  			info->last = true;
>  			error = xfs_getfsmap_rtdev_rmapbt_helper(bt_cur,
>  					&info->high, info);
> -			if (error)
> -				break;
>  		}
>  		info->group = NULL;
>  	}

