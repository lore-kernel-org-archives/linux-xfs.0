Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061033E9C0F;
	Wed, 27 May 2026 13:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779886807; cv=none; b=UNxGueAL2ozg5zLp7D/Pij1HGi2stuJccxyrCcLDFrGny0Y7lBAzgiZdaGcGTP+HcBPjDErzIVP+NgjH2wQlh9g7+F/GwxwrSsOwgdZfQ+VKKFbJRdIf/Bxt7l/J6o4AWwpkGiAzJMiyH9vzLmvpIL687OUyoUkMirfZnbb4jAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779886807; c=relaxed/simple;
	bh=EBaps+i7LpVAFfaa4b8PPUb3GdkIkGVY4AM8X9+iX4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ee5rcvS1pphvcD2se/pX8NpkVGnMe5j+6IZ3S1XyMnmLi9HDfQZMKX/UbCO1IzablVXPk99JKF9AM/vG3OojEH0GrQhaBUr6Z6cxl46AISZlTtoEx9tWJyveqkpT/aOjfOwDhTwmgxQy/5k5mrdwlbieam/OhCGeiLWKY7Ne0X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KRj0xV6x; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KRj0xV6x"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=XSOTEpS6jnOnkKRCoQQoSeSU8dByk24sxPymLSbbGcE=; b=KRj0xV6xgukBl9D4xsqK6bZu1w
	dlb6+dENOCzrPokyPEyMx/A/gnulxCC8Nx++F+gqtsSfg9ClXRpm31kYxour0RKhesUZlRvTUFuRd
	19M6/F7BZYFc/d/YQVXxi2aRol6wjk4whwR16kRtSjpvF/JEF8P62hjtbSKs9ZYaGGLhnDdLMw5mL
	/0fgeUmYAN+QGS97ENVQi4jvijWsfdJq5nO4yD9dVYRbOLO39dr4iA5+ulp8Sq/8WtiFXraw/grNl
	j061BWxTakH+C5qFKHLDH5NrEG+CE7bdtola8Vdwh9FhPMYYePVoT2Ta0OQURkR/NFiZZXlYWpP79
	cs+2kb4A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSDrd-000000048vG-0eXC;
	Wed, 27 May 2026 13:00:01 +0000
Date: Wed, 27 May 2026 06:00:01 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Tal Zussman <tz2294@columbia.edu>,
	Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH v6 1/4] block: add task-context bio completion
 infrastructure
Message-ID: <ahbq0RdUyLIPiItB@infradead.org>
References: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
 <20260514-blk-dontcache-v6-1-782e2fa7477b@columbia.edu>
 <agq2KRd8RkP1TAf5@infradead.org>
 <ea1fa305-3ba2-4cfd-b7cb-86875032a300@columbia.edu>
 <ahPbaSEoNA755Nt3@infradead.org>
 <f1b8eeb6-2397-4f48-a21a-a023eb0c80ab@columbia.edu>
 <rkb5oei6cx2erbyininczz6ukbnquqheexhu7tznn5rslkkdn7@b4kpdyhdwdb6>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <rkb5oei6cx2erbyininczz6ukbnquqheexhu7tznn5rslkkdn7@b4kpdyhdwdb6>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, May 27, 2026 at 11:42:28AM +0200, Jan Kara wrote:
> > I ran some experiments with fio on both XFS and a raw block device. Five
> > iterations each for 60s. Results below.
> > 
> > TLDR: Removing the delay doesn't significantly decrease user-visible
> > latency or otherwise improve performance, but does significantly reduce
> > throughput and increase context switches in some workloads (e.g. C).
> > I think it makes sense to leave the delay as-is. Thoughts?
> 
> Thanks for the test! One question below:

Thanks from me as well!

> 
> > Results:
> > 
> > Workloads (all `uncached=1`):
> >   A: rw=write     bs=128k iodepth=1   ioengine=pvsync2     # XFS
> >   B: rw=write     bs=128k iodepth=128 ioengine=io_uring    # XFS
> >   C: rw=randwrite bs=4k   iodepth=32  ioengine=io_uring    # XFS
> >   D: rw=rw 50/50  bs=64k  iodepth=32  ioengine=io_uring    # XFS
> >   E: rw=write     bs=128k iodepth=128 ioengine=io_uring    # raw /dev/nvmeXn1
> >   F: rw=write     bs=128k iodepth=128 numjobs=4
> >      + vm.dirty_bytes=64MB, vm.dirty_background_bytes=32MB # XFS
> > 
> > Mean ± stddev across 5 iterations:
> > 
> >     metric                     delay=1           delay=0     delta
> >     --------------------------------------------------------------
> > 
> >   A seq 128k qd1
> >     BW (MB/s)                4333 ± 27         4374 ± 34     +0.9%
> >     p99   (us)              36.2 ± 0.8        35.8 ± 0.4     -1.1%
> >     p999  (us)               3260 ± 75         3228 ± 29     -1.0%
> >     ctx-switches          184 k ± 59 k     3.68 M ± 65 k    +1903%
> >     cs / io                0.09 ± 0.03       1.86 ± 0.03    +1888%
> >     avg bios/run            80.4 ± 0.6         1.1 ± 0.0    -98.7%
> 
> So 1 jiffie delay is (with default HZ=1000) 1ms. That means for this load
> the completion latency should be at least 1000us but your results show p99
> latency of 36. What am I missing?

Yes, this looks a bit odd.  Unless there's multiple threads submitting
and somehow the completions get batched this should complete one
bio at a time and be the worst case for the delay scheme.

> >   C rand 4k qd32
> >     BW (MB/s)               66.2 ± 0.8        44.6 ± 7.4    -32.7%
> >     p99   (us)              8002 ± 174      17990 ± 6800   +124.8%
> >     p999  (us)             11390 ± 554     31890 ± 11076   +180.0%
> >     ctx-switches         3.67 M ± 45 k    3.59 M ± 106 k     -2.2%
> >     cs / io                3.78 ± 0.04       5.62 ± 0.83    +48.7%
> >     avg bios/run            32.3 ± 1.0         3.1 ± 0.3    -90.5%
> 
> I'm somewhat surprised how larger is the completion latency is here without
> the delay. Is that due to a contention on local lock between the IO completion
> interrupt and the worker? Or why is the completion latency so big here when
> the case B with more IOs in flight, less bios per run, still had significantly
> lower latency in the delay=0 case?

Note that in the past we had major problems with workqueue scheduling
latency.  At some point these got mitigated a lot, but if they are back
for this workload that might be one reason.

