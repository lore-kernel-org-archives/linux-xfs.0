Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 205CFEB64D9
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jun 2023 22:15:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbjFOWPP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Jun 2023 18:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232153AbjFOWPO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2023 18:15:14 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE9A2D4B
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 15:14:51 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-666669bb882so194451b3a.1
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 15:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1686867291; x=1689459291;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IF5eQu9JzXP5pTPqedmElzgFQSKW6QHeu1frLlJDFcU=;
        b=bmOAFc0tzM6lCray1vVQpkieO05XInZFliI8rHAyTtXRenU2VbSLahnqAmOHliUWdc
         dH7SXGT3mPhEmxGW40WqnqT5KbFrr5BfGteJv+ShHipHwE9u8Vkq8lx1cav8aG8HgADm
         oZOS7HkVPsqrOjVTnh8BN1ZnMIH/PygLDfNGkcNN2U05igP6sU/WulkcReu/hDI8g7BO
         HrvVZg9PUR41VhD9yBKJrhueI9zV/PqWVOh62V/js2SogmkQTuNIX8L4DfVBTHM2EAQT
         pqD9n4484fclOqI+x/CKq8rbOXLQ4rdFGlQvIkMWilRkO72z1oazSdy5ztdS6x3laXVr
         JtTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686867291; x=1689459291;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IF5eQu9JzXP5pTPqedmElzgFQSKW6QHeu1frLlJDFcU=;
        b=HRqmnWs+WTKAgw4UWAgswOza1akQB25g9+yT89Vs9A4Ea/xBpmRV3IK1/8ZjGnZI0C
         hJalVHUe/94R1S3Hz6ZgxGUYnQHbMxIMRwGwq6zzQQrEOABZHXgmSjhHZjCUMkDvFSFQ
         8G9rUytbEKchcQ+ASNV+AKBPuX6X9gHmtYZ75jUf8BMzioN7ITVxg7KpFFSqq7Y/P3g4
         9IdsSaeAvEGTmG6Wa6ObVtz7ad9SKKTVYrWoz0mPo1VVjR9uHNkr6hsmWfyTqn08EAYY
         rkOXGx0zesenF3MvLdGO75QnXiLe2jz2Rjek938fQGCXw9is7SivoQtdp9rsnfuBwEgZ
         cMQQ==
X-Gm-Message-State: AC+VfDzGfbtjsMADemyfwLMedcgFKdTMiBLjmpDus8dPf1Rti3JIAuZA
        j1gIE/6cMXYvD1jgpg3/Xg8z3w==
X-Google-Smtp-Source: ACHHUZ5deqNQwe8ZdtzVUk1Y1yt0qGZqmMfko7+WvOXQ4vqHdqmxMVBy7TmtgbrPJqJ4xtqqVniNDA==
X-Received: by 2002:a05:6a00:cc2:b0:656:c7b2:876f with SMTP id b2-20020a056a000cc200b00656c7b2876fmr499181pfv.14.1686867290705;
        Thu, 15 Jun 2023 15:14:50 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id j8-20020aa78008000000b00659edece5dasm10321183pfi.49.2023.06.15.15.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 15:14:50 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q9vEt-00CEaa-11;
        Fri, 16 Jun 2023 08:14:47 +1000
Date:   Fri, 16 Jun 2023 08:14:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "chandanrlinux@gmail.com" <chandanrlinux@gmail.com>
Subject: Re: [PATCH 1/3] xfs: pass alloc flags through to
 xfs_extent_busy_flush()
Message-ID: <ZIuNV8UqlOFmUmOY@dread.disaster.area>
References: <20230615014201.3171380-1-david@fromorbit.com>
 <20230615014201.3171380-2-david@fromorbit.com>
 <25F855D8-F944-45D0-9BB2-3E475A301EDB@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <25F855D8-F944-45D0-9BB2-3E475A301EDB@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 15, 2023 at 09:57:18PM +0000, Wengang Wang wrote:
> Hi Dave,
> 
> I got this error when applying this patch to the newest code:
> (I tried on both MacOS and OL8, it’s the same result)
> 
> $ patch -p1 <~/tmp/Dave1.txt
> patching file 'fs/xfs/libxfs/xfs_alloc.c'
> patch: **** malformed patch at line 27:  */

Whoa. I haven't use patch like this for a decade. :)

The way all the cool kids do this now is apply the entire series to
directly to a git tree branch with b4:

$ b4 am -o - 20230615014201.3171380-2-david@fromorbit.com | git am

(b4 shazam merges the b4 am and git am operations into the one
command, IIRC, but that trick isn't automatic for me yet :)
> Looking at the patch to see the line numbers:
> 
>  22 diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
>  23 index c20fe99405d8..11bd0a1756a1 100644
>  24 --- a/fs/xfs/libxfs/xfs_alloc.c
>  25 +++ b/fs/xfs/libxfs/xfs_alloc.c
>  26 @@ -1536,7 +1536,8 @@ xfs_alloc_ag_vextent_lastblock(
>  27  */
>  28 STATIC int
>  29 xfs_alloc_ag_vextent_near(

Yup, however you saved the patch to a file stripped the leading
spaces from all the lines in the patch.

If you look at the raw email on lore it has the correct leading
spaces in the patch.

https://lore.kernel.org/linux-xfs/20230615014201.3171380-2-david@fromorbit.com/raw

These sorts of patching problems go away when you use tools like b4
to pull the patches directly from the mailing list...

> > On Jun 14, 2023, at 6:41 PM, Dave Chinner <david@fromorbit.com> wrote:
> > 
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > To avoid blocking in xfs_extent_busy_flush() when freeing extents
> > and the only busy extents are held by the current transaction, we
> > need to pass the XFS_ALLOC_FLAG_FREEING flag context all the way
> > into xfs_extent_busy_flush().
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> > fs/xfs/libxfs/xfs_alloc.c | 96 +++++++++++++++++++++------------------
> > fs/xfs/libxfs/xfs_alloc.h |  2 +-
> > fs/xfs/xfs_extent_busy.c  |  3 +-
> > fs/xfs/xfs_extent_busy.h  |  2 +-
> > 4 files changed, 56 insertions(+), 47 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index c20fe99405d8..11bd0a1756a1 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -1536,7 +1536,8 @@ xfs_alloc_ag_vextent_lastblock(
> >  */
> > STATIC int
> > xfs_alloc_ag_vextent_near(
> > - struct xfs_alloc_arg *args)
> > + struct xfs_alloc_arg *args,
> > + uint32_t alloc_flags)
> > {
> > struct xfs_alloc_cur acur = {};
> > int error; /* error code */

This indicates the problem is likely to be your mail program,
because the quoting it has done here has completely mangled all the
whitespace in the patch....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
