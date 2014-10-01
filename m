Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B89EF7F76
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 14:31:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9EBF38F8054
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 12:31:47 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 4q0IMDds8NXLSD7I (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Oct 2014 12:31:43 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/12 RFC] Moving i_dquot out of struct inode
Date: Wed,  1 Oct 2014 21:31:22 +0200
Message-Id: <1412191894-9113-1-git-send-email-jack@suse.cz>
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
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com

  Hello,

  this patch set moves i_dquot array from struct inode into filesystem private
part of the inode. Thus filesystems which don't need it save 2 pointers in
their inodes (would be 3 after we add project quota support into generic
quota).

I have patches to move inode->i_data.private_list into filesystem private part
of the inode which is going to save another 2 pointers using the same
mechanism. However I didn't want to mix those in.

The patch series also contains a change to quotactl so that each filesystem
can set quota types it supports. This is in the end unrelated change
(originally it was necessary for i_dquot moving but in the end I changed
things so that it's not anymore). I can move that into a separate series
but I was somewhat reluctant to do that since that would mean another 6
one-line patches to the same files we are changing here...

Comments are welcome.

								Honza

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
