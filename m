Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7FDtRrF085603 for <xfs@oss.sgi.com>; Mon, 15 Aug 2011 08:55:27 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6BF62304059
	for <xfs@oss.sgi.com>; Mon, 15 Aug 2011 06:55:27 -0700 (PDT)
Received: from augusta (augusta.americas.sgi.com [128.162.233.117])
	by estes.americas.sgi.com (Postfix) with ESMTP id 5D1477000706
	for <xfs@oss.sgi.com>; Mon, 15 Aug 2011 08:55:27 -0500 (CDT)
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH v3 0/7] xfsdump: convert to using the POSIX signal API
Date: Mon, 15 Aug 2011 08:54:59 -0500
Message-Id: <1313416506-3666-1-git-send-email-wkendall@sgi.com>
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
To: xfs@oss.sgi.com


Changes from v2:

[v3 3/7] xfsdump: remove SIGCHLD handling
    - Explicitly ignore SIGCHLD. This has the benefit of causing
      any librmt rsh sessions that exit early to be reaped
      automatically.

[v3 4/7] xfsdump: rework dialog timeout and EINTR reliance
    - Add 'volatile' qualifier to 'dlog_signo_received' and
      'dlog_allowed_flag', which are set in signal handlers,
      to prevent compiler from optimizing them out from being
      checked during a loop.
    - Add an ASSERT(dlog_allowed_flag) to dlog_string_query()
      to be consistent with other callers of promptinput().

[v3 6/7] xfsdump: convert to the POSIX signal API
    - Move struct sigaction declaration to top of block.


Changes from v1:

[v2 1/7] xfsdump: remove conditional OPENMASKED code
    - No changes since v1.

[v2 2/7] xfsdump: process EPIPE instead of catching SIGPIPE
    - Minor change to ignore SIGPIPE in one location rather
      than separately for the miniroot and !miniroot cases.

[v2 3/7] xfsdump: remove SIGCHLD handling
    - No changes since v1.

[v2 4/7] xfsdump: rework dialog timeout and EINTR reliance
    - New patch to cleanup signal handling in dialog code.
      No longer use alarm() and don't depend on a particular
      thread receiving a signal to break out of a blocking
      read().

[v2 5/7] xfsdump: rework dialog to use main signal handler
    - New patch to avoid swapping signal handlers when
      entering a dialog.

[v2 6/7] xfsdump: convert to the POSIX signal API
    - Was patch #4 from v1 series. Essentially the same,
      but changes in dlog.c are simpler since the signal
      handler doesn't get swapped.

[v2 7/7] xfsdump: refactor inventory session creation
    - New patch to make it obvious that the signal mask
      is properly restored after creating the inventory.


This patch series converts xfsdump from using the System V signal
API to using the POSIX API. The first 3 patches remove/rework some
of the existing signal code, and the final patch does the actual
conversion.

The primary motivatation for this change is a currently unused
section of code in xfsdump's main():

    /* sleep until next signal
     */
    sigrelse(SIGINT);
    sigrelse(SIGHUP);
    ...
    sigpause(SIGARLM);

The intention is to wake up if any of the signals is received, but
this will only wake up if SIGALRM is received. Using sigsuspend()
with the appropriate mask fixes the issue.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
