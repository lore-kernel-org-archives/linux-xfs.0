Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EEF267F91
	for <xfs@oss.sgi.com>; Thu, 25 Feb 2016 09:21:03 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 80E9AAC005
	for <xfs@oss.sgi.com>; Thu, 25 Feb 2016 07:21:00 -0800 (PST)
Received: from mail-lb0-f178.google.com (mail-lb0-f178.google.com
	[209.85.217.178]) by cuda.sgi.com with ESMTP id
	J0rWsD8emdtFAfg2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Feb 2016 07:20:56 -0800 (PST)
Received: by mail-lb0-f178.google.com with SMTP id x1so30717680lbj.3
	for <xfs@oss.sgi.com>; Thu, 25 Feb 2016 07:20:56 -0800 (PST)
Received: from smtp.gmail.com ([195.214.234.4])
	by smtp.gmail.com with ESMTPSA id rk1sm1248525lbb.0.2016.02.25.07.20.54
	for <xfs@oss.sgi.com>
	(version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Thu, 25 Feb 2016 07:20:54 -0800 (PST)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] xfs_io: Prevent devide by zero from {pread,pwrite}_random
Date: Thu, 25 Feb 2016 19:20:53 +0400
Message-ID: <8760xc3jfu.fsf@openvz.org>
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
To: xfs@oss.sgi.com


Math is wrong if range requested is less or equals to block size

xfs_io -c 'pwrite -b 4k 8k 4k -R' \
       -c 'pread -b 4k  4k 4k -R' -f file

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 io/pread.c  | 6 +++++-
 io/pwrite.c | 6 +++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/io/pread.c b/io/pread.c
index f16c86c..b98355f 100644
--- a/io/pread.c
+++ b/io/pread.c
@@ -245,7 +245,11 @@ read_random(
 
 	*total = 0;
 	while (count > 0) {
-		off = ((offset + (random() % range)) / buffersize) * buffersize;
+		if (range)
+			off = ((offset + (random() % range)) / buffersize) *
+				buffersize;
+		else
+			off = offset;
 		bytes = do_pread(fd, off, buffersize, buffersize);
 		if (bytes == 0)
 			break;
diff --git a/io/pwrite.c b/io/pwrite.c
index 4fc8de6..67631ce 100644
--- a/io/pwrite.c
+++ b/io/pwrite.c
@@ -128,7 +128,11 @@ write_random(
 
 	*total = 0;
 	while (count > 0) {
-		off = ((offset + (random() % range)) / buffersize) * buffersize;
+		if (range)
+			off = ((offset + (random() % range)) / buffersize) *
+				buffersize;
+		else
+			off = offset;
 		bytes = do_pwrite(file->fd, off, buffersize, buffersize);
 		if (bytes == 0)
 			break;
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
