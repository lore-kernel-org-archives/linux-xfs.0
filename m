Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B3F2C7F50
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 02:27:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8F16A8F8033
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 00:27:43 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id eaGDfI9Ro9N6hB3Q (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 12 Aug 2015 00:27:42 -0700 (PDT)
Date: Wed, 12 Aug 2015 00:27:42 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/8] xfs: remove nonblocking mode from xfs_vm_writepage
Message-ID: <20150812072742.GB32399@infradead.org>
References: <1439333388-16452-1-git-send-email-david@fromorbit.com>
	<1439333388-16452-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1439333388-16452-4-git-send-email-david@fromorbit.com>
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

This error handling was the biggest obstacle last time we tried it,
so let's remove it for now.  However:

On Wed, Aug 12, 2015 at 08:49:43AM +1000, Dave Chinner wrote:
> Remove the nonblocking optimisation done for mapping lookups during
> writeback. It's not clear that leaving a hole in the writeback range
> just because we couldn't get a lock is really a win, as it makes us
> do another small random IO later on rather than a large sequential
> IO now.

The fs-writeback.c will usually move to a different inode, so I don't
think it's actually that bad.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
