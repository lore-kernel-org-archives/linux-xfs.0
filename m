Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56533 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751656AbdFVNb1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Jun 2017 09:31:27 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/11 v1] Fix inheritance of SGID in presence of default ACLs
Date: Thu, 22 Jun 2017 15:31:04 +0200
Message-Id: <20170622133115.16968-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Jan Kara <jack@suse.cz>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, reiserfs-devel@vger.kernel.org, Mike Marshall <hubcap@omnibond.com>, pvfs2-developers@beowulf-underground.org, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, cluster-devel@redhat.com, Bob Peterson <rpeterso@redhat.com>, linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>, linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>

Hello,

this patch set fixes a problem introduced by commit 073931017b49 "posix_acl:
Clear SGID bit when setting file permissions". The problem is that when new
directory 'DIR1' is created in a directory 'DIR0' with SGID bit set, DIR1 is
expected to have SGID bit set (and owning group equal to the owning group of
'DIR0'). However when 'DIR0' also has some default ACLs that 'DIR1' inherits,
setting these ACLs will result in SGID bit on 'DIR1' to get cleared if user is
not member of the owning group.

The problem is fixed by moving posix_acl_update_mode() so that it does not
get called when default ACLs are inherited.

I have created new generic/441 test for this and verified that generic/314,
generic/375, and generic/441 pass for ext2, ext4, btrfs, xfs, ocfs2, reiserfs.

All patches in this series are completely independent so fs maintainers please
pick them up as soon as they get reviewed. I'm leaving for three weeks of
vacation at the end of the week so I won't be able to push this further for
some time.

								Honza
