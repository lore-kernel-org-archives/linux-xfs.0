Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46163ECAAA1
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Sep 2022 05:00:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiILFAz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Sep 2022 01:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiILFAy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Sep 2022 01:00:54 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0CFEE222B8
        for <linux-xfs@vger.kernel.org>; Sun, 11 Sep 2022 22:00:51 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-149-49.pa.vic.optusnet.com.au [49.186.149.49])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id F2B2662DF17;
        Mon, 12 Sep 2022 15:00:49 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oXbYu-006iyH-6Y; Mon, 12 Sep 2022 15:00:48 +1000
Date:   Mon, 12 Sep 2022 15:00:48 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Stephen Zhang <starzhangzsd@gmail.com>
Cc:     djwong@kernel.org, dchinner@redhat.com, chandan.babu@oracle.com,
        zhangshida@kylinos.cn, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix up the comment in xfs_dir2_isleaf
Message-ID: <20220912050048.GC3600936@dread.disaster.area>
References: <20220911033137.4010427-1-zhangshida@kylinos.cn>
 <20220911222024.GY3600936@dread.disaster.area>
 <CANubcdUrZQTQnokcb8FUm31sgUToriaS1uNVXNYvNyeZ+ZUHkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANubcdUrZQTQnokcb8FUm31sgUToriaS1uNVXNYvNyeZ+ZUHkA@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=631ebd03
        a=XTRC1Ovx3SkpaCW1YxGVGA==:117 a=XTRC1Ovx3SkpaCW1YxGVGA==:17
        a=IkcTkHD0fZMA:10 a=xOM3xZuef0cA:10 a=7-415B0cAAAA:8
        a=XKeJ_9J_KWCVfxwrrIMA:9 a=QEXdDO2ut3YA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 12, 2022 at 11:14:51AM +0800, Stephen Zhang wrote:
> Dave Chinner <david@fromorbit.com> 于2022年9月12日周一 06:20写道：
> >
> > The "*vp" parameter should be a "bool *isleaf", in which case the
> > return value is obvious and the comment can be removed. Then the
> > logic in the function can be cleaned up to be obvious instead of
> > relying on easy to mistake conditional logic in assignemnts...
> 
> Thanks for the suggestion.In order to make sure we are at the same page,
> so this change will be shown like:

That's not what I was thinking. Cleanup involves converting
everything over to standard formatting and conventions. It also
means rethinking the logic to make the code more correct, easier to
read and understand, and so involves more than just changing the
name of a variable.

> ====
>  xfs_dir2_isblock(
>         struct xfs_da_args      *args,
> -       int                     *vp)    /* out: 1 is block, 0 is not block */
> +       bool                    *isblock)
>  {
>         xfs_fileoff_t           last;   /* last file offset */
>         int                     rval;
> 
>         if ((rval = xfs_bmap_last_offset(args->dp, &last, XFS_DATA_FORK)))
>                 return rval;

We don't put assingments in if statements anymore, so this needs to
be rewritten in the form:

	error = foo();
	if (error) {
		....
		return error;
	}

> -       rval = XFS_FSB_TO_B(args->dp->i_mount, last) == args->geo->blksize;
> +       *isblock = XFS_FSB_TO_B(args->dp->i_mount, last) == args->geo->blksize;

Similarly, we don't elide if() statements in this way anymore,
because it's easy to mistake this code as a multiple assignment
rather than a combination of assignment and logic. if() is much
clearer.

>         if (XFS_IS_CORRUPT(args->dp->i_mount,
> -                          rval != 0 &&
> +                          *isblock &&
>                            args->dp->i_disk_size != args->geo->blksize))
>                 return -EFSCORRUPTED;

And this only ever evaluates as true if *isblock is true, so why
run this logic check when *isblock is false?

IOWs, we can rearrange the logic so that it's made up of simple,
individual single comparisons that are obviously self documenting:

int
xfs_dir2_isblock(
	struct xfs_da_args	*args,
	bool			*isblock)
{
	struct xfs_mount	*mp = args->dp->i_mount;
	xfs_fileoff_t		eof;
	int			error;

	error = xfs_bmap_last_offset(args->dp, &eof, XFS_DATA_FORK);
	if (error)
		return error;

	*isblock = false;
	if (XFS_FSB_TO_B(mp, eof) != args->geo->blksize)
		return 0;

	*isblock = true;
	if (XFS_IS_CORRUPT(mp, args->dp->i_disk_size != args->geo->blksize))
		return -EFSCORRUPTED;
	return 0;
}


-- 
Dave Chinner
david@fromorbit.com
