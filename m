Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 719627CB9
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 12:39:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 45B35304032
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 10:39:18 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id RZMUpb8ThAhi38ZG (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 06 Apr 2016 10:39:17 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 48AAAC0D7F0F
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 17:39:17 +0000 (UTC)
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH] xfs_quota: print quota id number if the name can't be found
Date: Thu,  7 Apr 2016 01:39:13 +0800
Message-Id: <1459964353-25151-1-git-send-email-zlang@redhat.com>
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
Cc: sandeen@redhat.com, Zorro Lang <zlang@redhat.com>

When use GETNEXTQUOTA ioctl to report project quota, it always
report an unexpected quota:

  (null) 0 0 0 00 [--------]

The ID 0 store the default quota, even if no one set default quota,
it still have quota accounting, but not enforced. So GETNEXTQUOTA
can find and report this undefined quota.

>From this problem, I thought if others' quota name miss, (null) will
be printed too. e.g.

  # xfs_quota -xc "limit -u bsoft=300m bhard=400m test" $mnt
  # xfs_quota -xc "report -u" $mnt
  User ID          Used       Soft       Hard    Warn/Grace
  ---------- --------------------------------------------------
  root                0          0          0     00 [--------]
  test                0     307200     409600     00 [--------]
  # userdel -r test
  # xfs_quota -xc "report -u" $mnt
  User ID          Used       Soft       Hard    Warn/Grace
  ---------- --------------------------------------------------
  root                0          0          0     00 [--------]
  (null)              0     307200     409600     00 [--------]

So this problem same with above id 0's problem. For deal with this,
this patch will print id number if the name can't be found.

But if use old GETQUOTA ioctl, it won't print project id 0 quota
information(if it's not defined). That's different with GETNEXTQUOTA.
For keep consistent, this patch also print project id 0 when use old
GETQUOTA.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi,

This's a problem from GETNEXTQUOTA feature. The original disscussion
is as below:

http://thread.gmane.org/gmane.comp.file-systems.fstests/1852/focus=1968

Then Eryu send a patch to xfstests, try to fix the test failure bring
by this bug. The disscussion is as below:

http://oss.sgi.com/archives/xfs/2016-04/msg00002.html

Finally we decided to fix this problem in xfsprogs. After talked with
Eric Sandeen, I wrote this patch. At first, Eric thought we shouldn't
print project id 0 quota information, if no one set limit for it.

Then he change his mind to always print "root" as project id 0's name,
if no one define a name for it. But there's another problem, if we
print "root" for project id 0, but we can't run:

  xfs_quota -xc "limit -p xxx xxx root" $mnt

Because the "root" is a fake name. Then I suggest to print id number,
if the name can't be found. This method not only used for project id
0, it used for all user/group/project IDs which no name defined.

So this patch should be the V3 patch. We can't sure which one is the
best idea. If anyone have better idea, please tell me.

Thanks,
Zorro

 quota/report.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/quota/report.c b/quota/report.c
index 48a3f29..557d667 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -389,7 +389,10 @@ report_mount(
 					name = p->pr_name;
 			}
 		}
-		fprintf(fp, "%-10s", name);
+		if (name != NULL)
+			fprintf(fp, "%-10s", name);
+		else
+			fprintf(fp, "#%-10u", d.d_id);
 	}
 
 	if (form & XFS_BLOCK_QUOTA) {
@@ -571,6 +574,12 @@ report_project_mount(
 			id = oid + 1;
 		}
 	} else {
+		if (!getprprid(0)) {
+			report_mount(fp, 0, "#0", NULL, form, XFS_PROJ_QUOTA,
+			             mount, flags);
+			flags |= NO_HEADER_FLAG;
+		}
+
 		setprent();
 		while ((p = getprent()) != NULL) {
 			if (report_mount(fp, p->pr_prid, p->pr_name, NULL,
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
