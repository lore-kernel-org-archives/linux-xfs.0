Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E8F1C3F6B0
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Aug 2022 17:32:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbiHWRci (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Aug 2022 13:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234337AbiHWRa3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Aug 2022 13:30:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00848101D11
        for <linux-xfs@vger.kernel.org>; Tue, 23 Aug 2022 08:07:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1660AB81CED
        for <linux-xfs@vger.kernel.org>; Tue, 23 Aug 2022 15:07:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1C6C43141;
        Tue, 23 Aug 2022 15:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661267250;
        bh=dwmLrF5yO+exccfmTvCAKQiEvzmc+6CT/+w2ObX22BU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f2Img4qrG4Xt4p/ZAFqHGGpsTN8FQ7UdKlPmTrBYVjQ4k0m9WpBxo1q0bZT+SUuwk
         FVLSOYPzMGUnhR6o1e6GJ+Ggzn3imJYr3TCe+78pq9pMhpkIn5pHTb4WA2JGPMFn4f
         S7nZHKWkfhNevLGVMYxAZ3cSvzXTh2mZiy8J+LzyyKa3VV+oDYiyM+ipWwBTK0Kslo
         +q+yrjd9GL/XkWHpesWWp46kUlCG+xJ3Hd2HnOBZtVF3XpqqWxnWhxABUsaZGqzmgI
         ldrrr7hgcduNEmK72s+BETg3yHkWQdgXeizcp4r3Q+OBQofat9aSeZtlQjortxNkP6
         QL2YdNkqBezkA==
Date:   Tue, 23 Aug 2022 08:07:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Alli <allison.henderson@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH RESEND v2 01/18] xfs: Fix multi-transaction larp replay
Message-ID: <YwTtMqOCtkxyox3x@magnolia>
References: <20220804194013.99237-2-allison.henderson@oracle.com>
 <YvKQ5+XotiXFDpTA@magnolia>
 <20220810015809.GK3600936@dread.disaster.area>
 <373809e97f15e14d181fea6e170bfd8e37a9c9e4.camel@oracle.com>
 <20220810061258.GL3600936@dread.disaster.area>
 <f85ae9d8425aaff455301b28af32ba0d813f733b.camel@oracle.com>
 <20220816005438.GT3600936@dread.disaster.area>
 <YvsmAgj348tlKfCL@magnolia>
 <9acef43634b41baba8711dc47aaa7bd0cf46874d.camel@oracle.com>
 <82cc6ff775832d34f32cdbfe9bd125487ec22226.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82cc6ff775832d34f32cdbfe9bd125487ec22226.camel@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 18, 2022 at 06:05:54PM -0700, Alli wrote:
> On Tue, 2022-08-16 at 13:41 -0700, Alli wrote:
> > On Mon, 2022-08-15 at 22:07 -0700, Darrick J. Wong wrote:
> > > On Tue, Aug 16, 2022 at 10:54:38AM +1000, Dave Chinner wrote:
> > > > On Thu, Aug 11, 2022 at 06:55:16PM -0700, Alli wrote:
> > > > > On Wed, 2022-08-10 at 16:12 +1000, Dave Chinner wrote:
> > > > > > On Tue, Aug 09, 2022 at 10:01:49PM -0700, Alli wrote:
> > > > > > > On Wed, 2022-08-10 at 11:58 +1000, Dave Chinner wrote:
> > > > > > > > On Tue, Aug 09, 2022 at 09:52:55AM -0700, Darrick J. Wong
> > > > > > > > wrote:
> > > > > > > > > On Thu, Aug 04, 2022 at 12:39:56PM -0700, Allison
> > > > > > > > > Henderson
> > > > > > > > > wrote:
> > > > > > > > > > Recent parent pointer testing has exposed a bug in
> > > > > > > > > > the
> > > > > > > > > > underlying
> > > > > > > > > > attr replay.  A multi transaction replay currently
> > > > > > > > > > performs a
> > > > > > > > > > single step of the replay, then deferrs the rest if
> > > > > > > > > > there is
> > > > > > > > > > more
> > > > > > > > > > to do.
> > > > > > > > 
> > > > > > > > Yup.
> > > > > > > > 
> > > > > > > > > > This causes race conditions with other attr replays
> > > > > > > > > > that
> > > > > > > > > > might be recovered before the remaining deferred work
> > > > > > > > > > has had
> > > > > > > > > > a
> > > > > > > > > > chance to finish.
> > > > > > > > 
> > > > > > > > What other attr replays are we racing against?  There can
> > > > > > > > only be
> > > > > > > > one incomplete attr item intent/done chain per inode
> > > > > > > > present in
> > > > > > > > log
> > > > > > > > recovery, right?
> > > > > > > No, a rename queues up a set and remove before committing
> > > > > > > the
> > > > > > > transaction.  One for the new parent pointer, and another
> > > > > > > to
> > > > > > > remove
> > > > > > > the
> > > > > > > old one.
> > > > > > 
> > > > > > Ah. That really needs to be described in the commit message -
> > > > > > changing from "single intent chain per object" to "multiple
> > > > > > concurrent independent and unserialised intent chains per
> > > > > > object" is
> > > > > > a pretty important design rule change...
> > > > > > 
> > > > > > The whole point of intents is to allow complex, multi-stage
> > > > > > operations on a single object to be sequenced in a tightly
> > > > > > controlled manner. They weren't intended to be run as
> > > > > > concurrent
> > > > > > lines of modification on single items; if you need to do two
> > > > > > modifications on an object, the intent chain ties the two
> > > > > > modifications together into a single whole.
> > > > > > 
> > > > > > One of the reasons I rewrote the attr state machine for LARP
> > > > > > was to
> > > > > > enable new multiple attr operation chains to be easily build
> > > > > > from
> > > > > > the entry points the state machien provides. Parent attr
> > > > > > rename
> > > > > > needs a new intent chain to be built, not run multiple
> > > > > > independent
> > > > > > intent chains for each modification.
> > > > > > 
> > > > > > > It cant be an attr replace because technically the names
> > > > > > > are
> > > > > > > different.
> > > > > > 
> > > > > > I disagree - we have all the pieces we need in the state
> > > > > > machine
> > > > > > already, we just need to define separate attr names for the
> > > > > > remove and insert steps in the attr intent.
> > > > > > 
> > > > > > That is, the "replace" operation we execute when an attr set
> > > > > > overwrites the value is "technically" a "replace value"
> > > > > > operation,
> > > > > > but we actually implement it as a "replace entire attribute"
> > > > > > operation.
> > > > > > 
> > > > > > Without LARP, we do that overwrite in independent steps via
> > > > > > an
> > > > > > intermediate INCOMPLETE state to allow two xattrs of the same
> > > > > > name
> > > > > > to exist in the attr tree at the same time. IOWs, the attr
> > > > > > value
> > > > > > overwrite is effectively a "set-swap-remove" operation on two
> > > > > > entirely independent xattrs, ensuring that if we crash we
> > > > > > always
> > > > > > have either the old or new xattr visible.
> > > > > > 
> > > > > > With LARP, we can remove the original attr first, thereby
> > > > > > avoiding
> > > > > > the need for two versions of the xattr to exist in the tree
> > > > > > in
> > > > > > the
> > > > > > first place. However, we have to do these two operations as a
> > > > > > pair
> > > > > > of linked independent operations. The intent chain provides
> > > > > > the
> > > > > > linking, and requires us to log the name and the value of the
> > > > > > attr
> > > > > > that we are overwriting in the intent. Hence we can always
> > > > > > recover
> > > > > > the modification to completion no matter where in the
> > > > > > operation
> > > > > > we
> > > > > > fail.
> > > > > > 
> > > > > > When it comes to a parent attr rename operation, we are
> > > > > > effectively
> > > > > > doing two linked operations - remove the old attr, set the
> > > > > > new
> > > > > > attr
> > > > > > - on different attributes. Implementation wise, it is exactly
> > > > > > the
> > > > > > same sequence as a "replace value" operation, except for the
> > > > > > fact
> > > > > > that the new attr we add has a different name.
> > > > > > 
> > > > > > Hence the only real difference between the existing "attr
> > > > > > replace"
> > > > > > and the intent chain we need for "parent attr rename" is that
> > > > > > we
> > > > > > have to log two attr names instead of one. 
> > > > > 
> > > > > To be clear, this would imply expanding xfs_attri_log_format to
> > > > > have
> > > > > another alfi_new_name_len feild and another iovec for the attr
> > > > > intent
> > > > > right?  Does that cause issues to change the on disk log layout
> > > > > after
> > > > > the original has merged?  Or is that ok for things that are
> > > > > still
> > > > > experimental? Thanks!
> > > > 
> > > > I think we can get away with this quite easily without breaking
> > > > the
> > > > existing experimental code.
> > > > 
> > > > struct xfs_attri_log_format {
> > > >         uint16_t        alfi_type;      /* attri log item type */
> > > >         uint16_t        alfi_size;      /* size of this item */
> > > >         uint32_t        __pad;          /* pad to 64 bit aligned
> > > > */
> > > >         uint64_t        alfi_id;        /* attri identifier */
> > > >         uint64_t        alfi_ino;       /* the inode for this
> > > > attr
> > > > operation */
> > > >         uint32_t        alfi_op_flags;  /* marks the op as a set
> > > > or
> > > > remove */
> > > >         uint32_t        alfi_name_len;  /* attr name length */
> > > >         uint32_t        alfi_value_len; /* attr value length */
> > > >         uint32_t        alfi_attr_filter;/* attr filter flags */
> > > > };
> > > > 
> > > > We have a padding field in there that is currently all zeros.
> > > > Let's
> > > > make that a count of the number of {name, value} tuples that are
> > > > appended to the format. i.e.
> > > > 
> > > > struct xfs_attri_log_name {
> > > >         uint32_t        alfi_op_flags;  /* marks the op as a set
> > > > or
> > > > remove */
> > > >         uint32_t        alfi_name_len;  /* attr name length */
> > > >         uint32_t        alfi_value_len; /* attr value length */
> > > >         uint32_t        alfi_attr_filter;/* attr filter flags */
> > > > };
> > > > 
> > > > struct xfs_attri_log_format {
> > > >         uint16_t        alfi_type;      /* attri log item type */
> > > >         uint16_t        alfi_size;      /* size of this item */
> > > > 	uint8_t		alfi_attr_cnt;	/* count of name/val
> > > > pairs
> > > > */
> > > >         uint8_t		__pad1;          /* pad to 64 bit
> > > > aligned */
> > > >         uint16_t	__pad2;          /* pad to 64 bit aligned */
> > > >         uint64_t        alfi_id;        /* attri identifier */
> > > >         uint64_t        alfi_ino;       /* the inode for this
> > > > attr
> > > > operation */
> > > > 	struct xfs_attri_log_name alfi_attr[]; /* attrs to operate on
> > > > */
> > > > };
> > > > 
> > > > Basically, the size and shape of the structure has not changed,
> > > > and
> > > > if alfi_attr_cnt == 0 we just treat it as if alfi_attr_cnt == 1
> > > > as
> > > > the backwards compat code for the existing code.
> > > > 
> > > > And then we just have as many followup regions for name/val pairs
> > > > as are defined by the alfi_attr_cnt and alfi_attr[] parts of the
> > > > structure. Each attr can have a different operation performed on
> > > > them, and they can have different filters applied so they can
> > > > exist
> > > > in different namespaces, too.
> > > > 
> > > > SO I don't think we need a new on-disk feature bit for this
> > > > enhancement - it definitely comes under the heading of "this
> > > > stuff
> > > > is experimental, this is the sort of early structure revision
> > > > that
> > > > EXPERIMENTAL is supposed to cover....
> > > 
> > > You might even callit "alfi_extra_names" to avoid the "0 means 1"
> > > stuff.
> > > ;)
> > > 
> > > --D
> > 
> > Oh, I just noticed these comments this morning when I sent out the
> > new
> > attri/d patch.  I'll add this changes to v2.  Please let me know if
> > there's anything else you'd like me to change from the v1.  Thx!
> > 
> > Allison
> 
> Ok, so I am part way through coding this up, and I'm getting this
> feeling like this is not going to work out very well due to the size
> checks for the log formats:
> 
> root@garnet:/home/achender/work_area/xfs-linux# git diff
> fs/xfs/libxfs/xfs_log_format.h fs/xfs/xfs_ondisk.h
> diff --git a/fs/xfs/libxfs/xfs_log_format.h
> b/fs/xfs/libxfs/xfs_log_format.h
> index f1ff52ebb982..5a4e700f32fc 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -922,6 +922,13 @@ struct xfs_icreate_log {
>                                          XFS_ATTR_PARENT | \
>                                          XFS_ATTR_INCOMPLETE)
>  
> +struct xfs_attri_log_name {
> +       uint32_t        alfi_op_flags;  /* marks the op as a set or
> remove */
> +       uint32_t        alfi_name_len;  /* attr name length */
> +       uint32_t        alfi_value_len; /* attr value length */
> +       uint32_t        alfi_attr_filter;/* attr filter flags */
> +};
> +
>  /*
>   * This is the structure used to lay out an attr log item in the
>   * log.
> @@ -929,14 +936,12 @@ struct xfs_icreate_log {
>  struct xfs_attri_log_format {
>         uint16_t        alfi_type;      /* attri log item type */
>         uint16_t        alfi_size;      /* size of this item */
> -       uint32_t        __pad;          /* pad to 64 bit aligned */
> +       uint8_t         alfi_extra_names;/* count of name/val pairs */
> +       uint8_t         __pad1;         /* pad to 64 bit aligned */
> +       uint16_t        __pad2;         /* pad to 64 bit aligned */
>         uint64_t        alfi_id;        /* attri identifier */
>         uint64_t        alfi_ino;       /* the inode for this attr
> operation */
> -       uint32_t        alfi_op_flags;  /* marks the op as a set or
> remove */
> -       uint32_t        alfi_name_len;  /* attr name length */
> -       uint32_t        alfi_value_len; /* attr value length */
> -       uint32_t        alfi_attr_filter;/* attr filter flags */
> +       struct xfs_attri_log_name alfi_attr[]; /* attrs to operate on

What's the length of this VLA?  1 for a normal SET or REPLACE
operation, and 2 for the "rename and replace value" operation?

If so, why do we need two xfs_attri_log_name structures?  The old value
is unimportant, so we only need one alfi_value_len per operation.  Each
xfs_attri_log_format only describes one change, so it only needs one
alfi_op_flags per op.

For now I also don't think attributes should be able to jump namespaces,
so we'd only need one alfi_attr_filter per op as well.

*lightbulb comes on*  Oops, I think I led you astray with my unfortunate
comment. :(

IOWs, the only change to struct xfs_attri_log_format is:

-       uint32_t        __pad;          /* pad to 64 bit aligned */
+       uint32_t        alfi_new_namelen;/* new attr name length */

and the rest of the changes in "[PATCH] xfs: Add new name to attri/d"
are more or less fine as is.

I'll go reply to that before I get back to Dave's log accounting stuff.

--D

> */
>  };
>  
>  struct xfs_attrd_log_format {
> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> index 3e7f7eaa5b96..c040eeb88def 100644
> --- a/fs/xfs/xfs_ondisk.h
> +++ b/fs/xfs/xfs_ondisk.h
> @@ -132,7 +132,7 @@ xfs_check_ondisk_structs(void)
>         XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format,      56);
>         XFS_CHECK_STRUCT_SIZE(struct xfs_qoff_logformat,        20);
>         XFS_CHECK_STRUCT_SIZE(struct xfs_trans_header,          16);
> -       XFS_CHECK_STRUCT_SIZE(struct xfs_attri_log_format,      48);
> +       XFS_CHECK_STRUCT_SIZE(struct xfs_attri_log_format,      24);
>         XFS_CHECK_STRUCT_SIZE(struct xfs_attrd_log_format,      16);
>  
>         /* parent pointer ioctls */
> root@garnet:/home/achender/work_area/xfs-linux# 
> 
> 
> 
> If the on disk size check thinks the format is 24 bytes, and then we
> surprise pack an array of structs after it, isnt that going to run over
> the next item?  I think anything dynamic like this has to be an nvec.
>  Maybe we leave the existing alfi_* as they are so the size doesnt
> change, and then if we have a value in alfi_extra_names, then we have
> an extra nvec that has the array in it.  I think that would work.
> 
> FWIW, an alternate solution would be to use the pad for a second name
> length, and then we get a patch that's very similar to the one I sent
> out last Tues, but backward compatible.  Though it does eat the
> remaining pad and wouldn't be as flexible, I cant think of an attr op
> that would need more than two names either?
> 
> Let me know what people think.  Thanks!
> Allison
> 
> 
> > > > Cheers,
> > > > 
> > > > Dave.
> > > > -- 
> > > > Dave Chinner
> > > > david@fromorbit.com
> 
