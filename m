Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEE5EC433E6
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Jan 2021 08:38:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A25522597
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Jan 2021 08:38:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727331AbhAOIiM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Jan 2021 03:38:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26766 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727349AbhAOIiL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Jan 2021 03:38:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610699804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ml0jNQSRkBSA28kOryARcWBZEBN0Haqk3Uw2GnXubp0=;
        b=MiZAufXoGgtWwKcMIMR3z/y+SDf6W4yzjP/NoqCwdFIO/Jr3iVefF8eRv8xOeQ0hzhkaGl
        jHOBHqHKBximUUkffPbABN8D+cZb+rnioSn40Ph4ce64YIbMTrwGthv4A062qiR+zHzFP0
        iXwYkifsr87oVsGffLE52VjmXxZtYXw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-540-7dUAPHNzPBixpvDU67tozw-1; Fri, 15 Jan 2021 03:36:42 -0500
X-MC-Unique: 7dUAPHNzPBixpvDU67tozw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3678E107ACF7;
        Fri, 15 Jan 2021 08:36:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E4A05D739;
        Fri, 15 Jan 2021 08:36:41 +0000 (UTC)
Received: from zmail26.collab.prod.int.phx2.redhat.com (zmail26.collab.prod.int.phx2.redhat.com [10.5.83.33])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1FDB818095C7;
        Fri, 15 Jan 2021 08:36:41 +0000 (UTC)
Date:   Fri, 15 Jan 2021 03:36:40 -0500 (EST)
From:   Yumei Huang <yuhuang@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <1914065699.64814368.1610699800882.JavaMail.zimbra@redhat.com>
In-Reply-To: <20210114212102.GM331610@dread.disaster.area>
References: <1599642077.64707510.1610619249861.JavaMail.zimbra@redhat.com> <487974076.64709077.1610619629992.JavaMail.zimbra@redhat.com> <20210114172928.GA1351833@bfoster> <20210114212102.GM331610@dread.disaster.area>
Subject: Re: XFS: Assertion failed
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.72.13.201, 10.4.195.29]
Thread-Topic: Assertion failed
Thread-Index: 4WFU4D4YGjZBeaBXlW9+MRoum/6uow==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



----- Original Message -----
> From: "Dave Chinner" <david@fromorbit.com>
> To: "Brian Foster" <bfoster@redhat.com>
> Cc: "Yumei Huang" <yuhuang@redhat.com>, linux-xfs@vger.kernel.org
> Sent: Friday, January 15, 2021 5:21:02 AM
> Subject: Re: XFS: Assertion failed
> 
> On Thu, Jan 14, 2021 at 12:29:28PM -0500, Brian Foster wrote:
> > On Thu, Jan 14, 2021 at 05:20:29AM -0500, Yumei Huang wrote:
> > > Hit the issue when doing syzkaller test with kernel 5.11.0-rc3(65f0d241).
> > > The C reproducer is attached.
> > > 
> > > Steps to Reproduce:
> > > 1. # gcc -pthread -o reproducer reproducer.c
> > > 2. # ./reproducer
> > > 
> > > 
> > > Test results:
> > > [  131.726790] XFS: Assertion failed: (iattr->ia_valid &
> > > (ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
> > > ATTR_MTIME_SET|ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0, file:
> > > fs/xfs/xfs_iops.c, line: 849
> > > [  131.743687] ------------[ cut here ]------------
> > 
> > Some quick initial analysis from a run of the reproducer... It looks
> > like it calls into xfs_setattr_size() with ATTR_KILL_PRIV set in
> > ->ia_valid. This appears to originate in the VFS via handle_truncate()
> > -> do_truncate() -> dentry_needs_remove_privs().
> > 
> > An strace of the reproducer shows the following calls:
> > 
> > ...
> > [pid  1524] creat("./file0", 010)       = 3
> > ...
> > [pid  1524] fsetxattr(3, "security.capability",
> > "\0\0\0\3b\27\0\0\10\0\0\0\2\0\0\0\377\377\377\377\0\356\0", 24, 0
> > <unfinished ...>
> > ...
> > [pid  1524] creat("./file0", 010 <unfinished ...>
> > ...
> > 
> > So I'm guessing there's an attempt to open this file with O_TRUNC with
> > this particular xattr set (unexpectedly?). Indeed, after the reproducer
> > leaves file01 around with the xattr, a subsequent xfs_io -c "open -t
> > ..." attempt triggers the assert again, and then the xattr disappears.
> > I'd have to dig more into the associated vfs code to grok the expected
> > behavior and whether there's a problem here..
> 
> Changing the size of the inode is is all that xfs_setattr_size()
> should be doing. Stripping capability attributes should have been
> already been done by the generic setattr code before we get to
> xfs_setattr_size(), so ATTR_KILL_PRIV should not be set at that
> point.
> 
> notify_change() used to always strip ATTR_KILL_PRIV from ia_valid
> when it sets up the flags necessary to strip privileges in the
> ->setattr callout. But it doesn't appear to do so always anymore:
> 
>         if (ia_valid & ATTR_KILL_PRIV) {
>                 error = security_inode_need_killpriv(dentry);
>                 if (error < 0)
>                         return error;
>                 if (error == 0)
>                         ia_valid = attr->ia_valid &= ~ATTR_KILL_PRIV;
>         }
> 
> If ATTR_KILL_PRIV is still set, this implies
> security_inode_need_killpriv() returned > 0 for some reason. I'm
> assuming that this code ran:
> 
> security_inode_need_killpriv()
>   call_int_hook(inode_need_killpriv, 0, dentry);
> 
> And the only implemented hook is this:
> 
> LSM_HOOK_INIT(inode_need_killpriv, cap_inode_need_killpriv),
> 
> /**
>  * cap_inode_need_killpriv - Determine if inode change affects privileges
>  * @dentry: The inode/dentry in being changed with change marked
>  ATTR_KILL_PRIV
>  *
>  * Determine if an inode having a change applied that's marked ATTR_KILL_PRIV
>  * affects the security markings on that inode, and if it is, should
>  * inode_killpriv() be invoked or the change rejected.
>  *
>  * Returns 1 if security.capability has a value, meaning inode_killpriv()
>  * is required, 0 otherwise, meaning inode_killpriv() is not required.
>  */
> int cap_inode_need_killpriv(struct dentry *dentry)
> {
>         struct inode *inode = d_backing_inode(dentry);
>         int error;
>                                                                                  
>         error = __vfs_getxattr(dentry, inode, XATTR_NAME_CAPS, NULL, 0);
>         return error > 0;
> }
> 
> And that's the xattr that the reproducer is setting. So, smoking
> gun.
> 
> we've done a lookup on the security.capability xattr which it
> found so notify_change() does not clear ATTR_KILL_PRIV. The xattr
> gets killed in setattr_prepare() but it does not clear
> ATTR_KILL_PRIV, and hence we hit the assert faili when we get into
> xfs_setattr_size.
> 
> Looks like a regression introduced in 2016 by:
> 
> commit 030b533c4fd4d2ec3402363323de4bb2983c9cee
> Author: Jan Kara <jack@suse.cz>
> Date:   Thu May 26 17:21:32 2016 +0200
> 
>     fs: Avoid premature clearing of capabilities
>     
>     Currently, notify_change() clears capabilities or IMA attributes by
>     calling security_inode_killpriv() before calling into ->setattr. Thus it
>     happens before any other permission checks in inode_change_ok() and user
>     is thus allowed to trigger clearing of capabilities or IMA attributes
>     for any file he can look up e.g. by calling chown for that file. This is
>     unexpected and can lead to user DoSing a system.
>     
>     Fix the problem by calling security_inode_killpriv() at the end of
>     inode_change_ok() instead of from notify_change(). At that moment we are
>     sure user has permissions to do the requested change.
>     
>     References: CVE-2015-1350
>     Reviewed-by: Christoph Hellwig <hch@lst.de>
>     Signed-off-by: Jan Kara <jack@suse.cz>
> 
> The bug is harmless, it will only trigger the assert on debug XFS
> kernels, but otherwise ATTR_KILL_PRIV is not checked/used by
> xfs_setattr_size.
> 
> Removing ATTR_KILL_PRIV from the assert is probably all that is
> needed. Can you write a patch for that, Yumei?

Sure, I will send the patch soon.


Best Regards,

Yumei Huang

> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
> 
> 

