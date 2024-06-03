Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E45512F386
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 14:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717425479; cv=none; b=D0Jj7Flknc6z+5KOQqq70I4EdHrmS3GXf3IlIlIH285XV5Yh+5w82OOJwq7ir/3wncW/ydKq+tqGYX3pAXQ//pui6vbG1TlTUDtOrM6bWWdpQLwQ7N7r6IWNTgSnYaFn7SslcQx4oMWJzeplj8mXSehM2ifRRCPum8HFZBcAKfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717425479; c=relaxed/simple;
	bh=Es9e91vfOTiO/dQd9gTLsx3p9tK5Yc/rFZRZd3BGgUA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vo4c13cFbyW9NNzGhXlULDDkhH2UtaIWXz+zc6W8+HDueEtVg5zHedx7a9pB03nxVrNvuunZadyjtztNM/sWf9h3uMAVX7fDgwO8Ff/60oftSXfL59Sr+FHQLb5RFmYAsKh88v1pmyB1v/jD6Ps+b96mbj3yD47lk1DVv5Hz7UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FIcrelZo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FIcrelZo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717425476;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cOqpzK8CEz5l9HIAXp01oFv5EEExOqKe+EKDu9hbe/I=;
	b=FIcrelZoebZgzugO0CVbtrURsivplQ4aVkMiDDCjVUvEdFeubPHQCuHL1yw0ApH/rtmXrs
	mwlkd4qq9hFj/6QBgOeiChxpbOKd6qY0WmAm7RJpFA0vxKnDZqPNSvw2EX5ZZ0qvtzU3sJ
	/JnGmXY7hSFo8zghs8zohvdLNF9PgjQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-209-1oYrCS98MAW31na5gptarQ-1; Mon,
 03 Jun 2024 10:37:53 -0400
X-MC-Unique: 1oYrCS98MAW31na5gptarQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E01C618FFA58;
	Mon,  3 Jun 2024 14:37:39 +0000 (UTC)
Received: from bfoster (unknown [10.22.8.96])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5583630000C3;
	Mon,  3 Jun 2024 14:37:36 +0000 (UTC)
Date: Mon, 3 Jun 2024 10:37:48 -0400
From: Brian Foster <bfoster@redhat.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, djwong@kernel.org, hch@infradead.org,
	brauner@kernel.org, david@fromorbit.com, chandanbabu@kernel.org,
	jack@suse.cz, willy@infradead.org, yi.zhang@huawei.com,
	chengzhihao1@huawei.com, yukuai3@huawei.com
Subject: Re: [RFC PATCH v4 1/8] iomap: zeroing needs to be pagecache aware
Message-ID: <Zl3VPA5mVUP4iC3R@bfoster>
References: <20240529095206.2568162-1-yi.zhang@huaweicloud.com>
 <20240529095206.2568162-2-yi.zhang@huaweicloud.com>
 <ZlxRz9LPNuoOZOtl@bfoster>
 <cc7e0a68-185f-a3e0-d60a-989b8b014608@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc7e0a68-185f-a3e0-d60a-989b8b014608@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Mon, Jun 03, 2024 at 05:07:02PM +0800, Zhang Yi wrote:
> On 2024/6/2 19:04, Brian Foster wrote:
> > On Wed, May 29, 2024 at 05:51:59PM +0800, Zhang Yi wrote:
> >> From: Dave Chinner <dchinner@redhat.com>
> >>
> >> Unwritten extents can have page cache data over the range being
> >> zeroed so we can't just skip them entirely. Fix this by checking for
> >> an existing dirty folio over the unwritten range we are zeroing
> >> and only performing zeroing if the folio is already dirty.
> >>
> >> XXX: how do we detect a iomap containing a cow mapping over a hole
> >> in iomap_zero_iter()? The XFS code implies this case also needs to
> >> zero the page cache if there is data present, so trigger for page
> >> cache lookup only in iomap_zero_iter() needs to handle this case as
> >> well.
> >>
> >> Before:
> >>
> >> $ time sudo ./pwrite-trunc /mnt/scratch/foo 50000
> >> path /mnt/scratch/foo, 50000 iters
> >>
> >> real    0m14.103s
> >> user    0m0.015s
> >> sys     0m0.020s
> >>
> >> $ sudo strace -c ./pwrite-trunc /mnt/scratch/foo 50000
> >> path /mnt/scratch/foo, 50000 iters
> >> % time     seconds  usecs/call     calls    errors syscall
> >> ------ ----------- ----------- --------- --------- ----------------
> >>  85.90    0.847616          16     50000           ftruncate
> >>  14.01    0.138229           2     50000           pwrite64
> >> ....
> >>
> >> After:
> >>
> >> $ time sudo ./pwrite-trunc /mnt/scratch/foo 50000
> >> path /mnt/scratch/foo, 50000 iters
> >>
> >> real    0m0.144s
> >> user    0m0.021s
> >> sys     0m0.012s
> >>
> >> $ sudo strace -c ./pwrite-trunc /mnt/scratch/foo 50000
> >> path /mnt/scratch/foo, 50000 iters
> >> % time     seconds  usecs/call     calls    errors syscall
> >> ------ ----------- ----------- --------- --------- ----------------
> >>  53.86    0.505964          10     50000           ftruncate
> >>  46.12    0.433251           8     50000           pwrite64
> >> ....
> >>
> >> Yup, we get back all the performance.
> >>
> >> As for the "mmap write beyond EOF" data exposure aspect
> >> documented here:
> >>
> >> https://lore.kernel.org/linux-xfs/20221104182358.2007475-1-bfoster@redhat.com/
> >>
> >> With this command:
> >>
> >> $ sudo xfs_io -tfc "falloc 0 1k" -c "pwrite 0 1k" \
> >>   -c "mmap 0 4k" -c "mwrite 3k 1k" -c "pwrite 32k 4k" \
> >>   -c fsync -c "pread -v 3k 32" /mnt/scratch/foo
> >>
> >> Before:
> >>
> >> wrote 1024/1024 bytes at offset 0
> >> 1 KiB, 1 ops; 0.0000 sec (34.877 MiB/sec and 35714.2857 ops/sec)
> >> wrote 4096/4096 bytes at offset 32768
> >> 4 KiB, 1 ops; 0.0000 sec (229.779 MiB/sec and 58823.5294 ops/sec)
> >> 00000c00:  58 58 58 58 58 58 58 58 58 58 58 58 58 58 58 58
> >> XXXXXXXXXXXXXXXX
> >> 00000c10:  58 58 58 58 58 58 58 58 58 58 58 58 58 58 58 58
> >> XXXXXXXXXXXXXXXX
> >> read 32/32 bytes at offset 3072
> >> 32.000000 bytes, 1 ops; 0.0000 sec (568.182 KiB/sec and 18181.8182
> >>    ops/sec
> >>
> >> After:
> >>
> >> wrote 1024/1024 bytes at offset 0
> >> 1 KiB, 1 ops; 0.0000 sec (40.690 MiB/sec and 41666.6667 ops/sec)
> >> wrote 4096/4096 bytes at offset 32768
> >> 4 KiB, 1 ops; 0.0000 sec (150.240 MiB/sec and 38461.5385 ops/sec)
> >> 00000c00:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> >> ................
> >> 00000c10:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> >> ................
> >> read 32/32 bytes at offset 3072
> >> 32.000000 bytes, 1 ops; 0.0000 sec (558.036 KiB/sec and 17857.1429
> >>    ops/sec)
> >>
> >> We see that this post-eof unwritten extent dirty page zeroing is
> >> working correctly.
> >>
> > 
> > I've pointed this out in the past, but IIRC this implementation is racy
> > vs. reclaim. Specifically, relying on folio lookup after mapping lookup
> > doesn't take reclaim into account, so if we look up an unwritten mapping
> > and then a folio flushes and reclaims by the time the scan reaches that
> > offset, it incorrectly treats that subrange as already zero when it
> > actually isn't (because the extent is actually stale by that point, but
> > the stale extent check is skipped).
> > 
> 
> Hello, Brian!
> 
> I'm confused, how could that happen? We do stale check under folio lock,
> if the folio flushed and reclaimed before we get&lock that folio in
> iomap_zero_iter()->iomap_write_begin(), the ->iomap_valid() would check
> this stale out and zero again in the next iteration. Am I missing
> something?
> 

Hi Yi,

Yep, that is my understanding of how the revalidation thing works in
general as well. The nuance in this particular case is that no folio
exists at the associated offset. Therefore, the reval is skipped in
iomap_write_begin(), iomap_zero_iter() skips over the range as well, and
the operation carries on as normal.

Have you tried the test sequence above? I just retried on latest master
plus this series and it still trips for me. I haven't redone the low
level analysis, but in general what this is trying to show is something
like the following...

Suppose we start with an unwritten block on disk with a dirty folio in
cache:

- iomap looks up the extent and finds the unwritten mapping.
- Reclaim kicks in and writes back the page and removes it from cache.
  The underlying block is no longer unwritten (current mapping is now
  stale).
- iomap_zero_iter() processes the associated offset. iomap_get_folio()
  clears FGP_CREAT, no folio is found.
- iomap_write_begin() returns -ENOENT (i.e. no folio lock ->
  iomap_valid()). iomap_zero_iter() consumes the error and skips to the
  next range.

At that point we have data on disk from a previous write that a
post-write zero range (i.e. truncate) failed to zero. Let me know if you
think this doesn't match up with the current series. It's been a while
since I've looked at this and it's certainly possible I've missed
something or something changed.

Otherwise, I think there are multiple potential ways around this. I.e.,
you could consider a fallback locking mode for reval, explicit (large?)
folio recreation and invalidation (if non-dirty) over unwritten mappings
for revalidation purposes, or something like the POC diff in reply to
hch on patch 3 around checking cache prior to iomap lookup (which also
has tradeoffs). I'm sure there are other ideas as well.

Brian

> Thanks,
> Yi.
> 
> > A simple example to demonstrate this is something like the following:
> > 
> > # looping truncate zeroing
> > while [ true ]; do
> > 	xfs_io -fc "truncate 0" -c "falloc 0 32K" -c "pwrite 0 4k" -c "truncate 2k" <file>
> > 	xfs_io -c "mmap 0 4k" -c "mread -v 2k 16" <file> | grep cd && break
> > done
> > 
> > vs.
> > 
> > # looping writeback and reclaim
> > while [ true ]; do
> > 	xfs_io -c "sync_range -a 0 0" -c "fadvise -d 0 0" <file>
> > done
> > 
> > If I ran that against this patch, the first loop will eventually detect
> > stale data exposed past eof.
> > 
> > Brian
> > 
> 

