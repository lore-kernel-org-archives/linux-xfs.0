Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CE2757F51
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 17:00:40 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AA0AA8F804C
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 15:00:40 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	A4eMteNLYFu0LzNG for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 15:00:39 -0800 (PST)
Date: Fri, 13 Dec 2013 10:00:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/10] xfstests: fix generic/225 to check fiemap support
Message-ID: <20131212230037.GL10988@dastard>
References: <1386706321-15795-1-git-send-email-jayr@google.com>
	<1386706321-15795-7-git-send-email-jayr@google.com>
	<20131211074657.GF19248@infradead.org>
	<20131211224229.GK10988@dastard>
	<20131212180144.GB19422@infradead.org>
	<CAFA30n_-s1uMeQ0k2EoawY4NzMSiqkH+tHze9rASej2RoM_TjA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAFA30n_-s1uMeQ0k2EoawY4NzMSiqkH+tHze9rASej2RoM_TjA@mail.gmail.com>
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
To: Junho Ryu <jayr@google.com>
Cc: Christoph Hellwig <hch@infradead.org>, tytso@mit.edu, Hugh Dickins <hughd@google.com>, Boris Ranto <branto@redhat.com>, xfs@oss.sgi.com

On Thu, Dec 12, 2013 at 02:44:47PM -0800, Junho Ryu wrote:
> >> I'd just rename if _require_fiemap, because we need both xfs_io and
> >> kernel support for it, and we need xfs_io support to check for
> >> kernel support....
> >
> > Fine with me.
> 
> There are 3 more _require_xfs_io_.* functions. I can create another
> patch if you want these names to be consistent.
> 
> _require_xfs_io_falloc()
> _require_xfs_io_falloc_punch()

yes, those 2 can be changed similar to _requires_fiemap

> _require_xfs_io_zero()

That one is only testing for xfs_io command support, so it should
remain the way it is...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
