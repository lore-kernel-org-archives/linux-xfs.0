Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 90FC77FF2
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 07:15:04 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7BFCC8F8065
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 05:15:01 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id C7cN7hUORH2gN69y (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 14 Feb 2013 05:15:00 -0800 (PST)
Date: Thu, 14 Feb 2013 14:14:52 +0100
From: Jan Kara <jack@suse.cz>
Subject: XFS slow when project quota exceeded (again)
Message-ID: <20130214131452.GB605@quack.suse.cz>
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
Cc: dchinner@redhat.com

  Hi,

  this is a follow up on a discussion started here:
http://www.spinics.net/lists/xfs/msg14999.html

To just quickly sum up the issue: 
When project quota gets exceeded XFS ends up flushing inodes using
sync_inodes_sb(). I've tested (in 3.8-rc4) that if one writes 200 MB to a
directory with 100 MB project quota like:
	fd = open(argv[1], O_WRONLY | O_CREAT | O_TRUNC, 0644);
	for (i = 0; i < 50000; i++)
		pwrite(fd, buf, 4096, i*4096);
it takes about 3 s to finish, which is OK. But when there are lots of
inodes cached (I've tried with 10000 inodes cached on the fs), the same
test program runs ~140 s. This is because sync_inodes_sb() iterates over
all inodes in superblock and waits for IO and this iteration eats CPU
cycles.

One can argue that sync_inodes_sb() should be optimized but it isn't that
easy because it is a data integrity operation and we have to be sure that
even IO which has been submitted before sync_inodes_sb() is called is
finished by the time it returns.

So another POV is that it is an overkill to call data integrity operation
in a place which just needs to make sure IO is submitted so that delalloc
uncertainty is reduced. The comment before xfs_flush_inodes() says that
sync_inodes_sb() is used to throttle multiple callers to the rate at which
IO is completing. I wonder - why is that needed? Delalloc blocks are
allocated already at IO submission time so it should be enough to wait for
IO submission to happen? And writeback_inodes_sb() does that. Changelog of
the commit changing xfs_flush_inodes() to use sync_inodes_sb() claims that
if writeback_inodes_sb() is used, premature ENOSPC can happen. But I wonder
why is that the case when writeback_inodes_sb() waits for IO submission to
happen and thus for extent conversion? Isn't sync_inodes_sb() just papering
over some other problem?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
