Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4ECrw7O220293 for <xfs@oss.sgi.com>; Thu, 14 May 2009 07:53:58 -0500
Received: from thunker.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F22601D32555
	for <xfs@oss.sgi.com>; Thu, 14 May 2009 05:54:05 -0700 (PDT)
Received: from thunker.thunk.org (thunk.org [69.25.196.29]) by cuda.sgi.com
	with ESMTP id N8OAxBEWK9G386WH for <xfs@oss.sgi.com>;
	Thu, 14 May 2009 05:54:05 -0700 (PDT)
Subject: Questions about xfstests regarding porting it to test ext4 filesystems
From: "Theodore Ts'o" <tytso@mit.edu>
Message-Id: <E1M4aRo-0000ri-0G@closure.thunk.org>
Date: Thu, 14 May 2009 08:54:04 -0400
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


I've been playing around with xfstests (aka xfsqa) and have some
questions:

1)  What is the best mailing list to use for discussions about xfstests? 
I'm *not* subscribed to xfs@oss.sgi.com, since I'm concerned about
traffic levels... I'm on too many high-volume mailing lists already.

2)  Why is the TESTDIR have to be a persistent xfs volume?   I noticed
that when testing UDF and NFS, the scratch volume is used (and $testdir
is set to the point at the scratch directory).   Is there some
fundamental reason why there must be an XFS volume mounted, even if the
fundamental intention is to test some other filesystem type, whether
it's UDF, NFS, or Ext4?

3) How much latitude/interest is there in modifying xfstests to be a bit
more filesystem independent?  I understand the primary purpose of
xfstests has to be to support XFS development, but looking at the
scripts, there is a *huge* amount of XFS-specific assumptions all over
the shell scripts.  As a result I'm still of two minds whether it will
be less work to start from scratch to develop a test suite for ext4 (and
from the beginning try to make it filesystem independent) or to try to
hack xfstests and try to make it more filesystem indpendent.  A lot of
this depends on the time/interest with the xfstests upstream in working
with me.  (And assuming we get the licensing issues dealt with --- hence
my interest and time spent in trying to clarify the licensing situation
with the fsx program.)   

If there isn't a whole lot of interest in trying to make xfstests more
portable, that's fine.  It may be that I'm better off starting from
scratch.  There does seem to be a lot of work and experience represented
in the xfstest suite, though, so I would like to try exploring the
possibility of expanding its scope to also support testing other
filesystems (such as ext4, btrfs, etc.)

(I'm not on the xfs mailing list, so please keep me cc'ed, thanks.)

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
