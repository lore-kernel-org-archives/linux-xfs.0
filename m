Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 844987F93
	for <xfs@oss.sgi.com>; Mon,  4 Nov 2013 18:18:14 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 73A468F8052
	for <xfs@oss.sgi.com>; Mon,  4 Nov 2013 16:18:11 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	U6gemV7RAm20NfTL for <xfs@oss.sgi.com>;
	Mon, 04 Nov 2013 16:18:09 -0800 (PST)
Date: Tue, 5 Nov 2013 11:18:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 20/30] db: verify and calculate inode CRCs
Message-ID: <20131105001807.GT6188@dastard>
References: <1383107481-28937-1-git-send-email-david@fromorbit.com>
	<1383107481-28937-21-git-send-email-david@fromorbit.com>
	<20131104090551.GA23564@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131104090551.GA23564@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Nov 04, 2013 at 01:05:51AM -0800, Christoph Hellwig wrote:
> > +#define libxfs_dinode_verify		xfs_dinode_verify
> 
> Is there really any point in adding this libxfs renaming in new code?

Just following the convention used by all the other code...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
