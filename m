Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7112DDF71
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jul 2024 04:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719807883; cv=none; b=DWQRv1BbfKDJ7ywtCNIzdj5K6viwmj5/1E/sW9KOwfQmnfShoMzxgyfSY+WOgU0XOp1Nwzd2mPx6TVmqezeNYDVaJs2nJ4sYGNlg3qq2dEV29glqrzk936o0weyzH3US+N4QQI+NmF/DxY8O1BUBVsZ3CSQGx9cml29I5MHCPqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719807883; c=relaxed/simple;
	bh=paVAf+8j2Ao8wNZ6d9H4Go6mO+YeHszO+g9YMet+gN4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KBakxUfyPzIKh0jJ0On3J6a9S+vlnmbf2pPRu2eaZJCH+vxjHRtpTstqNeAvWgBAbKgK0dkL4aP1Gim5OA3qGrWqiKWJZyUapFoaU10RQmcf6ijTNZ1MiO2Fs3YI9XQ1RyUP7pp0yLb3vbtEwdz1X3Q2kz9bAkm2b0Cei2XuZHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=xUdX3f89; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="xUdX3f89"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1fab03d2f23so16706265ad.0
        for <linux-xfs@vger.kernel.org>; Sun, 30 Jun 2024 21:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1719807880; x=1720412680; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q8FaXxeW49XxQjIVoOOnJuKPW6Isofg2ljkc7tdAOtU=;
        b=xUdX3f897Grs5cWWuQ2CuoY+jfH5lwciBkIJtBCf7XHn5Vy6PLpf3Y0oEYflVH6KRZ
         cYzqRjL46Mhp7NxfpjavH3SLzSlx/uSa+Ln6e3xWzWkLpvU+SfWd11Q1NUXSphwk/a55
         6NmKjcHlf15ki8DBVRvoXxG9iAS8BoybM1PwJHIm2FC/Xyljt+0GJqf8Ngywja2J2Ww9
         D7HdBC8qSbQMyH3T7iDhdnoO18ctAczp+b2l/XZzsQNlAQ1DbgvNmMyhXtCE/zKg1CQ5
         RXhY8LPV6wTdbxdJutRYXNqMgvPmIWb0wLA295TCggO7vn7bIjBeCllNLk12n3yQw1Ko
         M1cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719807880; x=1720412680;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q8FaXxeW49XxQjIVoOOnJuKPW6Isofg2ljkc7tdAOtU=;
        b=OtIomdWHRXSjm7KdF4ucnBiCfR2y306gNtg231D2mFjkNNnuSs8Yw1iu55ZJGRqBD/
         1fnb/HKps1UBizbKrKpmZOtF1PHJ3ryd/wVwlPjqB5Am8H0niiBIl9o1gt0Pqpca8s/d
         bU1C960NRB3lshObxXZa6BU50/4LO7ce2y1/K8/4sqXAZxVDXByV/QiBrgY8iSb8Zl2G
         +f9asK4AwfjlPrVylDfAmJDmFxTPRVUSHAAFfKzQh/p3DOmw19/gUOLZ6IpMpjvT8Ogo
         i0ONwRudOjGtiewwncnjciIU8rCBJ4cFaAQklqw1yUrwihYDiSGDZJZ6hG+JF3tyLe00
         qnGA==
X-Forwarded-Encrypted: i=1; AJvYcCVjqYJkgNgxuLMY5j4jW7JfZjlO/5mf077Q9bf3rzXxjNMvTtzIOCRYNa4VeqHDg8YxwxM9HUOqfQ6ciJ0ahQS8a3jeKskTunSs
X-Gm-Message-State: AOJu0YyMuq5APMNZK6b1IpTM0EPED0q1lUah3AE5NH1JecUi26Qf7Fgh
	7uNHYHrC+FFXf11LAqne7ZNXUAoQiaRZOF1Yg50pwKp1Vjn4w5p4Y8NpdZDM4mY=
X-Google-Smtp-Source: AGHT+IFKQ7mlIRHK3qLypxLI+wB6C/xuRboouR5zOv5/KrFwuLBxwDWk/1+R28Hzvt5tq0xC0UW+Zw==
X-Received: by 2002:a17:902:d2cc:b0:1fa:2d0:f85b with SMTP id d9443c01a7336-1fadbce9d59mr26040185ad.49.1719807879574;
        Sun, 30 Jun 2024 21:24:39 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fac1569051sm53926215ad.215.2024.06.30.21.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jun 2024 21:24:39 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sO8ai-00HWNB-2Q;
	Mon, 01 Jul 2024 14:24:36 +1000
Date: Mon, 1 Jul 2024 14:24:36 +1000
From: Dave Chinner <david@fromorbit.com>
To: Alistair Popple <apopple@nvidia.com>
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, logang@deltatee.com, bhelgaas@google.com,
	jack@suse.cz, jgg@ziepe.ca, catalin.marinas@arm.com,
	will@kernel.org, mpe@ellerman.id.au, npiggin@gmail.com,
	dave.hansen@linux.intel.com, ira.weiny@intel.com,
	willy@infradead.org, djwong@kernel.org, tytso@mit.edu,
	linmiaohe@huawei.com, david@redhat.com, peterx@redhat.com,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	jhubbard@nvidia.com, hch@lst.de
Subject: Re: [PATCH 00/13] fs/dax: Fix FS DAX page reference counts
Message-ID: <ZoIvhDvzMCw28VBI@dread.disaster.area>
References: <cover.66009f59a7fe77320d413011386c3ae5c2ee82eb.1719386613.git-series.apopple@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.66009f59a7fe77320d413011386c3ae5c2ee82eb.1719386613.git-series.apopple@nvidia.com>

On Thu, Jun 27, 2024 at 10:54:15AM +1000, Alistair Popple wrote:
> FS DAX pages have always maintained their own page reference counts
> without following the normal rules for page reference counting. In
> particular pages are considered free when the refcount hits one rather
> than zero and refcounts are not added when mapping the page.
> 
> Tracking this requires special PTE bits (PTE_DEVMAP) and a secondary
> mechanism for allowing GUP to hold references on the page (see
> get_dev_pagemap). However there doesn't seem to be any reason why FS
> DAX pages need their own reference counting scheme.
> 
> By treating the refcounts on these pages the same way as normal pages
> we can remove a lot of special checks. In particular pXd_trans_huge()
> becomes the same as pXd_leaf(), although I haven't made that change
> here. It also frees up a valuable SW define PTE bit on architectures
> that have devmap PTE bits defined.
> 
> It also almost certainly allows further clean-up of the devmap managed
> functions, but I have left that as a future improvment.
> 
> This is an update to the original RFC rebased onto v6.10-rc5. Unlike
> the original RFC it passes the same number of ndctl test suite
> (https://github.com/pmem/ndctl) tests as my current development
> environment does without these patches.

I strongly suggest running fstests on pmem devices with '-o
dax=always' mount options to get much more comprehensive fsdax test
coverage. That exercises a lot of the weird mmap corner cases that
cause problems so it would be good to actually test that nothing new
got broken in FSDAX by this patchset.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
