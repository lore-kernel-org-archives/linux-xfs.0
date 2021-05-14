Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E309C433ED
	for <linux-xfs@archiver.kernel.org>; Fri, 14 May 2021 00:41:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 055CB611C9
	for <linux-xfs@archiver.kernel.org>; Fri, 14 May 2021 00:41:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbhENAmt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 May 2021 20:42:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:39106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231159AbhENAmt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 May 2021 20:42:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAD7E613C8;
        Fri, 14 May 2021 00:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620952899;
        bh=udewhTnaIuUZ+TetL5ddwxLFKnQSZ4GSw0lRJM5JVDU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pZXEpoz8p2hPwZtDiYE3P+bncFp5Ze3+i01mouMSDVX8+CS+ZFAdaa3eHgwQZ3jKh
         /HpyYu8ekPN+kH+DBWM055VLuYsi9qXJLrE3fp5QCBH63JLmSciMShPWZBXWB8OOI8
         MbCu3UiHFo1ULf12jxElG9rpLpOpxQJ8/wLyUXwbqBRMAeVyteN6JbOIAdLbNDAD7l
         rRdWMuXB38eKn44JZkvJutTJlsaXPmkFDXpemGX/MUxuE+3iV36jKEVvsVIpfr+9M0
         JVd93204x3Mo/ZHRbd6B9lCln1bH8EJlHVRFbJgk1y3KA12kW1ETR2nHnt4OF3Bjdi
         sQca9jSq50HAg==
Date:   Thu, 13 May 2021 17:41:37 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RESEND v18 05/11] xfs: Separate xfs_attr_node_addname and
 xfs_attr_node_addname_clear_incomplete
Message-ID: <20210514004137.GF9675@magnolia>
References: <20210512161408.5516-1-allison.henderson@oracle.com>
 <20210512161408.5516-6-allison.henderson@oracle.com>
 <20210513234913.GE9675@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210513234913.GE9675@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 13, 2021 at 04:49:13PM -0700, Darrick J. Wong wrote:
> On Wed, May 12, 2021 at 09:14:02AM -0700, Allison Henderson wrote:
> > This patch separate xfs_attr_node_addname into two functions.  This will
> > help to make it easier to hoist parts of xfs_attr_node_addname that need
> > state management
> > 
> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> 
> Makes sense...
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> --D
> 
> > ---
> >  fs/xfs/libxfs/xfs_attr.c | 23 +++++++++++++++++++++++
> >  1 file changed, 23 insertions(+)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index 1a618a2..5cf2e71 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -54,6 +54,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
> >  STATIC int xfs_attr_node_get(xfs_da_args_t *args);
> >  STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
> >  STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
> > +STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
> >  STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
> >  				 struct xfs_da_state **state);
> >  STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
> > @@ -1073,6 +1074,28 @@ xfs_attr_node_addname(
> >  			return error;
> >  	}
> >  
> > +	error = xfs_attr_node_addname_clear_incomplete(args);
> > +	if (error)
> > +		goto out;
> > +	retval = 0;
> > +out:
> > +	if (state)
> > +		xfs_da_state_free(state);
> > +	if (error)
> > +		return error;
> > +	return retval;
> > +}
> > +
> > +
> > +STATIC
> > +int xfs_attr_node_addname_clear_incomplete(

...well, so long as this gets changed to:

STATIC int
xfs_attr_node_addname_clear_incomplete

--D

> > +	struct xfs_da_args		*args)
> > +{
> > +	struct xfs_da_state		*state = NULL;
> > +	struct xfs_da_state_blk		*blk;
> > +	int				retval = 0;
> > +	int				error = 0;
> > +
> >  	/*
> >  	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
> >  	 * flag means that we will find the "old" attr, not the "new" one.
> > -- 
> > 2.7.4
> > 
