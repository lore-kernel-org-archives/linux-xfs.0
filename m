Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4688129DFA
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 22:09:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D7222AC00C
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 20:09:13 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	TZ7H4TCGAnxjTXYp for <xfs@oss.sgi.com>;
	Tue, 28 Oct 2014 20:09:10 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] repair: fix AGFL rebuild problem
Date: Wed, 29 Oct 2014 14:09:02 +1100
Message-Id: <1414552144-12627-1-git-send-email-david@fromorbit.com>
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
Cc: bvowk@box.com

Hi folks,

The following two patches fix a repair rebuild issue that was
reported to me. xfs_repair would appear to succeed, but subsequent
runs would report a freespace mismatch and then on mount trigger
a corruption error on the first allocation from AG 0.

The problem as that the AGFL was not being correctly rebuilt due to
a very particular freespace pattern in AG 0 which required free
blocks in the AGFL to populate an empty AGFL. reapir silently
ignored this error, so it triggered allocation corruption errors
when the same AGFL fixup attempt failed on a mounted filesystem.

The fix is relatively straight forward, as is the fixes to the
tracing code that I had to make before i could track down the issue.

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
