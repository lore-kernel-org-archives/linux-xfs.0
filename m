Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7650831B823
	for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 21:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771449968; cv=none; b=TQO187h/239cRzAdbyXhreHqf3uFDKEpfu+vI9UBWqc0W2F8MwULWJrXGDdsdUcLYVBSERxTRUA4lrZtsDcKgCf/CcfSZZm9+LDRxAGxjvzj1dzxcXdztB2LpJZ646X9LVMgmh84VxNujnXykIEIKaQ5z+HNliOhZZiphxg6pf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771449968; c=relaxed/simple;
	bh=TSEiRfMtoPLZ8CTZelBiCt+Z45NKL8wNlq9NjpF03LE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fYn+ESRz26ygi9Pqlmoq1km5kJqMK9Zatn1efdnjhpiZGjU1Bz8OlQRJ2L6sR4O9c5TrhVrcef7Lx65X1fUrKdssF2eKAwgj0Iu1/O2elPsHRAgilDh7Dhr/KKG7cTPBPHYNV1Y2BKPooGsU1ZzRKCxS+Iv3ebMNvmGBuhGh+Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=n1x2hzsx; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="n1x2hzsx"
Date: Wed, 18 Feb 2026 13:25:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771449955;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wo6vv3zwAb49jabaYEhJvfqzD+EG3AeCMF5nyF6m1Uo=;
	b=n1x2hzsxevl2KlW0/u2V4Vyr/ZSO5Xh+P9TXfWKLEIalUF12vlcIdJ8A5qhfR4EXzkOPNc
	tA8qejHL3g3QvA2gIMr6KY/kDgpRKkTCAAG7m+6aiqlp3hyLgb8cRmYYEXY3+leRbLTv7i
	xA43Ain+4HSrKFlMxM5ocAXx9hoOfKQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Carlos Maiolino <cem@kernel.org>, 
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Ritesh Harjani <riteshh@linux.ibm.com>, ojaswin@linux.ibm.com, Muchun Song <muchun.song@linux.dev>, 
	Cgroups <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>
Subject: Re: [next-20260216]NULL pointer dereference in drain_obj_stock()
 (RCU free path)
Message-ID: <aZYuJiEvMR9wC66k@linux.dev>
References: <ca241daa-e7e7-4604-a48d-de91ec9184a5@linux.ibm.com>
 <aZReMzl-S9KM_snh@nidhogg.toxiclabs.cc>
 <b4288fae-f805-42ff-a823-f6b66748ecfe@suse.cz>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4288fae-f805-42ff-a823-f6b66748ecfe@suse.cz>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 18, 2026 at 12:36:06PM +0100, Vlastimil Babka wrote:
> On 2/17/26 13:40, Carlos Maiolino wrote:
> > On Tue, Feb 17, 2026 at 04:59:12PM +0530, Venkat Rao Bagalkote wrote:
> >> Greetings!!!
> >> 
> >> I am observing below OOPs, while running xfstests generic/428 test case. But
> >> I am not able to reproduce this consistently.
> >> 
> >> 
> >> Platform: IBM Power11 (pSeries LPAR), Radix MMU, LE, 64K pages
> >> Kernel: 6.19.0-next-20260216
> >> Tests: generic/428
> >> 
> >> local.config >>>
> >> [xfs_4k]
> >> export RECREATE_TEST_DEV=true
> >> export TEST_DEV=/dev/loop0
> >> export TEST_DIR=/mnt/test
> >> export SCRATCH_DEV=/dev/loop1
> >> export SCRATCH_MNT=/mnt/scratch
> >> export MKFS_OPTIONS="-b size=4096"
> >> export FSTYP=xfs
> >> export MOUNT_OPTIONS=""-
> >> 
> >> 
> >> 
> >> Attached is .config file used.
> >> 
> >> 
> >> Traces:
> >> 
> > 
> > /me fixing trace's indentation
> 
> CCing memcg and slab folks.
> Would be nice to figure out where in drain_obj_stock things got wrong. Any
> change for e.g. ./scripts/faddr2line ?
> 
> I wonder if we have either some bogus objext pointer, or maybe the
> rcu_free_sheaf() context is new (or previously rare) for memcg and we have
> some locking issues being exposed in refill/drain.
> 

Yes output of ./scripts/faddr2line would be really helpful. I can't think of
anything that might go wrong in refill/drain.

