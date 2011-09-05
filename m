Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p85ESwpa018132 for <xfs@oss.sgi.com>; Mon, 5 Sep 2011 09:28:58 -0500
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/2][xfstests] fstrim: Use strtoull instead of strtoul
Date: Mon,  5 Sep 2011 16:28:51 +0200
Message-Id: <1315232931-26770-2-git-send-email-lczerner@redhat.com>
In-Reply-To: <1315232931-26770-1-git-send-email-lczerner@redhat.com>
References: <1315232931-26770-1-git-send-email-lczerner@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Lukas Czerner <lczerner@redhat.com>, aelder@sgi.com

When we are parsing input arguments we should really use stroull to get
unsigned long long numbers, since this is what we can specify on the
command line. With this fix it should parse long numbers on the 32 bit
architecture correctly.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 src/fstrim.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/fstrim.c b/src/fstrim.c
index f1f37ec..e23bcb3 100644
--- a/src/fstrim.c
+++ b/src/fstrim.c
@@ -97,7 +97,7 @@ static unsigned long long get_number(char **optarg)
 	}
 
 	errno = 0;
-	number = strtoul(opt, &end , 0);
+	number = strtoull(opt, &end , 0);
 	if (errno)
 		err_exit("%s: %s (%s)\n", program_name,
 			 strerror(errno), *optarg);
-- 
1.7.4.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
