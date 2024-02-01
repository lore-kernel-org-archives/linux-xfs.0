Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290A115F332;
	Thu,  1 Feb 2024 15:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706802672; cv=none; b=WxJFl1Tyc0FKarIFNtoGYdI+z2Ptc1cqaRAOKPwpc5LkTC4Dc3PeMwtkrKi9lie6QkO6Ocq2aciUpdpVqpjgQgkMJFMPuUEY2fqhL1uPJ4KVqZJiOJ3clCegjzLwYmzIsd8BmWEwaTd/NlC7IxMv/E35jESLQ2PoMFNLfT2G/Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706802672; c=relaxed/simple;
	bh=vetQWfc7x0y/pwVcyDLf2pd8BioDkeVM0XD1exOXfBY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gQRd+U2t2+kv1353EZVy0ExTnaNjiE4fjYRW8EIgZ5yDWCPX1bNSpogEjsn2vb5CZnJoW9vOcXeVIffHKiK7Pz3VoNttfyTcd23YqrIfJ8mwCk57TKAJxoIe1eArHDVusEbUxwu+J7TXBW74dn3nfSjGFl5YNXc1g41G5tqBQXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pankajraghav.com; spf=pass smtp.mailfrom=pankajraghav.com; dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b=QyK0o+71; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b="QyK0o+71"
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4TQjrl1PfQz9srx;
	Thu,  1 Feb 2024 16:44:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1706802279;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UstRbj1QoskmkDlV/xhfMZvqgMHOETDziO1CqeS+Z0w=;
	b=QyK0o+71eBjHIRNF/bW3v/dBwbiCIosnlHf3ckaRmyRiAXz4vSU2vt0Dmmrp+GOc59fUrC
	W0uvJ12wuGBTI63XicTXgOUlW4socgOmlz5pGpkMdXrqYEgnJJ6J632MCJeCLvIN62gGhy
	rG9OambtWf7n9gQWuhhMjJmxufg91Wl9f4zzkiUYau+5rhch3QAIJTdRIe7F7Z8kgSI8ki
	JPFTGrUOE9J8YcCpjF3/EZ/7owWxqGcP8sbQdpideaPq9Y56x1CsWl5raAcMyVw8lV8rML
	sST62OU4Tf0sTXqfl3j/ceQZa25DjTsftrGf2mCgKoK4hlzktYEEAnSQvjkjUA==
Date: Thu, 1 Feb 2024 16:44:36 +0100
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>, fstests@vger.kernel.org, 
	zlang@redhat.com, Dave Chinner <david@fromorbit.com>, mcgrof@kernel.org, 
	gost.dev@samsung.com, linux-xfs@vger.kernel.org, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: Re: fstest failure due to filesystem size for 16k, 32k and 64k FSB
Message-ID: <f5wwi5oqok5p6somhubriesmmhlvvid7csszy5cmjqem37jy4g@2of2bw4azlvx>
References: <CGME20240130131803eucas1p280d9355ca3f8dc94073aff54555e3820@eucas1p2.samsung.com>
 <fe7fec1c-3b08-430f-9c95-ea76b237acf4@samsung.com>
 <20240130195602.GJ1371843@frogsfrogsfrogs>
 <6bea58ad-5b07-4104-a6ff-a2c51a03bd2f@samsung.com>
 <20240131034851.GF6188@frogsfrogsfrogs>
 <yhuvl7u466fc6zznulfirtg35m7fteutzhar2dhunrxleterym@3qxydiupxnsx>
 <20240131182858.GG6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240131182858.GG6188@frogsfrogsfrogs>
X-Rspamd-Queue-Id: 4TQjrl1PfQz9srx

On Wed, Jan 31, 2024 at 10:28:58AM -0800, Darrick J. Wong wrote:
> On Wed, Jan 31, 2024 at 03:05:48PM +0100, Pankaj Raghav (Samsung) wrote:
> > > > 
> > > > Thanks for the reply. So we can have a small `if` conditional block for xfs
> > > > to have fs size = 500M in generic test cases.
> > > 
> > > I'd suggest creating a helper where you pass in the fs size you want and
> > > it rounds that up to the minimum value.  That would then get passed to
> > > _scratch_mkfs_sized or _scsi_debug_get_dev.
> > > 
> > > (testing this as we speak...)
> > 
> > I would be more than happy if you send a patch for
> > this but I also know you are pretty busy, so let me know if you want me
> > to send a patch for this issue.
> > 
> > You had something like this in mind?
> 
> Close, but something more like below.  It's not exhaustive; it merely
> makes the xfs 64k bs tests pass:
> 

I still see some errors in generic/081 and generic/108 that have been
modified in your patch with the same issue.

This is the mkfs option I am using:
-m reflink=1,rmapbt=1, -i sparse=1, -b size=64k

And with that:
$ ./check -s 64k generic/042 generic/081 generic/108 generic/704 generic/730 generic/731 xfs/279

...
generic/081.out.bad:
 +max log size 1732 smaller than min log size 2028, filesystem is too small
...
generic/108.out.bad:
+max log size 1876 smaller than min log size 2028, filesystem is too small
...
SECTION       -- 64k
=========================
Ran: generic/042 generic/081 generic/108 generic/704 generic/730 generic/731 xfs/279
Failures: generic/081 generic/108
Failed 2 of 7 tests

**Increasing the size** to 600M fixes all the test in 64k system.

The patch itself including `_small_fs_size_mb()` looks good to me.

> From: Darrick J. Wong <djwong@kernel.org>
> Subject: [PATCH] misc: fix test that fail formatting with 64k blocksize
> 
> There's a bunch of tests that fail the formatting step when the test run
> is configured to use XFS with a 64k blocksize.  This happens because XFS
> doesn't really support that combination due to minimum log size
> constraints.  Fix the test to format larger devices in that case.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/rc         |   29 +++++++++++++++++++++++++++++
>  tests/generic/042 |    9 +--------
>  tests/generic/081 |    7 +++++--
>  tests/generic/108 |    6 ++++--
>  tests/generic/704 |    3 ++-
>  tests/generic/730 |    3 ++-
>  tests/generic/731 |    3 ++-
>  tests/xfs/279     |    7 ++++---

As I indicated at the start of the thread, we need to also fix:
generic/455 generic/457 generic/482 shared/298

Thanks!
--
Pankaj Raghav
