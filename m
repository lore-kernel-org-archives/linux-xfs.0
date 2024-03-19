Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A75363
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 00:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710809059; cv=none; b=MGL2Pc38/+2Ii++A4Y9KRieHedh+ByPCwwWGSfXFLMQsBvieBZIqMfZi64hU0XkDrgxdwM7Hha3ZAn8Z1+L30302WeiacmYtR4v4t2ID6EEbiBRb9D7vWOig04L3F9stS1tF+kVn0r0C5ZZNP1mzzKLjTgLneWq2IdQLUF2pnvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710809059; c=relaxed/simple;
	bh=O1NDlqU7Ijl8RaWenY4D0+WfGdeMHVfR1IARPmlhim0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a1Cik/JTlROL+2esnagpMvwZaio4Jmhj96Q/hy8XXsMNAQYnNJoWIexTUkiv3Hgh9CGXLYpJeanUKSmYXdNH5rw5FjzM98KeNfGl9M4yp4ksjNOibagPT3nCLpbel2S9WyaAZeD7KTkA6NbQZh9IgVPrjMB25jSpjfC0HoRcLRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=KKNPwyzA; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="KKNPwyzA"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-221a2d0c5dcso3052379fac.0
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 17:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1710809057; x=1711413857; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GzOLPrVeb2mRWMtbmDyKdRXI7t1VxL0u9LQEOwyvqVs=;
        b=KKNPwyzAIjl5nkP8i4s+ZhK9lzORP1bBFsP2vO67wxas8NIqNvVvmyI4YIrAO/pv+6
         ac1ZhvlvrLZz19IyTFiJKV0zGmHpaaI08y2zPuzCKWiESn8X9KaFkcuq6ifS8HvQGcyV
         PfbOREeqQN6vIDOmvRa4hua00R9uxoYLRsbmHitMkGvFP3vNyXPpGcbvAJS+Qq+5GDaw
         pQwwNNg3+NXTUjLmloaVBr2JCHzIMuLsMuZET/lA36GSrQgETNGZlLgmG/AkdI8BqQ//
         w9ZUEWglEX34tM18TVKY3f/gXB8Aiwy/RZjxefkS4PPRlaX/sjKTchKmaMZ/GxFLJ4Fd
         ALFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710809057; x=1711413857;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GzOLPrVeb2mRWMtbmDyKdRXI7t1VxL0u9LQEOwyvqVs=;
        b=UPz9XETL1jXLyPILCIIW2rptZAgqJ5F8oyOCAgoUUH09s0ajsnrd3eOq0ypGg0Za7S
         4myfEr8370bJUTddmpoo9U9rIymWV7ZScM/L9TMgSPic0u8RKWIQ/8C9H36IZgAcULLL
         6Q+/fD0fIOLD/0HDaig5yEBOKtCm5BjoUtEEzsAyg+QJ/ssJsgX1xnF1Mc9Io67SZzS1
         1AtVFuN1WNzpSfIWj6GaPCFmbJMfhmGR6m3SXL0+HRYyE37DiD3Nsixu0IWbbpeGWdzC
         kG/C8x6oJyv/ck8ODvYPQVFSUe0MN5C0TXg6TZe7H4qeF1gWZ6j3pZmZenzQw332GIl5
         D/yg==
X-Gm-Message-State: AOJu0YwUbKL4QRpt4TfL3k4DksU0d3YBGF0h3vlRv6KKCfmXxYdr79NK
	opdd/eomDGaP0v4F/d1iOfCmndwm1C68L9cMMuol95DqVe0bbze3REUJHTyU8Fk=
X-Google-Smtp-Source: AGHT+IFP7HC7tILcd3qIuEJi507i+Yc/2izYu7Oyajb8Gp4RRLQ6z56eaLw+pqDXuj1mlEOa04kERQ==
X-Received: by 2002:a05:6870:220c:b0:227:139b:954d with SMTP id i12-20020a056870220c00b00227139b954dmr5735767oaf.31.1710809056763;
        Mon, 18 Mar 2024 17:44:16 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-185-123.pa.nsw.optusnet.com.au. [49.180.185.123])
        by smtp.gmail.com with ESMTPSA id lb3-20020a056a004f0300b006e664031f10sm8613552pfb.51.2024.03.18.17.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 17:44:16 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rmNaP-003qJ8-2j;
	Tue, 19 Mar 2024 11:44:13 +1100
Date: Tue, 19 Mar 2024 11:44:13 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 0/9] xfs: use large folios for buffers
Message-ID: <Zfjf3TBzCZSUIQc6@dread.disaster.area>
References: <20240318224715.3367463-1-david@fromorbit.com>
 <ZfjbKh1Yifn7Ok8x@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfjbKh1Yifn7Ok8x@infradead.org>

On Mon, Mar 18, 2024 at 05:24:10PM -0700, Christoph Hellwig wrote:
> On Tue, Mar 19, 2024 at 09:45:51AM +1100, Dave Chinner wrote:
> > Apart from those small complexities that are resolved by the end of
> > the patchset, the conversion and enhancement is relatively straight
> > forward.  It passes fstests on both 512 and 4096 byte sector size
> > storage (512 byte sectors exercise the XBF_KMEM path which has
> > non-zero bp->b_offset values) and doesn't appear to cause any
> > problems with large 64kB directory buffers on 4kB page machines.
> 
> Just curious, do you have any benchmark numbers to see if this actually
> improves performance?

I have run some fsmark scalability tests on 64kb directory block
sizes to check that nothing fails and the numbers are in the
expected ballpark, but I haven't done any specific back to back
performance regression testing.

The reason for that is two-fold:

1. scalability on 64kb directory buffer workloads is limited by
buffer lock latency and journal size. i.e. even a 2GB journal is
too small for high concurrency and results in significant amounts of
tail pushing and the directory modifications getting stuck on
writeback of directory buffers from tail-pushing.

2. relogging 64kB directory blocks is -expensive-. Comapred to a 4kB
block size, the large directory block sizes are relogged much more
frequently and the memcpy() in each relogging costs *much* more than
relogging a 4kB directory block. It also hits xlog_kvmalloc() really
hard, and that's now where we hit vmalloc scalalbility
issues on large dir block size workloads.

The result of these things is that there hasn't been any significant
change in performance one way or the other - what we gain in buffer
access efficiency, we give back in increased lock contention and
tail pushing latency issues...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
