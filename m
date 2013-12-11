Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F3BD67F4E
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 16:42:33 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8C931AC00B
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 14:42:33 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	vheQNoA76eRyzH5z for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 14:42:31 -0800 (PST)
Date: Thu, 12 Dec 2013 09:42:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/10] xfstests: fix generic/225 to check fiemap support
Message-ID: <20131211224229.GK10988@dastard>
References: <1386706321-15795-1-git-send-email-jayr@google.com>
	<1386706321-15795-7-git-send-email-jayr@google.com>
	<20131211074657.GF19248@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131211074657.GF19248@infradead.org>
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
Cc: Junho Ryu <jayr@google.com>, hughd@google.com, tytso@mit.edu, branto@redhat.com, xfs@oss.sgi.com

On Tue, Dec 10, 2013 at 11:46:57PM -0800, Christoph Hellwig wrote:
> On Tue, Dec 10, 2013 at 12:11:57PM -0800, Junho Ryu wrote:
> > generic/225 runs fiemap.  It would be nice to call
> > _require_xfs_io_fiemap like other tests which use fiemap.
> 
> It's not exactly correct as it doesn't require xfs_io.  If you have some
> spare cycles it would be good to factor out a _require_fiemap from it.

I'd just rename if _require_fiemap, because we need both xfs_io and
kernel support for it, and we need xfs_io support to check for
kernel support....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
