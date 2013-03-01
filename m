Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2BF647F96
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2013 18:26:47 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EE5F38F8040
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2013 16:26:43 -0800 (PST)
Received: from mail-qa0-f51.google.com (mail-qa0-f51.google.com
	[209.85.216.51]) by cuda.sgi.com with ESMTP id LjxRUIRQcv6N4LDX
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 28 Feb 2013 16:26:42 -0800 (PST)
Received: by mail-qa0-f51.google.com with SMTP id cr7so1830092qab.10
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2013 16:26:42 -0800 (PST)
Date: Thu, 28 Feb 2013 19:26:37 -0500
From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] xfstests: don't remove trailing zeros from integers
Message-ID: <20130301002637.GB5016@wallace>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: sandeen@redhat.com

_within_tolerance strips trailing zeros from the min and max range
values it outputs.  This leads to damage if the min or max value is
an integer containing trailing zeros rather than a real number with
a fractional part containing trailing zeros. Xfstest 289 can exhibit
this problem when its input is out of range.  Modify the code so it
will only remove trailing zeros found after a decimal point.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 common.filter |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/common.filter b/common.filter
index 9e4c90c..1df2f97 100644
--- a/common.filter
+++ b/common.filter
@@ -106,8 +106,10 @@ EOF
 
   # fix up min, max precision for output
   # can vary for 5.3, 6.2
-  _min=`echo $_min | sed -e 's/0*$//'` # get rid of trailling zeroes
-  _max=`echo $_max | sed -e 's/0*$//'` # get rid of trailling zeroes
+
+  # remove any trailing zeroes from min, max if they have fractional parts
+  _min=`echo $_min | sed -e '/\./s/0*$//'`
+  _max=`echo $_max | sed -e '/\./s/0*$//'`
 
   if [ $_in_range -eq 1 ] 
   then
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
