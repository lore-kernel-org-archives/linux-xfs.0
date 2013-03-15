Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 752C77FF5
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 06:53:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3E0EC8F8049
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 04:53:49 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	uR4vtWt8Iomtz6Ga for <xfs@oss.sgi.com>;
	Fri, 15 Mar 2013 04:53:47 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UGTCj-0001Ta-CC
	for xfs@oss.sgi.com; Fri, 15 Mar 2013 22:53:45 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UGTCZ-0005hx-9h
	for xfs@oss.sgi.com; Fri, 15 Mar 2013 22:53:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/13] xfstests: use command line option for setting extra
	space
Date: Fri, 15 Mar 2013 22:53:24 +1100
Message-Id: <1363348411-21867-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1363348411-21867-1-git-send-email-david@fromorbit.com>
References: <1363348411-21867-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Allow the extra free space to leave in large scratch filesystems to
be specified by a command line option rather than just via an
environment variable.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Rich Johnston <rjohnston@sgi.com>
---
 common |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/common b/common
index da86cd9..78ac654 100644
--- a/common
+++ b/common
@@ -247,6 +247,11 @@ s/ .*//p
 	    usage
 	    ;;
 
+	--extra-space=*)
+	    export SCRATCH_DEV_EMPTY_SPACE=${r#*=}
+	    xpand=false
+	    ;;
+
 	*)
 	    start=$r
 	    end=$r
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
