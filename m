Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191261BBBE8
	for <linux-xfs@vger.kernel.org>; Wed, 20 Nov 2024 20:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732135043; cv=none; b=Xn9nMExTHYG279S/ueywwrEEOiThyA7beyRVkMU8UyINJVLPij+uVoyewE5bxqASbRg/kgNrLaYFVSSBWla8/voR/BBf67JQzTrf/SHosXp6Pi/ixwhiZK7HilDkR/81NpnMO5vSkofWNdIkE0xeuG2AWRgbwv3UgRyMGYyT0JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732135043; c=relaxed/simple;
	bh=gxdo/qfNxQeE8KQho8RvlhXWrZvSkpA6qPXBeVgUJXo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MX623bCyhGp86Ovx1nLTQF4O3mgyAiskTr11I83CbYimy/vwC/zI6X4rUpWxexNDT79oUmQG78o+iQlm+qrLUObYm1lBS8qsAB+w2LvDQu+uUgCV1TVN+bu77UlncGiDpRQZH3+EOTD79VjrACIjB5zu7NPkaxcYAWZiORmLAYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Q++p/NM5; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Q++p/NM5"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2ea68cd5780so169838a91.3
        for <linux-xfs@vger.kernel.org>; Wed, 20 Nov 2024 12:37:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1732135041; x=1732739841; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=j7agw+MVRyIWuBCl7pZ+mHszf9nzIBAC/CJ3AinkBqw=;
        b=Q++p/NM5V2P0QCp2VjUddqV8grc4gu6TasiyBOjEJQMiSQgildyUd8BLF97mO16/gX
         kTe1Jos6tv+4nNZPMMMSPx6HSzOetxJw82emuaY6c0d3ITXa3luQTBYGSay+ie+6oABL
         TOJ1SCQiHGe1R75MPDrXtVZ/QlTWHU4jrPsRzdipsip9KcV5nAA1aio0kXTzHCSKLlTG
         k/i6fvt7Cd8OkTorLtfhQWGGVV52tDjb0ASwIvHHLTOh3eLBffLLJR5/4WKbuR6q99Rb
         vGfkeqp9eFbmc3ow7QN9qYTkKYrhRlJinKXsmg2NJHCKu+puEBR4zawIeTf45GOEcxHO
         JrsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732135041; x=1732739841;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j7agw+MVRyIWuBCl7pZ+mHszf9nzIBAC/CJ3AinkBqw=;
        b=Sw38DxZLdm862gVIH5cz/QF7BySUczPmlK0nrU9Opf0ZDW9GAlRGw0xkQOptoIWpuE
         lsLzFOMyEKXjK54gkM1I98IgGFHN7S2Uh8Mgs0PB8uQelkNCKxr9z64UQu5uYUJe6sjP
         YASFU0bzxeMpxoW7Z34kEPho0fpGeLSKSlZrRUgIhSJo8HE1blqV6o8Tqqx0blxAawh5
         VLJGo9uhYy8Pp6s4zTAKzeVWwyols2luxh7Y6rP/e6eGzt1/FsLOr3EJiP/fma/qB34Y
         gvnj7dxQfKyu6kqQTFcOipZ/5VXAJDaiYb6Wz54s24ye70Dikww3WPzdRuXTxk5GmXDQ
         aqDA==
X-Gm-Message-State: AOJu0Yx/se8aL+BzeBjkkP/QfqrdRgKV6rCOslW6s6dAmoYHUTVWftOq
	zqhqBDkUZTfeA2jWiWGM/TI+yTZSrYkYdZgPlhcnHz93k4TpCHg3LU9CLFusIig=
X-Google-Smtp-Source: AGHT+IGreu4pbRdf9RAsxW9otLcD4fFTHm8D1pwAWAPrW4pJkHesAy9VcpvXrA5aTGE2ELi+7vWGbw==
X-Received: by 2002:a17:90b:52c3:b0:2ea:b564:4b35 with SMTP id 98e67ed59e1d1-2eaca6e41f2mr5271046a91.9.1732135041400;
        Wed, 20 Nov 2024 12:37:21 -0800 (PST)
Received: from dread.disaster.area (pa49-180-121-96.pa.nsw.optusnet.com.au. [49.180.121.96])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ead03de6f6sm1762377a91.34.2024.11.20.12.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2024 12:37:20 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tDrRt-000000010Wl-2glT;
	Thu, 21 Nov 2024 07:37:17 +1100
Date: Thu, 21 Nov 2024 07:37:17 +1100
From: Dave Chinner <david@fromorbit.com>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH] xfs: Use xchg() in xlog_cil_insert_pcp_aggregate()
Message-ID: <Zz5IfYYQXHyZPwbi@dread.disaster.area>
References: <20241120150725.3378-1-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241120150725.3378-1-ubizjak@gmail.com>

On Wed, Nov 20, 2024 at 04:06:22PM +0100, Uros Bizjak wrote:
> try_cmpxchg() loop with constant "new" value can be substituted
> with just xchg() to atomically get and clear the location.
> 
> The code on x86_64 improves from:
> 
>     1e7f:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
>     1e84:	48 03 14 c5 00 00 00 	add    0x0(,%rax,8),%rdx
>     1e8b:	00
> 			1e88: R_X86_64_32S	__per_cpu_offset
>     1e8c:	8b 02                	mov    (%rdx),%eax
>     1e8e:	41 89 c5             	mov    %eax,%r13d
>     1e91:	31 c9                	xor    %ecx,%ecx
>     1e93:	f0 0f b1 0a          	lock cmpxchg %ecx,(%rdx)
>     1e97:	75 f5                	jne    1e8e <xlog_cil_commit+0x84e>
>     1e99:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
>     1e9e:	45 01 e9             	add    %r13d,%r9d
> 
> to just:
> 
>     1e7f:	48 03 14 cd 00 00 00 	add    0x0(,%rcx,8),%rdx
>     1e86:	00
> 			1e83: R_X86_64_32S	__per_cpu_offset
>     1e87:	31 c9                	xor    %ecx,%ecx
>     1e89:	87 0a                	xchg   %ecx,(%rdx)
>     1e8b:	41 01 cb             	add    %ecx,%r11d
> 
> No functional change intended.
> 
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> Cc: Chandan Babu R <chandan.babu@oracle.com>
> Cc: "Darrick J. Wong" <djwong@kernel.org>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_cil.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 80da0cf87d7a..9d667be1d909 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -171,11 +171,8 @@ xlog_cil_insert_pcp_aggregate(
>  	 */
>  	for_each_cpu(cpu, &ctx->cil_pcpmask) {
>  		struct xlog_cil_pcp	*cilpcp = per_cpu_ptr(cil->xc_pcp, cpu);
> -		int			old = READ_ONCE(cilpcp->space_used);
>  
> -		while (!try_cmpxchg(&cilpcp->space_used, &old, 0))
> -			;
> -		count += old;
> +		count += xchg(&cilpcp->space_used, 0);
>  	}
>  	atomic_add(count, &ctx->space_used);
>  }

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
