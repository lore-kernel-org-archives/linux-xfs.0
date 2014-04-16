Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4974629DF7
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 23:19:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C808FAC001
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 21:19:31 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id iYfGcsgyrWUCBmz3 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 21:19:30 -0700 (PDT)
From: NeilBrown <neilb@suse.de>
Date: Wed, 16 Apr 2014 14:03:36 +1000
Subject: [PATCH 14/19] driver core: set PF_FSTRANS while holding gdp_mutex
Message-ID: <20140416040336.10604.223.stgit@notabene.brown>
In-Reply-To: <20140416033623.10604.69237.stgit@notabene.brown>
References: <20140416033623.10604.69237.stgit@notabene.brown>
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
To: linux-mm@kvack.org, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: xfs@oss.sgi.com

lockdep reports a locking chain:

  sk_lock-AF_INET --> rtnl_mutex --> gdp_mutex

As sk_lock can be needed for memory reclaim (when loop-back NFS is in
use at least), any memory allocation under gdp_mutex needs to
be protected by PF_FSTRANS.

The path frome rtnl_mutex to gdp_mutex is

    [<ffffffff81841ecc>] get_device_parent+0x4c/0x1f0
    [<ffffffff81842496>] device_add+0xe6/0x610
    [<ffffffff81ac5f2a>] netdev_register_kobject+0x7a/0x130
    [<ffffffff81aaf5d4>] register_netdevice+0x354/0x550
    [<ffffffff81aaf7e5>] register_netdev+0x15/0x30

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/base/core.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 2b567177ef78..1a2735237650 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -750,6 +750,7 @@ static struct kobject *get_device_parent(struct device *dev,
 		struct kobject *kobj = NULL;
 		struct kobject *parent_kobj;
 		struct kobject *k;
+		unsigned int pflags;
 
 #ifdef CONFIG_BLOCK
 		/* block disks show up in /sys/block */
@@ -788,7 +789,9 @@ static struct kobject *get_device_parent(struct device *dev,
 		}
 
 		/* or create a new class-directory at the parent device */
+		current_set_flags_nested(&pflags, PF_FSTRANS);
 		k = class_dir_create_and_add(dev->class, parent_kobj);
+		current_restore_flags_nested(&pflags, PF_FSTRANS);
 		/* do not emit an uevent for this simple "glue" directory */
 		mutex_unlock(&gdp_mutex);
 		return k;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
