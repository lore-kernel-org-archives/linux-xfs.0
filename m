Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Jul 2008 05:14:28 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6SCENll008015
	for <xfs@oss.sgi.com>; Mon, 28 Jul 2008 05:14:25 -0700
Date: Mon, 28 Jul 2008 08:15:34 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: TAKE 981498 - kill bhv_vnode_t
Message-ID: <20080728121534.GA12715@infradead.org>
References: <20080728062625.BB57158C4C3F@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728062625.BB57158C4C3F@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

On Mon, Jul 28, 2008 at 04:26:25PM +1000, Lachlan McIlroy wrote:
> kill bhv_vnode_t
> 
> All remaining bhv_vnode_t instance are in code that's more or less Linux
> specific.  (Well, for xfs_acl.c that could be argued, but that code is
> on the removal list, too).  So just do an s/bhv_vnode_t/struct inode/
> over the whole tree.  We can clean up variable naming and some useless
> helpers later.

Thanks,  but I wonder how this could even apply without the
intialize_vnode cleanup..
