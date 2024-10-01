Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EE2EAC7
	for <linux-xfs@vger.kernel.org>; Tue,  1 Oct 2024 02:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727749384; cv=none; b=qHvWXw4J5nh9EdotqGKjORuiH5Xe2hXWtAfo4Rl/QjRMUyp40UyBzAGRKC22evz6Yu+qHtW5M04kGfj2FaNpv/yixk/oailPMH+o4Q6nlaLw/VqhCiBlfI1tCJgXq/QX6S2MgTWbXGiNqeoF5XpojvD/LoWQ7jThlmFOE4m5lsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727749384; c=relaxed/simple;
	bh=QZmAJyZ9UDzU+NVCWKwlqRikM8II/qcww+fKZE/rahE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EDz7bn935QBDmXII5HXVW8g2ao+k/y+KDYTENku6GuBo/d3pEe5ESkOIzdzppyRT1u/4U7BNm2BY3hEd60yQ6juFcYMytMvwSqsfkAImCaU0mJP5b5+9Fn6fQCR8Ptp8AuflcJxKi2Kp+FMzq+d4Z2wZ17MfgdgkrvOghVtPBI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=d23ZT7fG; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="d23ZT7fG"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-20b7463dd89so22143295ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 30 Sep 2024 19:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1727749382; x=1728354182; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fphHfnJEcRT+CCCigEf6BbGzPILMR7P2aFDlWYLdau0=;
        b=d23ZT7fG+RCcd33CWBJVQL6P5oGR9aaOtfwgfhDaZ4QS13cImj4BTU0yZtGUw/XtpV
         N86gLxUWz3CiZf/zaCV0oX3PSkkqdPJ9+ssXlv+7XjjIq1DMScem0p1IDJd4104pVLIk
         ymHiRwlQKsoJzaDxUIK1HrOcLvD6x0+geAH+RG0w451pENo2XzY/i1NWz3flkDEcEPDi
         gZ0ab0CGjmicZdQjDZZzVEqywUWyNxc7i3+05Koms3rCHXjrKibd+d5PFO2lDOgdR+18
         FCOScNHj8bmht8WvFBFJZQUA1LM5KWkb+g21O7PPYKfR3LITvfAXXg6R9bOYQ16y5oWq
         T8kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727749382; x=1728354182;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fphHfnJEcRT+CCCigEf6BbGzPILMR7P2aFDlWYLdau0=;
        b=qBheHDZqcqzCVUKR7PU3wT5UnzHK21kx3xp3jZybjQMJP5mxkAUaKuhj/kcY44sOID
         0O5ybrhT7S8Tb6CcocQ1XdUoAT3mMfBPDVo1ePvh//Kx7d+wJ/v3FeqO4V3X1CVQoCkM
         wwr5ASkHmoMzt3K7z0wg7lVNkHahY91Q3f6oilfMG7UYGN54xQDFTxKfqKUjkaK2IR8S
         32dMo+pQHVoLEpdKXSY3EdHWS595hIegIymeLtHHyQRE5p1lu1HO596ecFOom8ZFBnbr
         kmSutW3O14T6/c4rPsgnYXU5CfscTIskoXxrqsity2r0vrUGi0mCdUb8ZRQcmQ1hsctZ
         GHLg==
X-Forwarded-Encrypted: i=1; AJvYcCWuIpNO/r2s19lRmymnQPQEzuB5w0ZSn3EuOxHma2ftsUv7z0Pv0PUWH9dRgnMo1mWZZf7vnM01uiU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyE058caGr2rsCK6Pl1lZ1GQWO4TwNMUMWk5lLkMuB1S+IWJ/X4
	Xf4N/Z9pKzOVS8BvG+Qq1PE7XSyHFLSJdLr5DaYaXmqEhIIwZM850JqPF35sd8o=
X-Google-Smtp-Source: AGHT+IEIi8UX+/6HPP0XEhI/lnEGGmhElhXWLrtHf1wP23Nef5qBLLRm8LL8M7x5tzM1YwV1gXAbcA==
X-Received: by 2002:a17:903:41c3:b0:205:5582:d650 with SMTP id d9443c01a7336-20b37bfaae6mr212256425ad.52.1727749382508;
        Mon, 30 Sep 2024 19:23:02 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-78-197.pa.nsw.optusnet.com.au. [49.179.78.197])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20b37d5edbbsm60978415ad.13.2024.09.30.19.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2024 19:23:01 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1svSXT-00CJIe-0I;
	Tue, 01 Oct 2024 12:22:59 +1000
Date: Tue, 1 Oct 2024 12:22:59 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christian Theune <ct@flyingcircus.io>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>, Chris Mason <clm@meta.com>,
	Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Daniel Dao <dqminh@cloudflare.com>, regressions@lists.linux.dev,
	regressions@leemhuis.info
Subject: Re: Known and unfixed active data loss bug in MM + XFS with large
 folios since Dec 2021 (any kernel from 6.1 upwards)
Message-ID: <ZvtdA2A8Ub9v5v3a@dread.disaster.area>
References: <5bee194c-9cd3-47e7-919b-9f352441f855@kernel.dk>
 <459beb1c-defd-4836-952c-589203b7005c@meta.com>
 <ZurXAco1BKqf8I2E@casper.infradead.org>
 <ZuuBs762OrOk58zQ@dread.disaster.area>
 <CAHk-=wjsrwuU9uALfif4WhSg=kpwXqP2h1ZB+zmH_ORDsrLCnQ@mail.gmail.com>
 <CAHk-=wgQ_OeAaNMA7A=icuf66r7Atz1-NNs9Qk8O=2gEjd=qTw@mail.gmail.com>
 <E6728F3E-374A-4A86-A5F2-C67CCECD6F7D@flyingcircus.io>
 <CAHk-=wgtHDOxi+1uXo8gJcDKO7yjswQr5eMs0cgAB6=mp+yWxw@mail.gmail.com>
 <D49C9D27-7523-41C9-8B8D-82B2A7CBE97B@flyingcircus.io>
 <02121707-E630-4E7E-837B-8F53B4C28721@flyingcircus.io>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <02121707-E630-4E7E-837B-8F53B4C28721@flyingcircus.io>

On Mon, Sep 30, 2024 at 07:34:39PM +0200, Christian Theune wrote:
> Hi,
> 
> we’ve been running a number of VMs since last week on 6.11. We’ve
> encountered one hung task situation multiple times now that seems
> to be resolving itself after a bit of time, though. I do not see
> spinning CPU during this time.
> 
> The situation seems to be related to cgroups-based IO throttling /
> weighting so far:

.....

> Sep 28 03:39:19 <redactedhostname>10 kernel: INFO: task nix-build:94696 blocked for more than 122 seconds.
> Sep 28 03:39:19 <redactedhostname>10 kernel:       Not tainted 6.11.0 #1-NixOS
> Sep 28 03:39:19 <redactedhostname>10 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Sep 28 03:39:19 <redactedhostname>10 kernel: task:nix-build       state:D stack:0     pid:94696 tgid:94696 ppid:94695  flags:0x00000002
> Sep 28 03:39:19 <redactedhostname>10 kernel: Call Trace:
> Sep 28 03:39:19 <redactedhostname>10 kernel:  <TASK>
> Sep 28 03:39:19 <redactedhostname>10 kernel:  __schedule+0x3a3/0x1300
> Sep 28 03:39:19 <redactedhostname>10 kernel:  schedule+0x27/0xf0
> Sep 28 03:39:19 <redactedhostname>10 kernel:  io_schedule+0x46/0x70
> Sep 28 03:39:19 <redactedhostname>10 kernel:  folio_wait_bit_common+0x13f/0x340
> Sep 28 03:39:19 <redactedhostname>10 kernel:  folio_wait_writeback+0x2b/0x80
> Sep 28 03:39:19 <redactedhostname>10 kernel:  truncate_inode_partial_folio+0x5e/0x1b0
> Sep 28 03:39:19 <redactedhostname>10 kernel:  truncate_inode_pages_range+0x1de/0x400
> Sep 28 03:39:19 <redactedhostname>10 kernel:  evict+0x29f/0x2c0
> Sep 28 03:39:19 <redactedhostname>10 kernel:  do_unlinkat+0x2de/0x330

That's not what I'd call expected behaviour.

By the time we are that far through eviction of a newly unlinked
inode, we've already removed the inode from the writeback lists and
we've supposedly waited for all writeback to complete.

IOWs, there shouldn't be a cached folio in writeback state at this
point in time - we're supposed to have guaranteed all writeback has
already compelted before we call truncate_inode_pages_final()....

So how are we getting a partial folio that is still under writeback
at this point in time?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
