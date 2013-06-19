Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2C40F7F76
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 04:15:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 006B1304039
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 02:15:43 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 3tRfftGtDiStqBvJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 19 Jun 2013 02:15:41 -0700 (PDT)
Date: Wed, 19 Jun 2013 02:15:38 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/60] xfs: patch queue for 3.11
Message-ID: <20130619091538.GA359@infradead.org>
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1371617468-32559-1-git-send-email-david@fromorbit.com>
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

Hi Dave,

I like this version a lot better from a quick glance.

A few more comments:

 - do we really want all that many separate _format.h headers?
   I'd be really tempted to say we have just a single xfs_format.h
   header, which should declare everything.  It's still not all that
   large, and it would be a really good start to ease our include mess.
 - xfs_extent_ops.c still has that odd _ops.c name I hate because it
   tends to imply it's an implementation of some ops vector.  How about
   xfs_alloc_util.c to go with the other _util name you added?
 - any chance to reorder the inode.c split so that stuff doesn't get
   move around multiple times?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
