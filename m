Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0KKZ2ae125579 for <xfs@oss.sgi.com>; Fri, 20 Jan 2012 14:35:03 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id wehvith4UZ5zdjqV for <xfs@oss.sgi.com>;
	Fri, 20 Jan 2012 12:35:01 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/8] Fix filesystem freezing
Date: Fri, 20 Jan 2012 21:34:38 +0100
Message-Id: <1327091686-23177-1-git-send-email-jack@suse.cz>
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
To: linux-fsdevel@vger.kernel.org
Cc: Surbhi Palande <csurbhi@gmail.com>, Kamal Mostafa <kamal@canonical.com>, Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dchinner@redhat.com>, linux-ext4@vger.kernel.org


  Hello,

  This is the second iteration of my patches to improve filesystem freezing.
Filesystem freezing is currently racy and thus we can end up with dirty data
on frozen filesystem (see changelog of the first patch for detailed race
description and proposed fix). This patch series aims at fixing this.

The biggest changes since v1:
  * have two counters to provide safe state transitions for SB_FREEZE_WRITE
    and SB_FREEZE_TRANS states
  * use percpu counters instead of own percpu structure
  * added documentation fixes from the old fs freezing series
  * converted XFS to use SB_FREEZE_TRANS counter instead of its private
    m_active_trans counter

Now I'm sending this mostly as a heads up so that people see current state
because these patches are still racy. The problem is that when superblock is in
SB_FREEZE_WRITE state inodes can still be dirtied (e.g. through touch_atime,
directory operations or similar). These inodes then are not flushed and when
superblock passes to SB_FREEZE_TRANS state, flusher thread deadlocks on trying
to flush them.

To fix this, we will have to block also operations dirtying inodes already
in SB_FREEZE_WRITE state. I'm now looking into how to do this in the easiest
way.

								Honza

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
