Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 762927F50
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2015 04:59:01 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 62FE7304062
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2015 02:59:00 -0800 (PST)
Received: from mail-wi0-f171.google.com (mail-wi0-f171.google.com
	[209.85.212.171]) by cuda.sgi.com with ESMTP id
	NI0dA7zSgexndgVK (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Feb 2015 02:58:58 -0800 (PST)
Received: by mail-wi0-f171.google.com with SMTP id hi2so11002859wib.4
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2015 02:58:58 -0800 (PST)
Message-ID: <54DB35F0.1010203@plexistor.com>
Date: Wed, 11 Feb 2015 12:58:56 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: shared/032 is broken on Fedora
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>


This is not the proper patch just to show a working version for Fedora. But I think
it now breaks the other ARCHs.

What happens is that the output of ${MKFS_PROG}.* is:
	/usr/sbin/mkfs.bfs /usr/sbin/mkfs.btrfs /usr/sbin/mkfs.cramfs /usr/sbin/mkfs.ext2 /usr/sbin/mkfs.ext3 /usr/sbin/mkfs.ext4 ...

So in Fedora sbin has moved to /usr/... and therefor the sed below fails.
My sed foo is not good enough. How to support both places for sbin?

Also why the "_supported_fs xfs btrfs"? So if all those other mkfs.* that are destructive to
foreign filesystem, should the test not fail instead of skipped?
Maybe if the maintainers of all these filesystems day in and day out running xfstests and
see shared/032 failing, they might decide to fix their evil ways. Instead of skipping the
test and the said maintainer just ignores it?

Thanks
Boaz

---
diff --git a/tests/shared/032 b/tests/shared/032
index a410003..726e6b4 100755
--- a/tests/shared/032
+++ b/tests/shared/032
@@ -37,8 +37,8 @@ rm -f $seqres.full
 . ./common/filter
 
 # real QA test starts here
-_supported_fs xfs btrfs
+# _supported_fs xfs btrfs
 _supported_os Linux
 
 _require_scratch_nocheck
 _require_no_large_scratch_dev
@@ -49,8 +49,7 @@ if [ "$FSTYP" == "btrfs" ]; then
 		_notrun "Installed mkfs.btrfs does not support -f option"
 fi
 
-echo "Silence is golden."
-for fs in `echo ${MKFS_PROG}.* | sed -e 's/.sbin.mkfs.//g'`
+for fs in `echo ${MKFS_PROG}.* | sed -e 's/.usr\/sbin.mkfs.//g'`
 do
 	preop=""	# for special input needs
 	preargs=""	# for any special pre-device options

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
