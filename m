Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 31 Oct 2008 13:19:40 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9VKJSxw017971
	for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 13:19:28 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1075C567FB6
	for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 13:19:29 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id 6IlOtVLTPpQSa2NR for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 13:19:29 -0700 (PDT)
Date: Fri, 31 Oct 2008 16:19:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] XFS: fix uninitialised variable bug in dquot
	release.
Message-ID: <20081031201929.GB20309@infradead.org>
References: <1225415729-26514-1-git-send-email-david@fromorbit.com> <1225415729-26514-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225415729-26514-4-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Oct 31, 2008 at 12:15:27PM +1100, Dave Chinner wrote:
> gcc on ARM warns about an using an uninitialised variable
> in xfs_qm_dqrele_all_inodes(). This is a real bug, but gcc
> on x86_64 is not reporting this warning so it went unnoticed.
> 
> Fix the bug by bring the inode radix tree walk code up to
> date with xfs_sync_inodes_ag().

Looks good.
