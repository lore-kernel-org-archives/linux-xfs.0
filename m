Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB4CW7Rl026865 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 06:32:08 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2F5651695450
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2008 04:32:07 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id f7vk1HhxuK0Y8aNb for
	<xfs@oss.sgi.com>; Thu, 04 Dec 2008 04:32:07 -0800 (PST)
Date: Thu, 4 Dec 2008 07:32:06 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.27.7 vanilla, project quota enabled and process stuck in D
	state (repeatable every time)
Message-ID: <20081204123206.GA6935@infradead.org>
References: <200812021949.55463.arekm@maven.pl>
	<200812031406.41882.arekm@maven.pl>
	<20081203213028.GW18236@disturbed>
	<200812032242.29326.arekm@maven.pl>
	<20081203220934.GA32301@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081203220934.GA32301@disturbed>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Arkadiusz Miskiewicz <arekm@maven.pl>, xfs@oss.sgi.com

On Thu, Dec 04, 2008 at 09:09:34AM +1100, Dave Chinner wrote:
> Is that the unlock of the inodes is using the incorrect lock
> type for the unlock, (inodes lock XFS_ILOCK_EXCL, unlocked XFS_ILOCK_SHARED)
> which means they don't get unlocked and the next attempt to do anything
> with those inodes will hang.
> 
> Compile-tested-only patch below that should fix the problem.

Yeah, that also explains why my patch fixes it :)  I'd say let's put
yours into 2.6.28 and -stable, and I'll rediff mine ontop for the 2.6.29
queue.  I'll also write a testcase for xfsqa based on Arkadiusz's
report.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
