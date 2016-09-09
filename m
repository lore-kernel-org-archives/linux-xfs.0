Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B1CA87CA1
	for <xfs@oss.sgi.com>; Fri,  9 Sep 2016 03:44:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6B6C78F8035
	for <xfs@oss.sgi.com>; Fri,  9 Sep 2016 01:44:54 -0700 (PDT)
Received: from merlin.infradead.org (merlin.infradead.org [205.233.59.134]) by
	cuda.sgi.com with ESMTP id nIHt84v34kBc0xS4 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 09 Sep 2016 01:44:52 -0700 (PDT)
Date: Fri, 9 Sep 2016 10:44:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH, RFC] xfs: remove i_iolock and use i_rwsem in the VFS
	inode instead
Message-ID: <20160909084450.GF10153@twins.programming.kicks-ass.net>
References: <1470935423-12329-1-git-send-email-hch@lst.de>
	<20160811234335.GX16044@dastard> <20160812025026.GA975@lst.de>
	<20160812095813.GZ16044@dastard> <20160905151529.GB16726@lst.de>
	<20160907214536.GQ30056@dastard> <20160909083306.GA19964@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160909083306.GA19964@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Fri, Sep 09, 2016 at 10:33:06AM +0200, Christoph Hellwig wrote:
> On Thu, Sep 08, 2016 at 07:45:36AM +1000, Dave Chinner wrote:
> > It's a semaphore, not a mutex. Semaphore locking is independent of
> > task context, the lock follows the object it protects, not the task
> > that took the lock. i.e. Lockdep is wrong to assume the "owner" of a
> > rw_sem will not change between lock and unlock.
> 
> That's not the case - rw_semaphores had strict owner semanics for a
> long time (although I wish we could get rid of that for a different
> reason..).

Do tell; note however that due to the strict write owner, we can do
things like the optimistic spinning which improved writer->writer
performance significantly.

Also note that !owner locks create problems for RT.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
