Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56012 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966447AbcKLSbc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 12 Nov 2016 13:31:32 -0500
Date: Sun, 13 Nov 2016 02:31:29 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: new xfs/103 failure
Message-ID: <20161112183129.GJ27776@eguan.usersys.redhat.com>
References: <20161112163248.GA24737@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161112163248.GA24737@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Sat, Nov 12, 2016 at 08:32:48AM -0800, Christoph Hellwig wrote:
> After recently upgrading the xfs and xfsprogs trees I get reproducible
> xfs/103 failures because the n flags is not reported.  Does anyone else
> see this?

I see xfs/103 hang with latest xfsprogs & xfstests, and after applying
this xfstests patch xfs/103 passed for me without problem. kernel is
for-next branch from xfs tree.

http://www.spinics.net/lists/fstests/msg04308.html

Not sure if this is related to your problem.

Thanks,
Eryu

> 
> root@testvm:~/xfstests# diff -u tests/xfs/103.out
> /root/xfstests/results//xfs/103
> --- tests/xfs/103.outs# 2016-03-29 13:59:30.451720622
> +0000stests/results//xfs/10
> +++ /root/xfstests/results//xfs/103.out.bad	2016-11-12
> 16:30:37.032780388 +0000
> @@ -3,7 +3,7 @@
>  *** mount
>  *** testing nosymlinks directories
>  *** setting nosymlinks bit
> ---n-- SCRATCH_MNT/nosymlink
> +----- SCRATCH_MNT/nosymlink
>  ln: creating symbolic link 'SCRATCH_MNT/nosymlink/target': Operation not permitted
>  *** 1st listing...
>  SCRATCH_MNT
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
