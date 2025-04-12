Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E338E7FD
	for <linux-xfs@vger.kernel.org>; Sat, 12 Apr 2025 06:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744438788; cv=none; b=L0hwhMceGYiOaR/BhTqDZRAMbwEM4xs+N88cwU3UMWGrYIMe/kINgXDuLkYTawaSdj+xjM/IDeqQU2L+pde2qcrguwv95ym+Ey9PSWeGHZnz7ei4iH/kx5iUWLK0YK1659ZPq2RE+UNOC6zqSgm8KLfg0+asPjT6SgDdESJ3BYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744438788; c=relaxed/simple;
	bh=QkNem8s1mYaxFgDHJ9Hw/tJu7msSKxNdxQlENhRvnaY=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=KI8uTOMUsYNBAtdxbxwjJKEDDmM8+JciOe+Bp1HfnHmGFqTJMHUzNs+7MwA/42cyU4YMWzJShNGo7bUE7McnRWmoR0rjiRnLsP/JGXhep6L7azpkctgvWT9AWT/YpH53hBwMyYalWORkX5XIt0XBeIQdlqahQtWDjHKAcD53AxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EtmxxAbY; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EtmxxAbY"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-afc857702d1so2508184a12.3
        for <linux-xfs@vger.kernel.org>; Fri, 11 Apr 2025 23:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744438786; x=1745043586; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iiuwzjvh8vNtopLX5E5KkcDqS8qafJWdtx/gazdlMZw=;
        b=EtmxxAbYnAqVSR8pOi0084qkvEfvTz0ErjWK3Ky5BVMHJMwDWk75RmOs3pP7tz4mv1
         V/PJGjNhGA6Pq6DGevAarhkaYrHS9UwpHRtHub/NJhPFBKchZ+/POUvL+HOKM0qv0pKn
         Gaq+bAIwMqXOI3C4G/F/yyTHHS/L3Og9uWkIr751TR17DVnPz5rbl2a0WTY/2ZPCtwoU
         6qJ8vVmuMQZmXpBk2Wcw2OU2EWq03Chls3V6uuHZxQ1FkTBtVtl5Y7fJpeAZpGOvtWij
         wxSACB0bagJVJVvLTG8bYpdcPtJGLcyxQeei5n1PsrmUmhmyqCwZaYwhMCquHQS381s/
         NUxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744438786; x=1745043586;
        h=references:message-id:date:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iiuwzjvh8vNtopLX5E5KkcDqS8qafJWdtx/gazdlMZw=;
        b=Y6tfvZuz880ICq4Y0KqEzF3fAp/M7jtZTJMmRrYo9oOSl8BuoxZ28/5gb2gBDuJvPq
         xOkcqaiQCZLXsGOIZPbdC1uiAhozlG6tWIfULlbxlIV5sP7jVIFivibiVECxdzhNrX5Q
         J0t5HVFGX3CEVIbZqI7dyyu7n6Jmk8ygkNzkA5bRDAGRGEIIA/Mzk6FQe5ttcGjGrNQ6
         hrcoK1FbA8folCBOvCraKDhmfeCJFToqEntOJEtuxRfVt6tk1NYRgEEUlkjX4LqQg9xA
         7qU+D162Mq874Ry/IEsydZsoH0RD2vZ2XXyIhsDTL47YG+drywT2i5jCg598CYhEnVPa
         QY1w==
X-Gm-Message-State: AOJu0YwnRkznZ54TEMzy2O0TXduVmZX0NUggSaGeYf1u7hYJpcaatTLM
	bt3p0/y6SohEQ57r927EYvPCXJVUTjBWAIJxFa0RGmZEHzPQGqqc
X-Gm-Gg: ASbGncsaRG0x2uME0c0e99jcx9mDrZHH5+YIDN02KnTm/umv14jZBr3ofW7g7HTrACw
	BbBnRrNN8yzo2ZMAEconrIq1f4bzYok/tBpEmw4jTgklW4Sl1ohcUmOM/G3G97j7tworqvv+P7e
	a25bPA4F4nbZfFmpM4aBZPwIMYD+vn+QbfeahNdIEoS3nd1npC8hJEDgK3CcvlnzsvISAK9rnlo
	hCUEh6F/qJeAY7AXKk9u/LE49Yoy60/UYkMCzM3WLVj4/NF35sq4N1QHB32gFnpa3LEGCsy0Xt0
	/SqwCPG8z5ZLjRh9awMoILTARCOJDCY=
X-Google-Smtp-Source: AGHT+IG3WrsWxjpxr4HtkMV9KyPNVmTcDvDB6Nq9vMRGGAR1SPvc98wWpvXnMHyNRuEIIyC6ykToBg==
X-Received: by 2002:a17:90b:3cc6:b0:2ff:7c2d:6ff3 with SMTP id 98e67ed59e1d1-3082367fc07mr7781425a91.35.1744438785899;
        Fri, 11 Apr 2025 23:19:45 -0700 (PDT)
Received: from dw-tp ([171.76.81.0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22ac7b65112sm60666145ad.19.2025.04.11.23.19.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Apr 2025 23:19:45 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>, Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, aalbersh@kernel.org
Subject: Re: [PATCH] man: fix missing cachestat manpage
In-Reply-To: <20250409160059.GA6283@frogsfrogsfrogs>
Date: Sat, 12 Apr 2025 11:46:48 +0530
Message-ID: <87o6x129bj.fsf@gmail.com>
References: <20250409160059.GA6283@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

"Darrick J. Wong" <djwong@kernel.org> writes:

> From: Darrick J. Wong <djwong@kernel.org>
>
> Fix missing cachestat documentation so that xfs/514 doesn't fail.
>

Thanks for the fixing this. I didn't notice xfs/514 tests undocumented
xfs_db commands. 

The changes looks good to me. Please feel free to take:

Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  man/man8/xfs_io.8 |    3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index f36f1577a2b6c8..3c06e1b4d0fe2c 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -1101,6 +1101,9 @@ .SH FILE I/O COMMANDS
>  Do not print timing information at all.
>  .PD
>  .RE
> +.TP
> +.BI "cachestat off len
> +Print page cache statistics for the given file range.
>  
>  .SH MEMORY MAPPED I/O COMMANDS
>  .TP
