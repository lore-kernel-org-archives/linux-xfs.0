Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 762307CA3
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2016 15:30:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 457DB30404E
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2016 13:30:17 -0700 (PDT)
Received: from mail-pa0-f65.google.com (mail-pa0-f65.google.com
	[209.85.220.65]) by cuda.sgi.com with ESMTP id DM2o0OUrByy5wRJ4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 27 Apr 2016 13:30:15 -0700 (PDT)
Received: by mail-pa0-f65.google.com with SMTP id zy2so6974328pac.2
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2016 13:30:15 -0700 (PDT)
Date: Wed, 27 Apr 2016 22:30:10 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 1.2/2] mm: introduce memalloc_nofs_{save,restore} API
Message-ID: <20160427203010.GD22544@dhcp22.suse.cz>
References: <1461671772-1269-2-git-send-email-mhocko@kernel.org>
	<1461758075-21815-1-git-send-email-mhocko@kernel.org>
	<1461758075-21815-2-git-send-email-mhocko@kernel.org>
	<20160427200927.GC22544@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160427200927.GC22544@dhcp22.suse.cz>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Chris Mason <clm@fb.com>, linux-ntfs-dev@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, logfs@logfs.org, cluster-devel@redhat.com, linux-mm@kvack.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com, ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-afs@lists.infradead.org

On Wed 27-04-16 22:09:27, Michal Hocko wrote:
[...]
> [   53.993480]   [<ffffffff810945e3>] mark_held_locks+0x5e/0x74
> [   53.993480]   [<ffffffff8109722c>] lockdep_trace_alloc+0xb2/0xb5
> [   53.993480]   [<ffffffff81174e56>] kmem_cache_alloc+0x36/0x2b0

Scratch that. I got it. It is the lockdep annotation which I got wrong
with my patch. I thought this was done much later in the slow path.
My head is burnt so I will get back to it tomorrow. The patch 1.1 should
be OK to go for XFS though because it doesn't really introduce anything
new.

Sorry about the noise!
-- 
Michal Hocko
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
