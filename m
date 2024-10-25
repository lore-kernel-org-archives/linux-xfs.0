Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7E219993D
	for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2024 06:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729837753; cv=none; b=BRtl21iyx/Xg0wVXMdvErZxYds2ETIKOQHYD8RrPrOnuzKJ+09I1RnmZphpWyRUXhvHkd0Grbc28qjfZbQxInQrqlAhwD/+cQVM84ipamftAV0AUvjJCOVYDU3Z1qHrFex3S3TCor8P+51HqH94MQW7JRlNul5y4I+z6DFXtcDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729837753; c=relaxed/simple;
	bh=lXAEjM6XQBdPrpdvys1m8dWrReRdfQ157UMzTkZc68w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kbCzFacj4D3TXYREuS2WTlG0SJEKgG1AcyWom09XH0OlDBVnSWgzpt3E3n10f39ttyTLCkMvngpXHuCwxg/F0YEnRWIlgLdM0PHhUqmOjd9VMrSQ2HwTNPtW5/I1VZ/LCySv9eFrTQ480SsDbTQwglrNB1TES3mWYjginRgXZaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=xavgKTnb; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="xavgKTnb"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2e2e8c8915eso1255375a91.3
        for <linux-xfs@vger.kernel.org>; Thu, 24 Oct 2024 23:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1729837750; x=1730442550; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R34AffjiRfd1LJBTXBUb7rrqnh7/FkEP8kDGT5MzEic=;
        b=xavgKTnbScdmS6WcR1Ppa1dpEzokiStRsZEGTLDBZKa1XOtnkMB1kBPlURiAlra1xO
         zd83yd7NtZSrZ9fJOsu6Uk42KS6P3vBmJaziK1aNfsi5o9HN0fy7tLmRvidRBb2S3tgp
         PQW/t0SYzydbALt+Bp+wmsgzNpy+n5kqj0rT1zwaURbv6kOxpX/ewfv5JdmZM80vBBeY
         iMvPYA2cyXXy8hyBwWZ8GL3pseCldIo7ApesNtglTDFZAOoZE4OilJQVyy7TxTDQt+O3
         Ha9lNXCKPlIp8QH1UvmRWkblO9w+Ce1VVBekEZGeZfrWeLxi3O94b2oRLE3mfX+La07L
         q4fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729837750; x=1730442550;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R34AffjiRfd1LJBTXBUb7rrqnh7/FkEP8kDGT5MzEic=;
        b=ngC+r//eVlHmNsXLS6JEOZnt/V0AMLc5rEpA8UhdBJYsdga1Y20vIEc/FyMRpZ232n
         QDD2NMP85CTQqsUHU7SF1geBasvY3yxP+LfHQVopjfrg+HLqaF7eFPEkK6auTtRFaemi
         VVe1UJ9Hn57seiSeox1PAu5dacJn0ma6y574fGFdNEahYclYwxNnjpRBNHFEmOdQdl7w
         CvZ60CoNcuwRv+bjzuLoOxral/xBGHXeMHQQh54fUsJvl0v14qIo4cNo2wdIPSYEjJOL
         TxZwZTO5T1wF5uYwdOiUpYq/BE/T7DuER0AR7uot9iX6+CKJ1rnIXQljSLDZ1t8NYumT
         b5BQ==
X-Gm-Message-State: AOJu0Yz6pXtVWudd0ZzH1HnvtWmKxxIIUqB81DnSrnSoT+unzNfD/49c
	lq2RfiUTyIloT25aA8z2le1OaPGlaw4TSTYnFbWxrA/0PR9gCzHM5vVgopmhS/Q=
X-Google-Smtp-Source: AGHT+IFODc6njl+wAFVlRFrq6P9vp7VweiYSqddQ00zvs7Xv3OK63GzgfklMI1XlnQrMmwnIfiZbzQ==
X-Received: by 2002:a17:90a:8d0a:b0:2e2:d9f5:9cf7 with SMTP id 98e67ed59e1d1-2e76b6cdb2amr9225560a91.26.1729837750312;
        Thu, 24 Oct 2024 23:29:10 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e8e377179asm573558a91.53.2024.10.24.23.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 23:29:09 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t4Dop-005TMU-0H;
	Fri, 25 Oct 2024 17:29:07 +1100
Date: Fri, 25 Oct 2024 17:29:07 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/3] xfs: sparse inodes overlap end of filesystem
Message-ID: <Zxs6s/UqQgCf3Ad5@dread.disaster.area>
References: <20241024025142.4082218-1-david@fromorbit.com>
 <20241024163804.GH21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241024163804.GH21853@frogsfrogsfrogs>

On Thu, Oct 24, 2024 at 09:38:04AM -0700, Darrick J. Wong wrote:
> On Thu, Oct 24, 2024 at 01:51:02PM +1100, Dave Chinner wrote:
> > I'd prefer that we take the latter path: ignore the first patch.
> > This results in more flexible behaviour, allows existing filesystems
> > with this issue to work without needing xfs_repair to fix them, and
> > we get to remove complexity from the code.
> 
> Do xfs_repair/scrub trip over these sparse chunks that cross EOAG,
> or are they ok?

Repair trips over them and removes them (because they
fail alignment checks). I haven't looked to see if it needs anything
more than to consider the alignment of these sparse chunks as being
ok. I suspect the same for scrub - as long as the alignment checks
out, it shouldn't need to fail the cluster...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
