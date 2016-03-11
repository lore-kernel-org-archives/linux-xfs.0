Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2BF097CA1
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 01:32:52 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F309C304043
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2016 23:32:48 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id EutBAyLqnHXrz3TR (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 10 Mar 2016 23:32:46 -0800 (PST)
Date: Thu, 10 Mar 2016 23:32:45 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/16] xfs: rmap btree add more reserved blocks
Message-ID: <20160311073245.GA709@infradead.org>
References: <1457410578-30233-1-git-send-email-david@fromorbit.com>
	<1457410578-30233-4-git-send-email-david@fromorbit.com>
	<20160310142207.GD29058@infradead.org>
	<20160310220945.GY30721@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160310220945.GY30721@dastard>
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

On Fri, Mar 11, 2016 at 09:09:45AM +1100, Dave Chinner wrote:
> The root btree blocks are not a fixed location. The moment the tree
> splits to the root we get a new root block and the old root is now
> at a lower level of the tree. IOWs, it doesn't matter if there is a
> hole at the time of growfs/mkfs laying out the initial tree roots
> because they are going to move around anyway.

Yeah, once we update the root it moves anyway.  Objection retracted..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
