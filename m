Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 31 Oct 2008 13:21:40 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9VKLSiu018639
	for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 13:21:28 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 29D59567FEF
	for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 13:21:29 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id Q9dGrbBcD4ZfICP4 for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 13:21:29 -0700 (PDT)
Date: Fri, 31 Oct 2008 16:21:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/5] XFS: Avoid using inodes that haven't been
	completely initialised
Message-ID: <20081031202129.GD20309@infradead.org>
References: <1225415729-26514-1-git-send-email-david@fromorbit.com> <1225415729-26514-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225415729-26514-6-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Oct 31, 2008 at 12:15:29PM +1100, Dave Chinner wrote:
> The radix tree walks in xfs_sync_inodes_ag and xfs_qm_dqrele_all_inodes()
> can find inodes that are still undergoing initialisation. Avoid
> them by checking for the the XFS_INEW() flag once we have a reference
> on the inode. This flag is cleared once the inode is properly initialised.

Yeah, that's what I meant with my initial comment that we can grab the
inodes anytime they are on the radix tree.

Looks good.
