Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6EC0C54EE9
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Sep 2022 18:33:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiI0SdB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Sep 2022 14:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbiI0Sc7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Sep 2022 14:32:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75A91B8CA6
        for <linux-xfs@vger.kernel.org>; Tue, 27 Sep 2022 11:32:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5BC02B81CF4
        for <linux-xfs@vger.kernel.org>; Tue, 27 Sep 2022 18:32:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1873FC433C1;
        Tue, 27 Sep 2022 18:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664303575;
        bh=0gRr3EUHQnSqmDHnoxGDOHYKb/G3CNcscLEzsFJAr8w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zo9nim/qGWil7san0A8yjnjbdMco3R5035obFltPYyMUwlDfCOh9UAUSe4T/A4EFH
         /8XDWkoaQ032mgYRxPW6iBYhu2M+eugJsXsAJyFiUmiznYGQrZkczJWWiou/TFT1Uo
         Rdwq/fJjwqBK3UytEIqnwD5hEHZVKStKE6rf9UkOtpwgS9Dz6KouiwstQL/BeYA+x7
         eYsEMzBwTLt2ZcG00r/PrqvwBy3efAlLs/JNMO8N9RBFWLlYItFTFr520CnbJ/IPu6
         RLxlfLf8MlgpTD2zIQhAjFRR41qFlDBHe7eWZICtPtG1LDpbkHxLBBQLanlTTme5Mg
         cLc9wNCx1DJBg==
Date:   Tue, 27 Sep 2022 11:32:54 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3 23/26] xfs: Filter XFS_ATTR_PARENT for getfattr
Message-ID: <YzNB1juXibZtPuoj@magnolia>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
 <20220922054458.40826-24-allison.henderson@oracle.com>
 <Yy4o9c9w5OilCkrS@magnolia>
 <278fb4cce1eb9b7eaec97f8d382a2c12a3cd05c4.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <278fb4cce1eb9b7eaec97f8d382a2c12a3cd05c4.camel@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 26, 2022 at 09:49:42PM +0000, Allison Henderson wrote:
> On Fri, 2022-09-23 at 14:45 -0700, Darrick J. Wong wrote:
> > On Wed, Sep 21, 2022 at 10:44:55PM -0700,
> > allison.henderson@oracle.com wrote:
> > > From: Allison Henderson <allison.henderson@oracle.com>
> > > 
> > > Parent pointers returned to the get_fattr tool cause errors since
> > > the tool cannot parse parent pointers.  Fix this by filtering
> > > parent
> > > parent pointers from xfs_attr_list.
> > 
> > Yes!!  Parent pointers should /never/ be accessible by the standard
> > VFS
> > xattr syscalls, nor should the XFS ATTR_MULTI calls handle them.
> > 
> > Changes to parent pointers are performed via separate syscalls
> > (link/unlink/mknod/creat/etc), and I see you've created a separate
> > parent pointer ioctl later on for userspace to retrieve them.  I
> > think
> > this is the correct access model.
> > 
> > To check that assertion -- getxattr/setxattr/removexattr (and the
> > ATTRMULTI
> > equivalents) are prevented from accessing parent pointers directly
> > because you'd have to be able to set XFS_ATTR_PARENT in
> > xfs_da_args.attr_filter, right?
> Well, you set XFS_IOC_ATTR_PARENT which later translates to
> XFS_ATTR_PARENT.  I do that later in the set, but I see you've already
> commented on it

<nod>

> > 
> > And for the VFS to get/set/remove a parent pointer, XFS would have to
> > provide a struct xattr_handler with ->flags = XFS_ATTR_PARENT, which
> > XFS
> > will never do, right?
> Well, this set does not plan to make any vfs modifications at least :-)
> 
> > 
> > And for ATTR_MULTI to touch a parent pointer, xfs_attr_filter (and
> > the
> > ioctl api) would have to learn about XFS_ATTR_PARENT, which XFS will
> > also never do, right?
> I think we do have to publish that XFS_ATTR_PARENT exists, but I don't
> think we have to implement the XFS_IOC_ATTR_PARENT translation

Agreed.  The fewer symbols that end up in xfs_fs.h the better, because
anything we publish in there becomes a part of the userspace ABI and has
to be supported "forever".

> > If the answers to these three questions are all yes then you're 95%
> > of
> > the way to an RVB, except...
> > 
> > > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_da_format.h |  3 +++
> > >  fs/xfs/xfs_attr_list.c        | 47 +++++++++++++++++++++++++++----
> > > ----
> > >  2 files changed, 39 insertions(+), 11 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_da_format.h
> > > b/fs/xfs/libxfs/xfs_da_format.h
> > > index b02b67f1999e..e9c323fab6f3 100644
> > > --- a/fs/xfs/libxfs/xfs_da_format.h
> > > +++ b/fs/xfs/libxfs/xfs_da_format.h
> > > @@ -697,6 +697,9 @@ struct xfs_attr3_leafblock {
> > >  #define XFS_ATTR_INCOMPLETE    (1u << XFS_ATTR_INCOMPLETE_BIT)
> > >  #define XFS_ATTR_NSP_ONDISK_MASK \
> > >                         (XFS_ATTR_ROOT | XFS_ATTR_SECURE |
> > > XFS_ATTR_PARENT)
> > > +#define XFS_ATTR_ALL \
> > > +       (XFS_ATTR_LOCAL_BIT | XFS_ATTR_ROOT | XFS_ATTR_SECURE | \
> > > +        XFS_ATTR_PARENT | XFS_ATTR_INCOMPLETE_BIT)
> > >  
> > >  /*
> > >   * Alignment for namelist and valuelist entries (since they are
> > > mixed
> > > diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> > > index a51f7f13a352..13de597c4996 100644
> > > --- a/fs/xfs/xfs_attr_list.c
> > > +++ b/fs/xfs/xfs_attr_list.c
> > > @@ -39,6 +39,23 @@ xfs_attr_shortform_compare(const void *a, const
> > > void *b)
> > >         }
> > >  }
> > >  
> > > +/*
> > > + * Returns true or false if the parent attribute should be listed
> > > + */
> > > +static bool
> > > +xfs_attr_filter_parent(
> > > +       struct xfs_attr_list_context    *context,
> > > +       int                             flags)
> > > +{
> > > +       if (!(flags & XFS_ATTR_PARENT))
> > > +               return true;
> > > +
> > > +       if (context->attr_filter & XFS_ATTR_PARENT)
> > > +               return true;
> > > +
> > > +       return false;
> > 
> > ...wouldn't it suffice to do:
> > 
> > static inline bool
> > xfs_attr_filter_listent(
> >         struct xfs_attr_list_context    *context,
> >         int                             flags)
> > {
> >         return context->attr_filter != (flags &
> > XFS_ATTR_NSP_ONDISK_MASK);
> > }
> Almost.... XFS_ATTR_NSP_ONDISK_MASK includes XFS_ATTR_PARENT, so here
> we'd want XFS_ATTR_NSP_ONDISK_MASK & ~XFS_ATTR_PARENT
> 
> Also, XFS_ATTR_NSP_ONDISK_MASK doesnt include XFS_ATTR_LOCAL which was
> previously allowable
> 
> Hmm, how bout just:
> 	return context->attr_filter != flags & (XFS_ATTR_ROOT |
> XFS_ATTR_SECURE | XFS_ATTR_LOCAL)
> 
> I think that preserves the existing behavior

It does, but I think it'll cause conflicts with future online fsck code.

(Let me check my understanding of the xfs_attr_list callers first:

There are /three/ namespaces, but only two of them have defined flag
bits.  "root.*" and "secure.*" have XFS_ATTR_{ROOT,SECURE}, but "user.*"
is recorded by the absence of any XFS_ATTR_ flag.  IOWs, attr_filter
isn't a bit mask of all the namespaces that the caller wants; it's a
cookie value to coordinate between the xfs_attr_list caller and the
supplied putent function.

vfs_listxattr doesn't allow userspace to specify an xattr namespace, so
it returns xattrs from user.*, root.*, and secure.*.  xfs_vn_listxattr
doesn't set attr_filter, and xfs_xattr_put_listent doesn't check.

XFS_IOC_ATTRLIST_BY_HANDLE, on the other hand, requires userspace to
specify which namespace they want to list.  That's why it's the one
caller that sets context.attr_filter, and xfs_ioc_attr_put_listent does
a comparison to filter attributes from other namespaces.

The xattr scrubber calls xfs_attr_list_ilocked to walk every xattr
attached to the file.  For each call to ->put_listent, it uses the
built-in hash information to look up the attr name provided to confirm
that hashed lookups also work.  For /this/ usecase, we want
xfs_attr_list_* to return all xattrs because we need to check all xattr
namespaces.  Hence it doesn't set context.attr_filter, and
xchk_xattr_listent doesn't check it either.

...right?)

((Come to think of it -- shouldn't the ifork and attr leaf block
verifiers check that each attr entry struct have at most one of the
namespace bits set?))

After the addition of parent pointers, xfs_xattr_put_listent needs to
filter out (flags & XFS_ATTR_PARENT) cases.  XFS_IOC_ATTRLIST_BY_HANDLE
won't need any changes if we drop the XFS_IOC_ATTR_PARENT flag, since
there won't be any way for XFS_ATTR_PARENT to be set in attr_filter.
The xattr scrubber still needs to walk every xattr to perform a complete
scan.  Hence it will still not touch context.attr_filter, nor will it
want any filtering to be applied at all.

For the forthcoming totally-doesn't-exist-yet parent pointer online fsck
code, I'd sorta like to reuse that function to walk only the parent
pointers.  I'm not 100% sure I will end up doing that -- the cursoring
code would be useful if I have to use a live inode scan to do the
checking and repair, but OTOH it's a little annoying to deal with the
warts of the xfs_attr_list_context.  But in theory, I'd have
xchk_parent_listent or whatever the function ends up being named ignore
anything that wasn't XFS_ATTR_PARENT.  This mechanism also does not want
the xfs_attr_list_* functions to perform any filtering.

In terms of APIs, xfs_attr_filter_parent doesn't really make a lot of
sense -- if you set context.attr_filter = XFS_ATTR_PARENT, you'll get
all the xattrs (including the non-parent ones), but if you set any other
value (e.g. XFS_ATTR_SECURE), you'll get all the non-parent xattrs,
including the root.* and user.* attrs.  The ->put_listent function still
has to do its own filtering.  Right?

What if xfs_xattr_put_listent exited early if (flags & XFS_ATTR_PARENT)
and we never define a XFS_IOC_ATTR_ROOT?  Won't that suffice to prevent
the userspace xattr APIs from ever returning a parent pointer by
accident?

Looking ahead to the GETPARENTS code, I think the filtering code in
xfs_ioc_attr_put_listent would work for returning only the parent
pointers, right?  Since it does set context.attr_filter to
XFS_ATTR_PARENT on its own?  And you wouldn't need any of the other
changes here?

--D

> > 
> > like how xfs_ioc_attr_put_listent does?  And then...
> > 
> > > +}
> > > +
> > >  #define XFS_ISRESET_CURSOR(cursor) \
> > >         (!((cursor)->initted) && !((cursor)->hashval) && \
> > >          !((cursor)->blkno) && !((cursor)->offset))
> > > @@ -90,11 +107,12 @@ xfs_attr_shortform_list(
> > >                                                                sfe-
> > > >namelen,
> > >                                                                sfe-
> > > >flags)))
> > >                                 return -EFSCORRUPTED;
> > > -                       context->put_listent(context,
> > > -                                            sfe->flags,
> > > -                                            sfe->nameval,
> > > -                                            (int)sfe->namelen,
> > > -                                            (int)sfe->valuelen);
> > > +                       if (xfs_attr_filter_parent(context, sfe-
> > > >flags))
> > > +                               context->put_listent(context,
> > > +                                                    sfe->flags,
> > > +                                                    sfe->nameval,
> > > +                                                    (int)sfe-
> > > >namelen,
> > > +                                                    (int)sfe-
> > > >valuelen);
> > >                         /*
> > >                          * Either search callback finished early or
> > >                          * didn't fit it all in the buffer after
> > > all.
> > > @@ -185,11 +203,12 @@ xfs_attr_shortform_list(
> > >                         error = -EFSCORRUPTED;
> > >                         goto out;
> > >                 }
> > > -               context->put_listent(context,
> > > -                                    sbp->flags,
> > > -                                    sbp->name,
> > > -                                    sbp->namelen,
> > > -                                    sbp->valuelen);
> > > +               if (xfs_attr_filter_parent(context, sbp->flags))
> > > +                       context->put_listent(context,
> > > +                                            sbp->flags,
> > > +                                            sbp->name,
> > > +                                            sbp->namelen,
> > > +                                            sbp->valuelen);
> > >                 if (context->seen_enough)
> > >                         break;
> > >                 cursor->offset++;
> > > @@ -474,8 +493,10 @@ xfs_attr3_leaf_list_int(
> > >                                    !xfs_attr_namecheck(mp, name,
> > > namelen,
> > >                                                        entry-
> > > >flags)))
> > >                         return -EFSCORRUPTED;
> > > -               context->put_listent(context, entry->flags,
> > > +               if (xfs_attr_filter_parent(context, entry->flags))
> > > +                       context->put_listent(context, entry->flags,
> > >                                               name, namelen,
> > > valuelen);
> > > +
> > >                 if (context->seen_enough)
> > >                         break;
> > >                 cursor->offset++;
> > > @@ -539,6 +560,10 @@ xfs_attr_list(
> > >         if (xfs_is_shutdown(dp->i_mount))
> > >                 return -EIO;
> > >  
> > > +       if (context->attr_filter == 0)
> > > +               context->attr_filter =
> > > +                       XFS_ATTR_ALL & ~XFS_ATTR_PARENT;
> > 
> > ...I think this is unnecessary since none of the callers can actually
> > set XFS_ATTR_PARENT in the first place, right?
> > 
> The caller can stuff any bit in there they want, but until now it
> didn't matter because context->attr_filter was unused (getfattr appears
> to just leave it as 0).  So the existing behavior was that requesting
> nothing resulted in everything.  Now we're flipping that (at least
> internally).
> 
> If we use the filter logic above, this would need to turn into
> context->attr_filter = (XFS_ATTR_ROOT | XFS_ATTR_SECURE |
> XFS_ATTR_LOCAL)
> 
> > --D
> > 
> > > +
> > >         lock_mode = xfs_ilock_attr_map_shared(dp);
> > >         error = xfs_attr_list_ilocked(context);
> > >         xfs_iunlock(dp, lock_mode);
> > > -- 
> > > 2.25.1
> > > 
> 
