Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0E0807F3F
	for <xfs@oss.sgi.com>; Thu,  7 Jan 2016 09:25:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F30C88F8052
	for <xfs@oss.sgi.com>; Thu,  7 Jan 2016 07:25:45 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id A17UjLfsSTn3k30W (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 07 Jan 2016 07:25:43 -0800 (PST)
Date: Thu, 7 Jan 2016 16:25:42 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] xfs: cancel COW in xfs_cancel_ioend
Message-ID: <20160107152541.GA16982@lst.de>
References: <1451822873-12969-1-git-send-email-hch@lst.de>
	<1451822873-12969-4-git-send-email-hch@lst.de>
	<20160105014310.GK28330@birch.djwong.org>
	<20160105104214.GA16310@infradead.org>
	<20160107003227.GB8015@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160107003227.GB8015@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

On Wed, Jan 06, 2016 at 04:32:27PM -0800, Darrick J. Wong wrote:
> Ok.  I spent a couple of days trying to find all the places where we need to
> delete CoW reservations (hole punch, truncate, etc.) and found some places
> where the code was leaving reservations behind in the CoW fork (most notable
> truncate).  I also made the inode eviction code purge any CoW leftovers, so
> that should all go away.

Can you send that part out for NFS testing?

> I also wrote some more xfstests that try to hit all the CoW-cancelling code
> paths (fpunch, fzero, fcollapse, finsert, truncate, -EIO) to smoke test all
> that.  By the way, do you have a testcase handy for the "non-blocking writeback
> EAGAIN" case?  I'm guessing that we could hit that pretty easily by lowering
> dirty_background_* and dirtying a lot of pages while reflinking?

I did hit it pretty easily testing over NFS to a local nfs server with
xfstests.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
