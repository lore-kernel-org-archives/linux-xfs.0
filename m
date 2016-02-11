Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B7CE67CA2
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 09:13:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 914C58F8033
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 07:13:03 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id FtHTKnvAXTAT6yJv (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Feb 2016 07:13:01 -0800 (PST)
Date: Thu, 11 Feb 2016 07:13:01 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/8 v4] xfs: get rid of xfs_cluster_write
Message-ID: <20160211151301.GA13515@infradead.org>
References: <1455094043-9694-1-git-send-email-david@fromorbit.com>
	<20160210182538.GA7481@infradead.org>
	<20160210212550.GM14668@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160210212550.GM14668@dastard>
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

On Thu, Feb 11, 2016 at 08:25:51AM +1100, Dave Chinner wrote:
> I really like the idea, especially how using a bioset encapsulates
> the ioend and binds the life cycle to the bio. It also removes a
> heap of code, too.
> 
> We really do need some form of chaining here, though. If we don't,
> then we'll be doing unwritten extent of set file size transactions
> for ever 1MB bio completion instead of once for however large
> writepages can build an ioend.
> 
> I think this is definitely worth pursuing - are you going to get any
> time to work on this in the next couple of months, Christoph (i.e.
> to target the 4.7 merge window)?

Yes, I've just started working on this and would love to get it off
my table ASAP.  I was doing this ontop of your initial writeback
changes, so let me know if I should go back to that version, or
you think the last two patches will be ready in time as well?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
