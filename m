Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0C1L7BP205321 for <xfs@oss.sgi.com>; Wed, 11 Jan 2012 19:21:07 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id MKxCh2uDNZzh73HT for <xfs@oss.sgi.com>;
	Wed, 11 Jan 2012 17:21:06 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/4] Fix filesystem freezing
Date: Thu, 12 Jan 2012 02:20:49 +0100
Message-Id: <1326331253-6497-1-git-send-email-jack@suse.cz>
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

  filesystem freezing is currently racy and thus we can end up with dirty data
on frozen filesystem (see changelog of the first patch for detailed race
description and proposed fix). This patch series aims at fixing this. So far I
did basic testing using UML linux (running fsstress and bash-shared-mapping
while doing freeze - sync (to deadlock on leftover dirty pages) - unfreeze) and
I'm not able to trigger dirty pages on frozen filesystem anymore. I plan to do
more testing on real machine tomorrow. Surbhi, Kamal, you were able to
reproduce deadlocks due to dirty data as well so please test these patches out.
Thanks. Also review of patches is welcome.

								Honza

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
