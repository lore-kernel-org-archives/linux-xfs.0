Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7P8wcX8182469 for <xfs@oss.sgi.com>; Thu, 25 Aug 2011 03:58:38 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DDD404EBA40
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2011 01:58:37 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 3ay5UCmUqibHSSec for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2011 01:58:37 -0700 (PDT)
Date: Thu, 25 Aug 2011 10:58:25 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 4/5] xfs: use fs netlink interface for ENOSPC
 conditions
In-Reply-To: <20110825051631.GB1869@infradead.org>
Message-ID: <alpine.LFD.2.00.1108251052490.4105@dhcp-27-109.brq.redhat.com>
References: <1313669906-14931-1-git-send-email-lczerner@redhat.com>
	<1313669906-14931-5-git-send-email-lczerner@redhat.com>
	<20110825051631.GB1869@infradead.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Thu, 25 Aug 2011, Christoph Hellwig wrote:

> >  	xfs_rw_iunlock(ip, iolock);
> > +	if (unlikely(-ENOSPC == ret))
> > +		fs_nl_send_warning(inode->i_sb->s_dev, FS_NL_ENOSPC_WARN);
> 
> I'd remove the nl from both the name and the constants.  In the end what
> matters is the warning, and netlink just is an implementation detail.

That makes sense, I'll change that.

> 
> > index 9a72dda..dd167a0 100644
> > --- a/fs/xfs/linux-2.6/xfs_super.c
> > +++ b/fs/xfs/linux-2.6/xfs_super.c
> > @@ -1731,6 +1731,7 @@ init_xfs_fs(void)
> >  	error = register_filesystem(&xfs_fs_type);
> >  	if (error)
> >  		goto out_sysctl_unregister;
> > +	init_fs_nl_family();
> 
> Why do we have to call this from the filesystem?  Shouldn't we
> initialize it once from the VFS?

That's probably better than initialization in every file system. It
would also mean that the interface will be initializes even if there is
no user of it on the kernel side, but that should not be a problem I
guess.

> 
> 
> 
> Also any chance you could include the quota netlink warnings into the
> framework?  Any callers is also going to be interestested in quota
> warnings, not just enospc.  Also the xfs project quota code returns
> ENOSPC if over the project quota and needs to be handled either way.
> Adding another new category inbetween user/group quotas and plain ENOSPC
> for it would be nice.

That's the plan. I want to merge quota notification into this interface
as well (rather than having separate netlink interface
fs/quota/netlink.c). So, I'll try to do that in the next version of the
patches.

Thanks!
-Lukas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
