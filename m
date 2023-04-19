Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA9E5C77B73
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Apr 2023 23:56:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbjDSX4G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Apr 2023 19:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjDSX4F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Apr 2023 19:56:05 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 538D54C1A
        for <linux-xfs@vger.kernel.org>; Wed, 19 Apr 2023 16:56:04 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id 98e67ed59e1d1-24b29812c42so270161a91.0
        for <linux-xfs@vger.kernel.org>; Wed, 19 Apr 2023 16:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1681948564; x=1684540564;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KpbrTqVgD9bvL+1d/k+wPI5AvOUxCyxK21Y/LNHxzqA=;
        b=IwO8mErDig6uRo2wDiLn4+K4YTcWaljgsn9oPkhbImtMdV4mYVPXSreKovnzFSc7n5
         p2BigJq7NCK3NKnGshdX2DknyyMRV7vivtUg3kllh76NSEh5rvgGyjbp+wgvn6eCfcyk
         eQN7XvfrRhA0tshx+sVp2SUjPXFrrTqLkNejgIrLAVf3AEn6B4YU14FFraPVhKlPlm0k
         EUexhYZE16e7KKo+2+O4Z05TIWq4fzJ1cIQxjah0adA5nzP+CDIw7X64viXCLykQ+j6g
         3DmtQ8aLyvKdI/qcLzEQIVC71N9mS9tAKSTkqCYFim3S3JMrDpYG9DhpPkXzILn4HV0N
         fc8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681948564; x=1684540564;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KpbrTqVgD9bvL+1d/k+wPI5AvOUxCyxK21Y/LNHxzqA=;
        b=VDNuTjeCGQkytIh1rHJm4FOaif1ou9CowesNF3NYFveNk46W/xtjkjE7JYhCGiXmMo
         HS2Ucw/HD3v0FITK+PSq5UFZ6SvGfL2rIGAWQtZca+ApojPb0DIjUb7FUTRaThT2fao2
         ohuOj1QTbjAKQbhiSm63bI6oj74eNyAQ6P2GMGtOq5Ei3JcwkbWXzG2xzH6d48LFacZp
         MwvzFV7u19GcdsyLBS/jY8Rds/tMCquVthkmkPL39Wm8bq8QYKkVsfmSL0frkdyHHMN9
         dJZBTlshRGu8joXJu7fTYB1eGVDfHdM7DkWQcjDg55ff1uclw5BcLrsi5AHFG0KxYSqG
         vvng==
X-Gm-Message-State: AAQBX9dTBQY0y1N0UzTGt/PeUa41d9BSW8E9ue5c9qT2uQ5Q9SahOy+X
        uEzKT81dp/D9O7NROJ6cckWT5Q==
X-Google-Smtp-Source: AKy350bUGGWNliqT3cXk8xsuYdXoXm+G6e12ydTGDWRNBB5a6WFYV8hUPRylBAH4PbnY/n/MbEQT8g==
X-Received: by 2002:a17:90b:4a03:b0:246:8488:eab1 with SMTP id kk3-20020a17090b4a0300b002468488eab1mr4388939pjb.0.1681948563760;
        Wed, 19 Apr 2023 16:56:03 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id ie10-20020a17090b400a00b0022be36be19asm55900pjb.53.2023.04.19.16.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 16:56:02 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ppHeZ-005S1q-Kc; Thu, 20 Apr 2023 09:55:59 +1000
Date:   Thu, 20 Apr 2023 09:55:59 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: IO time one extent per EFI
Message-ID: <20230419235559.GW3223426@dread.disaster.area>
References: <20230414225836.8952-1-wen.gang.wang@oracle.com>
 <20230414225836.8952-2-wen.gang.wang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414225836.8952-2-wen.gang.wang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 14, 2023 at 03:58:35PM -0700, Wengang Wang wrote:
> At IO time, make sure an EFI contains only one extent. Transaction rolling in
> xfs_defer_finish() would commit the busy blocks for previous EFIs. By that we
> avoid holding busy extents (for previously extents in the same EFI) in current
> transaction when allocating blocks for AGFL where we could be otherwise stuck
> waiting the busy extents held by current transaction to be flushed (thus a
> deadlock).
> 
> The log changes
> 1) before change:
> 
>     358 rbbn 13 rec_lsn: 1,12 Oper 5: tid: ee327fd2  len: 48 flags: None
>     359 EFI  nextents:2 id:ffff9fef708ba940
>     360 EFI id=ffff9fef708ba940 (0x21, 7)
>     361 EFI id=ffff9fef708ba940 (0x18, 8)
>     362 -----------------------------------------------------------------
>     363 rbbn 13 rec_lsn: 1,12 Oper 6: tid: ee327fd2  len: 48 flags: None
>     364 EFD  nextents:2 id:ffff9fef708ba940
>     365 EFD id=ffff9fef708ba940 (0x21, 7)
>     366 EFD id=ffff9fef708ba940 (0x18, 8)
> 
> 2) after change:
> 
>     830 rbbn 31 rec_lsn: 1,30 Oper 5: tid: 319f015f  len: 32 flags: None
>     831 EFI  nextents:1 id:ffff9fef708b9b80
>     832 EFI id=ffff9fef708b9b80 (0x21, 7)
>     833 -----------------------------------------------------------------
>     834 rbbn 31 rec_lsn: 1,30 Oper 6: tid: 319f015f  len: 32 flags: None
>     835 EFI  nextents:1 id:ffff9fef708b9d38
>     836 EFI id=ffff9fef708b9d38 (0x18, 8)
>     837 -----------------------------------------------------------------
>     838 rbbn 31 rec_lsn: 1,30 Oper 7: tid: 319f015f  len: 32 flags: None
>     839 EFD  nextents:1 id:ffff9fef708b9b80
>     840 EFD id=ffff9fef708b9b80 (0x21, 7)
>     841 -----------------------------------------------------------------
>     842 rbbn 31 rec_lsn: 1,30 Oper 8: tid: 319f015f  len: 32 flags: None
>     843 EFD  nextents:1 id:ffff9fef708b9d38
>     844 EFD id=ffff9fef708b9d38 (0x18, 8)
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
>  fs/xfs/xfs_extfree_item.h | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
> index da6a5afa607c..ae84d77eaf30 100644
> --- a/fs/xfs/xfs_extfree_item.h
> +++ b/fs/xfs/xfs_extfree_item.h
> @@ -13,8 +13,15 @@ struct kmem_cache;
>  
>  /*
>   * Max number of extents in fast allocation path.
> + *
> + * At IO time, make sure an EFI contains only one extent. Transaction rolling
> + * in xfs_defer_finish() would commit the busy blocks for previous EFIs. By
> + * that we avoid holding busy extents (for previously extents in the same EFI)
> + * in current transaction when allocating blocks for AGFL where we could be
> + * otherwise stuck waiting the busy extents held by current transaction to be
> + * flushed (thus a deadlock).
>   */
> -#define	XFS_EFI_MAX_FAST_EXTENTS	16
> +#define	XFS_EFI_MAX_FAST_EXTENTS	1

IIRC, this doesn't have anything to do with the number of extents an
EFI can hold. All it does is control how the memory for the EFI
allocated.

Oh, at some point it got overloaded code to define the max items in
a defer ops work item. Ok, I now see why you changed this, but I
don't think this is right way to solve the problem. We can handle
processing multiple extents per EFI just fine, we just need to
update the EFD and roll the transaction on each extent we process,
yes?

In hindsight, the use of XFS_EFI_MAX_FAST_EXTENTS to limit intent
size is pretty awful. I also see the same pattern copied in every
other intent.

Darrick, if the deferops code has been limiting the number of
extents in a work item to this value, when will we ever see an
intent with more extents that .max_items in it? And if that is the
case, then why wouldn't we consider an intent with more extents than
we support in log recovery a corruption event?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
