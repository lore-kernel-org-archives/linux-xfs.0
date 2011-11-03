Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA3EPeDM017968 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 09:25:41 -0500
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 00DAC12FF497
	for <xfs@oss.sgi.com>; Thu,  3 Nov 2011 07:25:39 -0700 (PDT)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id pSUjAs4dkCsSzCsn
	for <xfs@oss.sgi.com>; Thu, 03 Nov 2011 07:25:39 -0700 (PDT)
Received: by mail-bw0-f53.google.com with SMTP id zs8so1398030bkb.26
	for <xfs@oss.sgi.com>; Thu, 03 Nov 2011 07:25:39 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 04/12] xfstests: fsstress add command line style output for
	show_opts
Date: Thu,  3 Nov 2011 18:24:53 +0400
Message-Id: <1320330301-2682-5-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1320330301-2682-1-git-send-email-dmonakhov@openvz.org>
References: <1320330301-2682-1-git-send-email-dmonakhov@openvz.org>
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
To: linux-fsdevel@vger.kernel.org
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, aelder@sgi.com, tytso@mit.edu, hch@lst.de, xfs@oss.sgi.com

Once some combination of seed+fs_ops result in regression it is
reasonable to document that combination. It is usefull to dump
that configuration in command line style. Later this line may be
simply hardcoded in to regression test.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 070            |    2 +-
 117            |    2 +-
 ltp/fsstress.c |   22 ++++++++++++++++++----
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/070 b/070
index 4458011..f48c33c 100755
--- a/070
+++ b/070
@@ -62,7 +62,7 @@ $FSSTRESS_PROG \
 	-f unresvsp=0 \
 	-f attr_set=100 \
 	-f attr_remove=100 \
-	-S -p 1 -n 10000 >$seq.full 2>&1
+        -p 1 -n 10000 -S c >$seq.full 2>&1
 
 status=$?
 exit
diff --git a/117 b/117
index fcf0485..edec157 100755
--- a/117
+++ b/117
@@ -85,7 +85,7 @@ while [ $i -lt $ITERATIONS ]; do
 	-f attr_set=100 \
 	-f attr_remove=100 \
         -s $seed \
-	-S -p 1 -n 1000 >>$seq.full 2>&1
+	-p 1 -n 1000 -S c >>$seq.full 2>&1
 
     let i=$i+1
 done
diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 133a247..77e0682 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -284,7 +284,7 @@ int main(int argc, char **argv)
 	nops = sizeof(ops) / sizeof(ops[0]);
 	ops_end = &ops[nops];
 	myprog = argv[0];
-	while ((c = getopt(argc, argv, "d:e:f:i:m:n:o:p:rs:vwzHS")) != -1) {
+	while ((c = getopt(argc, argv, "d:e:f:i:m:n:o:p:rs:S:vwzH")) != -1) {
 		switch (c) {
 		case 'd':
 			dirname = optarg;
@@ -345,7 +345,10 @@ int main(int argc, char **argv)
 			zero_freq();
 			break;
 		case 'S':
-			show_ops(0, NULL);
+			i = 0;
+			if (optarg[0] == 'c')
+				i = 1;
+			show_ops(1, NULL);
 			printf("\n");
                         nousage=1;
 			break;
@@ -1310,7 +1313,8 @@ show_ops(int flag, char *lead_str)
                         x+=printf("%s ", p->name);
                 }
                 printf("\n");
-        } else {
+        } else if (flag == 0) {
+		/* Table view style */
 	        int		f;
 	        for (f = 0, p = ops; p < ops_end; p++)
 		        f += p->freq;
@@ -1327,6 +1331,16 @@ show_ops(int flag, char *lead_str)
 			        (p->iswrite == 0) ? " " : "write op");
 		        }
                 }
+	} else {
+		/* Command line style */
+		if (lead_str != NULL)
+			printf("%s", lead_str);
+		printf ("-z -s %ld -m %d -n %d -p %d ", seed, idmodulo,
+			operations, nproc);
+	        for (p = ops; p < ops_end; p++)
+		        if (p->freq > 0)
+			        printf("-f%s=%d ",p->name, p->freq);
+		printf("\n");
 	}
 }
 
@@ -1433,7 +1447,7 @@ usage(void)
 	printf("   -v               specifies verbose mode\n");
 	printf("   -w               zeros frequencies of non-write operations\n");
 	printf("   -z               zeros frequencies of all operations\n");
-	printf("   -S               prints the table of operations (omitting zero frequency)\n");
+	printf("   -S [c,t]         prints the list of operations (omitting zero frequency) in command line or table style\n");
 	printf("   -H               prints usage and exits\n");
 }
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
