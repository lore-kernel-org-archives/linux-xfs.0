Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8684A7FD5
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 12:02:12 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 09ED7AC002
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 10:02:08 -0800 (PST)
Received: from mail-qc0-f178.google.com (mail-qc0-f178.google.com
	[209.85.216.178]) by cuda.sgi.com with ESMTP id
	jZDBtPqeHJLqlGna (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 01 Mar 2013 10:02:08 -0800 (PST)
Received: by mail-qc0-f178.google.com with SMTP id j34so366357qco.37
	for <xfs@oss.sgi.com>; Fri, 01 Mar 2013 10:02:07 -0800 (PST)
Date: Fri, 1 Mar 2013 13:01:58 -0500
From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH V2] xfstests: don't remove trailing zeros from integers
Message-ID: <20130301180158.GC6449@wallace>
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
will only remove trailing zeros found after a decimal point, and
remove decimal points not followed by digits.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 common.filter |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/common.filter b/common.filter
index 9e4c90c..bfc800b 100644
--- a/common.filter
+++ b/common.filter
@@ -106,8 +106,11 @@ EOF
 
   # fix up min, max precision for output
   # can vary for 5.3, 6.2
-  _min=`echo $_min | sed -e 's/0*$//'` # get rid of trailling zeroes
-  _max=`echo $_max | sed -e 's/0*$//'` # get rid of trailling zeroes
+
+  # remove any trailing zeroes from min, max if they have fractional parts
+  # and then remove any decimal points not followed by digits
+  _min=`echo $_min | sed -e '/\./s/0*$//' | sed -e 's/\.$//'`
+  _max=`echo $_max | sed -e '/\./s/0*$//' | sed -e 's/\.$//'`
 
   if [ $_in_range -eq 1 ] 
   then
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
