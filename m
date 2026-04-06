Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1BE37E2ED
	for <linux-xfs@vger.kernel.org>; Mon,  6 Apr 2026 14:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775484752; cv=none; b=g2JLUW7N7Y0t2ujcD+/XUvxgPtFVaPuBkhK/+H4Ag9Lek+Zx+nWGqSb4AUvHQfGBozlB2gvkFuUUizgP3//Pu2LZF/hTwug0/nFm+sZ4NkoCd1xyKVMudsyjA+GxXSjV+DvM2IqCNLfBqj9t+ZV8mWE+FiGrAFtX1OFdPqopq1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775484752; c=relaxed/simple;
	bh=Azr2aHGj0BVqD+O0XMt3evqkED8zuU7pGDdyiathlcY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sz7eiRsEc6fPhaWymjwU7cejQfoYxl7fVK21XLsth9VrSdkMJBS2O5EPFy5q5yvqCy13mPzatQvkaVD96EDNwbmlrXKsZspBKM7+CZBMcQbhoac2ZUnuDbNQwVr3RKnz5leFSQZFFbyxS6q/EPqgonIojjA1t0CTacAuS9k+Ge8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OYxIduWy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OYxIduWy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775484750;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2buYnToE+ok8MR38Bj2G8G1qdvagjV2+cCbEyl/EqJA=;
	b=OYxIduWy04VkGSwMqA9Q43k5O4D/h0u1PIxkICF0l9bZCqqa1AYHwrvC+sYLs4BaawHdQq
	iJXBHLJUUHVe9zI4FWt8zxLp/o34T/NCCAUwxpltWO5dOdCqYWm/rGRdqQdhzBXJGYctiq
	XmLDXXe89mUFsaj5IoA0aRAd2Nj/m3o=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-44-1N3VB5RjPUSrBMe5TQHuPw-1; Mon,
 06 Apr 2026 10:12:27 -0400
X-MC-Unique: 1N3VB5RjPUSrBMe5TQHuPw-1
X-Mimecast-MFC-AGG-ID: 1N3VB5RjPUSrBMe5TQHuPw_1775484746
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CE4C819560AA;
	Mon,  6 Apr 2026 14:12:25 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.79])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C220A1800351;
	Mon,  6 Apr 2026 14:12:24 +0000 (UTC)
Date: Mon, 6 Apr 2026 10:12:22 -0400
From: Brian Foster <bfoster@redhat.com>
To: Edward Adam Davis <eadavis@qq.com>
Cc: syzbot+b7dfbed0c6c2b5e9fd34@syzkaller.appspotmail.com, cem@kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] xfs: reject CRC validation when the log header cannot be
 retrieved
Message-ID: <adO_Rm7EN4vwWaYX@bfoster>
References: <69cebb99.050a0220.2dbe29.0007.GAE@google.com>
 <tencent_4D4CBF27D046DE52D3067D099C6EDDEECC06@qq.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_4D4CBF27D046DE52D3067D099C6EDDEECC06@qq.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Fri, Apr 03, 2026 at 09:43:39AM +0800, Edward Adam Davis wrote:
> When the traditional algorithm fails to locate the log header, it triggers
> the uninitialized-value issue regarding tmp_rhead_blk reported in [1],
> continuing with the subsequent CRC verification traversal in such a
> scenario is futile.
> 
> A check has been added to detect the absence of the log header and prevent
> the execution of the subsequent CRC verification traversal.
> 
> [1]
> BUG: KMSAN: uninit-value in xlog_verify_head+0x6c3/0x910 fs/xfs/xfs_log_recover.c:1058
>  xlog_verify_head+0x6c3/0x910 fs/xfs/xfs_log_recover.c:1058
>  xlog_find_tail+0xc2e/0x1a50 fs/xfs/xfs_log_recover.c:1315
>  xlog_recover+0x6d/0x800 fs/xfs/xfs_log_recover.c:3426
>  xfs_log_mount+0x4da/0x880 fs/xfs/xfs_log.c:617
> 
> Local variable tmp_rhead_blk created at:
>  xlog_verify_head+0x81/0x910 fs/xfs/xfs_log_recover.c:1032
> 
> Reported-by: syzbot+b7dfbed0c6c2b5e9fd34@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=b7dfbed0c6c2b5e9fd34
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> ---
>  fs/xfs/xfs_log_recover.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 09e6678ca487..0d1b4bddd193 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1050,6 +1050,9 @@ xlog_verify_head(
>  	if (error < 0)
>  		return error;
>  
> +	if (!error)
> +		return -EIO;
> +

Hmm.. at this point we've located the head block, pulled the tail block
from the log record header and are attempting to find the last written
log record that could have potentially been torn based on max iclogs so
we can verify it with a CRC pass.

Have you dug into how syzbot triggers this issue? The tweak seems
reasonable at a glance as I'm not sure why we wouldn't find at least one
log record header in the head/tail range, but at minimum the patch
should provide some analysis on why we should make that assumption here
and how this happens. It would also be ideal to know what's going on to
help determine whether there isn't some other issue here that might need
to be addressed.

For example, are we returning 0 here for the head verification pass and
aside from the uninit variable issue, falling into an otherwise
functional log recovery? Or does log recovery ultimately fail further
along? I'd be hesitant to blindly add an error return into a functioning
recovery situation as that might imply there's something wrong with the
verification logic, whereas maybe it's a different story if there's some
corruption or something that we're not handling gracefully enough.

FWIW, I did some LLM prodding at if/how something like this might happen
and it threw out some ideas based on records wrapping the log, but TBH
given the difficulty it has processing the details and layers of
complexity here I'm not really sure I trust it. The best bet is probably
to dig more into what the log looks like and why it triggers the issue.

Brian

>  	/*
>  	 * Now run a CRC verification pass over the records starting at the
>  	 * block found above to the current head. If a CRC failure occurs, the
> -- 
> 2.43.0
> 
> 

