Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA44B148FE6
	for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2025 03:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737428604; cv=none; b=C1t4hT47oYbsH1XPoscaT76kCdcUULwx31oYvxO2tZ7pbXQxokmBIKvUfcjlhX+tDLtLwpmXWkd0/ACfrbNiaG34fwaCJdBvqVzPnUhWVrxeCdUdhdbn0bX8FVWMR9lAl/4uh7pY9PsYejkkGJFtXk9T/AwDxJ53QoRjxShiHU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737428604; c=relaxed/simple;
	bh=BbV5jKqLTJiO31UvKt0PaPhLhOoWJ9c0y25/aH/XKDw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EcBIBr8aEUlKENViT95fBMyTyrBkRwwgelhuiVlXUTD0HPTD7lO86vcBJXUJ1dVQRGyrO4hCM+HZym3kZJd7bN8U846J8zL4KbF1KxMU6RYcrtBLlf9pI1YarR9DjgaEx5x82ltro0txyPC9D1O+K2JSz4oEBjLyBhEvEZjMnss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=nnDzdSgE; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="nnDzdSgE"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2ee8e8e29f6so6650480a91.0
        for <linux-xfs@vger.kernel.org>; Mon, 20 Jan 2025 19:03:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1737428602; x=1738033402; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9FcQopt018mcfh1i0WWwxMAtuDKTEJV4gm7uMMtqwyY=;
        b=nnDzdSgEU2wVJy1dZMR0j9ZCKFMR91dof9+ltSCNiO0+nFaj/aXQWq0N8aLNiYpiGO
         JuZVkwMgIyZEBv3xb2NJulQcnG3pZmZYacRfZ/M5YCGRN4nAH+jGIyhRJnhLsbVvRyiP
         T7/j1FHzg+LJoMAGaGWr6lTOcpcJ1cYtzJHOJFO5/8cpYty34K0W44qFDEnRdq5qvfUl
         Yeq5ITMq/jbB7/L1awiSiBYFR4cfe9qez68ypLPrxza8WFc6dpf32vqWErJ8TDiiXePp
         UR5tyGaTFfzhyR1yJ5nXctBNmIwYPymH+6MX2o1Kc+euriEG3ZYChzyXw0+xEifBXAgJ
         h+dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737428602; x=1738033402;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9FcQopt018mcfh1i0WWwxMAtuDKTEJV4gm7uMMtqwyY=;
        b=a2NEGE0Py2WcWmc8MzkJ6w3AK4jvdpxIbu7isVfq/zRw1q6BAgyTwxw92lw+F2N4y+
         TNW0xoYCByTCK4Kp0BDMYdiS4KQjxWW0bWJH+YKsvuJPfCbUQcUbUR/3QbIbTZoJBwmq
         BX4hPrA5nmEYzXN13liITc2aZxSXgFmOsB22MJ0ZiAv+ka2Tvc2rplv/rTNrVFt2pfWq
         tZTJJFq/N1hgrR6W0zHfT0VAvbT3AfhCJx1Kd6cHjQWWnuoDCja1SD+p1bl/CfDCcMOP
         8zRlFRLJTvLLK/fI5sOGpZ4bluHzlUWyfJH0dozif+3hKuvbaDf1DTFhWggnCQpzSlhO
         CCOQ==
X-Forwarded-Encrypted: i=1; AJvYcCWphRwYBOkDRvgA97kMZhlkjD1fNQc0g0MwK/vl8ZOKVGyeH2iWGz/z2dk/KWqx23Gd1Vgm6SLUhvo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxzBhw8/3LFhA937b2CbtzIwI9K0cUlCsY8981Vc65DnC/NZIjB
	J3tEEodncnrzK/VLB+A3VSP0nTQKeTj6mlGzkhtKinKzPTKNY9dlE2ccTDd378m015JGDFuRCqM
	h
X-Gm-Gg: ASbGncumx3AwCiB+uNyj3bdMod3aX142haRA+Sj/UYix4KCr5tX8zok94oRjHnc7HfX
	fTotTC7MQxofyr/3grW6M0YOrKRza2SvPbbcHyfLU8XpRnNTAAExfCIeX0LWpSTrM0OUSfHFd3W
	3of4aLPqBZhxz3apmVaLzrPZXUkNNJi8cnBGkdUSyIUwI9i11paWMlEdcajCyuHbjfK6dfZjoV7
	JIVn6pMyP6hVcaOCJMcplCS6oOb8djsHyTJ2O66MAD2J3aN5zL4ddszhHHlj6HlHIwDfUttA0+k
	LnGg5pq4ektsnzz/e7x5Vvln1Gj9D13MOfo=
X-Google-Smtp-Source: AGHT+IHiR7lkT1DaLOjXsW+1Wi28WUK1LbP5cmcv2BcbCU928X2RotwIEqRkNUypdWQFkQOt17CQWA==
X-Received: by 2002:a17:90b:2809:b0:2ea:a9ac:eee1 with SMTP id 98e67ed59e1d1-2f782c92bd9mr24402036a91.10.1737428601984;
        Mon, 20 Jan 2025 19:03:21 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f77615720asm8510148a91.19.2025.01.20.19.03.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2025 19:03:21 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1ta4Xu-00000008V7W-291p;
	Tue, 21 Jan 2025 14:03:18 +1100
Date: Tue, 21 Jan 2025 14:03:18 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/23] generic/476: fix fsstress process management
Message-ID: <Z48OdujL9TQA9sdC@dread.disaster.area>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
 <173706974091.1927324.4002591248645301199.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173706974091.1927324.4002591248645301199.stgit@frogsfrogsfrogs>

On Thu, Jan 16, 2025 at 03:25:26PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> generic/476 never used to run fsstress in the background, but
> 8973af00ec212f made it do that.  This is incorrect, because now 476 runs
> for three seconds (i.e. long enough to fall out the bottom of the test
> and end up in _cleanup), ignoring any SOAK_DURATION/TIME_FACTOR
> settings.
> 
> Cc: <fstests@vger.kernel.org> # v2024.12.08
> Fixes: 8973af00ec212f ("fstests: cleanup fsstress process management")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  tests/generic/476 |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
