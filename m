Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 20 Oct 2008 23:16:51 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9L6Gjms006858
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 23:16:45 -0700
Message-ID: <48FD7435.6010905@sgi.com>
Date: Tue, 21 Oct 2008 17:18:29 +1100
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/4] kill struct xfs_mount_args
References: <20080525190741.GB13372@lst.de> <20080723080505.GA3417@lst.de> <20080828231735.GB19757@lst.de> <20081018123535.GA25304@lst.de>
In-Reply-To: <20081018123535.GA25304@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> Can we please get these patches in?  They've been out for almost _five_
> month, and due to the nature of messing with the mount arguments they're
> going to cause conflict for anything dealing with mount options.  Not to
> speak they've been blocking making any progress on the mount/unmount
> path for these five month.
> 

Ok looking at the whole series

- [PATCH 1/4] don't leak m_fsname/m_rtname/m_logname
  Picked up by
   TAKE 981498 - don't leak m_fsname/m_rtname/m_logname
   http://oss.sgi.com/archives/xfs/2008-07/msg00388.html

- [PATCH 2/4] kill struct xfs_mount_args
  Revision http://oss.sgi.com/archives/xfs/2008-07/msg00476.html
  Still applies ok, applying it to our tree.

- [PATCH 3/4] fix the noquota mount option
  http://oss.sgi.com/archives/xfs/2008-05/msg00379.html
  Still applies ok, applying it to our tree.

- [PATCH 4/4] fix biosize option
  http://oss.sgi.com/archives/xfs/2008-05/msg00380.html
  Still applies ok, applying it to our tree.

Don
