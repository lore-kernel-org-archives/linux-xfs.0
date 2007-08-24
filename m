Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 17:10:58 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7O0Ap4p021782
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 17:10:54 -0700
Date: Fri, 24 Aug 2007 10:10:40 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 8/17] kill struct bhv_vnode
Message-ID: <20070824001040.GB72985246@sgi.com>
References: <20070823193905.GI8050@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070823193905.GI8050@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Thu, Aug 23, 2007 at 09:39:05PM +0200, Christoph Hellwig wrote:
> Now that struct bhv_vnode is empty we can just kill it.  Retain bhv_vattr_t
> as a typedef for struct inode for the time beeing until all the fallout is
> cleaned up.

I think you mean "retain the bhv_vnode_t as a typedef for struct inode":

> +typedef struct inode	bhv_vnode_t;
>  
> -typedef struct bhv_vnode {
> -	struct inode	v_inode;		/* Linux inode */
> -	/* inode MUST be last */
> -} bhv_vnode_t;

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
