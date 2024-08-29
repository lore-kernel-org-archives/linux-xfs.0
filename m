Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D52191F97
	for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 10:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724926605; cv=none; b=csfQB6RdAU2Xn/OodljARcJRpzZvI6dk2AT+9zbrvCR5iNMHGNqBAcv927zJGBRrxkTW657NWrLryEqwxvJuGcvkfDydQDzt26SUiIEF3Ovsnxije5qYy/3U8QVzKnEWdQM8ljjVHvdignMUrdNwn57JBc3vY0ao+nDvIt2gcEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724926605; c=relaxed/simple;
	bh=e6txsU4ceuthYB25vTAdeR/PZjz9thzjLaYgJ3gdlmY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NR6naRK43Nt5y9iNVuaW7Y+9N/YU2Qm+RDQYRDV4UC/ACZrKEqnIzk5VjBDsYI0bgWmblxkUWEB/QuUEqd2mxw/uet26T0gHpkctL3DKXbx2TfJYuHAr/W9S5GPHsH5RdDaoEFPsrD7K9KVu7YiSd9QMFLYIwGUOMyjuIjF4BT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Dz4D9Xxu; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Dz4D9Xxu"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-709428a9469so283346a34.3
        for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 03:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724926603; x=1725531403; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jC02SIKoftLV04Z5kAVpeh6n6y8xIW7L3y0I9Dy4wlE=;
        b=Dz4D9Xxu/AfaLNkdk4XxKyhnz2f0wmZwZmjJm7e9pgzvRmwY846720eWjSHLZl2ixA
         N4RNyQFVlTcjtziadztnNobIAuy/bm3Z4hrB02F+QZMRnayfmmcmYncHURJnkBtWc4iT
         h0DGUhd14EeKNUKsusLqH9R7M6jbJAJSfl9+rVmW0v+IfOtAQ9W3L+FJqUq/gSXOYv2J
         8Ay53LGh3KpWQ1yLKykNKwXCE8nOQJ5igb4Du/DoyuXUiauSaYa3LS6I4xrq1cwlwT0n
         aQA2mW+/AaIA3sT9WavAe6miI0msBlDyY+cYut6xhEka19d7TLX+TF8QU797Dqv/Hyaj
         EiNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724926603; x=1725531403;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jC02SIKoftLV04Z5kAVpeh6n6y8xIW7L3y0I9Dy4wlE=;
        b=shLRYHxYhUewzteDZL9HBUKr1gnRsvCbAGgdrSStaZ5gVQQl+J3BTs8xVi3QHDFlpD
         BrmK7m1SBwEQIZZROrrDZ1hfDpJehjq73elW/9qdO9XqsjuG+UCS7hyhSYA1tk5JmvcR
         85Uv1wpz2oTwCVvsau0Dn2QMMHbwm+3OOqZleY1o+YzAkFvJDucmTm6AumazKuqv+Kuz
         g6/m0GLKq7gA/xisijD/SrMwA6TjULicQ8Vy3SincA9cvotMTi0cwyLdhaiOrpdXDATT
         g+5dBOX9tIxOQXZzlIxyeVepBegB0yoQKDiDDO6WwZpy3Pmh9ROTgtMlVd/B5fMngx3R
         HcHg==
X-Forwarded-Encrypted: i=1; AJvYcCWYgksfuO3s2OuGc7CsI8CYMTrZmoAvsohKIDjRe4QeAtBz3oj0A/QQPc6uJkVKibCOTk69czzOoqs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvN0MRBpLsgNUyaARH+50Wp3N3ZIKFfcvp7WONeXowkij2TFJJ
	sJyeHPCKxkOpN99gifoMYoOu2GT5BcKoIHO8OioftyGPG6hIkXVVLpHsLta1XZY=
X-Google-Smtp-Source: AGHT+IGQbnY7R9ZDaVgsBqSrziQBdQXGOLZXREdwms83UhUWuM6RBkyocIzAFaxrCTilv6+E4lnmLg==
X-Received: by 2002:a05:6358:5285:b0:1af:15b5:7caa with SMTP id e5c5f4694b2df-1b603cb773fmr294351855d.21.1724926603163;
        Thu, 29 Aug 2024 03:16:43 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-65.pa.nsw.optusnet.com.au. [49.179.0.65])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7d22e7835d6sm784797a12.43.2024.08.29.03.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2024 03:16:42 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sjcCm-00Go0U-0E;
	Thu, 29 Aug 2024 20:16:40 +1000
Date: Thu, 29 Aug 2024 20:16:40 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Long Li <leo.lilong@huawei.com>, djwong@kernel.org,
	chandanbabu@kernel.org, linux-xfs@vger.kernel.org,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH 3/5] xfs: add XFS_ITEM_UNSAFE for log item push return
 result
Message-ID: <ZtBKiB1dEmvbzifO@dread.disaster.area>
References: <20240823110439.1585041-1-leo.lilong@huawei.com>
 <20240823110439.1585041-4-leo.lilong@huawei.com>
 <ZslU0yvCX9pbJq8C@infradead.org>
 <Zs2jpYJHBtYqSMmD@dread.disaster.area>
 <Zs3G-ZrwPsOjuInE@infradead.org>
 <Zs5KsPEBZFkzG2Pb@dread.disaster.area>
 <Zs6mRe5o_zndtwM_@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zs6mRe5o_zndtwM_@infradead.org>

On Tue, Aug 27, 2024 at 09:23:33PM -0700, Christoph Hellwig wrote:
> On Wed, Aug 28, 2024 at 07:52:48AM +1000, Dave Chinner wrote:
> > I suspect that we'd do better to have explicit shutdown processing
> > of log items in the AIL (i.e. a ->iop_shutdown method) that is
> > called instead of ->iop_push when the AIL detects that the
> > filesystem has shut down. We can then define the exact behaviour we
> > want in this case and processing does not have to be non-blocking
> > for performance and latency reasons.
> > 
> > If we go down that route, I think we'd want to add a
> > XFS_ITEM_SHUTDOWN return value after the push code calls
> > xfs_force_shutdown(). The push code does not error out the item or
> > remove it from the AIL, just shuts down the fs and returns
> > XFS_ITEM_SHUTDOWN.
> 
> Yes, that seems even better.  But it would probably be a fair amount
> of work.

I don't think so. Only the log items that implement ->iop_push would
need to implement ->iop_shutdown, and there are only 3 items that
implement iop_push. i.e. inode, dquot and buffer items.

The buffer item shutdown method would simply be:

{
	xfs_buf_lock(bp);
	bp->b_flags |= XBF_ASYNC;
	xfs_buf_ioend_fail(bp);
	return XFS_ITEM_FREED;
}

The inode item would use the same setup as xfs_inode_item_push()
to lock the inode cluster buffer, then run the same code as above
for the buffer item shutdown.

I think that dquots end up the same - do the same setup work to get
the locked dquot buffer, then fail it directly without doing IO.

It doesn't seem like it's all that complex....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
