Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BC04C43334
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jun 2022 19:15:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241722AbiFMTPJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jun 2022 15:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239904AbiFMTOp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jun 2022 15:14:45 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A643883
        for <linux-xfs@vger.kernel.org>; Mon, 13 Jun 2022 10:31:53 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id cx11so6254261pjb.1
        for <linux-xfs@vger.kernel.org>; Mon, 13 Jun 2022 10:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3rXICGy1AbfttFma9Cy+ibqODFjsnhBOanR1sSG61LE=;
        b=PlPdRxZiuryg3u8oM2JRI8V4AeWzDeqzncuxcGizRdyiNDl0zYOPjwAiz+Gz3MKt/V
         eXtADHA8Vu6DQBN3h5PVjEhYRclM5sdn6NTKsBR5S8qrvRwi+TegpncXRGqJLMjPTa/2
         ACJqILNsMOBolQiXYf8fbscIYN4DJl8rzsz26euDhuWGEI3vBu15isMJQw5VIFenIAGA
         dG3CJHaHPBe/rMxayhkedPFQl6LHWU56KhOkGT+HCzNkcOxJUBsAY3MsEn7up26knSDz
         HC7iouHzSkUtR3eitVx32hd0X3mbhLyWJ/AkpEY4XdWM/vI2V88+SLDtpS3gR2WV3ef+
         8YxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3rXICGy1AbfttFma9Cy+ibqODFjsnhBOanR1sSG61LE=;
        b=X9bII7wmSa5BPRGiiY2scKHcDkS6bQjj1182NDKeEUJqnxpOa/yA609pqyruRC83oW
         VgfPjmGARAv3TpwkY7So4ZH4uwxA7NWhgs+mgGO+cW7JjZ1+9/EiuiQFdZINHVb4hLYc
         8NKpMcLXkj9xOp+lYMh7KC5+miIF3NXU5eysWeQVb9OCLreu5ZiF5rAYSJWoJvddRaZm
         /boJPF0kwhrFYYD/tlfppzbEq+4+QT9Pc4ohch5OnGx7qWE2gpZyxPIwNjeOo1iTfqiH
         FBYnY0iu/rQugZ1LmQlGNAb+M/CzM7r5coLDNkw75DL8vicd3zvpI5B4GUQjfMzoOHfM
         S9iA==
X-Gm-Message-State: AOAM5316EBLIQFFaYCW+7UerUqccDZLOJ/gDASSmH9ghkT5ozKIKl365
        qJtWSm6Oeb2ioOMo1V7Ve9E=
X-Google-Smtp-Source: ABdhPJzS++Tgpf5ZEm2ZeaqX0GQVNESSWV3xZMaQxnQ6c6ODexjsxgpkF0SALHzQRi+IQR21xjzhSQ==
X-Received: by 2002:a17:90b:1e06:b0:1e8:ab5f:d9ef with SMTP id pg6-20020a17090b1e0600b001e8ab5fd9efmr16949732pjb.26.1655141513369;
        Mon, 13 Jun 2022 10:31:53 -0700 (PDT)
Received: from google.com ([2620:0:1001:7810:29d6:a9b3:5732:a478])
        by smtp.gmail.com with ESMTPSA id p3-20020a1709028a8300b00168adae4eb2sm5383380plo.262.2022.06.13.10.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 10:31:52 -0700 (PDT)
Date:   Mon, 13 Jun 2022 10:31:50 -0700
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Dave Chinner <dchinner@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 5.15 12/15] xfs: async CIL flushes need pending pushes to
 be made stable
Message-ID: <Yqd0hk2n9vyp56OA@google.com>
References: <20220603185721.3121645-1-leah.rumancik@gmail.com>
 <20220603185721.3121645-12-leah.rumancik@gmail.com>
 <CAOQ4uxh__DXycqz+6AFZK3JxLw0Bb_xCNv3eAmX-FdTk0miq8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxh__DXycqz+6AFZK3JxLw0Bb_xCNv3eAmX-FdTk0miq8g@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 08, 2022 at 10:43:57AM +0300, Amir Goldstein wrote:
> On Mon, Jun 6, 2022 at 8:12 AM Leah Rumancik <leah.rumancik@gmail.com> wrote:
> >
> > From: Dave Chinner <dchinner@redhat.com>
> >
> > [ Upstream commit 70447e0ad9781f84e60e0990888bd8c84987f44e ]
> >
> > When the AIL tries to flush the CIL, it relies on the CIL push
> > ending up on stable storage without having to wait for and
> > manipulate iclog state directly. However, if there is already a
> > pending CIL push when the AIL tries to flush the CIL, it won't set
> > the cil->xc_push_commit_stable flag and so the CIL push will not
> > actively flush the commit record iclog.
> >
> > generic/530 when run on a single CPU test VM can trigger this fairly
> > reliably. This test exercises unlinked inode recovery, and can
> > result in inodes being pinned in memory by ongoing modifications to
> > the inode cluster buffer to record unlinked list modifications. As a
> > result, the first inode unlinked in a buffer can pin the tail of the
> > log whilst the inode cluster buffer is pinned by the current
> > checkpoint that has been pushed but isn't on stable storage because
> > because the cil->xc_push_commit_stable was not set. This results in
> > the log/AIL effectively deadlocking until something triggers the
> > commit record iclog to be pushed to stable storage (i.e. the
> > periodic log worker calling xfs_log_force()).
> >
> > The fix is two-fold - first we should always set the
> > cil->xc_push_commit_stable when xlog_cil_flush() is called,
> > regardless of whether there is already a pending push or not.
> >
> > Second, if the CIL is empty, we should trigger an iclog flush to
> > ensure that the iclogs of the last checkpoint have actually been
> > submitted to disk as that checkpoint may not have been run under
> > stable completion constraints.
> >
> > Reported-and-tested-by: Matthew Wilcox <willy@infradead.org>
> > Fixes: 0020a190cf3e ("xfs: AIL needs asynchronous CIL forcing")
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
> > ---
> 
> Two questions/suggestions regarding backporting this patch.
> 
> DISCLAIMER: I am raising questions/suggestions.
> There is no presumption that I know the answers.
> The author of the patch is the best authority when it comes to answering
> those questions and w.r.t adopting or discarding my suggestions.
> 
> 1. I think the backport should also be tested with a single CPU VM as
>     described above
> 2. I wonder if it would make sense to backport the 3 "defensive fixes" that
>     Dave mentioned in the cover letter [1] along with this fix?
> 
> The rationale being that it is not enough to backport the fix itself.
> Anything that is required to test the fix reliably should be backported with it
> and since this issue involves subtle timing and races (maybe not as much
> on a single CPU VM?), the "defensive fixes" that change the timing and
> amount of wakeups/pushes may impact the ability to test the fix?
> 
> Thanks,
> Amir.
> 
> [1] https://lore.kernel.org/all/20220317053907.164160-1-david@fromorbit.com/

This patch has been postponed till the second set, but I can certainly
run this test described for the second set and look into the other fixes
from the cover letter. Thanks for pointing that out.

Leah
