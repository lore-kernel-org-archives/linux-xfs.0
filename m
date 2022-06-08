Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6470DC43334
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jun 2022 08:17:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiFHIQ4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jun 2022 04:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbiFHIPW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jun 2022 04:15:22 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463D892D34
        for <linux-xfs@vger.kernel.org>; Wed,  8 Jun 2022 00:44:09 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id r12so16233202vsg.8
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jun 2022 00:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iRB06EVD3amCRgzMOHbbyx10Eft7aMcniaNBoJrZfGY=;
        b=UFZX90SV8Oii7IsP5m+lXFzfv5jlgUqCIH9fNqhEraWbsfTuB8QN6IqSfb4MdcBc54
         SfM4fF46uQKvPxu1VtF15YBPpFDKCmaC0Vx5q/xBcCJ1h3FgB3TFfajMM4DsrV9P0JYC
         86iY2u6iLjb14+tthb1Cnf6qM/D4SOw6ANp2qRQ7qYaHxPMXR/GkwMFrntrLC/1vQHet
         9v6vlo8qmgHrVN33xbNb++xcDKw8GXesjxqBQlV6cCCzpQa/p0DHHEB5vh3xxtwDCNNh
         8AZleuGB2SjehcfQYeEmqbfcC0vMuq2xiEA47xlRtOQPSyfm9jvQN1FQNB94Z6qVY9gX
         0PCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iRB06EVD3amCRgzMOHbbyx10Eft7aMcniaNBoJrZfGY=;
        b=jXCWamy2KIjTh4M4PHmWcsZk310WQhLk8H0Errsj9pP4aeY8LUVtgFga8SMCgH/436
         38VHYeiqSN5uheFqnmlAabKsaIK3r5za5xNWWJrIkhruR7CklpJB7KsoLr10xQWPmA4w
         ZgkQU+p0HJy+7aLV63D4LBSh1XVpRx9ppgdd/68JywAixcrGK/P8bDC8lsmVrw4QHx/0
         rfbbkNsSqxMhi6eTEzr9RoM/Tjsa1dM08oTraUxXnsAipyrp4sNUop4GAJNh/pXtRkoX
         tqUHj7aHbJLVMlV6WdKljvf2iPtvuVUe0wUshZeqZg8zm4b3mT9sufC4ev+RWLK9ixti
         IQ7A==
X-Gm-Message-State: AOAM533qUQUtB18m0N0YSp02GPc8Tiz46HjUmYqoIeoDelLHgD0rVjm9
        ptj4sjhyENijVGlQI1diZINmRaSyW1lQ4q2Sl8cf7Sx5cairkQ==
X-Google-Smtp-Source: ABdhPJyS00+cfa1G+5Tww/oimiCi6C+EZd8I6sozI3gJGIzOTb74lnYxadzkjvRg96sVCBsMmpjRNSmM7idwtTL48a4=
X-Received: by 2002:a67:d28f:0:b0:34b:9225:6fda with SMTP id
 z15-20020a67d28f000000b0034b92256fdamr12931693vsi.72.1654674248335; Wed, 08
 Jun 2022 00:44:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220603185721.3121645-1-leah.rumancik@gmail.com> <20220603185721.3121645-12-leah.rumancik@gmail.com>
In-Reply-To: <20220603185721.3121645-12-leah.rumancik@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 8 Jun 2022 10:43:57 +0300
Message-ID: <CAOQ4uxh__DXycqz+6AFZK3JxLw0Bb_xCNv3eAmX-FdTk0miq8g@mail.gmail.com>
Subject: Re: [PATCH 5.15 12/15] xfs: async CIL flushes need pending pushes to
 be made stable
To:     Leah Rumancik <leah.rumancik@gmail.com>,
        Dave Chinner <dchinner@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 6, 2022 at 8:12 AM Leah Rumancik <leah.rumancik@gmail.com> wrote:
>
> From: Dave Chinner <dchinner@redhat.com>
>
> [ Upstream commit 70447e0ad9781f84e60e0990888bd8c84987f44e ]
>
> When the AIL tries to flush the CIL, it relies on the CIL push
> ending up on stable storage without having to wait for and
> manipulate iclog state directly. However, if there is already a
> pending CIL push when the AIL tries to flush the CIL, it won't set
> the cil->xc_push_commit_stable flag and so the CIL push will not
> actively flush the commit record iclog.
>
> generic/530 when run on a single CPU test VM can trigger this fairly
> reliably. This test exercises unlinked inode recovery, and can
> result in inodes being pinned in memory by ongoing modifications to
> the inode cluster buffer to record unlinked list modifications. As a
> result, the first inode unlinked in a buffer can pin the tail of the
> log whilst the inode cluster buffer is pinned by the current
> checkpoint that has been pushed but isn't on stable storage because
> because the cil->xc_push_commit_stable was not set. This results in
> the log/AIL effectively deadlocking until something triggers the
> commit record iclog to be pushed to stable storage (i.e. the
> periodic log worker calling xfs_log_force()).
>
> The fix is two-fold - first we should always set the
> cil->xc_push_commit_stable when xlog_cil_flush() is called,
> regardless of whether there is already a pending push or not.
>
> Second, if the CIL is empty, we should trigger an iclog flush to
> ensure that the iclogs of the last checkpoint have actually been
> submitted to disk as that checkpoint may not have been run under
> stable completion constraints.
>
> Reported-and-tested-by: Matthew Wilcox <willy@infradead.org>
> Fixes: 0020a190cf3e ("xfs: AIL needs asynchronous CIL forcing")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
> ---

Two questions/suggestions regarding backporting this patch.

DISCLAIMER: I am raising questions/suggestions.
There is no presumption that I know the answers.
The author of the patch is the best authority when it comes to answering
those questions and w.r.t adopting or discarding my suggestions.

1. I think the backport should also be tested with a single CPU VM as
    described above
2. I wonder if it would make sense to backport the 3 "defensive fixes" that
    Dave mentioned in the cover letter [1] along with this fix?

The rationale being that it is not enough to backport the fix itself.
Anything that is required to test the fix reliably should be backported with it
and since this issue involves subtle timing and races (maybe not as much
on a single CPU VM?), the "defensive fixes" that change the timing and
amount of wakeups/pushes may impact the ability to test the fix?

Thanks,
Amir.

[1] https://lore.kernel.org/all/20220317053907.164160-1-david@fromorbit.com/
