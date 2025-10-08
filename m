Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73666247280
	for <linux-xfs@vger.kernel.org>; Wed,  8 Oct 2025 21:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759958871; cv=none; b=pZ1/Fpov213og8LPfeAa60R5MmyxX3Xv9iqqj2DOPhvg5Z7UfMRTW4NPMzz8YYADo5tBTzSpzGDf3sPS0GZAmsoan05Nex8CvFvH1wCuhgErHzcSlS1nhBlq0LqhRTAEHHKhqhxPCwHrRiEeW3BE+c8nlDCrqiYueRZo9kbzY3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759958871; c=relaxed/simple;
	bh=khnmQSv1KqdW2r1s66Ycxw+/H26YBZCl3lZorIz5s0s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fdS4KLjQBWr8pveQuGZO/fjpOCB0z88ZigolmDxSNY0uwcoHftXVm2Bq4AN5Xfqr6M6UvrXWSwBcHIqA/f60fQMNGqkeLyHPffhSFdeD8a/coOFK8uaKgSlS+nncTIeHyjatG4C9f/CYfLlFBsVnvldNkAxpaxEapjSaQxduH+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=pnEIjpPG; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="pnEIjpPG"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-794f11334adso253184b3a.3
        for <linux-xfs@vger.kernel.org>; Wed, 08 Oct 2025 14:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1759958869; x=1760563669; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=F00rRgwaPiAVSa8UIE87R3vA0HR5XgbIb0LOT0xwQT0=;
        b=pnEIjpPGrACrpjb5FWtln3riGDDCJM/DGhpITgTXw2H2q+c9orup9wyh+7itYJ5d0w
         bwNdJg8IFQMe3dUY/L+EmcWZ1thxehZyHziByoIq+U2sKVCIBcW3rNz+UNihh0rXnuil
         Q3nXcN2yxBXrZQsa94g34pSa4i8MvOTHCANpQwGqL7Em9rqhoGUtdXL6GSDGkjtNzIIn
         ZAFlD5cbnyXts+Yzd5yDXTeo6eVUPE9XbZP8/NC5Qa1faEBHJUpsNXiM/ERW90WmD6sG
         NWzxmpiQOnMsCThpjr+Yl1FzYdcpn8Y2HUsU/PQ3HEN2aIkO3/FATnKlr4nn2YGZJzgH
         rFKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759958869; x=1760563669;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F00rRgwaPiAVSa8UIE87R3vA0HR5XgbIb0LOT0xwQT0=;
        b=qh8tqnatysTB3Si+O5bHIcxDrNora3COhBhLimHCHXNw9XH3iaUtJoxbXRnE9WhpEb
         q/JVG6/gGi+MmLBHItX5AQKKPHKa4kG7eptiKggPZ8PFalDVWFZhTpF9ablKWcOCjiCS
         uzBC7PFHCxJkvKLGwUs84wRwzF81IduWR4kBBOhaZsZwVNlf+c6XsFVjdrfYUriAd47o
         SxkNEL99VEXrrnKVgMulxn95UmyD3PEP0S9gEzsyXkWd35kuwjquFQOpy3/VJ4drQFmG
         YFQUl2cdLnOkjFOnK+LK87FJ2RZAIQGJ0g8dzRdBQNbKY1I7rhYR6DEaXPb4c0Kx+ioH
         9/qQ==
X-Forwarded-Encrypted: i=1; AJvYcCVIGVzFhAIu5amn5W2GFFPjWvsTSHahQhIOjQE8BACTA7bIG8EZO75geCXx67i/lYs2rtBSLQPFigc=@vger.kernel.org
X-Gm-Message-State: AOJu0YySQkD+/hlkVIJzvlM0abzesWKObdymt5c27X2ssW6Zp53u7Tng
	9b+tMX1sqVmWg5aoXZOx1RVuh2rIVoT7ema7IUOiWeR8wzZ/WXVaOsK9Ajvy+J+SrIsNDm50a7J
	2+Fvf
X-Gm-Gg: ASbGncsTY5NDvdUboQVVwRAGF/pJrpAky2IbDzGT0Ak5/rd7FjsOKx3LN2JG0qeoLlH
	aLa97c1ZdCUUTjk3kCTRNvl4QwLOeYyVCEj9G9fP6sNhKhdO0/1HIbT9HNznoApM/sJJOjukZAC
	5lcnCJN2JCGatFq1eeLNMBLVA724d8QBC2KzGvX3TViltCpmfslQtg4TGLtWOt6/Lb1hWXPiSEw
	whd9XiHnKQof2XG7WcomeyhvUATv1ScN2fQgk4SM6CHc0btDJKdFNxG+QOyKSaSVp0lL7bh4rwQ
	zH47RjzRpMyjUSkBucAqlrPJgJhBCi9PitluFQsCgrSBFKsA8yTzF8Ng1+WgYdv68b+0qFGms8h
	+VcGwg3gh+PbpooQrFKKlo3Txt6Pj3IRPcPJ3urIrqR90qZ64H8uhKqtyQXOyIAnkPxi7Bt9fen
	cqKxuj/sfsBoG5EP1mHbRQww==
X-Google-Smtp-Source: AGHT+IGEH5qrmAdErlm6CTYS93R5ybz8YDjTDbT7/9fw+48rtORlz2GGxNRLcpfwAHVvft7SzrjEGg==
X-Received: by 2002:a05:6a00:4fd0:b0:783:7de9:d3ca with SMTP id d2e1a72fcca58-79387c1a74bmr6026276b3a.31.1759958868450;
        Wed, 08 Oct 2025 14:27:48 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-794d4b39400sm720004b3a.15.2025.10.08.14.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 14:27:47 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1v6bhI-0000000CI7U-3Tda;
	Thu, 09 Oct 2025 08:27:44 +1100
Date: Thu, 9 Oct 2025 08:27:44 +1100
From: Dave Chinner <david@fromorbit.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Christoph Hellwig <hch@infradead.org>,
	Pavel Emelyanov <xemul@scylladb.com>, linux-fsdevel@vger.kernel.org,
	"Raphael S . Carvalho" <raphaelsc@scylladb.com>,
	linux-api@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] fs: Propagate FMODE_NOCMTIME flag to user-facing
 O_NOCMTIME
Message-ID: <aObXUBCtp4p83QzS@dread.disaster.area>
References: <20251003093213.52624-1-xemul@scylladb.com>
 <aOCiCkFUOBWV_1yY@infradead.org>
 <CALCETrVsD6Z42gO7S-oAbweN5OwV1OLqxztBkB58goSzccSZKw@mail.gmail.com>
 <aOSgXXzvuq5YDj7q@infradead.org>
 <CALCETrW3iQWQTdMbB52R4=GztfuFYvN_8p52H1fopdS8uExQWg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrW3iQWQTdMbB52R4=GztfuFYvN_8p52H1fopdS8uExQWg@mail.gmail.com>

On Wed, Oct 08, 2025 at 08:22:35AM -0700, Andy Lutomirski wrote:
> On Mon, Oct 6, 2025 at 10:08 PM Christoph Hellwig <hch@infradead.org> wrote:
> >
> > On Sat, Oct 04, 2025 at 09:08:05AM -0700, Andy Lutomirski wrote:
> > > > Well, we'll need to look into that, including maybe non-blockin
> > > > timestamp updates.
> > > >
> > >
> > > It's been 12 years (!), but maybe it's time to reconsider this:
> > >
> > > https://lore.kernel.org/all/cover.1377193658.git.luto@amacapital.net/
> >
> > I don't see how that is relevant here.  Also writes through shared
> > mmaps are problematic for so many reasons that I'm not sure we want
> > to encourage people to use that more.
> >
> 
> Because the same exact issue exists in the normal non-mmap write path,
> and I can even quote you upthread :)
> 
> > Well, we'll need to look into that, including maybe non-blockin
> timestamp updates.
> 
> I assume the code path that inspired this thread in the first place is:
> 
> ssize_t __generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
> {
>         struct file *file = iocb->ki_filp;
>         struct address_space *mapping = file->f_mapping;
>         struct inode *inode = mapping->host;
>         ssize_t ret;
> 
>         ret = file_remove_privs(file);
>         if (ret)
>                 return ret;
> 
>         ret = file_update_time(file);
> 
> and this has *exactly* the same problem as the shared-mmap write path:
> it synchronously updates the time (well, synchronously enough that it
> sometimes blocks),

You are conflating "synchronous update" with "blocking".

Avoiding the need for synchronous timestamp updates is exactly what
the lazytime mount option provides. i.e. lazytime degrades immediate
consistency requirements to eventual consistency similar to how the
default relatime behaviour defers atime updates for eventual
writeback.

IOWs, we've already largely addressed the synchronous c/mtime update
problem but what we haven't done is made timestamp updates
fully support non-blocking caller semantics. That's a separate
problem...

> and it does so before updating the file contents
> (although the window during which the timestamp is updated and the
> contents are not is not as absurdly long as it is in the mmap case).
> 
> Now my series does not change any of this, but I'm thinking more of
> the concept: instead of doing file/inode_update_time when a file is
> logically written (in write_iter, page_mkwrite, etc), set a flag so
> that the writeback code knows that the timestamp needs updating.

This is exactly what lazytime implements with the I_DIRTY_FLAG.

During writeback, if the filesystem has to modify other metadata in
the inode (e.g. block allocation), the filesystem will piggyback the
persistent update of the dirty timestamps on that modification and
clear the I_DIRTY_TIME flag.

However, if the writeback operation is a pure overwrite, then there
is no metadata modifiction occuring and so we leave the inode
I_DIRTY_TIME dirty for a future metadata persistence operation to
clean them.

IOWs, with lazytime, writeback already persists timestamp updates
when appropriate for best performance.

> Thinking out loud, to handle both write_iter and mmap, there might
> need to be two bits: one saying "the timestamp needs to be updated"
> and another saying "the timestamp has been updated in the in-memory
> inode, but the inode hasn't been dirtied yet".

The flag that implements the latter is called I_DIRTY_TIME. We have
not implemented the former as that's a userspace visible change of
behaviour.

> And maybe the latter
> is doable entirely within fs-specific code without any help from the
> generic code, but it might still be nice to keep generic_update_time
> usable for filesystems that want to do this.

generic_update_time() already supports I_DIRTY_TIME semantics.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
