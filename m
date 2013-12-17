Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B22F829E22
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 16:18:59 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 72F90304064
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 14:18:59 -0800 (PST)
Received: from mail-vc0-f202.google.com (mail-vc0-f202.google.com
	[209.85.220.202]) by cuda.sgi.com with ESMTP id
	VxC7HIQ9FNtnahp3 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 17 Dec 2013 14:18:58 -0800 (PST)
Received: by mail-vc0-f202.google.com with SMTP id id10so697234vcb.3
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 14:18:57 -0800 (PST)
From: Junho Ryu <jayr@google.com>
Subject: [PATCH v2 09/12] xfstests: skip generic/076 which cannot work on tmpfs
Date: Tue, 17 Dec 2013 14:18:39 -0800
Message-Id: <1387318722-3050-9-git-send-email-jayr@google.com>
In-Reply-To: <1387318722-3050-1-git-send-email-jayr@google.com>
References: <1387318722-3050-1-git-send-email-jayr@google.com>
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

v2: check whether SCRATCH_DEV is a block device instead of checking whether
    FSTYP is tmpfs.

 tests/generic/076 | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/generic/076 b/tests/generic/076
index a53840f..7ab2fbc 100755
--- a/tests/generic/076
+++ b/tests/generic/076
@@ -57,6 +57,8 @@ _supported_os IRIX Linux
 
 _require_scratch
 
+[ -d "$SCRATCH_DEV" ] || _notrun "this test requires block device"
+
 echo "*** init fs"
 
 rm -f $seqres.full
-- 
1.8.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
