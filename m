Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7922E18FDDF
	for <linux-xfs@vger.kernel.org>; Tue, 10 Sep 2024 14:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725977936; cv=none; b=LCRJFG7NZc/6K5WTP2OMdtOtAfa+jLLQJ3lKQTsUe2rHZWnqzLhZw0Ooot4J8Dkqa1jRfDRzFobsrNWUik8wUjFlxpyzjDYgVCTNLecNWg150PpjfhTA1tEhAOi7qdIhArsfvFCo5tukdEwRb5Mprmgr2aGWaYiqx1efEa4S+zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725977936; c=relaxed/simple;
	bh=jiHUyJ6x73YXYkIrcOzQgXfAtScry0+JeJor9h0eoTQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UyLK5hEJqlaAUJhvIfLUZDV085Ts+5QYoNZA1hjcLiX/JgKD2Xf95AoXrIVdKCKYK2AIgYRTOWJKafexMTpvx0N2tZpm1QJuoS7lX5m1doAW9DOZsp1NVGOiQhtTgSqSHHykKf0RKYo6BcUsFDvO5Qv1XQK9Jv+4cJM4Fg4Wr6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HuyQgDMF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HuyQgDMF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725977933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TC6kiy0r0pYGURKWrV6KFL2eaR4/p8VaGxZ9KXZi1so=;
	b=HuyQgDMFEsSqUUx/qEFQgUJK7nac+yM/MkPM2L5G+s/XQcdj0X8Z8TXxuZaE/+Tjx22oog
	QWMRRuRe6U5fOKLGKWuLienA05viyV/Tv5JAYARKMBPRw/Y7aUZrBWFp9+rAj8Gr6C6IMI
	JuD7PFyD8fp67QchLN24utiBn1C+n78=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-448-AG-AruinPm25KX2tqnYbww-1; Tue,
 10 Sep 2024 10:18:50 -0400
X-MC-Unique: AG-AruinPm25KX2tqnYbww-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D99B41955D55;
	Tue, 10 Sep 2024 14:18:48 +0000 (UTC)
Received: from bfoster (unknown [10.22.16.69])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AC13119560A3;
	Tue, 10 Sep 2024 14:18:47 +0000 (UTC)
Date: Tue, 10 Sep 2024 10:19:50 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, djwong@kernel.org, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test log recovery for extent frees right after
 growfs
Message-ID: <ZuBVhszqs-fKmc9X@bfoster>
References: <20240910043127.3480554-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240910043127.3480554-1-hch@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Tue, Sep 10, 2024 at 07:31:17AM +0300, Christoph Hellwig wrote:
> Reproduce a bug where log recovery fails when an unfinised extent free
> intent is in the same log as the growfs transaction that added the AG.
> 

No real issue with the test, but I wonder if we could do something more
generic. Various XFS shutdown and log recovery issues went undetected
for a while until we started adding more of the generic stress tests
currently categorized in the recoveryloop group.

So for example, I'm wondering if you took something like generic/388 or
475 and modified it to start with a smallish fs, grew it in 1GB or
whatever increments on each loop iteration, and then ran the same
generic stress/timeout/shutdown/recovery sequence, would that eventually
reproduce the issue you've fixed? I don't think reproducibility would
need to be 100% for the test to be useful, fwiw.

Note that I'm assuming we don't have something like that already. I see
growfs and shutdown tests in tests/xfs/group.list, but nothing in both
groups and I haven't looked through the individual tests. Just a
thought.

Brian

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/1323     | 61 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1323.out | 14 +++++++++++
>  2 files changed, 75 insertions(+)
>  create mode 100755 tests/xfs/1323
>  create mode 100644 tests/xfs/1323.out
> 
> diff --git a/tests/xfs/1323 b/tests/xfs/1323
> new file mode 100755
> index 000000000..a436510b0
> --- /dev/null
> +++ b/tests/xfs/1323
> @@ -0,0 +1,61 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024, Christoph Hellwig
> +#
> +# FS QA Test No. 1323
> +#
> +# Test that recovering an extfree item residing on a freshly grown AG works.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick growfs
> +
> +. ./common/filter
> +. ./common/inject
> +
> +_require_xfs_io_error_injection "free_extent"
> +
> +_xfs_force_bdev data $SCRATCH_MNT
> +
> +_cleanup()
> +{
> +	cd /
> +	_scratch_unmount > /dev/null 2>&1
> +	rm -rf $tmp.*
> +}
> +
> +echo "Format filesystem"
> +_scratch_mkfs_sized $((128 * 1024 * 1024)) >> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +echo "Fill file system"
> +dd if=/dev/zero of=$SCRATCH_MNT/filler1 bs=64k oflag=direct &>/dev/null
> +sync
> +dd if=/dev/zero of=$SCRATCH_MNT/filler2 bs=64k oflag=direct &>/dev/null
> +sync
> +
> +echo "Grow file system"
> +$XFS_GROWFS_PROG $SCRATCH_MNT >>$seqres.full
> +
> +echo "Create test files"
> +dd if=/dev/zero of=$SCRATCH_MNT/test1 bs=8M count=4 oflag=direct | \
> +	 _filter_dd
> +dd if=/dev/zero of=$SCRATCH_MNT/test2 bs=8M count=4 oflag=direct | \
> +	 _filter_dd
> +
> +echo "Inject error"
> +_scratch_inject_error "free_extent"
> +
> +echo "Remove test file"
> +rm $SCRATCH_MNT/test2
> +
> +echo "FS should be shut down, touch will fail"
> +touch $SCRATCH_MNT/test1 2>&1 | _filter_scratch
> +
> +echo "Remount to replay log"
> +_scratch_remount_dump_log >> $seqres.full
> +
> +echo "Done"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/1323.out b/tests/xfs/1323.out
> new file mode 100644
> index 000000000..1740f9a1f
> --- /dev/null
> +++ b/tests/xfs/1323.out
> @@ -0,0 +1,14 @@
> +QA output created by 1323
> +Format filesystem
> +Fill file system
> +Grow file system
> +Create test files
> +4+0 records in
> +4+0 records out
> +4+0 records in
> +4+0 records out
> +Inject error
> +Remove test file
> +FS should be shut down, touch will fail
> +Remount to replay log
> +Done
> -- 
> 2.45.2
> 
> 

