Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F1718E756
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jan 2025 20:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738010963; cv=none; b=UoJ2gLEuDZkYby19FP4hAoxppVg3sDA6D15luFyNy09sz+e03XPShHV0xvkzlgvK0iaHld92KsZGF3lfJLH25qrv9+VeomLxjb2xwZzDkMT4WCmvkF8Ud/Lx5yuSJsT0e1tTGrRuRgDa8M3wmx6ImdMsoVyBuwT7Qr0rxm/SezY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738010963; c=relaxed/simple;
	bh=bvBjFqaJ7UktweLPg1BtZVJWiau3uEPhJYmXGSZY0PI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CIPmIR/Lcy6qVVSnEWvF3ti6Wa1acVy0nRwyhDlqhN9AEVjOkFmVXPOlnvAYx2s1GMpf7Z6B6KAyL5bCcoLUFChvvhleMo5SRcl6TMLzmKo2cNWB6O+CXKybXEAPkmPgDPVD3TJlHsgwwUsi8+3zC7eGEQeCZOqskVH7jGXalbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=o0JjqNA7; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="o0JjqNA7"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2166360285dso83527215ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jan 2025 12:49:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1738010961; x=1738615761; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2nGC3qbOoAnArGFLSK/GsYSWsgr7XaBANkkv18PP2QM=;
        b=o0JjqNA7u2uJG9k7L3ODLKt7BVjw6qN/PYLffvL9iltyrydEuNsAqp57W8XULcQnFm
         SUzp+S2dDAfLF2brhnJKeMCCMGhfe8565gvX6nCNxBXfa2Rmaoq8glVZWZ1Xn8YVu8/7
         jExf2JIUWFYAWT7A49MDh9CUe/BoXXfZCbVu13bkjO7nPbyUrgP1CXeSmoSAtYpJv8h8
         ekmfXGkGwadl8WKopVLYR94T6MfI35Pwzc3cxYo7RCJlDnL+/iD0itXFbJ8R14KIE1c2
         jMQD6ybw3YePV8YLtRjyZ7fhLEPaKvrT/jSHQ1NO3llK9THbqABN9h9ewdJQVRHF7Pjz
         O5Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738010961; x=1738615761;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2nGC3qbOoAnArGFLSK/GsYSWsgr7XaBANkkv18PP2QM=;
        b=uhE1vMM2k/KMAQSlEdnGWVyiRIjidolPM58kRzDiA8EuXI7D/Re3Tc/u+kYz+lIM0s
         xhcU385rRoMcRF9S788Rc6sSgUscOG0CjlUTdrJwPyPX2Fn12m3cJdxga/QJzOBnVeow
         yie+M5zyMmJcDTrk6jJ7a5MhUxDq67qgCKEKZpf/iBp8q+tFwIaECvQp9Ut0GweJHawg
         Fx7UcyChiwLuLdiWlxerd29o/+tkfX89kxvCh+5AaFn/xjg1UTF7+zrl2f1hnl8jGN4i
         Hgu4pnhddYX1LsceHry+PUkb6RxVQK5LaYHzK5IRp2xGsutYqqUmZpsju4Ap+qqQ08m/
         RExQ==
X-Forwarded-Encrypted: i=1; AJvYcCXqXQ3uz+xYgzw8RmGp3PGE07kGFBt1wiAjdf9UEtMxQQhWP6k2tUrkWiYa3hhDnzNgUf8OLIbZjaU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEje13QJz2ChK2qsxMsfshURTbIfKSdf46xFCHmXyAoaQ+5wFP
	ZncKoBgID9pbeu85mi+kMmg0B0KUbZdwu7XemX0X0ESQ9APBzQyBpYbgDm7lRyU=
X-Gm-Gg: ASbGncvlW4rovKB8qUOgO4n0kaIIlmz0mydJNnEK8ST92iH7ThnI6qbHPo07AZERSdX
	JNdUWoyF9TKnMSKAnOiwTv9P5x/u2qbAmwgHIHCEs5Y7t7qt7/P83NuE3N8gYYeZOiqueyn0TJS
	cPbA3w0lGL8bkSKeGuiEMMGFCJhquKGlH4UJkWW8hdXYnR71iD64NrvRvlqRRGVL5qtXRYjuiZa
	lSnAOg04Pm2ghtWpgzxp/8+tzDAHBHF/D2LWwH9Dguswb7LmbJnf/tOLNpBDn50H7LZuEcHcGp+
	IvsiDyA1I9edpyMR/rLtw00IzghedUoIRrO7nVORL//JYzWc7JUbGW30
X-Google-Smtp-Source: AGHT+IGQWSprrmYRN5kel6rJULxFQhs+h0z14xiaDf0rpVheMNBMda043YP8qClx5P50t6iQ3sQiGw==
X-Received: by 2002:aa7:8884:0:b0:72a:bc6a:3a88 with SMTP id d2e1a72fcca58-72dafaaf2f2mr57214501b3a.22.1738010960967;
        Mon, 27 Jan 2025 12:49:20 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72f8a6b31besm7857737b3a.54.2025.01.27.12.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2025 12:49:20 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tcW2n-0000000BJEt-3Idu;
	Tue, 28 Jan 2025 07:49:17 +1100
Date: Tue, 28 Jan 2025 07:49:17 +1100
From: Dave Chinner <david@fromorbit.com>
To: Chi Zhiling <chizhiling@163.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Brian Foster <bfoster@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>,
	John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
Message-ID: <Z5fxTdXq3PtwEY7G@dread.disaster.area>
References: <953b0499-5832-49dc-8580-436cf625db8c@163.com>
 <20250108173547.GI1306365@frogsfrogsfrogs>
 <Z4BbmpgWn9lWUkp3@dread.disaster.area>
 <CAOQ4uxjTXjSmP6usT0Pd=NYz8b0piSB5RdKPm6+FAwmKcK4_1w@mail.gmail.com>
 <d99bb38f-8021-4851-a7ba-0480a61660e4@163.com>
 <20250113024401.GU1306365@frogsfrogsfrogs>
 <Z4UX4zyc8n8lGM16@bfoster>
 <Z4dNyZi8YyP3Uc_C@infradead.org>
 <Z4grgXw2iw0lgKqD@dread.disaster.area>
 <3d657be2-3cca-49b5-b967-5f5740d86c6e@163.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d657be2-3cca-49b5-b967-5f5740d86c6e@163.com>

On Fri, Jan 24, 2025 at 03:57:43PM +0800, Chi Zhiling wrote:
> On 2025/1/16 05:41, Dave Chinner wrote:
> > IOWs, a two-state shared lock provides the mechanism to allow DIO
> > to be done without holding the i_rwsem at all, as well as being able
> > to elide two atomic operations per DIO to track in-flight DIOs.
> > 
> > We'd get this whilst maintaining buffered/DIO coherency without
> > adding any new overhead to the DIO path, and allow concurrent
> > buffered reads and writes that have their atomicity defined by the
> > batched folio locking strategy that Brian is working on...
> > 
> > This only leaves DIO coherency issues with mmap() based IO as an
> > issue, but that's a problem for a different day...
> 
> When I try to implement those features, I think we could use exclusive
> locks for RWF_APPEND writes, and shared locks for other writes.
> 
> The reason is that concurrent operations are also possible for extended
> writes if there is no overlap in the regions being written.
> So there is no need to determine whether it is an extended write in
> advance.
> 
> As for why an exclusive lock is needed for append writes, it's because
> we don't want the EOF to be modified during the append write.

We don't care if the EOF moves during the append write at the
filesystem level. We set kiocb->ki_pos = i_size_read() from
generic_write_checks() under shared locking, and if we then race
with another extending append write there are two cases:

	1. the other task has already extended i_size; or
	2. we have two IOs at the same offset (i.e. at i_size).

In either case, we don't need exclusive locking for the IO because
the worst thing that happens is that two IOs hit the same file
offset. IOWs, it has always been left up to the application
serialise RWF_APPEND writes on XFS, not the filesystem.

There is good reason for not doing exclusive locking for extending
writes. When extending the file naturally (think sequential writes),
we need those IOs be able to run concurrently with other writes
in progress. i.e. it is common for
applications to submit multiple sequential extending writes in a
batch, and as long as we submit them all in order, they all hit the
(moving) EOF exactly and hence get run concurrently.

This also works with batch-submitted RWF_APPEND AIO-DIO - they just
turn into concurrent in-flight extending writes...

IOWs, forcing exclusive locking for writes at exactly EOF is
definitely not desirable, and existing behaviour is that they use
shared locking.

The only time we use exclusive locking for extending writes is when
they -start- beyond EOF (i.e. leave a hole between EOF and
kiocb->ki_pos) and so we have to guarantee that range does not have
stale data exposed from it while the write is in progress. i.e. we
have to zero the hole that moving EOF exposes if it contains
written extents, and we cannot allow reads or writes to that hole
before we are done.

> The code is like that:
> +       if (iocb->ki_flags & IOCB_APPEND)
> +               iolock = XFS_IOLOCK_EXCL;
> +       else
> +               iolock = XFS_IOLOCK_SHARED;
> 
> 
> If we use exclusive locks for all extended writes, we need to check if
> it is an extended write before acquiring the lock, but this value could
> become outdated if we do not hold the lock.
> 
> So if we do an extended write,
> we might need to follow this process:
> 
> 1. Get read lock.
> 2. Check if it is an extended write.
> 3. Release read lock.
> 4. Get write lock.
> 5. Do the write operation.

Please see xfs_file_write_checks() - it should already have all the
shared/exclusive relocking logic we need for temporarily excluding
buffered reads whilst submitting concurrent buffered writes (i.e. it
is the same as what we already do for concurrent DIO writes).

-Dave.
-- 
Dave Chinner
david@fromorbit.com
