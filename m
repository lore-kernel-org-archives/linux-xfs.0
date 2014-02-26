Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 48A1F7F37
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 22:39:13 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BABE0AC002
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 20:39:12 -0800 (PST)
Received: from fgwmail6.fujitsu.co.jp (fgwmail6.fujitsu.co.jp [192.51.44.36])
	by cuda.sgi.com with ESMTP id R4BHGCxwMju4CiSt (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Feb 2014 20:39:10 -0800 (PST)
Received: from m2.gw.fujitsu.co.jp (unknown [10.0.50.72])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id B1BFB3EE0B6
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 13:39:08 +0900 (JST)
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id A406E45DE4D
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 13:39:08 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.nic.fujitsu.com [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 8CAF145DE3E
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 13:39:08 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 808C1E08002
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 13:39:08 +0900 (JST)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local
	(g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 3615B1DB802C
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 13:39:08 +0900 (JST)
Message-ID: <530D6FE3.2040406@jp.fujitsu.com>
Date: Wed, 26 Feb 2014 13:38:59 +0900
From: sat <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH] XFS: fix the description of 'allocsize=' mount option
References: <530AE0E5.1090707@jp.fujitsu.com> <20140224120629.GN4317@dastard>
In-Reply-To: <20140224120629.GN4317@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Rob Landley <rob@landley.net>, xfs@oss.sgi.com

Hi Dave,

> Actually, it isn't. The initial size of dynamic prealloc is
> determined by a set of heuristics based on file size, filesystem
> geometry and the existing extents on the file. It uses a default
> of 64k if no optimisation heuristics trigger.

I see. I should have read the code more carefully.

---
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: [PATCH] XFS: remove the description about the default value of "allocsize=" mount option

The end-of-file preallocation size is dynamic by default.
So there is no static default size specified by "allocsize="
mount option and the description about the default size
should be removed.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Rob Landley <rob@landley.net>
---
  Documentation/filesystems/xfs.txt |    6 +++---
  1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
index 5be51fd..5837f0a 100644
--- a/Documentation/filesystems/xfs.txt
+++ b/Documentation/filesystems/xfs.txt
@@ -23,9 +23,9 @@ default behaviour.
  
    allocsize=size
      Sets the buffered I/O end-of-file preallocation size when
-    doing delayed allocation writeout (default size is 64KiB).
-    Valid values for this option are page size (typically 4KiB)
-    through to 1GiB, inclusive, in power-of-2 increments.
+    doing delayed allocation writeout. Valid values for this
+    option are page size (typically 4KiB) through to 1GiB,
+    inclusive, in power-of-2 increments.
  
      The default behaviour is for dynamic end-of-file
      preallocation size, which uses a set of heuristics to
-- 
1.7.1



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
