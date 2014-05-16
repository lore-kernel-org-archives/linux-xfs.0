Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 393FB7F5F
	for <xfs@oss.sgi.com>; Fri, 16 May 2014 00:53:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 00261304051
	for <xfs@oss.sgi.com>; Thu, 15 May 2014 22:53:21 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id O1TXOKNziXjqj9a2 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 15 May 2014 22:53:20 -0700 (PDT)
Date: Thu, 15 May 2014 22:53:20 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] xfs: fixes for 3.15-rc6
Message-ID: <20140516055320.GA20975@infradead.org>
References: <20140516021144.GK5421@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140516021144.GK5421@dastard>
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

On Fri, May 16, 2014 at 12:11:44PM +1000, Dave Chinner wrote:
> Hi Linus,
> 
> Can you please pull the updates listed below? I found a bunch of
> error sign issues while determine what we need to do to rid XFS of
> this problem permanently. A couple of the bugs are in data integirty
> operations, a couple more are in the new COLLAPSE_RANGE code. One of
> these came in through a recent ext4 merge and so I had to update the
> base tree to 3.15-rc5 before fixing the issues.

Doesn't this miss the log roundin fix?

Linus said he is away for about a weeke anyway, while we're at it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
