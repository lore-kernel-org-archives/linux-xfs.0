Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4707E1D88BE
	for <linux-xfs@vger.kernel.org>; Wed, 15 Jan 2025 20:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736974470; cv=none; b=SGYyEabbFxqQOkd9ZnsuRpXKCBwZpTOJrebOUKoQ79heznmJ5NaIJLjcPkCM6x23F8JWxSjw554dKo+5jG/k8TWo2Xb8QSBOwS3eGP89skihO0uAMcE2udO5v7YETKQ31fdsgoq5B4t7J7Kc9jLJ1WhzN5xbScuXPt5XJT3jHew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736974470; c=relaxed/simple;
	bh=SmJO5HEPey5x2X0CmeJGvemj40V2g6AgCT0+y8CQ9UE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rrjxW+HpK3ZiojcdWhy6pQ2k4MQzop4fvvUFni7Cq61yRA4vviAaZmhYkttc6zvyLG6f4cwl+FIbe7ycEhJKH2PihRMbVjWucoyYZ9ILZmwftDMcB7brKr5pvjvER3sTvxmrZksWNuSgy0oVQOB+4G3ZsuujmrNIZRUJm95pvZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=koI3VepX; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="koI3VepX"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-216426b0865so2228155ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jan 2025 12:54:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1736974468; x=1737579268; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ghIgydIqFwsC9U2pw8XOauniIphjLqLpglSfb+LVT2o=;
        b=koI3VepXl9Ci7M0O9ujRsIQTVzG0XSPKttGnBUzbKoG+W+nn+s3VF5tvbcWYoIhAJc
         aN4ldqIc1mWAlwTm4/AJLhS+gjFubL2gOggLp3RpQZqdTpybUfATrtvhIXBLOX8NFn/M
         FhaSeETmMFIUnMaepDUuhcnG/W2ZsCK9ASdZ6pYY7m4zttC+3N3/iiMJOz5dI7VByXNC
         7idnRK+VPrmNFX8NDKhvZ1Frg17eEXMbrS5qhnm966nIoa6aqIPmpW3r1WFKrxpOE1St
         dUFwEIa+7ZRe80YoGfab1jIus8x5fpZixc0ssG8V158F3rRxfrYxptYrCWErEkDD/Sfh
         JHgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736974468; x=1737579268;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ghIgydIqFwsC9U2pw8XOauniIphjLqLpglSfb+LVT2o=;
        b=cZHh0I66bza3yxGNsn8/mPYnqYFUUZMvtZ2tbMFujbQsn+g4GmVsVb1zDwMKmKTau1
         BFXfc2+OwhEK9eAIocPtoeKwSo6peKwQiPIi3RSbw8GzDqiR7JLiDH608V7N7B0wkoKT
         jzRVsSV7hQPx1YF0GeUP2wHvkwWpKTrDNnVa5DEvmpLHuH2mLMwZfhmA7eJNq6yZl9ZK
         lvmJ5Nuw98B1Y/Sii9QQNuZ3GkpfDAsrwZq3f7u+TuTGEEbCM/dxC9ckjK9cLb1GHJPb
         P/vESl3dTKjAfH5/lZczygXLgR7bqZUhYfPNSZkhw6toiW4z08Owz0+O20wrDn8zjcay
         0jCw==
X-Forwarded-Encrypted: i=1; AJvYcCXzBtVQiMsjmaNkh4Fr/3r+8Y2CKov2rFXsP/ylJdB0TlFomv2OD7Ps8ifJPB7AvcJU8UnduW3lAlI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKbi/9bFc7dk/EvRg1o9HEvEJBjLHGr6XsqI55Ly4Q71fuj5cy
	6cES3nrdH1FlB6mzL19ltAPnA4tdCZBKTvq/vUB5/YF1F3OifMciDt31zwTANJk=
X-Gm-Gg: ASbGncu1yDIYp2BFNWmI+hPDIat59Djmdqz+GOeboK/w7hAfJeY1+DUYL8JzHPcBbA6
	Kdw7Dwvhnxd+chpsy/iTMEPe3NzRJKFFyy3GtgxVZUewiSj2BjuQ8teqJuLmG8B8T7xEsnArgt7
	6+rWTjxnhExxzxwp7U+i0vYwX6tKqQesxkY47e70WYNLNUTt8gOe1gnY3C/zQgwldT7fitNTujo
	Mz2qP24SMjmIHEpGmHzwZ1UTF1oI4gJGTRZLmSEt4wtc6Z3hfUlaXfkncJbE8AvyTITqVodGSlA
	IJlsFAoNeBfmpPelSOFSdQ==
X-Google-Smtp-Source: AGHT+IFD+wB1XRuYKVi9v0ce634qHRE/4BVz7sMFHJQLAEK5xLBcLUWmke434hOpPeiVz/Mxsst+6w==
X-Received: by 2002:a17:90b:1f8b:b0:2ee:bf84:4fe8 with SMTP id 98e67ed59e1d1-2f548f1d44cmr42217681a91.30.1736974468573;
        Wed, 15 Jan 2025 12:54:28 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f72c2c2e71sm1808527a91.35.2025.01.15.12.54.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2025 12:54:28 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tYAPB-00000006Jtu-30m1;
	Thu, 16 Jan 2025 07:54:25 +1100
Date: Thu, 16 Jan 2025 07:54:25 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jinliang Zheng <alexjlzheng@gmail.com>
Cc: alexjlzheng@tencent.com, chandan.babu@oracle.com, djwong@kernel.org,
	flyingpeng@tencent.com, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: using mutex instead of semaphore for xfs_buf_lock()
Message-ID: <Z4gggRH0QBALn68W@dread.disaster.area>
References: <Z4cBRufxcp5izFWC@dread.disaster.area>
 <20250115120521.115047-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250115120521.115047-1-alexjlzheng@tencent.com>

On Wed, Jan 15, 2025 at 08:05:21PM +0800, Jinliang Zheng wrote:
> On Wed, 15 Jan 2025 11:28:54 +1100, Dave Chinner wrote:
> > On Fri, Dec 20, 2024 at 01:16:29AM +0800, Jinliang Zheng wrote:
> > > xfs_buf uses a semaphore for mutual exclusion, and its count value
> > > is initialized to 1, which is equivalent to a mutex.
> > > 
> > > However, mutex->owner can provide more information when analyzing
> > > vmcore, making it easier for us to identify which task currently
> > > holds the lock.
> > 
> > However, the buffer lock also protects the buffer state and contents
> > whilst IO id being performed and it *is not owned by any task*.
> > 
> > A single lock cycle for a buffer can pass through multiple tasks
> > before being unlocked in a different task to that which locked it:
> > 
> > p0			<intr>			<kworker>
> > xfs_buf_lock()
> > ...
> > <submitted for async io>
> > <wait for IO completion>
> > 		.....
> > 			<io completion>
> > 			queued to workqueue
> > 		.....
> > 						perform IO completion
> > 						xfs_buf_unlock()
> > 
> > 
> > IOWs, the buffer lock here prevents any other task from accessing
> > and modifying the contents/state of the buffer until the IO in
> > flight is completed. i.e. the buffer contents are guaranteed to be
> > stable during write IO, and unreadable when uninitialised during
> > read IO....
> 
> Yes.
> 
> > 
> > i.e. the locking model used by xfs_buf objects is incompatible with
> > the single-owner-task critical section model implemented by
> > mutexes...
> > 
> 
> Yes, from a model perspective.
> 
> This patch is proposed for two reasons:
> 1. The maximum count of the xfs_buf->b_sema is 1, which means that only one
>    kernel code path can hold it at the same time. From this perspective,
>    changing it to mutex will not have any functional impact.
> 2. When troubleshooting the hungtask of xfs, sometimes it is necessary to
>    locate who has acquired the lock. Although, as you said, xfs_buf->b_sema
>    will flow to other kernel code paths after being down(), it is also helpful
>    to know which kernel code path locked it first.
> 
> Haha, that's just my thought. If you think there is really no need to know who
> called the down() on xfs_buf->b_sema, please just ignore this patch.

We are rejecting the patch because it's fundamentally broken, not
because we don't want debugging visibility.

If you want to track what task locked a semaphore, then that should
be added to the semaphore implementation. Changing the XFS locking
implementation is not the solution to the problem you are trying to
solve.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
