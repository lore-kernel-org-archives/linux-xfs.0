Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D80017CBF
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 08:06:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B59FA8F8049
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 06:06:45 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	2zW7L8UEvSEACYTZ for <xfs@oss.sgi.com>;
	Fri, 07 Jun 2013 06:06:44 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkwNN-0005a7-8a
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 23:06:41 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkwNN-0003ov-5Z
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 23:06:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/6] xfstests: xfs/253 doesn't use seqres correctly
Date: Fri,  7 Jun 2013 23:06:35 +1000
Message-Id: <1370610398-14630-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1370610398-14630-1-git-send-email-david@fromorbit.com>
References: <1370610398-14630-1-git-send-email-david@fromorbit.com>
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

It was missed when converting all the tests as it was using
${seq}.full and none of the regexes matched it. Fix it up to direct
the output to the correct place.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 tests/xfs/253 |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/tests/xfs/253 b/tests/xfs/253
index 98c61d6..f491ef4 100755
--- a/tests/xfs/253
+++ b/tests/xfs/253
@@ -71,6 +71,8 @@ function create_file() {
 
 echo "Disciplyne of silence is goed."
 
+rm -f $seqres.full
+
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount
 
@@ -162,11 +164,11 @@ mv "${TEMP_ORPHAN}" "${ORPHAN}"
 touch "${NON_ORPHAN}"
 
 # Get a listing of all the files before obfuscation
-ls -R >> "${seq}.full"
-ls -R | od -c >> "${seq}.full"
+ls -R >> $seqres.full
+ls -R | od -c >> $seqres.full
 
 # Now unmount the filesystem and create a metadump file
-cd /; sync; sync		# Old school
+cd $here
 
 _scratch_unmount
 
@@ -178,9 +180,9 @@ xfs_mdrestore "${METADUMP_FILE}" "${SCRATCH_DEV}"
 _scratch_mount
 
 # Get a listing of all the files after obfuscation
-cd "${SCRATCH_MNT}"
-ls -R >> "${seq}.full"
-ls -R | od -c >> "${seq}.full"
+cd ${SCRATCH_MNT}
+ls -R >> $seqres.full
+ls -R | od -c >> $seqres.full
 
 # Finally, re-make the filesystem since to ensure we don't
 # leave a directory with duplicate entries lying around.
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
