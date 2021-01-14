Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6D91C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 21:21:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7740523A9D
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 21:21:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729241AbhANVVx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Jan 2021 16:21:53 -0500
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:44251 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727802AbhANVVw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jan 2021 16:21:52 -0500
Received: from dread.disaster.area (pa49-179-167-107.pa.nsw.optusnet.com.au [49.179.167.107])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 2C7C1E47334;
        Fri, 15 Jan 2021 08:21:07 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1l0A3C-006V1r-Ri; Fri, 15 Jan 2021 08:21:02 +1100
Date:   Fri, 15 Jan 2021 08:21:02 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Yumei Huang <yuhuang@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: XFS: Assertion failed
Message-ID: <20210114212102.GM331610@dread.disaster.area>
References: <1599642077.64707510.1610619249861.JavaMail.zimbra@redhat.com>
 <487974076.64709077.1610619629992.JavaMail.zimbra@redhat.com>
 <20210114172928.GA1351833@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114172928.GA1351833@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=+wqVUQIkAh0lLYI+QRsciw==:117 a=+wqVUQIkAh0lLYI+QRsciw==:17
        a=kj9zAlcOel0A:10 a=EmqxpYm9HcoA:10 a=7-415B0cAAAA:8
        a=26t6F8iA7IIoceBZxEMA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 14, 2021 at 12:29:28PM -0500, Brian Foster wrote:
> On Thu, Jan 14, 2021 at 05:20:29AM -0500, Yumei Huang wrote:
> > Hit the issue when doing syzkaller test with kernel 5.11.0-rc3(65f0d241). The C reproducer is attached.
> > 
> > Steps to Reproduce:
> > 1. # gcc -pthread -o reproducer reproducer.c 
> > 2. # ./reproducer 
> > 
> > 
> > Test results:
> > [  131.726790] XFS: Assertion failed: (iattr->ia_valid & (ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET| ATTR_MTIME_SET|ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0, file: fs/xfs/xfs_iops.c, line: 849
> > [  131.743687] ------------[ cut here ]------------
> 
> Some quick initial analysis from a run of the reproducer... It looks
> like it calls into xfs_setattr_size() with ATTR_KILL_PRIV set in
> ->ia_valid. This appears to originate in the VFS via handle_truncate()
> -> do_truncate() -> dentry_needs_remove_privs().
> 
> An strace of the reproducer shows the following calls:
> 
> ...
> [pid  1524] creat("./file0", 010)       = 3
> ...
> [pid  1524] fsetxattr(3, "security.capability", "\0\0\0\3b\27\0\0\10\0\0\0\2\0\0\0\377\377\377\377\0\356\0", 24, 0 <unfinished ...>
> ...
> [pid  1524] creat("./file0", 010 <unfinished ...>
> ...
> 
> So I'm guessing there's an attempt to open this file with O_TRUNC with
> this particular xattr set (unexpectedly?). Indeed, after the reproducer
> leaves file01 around with the xattr, a subsequent xfs_io -c "open -t
> ..." attempt triggers the assert again, and then the xattr disappears.
> I'd have to dig more into the associated vfs code to grok the expected
> behavior and whether there's a problem here..

Changing the size of the inode is is all that xfs_setattr_size()
should be doing. Stripping capability attributes should have been
already been done by the generic setattr code before we get to
xfs_setattr_size(), so ATTR_KILL_PRIV should not be set at that
point.

notify_change() used to always strip ATTR_KILL_PRIV from ia_valid
when it sets up the flags necessary to strip privileges in the
->setattr callout. But it doesn't appear to do so always anymore:

        if (ia_valid & ATTR_KILL_PRIV) {
                error = security_inode_need_killpriv(dentry);
                if (error < 0)
                        return error;
                if (error == 0)
                        ia_valid = attr->ia_valid &= ~ATTR_KILL_PRIV;
        }

If ATTR_KILL_PRIV is still set, this implies
security_inode_need_killpriv() returned > 0 for some reason. I'm
assuming that this code ran:

security_inode_need_killpriv()
  call_int_hook(inode_need_killpriv, 0, dentry);

And the only implemented hook is this:

LSM_HOOK_INIT(inode_need_killpriv, cap_inode_need_killpriv),

/**                                                                              
 * cap_inode_need_killpriv - Determine if inode change affects privileges        
 * @dentry: The inode/dentry in being changed with change marked ATTR_KILL_PRIV  
 *                                                                               
 * Determine if an inode having a change applied that's marked ATTR_KILL_PRIV    
 * affects the security markings on that inode, and if it is, should             
 * inode_killpriv() be invoked or the change rejected.                           
 *                                                                               
 * Returns 1 if security.capability has a value, meaning inode_killpriv()        
 * is required, 0 otherwise, meaning inode_killpriv() is not required.           
 */                                                                              
int cap_inode_need_killpriv(struct dentry *dentry)                               
{                                                                                
        struct inode *inode = d_backing_inode(dentry);                           
        int error;                                                               
                                                                                 
        error = __vfs_getxattr(dentry, inode, XATTR_NAME_CAPS, NULL, 0);         
        return error > 0;                                                        
}                                                                                

And that's the xattr that the reproducer is setting. So, smoking
gun.

we've done a lookup on the security.capability xattr which it
found so notify_change() does not clear ATTR_KILL_PRIV. The xattr
gets killed in setattr_prepare() but it does not clear
ATTR_KILL_PRIV, and hence we hit the assert faili when we get into
xfs_setattr_size.

Looks like a regression introduced in 2016 by:

commit 030b533c4fd4d2ec3402363323de4bb2983c9cee
Author: Jan Kara <jack@suse.cz>
Date:   Thu May 26 17:21:32 2016 +0200

    fs: Avoid premature clearing of capabilities
    
    Currently, notify_change() clears capabilities or IMA attributes by
    calling security_inode_killpriv() before calling into ->setattr. Thus it
    happens before any other permission checks in inode_change_ok() and user
    is thus allowed to trigger clearing of capabilities or IMA attributes
    for any file he can look up e.g. by calling chown for that file. This is
    unexpected and can lead to user DoSing a system.
    
    Fix the problem by calling security_inode_killpriv() at the end of
    inode_change_ok() instead of from notify_change(). At that moment we are
    sure user has permissions to do the requested change.
    
    References: CVE-2015-1350
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Jan Kara <jack@suse.cz>

The bug is harmless, it will only trigger the assert on debug XFS
kernels, but otherwise ATTR_KILL_PRIV is not checked/used by
xfs_setattr_size.

Removing ATTR_KILL_PRIV from the assert is probably all that is
needed. Can you write a patch for that, Yumei?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
