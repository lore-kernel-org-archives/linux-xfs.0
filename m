Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 May 2008 22:10:16 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4G5A4Ax017312
	for <xfs@oss.sgi.com>; Thu, 15 May 2008 22:10:09 -0700
Date: Fri, 16 May 2008 01:10:48 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: TAKE 981875 - xfs_dm_rdwr() needs to pass a vfsmount to
	dentry_open()
Message-ID: <20080516051048.GB5035@infradead.org>
References: <20080516045732.F12DC58C4C29@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080516045732.F12DC58C4C29@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

On Fri, May 16, 2008 at 02:57:32PM +1000, Lachlan McIlroy wrote:
> xfs_dm_rdwr() needs to pass a vfsmount to dentry_open()
> 
> We need a vfsmount pointer in xfs_dm_rdwr() but we are not
> provided with one and there's no way to get to it.  So add
> a m_vfsmount field to the xfs_mount structure and set it
> up at mount time.  We can then access it through the xfs
> inode.

Stong NACK for this crap, and double NACK for pushing this towards
mainline.
