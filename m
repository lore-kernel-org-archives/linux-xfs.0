Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6449E226182
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 06:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733811657; cv=none; b=L2LNkeHzeqhldXqAu+acTfg9KkmFgtICQnToYP4IU4GEUe1q/zM+hOTTWzJ59fxR/fnww1IN0dPJFL0aybypCxQpp4eddcQ8Wj9ya2QlgyDngB1KiFj+ECh6C6CDc6pkjWrJDQcrRFl7hTQ8kwP+Ucuk08bCSh2Fg0dwMsjv4mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733811657; c=relaxed/simple;
	bh=jKMJ3hsDh0a44KfJjpLZ3rCsv12rrjRszRtMW9lwJ58=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K91ZrKa7zr5ByZpboJihAltbhGw8siv7ovMfcMfAHbs34Zw6U7Ej2ETwQSOaJwvjcbkK2fY6bDtrIupTZi+95G5VQq4oMI1z+P+Vd7VLx3lzTvdCojGdhkQSnwUpoXEl+a0+U9QnoO1NjuZ0FdC32KWzr8C+mJj989JguEsIesc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=tgCOP6mH; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="tgCOP6mH"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-216395e151bso14597785ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 09 Dec 2024 22:20:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1733811654; x=1734416454; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qMX1AuSP8Eyrvs2U7wnctp2zpxhmbV80GOyPv6KiMhQ=;
        b=tgCOP6mHk+35V4B8uBIIei19Ha2WpN2htY+qRVO8QIHgCQBAa7hV1U5o20R5mxD85+
         N9hrCCxa6efCGf+54MEQSnCMcghfyjjUqJBMrkBex/t1UB0oPc67vdsP7sT3AsABLVR6
         3eYQ2qMa7POP+OLyW73V1ed5jLiqDIW4RcPixTw7Qi/I/F4JtWJc3uooYu2dv/QH6J5X
         0PwyD0cKwyg7ROL0MrCthL1zzPXlXoAcPb3IHyLGFWB+kujYvumYh2X2L/agQqWwIc9/
         FyRPs6FDvKEfIzVmN6wJEWEK4l8xZAO4A64HEHpIuWu9CsVV5hZ75uc8UE5sUsDGpc1f
         fuww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733811654; x=1734416454;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qMX1AuSP8Eyrvs2U7wnctp2zpxhmbV80GOyPv6KiMhQ=;
        b=vypcPySznB12ISKY2FBSexQ4gDw1wO8goLVXwGGpid1SuxJYldI7W8SORcik0uOeJC
         D/Kb7HUCr/S4MB1zRm3AtMpNcHerrEPbGVjtEvAPxk6py3VWkpPlcFqLENxA4Z0jQBz1
         MjyUnFizPqt3j1SyscA0jaX4+q+ggZE5yDgajrxyOqKTdggbtPI1CmPNFB5+IyVHAMuw
         4RLwaq4S/bK7pfA00ibivhHC/2RovjEyq7DlBt2I0JPJTKmiiUNwGazttGMfN2R0OeMW
         NbT43kV8u8g2RC88JlIDSGfImmxORtV9roeD/IpShw4Gt8N2CWCkDB+2fh2/B7yNQ+CC
         mcbw==
X-Forwarded-Encrypted: i=1; AJvYcCURdWW6UGWHQiTCUdUAXFf/Ld8c2QCRHEq8cPxqb3c+faThJxKrMJw4aijGSA7+nbqWYu6sFlTzINM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSqXD9uNRm110Nd164hYBaSvFh6e5HFZuDvKjlDeqKT0bxbNto
	DdbN8X+UHwi2xcWJqcYyzDFJcSkclU2rekdCxjwe2QiLjb01ZTeURMasw1dsPLc=
X-Gm-Gg: ASbGnct/YuvjQ8+tIkgtTH3uB2kz0ckIYgztUhmk66e7zk7bnZ92YEE4gOuenRhwnjf
	uqWbetFVB+IlcpxZHCcFRN/flOB3BVZBx/AMQPTS3EGSBKYtMag1aoHN6ZuSPANy6Q1h97uCKP7
	JKX5/uBDUqYCi2I3+S5+F9h8gia26aScucZ4eFazZX2hkvPEsj8B7bPfHbmnhU84pzLoD4AGL6F
	Js8XNeP5qENTKlQ86p+KOv7Vk3SKBjpTGU8584wCMJEsUxETzT3wecQtV4nBQQcwmPC4shd8bTV
	9txIbuVtAgqaRh0uBx+XgpTkxEQ=
X-Google-Smtp-Source: AGHT+IGE/WV78NxJt/4bX9/xTZNoAWMYiRG1ccc6Zg6L/vTySKlQjXpa3TGoQJkud5+hqLn8W65BZg==
X-Received: by 2002:a17:902:fc8f:b0:215:a034:3bae with SMTP id d9443c01a7336-21670a2e7b4mr30496775ad.18.1733811654611;
        Mon, 09 Dec 2024 22:20:54 -0800 (PST)
Received: from dread.disaster.area (pa49-195-9-235.pa.nsw.optusnet.com.au. [49.195.9.235])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-215f8f093a3sm82255285ad.192.2024.12.09.22.20.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2024 22:20:54 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tKtc3-00000008sb6-0kY6;
	Tue, 10 Dec 2024 17:20:51 +1100
Date: Tue, 10 Dec 2024 17:20:51 +1100
From: Dave Chinner <david@fromorbit.com>
To: Long Li <leo.lilong@huawei.com>
Cc: djwong@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com,
	lonuxli.64@gmail.com
Subject: Re: [PATCH] xfs: fix race condition in inodegc list and cpumask
 handling
Message-ID: <Z1fdw1odL7B8kIj-@dread.disaster.area>
References: <20241125015258.2652325-1-leo.lilong@huawei.com>
 <Z0TmLzSmLr78T8Im@dread.disaster.area>
 <Z1FPRKXZrsAxsoZ5@localhost.localdomain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1FPRKXZrsAxsoZ5@localhost.localdomain>

On Thu, Dec 05, 2024 at 02:59:16PM +0800, Long Li wrote:
> On Tue, Nov 26, 2024 at 08:03:43AM +1100, Dave Chinner wrote:
> 
> Sorry for reply so late, because I want to make the problem as clear
> as possible, but there are still some doubts.
> 
> > On Mon, Nov 25, 2024 at 09:52:58AM +0800, Long Li wrote:
> > > There is a race condition between inodegc queue and inodegc worker where
> > > the cpumask bit may not be set when concurrent operations occur.
> > 
> > What problems does this cause? i.e. how do we identify systems
> > hitting this issue?
> > 
> 
> I haven't encountered any actual issues, but while reviewing 62334fab4762
> ("xfs: use per-mount cpumask to track nonempty percpu inodegc lists"), I
> noticed there is a potential problem.
> 
> When the gc worker runs on a CPU other than the specified one due to
> loadbalancing,

How? inodegc is using get_cpu() to pin the task to the cpu while it
processes the queue and then queues the work to be run on that CPU.
The per-PCU inodegc queue is then processed using a single CPU
affine worker thread. The whole point of this setup is that
scheduler load balancing, etc, cannot disturb the cpu affinity of
the queues and the worker threads that service them.

How does load balancing break explicit CPU affine kernel task
scheduling?

> it could race with xfs_inodegc_queue() processing the
> same struct xfs_inodegc. If xfs_inodegc_queue() adds the last inode
> to the gc list during this race, that inode might never be processed
> and reclaimed due to cpumask not set. This maybe lead to memory leaks
> after filesystem unmount, I'm unsure if there are other more serious
> implications.

xfs_inodegc_stop() should handle this all just fine. It removes
the enabled flag, then moves into a loop that should catch list adds
that were in progress when the enabled flag was cleared.

> > > Current problematic sequence:
> > > 
> > >   CPU0                             CPU1
> > >   --------------------             ---------------------
> > >   xfs_inodegc_queue()              xfs_inodegc_worker()
> > >                                      llist_del_all(&gc->list)
> > >     llist_add(&ip->i_gclist, &gc->list)
> > >     cpumask_test_and_set_cpu()
> > >                                      cpumask_clear_cpu()
> > >                   < cpumask not set >
> > > 
> > > Fix this by moving llist_del_all() after cpumask_clear_cpu() to ensure
> > > proper ordering. This change ensures that when the worker thread clears
> > > the cpumask, any concurrent queue operations will either properly set
> > > the cpumask bit or have already emptied the list.
> > > 
> > > Also remove unnecessary smp_mb__{before/after}_atomic() barriers since
> > > the llist_* operations already provide required ordering semantics. it
> > > make the code cleaner.
> > 
> > IIRC, the barriers were for ordering the cpumask bitmap ops against
> > llist operations. There are calls elsewhere to for_each_cpu() that
> > then use llist_empty() checks (e.g xfs_inodegc_queue_all/wait_all),
> > so on relaxed architectures (like alpha) I think we have to ensure
> > the bitmask ops carried full ordering against the independent llist
> > ops themselves. i.e. llist_empty() just uses READ_ONCE, so it only
> > orders against other llist ops and won't guarantee any specific
> > ordering against against cpumask modifications.
> > 
> > I could be remembering incorrectly, but I think that was the
> > original reason for the barriers. Can you please confirm that the
> > cpumask iteration/llist_empty checks do not need these bitmask
> > barriers anymore? If that's ok, then the change looks fine.
> > 
> 
> Even on architectures with relaxed memory ordering (like alpha), I noticed
> that llist_add() already has full barrier semantics, so I think the 
> smp_mb__before_atomic barrier in xfs_inodegc_queue() can be removed.

Ok. Seems reasonable to remove it if everything uses full memory
barriers for the llist_add() operation.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
