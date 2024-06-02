Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612E92E3E9
	for <linux-xfs@vger.kernel.org>; Sun,  2 Jun 2024 11:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717326281; cv=none; b=uUapMmPIiEfDZH2jAUibQAaZ69dtSPvtCko4JGuV7RiEnjf4ZV9Px9qaRMQu+DNbKAt30gLCUPnjObzmgp4zSbTnAcDv+lKqJ2PF6+xAXfcqiu2yH93YxLJ8cjOBx3SjsDBDHa198h1fA00TjeuAKTZOEVTy1572Cmol7lcbpP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717326281; c=relaxed/simple;
	bh=PvJfrcgdw2ZEP8oxZRffPus/wUS5uj9s+Fa7sxHHdzs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hH7knfHRMnF0kXu4v6DDfNl9mGiCBCJVJ4IAgLEZyza9nEAQQLyxh51rZ3PiF2fPh4zfBEyz5DvZzREAlRAH9W6iMmJTTZQYUPSB/7b/I3ebn3RKmWFzI7Bxz7vzYueyC+VFTWBlc3/f1HKZzTjQ8lbWZBGaeiP7kxxRs/n+rB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Yoc1DTfe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Yoc1DTfe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717326279;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2RmCsa3x4PFA+Awu1HBsaYV9OR5QaPiIjh54C0Qzzgg=;
	b=Yoc1DTfe9nzCMQNRypLWP4DIKxsELXaySOvxpHL7L0jAnUL84HY7sJPIh87tvCJrXOKZcU
	rldBumg6HsuRIQXvxpBexQ1QvKaeK3TGPI/jz2DvzrrWw7c1KYvm+YeF8sGphwNfdA5z8S
	RtZ5rElhvAY2G65f+9VTpTi+XFPHWfQ=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-319-0ynkJ7azMDSTQA4HTcLcpg-1; Sun,
 02 Jun 2024 07:04:31 -0400
X-MC-Unique: 0ynkJ7azMDSTQA4HTcLcpg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F5053C025AC;
	Sun,  2 Jun 2024 11:04:30 +0000 (UTC)
Received: from bfoster (unknown [10.22.8.96])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C8C5105480A;
	Sun,  2 Jun 2024 11:04:29 +0000 (UTC)
Date: Sun, 2 Jun 2024 07:04:47 -0400
From: Brian Foster <bfoster@redhat.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, djwong@kernel.org, hch@infradead.org,
	brauner@kernel.org, david@fromorbit.com, chandanbabu@kernel.org,
	jack@suse.cz, willy@infradead.org, yi.zhang@huawei.com,
	chengzhihao1@huawei.com, yukuai3@huawei.com
Subject: Re: [RFC PATCH v4 1/8] iomap: zeroing needs to be pagecache aware
Message-ID: <ZlxRz9LPNuoOZOtl@bfoster>
References: <20240529095206.2568162-1-yi.zhang@huaweicloud.com>
 <20240529095206.2568162-2-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240529095206.2568162-2-yi.zhang@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

On Wed, May 29, 2024 at 05:51:59PM +0800, Zhang Yi wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Unwritten extents can have page cache data over the range being
> zeroed so we can't just skip them entirely. Fix this by checking for
> an existing dirty folio over the unwritten range we are zeroing
> and only performing zeroing if the folio is already dirty.
> 
> XXX: how do we detect a iomap containing a cow mapping over a hole
> in iomap_zero_iter()? The XFS code implies this case also needs to
> zero the page cache if there is data present, so trigger for page
> cache lookup only in iomap_zero_iter() needs to handle this case as
> well.
> 
> Before:
> 
> $ time sudo ./pwrite-trunc /mnt/scratch/foo 50000
> path /mnt/scratch/foo, 50000 iters
> 
> real    0m14.103s
> user    0m0.015s
> sys     0m0.020s
> 
> $ sudo strace -c ./pwrite-trunc /mnt/scratch/foo 50000
> path /mnt/scratch/foo, 50000 iters
> % time     seconds  usecs/call     calls    errors syscall
> ------ ----------- ----------- --------- --------- ----------------
>  85.90    0.847616          16     50000           ftruncate
>  14.01    0.138229           2     50000           pwrite64
> ....
> 
> After:
> 
> $ time sudo ./pwrite-trunc /mnt/scratch/foo 50000
> path /mnt/scratch/foo, 50000 iters
> 
> real    0m0.144s
> user    0m0.021s
> sys     0m0.012s
> 
> $ sudo strace -c ./pwrite-trunc /mnt/scratch/foo 50000
> path /mnt/scratch/foo, 50000 iters
> % time     seconds  usecs/call     calls    errors syscall
> ------ ----------- ----------- --------- --------- ----------------
>  53.86    0.505964          10     50000           ftruncate
>  46.12    0.433251           8     50000           pwrite64
> ....
> 
> Yup, we get back all the performance.
> 
> As for the "mmap write beyond EOF" data exposure aspect
> documented here:
> 
> https://lore.kernel.org/linux-xfs/20221104182358.2007475-1-bfoster@redhat.com/
> 
> With this command:
> 
> $ sudo xfs_io -tfc "falloc 0 1k" -c "pwrite 0 1k" \
>   -c "mmap 0 4k" -c "mwrite 3k 1k" -c "pwrite 32k 4k" \
>   -c fsync -c "pread -v 3k 32" /mnt/scratch/foo
> 
> Before:
> 
> wrote 1024/1024 bytes at offset 0
> 1 KiB, 1 ops; 0.0000 sec (34.877 MiB/sec and 35714.2857 ops/sec)
> wrote 4096/4096 bytes at offset 32768
> 4 KiB, 1 ops; 0.0000 sec (229.779 MiB/sec and 58823.5294 ops/sec)
> 00000c00:  58 58 58 58 58 58 58 58 58 58 58 58 58 58 58 58
> XXXXXXXXXXXXXXXX
> 00000c10:  58 58 58 58 58 58 58 58 58 58 58 58 58 58 58 58
> XXXXXXXXXXXXXXXX
> read 32/32 bytes at offset 3072
> 32.000000 bytes, 1 ops; 0.0000 sec (568.182 KiB/sec and 18181.8182
>    ops/sec
> 
> After:
> 
> wrote 1024/1024 bytes at offset 0
> 1 KiB, 1 ops; 0.0000 sec (40.690 MiB/sec and 41666.6667 ops/sec)
> wrote 4096/4096 bytes at offset 32768
> 4 KiB, 1 ops; 0.0000 sec (150.240 MiB/sec and 38461.5385 ops/sec)
> 00000c00:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> ................
> 00000c10:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> ................
> read 32/32 bytes at offset 3072
> 32.000000 bytes, 1 ops; 0.0000 sec (558.036 KiB/sec and 17857.1429
>    ops/sec)
> 
> We see that this post-eof unwritten extent dirty page zeroing is
> working correctly.
> 

I've pointed this out in the past, but IIRC this implementation is racy
vs. reclaim. Specifically, relying on folio lookup after mapping lookup
doesn't take reclaim into account, so if we look up an unwritten mapping
and then a folio flushes and reclaims by the time the scan reaches that
offset, it incorrectly treats that subrange as already zero when it
actually isn't (because the extent is actually stale by that point, but
the stale extent check is skipped).

A simple example to demonstrate this is something like the following:

# looping truncate zeroing
while [ true ]; do
	xfs_io -fc "truncate 0" -c "falloc 0 32K" -c "pwrite 0 4k" -c "truncate 2k" <file>
	xfs_io -c "mmap 0 4k" -c "mread -v 2k 16" <file> | grep cd && break
done

vs.

# looping writeback and reclaim
while [ true ]; do
	xfs_io -c "sync_range -a 0 0" -c "fadvise -d 0 0" <file>
done

If I ran that against this patch, the first loop will eventually detect
stale data exposed past eof.

Brian

