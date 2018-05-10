Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:33596 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965410AbeEJP2v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 May 2018 11:28:51 -0400
Subject: [PATCH v3 00/14] xfs-4.18: quota refactor
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 10 May 2018 08:28:45 -0700
Message-ID: <152596612549.27525.9876256551560849585.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, hch@lst.de

Hi all,

Here's a series to refactor and clean out the incohesive mess that
xfs_qm_dqget has become.  I'm reposting this per Christoph request
since the v2 thread became very hairy and disorganized.

I've distinguished three contexts in which dqget can be called, and
converted them into separate externally visible interfaces --
_qm_dqget_next, which returns the first initialized dquot with an id at
least as high as the id passed in; _qm_dqget_inode, which returns the
dquot for a given (inode, type); and so _qm_dqget now only returns the
dquot for a given (id, type).  I removed unused parameters from the
dqattach functions, renamed _qm_dqiterate (since it now only knows how
to zap dquot counters during quotacheck), and added a real function to
iterate all dquots of a given type.  I also re-hid _qm_dqread in favor
of a new _qm_dqget_uncached which has a better description of why we
bypass the dquot cache.

This means that all _dqget variants no longer take QMOPT flags, and
QMOPT_NEXT is gone.  XFS_QMOPT_DQALLOC is now a boolean and can
only be specified for functions where it makes sense.

This whole thing will be in for-next tomorrow, with any luck.

--D
