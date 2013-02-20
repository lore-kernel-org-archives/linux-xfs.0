Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 00C6E7F5A
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 04:42:31 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CDDD28F8035
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 02:42:27 -0800 (PST)
Received: from relay.sw.ru (mailhub.sw.ru [195.214.232.25]) by cuda.sgi.com
	with ESMTP id Jq3QXuqi7ZZGEf1o (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 20 Feb 2013 02:42:25 -0800 (PST)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 01/10] xfstests: add fio requirement V2
Date: Wed, 20 Feb 2013 14:42:06 +0400
Message-Id: <1361356935-29153-2-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1361356935-29153-1-git-send-email-dmonakhov@openvz.org>
References: <1361356935-29153-1-git-send-email-dmonakhov@openvz.org>
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
Cc: linux-fsdevel@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org, dchinner@redhat.com

FIO is very flexible io generator, I would call it IO swiss knife.
Currently we have tonns of hardcoded application which reproduces
some predefined scenario. This approach has obvious dissadvantages
1) Lack of flexability: one written it is hard to modify it in future
2) Code base is large, many routines written again and again

At the same time add new fio based tast is just add simle INI file.
This greatly simplify code review. I do beleve that some day we will
replace most of hardcoded io binaries with fio.

One who is planning to run $FIO_PROG should first check that system
contains appropriate version which is able to handle jobfile
for example:  _require_fio 286-job.fio

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 common.config |    1 +
 common.rc     |   15 +++++++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/common.config b/common.config
index 827c718..7681812 100644
--- a/common.config
+++ b/common.config
@@ -159,6 +159,7 @@ export KILLALL_PROG="`set_prog_path killall`"
 export INDENT_PROG="`set_prog_path indent`"
 export XFS_COPY_PROG="`set_prog_path xfs_copy`"
 export FSTRIM_PROG="`set_prog_path fstrim`"
+export FIO_PROG="`set_prog_path fio`"
 
 # Generate a comparable xfsprogs version number in the form of
 # major * 10000 + minor * 100 + release
diff --git a/common.rc b/common.rc
index 2e8581e..14de47b 100644
--- a/common.rc
+++ b/common.rc
@@ -1789,6 +1789,21 @@ _require_freeze()
 	[ $result -eq 0 ] || _notrun "$FSTYP does not support freezing"
 }
 
+# Check that fio is present, and it is able to execute given jobfile
+_require_fio()
+{
+	job=$1
+
+	_require_command $FIO_PROG
+	if [ -z "$1" ]; then
+		return 1;
+	fi
+	
+	$FIO_PROG --warnings-fatal --showcmd $job >/dev/null 2>&1
+	[ $? -eq 0 ] || _notrun "$FIO_PROG too old"
+}
+
+
 # arg 1 is dev to remove and is output of the below eg.
 # ls -l /sys/class/block/sdd | rev | cut -d "/" -f 3 | rev
 _devmgt_remove()
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
