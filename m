Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFE81E570F
	for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 13:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729518669; cv=none; b=YRLK72LUU3qwU4IYjkEH4yyROCBeiVWk+pAe3mHnvpoMNYFxKBk7gYj0ZSb+EaUZijKRA0+YWmgpp1xiRYXMZGaMexmRGJ2NtFY+KQZIMk2Ex/iHOaoj8K12HGm8ILK1LZ+XUg1QOM65hF8tutOT4bX1x7GymO7Xjwqul8UYCjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729518669; c=relaxed/simple;
	bh=HXDMjUzao9l0FPzv0fWzHetKraYXxqwrYGzwCA5PdjU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hCUN0jzAp6GdYxCkCigUn8mfDUs3l6aw+q/61nFluQsxLvNgjbQ65paj78NAwJ49NSuSjrmES+AQoYLy2jxYulGJFjjH0a95CbHZbkXJtvom/c4rhs+6ypSVukzzUl9Ws1W7g3Ye9OyE2zm6fMznZfr6NGwlxUJSIbSOWxjxw+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=0x/7tMms; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="0x/7tMms"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2e2e050b1c3so3886750a91.0
        for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 06:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1729518666; x=1730123466; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qmlYusqwbs3QBiSq5jmhKci3LuQRDJfNgiez5CPmGk4=;
        b=0x/7tMmsyK1++7/lt7uXHm5WFwbuxenx6no+mWYXBii98YUFJ++TLM4O1B+MDpvNtu
         ujau2Lu3gOdDOPFhfE/ZKRxaZDj9L38JgzaUVbkc/WHgGGobXuISXl3hIrhC+2xTcCXy
         wJ+u4IwrsDGCgU6jVxr8mIYAdxBs4Bufg3uBz1sHoCMoxDthHHj2pxlwVM8SR2my8aUG
         YqYVZOBh/2yIJiaqjozeNZ+zwisuKVxdsZyeNzSM3nsdeA7MEHaFaHHe2XA5xjPpVWZP
         Zh9LupvgwiU9ozoXf8sgSOm/puzaKsaS5HSQmhkrUjuEIzQpZtOn3j4bY3ZVvF4QGdfa
         +NCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729518666; x=1730123466;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qmlYusqwbs3QBiSq5jmhKci3LuQRDJfNgiez5CPmGk4=;
        b=m8VyZ3b0D4e9XS72Q7AThTqZkWqsktyj2Rcmzi7AtMNWFHxxTy77921AivIhpATyyC
         IZv8sLn/hHuQX31N/impfd0d+gFyb22RedgCoz6x4iTBQQ+fQ9dI4NPxGBADimPZkdd4
         sg0W+e7VCcMS+Rzl4PpvNowNdIZSxpO74lMLbU+0WeWk1ZI89uESCsqYgeaEtqoBMprO
         LAigreUukjSDiDbuIRuFt1nResbGHDYSVeT+XzrglIspIm9gWXv1sg2ug1np1aXgV3aL
         ayxJKcPqhmEPtc07jsixDJIjYt/OAb9j1Xk5r2Jix2gyMrcWfFDktP/GnMJDss2ug05f
         u4RA==
X-Forwarded-Encrypted: i=1; AJvYcCXVeIyldIjVKEZdNCEtaXxBij+ZYk6UnXYjyHX6TfwlC98EoGEpK85m5daAR/CFXgjqYT3Ng+E+PgE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBWHllzKg4MUf4GqTuJe1XcOoyru93u7JoHUr6+W3Y6EPwy7+C
	PGa14NtdSAHAyAJDbwKPQ/O9cEQxtZ0MhQOmkdc5Po74SRsPbRzYr5/nfMRBmKs=
X-Google-Smtp-Source: AGHT+IH9gcyU4W3xftnDCfwy1lQ8dwmp5zX8+FASkrzzKK6k6eeOtIwXLT5p801y52PXMwLNab7Mbw==
X-Received: by 2002:a17:90b:4b92:b0:2e2:c744:2eea with SMTP id 98e67ed59e1d1-2e565063adcmr15695640a91.13.1729518666469;
        Mon, 21 Oct 2024 06:51:06 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e5ad25c314sm3838181a91.12.2024.10.21.06.51.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2024 06:51:06 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t2soJ-003pQd-13;
	Tue, 22 Oct 2024 00:51:03 +1100
Date: Tue, 22 Oct 2024 00:51:03 +1100
From: Dave Chinner <david@fromorbit.com>
To: Edward Adam Davis <eadavis@qq.com>
Cc: syzbot+4125a3c514e3436a02e6@syzkaller.appspotmail.com, cem@kernel.org,
	chandan.babu@oracle.com, djwong@kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] xfs: If unable to pick perag an error needs to be
 returned
Message-ID: <ZxZcR1v8OnYH/l+/@dread.disaster.area>
References: <6712b052.050a0220.10f4f4.001a.GAE@google.com>
 <tencent_1DD6B365236C297EA3A6A45DB768B76F2605@qq.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_1DD6B365236C297EA3A6A45DB768B76F2605@qq.com>

On Sun, Oct 20, 2024 at 01:30:05PM +0800, Edward Adam Davis wrote:
> Syzbot reported a null-ptr-deref Write in xfs_filestream_select_ag.
> When pag is not found, xfs_filestream_pick_ag() also returns 0, which leads
> to null pointer access in xfs_filestream_create_association().
> 
> At the end of xfs_filestream_pick_ag, we need to add a sanity check for pag,
> if we fail to grab any AG, we should return to -ENOSPC instead of 0.
> 
> Reported-and-tested-by: syzbot+4125a3c514e3436a02e6@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=4125a3c514e3436a02e6
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> ---
>  fs/xfs/xfs_filestream.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> index e3aaa0555597..dd8f193a3957 100644
> --- a/fs/xfs/xfs_filestream.c
> +++ b/fs/xfs/xfs_filestream.c
> @@ -165,6 +165,10 @@ xfs_filestream_pick_ag(
>  
>  	trace_xfs_filestream_pick(pag, pino, free);
>  	args->pag = pag;
> +
> +	if (!args->pag)
> +		return -ENOSPC;
> +

If we get here with pag == NULL, then something else has gone
wrong before we got here.

i.e. there's an if (!pag) {} check directly above this, and it can
only fall through to this code if pag != NULL. Hence if pag is NULL
at this point, we should have already hit a null pointer deref
before we got to this point...

So, where's the null pag coming from?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
