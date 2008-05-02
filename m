Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 May 2008 23:06:23 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4266Cnw007535
	for <xfs@oss.sgi.com>; Thu, 1 May 2008 23:06:16 -0700
Date: Fri, 2 May 2008 02:06:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Don't use d_alloc_anon for open_by_handle
Message-ID: <20080502060654.GA23912@infradead.org>
References: <20080501070244.GH108924158@sgi.com> <1209693339-4861-1-git-send-email-xaiki@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209693339-4861-1-git-send-email-xaiki@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xaiki@sgi.com
Cc: xfs-dev@sgi.com, xfs@oss.sgi.com

On Fri, May 02, 2008 at 11:55:37AM +1000, xaiki@sgi.com wrote:
> One of our DMAPI user found that in some cases inodes weren't getting through
> xfs_inactive() in any reasonable amount of time. Investigation tracked it down
> to the use of d_alloc_anon() combined with another thread accessing the same
> inode via an open().
> 
> So we introduce a stripped down version of d_alloc_anon, that won't try to find
> an existing dentry, nor will hash it.

No, this is even more buggy than using d_alloc_anon.  What really needs
to be done in the handle code is to do the full reconnect logic nfsd
would be doing.  Aka you should be using exportfs_decode_fh and update
xfs's fh_to_dentry method to accept the file handle type used by the
handle interface.
