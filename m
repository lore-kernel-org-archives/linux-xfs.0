Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD12DC433E6
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB78E64E60
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239142AbhCDARR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:17:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23892 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233594AbhCCLxa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Mar 2021 06:53:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614772261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=84tceuAtjMAQLRwiCIrGCMa3BPH1B2TggTxoDalabbk=;
        b=UH8tiwib66/avxz6a9Y1d/R0V1Bpa1oIhEsAmgyF6pzlZb/cbq96idtokpEC8zW/wjEbHi
        OAzxOLlVAHpnG4VcDEsakKulGaTtXkE6xldP/z+tSFMdFjMjlsd7MJh3Jg5ue4E5e8rF6E
        P0f4ZsGT2ngy/+6kibSvsB7CaqfYJRA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-Ixgtkx6xOOG3Tbe9IaCsBg-1; Wed, 03 Mar 2021 06:50:59 -0500
X-MC-Unique: Ixgtkx6xOOG3Tbe9IaCsBg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71E461E561;
        Wed,  3 Mar 2021 11:50:58 +0000 (UTC)
Received: from bfoster (ovpn-119-215.rdu2.redhat.com [10.10.119.215])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E2E4860BFA;
        Wed,  3 Mar 2021 11:50:57 +0000 (UTC)
Date:   Wed, 3 Mar 2021 06:50:52 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v15 16/22] xfs: Set up infastructure for deferred
 attribute operations
Message-ID: <YD94HKkJ3WWXDU93@bfoster>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-17-allison.henderson@oracle.com>
 <20210226045802.GB7267@magnolia>
 <88ef7647-5898-888e-e4f0-0a115835759b@oracle.com>
 <83053a19-3ac0-ff9a-60ef-30a2a513325a@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <83053a19-3ac0-ff9a-60ef-30a2a513325a@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 02, 2021 at 12:13:23AM -0700, Allison Henderson wrote:
> 
> 
> On 2/26/21 5:56 PM, Allison Henderson wrote:
> > 
> > 
> > On 2/25/21 9:58 PM, Darrick J. Wong wrote:
> > > On Thu, Feb 18, 2021 at 09:53:42AM -0700, Allison Henderson wrote:
...
> > > 
> > > That said, as this series gets longer and longer I find it really more
> > > difficult to go through the whole series one by one vs. just diffing the
> > > whole branch and reviewing that.
> That's fine, it's that's easier for you, I could probably figure out in what
> patch the line of code you are commenting on would affect.  As noted in the
> call earlier today, I try to help reviewers in the cover letter by listing
> off which patches have changed since the last revision, and which havnt.
> That way you dont have to grind through things that havnt changed.  Though
> I'm not sure if folks really use the cover letter :-)
> 
> > > 
> > > <shrug> I don't really have a definitive answer for which is better.
> > > The xattr code is very complex, and I struggle even combining both of my
> > > usual strategies and attacking review from both ends.
> I actually think it's very reasonable to just focus on patches 11 and 12?
> Or maybe just the diff of the branch up to 12 if that's easier for you.
> Because if there's something about 11 or 12 that people want to change, it
> generally implies some change to the underlying refactoring.  So it seems a
> bit wasteful to keep re-reviewing the refactoring if the end result has some
> gripe about it.  If everyone is happy about how the refactoring ends up,
> then it makes sense to go back and review the implementation details.
> 

Just FWIW, I've been pretty much focusing on getting up to those one or
two patches and the preceding factoring leading up to it. I'm aware of
what's coming on top and have passed through it on (much) earlier
versions, but the release to release churn that results from the review
cycles is too much for me to keep up with in combination with other
things. To be clear, I'm certainly not _expecting_ to see a refresh of
the world so to speak on every post cycle based on feedback to the state
management code. (Of course there is nothing wrong with that if that's
your preference from a development perspective.)

One of the advantages of that IMO is that if everything leading up to
the introduction of state machine code is clean, isolated refactoring,
then ISTM those patches could roll into upstream as the series
progresses and minimize the snowball effect of the series overall.
That's one of the reasons I might harp a bit on some of the factoring
warts we might introduce, even if temporary and ultimately cleaned up by
the state management code, just because that makes it a little harder to
justify rolling things off the start of the series into upstream...

Brian

> To be clear, it's certaintly not that I dont appreciate the reviews, but I
> understand it's an exhausting thing to grind through, and I try to be
> mindful of that.  The only reason I dont push out the entire extended set is
> because its a 40 patch monster that's not reasonable for anyone to review
> right now, and I dont want people to think that I'm asking for that at this
> time.  So I just sort of send the links out so that people can see where
> it's meant to go.  For similar reasons, I've thought about reducing the
> visible window of patches to reduce reviewer burnout. So dont feel like you
> have to flog yourself through all 22, I think 12 is also reasonable cap off.
> 
> > > 
> > > By the way, have you been stress testing the xattr code with all this
> > > stuff applied?  At some point it becomes easier to pull this in and fix
> > > up the breakage than it is to review 22 slice-n-dice patches every cycle.
> > > 
> No, I've been testing with the attr group, and then a  few tests I came up
> with to replay the journal and also parent pointers.  I can toss in some
> stress tests too and make sure nothing turns up.
> 
> Thank you for the reviews, I know it's a lot
> Allison
> 
> > > --D
> > > 
> > > > + * attribute operations need to be processed.  An operation is
> > > > currently either
> > > > + * a set or remove.  Set or remove operations are described by
> > > > the xfs_attr_item
> > > > + * which may be logged to this intent.
> > > > + *
> > > > + * During a normal attr operation, name and value point to the
> > > > name and value
> > > > + * feilds of the calling functions xfs_da_args.  During a
> > > > recovery, the name
> > > > + * and value buffers are copied from the log, and stored in a
> > > > trailing buffer
> > > > + * attached to the xfs_attr_item until they are committed. 
> > > > They are freed when
> > > > + * the xfs_attr_item itself is freed when the work is done.
> > > > + */
> > > > +struct xfs_attri_log_item {
> > > > +    struct xfs_log_item        attri_item;
> > > > +    atomic_t            attri_refcount;
> > > > +    int                attri_name_len;
> > > > +    int                attri_value_len;
> > > > +    void                *attri_name;
> > > > +    void                *attri_value;
> > > > +    struct xfs_attri_log_format    attri_format;
> > > > +};
> > > > +
> > > > +/*
> > > > + * This is the "attr done" log item.  It is used to log the
> > > > fact that some attrs
> > > > + * earlier mentioned in an attri item have been freed.
> > > > + */
> > > > +struct xfs_attrd_log_item {
> > > > +    struct xfs_attri_log_item    *attrd_attrip;
> > > > +    struct xfs_log_item        attrd_item;
> > > > +    struct xfs_attrd_log_format    attrd_format;
> > > > +};
> > > > +
> > > > +#endif    /* __XFS_ATTR_ITEM_H__ */
> > > > diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> > > > index 8f8837f..d7787a5 100644
> > > > --- a/fs/xfs/xfs_attr_list.c
> > > > +++ b/fs/xfs/xfs_attr_list.c
> > > > @@ -15,6 +15,7 @@
> > > >   #include "xfs_inode.h"
> > > >   #include "xfs_trans.h"
> > > >   #include "xfs_bmap.h"
> > > > +#include "xfs_da_btree.h"
> > > >   #include "xfs_attr.h"
> > > >   #include "xfs_attr_sf.h"
> > > >   #include "xfs_attr_leaf.h"
> > > > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > > > index 248083e..6682936 100644
> > > > --- a/fs/xfs/xfs_ioctl.c
> > > > +++ b/fs/xfs/xfs_ioctl.c
> > > > @@ -15,6 +15,8 @@
> > > >   #include "xfs_iwalk.h"
> > > >   #include "xfs_itable.h"
> > > >   #include "xfs_error.h"
> > > > +#include "xfs_da_format.h"
> > > > +#include "xfs_da_btree.h"
> > > >   #include "xfs_attr.h"
> > > >   #include "xfs_bmap.h"
> > > >   #include "xfs_bmap_util.h"
> > > > diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> > > > index c1771e7..62e1534 100644
> > > > --- a/fs/xfs/xfs_ioctl32.c
> > > > +++ b/fs/xfs/xfs_ioctl32.c
> > > > @@ -17,6 +17,8 @@
> > > >   #include "xfs_itable.h"
> > > >   #include "xfs_fsops.h"
> > > >   #include "xfs_rtalloc.h"
> > > > +#include "xfs_da_format.h"
> > > > +#include "xfs_da_btree.h"
> > > >   #include "xfs_attr.h"
> > > >   #include "xfs_ioctl.h"
> > > >   #include "xfs_ioctl32.h"
> > > > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > > > index 00369502f..ce04721 100644
> > > > --- a/fs/xfs/xfs_iops.c
> > > > +++ b/fs/xfs/xfs_iops.c
> > > > @@ -13,6 +13,8 @@
> > > >   #include "xfs_inode.h"
> > > >   #include "xfs_acl.h"
> > > >   #include "xfs_quota.h"
> > > > +#include "xfs_da_format.h"
> > > > +#include "xfs_da_btree.h"
> > > >   #include "xfs_attr.h"
> > > >   #include "xfs_trans.h"
> > > >   #include "xfs_trace.h"
> > > > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > > > index 0604183..290e57b 100644
> > > > --- a/fs/xfs/xfs_log.c
> > > > +++ b/fs/xfs/xfs_log.c
> > > > @@ -2070,6 +2070,10 @@ xlog_print_tic_res(
> > > >           REG_TYPE_STR(CUD_FORMAT, "cud_format"),
> > > >           REG_TYPE_STR(BUI_FORMAT, "bui_format"),
> > > >           REG_TYPE_STR(BUD_FORMAT, "bud_format"),
> > > > +        REG_TYPE_STR(ATTRI_FORMAT, "attri_format"),
> > > > +        REG_TYPE_STR(ATTRD_FORMAT, "attrd_format"),
> > > > +        REG_TYPE_STR(ATTR_NAME, "attr_name"),
> > > > +        REG_TYPE_STR(ATTR_VALUE, "attr_value"),
> > > >       };
> > > >       BUILD_BUG_ON(ARRAY_SIZE(res_type_str) != XLOG_REG_TYPE_MAX + 1);
> > > >   #undef REG_TYPE_STR
> > > > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > > > index 295a5c6..c0821b6 100644
> > > > --- a/fs/xfs/xfs_log_recover.c
> > > > +++ b/fs/xfs/xfs_log_recover.c
> > > > @@ -1775,6 +1775,8 @@ static const struct xlog_recover_item_ops
> > > > *xlog_recover_item_ops[] = {
> > > >       &xlog_cud_item_ops,
> > > >       &xlog_bui_item_ops,
> > > >       &xlog_bud_item_ops,
> > > > +    &xlog_attri_item_ops,
> > > > +    &xlog_attrd_item_ops,
> > > >   };
> > > >   static const struct xlog_recover_item_ops *
> > > > diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> > > > index 0aa87c21..bc9c25e 100644
> > > > --- a/fs/xfs/xfs_ondisk.h
> > > > +++ b/fs/xfs/xfs_ondisk.h
> > > > @@ -132,6 +132,8 @@ xfs_check_ondisk_structs(void)
> > > >       XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format,    56);
> > > >       XFS_CHECK_STRUCT_SIZE(struct xfs_qoff_logformat,    20);
> > > >       XFS_CHECK_STRUCT_SIZE(struct xfs_trans_header,        16);
> > > > +    XFS_CHECK_STRUCT_SIZE(struct xfs_attri_log_format,    40);
> > > > +    XFS_CHECK_STRUCT_SIZE(struct xfs_attrd_log_format,    16);
> > > >       /*
> > > >        * The v5 superblock format extended several v4 header
> > > > structures with
> > > > diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> > > > index bca48b3..9b0c790 100644
> > > > --- a/fs/xfs/xfs_xattr.c
> > > > +++ b/fs/xfs/xfs_xattr.c
> > > > @@ -10,6 +10,7 @@
> > > >   #include "xfs_log_format.h"
> > > >   #include "xfs_da_format.h"
> > > >   #include "xfs_inode.h"
> > > > +#include "xfs_da_btree.h"
> > > >   #include "xfs_attr.h"
> > > >   #include "xfs_acl.h"
> > > >   #include "xfs_da_btree.h"
> > > > -- 
> > > > 2.7.4
> > > > 
> 

