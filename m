Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 11B417CA0
	for <xfs@oss.sgi.com>; Fri, 19 Aug 2016 08:27:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BBEDD8F8033
	for <xfs@oss.sgi.com>; Fri, 19 Aug 2016 06:27:41 -0700 (PDT)
Received: from merlin.infradead.org (merlin.infradead.org [205.233.59.134]) by
	cuda.sgi.com with ESMTP id oEapYHjMmBy17mpB (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 19 Aug 2016 06:27:39 -0700 (PDT)
Date: Fri, 19 Aug 2016 15:27:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH, RFC] xfs: remove i_iolock and use i_rwsem in the VFS
	inode instead
Message-ID: <20160819132736.GH10121@twins.programming.kicks-ass.net>
References: <1470935423-12329-1-git-send-email-hch@lst.de>
	<20160811215444.GY30192@twins.programming.kicks-ass.net>
	<20160818173707.GA1240@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160818173707.GA1240@lst.de>
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

On Thu, Aug 18, 2016 at 07:37:07PM +0200, Christoph Hellwig wrote:
> On Thu, Aug 11, 2016 at 11:54:44PM +0200, Peter Zijlstra wrote:
> > Sure, find below. Not been near a compiler.
> 
> It has now.  Below are the additions I need, and things seem to be
> passing fine with that.
> 
> Note that to fit the existing XFS lock asserts I'm using
> _lockdep_is_held directly instead of lockdep_assert_held_exclusive.
> All the exports are there, but I'm just trying to make sure you're
> not going to shout at me for that later :)

Hurm, if you're going to directly use that maybe we should pick a better
name ;-)

Also, be sure to check the debug_locks variable, if that's cleared the
result of _lockdep_is_held() isn't reliable -- we stop tracking lock
state when there's an error.

Thanks!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
