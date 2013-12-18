Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B9F2A29E17
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 12:16:13 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 56E6DAC002
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 10:16:13 -0800 (PST)
Received: from mail-qa0-f74.google.com (mail-qa0-f74.google.com
	[209.85.216.74]) by cuda.sgi.com with ESMTP id YpH6TkMzFIvxzDiV
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 18 Dec 2013 10:16:12 -0800 (PST)
Received: by mail-qa0-f74.google.com with SMTP id i13so71488qae.1
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 10:16:11 -0800 (PST)
From: Junho Ryu <jayr@google.com>
Subject: [PATCH v3 11/12] xfstests: do not unmount before calling
	_check_scratch_fs()
Date: Wed, 18 Dec 2013 10:16:02 -0800
Message-Id: <1387390563-27064-11-git-send-email-jayr@google.com>
In-Reply-To: <1387390563-27064-1-git-send-email-jayr@google.com>
References: <1387390563-27064-1-git-send-email-jayr@google.com>
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
Cc: tytso@mit.edu, hughd@google.com, branto@redhat.com, Junho Ryu <jayr@google.com>

Many tests do not unmount SCRATCH_DEV before calling
_check_scratch_fs().  Change generic/053 to call check a filesystem
without unmounting the device.

Signed-off-by: Junho Ryu <jayr@google.com>
---

v3: same as v2

v2: extracted from patch 9

 tests/generic/053 | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tests/generic/053 b/tests/generic/053
index b8bd9e6..cf46a93 100755
--- a/tests/generic/053
+++ b/tests/generic/053
@@ -81,9 +81,7 @@ list_acls()
 
 echo "acls before repair:"
 list_acls
-_do 'unmount $SCRATCH_DEV' 'umount $SCRATCH_DEV'
 _do 'repair filesystem' '_check_scratch_fs'
-_do 'mount filesytem' '_scratch_mount'
 echo "acls after repair: "
 list_acls
 
-- 
1.8.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
