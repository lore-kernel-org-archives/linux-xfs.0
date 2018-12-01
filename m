Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f196.google.com ([209.85.219.196]:39304 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbeLAVAK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Dec 2018 16:00:10 -0500
MIME-Version: 1.0
References: <20181130192047.GO8125@magnolia>
In-Reply-To: <20181130192047.GO8125@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 1 Dec 2018 11:47:50 +0200
Message-ID: <CAOQ4uxhv7vOaCRK9FojG5zm=cKtobBvPmVOdWS+3GE53OoX+9A@mail.gmail.com>
Subject: Re: [RFC PATCH] splice: don't read more than available pipe space
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, jencce.kernel@gmail.com, linux-xfs <linux-xfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Zorro Lang <zlang@redhat.com>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Fri, Nov 30, 2018 at 9:20 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> In commit 4721a601099, we tried to fix a problem wherein directio reads
> into a splice pipe will bounce EFAULT/EAGAIN all the way out to
> userspace by simulating a zero-byte short read.  This happens because
> some directio read implementations (xfs) will call
> bio_iov_iter_get_pages to grab pipe buffer pages and issue asynchronous
> reads, but as soon as we run out of pipe buffers that _get_pages call
> returns EFAULT, which the splice code translates to EAGAIN and bounces
> out to userspace.
>
> In that commit, the iomap code catches the EFAULT and simulates a
> zero-byte read, but that causes assertion errors on regular splice reads
> because xfs doesn't allow short directio reads.
>
> The brokenness is compounded by splice_direct_to_actor immediately
> bailing on do_splice_to returning <= 0 without ever calling ->actor
> (which empties out the pipe), so if userspace calls back we'll EFAULT
> again on the full pipe, and nothing ever gets copied.
>
> Therefore, teach splice_direct_to_actor to clamp its requests to the
> amount of free space in the pipe and remove the simulated short read
> from the iomap directio code.
>
> Fixes: 4721a601099 ("iomap: dio data corruption and spurious errors when pipes fill")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Problem is the regressing commit does two things and you here revert one
of them and re-fix the bug.

IMO, it would be nicer to:
- Revert the regression commit
- Attribute Reported-by and specify regression details in revert commit
- Re-apply Dave's zero_tail fix with its own commit instead of a
  "To make matters worse..." clause.
- Apply your re-fix with description of original problem and without the
  story about the regression

Your call.

Miklos,

Can you please review the suggested re-fix?

Thanks,
Amir.
