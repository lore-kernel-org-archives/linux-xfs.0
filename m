Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 514A129E04
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 12:16:12 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BCB91AC004
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 10:16:11 -0800 (PST)
Received: from mail-ie0-f201.google.com (mail-ie0-f201.google.com
	[209.85.223.201]) by cuda.sgi.com with ESMTP id
	HE2lKTNomAGEv4us (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Dec 2013 10:16:10 -0800 (PST)
Received: by mail-ie0-f201.google.com with SMTP id at1so1704iec.4
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 10:16:10 -0800 (PST)
From: Junho Ryu <jayr@google.com>
Subject: [PATCH v3 09/12] xfstests: skip generic/076 which cannot work on tmpfs
Date: Wed, 18 Dec 2013 10:16:00 -0800
Message-Id: <1387390563-27064-9-git-send-email-jayr@google.com>
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

Skip generic/076 which tests concurrent access while testing tmpfs
because there are other tests cover the case using fsstress.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Junho Ryu <jayr@google.com>
---

v3: use -b to check whether SCRATCH_DEV is a block device.

v2: check whether SCRATCH_DEV is a block device instead of checking whether
    FSTYP is tmpfs.

 tests/generic/076 | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/generic/076 b/tests/generic/076
index a53840f..b6a89b7 100755
--- a/tests/generic/076
+++ b/tests/generic/076
@@ -57,6 +57,8 @@ _supported_os IRIX Linux
 
 _require_scratch
 
+[ -b "$SCRATCH_DEV" ] || _notrun "this test requires block device"
+
 echo "*** init fs"
 
 rm -f $seqres.full
-- 
1.8.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
