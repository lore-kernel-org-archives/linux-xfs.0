Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9D5EF7CB0
	for <xfs@oss.sgi.com>; Thu,  3 Mar 2016 06:40:05 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 11678AC004
	for <xfs@oss.sgi.com>; Thu,  3 Mar 2016 04:40:01 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id x45AqlQVdrVZfwHC (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 03 Mar 2016 04:40:00 -0800 (PST)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/4] only run torn log write detection on dirty logs
Date: Thu,  3 Mar 2016 07:39:54 -0500
Message-Id: <1457008798-58734-1-git-send-email-bfoster@redhat.com>
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
To: xfs@oss.sgi.com
Cc: Jan Beulich <JBeulich@suse.com>

Hi all,

This series addresses a problem reported by Jan Beulich here:

  http://oss.sgi.com/pipermail/xfs/2016-February/047302.html

The problem in this particular x86 vs. x86-64 case is that the size of
some of the log data structures change due to padding (e.g., struct
xlog_rec_header). The more general problem is that torn log write
detection unconditionally scans behind an unmount record on a cleanly
mounted filesystem, and thus can trip over log data that might not have
been written by the currently running system.

The solution implemented here is to limit torn write detection to when
the log is dirty. Patches 1-3 refactor the existing code into some new
helpers such that torn write detection can be made conditional. Patch 4
reorders the head/tail discovery logic to check for an unmount record at
the head of the log and run torn write detection only when one is not
present.

This survives xfstests on x86-64, x86 and ppc64 boxes. I've also run the
log test group against a test volume that was preserved and passed back
and forth across all three of the aforementioned arches without a
problem. Thoughts, reviews, flames appreciated.

Brian

Brian Foster (4):
  xfs: separate log head record discovery from verification
  xfs: refactor unmount record detection into helper
  xfs: refactor in-core log state update to helper
  xfs: only run torn log write detection on dirty logs

 fs/xfs/xfs_log_recover.c | 271 +++++++++++++++++++++++++++++------------------
 1 file changed, 168 insertions(+), 103 deletions(-)

-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
