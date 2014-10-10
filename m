Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9F7787F91
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 09:24:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2F311AC014
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 07:24:12 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id vgszfcsGQVpM4G9z (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Oct 2014 07:24:10 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] printk: Debug patch 2
Date: Fri, 10 Oct 2014 16:23:48 +0200
Message-Id: <1412951028-4085-44-git-send-email-jack@suse.cz>
In-Reply-To: <1412951028-4085-1-git-send-email-jack@suse.cz>
References: <1412951028-4085-1-git-send-email-jack@suse.cz>
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
To: linux-fsdevel@vger.kernel.org
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

Signed-off-by: Jan Kara <jack@suse.cz>
---
 kernel/printk/printk.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index a39f4129f848..00a9ad5c2708 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1718,17 +1718,19 @@ asmlinkage int vprintk_emit(int facility, int level,
 
 	logbuf_cpu = UINT_MAX;
 	raw_spin_unlock(&logbuf_lock);
-	local_irq_restore(flags);
-
-	/* If called from the scheduler, we can not call up(). */
-	if (in_sched)
-		return printed_len;
-
 	/*
 	 * Disable preemption to avoid being preempted while holding
 	 * console_sem which would prevent anyone from printing to console
 	 */
 	preempt_disable();
+	local_irq_restore(flags);
+
+	/* If called from the scheduler, we can not call up(). */
+	if (in_sched) {
+		preempt_enable();
+		return printed_len;
+	}
+
 	/*
 	 * Try to acquire and then immediately release the console semaphore.
 	 * The release will print out buffers and wake up /dev/kmsg and syslog()
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
