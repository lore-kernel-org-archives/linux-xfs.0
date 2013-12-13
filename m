Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BA69C7F50
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 05:01:55 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A9739304059
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 03:01:43 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id Xa3LGe2AnjFMT9L4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Dec 2013 03:01:32 -0800 (PST)
Date: Fri, 13 Dec 2013 03:01:28 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/6] xfs: don't try to mark uncached buffers stale on
	error.
Message-ID: <20131213110128.GA14884@infradead.org>
References: <1386826478-13846-1-git-send-email-david@fromorbit.com>
	<1386826478-13846-2-git-send-email-david@fromorbit.com>
	<20131212163629.GA2894@infradead.org>
	<20131212222438.GJ10988@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131212222438.GJ10988@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Dec 13, 2013 at 09:24:38AM +1100, Dave Chinner wrote:
> Ok, I agree it is a bit messy, but that code is already pretty ugly.
> I'd like to get this fix in first, because it's causing oopses in
> roughly 30% of my local xfstests runs on a couple of VMs, so I'd
> prefer to get the fix out there now and do the cleanup as a separate
> patch series. Would that be an acceptible approach to take here from
> your perspective?

Ok, let's put the minimal fix in for now and then sort it out.  I'll
re-review it carefully.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
