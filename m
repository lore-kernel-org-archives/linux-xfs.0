Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 75A9B7CA0
	for <xfs@oss.sgi.com>; Fri,  1 Apr 2016 21:45:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3BE47304032
	for <xfs@oss.sgi.com>; Fri,  1 Apr 2016 19:45:20 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 5bvXHUrSBgYlNBWT (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 01 Apr 2016 19:45:16 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 5110A1636A9
	for <xfs@oss.sgi.com>; Sat,  2 Apr 2016 02:45:15 +0000 (UTC)
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH v2] xfs_quota: add missed options -D and -P into man page
Date: Sat,  2 Apr 2016 10:45:10 +0800
Message-Id: <1459565110-23923-1-git-send-email-zlang@redhat.com>
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
Cc: Zorro Lang <zlang@redhat.com>, billodo@redhat.com

There're two options in xfsprogs/quota/init.c:init() function, the -D
option is used to set a file to instead of /etc/projects, and the -P
option is used to set a file to instead of /etc/projid. I don't know
these two options when I write xfstests case xfs/133, because
there's no any information about them in xfs_quota and other related
man pages. I learn about these two options by read others test cases.

So I add these options into xfs_quota man page.

Reported-by: Eryu Guan <eguan@redhat.com>
Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi,

V2 patch fix some english words problems:
Point a file contain the -> Specify a file containing the
directories trees -> directory trees

Thanks for Bill specify my english syntax errors. English is not my
mother tongue, sorry for the mistake when I write english.

Thanks,
Zorro

 man/man8/xfs_quota.8 | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/man/man8/xfs_quota.8 b/man/man8/xfs_quota.8
index 951252b..ab67423 100644
--- a/man/man8/xfs_quota.8
+++ b/man/man8/xfs_quota.8
@@ -15,6 +15,12 @@ xfs_quota \- manage use of quota on XFS filesystems
 .B \-d
 .I project
 ] ... [
+.B \-D
+.I projects_file
+] [
+.B \-P
+.I projid_file
+] [
 .IR path " ... ]"
 .br
 .B xfs_quota \-V
@@ -53,6 +59,18 @@ commands to the set of projects specified. Multiple
 .B \-d
 arguments may be given.
 .TP
+.BI \-D " projects_file"
+Specify a file containing the mapping of numeric project identifiers
+to directory trees.
+.I /etc/projects
+as default, if this option is none.
+.TP
+.BI \-P " projid_file"
+Specify a file containing the mapping of numeric project identifiers
+to project names.
+.I /etc/projid
+as default, if this option is none.
+.TP
 .B \-V
 Prints the version number and exits.
 .PP
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
