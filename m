Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B2EE57F51
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2014 06:07:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 85BA9304048
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2014 04:07:31 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id i9coGY6LgHhPnqw6 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 03 Apr 2014 04:07:30 -0700 (PDT)
Date: Thu, 3 Apr 2014 04:07:30 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] xfs: add a test for unlinked inodes due to O_TMPFILE
Message-ID: <20140403110730.GB26244@infradead.org>
References: <20140313101302.996355155@bombadil.infradead.org>
	<20140313101433.608283621@bombadil.infradead.org>
	<20140313112907.GJ4263@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140313112907.GJ4263@dastard>
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

Skipping this for now, filtering the repair output properly is going to
be a lot of work, and I'd rather do a generic unlinked inode list
recovery test instead of tying it to O_TMPFILE.

With the first patch already reviewed and the second updated those
should be ready to apply now.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
