Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCB01B808
	for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2025 03:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737429163; cv=none; b=o5D3aqeks9RPkSUSfP68SFCNUh/F8BoKBeGAYt3npNxl8jyTjFltFI+TSLf2JtVKiLN5zZtHnuAeG0avs+IlXgcX3qIOxma1aF9ySqfiCFatB023zaWQOkuI2j47MVkFjOoEEcTzdCbN0UTCYOGh60Jmlh7ndbI2OhEkrCDa92M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737429163; c=relaxed/simple;
	bh=tvpEwhsEdzNbeXkgEKkfvIfOZAl8IuNqZBVhewwKTr0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uShZrQBVBYRgCrst/nE32y1cK5QL0/7LUT7SwpMvR3AvVUtk8Hvor5ontUtzZw2ifXHlG1oFYYhAWYCNbIm+AP8v+YVgLQhcPyByw8YvvhBtGfv/5NNcXc61uY1C8hvLBLUs6N6KIKSpql1RWbKhVGpsJOGuZ7R6oPkzBFbVCmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=u9CaEkrL; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="u9CaEkrL"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-21680814d42so83253765ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 20 Jan 2025 19:12:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1737429162; x=1738033962; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7+vkBMDJ3nJL+cOp3+IPRsJr5TcdIL0qyzrFk3x1JIc=;
        b=u9CaEkrLBIeXtLdKR+g2JjyKQAuC7GBUMSa9A+80F9efGzgS/9sWxvvnsH/9HS6M4L
         hbHVbRttQHS4zQL604x+4R15ethHCC/GlIcFIKPxhusWx0vqnp+csIsR2TObrBllSHCW
         nmlw3V6uqaNkhEyHlE/YPQfqK4MVG1dzehvcnTBUn7t2d0qhmYiwM3opbLGOMmX7yMAD
         KVyWq1eYPukBxZfBtMZ7mcPyZPCXyqYpNeC/bPPXso+0j6s3ReD6DwQfde7NjNm3RfuE
         SLWKLFFUrvgi37vXgURBtxrsIkXZVnMhjXLnrdLIKG5dfVe+wFczHYrEIdkSMGIuQutC
         jpPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737429162; x=1738033962;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7+vkBMDJ3nJL+cOp3+IPRsJr5TcdIL0qyzrFk3x1JIc=;
        b=g40LWZWEN57WIt1Zv/qYoJBAVsrgbrx8SpRoV6stzFU9JSzihhnrou/6PRnOYL5cs5
         +m6vvOElfYwdX7y6UgiY8GUgiaOfYc8owD/t6Xsz3FFd0o5NkImE0LA/63ZCfNtsbgNW
         6uY7dGtSS+73sx9woy0PO01uCnfXscFbu4mnsl4SDi8tAYT181nSYZYLrggjA5e4buDc
         pn3QmWCU7mpoxZn80nSgwe2Gdio7LD12SEF8jeCm4Kqpxraxqi2C0VU//H8BJDxzlwlG
         awfxTNyUROmSkkTOmd4QXEaaTs7Q6WYnn3sELHFIqDSoQb8OwMlLBx31JTjDF59CO2FG
         B/tw==
X-Forwarded-Encrypted: i=1; AJvYcCV+DI2QWJawjWHdlQCM1kM+YW92fN8Qhtjyo9VxsXH1LuKfMFNorWjCiM0Q5TqW24LZZiTDuLwSQx8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yysh1fyV8xqDnu1l+5oNuvZBGhSIJiAZ5CGHoxjsbRSDaLOJUah
	jOT1iMiTpxSkl/JsQYC78ajbMkRe8lrV2rTSuNX8Wx0EIp0qfvnzU3D2s2G55vk=
X-Gm-Gg: ASbGncvLGY03ovn7Q0mG1HLc98tsNh2eSsYKW71we49MdU96q+SYxMwOxBYlsU4Ucpw
	I/QvQy8I+hHbyHt+bicG9eJRI5BvVO0hLaxXWTpe5PkWmo62TM4yyjhKpltGYxnN13hQqtc3bsD
	9V5CcZYAAyPj59Bxf6vM07EnRXzPb3w1SbBsHN47OxP/aoGEJvkfCnb+gBM0ZfpS1rYSraHqRSO
	Aj+NFW8iWs7r9JdBTIBLYoou5dHvIF8yyeF5tTfH66fALkAoGdycoI6LoESciu4gkBvGaZQ5c1P
	8sQ6KysiMPCSaCeRFVSOEqPCCwgleyEm6yQ=
X-Google-Smtp-Source: AGHT+IGVclWoHV11LetKGs3oF5rs9605WVQmttif0csWu59P5kHjS5yglmJljQVCeEYkOlMWmJOgQw==
X-Received: by 2002:a17:902:e743:b0:215:a039:738 with SMTP id d9443c01a7336-21c352de481mr256554995ad.5.1737429161635;
        Mon, 20 Jan 2025 19:12:41 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21c2d3d989fsm68028975ad.181.2025.01.20.19.12.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2025 19:12:41 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1ta4gw-00000008VDg-2pKB;
	Tue, 21 Jan 2025 14:12:38 +1100
Date: Tue, 21 Jan 2025 14:12:38 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/23] generic/019: don't fail if fio crashes while
 shutting down
Message-ID: <Z48QpvLQCgbu6-pr@dread.disaster.area>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
 <173706974152.1927324.14222114120134004551.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173706974152.1927324.14222114120134004551.stgit@frogsfrogsfrogs>

On Thu, Jan 16, 2025 at 03:26:28PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> My system (Debian 12) has fio 3.33.  Once in a while, fio crashes while
> shutting down after it receives a SIGBUS on account of the filesystem
> going down.  This causes the test to fail with:
> 
> generic/019       - output mismatch (see /var/tmp/fstests/generic/019.out.bad)
>     --- tests/generic/019.out   2024-02-28 16:20:24.130889521 -0800
>     +++ /var/tmp/fstests/generic/019.out.bad    2025-01-03 15:00:35.903564431 -0800
>     @@ -5,5 +5,6 @@
> 
>      Start fio..
>      Force SCRATCH_DEV device failure
>     +/tmp/fstests/tests/generic/019: line 112: 90841 Segmentation fault      $FIO_PROG $fio_config >> $seqres.full 2>&1
>      Make SCRATCH_DEV device operable again
>      Disallow global fail_make_request feature
>     ...
>     (Run 'diff -u /tmp/fstests/tests/generic/019.out /var/tmp/fstests/generic/019.out.bad'  to see the entire diff)
> 
> because the wait command will dutifully report fatal signals that kill
> the fio process.  Unfortunately, a core dump shows that we blew up in
> some library's exit handler somewhere:
> 
> (gdb) where
> #0  unlink_chunk (p=p@entry=0x55b31cb9a430, av=0x7f8b4475ec60 <main_arena>) at ./malloc/malloc.c:1628
> #1  0x00007f8b446222ff in _int_free (av=0x7f8b4475ec60 <main_arena>, p=0x55b31cb9a430, have_lock=<optimized out>, have_lock@entry=0) at ./malloc/malloc.c:4603
> #2  0x00007f8b44624f1f in __GI___libc_free (mem=<optimized out>) at ./malloc/malloc.c:3385
> #3  0x00007f8b3a71cf0e in ?? () from /lib/x86_64-linux-gnu/libtasn1.so.6
> #4  0x00007f8b4426447c in ?? () from /lib/x86_64-linux-gnu/libgnutls.so.30
> #5  0x00007f8b4542212a in _dl_call_fini (closure_map=closure_map@entry=0x7f8b44465620) at ./elf/dl-call_fini.c:43
> #6  0x00007f8b4542581e in _dl_fini () at ./elf/dl-fini.c:114
> #7  0x00007f8b445ca55d in __run_exit_handlers (status=0, listp=0x7f8b4475e820 <__exit_funcs>, run_list_atexit=run_list_atexit@entry=true, run_dtors=run_dtors@entry=true)
>     at ./stdlib/exit.c:116
> #8  0x00007f8b445ca69a in __GI_exit (status=<optimized out>) at ./stdlib/exit.c:146
> #9  0x00007f8b445b3251 in __libc_start_call_main (main=main@entry=0x55b319278e10 <main>, argc=argc@entry=2, argv=argv@entry=0x7ffec6f8b468) at ../sysdeps/nptl/libc_start_call_main.h:74
> #10 0x00007f8b445b3305 in __libc_start_main_impl (main=0x55b319278e10 <main>, argc=2, argv=0x7ffec6f8b468, init=<optimized out>, fini=<optimized out>, rtld_fini=<optimized out>,
>     stack_end=0x7ffec6f8b458) at ../csu/libc-start.c:360
> #11 0x000055b319278ed1 in _start ()
> 
> This isn't a filesystem failure, so mask this by shovelling the output
> to seqres.full.

looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
