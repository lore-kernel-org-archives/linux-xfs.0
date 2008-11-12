Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Nov 2008 20:24:32 -0800 (PST)
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mAC4OKGf013124
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2008 20:24:21 -0800
Message-ID: <491A5A6D.5040802@sgi.com>
Date: Wed, 12 Nov 2008 15:24:13 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] use inode_change_ok for setattr permission checking
References: <20080929215329.GC30363@lst.de> <4908041F.2020905@sgi.com> <20081111222414.GA9134@infradead.org>
In-Reply-To: <20081111222414.GA9134@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Wed, Oct 29, 2008 at 05:35:11PM +1100, Timothy Shimmin wrote:
>> Christoph Hellwig wrote:
>>> Instead of implementing our own checks use inode_change_ok to check for
>>> nessecary permission in setattr.  
>> Yeah, the 1st bit I quite like and is similar to what I did in some
>> nfs4acl code, as you know.
>> We put all the EPERM cases early on which is nice.
> 
> Yes.  The big differene to the NFSv4 ACL patches is that we use the
> standard kernel inode_change_ok routine, which means we are guaranteed
> to have the same checks as all other filesystems and get rid of
> duplicated code.
> 
> Btw, I must also say that I really hate the way the NFSv4 ACL patches make
> this filesystem-specific for all filesystems that support the NFSv4
> ACLs.  All these permission checks should instead go through
> ->permission with additional MAY_ flags.
> 
Yeah, it would be nice to have more out of the filesystem.

>> And then we have similar code in inode_setattr()
>>         if (ia_valid & ATTR_MODE) {
>>                 umode_t mode = attr->ia_mode;
>>
>>                 if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
>>                         mode &= ~S_ISGID;
>>                 inode->i_mode = mode;
>>         }
>>
>> But what about the suid case?
> 
> SUID is handled in the inode_change_ok bit you quoted earlier.  

For some reason I can't see where? Sorry.
I see the sgid clear but not the suid clear. D'oh.


> But we
> should add this S_ISGID handling here to XFS, too.
> 
>> And also, what is with the ATTR_KILL_* bits?
>> Lemme look...
> 
> ATTR_KILL_SUID/ATTR_KILL_SGID is a rather special thing added for NFS
> which doesn't want to do these locally but only on the server.  Local
> filesystems can simply ignore it.
> 
Thanks for the explanation.

> Updated patch below.  Note that the S_ISGID hadling required moving
> the ATTR_MODE handling after the ATTR_GID handling.
> 

So from above we have:

notify_change(struct dentry * dentry, struct iattr * attr):

>         if (inode->i_op && inode->i_op->setattr) {
>                 error = security_inode_setattr(dentry, attr);
>                 if (!error)
>                         error = inode->i_op->setattr(dentry, attr);


>         } else {
>                 error = inode_change_ok(inode, attr);
>                 if (!error)
>                         error = security_inode_setattr(dentry, attr);
>                 if (!error) {
>                         if ((ia_valid & ATTR_UID && attr->ia_uid != inode->i_uid) ||
>                             (ia_valid & ATTR_GID && attr->ia_gid != inode->i_gid))
>                                 error = DQUOT_TRANSFER(inode, attr) ? -EDQUOT : 0;
>                         if (!error)
>                                 error = inode_setattr(inode, attr);
>                 }
>         }

So in our case i_op->setattr -> xfs_setattr
And xfs_setattr will now call inode_change_ok().
So we should have similar code to inode_setattr.

So why do we do sgid clear in inode_setattr() as well as in inode_change_ok()?
Doesn't inode_change_ok propagate the attr->ia_mode change back?

Okay, the SGID clearing for mode setting seems fine.

However, we really should have a QA test for this stuff.
Something is bound to stuff up here.

--Tim
