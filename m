Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6EA1D7F3F
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 09:24:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5D7C48F8065
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 07:24:05 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id vItAxkum4cQzr8wV (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Oct 2014 07:24:04 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2 v2] Fix data corruption when blocksize < pagesize for
	mmapped data
Date: Fri, 10 Oct 2014 16:23:05 +0200
Message-Id: <1412951028-4085-1-git-send-email-jack@suse.cz>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

  Hello,

  this is a second version of the patches to fix data corruption in mmapped
data when blocksize < pagesize as tested by xfstests generic/030 test.
The patchset fixes XFS and ext4. I've checked and btrfs doesn't need fixing
because it doesn't support blocksize < pagesize. If that's ever going
to change btrfs will likely need a similar treatment. ocfs2, ext2, ext3 are
OK since they happily allocate blocks during writeback. For other filesystems
like gfs2, ubifs, nilfs, ceph,... I'm not sure whether they support blocksize <
pagesize at all. Interesting is also NFS which may care but I don't understand
its ->page_mkwrite() handler good enough to judge.

Changes since v1:
- changed helper function name and moved it to mm/truncate.c - I originally
  thought we can make the helper function update i_size to simplify the
  interface but it's actually impossible due to generic_write_end() lock
  ordering constraints.
- used round_up() instead of ALIGN()
- taught truncate_setsize() to use the helper function

								Honza

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
