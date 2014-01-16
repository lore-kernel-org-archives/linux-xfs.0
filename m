Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B175429DF8
	for <xfs@oss.sgi.com>; Thu, 16 Jan 2014 11:07:22 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 28814AC001
	for <xfs@oss.sgi.com>; Thu, 16 Jan 2014 09:07:22 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 5jTWFtsOj7zDNVGC (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 16 Jan 2014 09:07:20 -0800 (PST)
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id AC561AC3E
	for <xfs@oss.sgi.com>; Thu, 16 Jan 2014 17:07:19 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/5] xfstests: use value of FSTYP if defined externally
Date: Thu, 16 Jan 2014 18:07:12 +0100
Message-Id: <efafb76f725148435b09a22c62c92a63eedb9b71.1389891730.git.dsterba@suse.cz>
In-Reply-To: <cover.1389891730.git.dsterba@suse.cz>
References: <cover.1389891730.git.dsterba@suse.cz>
In-Reply-To: <cover.1389891730.git.dsterba@suse.cz>
References: <cover.1389891730.git.dsterba@suse.cz>
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
 README | 3 +++
 check  | 7 ++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/README b/README
index a49ca7c3ff15..62974ef87b89 100644
--- a/README
+++ b/README
@@ -65,6 +65,9 @@ Preparing system for tests (IRIX and Linux):
                environment variable set to "yes" will enable their use.
              - setenv DIFF_LENGTH "number of diff lines to print from a failed test",
                by default 10, set to 0 to print the full diff
+             - setenv FSTYP "the filesystem you want to test", the filesystem
+               type is devised from the TEST_DEV device, but you may want to
+               override it
         - or add a case to the switch in common/config assigning
           these variables based on the hostname of your test
           machine
diff --git a/check b/check
index 320ad26b7c2c..9e4275b1fa37 100755
--- a/check
+++ b/check
@@ -33,7 +33,7 @@ showme=false
 have_test_arg=false
 randomize=false
 here=`pwd`
-FSTYP=xfs
+FSTYP=${FSTYP:-xfs}
 xfile=""
 
 # start the initialisation work now
@@ -57,8 +57,9 @@ then
     exit 1
 fi
 
-# Autodetect fs type based on what's on $TEST_DEV
-if [ "$HOSTOS" == "Linux" ]; then
+# Autodetect fs type based on what's on $TEST_DEV unless it's been set
+# externally
+if [ -z "$FSTYP" -a "$HOSTOS" == "Linux" ]; then
     FSTYP=`blkid -c /dev/null -s TYPE -o value $TEST_DEV`
 fi
 export FSTYP
-- 
1.8.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
