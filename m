Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 591367D29
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2016 16:14:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0D083304039
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2016 14:14:20 -0700 (PDT)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com
	[74.125.82.66]) by cuda.sgi.com with ESMTP id 035KkpzS8nNeMkcp
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 27 Apr 2016 14:14:17 -0700 (PDT)
Received: by mail-wm0-f66.google.com with SMTP id n129so7523000wmn.1
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2016 14:14:17 -0700 (PDT)
Date: Wed, 27 Apr 2016 23:14:14 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 1.2/2] mm: introduce memalloc_nofs_{save,restore} API
Message-ID: <20160427211414.GA24919@dhcp22.suse.cz>
References: <1461671772-1269-2-git-send-email-mhocko@kernel.org>
	<1461758075-21815-1-git-send-email-mhocko@kernel.org>
	<1461758075-21815-2-git-send-email-mhocko@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1461758075-21815-2-git-send-email-mhocko@kernel.org>
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
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-ntfs-dev@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, logfs@logfs.org, cluster-devel@redhat.com, Chris Mason <clm@fb.com>, linux-mtd@lists.infradead.org, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com, ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-afs@lists.infradead.org

OK, so the lockdep splats I was seeing [1] were much easier to fix than
I originally thought. So the following should be folded into the
original patch. I will send the full patch later on.

[1] http://lkml.kernel.org/r/20160427200927.GC22544@dhcp22.suse.cz
---
>From 1968c0a8ace4090a9deca8f4c1a206ee546e595a Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.com>
Date: Wed, 27 Apr 2016 22:32:57 +0200
Subject: [PATCH] fold me "mm: introduce memalloc_nofs_{save,restore} API"

Lockdep infrastructure is hooked into early hot paths of the allocator
so __lockdep_trace_alloc has to check for PF_MEMALLOC_NOFS directly and
do not rely on current_gfp_context

Signed-off-by: Michal Hocko <mhocko@suse.com>

---
 kernel/locking/lockdep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 716547fdb873..f60124d0871c 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -2750,7 +2750,7 @@ static void __lockdep_trace_alloc(gfp_t gfp_mask, unsigned long flags)
 		return;
 
 	/* We're only interested __GFP_FS allocations for now */
-	if (!(gfp_mask & __GFP_FS))
+	if (!(gfp_mask & __GFP_FS) || (curr->flags & PF_MEMALLOC_NOFS))
 		return;
 
 	/*
-- 
2.8.0.rc3

-- 
Michal Hocko
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
