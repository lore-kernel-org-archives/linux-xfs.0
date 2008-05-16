Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 May 2008 22:09:53 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4G59Za3017266
	for <xfs@oss.sgi.com>; Thu, 15 May 2008 22:09:36 -0700
Date: Fri, 16 May 2008 01:10:23 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_dm_rdwr() needs to pass a vfsmount to dentry_open()
Message-ID: <20080516051023.GA5035@infradead.org>
References: <482CE39F.9050404@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482CE39F.9050404@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, May 16, 2008 at 11:30:07AM +1000, Lachlan McIlroy wrote:
> --- fs/xfs/xfs_mount.h_1.265	2008-05-15 13:23:49.000000000 +1000
> +++ fs/xfs/xfs_mount.h	2008-05-15 13:21:50.000000000 +1000
> @@ -337,6 +337,7 @@ typedef struct xfs_mount {
> 	spinlock_t		m_sync_lock;	/* work item list lock */
> 	int			m_sync_seq;	/* sync thread generation no. */
> 	wait_queue_head_t	m_wait_single_sync_task;
> +	struct vfsmount		*m_vfsmount;
> } xfs_mount_t;

there can be multiple vfsmounts for a single xfs_mount.  In addition to
that please don't mess up core xfs for dmapi braindamage.
