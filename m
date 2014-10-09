Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8FDB67F3F
	for <xfs@oss.sgi.com>; Thu,  9 Oct 2014 03:39:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7E7A9304048
	for <xfs@oss.sgi.com>; Thu,  9 Oct 2014 01:39:28 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id nFOj78M6ve3FVE8K (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 09 Oct 2014 01:39:27 -0700 (PDT)
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] xfs/262: update filter to deal with long device name correctly
Date: Thu,  9 Oct 2014 16:38:51 +0800
Message-Id: <1412843931-10447-1-git-send-email-eguan@redhat.com>
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
To: fstests@vger.kernel.org
Cc: Eryu Guan <eguan@redhat.com>, xfs@oss.sgi.com

If the device name is too long, the output of xfs_quota -c "df" will be
broke into two lines as

Filesystem           1K-blocks       Used  Available  Use% Pathname
/dev/mapper/rhel_hp--dl388eg8--01-testlv2
                      15718400      32932   15685468    0% /mnt/testarea/scratch
/dev/mapper/rhel_hp--dl388eg8--01-testlv2
                        512000          0     512000    0% /mnt/testarea/scratch/test

and _filter_quota_rpt() couldn't catch the correct available number and
test will fail as

	[root@hp-dl388g8-01 xfstests]# diff -u tests/xfs/262.out /root/xfstests/results//xfs/262.out.bad
	--- tests/xfs/262.out   2014-10-08 20:16:19.000000000 +0800
	+++ /root/xfstests/results//xfs/262.out.bad  2014-10-09 14:29:38.795813323 +0800
	@@ -1,2 +1,4 @@
	 QA output created by 262
	 Silence is golden.
	+hard limit 0 bytes, expected 524288000
	+hard limit 0 bytes, expected 524288000

Update the filter so it could catch the correct value.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/xfs/262 | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/tests/xfs/262 b/tests/xfs/262
index 6040f62..9d8b838 100755
--- a/tests/xfs/262
+++ b/tests/xfs/262
@@ -76,6 +76,8 @@ _require_scratch
 # both the "df" and the "report" output.  For "report", the line we're
 # interested in contains our project name in the first field.  For "df"
 # it contains our project directory in the last field.
+# But if the device name is too long, the "df" output is broke into two
+# lines, the fourth field is not correct, so take $(nf-2) of "df"
 _filter_quota_rpt() {
 	awk '
 	BEGIN {
@@ -96,9 +98,15 @@ _filter_quota_rpt() {
 		return result;
 	}
 	{
-		if ($1 !~ proj_name && $nf !~ proj_dir)
+		if ($1 =~ proj_name) {
+			# this is the "report" output
+			bsize = byte_size($4);
+		} else if ($nf =~ proj_dir) {
+			# this is the "df" output
+			bsize = byte_size($(nf-2));
+		} else {
 			next;
-		bsize = byte_size($4);
+		}
 		if (bsize != qlimit)
 			printf("hard limit %d bytes, expected %d\n",
 				bsize, qlimit);
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
