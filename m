Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 45D417CA0
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 13:23:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B004CAC005
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 11:22:58 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QchlQSyeWM9aunie (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Apr 2016 11:22:57 -0700 (PDT)
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH] xfs: group quota is still enforced if mount v5 xfs with
	gqnoenforce and pqnoenforce
Date: Thu, 14 Apr 2016 02:22:52 +0800
Message-Id: <1460571772-20285-1-git-send-email-zlang@redhat.com>
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
Cc: linux-fsdevel@vger.kernel.org, sandeen@redhat.com, Zorro Lang <zlang@redhat.com>

This's a regression bug caused by:

  2e74af0 xfs: convert mount option parsing to tokens

xfstests xfs/299 can reproduce this bug, it will fail when do
gpnoenforce test, the error output as below(diff with 299.out):

 *** push past the soft block limit
  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
  -[NAME] 140 100 500 00 [--------] 4 4 10 00 [--------] 0 0 0 00 [--------]
  +[NAME] 140 100 500 00 [7 days] 4 4 10 00 [--------] 0 0 0 00 [--------]

 *** push past the hard inode limit (expect EDQUOT)
  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
  -[NAME] 140 100 500 00 [--------] 16 4 10 00 [--none--] 0 0 0 00 [--------]
  +[NAME] 140 100 500 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]

 *** push past the hard block limit (expect EDQUOT)
  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
  -[NAME] 540 100 500 00 [--none--] 16 4 10 00 [--none--] 0 0 0 00 [--------]
  +[NAME] 500 100 500 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]

It shows that group quota is still enforced. But this bug only can
be reproduced when mount v5 xfs with gqnoenforce and pqnoenforce
options. The reason as I found is a missed "break" in xfs_parseargs()
function.

After deal with "pqnoenforce", it should break. But the code keep
running into "gquota/grpquota" lines, and make gquota enforced.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi,

This's a tiny bug(only one line patch). But it's belong to
regression bug and take me a few hours to find the problem.
So I hope it can be fixed:)

Thanks,
Zorro

 fs/xfs/xfs_super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 187e14b..f3c0ffc 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -350,6 +350,7 @@ xfs_parseargs(
 		case Opt_pqnoenforce:
 			mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE);
 			mp->m_qflags &= ~XFS_PQUOTA_ENFD;
+			break;
 		case Opt_gquota:
 		case Opt_grpquota:
 			mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
