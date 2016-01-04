Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D699C7F37
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 00:22:37 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C6347304032
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2016 22:22:34 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	RAZnCcMAw4YDrPAG for <xfs@oss.sgi.com>;
	Sun, 03 Jan 2016 22:22:32 -0800 (PST)
Date: Mon, 4 Jan 2016 17:22:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: lazytime implementation questions
Message-ID: <20160104062219.GB19802@dastard>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, ext4@vger.kernel.org

Hi folks,

I've been looking at implementing the lazytime mount option for XFS,
and I'm struggling to work out what it is supposed to mean.

AFAICT, on ext4, lazytime means that pure timestamp updates are not
journalled and they are only ever written back when the inode is
otherwise dirtied and written, or they are timestamp dirty for 24
hours which triggers writeback.

This poses a couple of problems for XFS:

	1. we log every timestamp change, so there is no mechanism
	   for delayed/deferred update.

	2. we track dirty metadata in the journal, not via the VFS
	   dirty inode lists, so all the infrastructure written for
	   ext4 to do periodic flushing is useless to us.

These are solvable problems, but what I'm not sure about is exactly
what the intended semantics of lazytime durability are. That is,
exactly what guaranteed are we giving userspace about timestamp
updates when lazytime is used? The guarantees we have to give will
greatly influence the XFS implementation, so I really need to nail
down what we are expected to provide userspace. Can we:

	a) just ignore all durability concerns?
	b) if not, do we only need to care about the 24 hour
	   writeback and unmount?
	c) if not, are fsync/sync/syncfs/freeze/unmount supposed
	   to provide durability of all metadata changes?
	d) do we have to care about ordering - if we fsync one inode
	   with 1 hour old timestamps, do we also need to guarantee
	   that all the inodes with older dirty timestamps also get
	   made durable?

I really want to completely ignore all ordering and forced
durability requirements for lazytime (i.e. implement only periodic,
optimistic and freeze/unmount writeback), but I haven't found any
documentation of what durability lazytime is supposed to provide and
can really only guess what was intended from the ext4
implementation....

Clarity would be appreciated.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
