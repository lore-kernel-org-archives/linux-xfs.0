Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4HK8ouL239308 for <xfs@oss.sgi.com>; Thu, 17 May 2012 15:08:50 -0500
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 1l7O9FrHjpmx7WYc (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 17 May 2012 13:08:48 -0700 (PDT)
Date: Thu, 17 May 2012 22:08:31 +0200
From: Jan Kara <jack@suse.cz>
Subject: Are two transactions running in parallel OK?
Message-ID: <20120517200831.GB23231@quack.suse.cz>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: sandeen@redhat.com, dchinner@redhat.com

  Hello,

  I've been into a source of lockdep warning I got with XFS when testing my
filesystem freezing patches. The culprit seems to be that when doing direct
IO, XFS starts a transaction in xfs_setfilesize_trans_alloc() and attaches
that transaction to endio structure. Then it goes on and starts another
transaction in xfs_iomap_write_direct() which creates a possible deadlock
with filesystem freezing (if the second transaction start happens after we
start blocking new transactions, it gets blocked, but the first transaction
isn't ever completed).

So first I wanted to ask whether my analysis is correct. If yes, I was also
wondering whether this cannot cause a deadlock (at least in theory) if the
second transaction would block waiting for log space but we couldn't
possibly free enough of it due to the first transaction being held open?

If freezing deadlock is the only problem with this code, then I guess we
could avoid waiting for filesystem freezing when starting the second
transaction (although it might end up being rather ugly). Or if anyone else
has other idea how to solve this, I'm listening ;).

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
