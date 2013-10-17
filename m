Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 91D417F3F
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 12:50:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8164A304067
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 10:50:22 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id flGDBpqqydFUPuzY for
	<xfs@oss.sgi.com>; Thu, 17 Oct 2013 10:50:20 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r9HHoHci018745
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 13:50:17 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r9HHoGht024226
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 13:50:17 -0400
Message-ID: <52602358.1050300@redhat.com>
Date: Thu, 17 Oct 2013 12:50:16 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_repair: avoid segfault if reporting progress early in
	repair
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

For a very large filesystem, zeroing the log may take some time.

If we ask for progress reports frequently enough that one fires
before we finish with log zeroing, we try to use a progress format
which has not yet been set up, and segfault:

# mkfs.xfs -d size=60t,file,name=fsfile
# xfs_repair -m 9000 -o ag_stride=32 -t 1 fsfile 
Phase 1 - find and verify superblock...
        - reporting progress in intervals of 1 seconds
Phase 2 - using internal log
        - zero log...
Segmentation fault

(gdb) bt
#0  0x0000000000426962 in progress_rpt_thread (p=0x67ad20) at progress.c:234
#1  0x0000003b98a07851 in start_thread (arg=0x7f19d8e47700) at pthread_create.c:301
#2  0x0000003b982e767d in ?? ()
#3  0x0000000000000000 in ?? ()
(gdb) p msgp
$1 = (msg_block_t *) 0x67ad20
(gdb) p msgp->format
$2 = (progress_rpt_t *) 0x0
(gdb)

I suppose we could rig up progress reports for log zeroing, but
that won't usually take terribly long; for now, be defensive
and init the message->format to NULL, and just return early
from the progress thread if we've not yet set up any message.

(Sure, global_msgs is global, and ->format is already NULL,
but to me it's worth being explicit since we will test it).

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/progress.c b/repair/progress.c
index ab320dc..45a412e 100644
--- a/repair/progress.c
+++ b/repair/progress.c
@@ -124,6 +124,7 @@ init_progress_rpt (void)
 	 */
 
 	pthread_mutex_init(&global_msgs.mutex, NULL);
+	global_msgs.format = NULL;
 	global_msgs.count = glob_agcount;
 	global_msgs.interval = report_interval;
 	global_msgs.done   = prog_rpt_done;
@@ -169,6 +170,10 @@ progress_rpt_thread (void *p)
 	msg_block_t *msgp = (msg_block_t *)p;
 	__uint64_t percent;
 
+	/* It's possible to get here very early w/ no progress msg set */
+	if (!msgp->format)
+		return NULL;
+
 	if ((msgbuf = (char *)malloc(DURATION_BUF_SIZE)) == NULL)
 		do_error (_("progress_rpt: cannot malloc progress msg buffer\n"));
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
