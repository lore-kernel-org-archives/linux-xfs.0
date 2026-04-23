Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B3A3ED137
	for <linux-xfs@vger.kernel.org>; Thu, 23 Apr 2026 12:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776947157; cv=none; b=gasH8j6UtjsF/3wRQdagXX7E20744nizsVPJ/c6xH9bPsAsU8ZzuI5zp48W8xtGiqwnGUdc3bT37h63QNuUxaDAwT9xNv+kJnA6k5GQomuY0dUavaiYGlnKTqb6cEghxGqTPHvG++bT92zPTh0UTwcIPnpUEA83TS/tQqQJrLGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776947157; c=relaxed/simple;
	bh=FBjJyGVOwVuijLt2LvRBQcsgEHxNfqPNm4A3xTCb4NI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=odr+xDVK0rq3u346RBMnFqaExeA4skd99lKoA+TvAf3TkwUhqtTHLm4XYerO7oTbHCF8Vv5fvBzuoHc+1keAB6F2H6zqIDnw8IYawfjvUKrzSqlzbUUwygHyft4M1kzX9Lhmnt3ZnT6uhRuN/AHdzdRMf8YTkcKOSYnkCzkWEb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NaHOKZTR; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NaHOKZTR"
Date: Thu, 23 Apr 2026 14:25:43 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776947154;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NFuI3kxxNCrl1GLPiiErWVXfpDdcEtSe+fyhzmE9jac=;
	b=NaHOKZTRP52mY7pu+ogzf0zI5S8qT/ynND5WU9sondO+ZOha12kDjwmi0r/Xha3XZOm7AK
	05XTRztpA3R0TyfxhFOf375iEPmqlyQtS8Sq2Qtbi/kiW0DpwX3kiQgfo1APdOlUQSrScN
	dPiC1+Mib7ECPkAL7sev5w6QBHsL6hU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, hch@lst.de, 
	ritesh.list@gmail.com, jack@suse.cz, Luis Chamberlain <mcgrof@kernel.org>, 
	dgc@kernel.org, tytso@mit.edu, p.raghav@samsung.com, andres@anarazel.de, 
	brauner@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 0/5] Add buffered write-through support to iomap &
 xfs
Message-ID: <4og3axdvzyfpfx4o2rhcnwdsggha2kfoerausxx52vd6jc2hzq@u72iwxrxxble>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1775658795.git.ojaswin@linux.ibm.com>
X-Migadu-Flow: FLOW_OUT

> 
> 
> * Testing Notes (UPDATED) *
> 
> - I've added support for RWF_WRITETHROUGH to fsx and fsstress in
>   xfstests and these patches survive fsx with integrity verification as
>   well as fsstress parallel stressing.
> - -g quick with blocks size == page size and blocksize < pagesize shows
>   no new regressions.

I am hitting a very strange error in generic/127. I deconstructed it in
to two commands that can reproduce the issue:

```
$ dd if=/dev/zero of=/media/test/fsx_lite_nommap bs=262144 count=1

$ /root/home/xfstests/ltp/fsx -l 262144 -o 65536 -S 191110531 -N 100000 -L -R -W /media/test/fsx_lite_nommap
mapped writes DISABLED
Seed set to 191110531
main: filesystem does not support exchange range, disabling!
main: atomic writes need O_DIRECT (-Z), disabling!
short read: 0x0 bytes instead of 0x6c7f
LOG DUMP (1 total operations):
1(  1 mod 256): READ     0x39381 thru 0x3ffff   (0x6c7f bytes)
Log of operations saved to "/media/test/fsx_lite_nommap.fsxops"; replay with --replay-ops
fsx: save_buffer: .fsxgood file too short... will save 0x0 bytes instead of 0x40000
: Operation not supported
Correct content saved for comparison
(maybe hexdump "/media/test/fsx_lite_nommap" vs "/media/test/fsx_lite_nommap.fsxgood")
```

This is on a bs == ps (4k block size) xfs filesystem.
```
$ xfs_info /media/test/
meta-data=/dev/nvme1n1           isize=512    agcount=4, agsize=2097152 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=0
data     =                       bsize=4096   blocks=8388608, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
```

The same test passes if I pass `-G` to fsx parameters(disabling writethrough).

The error is coming when we do a read operation which feels very
strange. Could you run this in your setup and see if you can reproduce
them? I still do not know where the issue is coming from or it is
because of my test setup.

--
Pankaj
