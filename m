Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D002E62C
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jul 2024 22:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721686528; cv=none; b=W2WSmSqsSuIzB4Q1LeV9uIepbzSeEC9fn4joNb3375VguP9DVM0DhYCgUrZUGGAsrj0BfmhjaAhF9NXmDf9gvxe5SZ8kpVWEyF7pk906Sz9JSZPM5ykXwbUWD2RV6Dpxk3UAG6i+XmpPIR0KXjKtCdo1R9i6D03iu7aj7ZcLkYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721686528; c=relaxed/simple;
	bh=5x8aGvC4E55sxp9PLWf5vK2tQQlG4r1BNiohxsrsZZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LzOLW0OgqWzGnipq9R0AkssScepxjEFSrFETDkFj7YwXpminaZb9nEl9ESpWdEdJ6tUT2zQVjqr08azkDvKj/ksqO7FytpfxkRfdwoB6Yv3ndBhLQwkRivjhjnravx4H2YzFgSGbEO6V7Twya2fRPnwC4OiRmGhlQfYlLveES0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=rzKf0RDM; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="rzKf0RDM"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1fb53bfb6easo235665ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jul 2024 15:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1721686526; x=1722291326; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vgAS2a5P2U7bAMdSkmwto9pojkelJzyHGVSfWhJLVxU=;
        b=rzKf0RDMh54aK+fJegOdIawLzmhfOczi5V+pg0607KcoVS8QIpZlieNLRsDD0gLV0g
         uMwd7SDBoNS1LdBQ2Rgaax2sSLyVKhEQwOHrJ61ZIocwiDpvujmlm5eug1ZA5VVSz3s8
         xOcsv+Gf/51zVxb4XoSubYihWlQ3y/TnLb2dnESBmEjyXoKzf+qOokew1kmyUIH4yogC
         80S1TK6lltqAxl16t7jVcVPMPiz9+hq5xWaQFkLvstKo0VGU6wm6Hog1oQ4qQukO07HD
         pr8ViJfta2XSJT4kZR88Ki/aKOJJZAtMwaMISE9cmWKjytYpG6EAtm5WtcQ1SoUGWZnR
         vt9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721686526; x=1722291326;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vgAS2a5P2U7bAMdSkmwto9pojkelJzyHGVSfWhJLVxU=;
        b=nEfEmy3v98Dy0dP0jEDnDGfn6oU8OE1We2NehT75Gzw+7PB0E9gH/+RsuyEthXpO/R
         RGxfetBspqW9uYCz6g1UnjazBH/SAGNgt88h+tJPtYnq1BJ4cIm5pK5uZ8tMxY8ASoOV
         PYlMVr/ZyC25teL3UHVyp/GjNtju2X0S5IzMSaAAr2rPyjmOR6eP5xOtS7qTTGRmICJL
         IP6jmqcfL786isSUW6gTV4H+mc50Dh9OczbaIVoZXYkr5iN77h9J+L2E02QdAn9n8wlM
         BlOOFuZETn/bY0yUV1qA/MhmmA3kMGboAVpmGqwZVYfve2yx9bhK1GDuAxPSBJt7nOQ6
         oBTQ==
X-Gm-Message-State: AOJu0YwU8pwS2uKafFx+YiFnHsFiYa6t6UMceWLtqH81WItExA+u2oQj
	FUSV5+Td8Smlinq7oIWsltc+5nLbyw8iKo5SSsTJ2SJjhe+PeakqBnXruz5xA8A=
X-Google-Smtp-Source: AGHT+IEs6ZHZifFYm0ILfbv1R6iPOVc2eB+LHyQ+QjvXCg8btqiV4D7HdK5XcJeIDGVO1ecRlHkwcQ==
X-Received: by 2002:a17:902:db01:b0:1fb:8a61:129d with SMTP id d9443c01a7336-1fd7461ea07mr61270175ad.56.1721686526121;
        Mon, 22 Jul 2024 15:15:26 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fd6f4533e7sm60116445ad.220.2024.07.22.15.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jul 2024 15:15:25 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sW1JS-007nj6-2s;
	Tue, 23 Jul 2024 08:15:22 +1000
Date: Tue, 23 Jul 2024 08:15:22 +1000
From: Dave Chinner <david@fromorbit.com>
To: "P M, Priya" <pm.priya@hpe.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: xfs issue
Message-ID: <Zp7Z+vLH5qmyGXHV@dread.disaster.area>
References: <MW4PR84MB1660F0405D5E26BD48C5DD7C88A82@MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM>
 <MW4PR84MB16604A5EE24D0CA948F1D2B488A82@MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MW4PR84MB16604A5EE24D0CA948F1D2B488A82@MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM>

On Mon, Jul 22, 2024 at 02:21:40PM +0000, P M, Priya wrote:
> Hi, 
> 
> Good Morning! 
> 
> We see the IO stall on backing disk sdh when it hangs - literally no IO, but a very few, per this sort of thing in diskstat:
>  
> alslater@HPE-W5P7CGPQYL collectl % grep 21354078 sdhi.out | sed 's/.*disk//'|wc -l
>    1003
> 
> alslater@HPE-W5P7CGPQYL collectl % grep 21354078 sdhi.out | sed 's/.*disk//'|uniq -c
>   1     8     112 sdh 21354078 11338 20953907501 1972079123 18657407 324050 16530008823 580990600 0 17845212 2553245350
>   1     8     112 sdh 21354078 11338 20953907501 1972079123 18657429 324051 16530009041 580990691 0 17845254 2553245441
>   1     8     112 sdh 21354078 11338 20953907501 1972079123 18657431 324051 16530009044 580990691 0 17845254 2553245441
> 1000     8     112 sdh 21354078 11338 20953907501 1972079123 18657433 324051 16530009047 580990691 0 17845254 2553245441
> ^ /very/ slight changes these write cols ->
> (these are diskstat metrics per 3.10 era, read metrics first, then writes)

What kernel are you running? What's the storage stack look like
(i.e. storage hardware, lvm, md, xfs_info, etc).

> And there is a spike in sleeping on logspace concurrent with fail.
>  
> Prior backtraces had xlog_grant_head_check hungtasks

Which means the journal ran out of space, and the tasks were waiting
on metadata writeback to make progress to free up journal space.

What do the block device stats tell you about inflight IOs
(/sys/block/*/inflight)?

> but currently with noop scheduler
> change (from deadline which was our default), and xfssyncd dialled down to 10s, we get:
>  
> bc3:
> /proc/25146  xfsaild/sdh
> [<ffffffffc11aa9f7>] xfs_buf_iowait+0x27/0xc0 [xfs]
> [<ffffffffc11ac320>] __xfs_buf_submit+0x130/0x250 [xfs]
> [<ffffffffc11ac465>] _xfs_buf_read+0x25/0x30 [xfs]
> [<ffffffffc11ac569>] xfs_buf_read_map+0xf9/0x160 [xfs]
> [<ffffffffc11de299>] xfs_trans_read_buf_map+0xf9/0x2d0 [xfs]
> [<ffffffffc119fe9e>] xfs_imap_to_bp+0x6e/0xe0 [xfs]
> [<ffffffffc11c265a>] xfs_iflush+0xda/0x250 [xfs]
> [<ffffffffc11d4f16>] xfs_inode_item_push+0x156/0x1a0 [xfs]
> [<ffffffffc11dd1ef>] xfsaild+0x38f/0x780 [xfs]
> [<ffffffff956c32b1>] kthread+0xd1/0xe0
> [<ffffffff95d801dd>] ret_from_fork_nospec_begin+0x7/0x21
> [<ffffffffffffffff>] 0xffffffffffffffff
>  
> bbm:
> /proc/22022  xfsaild/sdh
> [<ffffffffc12d09f7>] xfs_buf_iowait+0x27/0xc0 [xfs]
> [<ffffffffc12d2320>] __xfs_buf_submit+0x130/0x250 [xfs]
> [<ffffffffc12d2465>] _xfs_buf_read+0x25/0x30 [xfs]
> [<ffffffffc12d2569>] xfs_buf_read_map+0xf9/0x160 [xfs]
> [<ffffffffc1304299>] xfs_trans_read_buf_map+0xf9/0x2d0 [xfs]
> [<ffffffffc12c5e9e>] xfs_imap_to_bp+0x6e/0xe0 [xfs]
> [<ffffffffc12e865a>] xfs_iflush+0xda/0x250 [xfs]
> [<ffffffffc12faf16>] xfs_inode_item_push+0x156/0x1a0 [xfs]
> [<ffffffffc13031ef>] xfsaild+0x38f/0x780 [xfs]
> [<ffffffffbe4c32b1>] kthread+0xd1/0xe0
> [<ffffffffbeb801dd>] ret_from_fork_nospec_begin+0x7/0x21
> [<ffffffffffffffff>] 0xffffffffffffffff

And that's metadata writeback waiting for IO completion to occur.

If this is where the filesystem is stuck, then that's why the
journal has no space and tasks get hung up in
xlog_grant_head_check(). i.e.  these appaer to be two symptoms of
the same problem.

> .. along with cofc threads in isr waiting for data. What that doesn't tell us yet is who's the symptom
> versus who's the cause. Might be lack of / lost interrupt handling, might be lack of pushing the 
> xfs log hard enough  out, might be combination of timing aspects..

No idea as yet - what kernel you are running is kinda important to
know before we look much deeper.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
