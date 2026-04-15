Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF83390CBA;
	Wed, 15 Apr 2026 06:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776236363; cv=none; b=VqWdfd/e9DIzYw0GJ2C64untG1YL9lRHwH3yQE0vhZjAQ9+YZg5ILuyupz0NstyDYx/yji1F+0v/tcUG0Ly+LPvDIHHIoXi4zovwYnRF+ulCVRCrzPl4XSypwyN0+Enx2LkxxCGSeeW+pSFxyQg2m4HdTUYZKPN4aJiCNbypeTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776236363; c=relaxed/simple;
	bh=4cycmBmatrnCWRvdzG28xMg794YYKWzuy6LwUqRuvQc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JGE+iC9Qovv82MDjE/hxEA7HVZOMgu6K83l/4hGIsZMliIhJw0Eo7aja13N7r0IFn8xoL+PlDUtcc4mGBwbZ1ZqnnRkIn4asy/yoJ0fMYBglWjWsVW5X2KiT2ePZqzex5X3UBFa+hKuCaylz47jttxfi8MkHcUdeXfVP3trW9nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8250268BFE; Wed, 15 Apr 2026 08:59:16 +0200 (CEST)
Date: Wed, 15 Apr 2026 08:59:16 +0200
From: Christoph Hellwig <hch@lst.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Christoph Hellwig <hch@lst.de>, Gao Xiang <hsiangkao@linux.alibaba.com>,
	Dave Chinner <dgc@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>, Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Sandeep Dhavale <dhavale@google.com>,
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 8/8] RFC: use a TASK_FIFO kthread for read completion
 support
Message-ID: <20260415065916.GA28634@lst.de>
References: <20260409160243.1008358-1-hch@lst.de> <20260409160243.1008358-9-hch@lst.de> <adl1iqhldFvJwSw-@dread> <7f0d072b-97a7-405f-bff5-d3819de2e3dd@linux.alibaba.com> <ad2RKNo2FGhpzJQp@dread> <a7a74185-df02-4906-a0ec-f87e2394aa5f@linux.alibaba.com> <20260415055552.GD26893@lst.de> <20260415063051.H3zA99Qh@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415063051.H3zA99Qh@linutronix.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 15, 2026 at 08:30:51AM +0200, Sebastian Andrzej Siewior wrote:
> Not sure why I ended up here

Because this is very similar to ksoftirqd and softirq.c doesn't have a
maintainer, and you were the last one doing substantial changes to it.
And you're also very knowledgeable about PREEMPT_RT, which has a bit of
a history of low-latency user context helpers :)

