Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from tyo185.gate.nec.co.jp ([114.179.232.185]:37652 "EHLO
        tyo185.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751374AbdBAK5N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Feb 2017 05:57:13 -0500
Received: from tyo161.gate.nec.co.jp (tyo161.gate.nec.co.jp [114.179.232.161])
        by tyo185.gate.nec.co.jp (8.15.1/8.15.1) with ESMTPS id v11AVbrT004440
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
        for <linux-xfs@vger.kernel.org>; Wed, 1 Feb 2017 19:31:37 +0900
From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [dm-devel] error propagation problem on xfs over dm stripe
Date: Wed, 1 Feb 2017 10:28:49 +0000
Message-ID: <cbc06f1f-47e1-5406-88f5-7006a3da6dbd@ce.jp.nec.com>
References: <b44b5dc2-eac0-cd40-6de8-b615cb4dece8@sandeen.net>
In-Reply-To: <b44b5dc2-eac0-cd40-6de8-b615cb4dece8@sandeen.net>
Content-Language: ja-JP
Content-Type: text/plain; charset="iso-2022-jp"
Content-ID: <27630955DBF81A40B05BF8246F3B3E1F@gisp.nec.co.jp>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>

On 02/01/17 12:12, Eric Sandeen wrote:
> xfstest generic/108 creates a stripe then fails one leg to
> see if io errors on only a subset of an io get reported
> to userspace:
> 
> # Test partial block device failure. Calls like fsync() should report failure
> # on partial I/O failure, e.g. a single failed disk in a raid 0 stripe.
> #
> # Test motivated by an XFS bug, and this commit fixed the issue
> # xfs: return errors from partial I/O failures to files
> 
> 
> This started failing with a recent xfs commit, but the change wasn't
> expected to change anything related to this behavior at all.
> 
> My best guess was that allocation and IO patterns shifted over
> the stripe, and I think that turned out to be right.
> 
> I tracked this down to being unique to dm; an md stripe of
> the same geometry doesn't have this issue.  Root cause seems
> to be that dm's dec_pending() overwrites a bio's bi_error regardless
> of current state, and in some cases will overwrite an -EIO with
> a zero.  This seems to fix it for me:
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 3086da5..3555ba8 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -808,7 +808,9 @@ static void dec_pending(struct dm_io *io, int error)
>  		} else {
>  			/* done with normal IO or empty flush */
>  			trace_block_bio_complete(md->queue, bio, io_error);
> -			bio->bi_error = io_error;
> +			/* don't overwrite or clear existing errors */
> +			if (!bio->bi_error)
> +				bio->bi_error = io_error;
>  			bio_endio(bio);
>  		}
>  	}
> 
> but Mike was a little uneasy, not knowing for sure how we got here to
> overwrite this bio's error (hopefully I'm representing his concerns
> fairly and correctly).
> 
> One other clue is that I think this is a chained bio, something xfs
> does use.
> 
> I'll submit the above as a proper dm patch if it seems sane, but figured
> I'd throw this out on the lists as a bit of a heads up / question / RFC
> before I do that.

I couldn't see why the patch is needed.

dec_pending() already takes care of mixed error/non-error returns
from underlying devices by recording the last observed error:

        if (unlikely(error)) {
                spin_lock_irqsave(&io->endio_lock, flags);
                if (!(io->error > 0 && __noflush_suspending(md)))
                        io->error = error;
                spin_unlock_irqrestore(&io->endio_lock, flags);
        }

So successful return from healthy stripe doesn't overwrite
error return from faulty stripe.

Was bi_error already set by xfs when submitted and DM had to keep it?
If so, similar fix should be necessary for other drivers, not only for DM.

-- 
Jun'ichi Nomura, NEC Corporation / NEC Solution Innovators, Ltd.
