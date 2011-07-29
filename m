Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6TKebOI066909 for <xfs@oss.sgi.com>; Fri, 29 Jul 2011 15:40:37 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 001D28F8078
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2011 13:40:33 -0700 (PDT)
Received: from augusta (augusta.americas.sgi.com [128.162.233.117])
	by estes.americas.sgi.com (Postfix) with ESMTP id D4B9470006F8
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2011 15:40:33 -0500 (CDT)
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH 0/4] xfsdump: convert to using the POSIX signal API
Date: Fri, 29 Jul 2011 15:40:07 -0500
Message-Id: <1311972011-1446-1-git-send-email-wkendall@sgi.com>
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
