Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 120837F98
	for <xfs@oss.sgi.com>; Thu, 31 Jul 2014 12:16:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A0198AC008
	for <xfs@oss.sgi.com>; Thu, 31 Jul 2014 10:16:56 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id JKaXFqYOxwgVrolG (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 31 Jul 2014 10:16:55 -0700 (PDT)
Date: Thu, 31 Jul 2014 10:16:55 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/6] xfs: discombobulate sb updates and kill xfs_vnode.h
Message-ID: <20140731171655.GA30301@infradead.org>
References: <1406791995-14723-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1406791995-14723-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Jul 31, 2014 at 05:33:09PM +1000, Dave Chinner wrote:
> Hi folks,
> 
> Really two patch series in one. The first two patches remove the
> bitfield based superblock update method and replace it with a simple
> "update and log everything" operation. Superblock updates are
> now relatively rare so there's no need to optimise for single field
> updates. This patchset removes all that complex code and makes
> everything nice and simple.

Is there any deeper rationale why you want to get rid of it?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
