Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3190C25B0D
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Aug 2022 04:22:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiHPEWD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Aug 2022 00:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiHPEVt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Aug 2022 00:21:49 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BD395379043
        for <linux-xfs@vger.kernel.org>; Mon, 15 Aug 2022 17:54:43 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-52-176.pa.nsw.optusnet.com.au [49.181.52.176])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 494B410E89FD;
        Tue, 16 Aug 2022 10:54:39 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oNkqs-00DbbZ-JN; Tue, 16 Aug 2022 10:54:38 +1000
Date:   Tue, 16 Aug 2022 10:54:38 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Alli <allison.henderson@oracle.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH RESEND v2 01/18] xfs: Fix multi-transaction larp replay
Message-ID: <20220816005438.GT3600936@dread.disaster.area>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
 <20220804194013.99237-2-allison.henderson@oracle.com>
 <YvKQ5+XotiXFDpTA@magnolia>
 <20220810015809.GK3600936@dread.disaster.area>
 <373809e97f15e14d181fea6e170bfd8e37a9c9e4.camel@oracle.com>
 <20220810061258.GL3600936@dread.disaster.area>
 <f85ae9d8425aaff455301b28af32ba0d813f733b.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f85ae9d8425aaff455301b28af32ba0d813f733b.camel@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62faead0
        a=O3n/kZ8kT9QBBO3sWHYIyw==:117 a=O3n/kZ8kT9QBBO3sWHYIyw==:17
        a=kj9zAlcOel0A:10 a=biHskzXt2R4A:10 a=7-415B0cAAAA:8
        a=SPW_LBvYJik8ORvYUScA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 11, 2022 at 06:55:16PM -0700, Alli wrote:
> On Wed, 2022-08-10 at 16:12 +1000, Dave Chinner wrote:
> > On Tue, Aug 09, 2022 at 10:01:49PM -0700, Alli wrote:
> > > On Wed, 2022-08-10 at 11:58 +1000, Dave Chinner wrote:
> > > > On Tue, Aug 09, 2022 at 09:52:55AM -0700, Darrick J. Wong wrote:
> > > > > On Thu, Aug 04, 2022 at 12:39:56PM -0700, Allison Henderson
> > > > > wrote:
> > > > > > Recent parent pointer testing has exposed a bug in the
> > > > > > underlying
> > > > > > attr replay.  A multi transaction replay currently performs a
> > > > > > single step of the replay, then deferrs the rest if there is
> > > > > > more
> > > > > > to do.
> > > > 
> > > > Yup.
> > > > 
> > > > > > This causes race conditions with other attr replays that
> > > > > > might be recovered before the remaining deferred work has had
> > > > > > a
> > > > > > chance to finish.
> > > > 
> > > > What other attr replays are we racing against?  There can only be
> > > > one incomplete attr item intent/done chain per inode present in
> > > > log
> > > > recovery, right?
> > > No, a rename queues up a set and remove before committing the
> > > transaction.  One for the new parent pointer, and another to remove
> > > the
> > > old one.
> > 
> > Ah. That really needs to be described in the commit message -
> > changing from "single intent chain per object" to "multiple
> > concurrent independent and unserialised intent chains per object" is
> > a pretty important design rule change...
> > 
> > The whole point of intents is to allow complex, multi-stage
> > operations on a single object to be sequenced in a tightly
> > controlled manner. They weren't intended to be run as concurrent
> > lines of modification on single items; if you need to do two
> > modifications on an object, the intent chain ties the two
> > modifications together into a single whole.
> > 
> > One of the reasons I rewrote the attr state machine for LARP was to
> > enable new multiple attr operation chains to be easily build from
> > the entry points the state machien provides. Parent attr rename
> > needs a new intent chain to be built, not run multiple independent
> > intent chains for each modification.
> > 
> > > It cant be an attr replace because technically the names are
> > > different.
> > 
> > I disagree - we have all the pieces we need in the state machine
> > already, we just need to define separate attr names for the
> > remove and insert steps in the attr intent.
> > 
> > That is, the "replace" operation we execute when an attr set
> > overwrites the value is "technically" a "replace value" operation,
> > but we actually implement it as a "replace entire attribute"
> > operation.
> > 
> > Without LARP, we do that overwrite in independent steps via an
> > intermediate INCOMPLETE state to allow two xattrs of the same name
> > to exist in the attr tree at the same time. IOWs, the attr value
> > overwrite is effectively a "set-swap-remove" operation on two
> > entirely independent xattrs, ensuring that if we crash we always
> > have either the old or new xattr visible.
> > 
> > With LARP, we can remove the original attr first, thereby avoiding
> > the need for two versions of the xattr to exist in the tree in the
> > first place. However, we have to do these two operations as a pair
> > of linked independent operations. The intent chain provides the
> > linking, and requires us to log the name and the value of the attr
> > that we are overwriting in the intent. Hence we can always recover
> > the modification to completion no matter where in the operation we
> > fail.
> > 
> > When it comes to a parent attr rename operation, we are effectively
> > doing two linked operations - remove the old attr, set the new attr
> > - on different attributes. Implementation wise, it is exactly the
> > same sequence as a "replace value" operation, except for the fact
> > that the new attr we add has a different name.
> > 
> > Hence the only real difference between the existing "attr replace"
> > and the intent chain we need for "parent attr rename" is that we
> > have to log two attr names instead of one. 
> 
> To be clear, this would imply expanding xfs_attri_log_format to have
> another alfi_new_name_len feild and another iovec for the attr intent
> right?  Does that cause issues to change the on disk log layout after
> the original has merged?  Or is that ok for things that are still
> experimental? Thanks!

I think we can get away with this quite easily without breaking the
existing experimental code.

struct xfs_attri_log_format {
        uint16_t        alfi_type;      /* attri log item type */
        uint16_t        alfi_size;      /* size of this item */
        uint32_t        __pad;          /* pad to 64 bit aligned */
        uint64_t        alfi_id;        /* attri identifier */
        uint64_t        alfi_ino;       /* the inode for this attr operation */
        uint32_t        alfi_op_flags;  /* marks the op as a set or remove */
        uint32_t        alfi_name_len;  /* attr name length */
        uint32_t        alfi_value_len; /* attr value length */
        uint32_t        alfi_attr_filter;/* attr filter flags */
};

We have a padding field in there that is currently all zeros. Let's
make that a count of the number of {name, value} tuples that are
appended to the format. i.e.

struct xfs_attri_log_name {
        uint32_t        alfi_op_flags;  /* marks the op as a set or remove */
        uint32_t        alfi_name_len;  /* attr name length */
        uint32_t        alfi_value_len; /* attr value length */
        uint32_t        alfi_attr_filter;/* attr filter flags */
};

struct xfs_attri_log_format {
        uint16_t        alfi_type;      /* attri log item type */
        uint16_t        alfi_size;      /* size of this item */
	uint8_t		alfi_attr_cnt;	/* count of name/val pairs */
        uint8_t		__pad1;          /* pad to 64 bit aligned */
        uint16_t	__pad2;          /* pad to 64 bit aligned */
        uint64_t        alfi_id;        /* attri identifier */
        uint64_t        alfi_ino;       /* the inode for this attr operation */
	struct xfs_attri_log_name alfi_attr[]; /* attrs to operate on */
};

Basically, the size and shape of the structure has not changed, and
if alfi_attr_cnt == 0 we just treat it as if alfi_attr_cnt == 1 as
the backwards compat code for the existing code.

And then we just have as many followup regions for name/val pairs
as are defined by the alfi_attr_cnt and alfi_attr[] parts of the
structure. Each attr can have a different operation performed on
them, and they can have different filters applied so they can exist
in different namespaces, too.

SO I don't think we need a new on-disk feature bit for this
enhancement - it definitely comes under the heading of "this stuff
is experimental, this is the sort of early structure revision that
EXPERIMENTAL is supposed to cover....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
