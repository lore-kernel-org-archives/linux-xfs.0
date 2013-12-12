Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 60DF77F5A
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 10:36:34 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 30B61304051
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 08:36:31 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Ewu12CF0biy1VnWw (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 08:36:30 -0800 (PST)
Date: Thu, 12 Dec 2013 08:36:29 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/6] xfs: don't try to mark uncached buffers stale on
	error.
Message-ID: <20131212163629.GA2894@infradead.org>
References: <1386826478-13846-1-git-send-email-david@fromorbit.com>
	<1386826478-13846-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1386826478-13846-2-git-send-email-david@fromorbit.com>
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

I really don't like how this makes even more of a mess out of the
already convoluted xfs_bioerror/xfs_bioerror_else maze.  Can we
maybe first merge them and document the difference before adding
even more special case branches?

Also most uses of uncached buffers use xfsbdstrat, where we can do
error handling straight in the caller instead of playing with all
the flags manipulation mess.  In all these cases no one but the
caller can find these buffers anyway, so doing all this on an
I/O error is pointless.

The only buffer where any of this matters is the superblock one,
and given that we re-read it on mount anyway I wonder if we should
just make it a regular buffer again and let all this mess just
disappear.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
