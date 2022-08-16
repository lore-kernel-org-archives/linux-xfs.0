Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEDFDC2BB41
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Aug 2022 07:55:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbiHPHzR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Aug 2022 03:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiHPHy7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Aug 2022 03:54:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26917194E6E
        for <linux-xfs@vger.kernel.org>; Mon, 15 Aug 2022 22:07:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2896B815B8
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 05:07:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 740A7C433C1;
        Tue, 16 Aug 2022 05:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660626435;
        bh=/RaQxLqu+Q88VDaqbwLIlSxBSMDdQ0XlzpSozqa/uu4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FdKHLYjvS+bZHF4yM87Evp29AOuvDdTDM0GLa24d52Iz2ziSUr0eLjy0krI2jSTvL
         PQ/rmNF7OJAU1vToRxLX835uXCIHpI54neKDROW4V1JTdMAbDAUwO8YC4FdeTKzVmO
         XXZy+7dftob7xWcztm9lYvI9g3POSqRSWti32/glK7ixCZj8y0uJrpm678L8ze9UWo
         JfpnY6BidigjIkfjXCB2CI0GVj338Srgd4o6Vn+ln1CM+pzAs2iF+3AAtgKeATlfaW
         1dkntD76P4xr3ANPXK6LuPG3t/YvSNbY63KjeHOqsAUNT9VYPd4jGQxxMAo2VT4AIc
         dNi09+hSs1oQg==
Date:   Mon, 15 Aug 2022 22:07:14 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Alli <allison.henderson@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH RESEND v2 01/18] xfs: Fix multi-transaction larp replay
Message-ID: <YvsmAgj348tlKfCL@magnolia>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
 <20220804194013.99237-2-allison.henderson@oracle.com>
 <YvKQ5+XotiXFDpTA@magnolia>
 <20220810015809.GK3600936@dread.disaster.area>
 <373809e97f15e14d181fea6e170bfd8e37a9c9e4.camel@oracle.com>
 <20220810061258.GL3600936@dread.disaster.area>
 <f85ae9d8425aaff455301b28af32ba0d813f733b.camel@oracle.com>
 <20220816005438.GT3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816005438.GT3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 16, 2022 at 10:54:38AM +1000, Dave Chinner wrote:
> On Thu, Aug 11, 2022 at 06:55:16PM -0700, Alli wrote:
> > On Wed, 2022-08-10 at 16:12 +1000, Dave Chinner wrote:
> > > On Tue, Aug 09, 2022 at 10:01:49PM -0700, Alli wrote:
> > > > On Wed, 2022-08-10 at 11:58 +1000, Dave Chinner wrote:
> > > > > On Tue, Aug 09, 2022 at 09:52:55AM -0700, Darrick J. Wong wrote:
> > > > > > On Thu, Aug 04, 2022 at 12:39:56PM -0700, Allison Henderson
> > > > > > wrote:
> > > > > > > Recent parent pointer testing has exposed a bug in the
> > > > > > > underlying
> > > > > > > attr replay.  A multi transaction replay currently performs a
> > > > > > > single step of the replay, then deferrs the rest if there is
> > > > > > > more
> > > > > > > to do.
> > > > > 
> > > > > Yup.
> > > > > 
> > > > > > > This causes race conditions with other attr replays that
> > > > > > > might be recovered before the remaining deferred work has had
> > > > > > > a
> > > > > > > chance to finish.
> > > > > 
> > > > > What other attr replays are we racing against?  There can only be
> > > > > one incomplete attr item intent/done chain per inode present in
> > > > > log
> > > > > recovery, right?
> > > > No, a rename queues up a set and remove before committing the
> > > > transaction.  One for the new parent pointer, and another to remove
> > > > the
> > > > old one.
> > > 
> > > Ah. That really needs to be described in the commit message -
> > > changing from "single intent chain per object" to "multiple
> > > concurrent independent and unserialised intent chains per object" is
> > > a pretty important design rule change...
> > > 
> > > The whole point of intents is to allow complex, multi-stage
> > > operations on a single object to be sequenced in a tightly
> > > controlled manner. They weren't intended to be run as concurrent
> > > lines of modification on single items; if you need to do two
> > > modifications on an object, the intent chain ties the two
> > > modifications together into a single whole.
> > > 
> > > One of the reasons I rewrote the attr state machine for LARP was to
> > > enable new multiple attr operation chains to be easily build from
> > > the entry points the state machien provides. Parent attr rename
> > > needs a new intent chain to be built, not run multiple independent
> > > intent chains for each modification.
> > > 
> > > > It cant be an attr replace because technically the names are
> > > > different.
> > > 
> > > I disagree - we have all the pieces we need in the state machine
> > > already, we just need to define separate attr names for the
> > > remove and insert steps in the attr intent.
> > > 
> > > That is, the "replace" operation we execute when an attr set
> > > overwrites the value is "technically" a "replace value" operation,
> > > but we actually implement it as a "replace entire attribute"
> > > operation.
> > > 
> > > Without LARP, we do that overwrite in independent steps via an
> > > intermediate INCOMPLETE state to allow two xattrs of the same name
> > > to exist in the attr tree at the same time. IOWs, the attr value
> > > overwrite is effectively a "set-swap-remove" operation on two
> > > entirely independent xattrs, ensuring that if we crash we always
> > > have either the old or new xattr visible.
> > > 
> > > With LARP, we can remove the original attr first, thereby avoiding
> > > the need for two versions of the xattr to exist in the tree in the
> > > first place. However, we have to do these two operations as a pair
> > > of linked independent operations. The intent chain provides the
> > > linking, and requires us to log the name and the value of the attr
> > > that we are overwriting in the intent. Hence we can always recover
> > > the modification to completion no matter where in the operation we
> > > fail.
> > > 
> > > When it comes to a parent attr rename operation, we are effectively
> > > doing two linked operations - remove the old attr, set the new attr
> > > - on different attributes. Implementation wise, it is exactly the
> > > same sequence as a "replace value" operation, except for the fact
> > > that the new attr we add has a different name.
> > > 
> > > Hence the only real difference between the existing "attr replace"
> > > and the intent chain we need for "parent attr rename" is that we
> > > have to log two attr names instead of one. 
> > 
> > To be clear, this would imply expanding xfs_attri_log_format to have
> > another alfi_new_name_len feild and another iovec for the attr intent
> > right?  Does that cause issues to change the on disk log layout after
> > the original has merged?  Or is that ok for things that are still
> > experimental? Thanks!
> 
> I think we can get away with this quite easily without breaking the
> existing experimental code.
> 
> struct xfs_attri_log_format {
>         uint16_t        alfi_type;      /* attri log item type */
>         uint16_t        alfi_size;      /* size of this item */
>         uint32_t        __pad;          /* pad to 64 bit aligned */
>         uint64_t        alfi_id;        /* attri identifier */
>         uint64_t        alfi_ino;       /* the inode for this attr operation */
>         uint32_t        alfi_op_flags;  /* marks the op as a set or remove */
>         uint32_t        alfi_name_len;  /* attr name length */
>         uint32_t        alfi_value_len; /* attr value length */
>         uint32_t        alfi_attr_filter;/* attr filter flags */
> };
> 
> We have a padding field in there that is currently all zeros. Let's
> make that a count of the number of {name, value} tuples that are
> appended to the format. i.e.
> 
> struct xfs_attri_log_name {
>         uint32_t        alfi_op_flags;  /* marks the op as a set or remove */
>         uint32_t        alfi_name_len;  /* attr name length */
>         uint32_t        alfi_value_len; /* attr value length */
>         uint32_t        alfi_attr_filter;/* attr filter flags */
> };
> 
> struct xfs_attri_log_format {
>         uint16_t        alfi_type;      /* attri log item type */
>         uint16_t        alfi_size;      /* size of this item */
> 	uint8_t		alfi_attr_cnt;	/* count of name/val pairs */
>         uint8_t		__pad1;          /* pad to 64 bit aligned */
>         uint16_t	__pad2;          /* pad to 64 bit aligned */
>         uint64_t        alfi_id;        /* attri identifier */
>         uint64_t        alfi_ino;       /* the inode for this attr operation */
> 	struct xfs_attri_log_name alfi_attr[]; /* attrs to operate on */
> };
> 
> Basically, the size and shape of the structure has not changed, and
> if alfi_attr_cnt == 0 we just treat it as if alfi_attr_cnt == 1 as
> the backwards compat code for the existing code.
> 
> And then we just have as many followup regions for name/val pairs
> as are defined by the alfi_attr_cnt and alfi_attr[] parts of the
> structure. Each attr can have a different operation performed on
> them, and they can have different filters applied so they can exist
> in different namespaces, too.
> 
> SO I don't think we need a new on-disk feature bit for this
> enhancement - it definitely comes under the heading of "this stuff
> is experimental, this is the sort of early structure revision that
> EXPERIMENTAL is supposed to cover....

You might even callit "alfi_extra_names" to avoid the "0 means 1" stuff.
;)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
