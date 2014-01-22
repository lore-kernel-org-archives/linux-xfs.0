Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BE7317F72
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 08:38:08 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8FD608F8054
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 06:38:05 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 7GHBTFwW1H3U9uh6 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 22 Jan 2014 06:38:04 -0800 (PST)
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 41ED9AC5D
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 14:38:03 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH v2] xfstests: use value of FSTYP if defined externally
Date: Wed, 22 Jan 2014 15:38:02 +0100
Message-Id: <1390401482-13389-1-git-send-email-dsterba@suse.cz>
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
Cc: David Sterba <dsterba@suse.cz>

The initial value of FSTYP is unconditionally set to 'xfs' and the
filesystem type is taken from the TEST_DEV. This could lead to confusion
if the device hasn't been formatted yet, eg. an empty image in VM, or
a different test setup took place before.

Now one can specify the desired FSTYP in advance and be safe. If unset,
the fallback to TEST_DEV type continues to work.

Signed-off-by: David Sterba <dsterba@suse.cz>
---

v2:
- fixed handling of default case, reorder as the last step
- README: mention what's the default if FSTYP is unset

 README | 3 +++
 check  | 7 ++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/README b/README
index a49ca7c3ff15..295d67f56246 100644
--- a/README
+++ b/README
@@ -65,6 +65,9 @@ Preparing system for tests (IRIX and Linux):
                environment variable set to "yes" will enable their use.
              - setenv DIFF_LENGTH "number of diff lines to print from a failed test",
                by default 10, set to 0 to print the full diff
+             - setenv FSTYP "the filesystem you want to test", the filesystem
+               type is devised from the TEST_DEV device, but you may want to
+               override it; if unset, the default is 'xfs'
         - or add a case to the switch in common/config assigning
           these variables based on the hostname of your test
           machine
diff --git a/check b/check
index 61fb91b82316..2fb4efe31771 100755
--- a/check
+++ b/check
@@ -33,7 +33,6 @@ showme=false
 have_test_arg=false
 randomize=false
 here=`pwd`
-FSTYP=xfs
 xfile=""
 
 # start the initialisation work now
@@ -57,10 +56,12 @@ then
     exit 1
 fi
 
-# Autodetect fs type based on what's on $TEST_DEV
-if [ "$HOSTOS" == "Linux" ]; then
+# Autodetect fs type based on what's on $TEST_DEV unless it's been set
+# externally
+if [ -z "$FSTYP" -a "$HOSTOS" == "Linux" ]; then
     FSTYP=`blkid -c /dev/null -s TYPE -o value $TEST_DEV`
 fi
+FSTYP=${FSTYP:=xfs}
 export FSTYP
 
 SUPPORTED_TESTS="[0-9][0-9][0-9] [0-9][0-9][0-9][0-9]"
-- 
1.8.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
