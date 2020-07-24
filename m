Return-Path: <SRS0=Yx8G=BD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89F74C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 02:24:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 701DE20737
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 02:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgGXCYm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jul 2020 22:24:42 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:48925 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726349AbgGXCYm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jul 2020 22:24:42 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 58506365EF6;
        Fri, 24 Jul 2020 12:24:38 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jynO0-0002Jx-Vd; Fri, 24 Jul 2020 12:24:36 +1000
Date:   Fri, 24 Jul 2020 12:24:36 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Allison Collins <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v11 01/25] xfs: Add xfs_has_attr and subroutines
Message-ID: <20200724022436.GM2005@dread.disaster.area>
References: <20200721001606.10781-1-allison.henderson@oracle.com>
 <20200721001606.10781-2-allison.henderson@oracle.com>
 <20200721232613.GZ7625@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721232613.GZ7625@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QKgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=yPCof4ZbAAAA:8 a=pGLkceISAAAA:8
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=fevoeIvK2UQPpZgo0hEA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 21, 2020 at 04:26:13PM -0700, Darrick J. Wong wrote:
> On Mon, Jul 20, 2020 at 05:15:42PM -0700, Allison Collins wrote:
> > This patch adds a new functions to check for the existence of an
> > attribute. Subroutines are also added to handle the cases of leaf
> > blocks, nodes or shortform. Common code that appears in existing attr
> > add and remove functions have been factored out to help reduce the
> > appearance of duplicated code.  We will need these routines later for
> > delayed attributes since delayed operations cannot return error codes.
> > 
> > Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> > Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> Looks good enough for now... I still dislike generating ENOATTR/EEXIST
> deep in the folds of the attr code but that's probably a bigger thing to
> be wrangled with later.  (And tbh I've thought about this & haven't come
> up with a better idea anyway :P)

Yes, I agree it is hard to read, but I do think there's a cleaner
way of doing this. Take, for example, xfs_attr_leaf_try_add(). It
looks like this:

        /*
         * Look up the given attribute in the leaf block.  Figure out if
         * the given flags produce an error or call for an atomic rename.
         */
        retval = xfs_attr_leaf_hasname(args, &bp);
        if (retval != -ENOATTR && retval != -EEXIST)
                return retval;
        if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
                goto out_brelse;
        if (retval == -EEXIST) {
                if (args->attr_flags & XATTR_CREATE)
                        goto out_brelse;

                trace_xfs_attr_leaf_replace(args);

                /* save the attribute state for later removal*/
                args->op_flags |= XFS_DA_OP_RENAME;     /* an atomic rename */
                xfs_attr_save_rmt_blk(args);

                /*
                 * clear the remote attr state now that it is saved so that the
                 * values reflect the state of the attribute we are about to
                 * add, not the attribute we just found and will remove later.
                 */
                args->rmtblkno = 0;
                args->rmtblkcnt = 0;
                args->rmtvaluelen = 0;
        }

        /*
         * Add the attribute to the leaf block
         */
        return xfs_attr3_leaf_add(bp, args);

out_brelse:
        xfs_trans_brelse(args->trans, bp);
        return retval;
}


I agree, the error handling is messy and really hard to follow.
But if we write it like this:

        /*
         * Look up the given attribute in the leaf block.  Figure out if
         * the given flags produce an error or call for an atomic rename.
         */
        retval = xfs_attr_leaf_hasname(args, &bp);
        switch (retval) {
        case -ENOATTR:
                if (args->attr_flags & XATTR_REPLACE)
                        goto out_brelse;
                break;
        case -EEXIST:
                if (args->attr_flags & XATTR_CREATE)
                        goto out_brelse;

                trace_xfs_attr_leaf_replace(args);

                /* save the attribute state for later removal*/
                args->op_flags |= XFS_DA_OP_RENAME;     /* an atomic rename */
                xfs_attr_save_rmt_blk(args);

                /*
                 * clear the remote attr state now that it is saved so that the
                 * values reflect the state of the attribute we are about to
                 * add, not the attribute we just found and will remove later.
                 */
                args->rmtblkno = 0;
                args->rmtblkcnt = 0;
                args->rmtvaluelen = 0;
                break;
	case 0:
		break;
        default:
                return retval;
        }

        /*
         * Add the attribute to the leaf block
         */
        return xfs_attr3_leaf_add(bp, args);

out_brelse:
        xfs_trans_brelse(args->trans, bp);
        return retval;
}

The logic is *much* cleaner and it is not overly verbose, either.
This sort of change could be done at the end of the series, too,
rather than requiring a rebase of everything....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
