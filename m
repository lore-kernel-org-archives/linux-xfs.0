Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C6A19AA58
	for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2024 20:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731614529; cv=none; b=JPR7Sdbiqy0vNcv7DFvEy26GIWaegOKbCZAa9fOcaJRV/jRccgUQdNAyFPaw3ihVC5O1ds5vJjQ5Wq0HkdTToju30sedt+d+xFcn5fF0xAAOOdh2sAO3pZT4vgZQCR1KHxBb+PBn8c5l6s7ZC5Jss+378uYzenyRBxPvOpB0ACg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731614529; c=relaxed/simple;
	bh=V6XP1i7PFFdyGExNaauZAMJDNV9j6uXlFgkBWasHe6Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f+tpNWNTHx8Pdi26ocBv76/Yl+cCig607qHfOrsEKgyqGuwvOmyetlxaVfClZH/MfkBmLIeY1E6NtbAITLOZfB2OPMUD85oUPfhrHbo9zQhYAavivPuULIproERtRUMRiNbtQhLMfbWCGByT5EK4gZKzq1wkS5KMbobyPD+KMDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=BvUk9jPv; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="BvUk9jPv"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-7ee6edc47abso768554a12.3
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2024 12:02:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1731614527; x=1732219327; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dydJNRfXOyNIvuL4TwHtyCMvg4SZQJFnVFrxrYbG8yg=;
        b=BvUk9jPvGZ/ONHbjbF0B/mnt48Ui/sR4NZTxz4ABk5h9ykd/QAb3sHFLlEqM12qLw4
         F5McI3tVRbQeXtt2BvXM7yab/2JjYdh+462jtEl4jOovm+eJlgLcHRbS6uvaOriKoeBR
         8psYerAy1rwjZQ6PX4TzpGRzkrTFM8HF2iKVItPD1EqWFP4zW2TKFBG+PhcBsaIEjV0K
         zPyQcoDLmiqLDIyM4uxAXkEq2thPN5lnEiY9Im00GO2epbH0oq6Q0Q/fQZiY4qHnJbzb
         L9r85MTcJASnawf9/GaNsPLJ+9RNeDjNx8DhbPEx+31yoRanrBG9EAYBVagU3hNfMEsc
         tIRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731614527; x=1732219327;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dydJNRfXOyNIvuL4TwHtyCMvg4SZQJFnVFrxrYbG8yg=;
        b=Yfe0SRFTn4cQvan66rcYApxJP7ZDVEDkVSGyV8m9FkEx56egP96nrjOMaUkAJIp+Ea
         I1xQP0o6keUI+uPoWqKnFSkxvT4VqW9HJtzc+BdoeuUEdJsxxwPDZ6D2HmeFxmnfVT+P
         eC2DyYL5yC2htVPwZebVP/lN32QdJJkZJqVbqOw6MCYG851/fLujiiCsenXCjkfKZcm2
         zOd8FWMWgz5CbqSrLp/VF/0I86iCaitpQR3gbc7SONvUYA0YFLYA7NrLlt8zkGIjE1+d
         IzsE8wO/JBRhcedwpEW6tMGk19PH06F3mYJ+wpoV483+O1GdpSUm6flPvrHTvcD9oNht
         ohvA==
X-Forwarded-Encrypted: i=1; AJvYcCXZSdgyTShkPKWTlsP66QMG0MwRcHgxIDBNmXRLHrxbtzf352TuKPMQoO5kBVBOiwx8I9YSAG7AY6E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7urS7K3XQh5Cvjd1CQRk4zLKQ7AeFDNtRLxN69NjXQTr1YxJG
	8z8kbDskh+Ln0HYth1BIkvIirXINaKb8cxjzjWxGkAXB6NpzSZjeF3FBpFoaEjM=
X-Google-Smtp-Source: AGHT+IG+Hekh/1lfeTIb2DJXZEZom0V9AUlxgNcE8klAVkeipHOq3EzqF2dUI3eb6/GO0465gBmXSA==
X-Received: by 2002:a17:90b:1e01:b0:2e2:af54:d2fe with SMTP id 98e67ed59e1d1-2ea155aa2a7mr148185a91.34.1731614521287;
        Thu, 14 Nov 2024 12:02:01 -0800 (PST)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ea0a6b226bsm1374261a91.42.2024.11.14.12.02.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 12:02:00 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1tBg2Q-00EgF1-0E;
	Fri, 15 Nov 2024 07:01:58 +1100
Date: Fri, 15 Nov 2024 07:01:58 +1100
From: Dave Chinner <david@fromorbit.com>
To: Brian Foster <bfoster@redhat.com>
Cc: Long Li <leo.lilong@huawei.com>, brauner@kernel.org, djwong@kernel.org,
	cem@kernel.org, linux-xfs@vger.kernel.org, yi.zhang@huawei.com,
	houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH v2 1/2] iomap: fix zero padding data issue in concurrent
 append writes
Message-ID: <ZzZXNoOsFRqcd6ge@dread.disaster.area>
References: <20241113091907.56937-1-leo.lilong@huawei.com>
 <ZzTQPdE5V155Soui@bfoster>
 <ZzVhsvyFQu01PnHl@localhost.localdomain>
 <ZzY7r1l5dpBw7UsY@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZzY7r1l5dpBw7UsY@bfoster>

On Thu, Nov 14, 2024 at 01:04:31PM -0500, Brian Foster wrote:
> On Thu, Nov 14, 2024 at 10:34:26AM +0800, Long Li wrote:
> > On Wed, Nov 13, 2024 at 11:13:49AM -0500, Brian Foster wrote:
> ISTM that for the above merge scenario to happen we'd either need
> writeback of the thread 1 write to race just right with the thread 2
> write, or have two writeback cycles where the completion of the first is
> still pending by the time the second completes. Either of those seem far
> less likely than either writeback seeing i_size == 8k from the start, or
> the thread 2 write completing sometime after the thread 1 ioend has
> already been completed. Hm?

I think that this should be fairly easy to trigger with concurrent
sub-block buffered writes to O_DSYNC|O_APPEND opened files. The fact
we drop the IOLOCK before calling generic_write_sync() to flush the
data pretty much guarantees that there will be IO in flight whilst
other write() calls have extended the file in memory and are then
waiting for the current writeback on the folio to complete before
submitting their own writeback IO.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
