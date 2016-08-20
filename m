Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 78CF27CA2
	for <xfs@oss.sgi.com>; Sat, 20 Aug 2016 01:37:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D14F5AC003
	for <xfs@oss.sgi.com>; Fri, 19 Aug 2016 23:37:28 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id j0eZNvIIrWG9NFpj (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 19 Aug 2016 23:37:25 -0700 (PDT)
Date: Sat, 20 Aug 2016 08:37:23 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, RFC] xfs: remove i_iolock and use i_rwsem in the VFS
	inode instead
Message-ID: <20160820063723.GA7013@lst.de>
References: <1470935423-12329-1-git-send-email-hch@lst.de>
	<20160811215444.GY30192@twins.programming.kicks-ass.net>
	<20160818173707.GA1240@lst.de>
	<20160819132736.GH10121@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160819132736.GH10121@twins.programming.kicks-ass.net>
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
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Fri, Aug 19, 2016 at 03:27:36PM +0200, Peter Zijlstra wrote:
> Hurm, if you're going to directly use that maybe we should pick a better
> name ;-)

Fine with that.

> Also, be sure to check the debug_locks variable, if that's cleared the
> result of _lockdep_is_held() isn't reliable -- we stop tracking lock
> state when there's an error.

I already do.  But I'm wondering if we can't simply move the 
debug_locks check into lockdep_is_held?  It's already used directly
in a few places, and that would also solve the whole naming issue.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
