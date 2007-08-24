Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 18:22:31 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7O1MQ4p032222
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 18:22:29 -0700
Date: Fri, 24 Aug 2007 03:22:25 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 8/17] kill struct bhv_vnode
Message-ID: <20070824012225.GB25534@lst.de>
References: <20070823193905.GI8050@lst.de> <20070824001040.GB72985246@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070824001040.GB72985246@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Fri, Aug 24, 2007 at 10:10:40AM +1000, David Chinner wrote:
> On Thu, Aug 23, 2007 at 09:39:05PM +0200, Christoph Hellwig wrote:
> > Now that struct bhv_vnode is empty we can just kill it.  Retain bhv_vattr_t
> > as a typedef for struct inode for the time beeing until all the fallout is
> > cleaned up.
> 
> I think you mean "retain the bhv_vnode_t as a typedef for struct inode":

Yes, feel free to correct it in the final commit message :)
