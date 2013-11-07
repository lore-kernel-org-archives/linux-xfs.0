Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6AFA029E04
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 06:02:02 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 55034304053
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 04:01:59 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 8kq6WukqO4ejq4Bl (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 07 Nov 2013 04:01:58 -0800 (PST)
Date: Thu, 7 Nov 2013 04:01:57 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfstest failures
Message-ID: <20131107120157.GA4683@infradead.org>
References: <20131106105451.GA31283@infradead.org>
	<20131106194417.GF6188@dastard>
	<20131107082234.GA30243@infradead.org>
	<20131107115722.GB11434@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131107115722.GB11434@dastard>
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

On Thu, Nov 07, 2013 at 10:57:22PM +1100, Dave Chinner wrote:
> Actually, it doesn't. v4 configs give the same notrun output, which
> is wrong but doesn't result in a failure (hence I didn't notice it).
> Now that you've reported it I've just found a bug in the
> _requires_attr_v1 function that makes it always fail and notrun the
> test....

It fails for me running latests xfstests, latest xfsprogs an latest xfs
tree in a x86 VM running the default mkfs options.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
