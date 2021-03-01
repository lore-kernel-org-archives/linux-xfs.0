Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC02BC4332D
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Mar 2021 20:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B54D664DDF
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Mar 2021 20:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242653AbhCAUMM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Mar 2021 15:12:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:39928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237956AbhCAUJv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Mar 2021 15:09:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9666653B0;
        Mon,  1 Mar 2021 18:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614621600;
        bh=lcBTqgk+O3Tr7+m9UeWmknNnVCLw+K5guW2TzXUN7AQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G1pQmxPVroOZhDJlDIOPCLgUkjb1dHkwO7XMsDxtmUA6cRKehhOlWyrGyfG04ApAE
         un+U0LEBg+iHnuNooyspi584vUN1SVo7RJee15+c4H7qmAB9yd5nprvpy9sjbsvZ+c
         c58cT1dIJ38jE/Jx1pRhg0dIUOdoqfb6Mx+rA/lu5yjLJOGibhmox7peEqbUTR75jt
         KJlmGnnMhN01Qca6peSFfQsAEOUGdtOc/D9RtuDG1yhoAu3tWYVgjeStDnjWkT8ehH
         k9wnN0oHWHL66EwVV5ReADH6eQPnH+IbzlCALwi61/xxS67xcByB/V7C4IZlWOCVwX
         po9uXCa1+yoWA==
Date:   Mon, 1 Mar 2021 10:00:00 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v15 06/22] xfs: Separate xfs_attr_node_addname and
 xfs_attr_node_addname_work
Message-ID: <20210301180000.GG7272@magnolia>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-7-allison.henderson@oracle.com>
 <20210226040201.GT7272@magnolia>
 <affae494-e7dd-4c27-aade-e640a731b096@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <affae494-e7dd-4c27-aade-e640a731b096@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 26, 2021 at 05:54:51PM -0700, Allison Henderson wrote:
> 
> 
> On 2/25/21 9:02 PM, Darrick J. Wong wrote:
> > On Thu, Feb 18, 2021 at 09:53:32AM -0700, Allison Henderson wrote:
> > > This patch separate xfs_attr_node_addname into two functions.  This will
> > > help to make it easier to hoist parts of xfs_attr_node_addname that need
> > > state management
> > > 
> > > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > > ---
> > >   fs/xfs/libxfs/xfs_attr.c | 20 ++++++++++++++++++++
> > >   1 file changed, 20 insertions(+)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > > index 205ad26..bee8d3fb 100644
> > > --- a/fs/xfs/libxfs/xfs_attr.c
> > > +++ b/fs/xfs/libxfs/xfs_attr.c
> > > @@ -54,6 +54,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
> > >   STATIC int xfs_attr_node_get(xfs_da_args_t *args);
> > >   STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
> > >   STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
> > > +STATIC int xfs_attr_node_addname_work(struct xfs_da_args *args);
> > >   STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
> > >   				 struct xfs_da_state **state);
> > >   STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
> > > @@ -1059,6 +1060,25 @@ xfs_attr_node_addname(
> > >   			return error;
> > >   	}
> > > +	error = xfs_attr_node_addname_work(args);
> > > +out:
> > > +	if (state)
> > > +		xfs_da_state_free(state);
> > > +	if (error)
> > > +		return error;
> > > +	return retval;
> > > +}
> > > +
> > > +
> > > +STATIC
> > > +int xfs_attr_node_addname_work(
> > 
> > What, erm, work does this function do?  Since it survives to the end of
> > the patchset, I think this needs a better name (or at least needs a
> > comment about what it's actually supposed to do).
> To directly answer the question: it's here to help xfs_attr_set_iter not be
> any bigger than it has to. I think we likely struggled with the name because
> it's almost like it's just the "remainder" of the operation that doesnt need
> state management
> 
> > 
> > AFAICT you're splitting node_addname() into two functions because we're
> > at a transaction roll point, and this "_work" function exists to remove
> > the copy of the xattr key that has the "INCOMPLETE" bit set (aka the old
> > one), right?
> Thats about right. Maybe just a quick comment?
> /*
>  * Removes the old xattr key marked with the INCOMPLETE bit
>  */
> 
> I suppose we could consider something like
> "xfs_attr_node_addname_remv_incomplete"?  Or xfs_attr_node_addname_cleanup?
> Trying to cram it into the name maybe getting a bit wordy too.

xfs_attr_node_addname_clear_incomplete?

--D

> 
> Allison
> > 
> > --D
> > 
> > > +	struct xfs_da_args		*args)
> > > +{
> > > +	struct xfs_da_state		*state = NULL;
> > > +	struct xfs_da_state_blk		*blk;
> > > +	int				retval = 0;
> > > +	int				error = 0;
> > > +
> > >   	/*
> > >   	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
> > >   	 * flag means that we will find the "old" attr, not the "new" one.
> > > -- 
> > > 2.7.4
> > > 
