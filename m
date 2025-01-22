Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05647185B62
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 23:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737588960; cv=none; b=CaVflA7bCMOzW6SsEWyDilXq+t58lkBoTq1ovJnyDu90jVO6EfxMRN2wt+HsjE2iX1tZ6yKG489inwPDCssFthIjta7/zBj4PiL2AE/idwzD5o62UlXG4Co/1c2sMCXsdksc8MBYOi3BTkFfO0U2/H0VtyGdko22Og00l+pmWjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737588960; c=relaxed/simple;
	bh=IUIZ7amWJcDTh/AOG8Asjr28ffYWJP9MY3y3xx/ttk0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hvr0u/nklqS3NazWkp842h8BuI8Fs5suxcz+OOeUWhAf0P2bBw1cEQcQejaxFUhqD/J8/NmA596iiCmaQKFEQBR+QtNTNBElLcDBFRa1nENCUIWKkPB/ezSIxselqcDdevL9WBXZPYRfTCo+ndHDBguK/c3gv4ZKn9jQxiCTGag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=RWC0V26/; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="RWC0V26/"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-21bc1512a63so4417925ad.1
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 15:35:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1737588957; x=1738193757; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PQIZKSNd8OQ+CuQJmCwdgXHO6+w/Fkh8ODeAu97iHYY=;
        b=RWC0V26/viuMgjUV9RjNHAlGBbW3+e9hZ5mxpW6JewuU0QessC014Z5DZmVqWfv05I
         M3xWYt3sGprnPb9Rp4igillDaqU+rsHtEEqmw3Cy1RbNIfv28ZpdVh81GIVn9n8Exdme
         rrSe7JXQkiJfFaiybvS3VLSlmUWio7oEgO5FV93xgc7oQUfUplG0+N05MGkBQ1MNZqfd
         18YjdEjvdm1RKnb0NPry+JlhdGrMpEjSDIsbrKP1doCSiqfGxXyqxWQgQX18twykJHxk
         HFGVBq8oLUx+WDcwq2M0eVwo90f9cmijlZFzKRBEw0B/BzsmTjYcsYG3vcqo1sqrHXLB
         W0bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737588957; x=1738193757;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PQIZKSNd8OQ+CuQJmCwdgXHO6+w/Fkh8ODeAu97iHYY=;
        b=KM1jWNJhMHAXfo6K1me5iMLol9jxyl5fsHEzjmNmL8wBjk4x6Z/Z/oJFIPp8ZyZV7k
         LCfMU2BNDGJz2VHGs/enFL4VT43AQevyjnfLn5vRGH1ZpCg3d6ca7RidtQACu6eQN2yr
         1smuG9I4hzfTIQKdTa7RsauTgbyD9TdjALo8/kmKasRlJ2yfeCB/w9B83AtLI90lHG/S
         Pslrt85shNC3HAmRBnn281zOPkZ6C2tW8LkxdOuQfju66x8SYzPINktrgJYetabH0GpX
         Cs0ucdeMy7evTsCyX5iL8nEKkGDw7NCfSNtLdipH1Wo8awSWlv/2f+VHvr6cmcdL7sgJ
         8BTw==
X-Forwarded-Encrypted: i=1; AJvYcCUsjfcoHqJvAkP1FeXWO+bHweROV7IynVMimBKHRCLzqcqO6WNM/37C924kWJg8mqDWkROpPCoeH7w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3SnZbZhX2O/09XDsR6x2BeRubls0u8NRCjhzVkJCZniP00xhT
	AwXn3NOysvwX4hcoKTL3Gl2LdOfIHc+KR/grZqQvHxaMymvEOyegta1yzUpR8a0=
X-Gm-Gg: ASbGncvMd7KFpfPrPsv6wGIp5EeSDKaYvKD8/AQtVfCMsSfn2qfi0h/79BYaexfZgrZ
	GxLlZ/5EtjCWEtcVMCniLv1D15QQB1SZ2f8GyiE4pAGB6dC4nKeen2IEh8+uxiUoeH5mpDvOJ9r
	EiVK3/4rroKhXU5yKGI11VoqIcf6B1BAXHaJmNQS/4fL7FCpkwRNjcqqjSrrmZou2zrmJ/0WIMi
	6snt/UFNPAeyjHDGoCIBMMelbWPc51XVRxMjrFN+zpCl1HaYfO1a4JEHakm6J1LAjBuM6WJJLeX
	lrYHHriIuzGXTTgjxi3Ci4F0cvcL1bF/rX0=
X-Google-Smtp-Source: AGHT+IEbIemosPcPMqz4QUqnOq5Y3a04UAxJv4Gi5UG/0jI/jDEkwZvs5Q/7Vdqfmtw4fKwGDPsy3w==
X-Received: by 2002:a05:6a20:4312:b0:1e0:cf39:846a with SMTP id adf61e73a8af0-1eb2159019emr38319317637.29.1737588957316;
        Wed, 22 Jan 2025 15:35:57 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72dab9c8dc4sm11899720b3a.94.2025.01.22.15.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2025 15:35:56 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1takGI-00000009HCE-0jDL;
	Thu, 23 Jan 2025 10:35:54 +1100
Date: Thu, 23 Jan 2025 10:35:54 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Brian Foster <bfoster@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chi Zhiling <chizhiling@163.com>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>,
	John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
Message-ID: <Z5GA2rm9wg6xCQTs@dread.disaster.area>
References: <Z4BbmpgWn9lWUkp3@dread.disaster.area>
 <CAOQ4uxjTXjSmP6usT0Pd=NYz8b0piSB5RdKPm6+FAwmKcK4_1w@mail.gmail.com>
 <d99bb38f-8021-4851-a7ba-0480a61660e4@163.com>
 <20250113024401.GU1306365@frogsfrogsfrogs>
 <Z4UX4zyc8n8lGM16@bfoster>
 <Z4dNyZi8YyP3Uc_C@infradead.org>
 <Z4grgXw2iw0lgKqD@dread.disaster.area>
 <CAOQ4uxjRi9nagj4JVXMFoz0MXP_2YA=bgvoiDqStiHpFpK+tsQ@mail.gmail.com>
 <Z4rXY2-fx_59nywH@dread.disaster.area>
 <Z5CLSmrBvp66WHPP@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z5CLSmrBvp66WHPP@infradead.org>

On Tue, Jan 21, 2025 at 10:08:10PM -0800, Christoph Hellwig wrote:
> On Sat, Jan 18, 2025 at 09:19:15AM +1100, Dave Chinner wrote:
> > And, quite frankly, the fact the bcachefs solution also covers AIO
> > DIO in flight (which i_rwsem based locking does not!) means it is a
> > more robust solution than trying to rely on racy i_dio_count hacks
> > and folio residency in the page cache...
> 
> The original i_rwsem (still i_iolock then) scheme did that, but the
> core locking maintainers asked us to remove the non-owner unlocks,
> so I did that.  It turns out later we got officially sanctioned
> non-owner unlocks, so we could have easily add this back.  I did that
> 5 years ago, but reception was lukewarm:
> 
> http://git.infradead.org/?p=users/hch/xfs.git;a=shortlog;h=refs/heads/i_rwsem-non_owner

I have no issues with the concept - I have always thought that
holding the IOLOCK to completion was how the IO locking should work
(like we do with the xfs_buf semaphore). The i_dio_count submission
barrier solution was a necessary hack because rwsems did not work
the way we needed to use them.

What I didn't like about the proposal above was the implementation
(i.e. the encoding of rwsem semantics in the iomap dio API and
implementation), but there was never any followup that addressed the
issues that were raised.....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
