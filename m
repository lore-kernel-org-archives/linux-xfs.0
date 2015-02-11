Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 60FA87F58
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2015 11:11:14 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4FB0E304053
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2015 09:11:11 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id kfT0PDNlt4cuwzON for <xfs@oss.sgi.com>;
	Wed, 11 Feb 2015 09:11:10 -0800 (PST)
Message-ID: <54DB8D2D.20104@sandeen.net>
Date: Wed, 11 Feb 2015 11:11:09 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] fstests: shared/032 handle mkfs.* in either /sbin or /usr/sbin
References: <54DB35F0.1010203@plexistor.com>
In-Reply-To: <54DB35F0.1010203@plexistor.com>
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
To: Boaz Harrosh <boaz@plexistor.com>, Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, fstests@vger.kernel.org

mkfs programs may live in either /sbin or /usr/sbin, and
the current regexp in this test only catches the latter,
and so the test wont' run properly for the former.

Fix this by iterating over each full path to every mkfs.${FS}
program in ${MKFS.PROG}.*, and extracting the ${FS} part.

We found the paths in the first place by using a wildcard
with the found ${MKFS_PROG}, so we can use that string to
filter out everything except the wildcard match at the end,
which is the fs name we are looking for.

Reported-by: Boaz Harrosh <boaz@plexistor.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/tests/shared/032 b/tests/shared/032
index a410003..8ffb54b 100755
--- a/tests/shared/032
+++ b/tests/shared/032
@@ -50,8 +50,9 @@ if [ "$FSTYP" == "btrfs" ]; then
 fi
 
 echo "Silence is golden."
-for fs in `echo ${MKFS_PROG}.* | sed -e 's/.sbin.mkfs.//g'`
+for mkfs in `echo ${MKFS_PROG}.*`
 do
+	fs=`echo $mkfs | sed -e s:${MKFS_PROG}.::`
 	preop=""	# for special input needs
 	preargs=""	# for any special pre-device options
 	postargs=""	# for any special post-device options


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
