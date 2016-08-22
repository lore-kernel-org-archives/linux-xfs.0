Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 50D057CA0
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2016 03:35:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C4C96AC002
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2016 01:35:03 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id GbmXN7BAMWZ7tbyR (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 22 Aug 2016 01:35:01 -0700 (PDT)
Date: Mon, 22 Aug 2016 10:34:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH, RFC] xfs: remove i_iolock and use i_rwsem in the VFS
	inode instead
Message-ID: <20160822083455.GH10153@twins.programming.kicks-ass.net>
References: <1470935423-12329-1-git-send-email-hch@lst.de>
	<20160811215444.GY30192@twins.programming.kicks-ass.net>
	<20160818173707.GA1240@lst.de>
	<20160819132736.GH10121@twins.programming.kicks-ass.net>
	<20160820063723.GA7013@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160820063723.GA7013@lst.de>
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

On Sat, Aug 20, 2016 at 08:37:23AM +0200, Christoph Hellwig wrote:
> On Fri, Aug 19, 2016 at 03:27:36PM +0200, Peter Zijlstra wrote:
> > Hurm, if you're going to directly use that maybe we should pick a better
> > name ;-)
> 
> Fine with that.
> 
> > Also, be sure to check the debug_locks variable, if that's cleared the
> > result of _lockdep_is_held() isn't reliable -- we stop tracking lock
> > state when there's an error.
> 
> I already do.  But I'm wondering if we can't simply move the 
> debug_locks check into lockdep_is_held?  It's already used directly
> in a few places, and that would also solve the whole naming issue.

Reason I didn't do that initially was that I used lock_is_held() for
both positive and negative tests (ie. assert a lock is held and a lock
is not held). Given that, you cannot pick a right return value when
!debug_locks.

Not sure we still do that, but I distinctly remember running into that
when I did as you suggest now. But that was many years ago.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
