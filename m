Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8D7154BEA
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 22:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723762567; cv=none; b=m84Rhap7gDFLLRvwty+UKWGbda1Fu3Jt0xsX28DLgBiZ0pxxFVBsQ+X4VhBPXYog+vU0Xj2qOsSc/jxdKJylOUTwKRnL2PMlYgR+6fTPLhWaNTECAaUoGYK/0Kj/xkyUFRQ0wknMw4k4kYZb4eSm433R2jb7SIBnB6qxoFPAi58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723762567; c=relaxed/simple;
	bh=V225mQvLSldnOZsu/o4H7J3rm6OImbOy18qmjgkzUns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=COTVTHBYtamayrEGt5izA+OVSEPnWIjrPeXRxCwkCIHyu0Z9B1XWAwIwJcpTuv4Ae65lgwMEdSLgxsFzryXnBDVxcsPDTQZJ1AUjsRyTYl7P8AOmfAoZFEEhK0F105zIIVj7BhTfXplKvXF4/I59imvs/nuPFqK8RjElaY7ny7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=DcRZVZ6c; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="DcRZVZ6c"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-710e39961f4so1085975b3a.3
        for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 15:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1723762564; x=1724367364; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HpvYCpw7xXOcgiFoL0p66SwE4Ip9+p+G8fo1oNmytn4=;
        b=DcRZVZ6c3cCmBn4oX23x7lf0UuXvxpSevXQzbQtUUzeMoT3oiO8lA6kDm2dhexCULU
         skJ+eyvRTpGKTlJDMlNXSQ6cJ/bMqvh3k2A37DEmSM6+joDEI5ODd0agcadx/tldht0c
         Ks0iB0CkppxaTdzD0vLQg1FQFT3kBQTnkIYU9tlaUpnDPyNVOtgqwulWuRClvp8zln/3
         55Y6S1skJz26e1e/owclaUVOaRgMLMTAcsPzReVwMfkffz8eqhs4gF+58XhurTcDbgTg
         xHXrt6qqewjFOUv/oMm9G8JVfJPPyZVsoD04kBgk5dl5cXr0bEPKZ+h0MU3XWyEl8GvY
         ISsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723762564; x=1724367364;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HpvYCpw7xXOcgiFoL0p66SwE4Ip9+p+G8fo1oNmytn4=;
        b=sim2r+5nvQgwviy4XUVzCc1ab8v5ZqsBOh8RTxSnzwSJJISFIrqHjd2EjtIHfu7+Yo
         2PVGEcI+/0t9AJ7Xd0TILpRKWWIQh1DLk0PJQiCaAgIB6B4gDD+n5deK4Dr73WOJVWPe
         DvvylfeHtjkYQamJ6Lfm4oGLLS/xb07b1tTo5I08Ng63FLVdze/U4VkM6Rq7o1Gs6N5y
         Hbh9u2m03QYExx5DEjdQvL84CAewMq5JVbd+19N0RaxfhUDPqjUrtUuUS9TlvSm/1Akr
         JVAQRnTSMv/A66p+7qIGCWPF+dNWEH/7B/Lccjg9jdYETFH+U0dwASV6W8j0+WsfMzji
         /Flg==
X-Gm-Message-State: AOJu0YzWQZwVkr2/CXxaYHGIhhC0yyitzTlMOp7F7vZjLsZ34Ahenhnf
	7C79+366lbzzGeWEmYCwErq4zoWjnK+aC2zhYZ1xSEK1lk2i58lklAiwCy6A0CAqjAJy0g3k8dp
	p
X-Google-Smtp-Source: AGHT+IFdYyQfsGsJqnlnP43/yRVIRlbQO3OOFx9BvymCWBCriBcMzO0BMD3Rk/+mdI0C1MzfpiPOOQ==
X-Received: by 2002:a05:6a21:918a:b0:1c4:c1cd:a29d with SMTP id adf61e73a8af0-1c904fb50fbmr1604626637.28.1723762564022;
        Thu, 15 Aug 2024 15:56:04 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7c6b61e0e93sm1687244a12.42.2024.08.15.15.56.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2024 15:56:03 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sejNw-000tGX-2P;
	Fri, 16 Aug 2024 08:56:00 +1000
Date: Fri, 16 Aug 2024 08:56:00 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: perf loss on parallel compile due to conention on the buf
 semaphore
Message-ID: <Zr6HgCW3nwZi6CTm@dread.disaster.area>
References: <CAGudoHFJV=S61Fjb=QVf4mSTRfkYf5QR1y0TDMhnawZKtgyouA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGudoHFJV=S61Fjb=QVf4mSTRfkYf5QR1y0TDMhnawZKtgyouA@mail.gmail.com>

On Thu, Aug 15, 2024 at 02:25:48PM +0200, Mateusz Guzik wrote:
> I have an ext4-based system where xfs got mounted on tmpfs for testing
> purposes. The directory is being used a lot by gcc when compiling.
> 
> I'm testing with 24 compilers running in parallel, each operating on
> their own hello world source file, listed at the end for reference.
>
> Both ext4 and btrfs backing the directory result in 100% cpu
> utilization and about 1500 compiles/second. With xfs I see about 20%
> idle(!) and about 1100 compiles/second.

Yup, you're not using any of the allocation parallelism in XFS by
running all the microbenchmark threads in the same directory. That
serialises the tasks on inode and extent allocation and freeing
because they all hit the same allocation group.

Start by separating threads per directory because XFS puts
directories in different allocation groups when they are allocated,
and then keeps the contents of the directories local to the AG the
directory is located in. This largely gives perfect scalability
across directories as long as the filesystem has enough AGs in it.

For scalability microbenchmarks, I tend to use ian AG count of 2x
max thread count.  i.e. for 24 threads, I'd probably use:

# mkfs.xfs -d agcount=49 ....

and put every thread instance in a newly created directory.

For normal workloads (e.g. compiling a large source tree) this
special setup step is not necessary. e.g. the creation of a large
source tree naturally distributes all the directories and files over
all the AGs in the filesystem and so there isn't a single AGI or AGF
buffer lock that serialises the entire concurrent compilation.

You're going to see the same thing with any other will-it-scale
concurrency microbenchmark that has each thread allocate/free inodes
or extents on files in the same directory.

IOWs, this is purely a microbenchmarking setup issue, not a real
world filesystem scalability issue.

> The fact that this is contended aside, I'll note the stock semaphore
> code does not do adaptive spinning, which avoidably significantly
> worsens the impact.

No, we most definitely do not want adaptive spinning. This is a long
hold, non-owner sleeping lock - it is owned by the buffer, not the
task that locks the buffer. The semaphore protects the contents of
the buffer as IO is performed on it (i.e. while it has no task
associated with it, but hardware is modifying the contents via
asynchronous DMA).

It is also held for long periods of time even when the task that
locked it is on-cpu. Inode and extent allocation/freeing can involve
updating multiple btrees that each contain millions of records, and
all the buffers may be cached and so the task running the allocaiton
and holding the AGI/AGF locked might actually run for many
milliseconds before it yeilds the lock.

We absolutely do not want tens of threads optimistically spinning on
these locks when contention occurs - spinning locks areit is
extremely power-inefficient and these locks are held long enough
that you can measure spinning lock contention events via the power
socket monitoring...

> You can probably convert this to a rw semaphore
> and only ever writelock, which should sort out this aspect. I did not
> check what can be done to contend less to begin with.

No.  We cannot use any other Linux kernel lock for this, because
they are all mutexes (including rwsems). The optimistic spinning is
based on a task owning the lock and doing the unlock (that's why
rwsems track the write owner task).

We need *pure* sleeping semaphore locks for these buffers and we'd
really, really like for rwsems to be pure semaphores and not a
bastardised rwmutex for the same reasons....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
