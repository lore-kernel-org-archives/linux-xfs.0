Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AA98460;
	Tue, 14 Apr 2026 00:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776128311; cv=none; b=o4waXXFpYmKLMwx0nSuz3G1Dw5ciDFqfmpPTB8BehOkN+P5vtx0UjybaNoLOIB3YXrMdPDW4wPU2hLSddIic5iQHmcZjwzJGaS60JZqvpBfx/rwJuxfc9BlxKEZ8Lq6uAu9Dq1gxzVlkpEBlPLt3yfAJ6ruirhYEhYBEv47V/G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776128311; c=relaxed/simple;
	bh=3CPipGJaHA3s88GYGUsO7x7ehen2R8UngXGLoTHJjjw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rlCZKP0sryAOOlQmx/h8iW6/HFUCIF8eOPUDwooJjg+qBygtMSdupvdFYYZ8AyqKqz6h0G7mQ8UjoHN30TQPnn2NpT05evdNhMLkQz36J9W02qT16cLnavjdNBrIHVMWwA2Gj2GJUyI+aSem02b+xl4ct8ttK24B24fb0PnzlKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OcsJXF1P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OcsJXF1P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E1FC2BCAF;
	Tue, 14 Apr 2026 00:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776128311;
	bh=3CPipGJaHA3s88GYGUsO7x7ehen2R8UngXGLoTHJjjw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OcsJXF1PmRjCZDAfuYGZoXbIniLv84Y/ELoCE7qu3TgOHRTrVtUykun/PwQZccOnZ
	 6PAQXF1uHTMuw8JRnCIRQUcHacvwwIDGYCflED7jspQ4Dk1hSHD9EIcwKt75U25MNm
	 GXlvVkaNlmgoWYfPVlmEDVmQScReiJW+SBCFXwC9TUJUDDZ1cNQ85FCC6BNOX1ClBS
	 7uF4GFWmCBmTZwJWoobFmybkYl5JZ0bqL7SL29031q8R1x5jvJQ/8BR+0CLMx/W7Bh
	 FYTxmGNZr/VD7oP2SiGvam5GfwHFsK17AbwxbrBGeDQtDs/cKX9vhXFAmnc3HFDkkt
	 pqwDN77HE8ImQ==
Date: Tue, 14 Apr 2026 10:58:16 +1000
From: Dave Chinner <dgc@kernel.org>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Christoph Hellwig <hch@lst.de>, Tal Zussman <tz2294@columbia.edu>,
	Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>, Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Sandeep Dhavale <dhavale@google.com>
Subject: Re: [PATCH 8/8] RFC: use a TASK_FIFO kthread for read completion
 support
Message-ID: <ad2RKNo2FGhpzJQp@dread>
References: <20260409160243.1008358-1-hch@lst.de>
 <20260409160243.1008358-9-hch@lst.de>
 <adl1iqhldFvJwSw-@dread>
 <7f0d072b-97a7-405f-bff5-d3819de2e3dd@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f0d072b-97a7-405f-bff5-d3819de2e3dd@linux.alibaba.com>

On Sat, Apr 11, 2026 at 07:44:43AM +0800, Gao Xiang wrote:
> 
> 
> On 2026/4/11 06:11, Dave Chinner wrote:
> > On Thu, Apr 09, 2026 at 06:02:21PM +0200, Christoph Hellwig wrote:
> > > Commit 3fffb589b9a6 ("erofs: add per-cpu threads for decompression as an
> > > option") explains why workqueue aren't great for low-latency completion
> > > handling.  Switch to a per-cpu kthread to handle it instead.  This code
> > > is based on the erofs code in the above commit, but further simplified
> > > by directly using a kthread instead of a kthread_work.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > Can we please not go back to the (bad) old days of individual
> > subsystems needing their own set of per-cpu kernel tasks just
> > sitting around idle most of of the time?  The whole point of the
> > workqueue infrastructure was to get rid of this widely repeated
> > anti-pattern.
> > 
> > If there's a latency problem with workqueue scheduling, then we
> > should be fixing that problem rather than working around it in every
> > subsystem that thinkgs it has a workqueue scheduling latency
> > issue...
> 
> It has been "fixed" but never actually get fixed:
> https://lore.kernel.org/r/CAB=BE-QaNBn1cVK6c7LM2cLpH_Ck_9SYw-YDYEnNrtwfoyu81Q@mail.gmail.com
> 
> and workqueues don't have any plan to introduce RT threads;

They don't need to (or should) introduce RT threads. Per-cpu kernel
threads already get priority over normal user tasks on scheduling
decisions.  However, they do not pre-empt running kernel tasks of
the same priority.

In general, kernel threads should not use RT scheduling at all - if
the kernel uses RT prioprity tasks then that can interfere with user
scheduled RT tasks. This is especially true in this case where a
non-RT tasks issue the IO, and the IO completion is then scheduled
with RT priority. IOWs, any unprivileged user can now impact the
processing time available to, and the response latency of, other
RT scheduled tasks the system is running.

Tejun asked Sandeep if setting the workqueue thread priority to
-19 through sysfs (i.e. making them higher priority than normal
kernel threads) had the same effect on latency as using a dedicated
per-cpu RT task thread. THere was no followup.

In theory, this should provide the same benefit, because what RT
scheduling is doing is pre-empting any user and kernel task that was
running when the interrupt was delivered to execute the completion
task immediately.

Setting the workqueue to use kernel threads of a higher scheduler
prioirty should do the same thing, without the need to use dedicated
per-cpu RT threads.

> If Sandeep has more time, I hope he could have more time to
> test since I don't work on Android anymore: In principle,
> I still think RT thread is needed somewhere for such usage
> since lowest latencies is needed.

All that is needed is for the kworker thread to be scheduled to run
immeidately after the interrupt that scheduled the work exits. This
does not require dedicated per-cpu kernel tasks or RT scheduling....

> Compared to the scheduling latency issues, interested users
> don't care "individual subsystems needing their own set of
> per-cpu kernel tasks just sitting around idle most of of
> the time". If end users care it more, they can just turn
> it off by Kconfig.

Distros enable all these subsystems all the time, so saying
"turn it off via kconfig" is not a viable mitigation
strategy. Proliferation of dedicated per-CPU worker task pools is a
known problem, and we really don't want to regress back to those
days when a typical system had thousands of dedicated per-cpu work
queues that largely did nothing most of the time.

-Dave.

-- 
Dave Chinner
dgc@kernel.org
