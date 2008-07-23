Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 14:56:24 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6NLuL5x027865
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 14:56:21 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 83494E8F5A9
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 14:57:31 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id uUSYVyZfpmJCWyQ2 for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 14:57:31 -0700 (PDT)
Date: Wed, 23 Jul 2008 23:57:21 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/2] kill bhv_vnode_t
Message-ID: <20080723215721.GA11049@lst.de>
References: <20080723214737.GA10655@lst.de> <4887A84D.90701@thebarn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4887A84D.90701@thebarn.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Russell Cattelan <cattelan@thebarn.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 23, 2008 at 04:53:17PM -0500, Russell Cattelan wrote:
> Christoph Hellwig wrote:
> >Dave complained today that the fate of bhv_vnode_t isn't entirely clear
> >yet, so I've prepared these two patches to kill it in a minimally
> >invasive way.  While it causes churn in a lot of areas it does not
> >affect the generated code at all.
> >
> >  
> I know a bunch of stuff has gone in that is not very portable, which is 
> fine since
> they can be dealt with individually since they are not that intrusive.
> 
> Changing bhv_vnode_t to struct inode throughout the code is a pretty big
> change and would be a major pain to work around.

Have you actually looed at the patches?  The only places where we use
struct inode outside of linux-2.6/ are:

 - xfs_finish_reclaim:

	Distangles the xfs_inode from Linux inode.  Per defintion
	OS-specific.

 - xfs_sync_inodes:

	 Sync code that is quite OS specific.  Dave will move it
	 to linux-2.6/ pretty soon.

 - quota/xfs_qm_syscalls.c:

	Similar sync code.

 - xfs_acl.c:

	ACL code with some OS dependencies, and pretty dead with my
	pending patch to use the generic ACL code.

And no, it's not actually a big change.
