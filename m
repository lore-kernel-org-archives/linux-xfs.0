Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3FIMU1c084030 for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 13:22:30 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9E1B03E4B15
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 11:25:53 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id GDWZZWq1fC1cNEfP for
	<xfs@oss.sgi.com>; Fri, 15 Apr 2011 11:25:53 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p3FIPo9S028026
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 14:25:51 -0400
Received: from test1244.test.redhat.com (test1244.test.redhat.com
	[10.10.10.244])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id p3FIPomh015334
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 14:25:50 -0400
From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] xfsqa: reduce error output on 229
Date: Fri, 15 Apr 2011 14:14:53 -0400
Message-Id: <1302891293-5176-1-git-send-email-josef@redhat.com>
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

From: Dave Chinner <dchinner@redhat.com>

Once we get one short write, we know the test has failed. We don't
ened to keep writing and getting more short writes and spewing
thousands of errors to the console.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---
 src/t_holes.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/src/t_holes.c b/src/t_holes.c
index eba310a..4424335 100644
--- a/src/t_holes.c
+++ b/src/t_holes.c
@@ -14,10 +14,11 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
+#include <stdio.h>
+#include <stdlib.h>
 #include <unistd.h>
 #include <fcntl.h>
 #include <sys/types.h>
-#include <stdio.h>
 
 int main(int argc, char **argv)
 {
@@ -29,8 +30,10 @@ int main(int argc, char **argv)
 		for (j = 0; j < 1024; j++)
 			buf[j]  = i | i << 5;
 
-		if (write(fd,buf,253*4*sizeof(int))!= 253*4*sizeof(int))
+		if (write(fd,buf,253*4*sizeof(int))!= 253*4*sizeof(int)) {
 			printf("Write did not return correct amount\n");
+			exit(EXIT_FAILURE);
+		}
 
 		if ((i % 9) == 0 && i < 9001)
 			lseek(fd, 4096 * 110,SEEK_CUR);
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
