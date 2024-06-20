Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72803639
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 07:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718868112; cv=none; b=G7MNWCa+n6IvPPbNCWd78ij9/7eZUIAMieMo6tH8pdFvZ4fhtGh1wb9Qh9zmqZwUpmf4t07IQ8Ru5Lr8HTaacVrIvsnuwNKCXmmfh5FkLkrShYyYeLcE3cSqva6us4KVLF8/0B1139nQ8lfvJAJMuQC69MyBUWZcBdFrFvGIbbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718868112; c=relaxed/simple;
	bh=X/fncuBPeYOLW95rZ7ffVZpkqn9pANfQGW6zo/IY52w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DxinjsDAYJBiLO0JpVVeY04ftQ2IdPWH3Vvy3kK0ke6H5MakoNRsbpJmzktJOXC1ueymgNOQ0M6JphY9cs4quoe+z5vfeMKsEhJnP1qF2xNQRBO657hoFIvJlDdwNGOZK5of+Yo87JrfFLfX1d1LTbFWdta9PPy18YrhtJf2MpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nuyDqTGD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nuyDqTGD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=P30xvcLdecknx03mvyYQ6fLlBqrm+XsjvGsrFbuECzA=; b=nuyDqTGDiryGTWODWybeOxvf2s
	gooElv6yJ4flU6K0Cb9oxOWY2wsCwcRR8vADBjZyJi5rjHaLjwPIr5Y2AYOCCVmgHv+49dQ9uUKk7
	+mg5TQprj3JUq/gfUHatgD+tK0XPlS5kFpQdXFfUVReW1XM4pePHr6afab/jTTmj6/RlU5eU0B8NC
	TXUuc3PewACJxanCtlstnNJ5qnNtzEprlV23CnAUdm8A6Dd99fdfogCH0tuoBNSo35d4S61rAUklz
	Qamj5YaBSrEQbJ6Ef6TPRPxiyo9tXpSMBb8rCGtYOo51yG0k+R5055Wvxf33V+8/T6U3tV3YODHwZ
	HwtYciYg==;
Received: from 2a02-8389-2341-5b80-3a9c-dc0d-9615-f1ed.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3a9c:dc0d:9615:f1ed] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKC7C-00000003xXU-20HC;
	Thu, 20 Jun 2024 07:21:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: xfs: byte-based grant head reservation tracking v4
Date: Thu, 20 Jun 2024 09:21:17 +0200
Message-ID: <20240620072146.530267-1-hch@lst.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

[Note: I've taken over from Dave on this to push it over the finish line]

One of the significant limitations of the log reservation code is
that it uses physical tracking of the reservation space to account
for both the space used in the journal as well as the reservations
held in memory by the CIL and active running transactions. Because
this in-memory reservation tracking requires byte-level granularity,
this means that the "LSN" that the grant head stores it's location
in is split into 32 bits for the log cycle and 32 bits for the grant
head offset into the log.

Storing a byte count as the grant head offset into the log means
that we can only index 4GB of space with the grant head. This is one
of the primary limiting factors preventing us from increasing the
physical log size beyond 2GB. Hence to increase the physical log
size, we have to increase the space available for storing the grant
head.

Needing more physical space to store the grant head is an issue
because we use lockless atomic accounting for the grant head to
minimise the overhead of new incoming transaction reservations.
These have unbound concurrency, and hence any lock in the
reservation path will cause serious scalability issues. The lockless
accounting fast path was the solution to these scalability problems
that we had over a decade ago, and hence we know we cannot go back
to a lock based solution.


The simplest way I can describe how we track the log space is
as follows:

   l_tail_lsn           l_last_sync_lsn         grant head lsn
	|-----------------------|+++++++++++++++++++++|
	|    physical space     |   in memory space   |
	| - - - - - - xlog_space_left() - - - - - - - |

It is simple for the AIL to track the maximum LSN that has been
inserted into the AIL. If we do this, we no longer need to track
log->l_last_sync_lsn in the journal itself and we can always get the
physical space tracked by the journal directly from the AIL. The AIL
functions can calculate the "log tail space" dynamically when either
the log tail or the max LSN seen changes, thereby removing all need
for the log itself to track this state. Hence we now have:

   l_tail_lsn           ail_max_lsn_seen        grant head lsn
	|-----------------------|+++++++++++++++++++++|
	|    log->l_tail_space  |   in memory space   |
	| - - - - - - xlog_space_left() - - - - - - - |

And we've solved the problem of efficiently calculating the amount
of physical space the log is consuming. All this leaves is now
calculating how much space we are consuming in memory.

Luckily for us, we've just added all the update hooks needed to do
this. From the above diagram, two things are obvious:

1. when the tail moves, only log->l_tail_space reduces
2. when the ail_max_lsn_seen increases, log->l_tail_space increases
   and "in memory space" reduces by the same amount.

IOWs, we now have a mechanism that can transfer the in-memory
reservation space directly to the on-disk tail space accounting. At
this point, we can change the grant head from tracking physical
location to tracking a simple byte count:

   l_tail_lsn           ail_max_lsn_seen        grant head bytes
   	|-----------------------|+++++++++++++++++++++|
	|    log->l_tail_space  |     grant space     |
	| - - - - - - xlog_space_left() - - - - - - - |

and xlog_space_left() simply changes to:

space left = log->l_logsize - grant space - log->l_tail_space;

All of the complex grant head cracking, combining and
compare/exchange code gets replaced by simple atomic add/sub
operations, and the grant heads can now track a full 64 bit bytes
space. The fastpath reservation accounting is also much faster
because it is much simpler.

There's one little problem, though. The transaction reservation code
has to set the LSN target for the AIL to push to ensure that the log
tail keeps moving forward (xlog_grant_push_ail()), and the deferred
intent logging code also tries to keep abreast of the amount of
space available in the log via xlog_grant_push_threshold().

The AIL pushing problem is actually easy to solve - we don't need to
push the AIL from the transaction reservation code as the AIL
already tracks all the space used by the journal. All the
transaction reservation code does is try to keep 25% of the journal
physically free, and there's no reason why the AIL can't do that
itself.

Hence before we start changing any of the grant head accounting, we
remove all the AIL pushing hooks from the reservation code and let
the AIL determine the target it needs to push to itself. We also
allow the deferred intent logging code to determine if the AIL
should be tail pushing similar to how it currently checks if we are
running out of log space, so the intent relogging still works as it
should.

With these changes in place, there is no external code that is
dependent on the grant heads tracking physical space, and hence we
can then implement the change to pure in-memory reservation space
tracking in the grant heads.....

This all passes fstests for default and rmapbt enabled configs.
Performance tests also show good improvements where the transaction
accounting is the bottleneck.

Changes since v3:
 - fix all review comments (Dave)
 - add a new patch to skip flushing AIL items (Dave)
 - rework XFS_AIL_OPSTATE_PUSH_ALL handling (Dave)
 - misc checkpath and minor coding style fixups (Christoph)
 - clean up the grant head manipulation helpers (Christoph)
 - rename the sysfs files so that xfstests can autodetect the new format
   (Christoph)
 - fix the contact address for xfs sysfs ABI entries (Christoph)

Changes since v2:
  - rebase on 6.6-rc2 + linux-xfs/for-next
  - cleaned up static warnings from build bot.
  - fixed comment about minimum AIL push target.
  - fixed whitespace problems in multiple patches.

Changes since v1:
  - https://lore.kernel.org/linux-xfs/20220809230353.3353059-1-david@fromorbit.com/
  - reorder moving xfs_trans_bulk_commit() patch to start of series
  - fix failure to consider NULLCOMMITLSN push target in AIL
  - grant space release based on ctx->start_lsn fails to release the space used in
    the checkpoint that was just committed. Release needs to be based on
    ctx->commit_lsn which is the end of the region that the checkpoint consumes in
    the log

Diffstat:
 Documentation/ABI/testing/sysfs-fs-xfs |   26 -
 fs/xfs/libxfs/xfs_defer.c              |    4 
 fs/xfs/xfs_inode.c                     |    1 
 fs/xfs/xfs_inode_item.c                |    6 
 fs/xfs/xfs_log.c                       |  511 +++++++--------------------------
 fs/xfs/xfs_log.h                       |    1 
 fs/xfs/xfs_log_cil.c                   |  177 +++++++++++
 fs/xfs/xfs_log_priv.h                  |   61 +--
 fs/xfs/xfs_log_recover.c               |   23 -
 fs/xfs/xfs_sysfs.c                     |   29 -
 fs/xfs/xfs_trace.c                     |    1 
 fs/xfs/xfs_trace.h                     |   42 +-
 fs/xfs/xfs_trans.c                     |  129 --------
 fs/xfs/xfs_trans.h                     |    4 
 fs/xfs/xfs_trans_ail.c                 |  244 ++++++++-------
 fs/xfs/xfs_trans_priv.h                |   44 ++
 16 files changed, 552 insertions(+), 751 deletions(-)
