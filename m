Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7EBDC7F53
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 09:02:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0CD5EAC006
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 07:02:23 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id IYB57LsGuEs3MdJD for
	<xfs@oss.sgi.com>; Wed, 12 Jun 2013 07:02:23 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r5CE2MJA015498
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 10:02:22 -0400
Received: from dhcp-1-112.brq.redhat.com (dhcp-1-112.brq.redhat.com
	[10.34.1.112])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r5CE2KZG006186
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 10:02:21 -0400
Date: Wed, 12 Jun 2013 16:02:19 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: [PATCH] xfstests: print missing utility name
Message-ID: <alpine.LFD.2.00.1306121558030.14273@localhost.localdomain>
MIME-Version: 1.0
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
To: xfs-oss <xfs@oss.sgi.com>

Currently when the utility such as fio or dmsetup is missing user does
not get the information about the utility name which is actually
missing. Fix it by providing second argument to the _require_command().

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 common/rc | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/common/rc b/common/rc
index fe6bbfc..984cef1 100644
--- a/common/rc
+++ b/common/rc
@@ -1054,6 +1054,7 @@ _require_realtime()
 _require_command()
 {
     [ -n "$1" ] && _cmd="$1" || _cmd="$2"
+    [ -z $_cmd ] && _cmd="<fill utility name>"
     [ -n "$1" -a -x "$1" ] || _notrun "$_cmd utility required, skipped this test"
 }
 
@@ -1061,7 +1062,7 @@ _require_command()
 #
 _require_dm_flakey()
 {
-    _require_command $DMSETUP_PROG
+    _require_command $DMSETUP_PROG dmsetup
 
     modprobe dm-flakey >/dev/null 2>&1
     $DMSETUP_PROG targets | grep flakey >/dev/null 2>&1
@@ -2036,7 +2037,7 @@ _require_fio()
 {
 	job=$1
 
-	_require_command $FIO_PROG
+	_require_command $FIO_PROG fio
 	if [ -z "$1" ]; then
 		return 1;
 	fi
-- 
1.8.2.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
