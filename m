Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EAD9D7F5F
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 01:59:35 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C4D558F8039
	for <xfs@oss.sgi.com>; Mon, 11 Nov 2013 23:59:35 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id epzV3FRgzRXZ7JSL for
	<xfs@oss.sgi.com>; Mon, 11 Nov 2013 23:59:35 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rAC7xYnY029892
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 02:59:34 -0500
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH v2] xfstests: _filter_mkfs should consume input from stdin for
	non-xfs fs
Date: Tue, 12 Nov 2013 15:59:18 +0800
Message-Id: <1384243158-19317-1-git-send-email-eguan@redhat.com>
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
Cc: Eryu Guan <eguan@redhat.com>

_filter_mkfs is a filter so that it should read from stdin first
before printing anything out. Otherwise the command prior to the
pipeline may get EPIPE.

I saw this when testing extN with generic/204, _scratch_mkfs_sized was
unable to create fs because of EPIPE, then _scratch_mount failed.

generic/204 12s ... [failed, exit status 1] - output mismatch (see /root/xfstests/results//generic/204.out.bad)
    --- tests/generic/204.out   2013-11-01 16:47:56.728591856 +0800
    +++ /root/xfstests/results//generic/204.out.bad     2013-11-01 22:52:53.207828779 +0800
    @@ -1,2 +1,7 @@
     QA output created by 204
    -*** done
    +mount: wrong fs type, bad option, bad superblock on /dev/sda6,
    +       missing codepage or helper program, or other error
    +       In some cases useful info is found in syslog - try
    +       dmesg | tail  or so
    +

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
v2: just pipe stdin to /dev/null for non-xfs fs as Dave suggested.

 common/filter | 1 +
 1 file changed, 1 insertion(+)

diff --git a/common/filter b/common/filter
index e37ce69..c872a27 100644
--- a/common/filter
+++ b/common/filter
@@ -138,6 +138,7 @@ _filter_mkfs()
     xfs)
 	;;
     *)
+	cat - >/dev/null
 	perl -e 'print STDERR "dbsize=4096\nisize=256\n"'
 	return ;;
     esac
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
